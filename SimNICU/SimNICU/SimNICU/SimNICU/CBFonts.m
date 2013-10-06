//
//  CBFonts.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBFonts.h"

@implementation CBFonts

// Header / Footer fonts

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
