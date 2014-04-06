//
//  SofAMapViewController.m
//  VFinder
//
//  Created by Alfred Huang on 2014/2/5.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import "SofAMapViewController.h"
#import "CoreLocation/CoreLocation.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SofAMainModel.h"
#import "SofAAnnotation.h"
#import "SofADetailViewController.h"
#import "SofAMyMapManager.h"


@interface SofAMapViewController ()

// @lfred: Control properties
@property (strong, nonatomic) CLLocationManager *m_locationMgr;
@property (nonatomic) BOOL m_isMapViewInit;

// @lfred: search properties
@property (strong, nonatomic) NSString* m_searchStr;
@property (strong, nonatomic) NSString* m_searchType;
@property (nonatomic) double m_radius;
@property (nonatomic) double m_currentLat;
@property (nonatomic) double m_currentLog;

// @lfred: UI properties
@property (weak, nonatomic) IBOutlet MKMapView *m_mapViewer;
@property (strong, nonatomic) UIAlertView* m_workingInProgress;
@property (strong, nonatomic) UIAlertView* m_abortingInProgress;

@end

static BOOL m_isCanceled = FALSE;

@implementation SofAMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) awakeFromNib {
    
    //self.m_locationMgr = [CLLocationManager new];
    //self.m_locationMgr.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // @lfred: setup the location manager
    NSLog (@"viewDidLoad");
    
    m_isCanceled = FALSE;
    self.m_isMapViewInit = NO;
    self.m_workingInProgress = nil;
    
    self.m_locationMgr = [CLLocationManager new];
    self.m_locationMgr.delegate = self;
    [self.m_locationMgr startUpdatingLocation];
    
    self.m_mapViewer.showsUserLocation = YES;
    self.m_mapViewer.delegate = self;
    
    // Initialize local data by using model
    self.m_searchStr    = [[SofAMainModel getMainModel] getKeyword];
    self.m_searchType   = [[SofAMainModel getMainModel] getSearchType];
    self.m_radius       = [[SofAMainModel getMainModel] getRadius];
    
    NSLog (@"!!! viewDidLoad:Keyword: %@ !!!", self.m_searchStr);
    NSLog (@"!!! viewDidLoad:searchWord: %@ !!!", self.m_searchType);
    NSLog (@"!!! viewDidLoad:radius: %1.2f !!!", self.m_radius);
}

// @lfred: stop updating locations after disappear.
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog (@"viewWillDisappear");
    [self.m_locationMgr stopUpdatingLocation];
    [self.m_locationMgr stopMonitoringSignificantLocationChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMyStuffWithCompletion: (void(^)(BOOL completed)) completionBlock
{
    NSLog (@"loadMyStuffWithCompletion");
    completionBlock (YES);
}

/*
 - (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
 [self.m_mapViewer setCenterCoordinate:userLocation.coordinate animated:YES];
 }
 */

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)viewParameters {
    NSLog (@"didSelectAnnotationView");
    return;
}

- (void)mapView:(MKMapView *)mapView annotationView: (MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog (@"mapView: annotationView: calloutAccessoryControlTapped");
    
    SofAAnnotation *pAnn = [view annotation];
    if (pAnn == nil)
        return;
    
    if ([pAnn getName] == nil)
        return;
    
    // @lfred: setup the selected item.
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    [pModel setDetailItem: pAnn];
    
    // @lfred: here we open the detail view
    UIViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"SofADetailViewID"];
    SofADetailViewController *pDetail = (SofADetailViewController*) homeView;
    pDetail.m_startFromMap = YES;
    [self.navigationController pushViewController:homeView animated: NO];
    
    
}

- (void)clickCallout: (id)sender{

    NSLog (@"clickCallout");
    
    // TODO: add the data to the bookmark
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    
    //NSLog (@"mapView is called");
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[SofAAnnotation class]] == NO)
        return nil;
    
    SofAAnnotation *pAnn = (SofAAnnotation*)annotation;
    
    if ([pAnn coordinate].latitude == self.m_currentLat &&
        [pAnn coordinate].longitude == self.m_currentLog)
        return nil;
    
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    newAnnotation.canShowCallout = YES;
    newAnnotation.animatesDrop = YES;
    
    // Add a detail disclosure button to the callout.
    UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(clickCallout:) forControlEvents:UIControlEventTouchUpInside];
    newAnnotation.rightCalloutAccessoryView = rightButton;
    
    return newAnnotation;
}

- (float) convertMetersToLatitude: (float)lat Longitude:(float)lg Distance:(int) dis {
    
    float unitMeter = 110 * 1000;
    return dis/unitMeter;
}

- (float) convertMetersToLongitude: (float) lat Longitude:(float)lg Distance:(int) dis {
    
    float unitMeter[10] = {110.0, 107.0, 100.0, 90.0, 78.0, 63.0, 46.0, 28.0, 10.0};
    
    int key = (int)(lat / 9.0);
    float unitDis = unitMeter[key] * 1000;
    
    return dis / unitDis;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    double longitude = [locations[0] coordinate].longitude;
    double latitude  = [locations[0] coordinate].latitude;
    self.m_currentLat = latitude;
    self.m_currentLog = longitude;
    
    // @lfred: stop update immediately.
    [self.m_locationMgr stopUpdatingLocation];
    [self.m_locationMgr startMonitoringSignificantLocationChanges];
    
    NSLog (@"Location Updated: %1.2f, %1.2f", longitude, latitude);
    
    // @lfred: config the current position
    if (self.m_isMapViewInit == NO)
    {
        NSLog (@"Updating user map");
        CLLocationCoordinate2D loc;
        loc.latitude = latitude;
        loc.longitude = longitude;
        
        MKCoordinateSpan span;
        
        float spanLat = [self convertMetersToLatitude:latitude Longitude:longitude Distance:self.m_radius] * 2;
        float spanLog = [self convertMetersToLongitude:latitude Longitude:longitude Distance:self.m_radius] * 2;
        NSLog (@"*** spanLat = %f, spanLog = %f ***", spanLat, spanLog);
        
        if (spanLat > spanLog)
            spanLog = spanLat;
        else
            spanLat = spanLog;
        
        span.latitudeDelta  = spanLat;
        span.longitudeDelta = spanLog;
        
        MKCoordinateRegion theRegion;
        theRegion.center = loc;
        theRegion.span = span;
        
        [self.m_mapViewer setRegion:theRegion];
        [self.m_mapViewer regionThatFits:theRegion];
        self.m_isMapViewInit = YES;
        
        // show something
        m_isCanceled = FALSE;
        self.m_workingInProgress =
            [[UIAlertView alloc] initWithTitle:@"Searching In Process"
                                       message:@"Press Cancel to go back."
                                      delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:nil];
        [self.m_workingInProgress show];
        
        // Setting up the google map manager
        [SofAMyMapManager nearestVenuesForLatLong:loc
                                     withinRadius:self.m_radius
                                         forQuery:self.m_searchStr
                                        queryType:self.m_searchType
                                 googleMapsAPIKey:[SofAMainModel getMyApiKey]
                                 searchCompletion:^(NSMutableArray *results) {
                                     
                                     if (m_isCanceled == TRUE) {
                                         
                                         m_isCanceled = FALSE;
                                         [self.m_abortingInProgress dismissWithClickedButtonIndex:0 animated:NO];
                                         [self.navigationController popViewControllerAnimated:NO];
                                         return;
                                     }
                                     
                                     // process data
                                     //NSLog (@"Total: %lu", [results count]);
                                     
                                     SofAMainModel *pModel = [SofAMainModel getMainModel];
                                     [pModel updateResults: results];
                                     
                                     for (int i=0; i<[results count]; ++i) {
                                         
                                         // @lfred: prepare data
                                         NSDictionary __strong *data = [[pModel getCurrentResults] objectAtIndex:i];
                                         NSNumber *lat = data[@"geometry"][@"location"][@"lat"];
                                         NSNumber *log = data[@"geometry"][@"location"][@"lng"];
                                         CLLocationCoordinate2D loc = {[lat doubleValue], [log doubleValue]};
                                         
                                         // @lfred: put a pin on the MAP
                                         //[self.m_mapViewer willChangeValueForKey: @"coordinate"];
                                         dispatch_async (dispatch_get_main_queue(), ^{
                                             SofAAnnotation *ann = [SofAAnnotation new];
                                             ann.coordinate = loc;
                                             
                                             NSDictionary *photoDict = [[data objectForKey:@"photos"] objectAtIndex:0];
                                             
                                             __strong NSString* pRef;
                                             
                                             if ([photoDict objectForKey:@"photo_reference"] != nil) {
                                                 pRef = [NSString stringWithString:[photoDict objectForKey:@"photo_reference"]];
                                             } else
                                                 pRef = nil;
                                             
                                             if (pRef != nil)
                                                 [ann setPhotoRef: pRef];
                                             
                                             [ann setId: data[@"id"]];
                                             [ann setName: data[@"name"]];
                                             [ann setVicinity: data[@"vicinity"]];
                                             [ann setReference: data[@"reference"]];
                                             [ann setIcon: data[@"icon"]];
                                             
                                             [ann setTitle: data[@"name"]];
                                             [ann setSubtitle: data[@"vicinity"]];
                                             [self.m_mapViewer addAnnotation:ann];
                                             
                                         });
                                         
                                         //[self.m_mapViewer didChangeValueForKey: @"coordinate"];
                                     }
                                     
                                     [self loadMyStuffWithCompletion: ^(BOOL completed) {
                                         
                                         NSLog (@"%d", completed);
                                         [self.m_workingInProgress dismissWithClickedButtonIndex:0 animated:true];
                                         
                                     }];
                                 }];
    }
}

#pragma mark - alertview delegate implementation
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog (@"Cancel Key is pressed");
        
        m_isCanceled = TRUE;
        
        self.m_abortingInProgress =
        [[UIAlertView alloc] initWithTitle:@"Aborting In Process"
                                   message:@"Please wait while cleaning..."
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:nil];
        [self.m_abortingInProgress show];


    }
}

@end
