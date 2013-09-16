//
//  Preferences.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "HandoverSection.h"
#import "Preferences.h"
#import "HandoverRow.h"

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

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setDefaults];
    }
    
    return self;
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
        self.handoverSections = [aDecoder decodeObjectForKey:@"handoverSections"];
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
    [aCoder encodeObject:self.handoverSections
                  forKey:@"handoverSections"];
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
    
    // default trackball
    if (!self.trackball)
    {
        self.trackball = [NSNumber numberWithInt:1];
    }
    
    if (!self.handoverSections)
    {
        // create array - note this is similar but difference to the patient handover Sections
        // which includes individual patient rowHeight data for information contained in the sections
        
        self.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        
        // 00 - Background
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Background";
        
        [self.handoverSections addObject:newSection];
        
        // 01 - Active Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Active Problems";
        
        [self.handoverSections addObject:newSection];
        
        // 02 - Resolved Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Resolved Problems";
        
        [self.handoverSections addObject:newSection];
        
        // 03 - Recent Significant Events
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Recent Significant Events";
        
        [self.handoverSections addObject:newSection];
        
        // 04 - Ventilation & Sedation
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Ventilation & Sedation";
        
        [self.handoverSections addObject:newSection];
        
        // 05 - CXR
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"CXR";
        
        [self.handoverSections addObject:newSection];
        
        // 06 - Cardiovascular
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Cardiovascular";
        
        [self.handoverSections addObject:newSection];
        
        // 07 - Lines
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Lines";
        
        [self.handoverSections addObject:newSection];
        
        // 08 - Feeds & Fluids
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Feeds & Fluids";
        
        [self.handoverSections addObject:newSection];
        
        // 09 - Fluid Balance
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Fluid Balance";
        
        [self.handoverSections addObject:newSection];
        
        // 10 - Biochemistry
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Biochemistry";
        
        [self.handoverSections addObject:newSection];
        
        // 11 - Jaundice
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Jaundice";
        
        [self.handoverSections addObject:newSection];
        
        // 12 - Sepsis
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Sepsis";
        
        [self.handoverSections addObject:newSection];
        
        // 13 - Drugs
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Drugs";
        
        [self.handoverSections addObject:newSection];
        
        // 14 - ROP
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"ROP";
        
        [self.handoverSections addObject:newSection];
        
        // 15 - Neurology & Cranial USS
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Neurology & Cranial USS";
        
        [self.handoverSections addObject:newSection];
        
        // 16 - Parents / Social
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Parents / Social";
        
        [self.handoverSections addObject:newSection];
        
        // 17 - Examination
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Examination";
        
        [self.handoverSections addObject:newSection];
        
        // 18 - Summary
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Summary";
        
        [self.handoverSections addObject:newSection];
        
        // 19 - Plan
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Plan";
        
        [self.handoverSections addObject:newSection];
    }
}

@end
