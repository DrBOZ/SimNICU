//
//  HandoverSectionCustomText.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverSectionCustomText.h"

@implementation HandoverSectionCustomText

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.customTextReferenceName = [aDecoder decodeObjectForKey:@"customTextReferenceName"];
        self.customTextHeight = [aDecoder decodeObjectForKey:@"customTextHeight"];
        self.customText = [aDecoder decodeObjectForKey:@"customText"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.customTextReferenceName forKey:@"customTextReferenceName"];
    [aCoder encodeObject:self.customTextHeight forKey:@"customTextHeight"];
    [aCoder encodeObject:self.customText forKey:@"customText"];
}

@end
