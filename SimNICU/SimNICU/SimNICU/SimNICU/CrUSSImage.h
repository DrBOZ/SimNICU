//
//  CrUSSImage.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrUSSImage : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *orientation;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *labelledImage;

@end
