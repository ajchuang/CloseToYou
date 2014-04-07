//
//  SofAViewController.m
//  VFinder
//
//  Created by Alfred Huang on 2014/2/5.
//  Copyright (c) 2014年 Alfred Huang. All rights reserved.
//

#import "SofAViewController.h"
#import "SofAMapViewController.h"
#import "SofAMainModel.h"

@interface SofAViewController ()

// @lfred: UI components
@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property (weak, nonatomic) IBOutlet UITextField *m_typeInput;
@property (weak, nonatomic) IBOutlet UISlider *m_radiusSlider;
@end

@implementation SofAViewController

- (IBAction)pressFindButton:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self trackLaunchInfo];
	// Do any additional setup after loading the view, typically from a nib.

    //self.searchInput.text = @"Your Venue Here";
    self.searchInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchInput.delegate = self;

    self.m_typeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.m_typeInput.delegate = self;
    
    // setup UI
//    self.title = @"CloseToYou";
    self.tabBarController.title = @"CloseToYou";
}

- (void) trackLaunchInfo {
    
    NSLog (@"trackLaunchInfo");
    
    // how many time
    int currentLaunches =
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"Launches"] intValue];
    
    if (currentLaunches == 0)
        currentLaunches++;
    
    // write back to the app defaults
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(currentLaunches) forKey:@"Launches"];
    [def synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// @lfred: to fix the keyboard enter.
- (BOOL)textFieldShouldReturn: (UITextField*) textField
{
    //NSLog (@"*** searchInput: %@", self.searchInput.text);
    //NSLog (@"*** m_typeInput: %@", self.m_typeInput.text);
    //NSLog (@"*** m_radiusInput: %@", self.m_radiusInput.text);
    
    if (textField == self.searchInput) {
        NSLog (@"*** searchInput: %@ ***", self.searchInput.text);
    } else if (textField == self.m_typeInput) {
        NSLog (@"*** m_typeInput: %@ ***", self.m_typeInput.text);
    }
    
    [textField resignFirstResponder];
    return YES;
}

// @lfred: Pass info to the NEXT view
- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    NSLog (@"prepareForSegue");
    SofAMapViewController *dest;
    dest = (SofAMapViewController*) segue.destinationViewController;
    
    NSLog (@"searchInput: %@", self.searchInput.text);
    NSLog (@"m_typeInput: %@", self.m_typeInput.text);
    NSLog (@"m_radiusSlider: %f", self.m_radiusSlider.value);
    
    // @lfred: assign the data to the model
    [[SofAMainModel getMainModel] setKeyword: [self.searchInput.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    [[SofAMainModel getMainModel] setSearchType: self.m_typeInput.text];
    [[SofAMainModel getMainModel] setRadius: self.m_radiusSlider.value];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog (@"viewWillDisappear");
}

@end
