//
//  APGARVCFormats.m
//  SimNICU
//
//  Created by Conrad Bosman on 02/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "APGARVCFormats.h"

@implementation APGARVCFormats

+ (void)formatSegmentedControl:(UISegmentedControl *)segmentedControl
{
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        segmentedControl.frame = CGRectMake(0.0f, 0.0f, 290.0f, 44.0f);
    }
    else
    {
        segmentedControl.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
    }
}

+ (void)formatAPGARScoreText:(UILabel *)label
{
    
}

+ (void)formatLabel:(UILabel *)label
{
    label.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.opaque = YES;
    label.font = [UIFont boldSystemFontOfSize:18.0f];
}

@end
