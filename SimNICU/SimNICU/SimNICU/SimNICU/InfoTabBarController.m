//
//  InfoTabBarController.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "AcknowledgementsViewController.h"
#import "InstructionsViewController.h"
#import "AboutSimNICUViewController.h"
#import "AboutSimNICUViewController2.h"
#import "DisclaimerViewController.h"
#import "TwitterViewController.h"
#import "InfoTabBarController.h"
#import "AppDelegate.h"

@interface InfoTabBarController ()

@end

@implementation InfoTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Information";
        
        AboutSimNICUViewController2 *firstViewController = [[AboutSimNICUViewController2 alloc] init];
        InstructionsViewController *secondViewController = [[InstructionsViewController alloc] init];
        TwitterViewController *thirdViewController = [[TwitterViewController alloc] init];
        DisclaimerViewController *fourthViewController = [[DisclaimerViewController alloc] init];
        // AcknowledgementsViewController *fourthViewController = [[AcknowledgementsViewController alloc] init];
        
        firstViewController.tabBarItem.image = [UIImage imageNamed:@"about.png"];
        secondViewController.tabBarItem.image = [UIImage imageNamed:@"instructions.png"];
        thirdViewController.tabBarItem.image = [UIImage imageNamed:@"twitter.png"];
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
