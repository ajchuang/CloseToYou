//
//  SofAListViewController.m
//  VFinder
//
//  Created by Alfred Huang on 3/14/14.
//  Copyright (c) 2014 Alfred Huang. All rights reserved.
//

#import "SofAListViewController.h"
#import "SofAMainModel.h"
#import "SofADetailViewController.h"

@interface SofAListViewController ()
@property (strong, nonatomic) NSMutableArray * m_sortedDataBank;
@end

@implementation SofAListViewController

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
    self.tabBarController.title = @"Search Result";
    self.m_sortedDataBank = [[NSMutableArray alloc] init];
    
    // get all results and translate into pAnn array
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    NSMutableArray *pRes = [pModel getCurrentResults];
    
    for (int i=0; i < [pRes count]; ++i) {
        NSDictionary *pDict = [pRes objectAtIndex: i];
        SofAAnnotation *pAnn = [SofAAnnotation new];
    
        NSDictionary *photoDict = [[pDict objectForKey:@"photos"] objectAtIndex:0];
    
        __strong NSString* pRef;
    
        if ([photoDict objectForKey:@"photo_reference"] != nil) {
            pRef = [NSString stringWithString:[photoDict objectForKey:@"photo_reference"]];
        } else
            pRef = nil;
    
        if (pRef != nil)
            [pAnn setPhotoRef: pRef];
    
        [pAnn setId: pDict[@"id"]];
        [pAnn setName: pDict[@"name"]];
        [pAnn setVicinity: pDict[@"vicinity"]];
        [pAnn setReference: pDict[@"reference"]];
        [pAnn setIcon: pDict[@"icon"]];
        [pAnn setTitle: pDict[@"name"]];
        [pAnn setSubtitle: pDict[@"vicinity"]];
        
        // get dist
        NSNumber *lat = pDict[@"geometry"][@"location"][@"lat"];
        NSNumber *log = pDict[@"geometry"][@"location"][@"lng"];
        CLLocationCoordinate2D myloc = {[lat doubleValue], [log doubleValue]};
        [pAnn setDist:[pModel getCurrentPos] my:myloc];
        
        [self.m_sortedDataBank addObject:pAnn];
    }
    
    NSArray *temp = [self.m_sortedDataBank sortedArrayUsingSelector:@selector(compare:)];
    self.m_sortedDataBank = [temp mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    return [[pModel getCurrentResults] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *pName = [self.m_sortedDataBank[indexPath.item] getName];
    
    //SofAMainModel *pModel = [SofAMainModel getMainModel];
    //NSMutableArray *pRes = [pModel getCurrentResults];
    //NSDictionary *pAnn = [pRes objectAtIndex: indexPath.item];
    //NSString *pName = pAnn[@"name"];
    cell.textLabel.text = pName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    SofAMainModel *pModel = [SofAMainModel getMainModel];
#if 0
    NSMutableArray *pRes = [pModel getCurrentResults];
    NSDictionary *pDict = [pRes objectAtIndex: indexPath.item];
    SofAAnnotation *pAnn = [SofAAnnotation new];
    
    NSDictionary *photoDict = [[pDict objectForKey:@"photos"] objectAtIndex:0];
    
    __strong NSString* pRef;
    
    if ([photoDict objectForKey:@"photo_reference"] != nil) {
        pRef = [NSString stringWithString:[photoDict objectForKey:@"photo_reference"]];
    } else
        pRef = nil;
    
    if (pRef != nil)
        [pAnn setPhotoRef: pRef];
    
    [pAnn setId: pDict[@"id"]];
    [pAnn setName: pDict[@"name"]];
    [pAnn setVicinity: pDict[@"vicinity"]];
    [pAnn setReference: pDict[@"reference"]];
    [pAnn setIcon: pDict[@"icon"]];
    [pAnn setTitle: pDict[@"name"]];
    [pAnn setSubtitle: pDict[@"vicinity"]];
#else
    SofAAnnotation *pAnn = self.m_sortedDataBank[indexPath.item];
#endif
    
    // @lfred: setup the selected item.
    [pModel setDetailItem: pAnn];
    
    // @lfred: here we open the detail view
    UIViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"SofADetailViewID"];
    SofADetailViewController *pDetail = (SofADetailViewController*) detailView;
    pDetail.m_startFromMap = YES;
    [self.navigationController pushViewController:detailView animated: NO];
}

@end
