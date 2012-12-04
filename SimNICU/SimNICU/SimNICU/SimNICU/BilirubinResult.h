//
//  BilirubinResult.h
//  SimNICU
//
//  Created by Conrad Bosman on 16/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BilirubinResult : NSObject

@property (nonatomic, retain) NSNumber *sampleAgeInDays;
@property (nonatomic, retain) NSNumber *bilirubinResult;
@property (nonatomic, retain) NSString *bilirubinUnit;

@end
