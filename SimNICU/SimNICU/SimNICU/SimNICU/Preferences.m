//
//  Preferences.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // if((self = [super init]))
    //
    // above used before class was made into a singleton
    
    if((self = [Preferences sharedPreferences]))
    {
        self.bilirubinUnits = [aDecoder decodeObjectForKey:@"BilirubinUnits"];
        self.guidelineCountry = [aDecoder decodeObjectForKey:@"GuidelineCountry"];
        self.ETTRoundUp = [aDecoder decodeObjectForKey:@"ETTRoundUp"];
        self.OIUnits = [aDecoder decodeObjectForKey:@"OIUnits"];
        self.ROPGestationScreeningThreshold = [aDecoder decodeObjectForKey:@"ROPGestationScreeningThreshold"];
        self.ROPBirthWeightScreeningThreshold = [aDecoder decodeObjectForKey:@"ROPBirthWeightScreeningThreshold"];
        self.defaultInfusionFluidVolumeMillilitres = [aDecoder decodeObjectForKey:@"defaultInfusionFluidVolumeMillilitres"];
        self.userKnowsHowToSwipeGestation = [aDecoder decodeObjectForKey:@"userKnowsHowToSwipeGestation"];
        self.userKnowsHowToSwipePatientList = [aDecoder decodeObjectForKey:@"userKnowsHowToSwipePatientList"];
        self.correctAgeForPrematurityUntilYears = [aDecoder decodeObjectForKey:@"correctAgeForPrematurityUntilYears"];
        self.paperSize = [aDecoder decodeObjectForKey:@"paperSize"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.border = [aDecoder decodeObjectForKey:@"border"];
        
        // find user's current locale
        NSString *currentLocale = [[NSLocale currentLocale] localeIdentifier];
        self.locale = currentLocale;
        
        // set default paper size
        if (!self.paperSize)
        {
            if ([currentLocale isEqualToString:@"en_GB"])
            {
                self.paperSize = @"A4";
            }
            else
            {
                self.paperSize = @"Letter";
            }
        }
        
        if (!self.border)
        {
            self.border = [NSNumber numberWithInt:1];
        }
        
        // set default correction age
        if (!self.correctAgeForPrematurityUntilYears)
        {
            self.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:2];
        }
        
        // set phototherapy defaults
        if (!self.guidelineCountry)
        {
            if ([currentLocale isEqualToString:@"en_GB"])
            {
                self.guidelineCountry = @"UK";
                self.bilirubinUnits = @"SI";
            }
            else if ([currentLocale isEqualToString:@"en_US"])
            {
                self.guidelineCountry = @"US";
                self.bilirubinUnits = @"US";
            }
            else
            {
                self.guidelineCountry = @"US";
                self.bilirubinUnits = @"US";
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bilirubinUnits
                  forKey:@"BilirubinUnits"];
    [aCoder encodeObject:self.guidelineCountry
                  forKey:@"GuidelineCountry"];
    [aCoder encodeObject:self.ETTRoundUp
                  forKey:@"ETTRoundUp"];
    [aCoder encodeObject:self.OIUnits
                  forKey:@"OIUnits"];
    [aCoder encodeObject:self.ROPGestationScreeningThreshold
                  forKey:@"ROPGestationScreeningThreshold"];
    [aCoder encodeObject:self.ROPBirthWeightScreeningThreshold
                  forKey:@"ROPBirthWeightScreeningThreshold"];
    [aCoder encodeObject:self.defaultInfusionFluidVolumeMillilitres
                  forKey:@"defaultInfusionFluidVolumeMillilitres"];
    [aCoder encodeObject:self.userKnowsHowToSwipeGestation
                  forKey:@"userKnowsHowToSwipeGestation"];
    [aCoder encodeObject:self.userKnowsHowToSwipePatientList
                  forKey:@"userKnowsHowToSwipePatientList"];
    [aCoder encodeObject:self.correctAgeForPrematurityUntilYears
                  forKey:@"correctAgeForPrematurityUntilYears"];
    [aCoder encodeObject:self.paperSize
                  forKey:@"paperSize"];
    [aCoder encodeObject:self.signature
                  forKey:@"signature"];
    [aCoder encodeObject:self.border
                  forKey:@"border"];
}

// Singleton method
+ (Preferences *)sharedPreferences
{
    static Preferences *sharedPreferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPreferences = [[self alloc] init];
    });
    return sharedPreferences;
}

@end
