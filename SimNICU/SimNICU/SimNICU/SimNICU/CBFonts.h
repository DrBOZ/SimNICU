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
+ (UILabel *)mainPickerHeadlineTextFormattingforLabel:(UILabel *)label;
+ (UILabel *)mainPickerSubheadlineDetailTextFormattingForLabel:(UILabel *)label;

+ (UILabel *)textFormattingForLabel:(UILabel *)label withTextStyle:(NSString *)textStyle minFontSize:(CGFloat)minFontSize;
+ (UILabel *)detailTextFormattingForLabel:(UILabel *)label withTextStyle:(NSString *)textStyle minFontSize:(CGFloat)minFontSize;


// Header / Footer formatting
+ (UILabel *)darkGrayOffsetShadowFormattingForLabel:(UILabel *)label;

// Colours
+ (UIColor *)specialGray;

@end

// should really refactor this to CBFormatting, or something