//
//  Bay.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 16/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "Bay.h"

@implementation Bay

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.bayName = [aDecoder decodeObjectForKey:@"BayName"];
        self.patientsInBay = [aDecoder decodeObjectForKey:@"PatientsInBay"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bayName forKey:@"BayName"];
    [aCoder encodeObject:self.patientsInBay forKey:@"PatientsInBay"];
}

@end
