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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
    if (editing) {
        addButton.enabled = NO;
    } else {
        addButton.enabled = YES;
    }

}
*/

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
    
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    NSMutableArray *pRes = [pModel getCurrentResults];
    NSDictionary *pAnn = [pRes objectAtIndex: indexPath.item];
    NSString *pName = pAnn[@"name"];
    cell.textLabel.text = pName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SofAMainModel *pModel = [SofAMainModel getMainModel];
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
    
    // @lfred: setup the selected item.
    [pModel setDetailItem: pAnn];
    
    // @lfred: here we open the detail view
    UIViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"SofADetailViewID"];
    SofADetailViewController *pDetail = (SofADetailViewController*) detailView;
    pDetail.m_startFromMap = YES;
    [self.navigationController pushViewController:detailView animated: NO];
}

@end
