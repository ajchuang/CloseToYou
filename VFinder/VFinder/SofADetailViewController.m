//
//  SofADetailViewController.m
//  VFinder
//
//  Created by Alfred Huang on 2014/2/13.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import "SofADetailViewController.h"
#import "SofAMainModel.h"
#import "SofAAppDelegate.h"
#import "Bookmark.h"

@interface SofADetailViewController ()

@property (nonatomic, weak) NSString *m_name;
@property (nonatomic, weak) NSString *m_vicinity;
@property (nonatomic, weak) NSString *m_ref;
@property (nonatomic, weak) NSString *m_fotoRef;
@property (nonatomic, weak) NSString *m_iconRef;

@property (weak, nonatomic) IBOutlet UILabel *m_venueName;
@property (weak, nonatomic) IBOutlet UIImageView *m_venueImg;
@property (weak, nonatomic) IBOutlet UILabel *m_venueVicinity;
@property (weak, nonatomic) IBOutlet UILabel *m_pictureTitle;
@property (weak, nonatomic) IBOutlet UIButton *m_addToBm;

@end

@implementation SofADetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    
    if (self.m_startFromMap == NO) {
        self.m_addToBm.titleLabel.text = @"";
        self.m_addToBm.enabled = NO;
    }
    
    self.m_name = [pModel getHighlightedName];
    self.m_ref = [pModel getHighlightedRef];
    self.m_vicinity = [pModel getHighlightedVicinity];
    
    self.title = self.m_name;
    self.m_venueVicinity.text = self.m_vicinity;
    self.m_venueName.text = self.m_name;
    
    if ([pModel getHighlightedFotoRef] != nil) {
        self.m_fotoRef =
            [NSString stringWithFormat:
             @"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyANQ8spsA0-kt6Nj3LSNDQhaQi9rhXKwFk",
             [pModel getHighlightedFotoRef]];
        
        NSLog (@"%@", [pModel getHighlightedFotoRef]);
        NSLog (@"%@", self.m_fotoRef);
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.m_fotoRef]];
        self.m_venueImg.image = [UIImage imageWithData:imageData];
    } else {
        self.m_iconRef = [pModel getHighlightedIcon];
        NSData *imageData =
            [NSData dataWithContentsOfURL:
                [NSURL URLWithString: self.m_iconRef]];
        self.m_venueImg.image = [UIImage imageWithData:imageData];
        self.m_pictureTitle.text = @"Icon";
    }
    
    NSLog (@"SofADetailViewController::viewDidLoad");
}

- (IBAction)addToBookmark:(id)sender {
    
    NSLog (@"add to bookmark");
    
    // important local var
    SofAAppDelegate *app = (SofAAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    // check if the item exists
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName: @"Bookmark"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"m_name = %@", self.m_name];
    [fetch setPredicate:predicate];
    
    NSError *error = [NSError new];
    NSArray *results = [app.managedObjectContext executeFetchRequest:fetch error:&error];
    
    if (results) {
        if ([results count] > 0) {
            NSLog (@"Already existed.");
            return;
        }
    } else {
        NSLog(@"Error: %@", error);
        return;
    }

    // perform insertion
    Bookmark *bm =
        [NSEntityDescription
            insertNewObjectForEntityForName:@"Bookmark"
            inManagedObjectContext:app.managedObjectContext];

    if (bm != nil) {
        bm.m_name = self.m_name;
        bm.m_vicinity = self.m_vicinity;
        bm.m_image = self.m_fotoRef;
        bm.m_icon = self.m_iconRef;
        
        NSError *saveError = nil;
        
        if ([app.managedObjectContext save:&saveError] == YES) {
            NSLog(@"save new rocord successfully");
            
            UIAlertView* pAlertView =
                [[UIAlertView alloc] initWithTitle:@"Hooray!"
                                           message:@"Saving bookmark successfully"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
            [pAlertView show];
            self.m_addToBm.enabled = NO;
            
        } else {
            NSLog(@"save new rocord failed.");
            
            UIAlertView* pAlertView =
                [[UIAlertView alloc] initWithTitle:@"Oooops!"
                                           message:@"Saving bookmark failed"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
            [pAlertView show];
        }
    } else {
        NSLog(@"create object failed.");
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [[SofAMainModel getMainModel] clearCurrentViewInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - alertview delegate implementation
- (void) alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog (@"Cancel Key is pressed");
    }
}

@end
