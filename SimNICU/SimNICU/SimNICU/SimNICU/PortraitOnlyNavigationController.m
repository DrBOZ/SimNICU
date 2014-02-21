//
//  PortraitOnlyNavigationController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"

@interface PortraitOnlyNavigationController ()

@end

@implementation PortraitOnlyNavigationController

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

// Tell the system what we support
- (NSUInteger)supportedInterfaceOrientations
{
    // workaround
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.orientation = @"PreventRotation";
    
    return UIInterfaceOrientationMaskPortrait;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate
{
    return NO;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
