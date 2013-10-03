//
//  APGARVCFormats.h
//  SimNICU
//
//  Created by Conrad Bosman on 02/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APGARVCFormats : NSObject

+ (void)formatSegmentedControl:(UISegmentedControl *)segmentedControl;
+ (void)formatAPGARScoreText:(UILabel *)label;
+ (void)formatLabel:(UILabel *)label;

@end
