//
//  CBTrackers.h
//  SimNICU
//
//  Created by Conrad Bosman on 19/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTrackers : NSObject

+ (void)logEvent:(NSString *)event;

+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)parameters timed:(BOOL)timed;

+ (void)endTimedEvent:(NSString *)event withParameters:(NSDictionary *)parameters;

@end
