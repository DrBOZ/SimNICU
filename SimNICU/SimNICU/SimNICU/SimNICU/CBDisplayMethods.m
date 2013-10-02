//
//  CBDisplayMethods.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBDisplayMethods.h"
#import "AppDelegate.h"

@implementation CBDisplayMethods

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
