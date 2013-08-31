//
//  InfoTabBarController.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "InstructionsViewController.h"
#import "AboutSimNICUViewController.h"
#import "AboutSimNICUViewController.h"
#import "DisclaimerViewController.h"
#import "InfoTabBarController.h"
#import "AppViewController.h"
#import "AppDelegate.h"
#import "ZUUIRevealController.h"

@interface InfoTabBarController ()

@end

@implementation InfoTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Information";
        
        AboutSimNICUViewController *firstViewController = [[AboutSimNICUViewController alloc] init];
        
        // delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UINavigationController *navController = (UINavigationController *)appDelegate.revealController.frontViewController;
        
        firstViewController.delegate = (AppViewController *)[navController topViewController];
        
        InstructionsViewController *secondViewController = [[InstructionsViewController alloc] init];
        DisclaimerViewController *fourthViewController = [[DisclaimerViewController alloc] init];
        
        firstViewController.tabBarItem.image = [UIImage imageNamed:@"about.png"];
        secondViewController.tabBarItem.image = [UIImage imageNamed:@"instructions.png"];
        fourthViewController.tabBarItem.image = [UIImage imageNamed:@"disclaimer.png"];
        
        self.viewControllers = @[firstViewController, fourthViewController];
        
        //back
		self.navigationItem.hidesBackButton = YES;
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(closeModal)];
		self.navigationItem.leftBarButtonItem = backButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    self.viewControllers = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"InfoTabBarController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"InfoTabBarController unloaded properties");
        
        // release...
    }
}

//close button
-(void)closeModal
{
	[[self navigationController] dismissModalViewControllerAnimated:YES];
}

@end
