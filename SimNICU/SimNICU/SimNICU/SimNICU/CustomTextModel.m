//
//  CustomTextModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverSectionCustomText.h"
#import "CustomTextModel.h"
#import "HandoverSection.h"

@implementation CustomTextModel

+ (NSArray *)getArrayOfCustomTextForHandoverSection:(int)section;
{
    NSMutableArray *arrayOfCustomText = [[NSMutableArray alloc] initWithCapacity:5];
    
    // single object
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get the handover section to display custom text
    HandoverSection *handoverSection = preferences.handoverSections[section];
    
    HandoverSectionCustomText *customText;
    
    for (customText in handoverSection.customText)
    {
        [arrayOfCustomText addObject:customText];
    }
    
    return arrayOfCustomText;
}

@end
