//
//  HandoverSection.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverSection.h"

@implementation HandoverSection

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.sectionName = [aDecoder decodeObjectForKey:@"SectionName"];
        self.sectionEditable = [aDecoder decodeObjectForKey:@"SectionEditable"];
        self.rows = [aDecoder decodeObjectForKey:@"SectionRows"];
        
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sectionName forKey:@"SectionName"];
    [aCoder encodeObject:self.sectionEditable forKey:@"SectionEditable"];
    [aCoder encodeObject:self.rows forKey:@"SectionRows"];
}

@end
