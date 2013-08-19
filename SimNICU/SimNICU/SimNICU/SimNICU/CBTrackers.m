//
//  CBTrackers.m
//  SimNICU
//
//  Created by Conrad Bosman on 19/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTrackers.h"

@implementation CBTrackers

+ (void)logEvent:(NSString *)event
{
    [self logEvent:event withParameters:nil timed:NO];
}

+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)parameters timed:(BOOL)timed
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:event withError:nil];
    
#endif
    
    [Flurry logEvent:event withParameters:parameters timed:timed];
}

+ (void)endTimedEvent:(NSString *)event withParameters:(NSDictionary *)parameters
{
    [Flurry endTimedEvent:event withParameters:parameters];
}

@end
