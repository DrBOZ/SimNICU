//
//  CustomText.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CustomText.h"

@implementation CustomText

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.customTextReferenceName = [aDecoder decodeObjectForKey:@"customTextReferenceName"];
        self.customText = [aDecoder decodeObjectForKey:@"customText"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.customTextReferenceName forKey:@"customTextReferenceName"];
    [aCoder encodeObject:self.customText forKey:@"customText"];
}

- (void)createCustomTextWithReferenceName:(NSString *)referenceName forText:(NSString *)text
{
    self.customTextReferenceName = referenceName;
    self.customText = text;
}

@end
