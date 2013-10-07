//
//  CBFonts.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBFonts.h"

@implementation CBFonts

// TableViewCell label formatting

+ (UILabel *)textFormattingForLabel:(UILabel *)label withTextStyle:(NSString *)textStyle minFontSize:(CGFloat)minFontSize
{
    // black text
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        
#if USE_DYNAMIC_TEXT
        
        label.font = [UIFont preferredFontForTextStyle:textStyle];
        label.adjustsFontSizeToFitWidth = YES;
        
        // NSLog(@"label.font.xHeight = %f", label.font.xHeight);
        
        if (label.font.xHeight < (minFontSize / 2.0f))
        {
            label.font = [UIFont boldSystemFontOfSize:minFontSize];
            
            NSLog(@"Using minFontSize = %f", minFontSize);
        }
        
#else
        
        label.font = [UIFont boldSystemFontOfSize:17.0f];
        
#endif
        
    }
    else
    {
        // iOS 6 default
    }
    
    return label;
}

+ (UILabel *)detailTextFormattingForLabel:(UILabel *)label withTextStyle:(NSString *)textStyle minFontSize:(CGFloat)minFontSize
{
    // gray formatting
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        
#if USE_DYNAMIC_TEXT
        
        label.font = [UIFont preferredFontForTextStyle:textStyle];
        label.adjustsFontSizeToFitWidth = YES;
        
#else
        
        label.font = [UIFont systemFontOfSize:14.0f];
        
#endif
        
    }
    else
    {
        label.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return label;
}

+ (UILabel *)mainPickerHeadlineTextFormattingforLabel:(UILabel *)label;
{
    // black text
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    // boldSystemFontOfSize:18.0f minimum
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        
#if USE_DYNAMIC_TEXT
        
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        label.adjustsFontSizeToFitWidth = YES;
        
        // NSLog(@"label.font.xHeight = %f", label.font.xHeight);
        
        if (label.font.xHeight < 9.0f)
        {
            label.font = [UIFont boldSystemFontOfSize:18.0f];
        }
        
#else
        
        label.font = [UIFont boldSystemFontOfSize:17.0f];
        
#endif
        
    }
    else
    {
        // iOS 6 default
    }
    
    return label;
}

+ (UILabel *)mainPickerSubheadlineDetailTextFormattingForLabel:(UILabel *)label;
{
    
    return label;
}

// Header / Footer formatting

+ (UILabel *)darkGrayOffsetShadowFormattingForLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.shadowColor = [UIColor whiteColor];
    label.textColor = [self specialGray];
    label.numberOfLines = 0;
    
    return label;
}

// Special colours

+ (UIColor *)specialGray
{
    return [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
}

@end
