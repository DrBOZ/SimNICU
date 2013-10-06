//
//  CBTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"

@interface CBTableViewController ()

@property (nonatomic, strong) UIGestureRecognizer *swipeGestureRecognizer;

@end

@implementation CBTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // add TableView background
    // [CBTableViewController setBackgroundForTableView:self.tableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    // add TableView background
    [CBTableViewController setBackgroundForTableView:self.tableView];
    
    // deselect row
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // update TableView background
    [CBTableViewController updateBackgroundForTableView:self.tableView];
}

#pragma mark Class Methods

+ (void)setBackgroundForTableView:(UITableView *)myTableView
{
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // no images
    }
    else
    {
#if USE_DIMPLE_BACKGROUND
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // set background colour
        UIImageView *tempImageView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
            }
            else
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_LANDSCAPE_PNG]];
            }
        }
        else
        {
            // 3.5 inch Retina
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
            }
            else
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_LANDSCAPE_PNG]];
            }
        }
        
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
        
#else
        
        myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
#endif
    }
}

+ (void)updateBackgroundForTableView:(UITableView *)myTableView
{
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // no images
    }
    else
    {
#if USE_DIMPLE_BACKGROUND
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // set background colour
        UIImageView *tempImageView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
            }
            else
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_LANDSCAPE_PNG]];
            }
        }
        else
        {
            // 3.5 inch Retina
            if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
            }
            else
            {
                tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_LANDSCAPE_PNG]];
            }
        }
        
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
        
#else
        
        myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
#endif
    }
}

+ (void)setSecondaryBackgroundForTableView:(UITableView *)myTableView
{
    
#if USE_DIMPLE_BACKGROUND
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
    }
    else
    {
        // 3.5 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
    }
    
#else
    
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
#endif
}

@end
