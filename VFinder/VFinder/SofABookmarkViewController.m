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
@property (nonatomic, strong) NSMutableArray *m_bmArray;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;
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
}

- (void) viewDidAppear:(BOOL)animated {
    
    self.tabBarController.title = @"CloseToYou";
    
    // load data here to prevent change in the middle
    [self readCoreData];
    [self.m_tableView reloadData];
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
        [(NSArray*)[app.managedObjectContext
                        executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if ([self.m_bmArray count] == 0) {
        
        UIAlertView *pAlert =
            [[UIAlertView alloc] initWithTitle:@"No bookmark"
                                       message:@"Going back to the search screen"
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
        [pAlert show];

        
        // nothing in the bookmark - switch back to search view
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    }
    
    // debugging
    for (Bookmark *bm in self.m_bmArray) {
        NSLog (@"name %@", bm.m_name);
    }
}

#pragma mark - table view functions
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.m_bmArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView: (UITableView*) tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    // local variables
    NSError *saveError = nil;
    NSLog (@"deleting function");
    
    // also delete the data in the Core Data
    SofAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject: self.m_bmArray [indexPath.row]];
    
    if ([context save:&saveError] == YES) {
        NSLog (@"Saved to SQLite successfully");
    } else {
        NSLog (@"Saved to SQLite FAILED");
    }
    
    // Remove the row from data model
    [self.m_bmArray removeObjectAtIndex:indexPath.row];
    
    if ([self.m_bmArray count] == 0) {
        UIAlertView *pAlert =
        [[UIAlertView alloc] initWithTitle:@"No bookmark"
                                   message:@"Going back to the search screen"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [pAlert show];
        
        
        // nothing in the bookmark - switch back to search view
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        return;
    }
    
    // Request table view to reload
    [tableView reloadData];
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
