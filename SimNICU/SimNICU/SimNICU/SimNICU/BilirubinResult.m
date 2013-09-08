//
//  BilirubinResult.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 16/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "BilirubinResult.h"

@implementation BilirubinResult

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.sampleAgeInDays = [aDecoder decodeObjectForKey:@"BilirubinSampleAge"];
        self.bilirubinResult = [aDecoder decodeObjectForKey:@"BilirubinResult"];
        self.bilirubinUnit = [aDecoder decodeObjectForKey:@"BilirubinUnit"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sampleAgeInDays forKey:@"BilirubinSampleAge"];
    [aCoder encodeObject:self.bilirubinResult forKey:@"BilirubinResult"];
    [aCoder encodeObject:self.bilirubinUnit forKey:@"BilirubinUnit"];
}

@end
