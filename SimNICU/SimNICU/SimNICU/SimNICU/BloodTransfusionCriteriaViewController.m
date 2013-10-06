//
//  BloodTransfusionCriteriaViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 15/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "BloodTransfusionCriteriaViewController.h"
#import "BloodTransfusionCriteriaModel.h"

@interface BloodTransfusionCriteriaViewController ()

@end

@implementation BloodTransfusionCriteriaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Blood Products/Blood Transfusion" withParameters:nil timed:YES];
    
    self.title = @"Blood Transfusion";
    
    self.webViewSections = [BloodTransfusionCriteriaModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"BloodTransfusionCriteriaViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"BloodTransfusionCriteriaViewController unloaded properties");
        
        self.tableView = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [Flurry endTimedEvent:@"Blood Products/Blood Transfusion" withParameters:nil];
}

@end
