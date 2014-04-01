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
    SofAAnnotation *pAnn = [pRes objectAtIndex: indexPath.item];
    
    // @lfred: setup the selected item.
    [pModel setDetailItem: pAnn];
    
    // @lfred: here we open the detail view
    UIViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"SofADetailViewID"];
    SofADetailViewController *pDetail = (SofADetailViewController*) detailView;
    pDetail.m_startFromMap = YES;
    [self.navigationController pushViewController:detailView animated: NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
