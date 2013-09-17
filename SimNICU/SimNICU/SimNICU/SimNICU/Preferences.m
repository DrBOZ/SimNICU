//
//  Preferences.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "HandoverSectionCustomText.h"
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
    
#if RESET_PREFERENCES_HANDOVER_SECTIONS
    
    self.HandoverSections = nil;
    
#endif
    
    if (!self.handoverSections)
    {
        // create array - note this is similar but difference to the patient handover Sections
        // which includes individual patient rowHeight data for information contained in the sections
        
        self.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        HandoverSectionCustomText *customText;
        
        /*
        newSection.customText = [[NSMutableArray alloc] initWithCapacity:2]; 
         
        // custom text template
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"";
            customText.customText = @"";
            
            [newSection.customText addObject:customText];
        }
         */
        
        // 00 - Background
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Background";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Spontaneous preterm labour
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Spontaneous preterm labour";
                customText.customText = @"Spontaneous preterm labour";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal gestational diabetes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal gestational diabetes";
                customText.customText = @"Maternal gestational diabetes";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal insulin dependant diabetes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal insulin dependant diabetes";
                customText.customText = @"Maternal insulin dependant diabetes";
                
                [newSection.customText addObject:customText];
            }
            
            // Prolonged rupture of membranes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Prolonged rupture of membranes";
                customText.customText = @"Prolonged rupture of membranes";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
        // 01 - Active Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Active Problems";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Prematurity
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Prematurity";
                customText.customText = @"Prematurity";
                
                [newSection.customText addObject:customText];
            }
            
            // Respiratory distress syndrome
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Respiratory distress syndrome";
                customText.customText = @"Respiratory distress syndrome";
                
                [newSection.customText addObject:customText];
            }
            
            // Surfactant deficient lung disease
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Surfactant deficient lung disease";
                customText.customText = @"Surfactant deficient lung disease";
                
                [newSection.customText addObject:customText];
            }
            
            // Breech delivery
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Breech delivery";
                customText.customText = @"Breech delivery";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
        // 02 - Resolved Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Resolved Problems";
        
            [self.handoverSections addObject:newSection];
        }
        
        // 03 - Recent Significant Events
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Recent Significant Events";
        
            [self.handoverSections addObject:newSection];
        }
        
        // 04 - Ventilation & Sedation
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Ventilation & Sedation";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Breathing in air
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Breathing in air";
                customText.customText = @"Breathing in air";
                
                [newSection.customText addObject:customText];
            }
            
            // Breathing in _ L/min n/c oxygen
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Breathing in _ L/min n/c oxygen";
                customText.customText = @"Breathing in _ L/min nasal cannulae oxygen";
                
                [newSection.customText addObject:customText];
            }
            
            // Breathing in _ % headbox oxygen
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Breathing in _ % headbox oxygen";
                customText.customText = @"Breathing in _ % headbox oxygen";
                
                [newSection.customText addObject:customText];
            }
            
            // No events
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No events";
                customText.customText = @"No events";
                
                [newSection.customText addObject:customText];
            }
            
            // Detailed respiratory exam
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Detailed respiratory exam";
                customText.customText = @"";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
        // 05 - CXR
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"CXR";
        
            [self.handoverSections addObject:newSection];
        }
        
        // 06 - Cardiovascular
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Cardiovascular";
        
            [self.handoverSections addObject:newSection];
        }
            
        // 07 - Lines
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Lines";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // No lines
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No intravenous lines";
                customText.customText = @"No intravenous lines";
                
                [newSection.customText addObject:customText];
            }
            
            // 24G
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"24G";
                customText.customText = @"24G ";
                
                [newSection.customText addObject:customText];
            }
            
            // dorsum
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"dorsum";
                customText.customText = @"dorsum ";
                
                [newSection.customText addObject:customText];
            }
            
            // left
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"left";
                customText.customText = @"left ";
                
                [newSection.customText addObject:customText];
            }
            
            // right
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"right";
                customText.customText = @"right ";
                
                [newSection.customText addObject:customText];
            }
            
            // hand
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"hand";
                customText.customText = @"hand";
                
                [newSection.customText addObject:customText];
            }
            
            // foot
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"foot";
                customText.customText = @"foot";
                
                [newSection.customText addObject:customText];
            }
            
            // antecubital fossa
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"antecubital fossa";
                customText.customText = @"antecubital fossa";
                
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
        
        // 08 - Feeds & Fluids
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Feeds & Fluids";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:5];
            
            // Nil by mouth
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Nil by mouth";
                customText.customText = @"Nil by mouth";
                
                [newSection.customText addObject:customText];
            }
            
            // 10% Dextrose
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"10% Dextrose";
                customText.customText = @"10% Dextrose";
                
                [newSection.customText addObject:customText];
            }
            
            // Fully enterally fed
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Fully enterally fed";
                customText.customText = @"Fully enterally fed";
                
                [newSection.customText addObject:customText];
            }
            
            // Minimal milky aspirates
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Minimal milky aspirates";
                customText.customText = @"Minimal milky aspirates";
                
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
        
        // 09 - Fluid Balance
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Fluid Balance";
        
            [self.handoverSections addObject:newSection];
        }
        
        // 10 - Biochemistry
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Biochemistry";
        
            [self.handoverSections addObject:newSection];
        }
        
        // 11 - Jaundice
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Jaundice";
        
            [self.handoverSections addObject:newSection];
        }
            
        // 12 - Sepsis
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Sepsis";
        newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
        // No sepsis concerns
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"No sepsis concerns";
            customText.customText = @"No sepsis concerns";
            
            [newSection.customText addObject:customText];
        }
        
        [self.handoverSections addObject:newSection];
        
        // 13 - Drugs
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Drugs";
        newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Abidec
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Abidec";
            customText.customText = @"Abidec";
            
            [newSection.customText addObject:customText];
        }
        
        // Benzylpenicillin
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Benzylpenicillin";
            customText.customText = @"Benzylpenicillin";
            
            [newSection.customText addObject:customText];
        }
        
        // Caffeine
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Caffeine";
            customText.customText = @"Caffeine";
            
            [newSection.customText addObject:customText];
        }
        
        // Gaviscon
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Gaviscon";
            customText.customText = @"Gaviscon";
            
            [newSection.customText addObject:customText];
        }
        
        // Gentamicin
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Gentamicin";
            customText.customText = @"Gentamicin";
            
            [newSection.customText addObject:customText];
        }
        
        // Vitamins
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Vitamins";
            customText.customText = @"Vitamins";
            
            [newSection.customText addObject:customText];
        }
        
        [self.handoverSections addObject:newSection];
        
        // 14 - ROP
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"ROP";
        newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
        // Screening not indicated
        {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Screening not indicated";
            customText.customText = @"Screening not indicated";
            
            [newSection.customText addObject:customText];
        }
        
        [self.handoverSections addObject:newSection];
        
        // 15 - Neurology & Cranial USS
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Neurology & Cranial USS";
        
        [self.handoverSections addObject:newSection];
        
        // 16 - Parents / Social
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Parents / Social";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
        
            {
                // custom text 01
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No concerns";
                customText.customText = @"No concerns";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        } 
        
         // 17 - Examination
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Examination";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
        
            // custom text 01
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Normal exam";
                customText.customText = @"Pink\nActive\nHR 140\nHeart sounds normal\nNo murmurs\nFemorals bilaterally palpable\nRR 40\nSaO2 97% in air\nNo recession\nAbdomen soft and non-tender\nNo distension or discoloration";
        
                [newSection.customText addObject:customText];
            }
        
            // custom text 02
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Oscillated exam";
                customText.customText = @"Add Text";
            
                [newSection.customText addObject:customText];
            }
            
            // Dysmorphic exam
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Dysmorphic exam";
                customText.customText = @"Tone: abnormal";
                
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
        
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
