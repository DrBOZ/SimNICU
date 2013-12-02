//
//  VascularLine.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VascularLine : NSObject

// Line type
@property (nonatomic, strong) NSString *lineDescription;
@property (nonatomic, strong) NSString *lineSite;
@property (nonatomic, strong) NSDate *dateInserted;

+ (NSArray *)getLineDescriptions;
+ (NSArray *)getLineSites;

@end

#warning need to add decode methods