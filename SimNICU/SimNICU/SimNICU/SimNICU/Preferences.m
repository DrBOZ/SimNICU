//
//  Preferences.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

// Class Singleton method
+ (Preferences *)sharedPreferences
{
    static Preferences *sharedPreferences = nil;
    static dispatch_once_t onceToken;            // uses Grand Central Dispatch, ie threadsafe
    dispatch_once(&onceToken, ^{
        sharedPreferences = [[self alloc] init];
    });
    return sharedPreferences;
}

// Instance methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
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
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.autocorrection = [aDecoder decodeObjectForKey:@"autocorrection"];
        self.trackball = [aDecoder decodeObjectForKey:@"trackball"];
    }
    
    [self setDefaults];

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
    [aCoder encodeObject:self.image
                  forKey:@"image"];
    [aCoder encodeObject:self.autocorrection
                  forKey:@"autocorrection"];
    [aCoder encodeObject:self.trackball
                  forKey:@"trackball"];
}

- (void)setDefaults
{
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
    
    // default logo
    if (!self.image)
    {
        self.image = [UIImage imageNamed:@"sherwood-forest-hospitals-logo.jpg"];
    }
    
    // default trackball
    if (!self.trackball)
    {
        self.trackball = [NSNumber numberWithInt:1];
    }
}

@end
