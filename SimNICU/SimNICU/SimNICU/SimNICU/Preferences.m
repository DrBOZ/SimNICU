//
//  Preferences.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

// in order they were added to project for compatibility

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
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
        
        // set defaults
        if (!self.paperSize)
        {
            self.paperSize = @"A4";
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bilirubinUnits forKey:@"BilirubinUnits"];
    [aCoder encodeObject:self.guidelineCountry forKey:@"GuidelineCountry"];
    [aCoder encodeObject:self.ETTRoundUp forKey:@"ETTRoundUp"];
    [aCoder encodeObject:self.OIUnits forKey:@"OIUnits"];
    [aCoder encodeObject:self.ROPGestationScreeningThreshold forKey:@"ROPGestationScreeningThreshold"];
    [aCoder encodeObject:self.ROPBirthWeightScreeningThreshold forKey:@"ROPBirthWeightScreeningThreshold"];
    [aCoder encodeObject:self.defaultInfusionFluidVolumeMillilitres forKey:@"defaultInfusionFluidVolumeMillilitres"];
    [aCoder encodeObject:self.userKnowsHowToSwipeGestation forKey:@"userKnowsHowToSwipeGestation"];
    [aCoder encodeObject:self.userKnowsHowToSwipePatientList forKey:@"userKnowsHowToSwipePatientList"];
    [aCoder encodeObject:self.correctAgeForPrematurityUntilYears forKey:@"correctAgeForPrematurityUntilYears"];
    [aCoder encodeObject:self.paperSize forKey:@"paperSize"];
}

+ (id)sharedPreferences
{
    static Preferences *sharedPreferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPreferences = [[self alloc] initWithCoder:nil];
    });
    return sharedPreferences;
}

@end
