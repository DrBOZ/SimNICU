//
//  CBFonts.h
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBFonts : NSObject

// TableViewCell label formatting

+ (UILabel *)textFormattingForLabel:(UILabel *)label;
+ (UILabel *)detailTextFormattingForLabel:(UILabel *)label;

// Header / Footer formatting

+ (UILabel *)darkGrayOffsetShadowFormattingForLabel:(UILabel *)label;

// Colours
+ (UIColor *)specialGray;

@end

// should really refactor this to CBFormatting, or something