//
//  CustomText.h
//  SimNICU
//
//  Created by Conrad Bosman on 11/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomText : NSObject

// @property (nonatomic, strong) NSNumber *customTextHeightLandscape;
@property (nonatomic, strong) NSString *customTextReferenceName;
// @property (nonatomic, strong) NSNumber *customTextHeight;
@property (nonatomic, strong) NSString *customText;

- (void)createCustomTextWithReferenceName:(NSString *)referenceName forText:(NSString *)text;

@end
