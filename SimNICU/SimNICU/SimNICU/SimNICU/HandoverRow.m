//
//  HandoverRow.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverRow.h"

@implementation HandoverRow

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.rowHeight = [aDecoder decodeObjectForKey:@"RowHeight"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rowHeight forKey:@"RowHeight"];
}

@end
