//
//  SofABookmarkViewController.m
//  VFinder
//
//  Created by Alfred Huang on 3/14/14.
//  Copyright (c) 2014 Alfred Huang. All rights reserved.
//

#import "SofABookmarkViewController.h"
#import "SofAAppDelegate.h"
#import "Bookmark.h"
#import "SofAMainModel.h"
#import "SofADetailViewController.h"

@interface SofABookmarkViewController ()
@property (nonatomic) long m_entCount;
@property (nonatomic, strong) NSArray *m_bmArray;

@end

@implementation SofABookmarkViewController

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
    NSLog (@"viewDidLoad");
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"Bookmark";
    [self readCoreData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) readCoreData {
    
    NSLog (@"readCoreData");
    
    SofAAppDelegate *app = (SofAAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity =
        [NSEntityDescription
            entityForName:@"Bookmark"
            inManagedObjectContext:app.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.m_bmArray =
        [app.managedObjectContext
            executeFetchRequest:fetchRequest error:&error];
    self.m_entCount = self.m_bmArray.count;
    
    for (Bookmark *bm in self.m_bmArray) {
        NSLog(@"name %@", bm.m_name);
    }
}

#pragma mark - table view functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_entCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Bookmark *pBm = self.m_bmArray[indexPath.item];
    cell.textLabel.text = pBm.m_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Bookmark *pBm = self.m_bmArray[indexPath.item];
    
    // @lfred: setup the selected item.
    SofAMainModel *pModel = [SofAMainModel getMainModel];
    [pModel setDetailItemByBM: pBm];
    
    // @lfred: here we open the detail view
    UIViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"SofADetailViewID"];
    SofADetailViewController *pDetail = (SofADetailViewController*) detailView;
    pDetail.m_startFromMap = NO;
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
