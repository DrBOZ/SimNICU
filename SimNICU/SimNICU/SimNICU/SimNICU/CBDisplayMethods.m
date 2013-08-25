//
//  CBDisplayMethods.m
//  SimNICU
//
//  Created by Conrad Bosman on 23/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBDisplayMethods.h"
#import "AppDelegate.h"

@implementation CBDisplayMethods

+ (void)setBackgroundForTableView:(UITableView *)myTableView
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
#if USE_DIMPLE_BACKGROUND
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
    }
    else
    {
        // 3.5 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
        [tempImageView setFrame:myTableView.frame];
        
        myTableView.backgroundView = tempImageView;
    }
    
#else
    
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
#endif
}

+ (void)setSecondaryBackgroundForTableView:(UITableView *)myTableView
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
#if USE_DIMPLE_BACKGROUND
    
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
