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
#import "CustomText.h"

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
        self.dynamicText = [aDecoder decodeObjectForKey:@"dynamicText"];
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
    [aCoder encodeObject:self.dynamicText
                  forKey:@"dynamicText"];
    [aCoder encodeObject:self.handoverSections
                  forKey:@"handoverSections"];
}

- (CustomText *)customText:(NSString *)text ref:(NSString *)referenceText
{
    CustomText *customText = [CustomText new];
    
    [customText createCustomTextWithReferenceName:referenceText
                                          forText:text];
    
    return customText;
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
    
    // default dynamic text
    if (!self.dynamicText)
    {
        self.dynamicText = [NSNumber numberWithInt:0];
    }
    
#if RESET_PREFERENCES_HANDOVER_SECTIONS
    
    self.HandoverSections = nil;
    
#endif
    
    if (!self.handoverSections)
    {
        // create array - note this is similar but difference to the patient handover Sections
        // which includes individual patient rowHeight data for information contained in the sections
        
        self.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        
#pragma mark Background
        // 00 - Background
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Background";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Transfer from 
            [newSection.customText addObject:[self customText:@"Transfer from " ref:@"Transfer from"]];
            
            // Spontaneous preterm labour
            [newSection.customText addObject:[self customText:@"Spontaneous preterm labour" ref:@"Spontaneous preterm labour"]];
            
            // Maternal antepartum haemorrhage
            [newSection.customText addObject:[self customText:@"Maternal APH" ref:@"Maternal APH"]];
            
            // Em LSCS
            [newSection.customText addObject:[self customText:@"Em LSCS" ref:@"Em LSCS"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Active Problems
        // 01 - Active Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Active Problems";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Resolved Problems
        // 02 - Resolved Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Resolved Problems";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Recent Significant Events
        // 03 - Recent Significant Events
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Recent Significant Events";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Ventilation & Sedation
        // 04 - Ventilation & Sedation
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Ventilation & Sedation";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Breathing in air
            [newSection.customText addObject:[self customText:@"Breathing in air" ref:@"Breathing in air"]];
            
            // No events
            [newSection.customText addObject:[self customText:@"No events" ref:@"No events"]];
            
            // pH
            [newSection.customText addObject:[self customText:@"pH " ref:@"pH"]];
            
            // PCO2
            [newSection.customText addObject:[self customText:@" PCO2 " ref:@"PCO2"]];
            
            // PO2
            [newSection.customText addObject:[self customText:@" PO2 " ref:@"PO2"]];
            
            // SB
            [newSection.customText addObject:[self customText:@" SB " ref:@"SB"]];
            
            // BE
            [newSection.customText addObject:[self customText:@" BE " ref:@"BE"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark CXR
        // 05 - CXR
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"CXR";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Ground glass appearances
            [newSection.customText addObject:[self customText:@"Ground glass appearances" ref:@"Ground glass appearances"]];
            
            // Fluid in the horizontal fissure
            [newSection.customText addObject:[self customText:@"Fluid in the horizontal fissure" ref:@"Fluid in the horizontal fissure"]];
            
            // No pneumothorax
            [newSection.customText addObject:[self customText:@"No obvious pneumothorax" ref:@"No obvious pneumothorax"]];
            
            // Nasogastric tube in the stomach
            [newSection.customText addObject:[self customText:@"Nasogastric tube in the stomach" ref:@"Nasogastric tube in the stomach"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Cardiovascular
        // 06 - Cardiovascular
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Cardiovascular";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Hb
            [newSection.customText addObject:[self customText:@"Hb " ref:@"Hb"]];
            
            // WCC
            [newSection.customText addObject:[self customText:@" WCC " ref:@"WCC"]];
            
            // Plats
            [newSection.customText addObject:[self customText:@" Plats " ref:@"Plats"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
            
            // micrograms/kg/min
            [newSection.customText addObject:[self customText:@" micrograms/kg/min" ref:@"micrograms/kg/min"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Lines
        // 07 - Lines
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Lines";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // 24G
            [newSection.customText addObject:[self customText:@"24G " ref:@"24G"]];
            
            // dorsum
            [newSection.customText addObject:[self customText:@"dorsum " ref:@"dorsum"]];
            
            // left
            [newSection.customText addObject:[self customText:@"left " ref:@"left"]];
            
            // right
            [newSection.customText addObject:[self customText:@"right " ref:@"right"]];
            
            // hand
            [newSection.customText addObject:[self customText:@"hand" ref:@"hand"]];
            
            // foot
            [newSection.customText addObject:[self customText:@"foot " ref:@"foot"]];
            
            // antecubital fossa
            [newSection.customText addObject:[self customText:@"antecubital fossa " ref:@"antecubital fossa"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Feeds & Fluids
        // 08 - Feeds & Fluids
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Feeds & Fluids";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:5];
            
            // ml/kg/day
            [newSection.customText addObject:[self customText:@"ml/kg/day" ref:@"ml/kg/day"]];
            
            // Parenteral nutrition
            [newSection.customText addObject:[self customText:@"Standard preterm PN" ref:@"Standard preterm PN"]];
            
            // Yellow regime
            [newSection.customText addObject:[self customText:@"Yellow regime" ref:@"Yellow regime"]];
            
            // Green regime
            [newSection.customText addObject:[self customText:@"Green regime" ref:@"Green regime"]];
            
            // Fully enterally fed
            [newSection.customText addObject:[self customText:@"Fully enterally fed" ref:@"Fully enterally fed"]];
            
            // Minimal milky aspirates
            [newSection.customText addObject:[self customText:@"Minimal milky aspirates" ref:@"Minimal milky aspirates"]];
            
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Fluid Balance
        // 09 - Fluid Balance
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Fluid Balance";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // ml/kg
            [newSection.customText addObject:[self customText:@" ml/kg" ref:@"ml/kg"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Biochemistry
        // 10 - Biochemistry
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Biochemistry";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Na
            [newSection.customText addObject:[self customText:@"Na " ref:@"Na"]];
            
            // K
            [newSection.customText addObject:[self customText:@" K " ref:@"K"]];
            
            // U
            [newSection.customText addObject:[self customText:@" U " ref:@"U"]];
            
            // Cr
            [newSection.customText addObject:[self customText:@" Cr " ref:@"Cr"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
            
            // current date and time
            [newSection.customText addObject:[self customText:@"[current date and time]"
                                                          ref:@"[current date and time]"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Jaundice
        // 11 - Jaundice
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Jaundice";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Sepsis
        // 12 - Sepsis
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Sepsis";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // CRP
            [newSection.customText addObject:[self customText:@"CRP " ref:@"CRP"]];
            
            // < 5
            [newSection.customText addObject:[self customText:@"< 5" ref:@"< 5"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Drugs
        // 13 - Drugs
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Drugs";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Benzylpenicillin
            [newSection.customText addObject:[self customText:@"Benzylpenicillin" ref:@"Benzylpenicillin"]];
        
            // Gentamicin
            [newSection.customText addObject:[self customText:@"Gentamicin" ref:@"Gentamicin"]];
            
            // Caffeine
            [newSection.customText addObject:[self customText:@"Caffeine" ref:@"Caffeine"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Retinopathy of Prematurity
        // 14 - ROP
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Retinopathy of prematurity";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Screening not indicated
            [newSection.customText addObject:[self customText:@"Screening not indicated" ref:@"Screening not indicated"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Neurology & Cranial USS
        // 15 - Neurology & Cranial USS
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Neurology & Cranial USS";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Parents / Social
        // 16 - Parents / Social
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Parents / Social";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // No concerns
            [newSection.customText addObject:[self customText:@"No concerns" ref:@"No concerns"]];
        
            [self.handoverSections addObject:newSection];
        } 
        
#pragma mark Examination
         // 17 - Examination
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Examination";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // Normal examination
            [newSection.customText addObject:[self customText:@"Pink\nActive\nHR 140\nHeart sounds normal\nNo murmurs\nFemorals bilaterally palpable\nRR 40\nSaO2 97% in air\nNo recession\nAbdomen soft and non-tender\nNo distension or discoloration"
                                                          ref:@"Normal examination"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Summary
        // 18 - Summary
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Summary";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Plan
        // 19 - Plan
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Plan";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
        
            [self.handoverSections addObject:newSection];
        }
    }
}

@end
