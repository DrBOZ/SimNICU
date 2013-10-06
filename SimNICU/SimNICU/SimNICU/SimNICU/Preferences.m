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
        
#pragma mark Background
        // 00 - Background
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Background";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Transfer from 
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Transfer from";
                customText.customText = @"Transfer from ";
                
                [newSection.customText addObject:customText];
            }
            
            // Spontaneous preterm labour
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Spontaneous preterm labour";
                customText.customText = @"Spontaneous preterm labour";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal antepartum haemorrhage
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = NSLocalizedString(@"Maternal antepartum haemorrhage", nil);
                customText.customText = NSLocalizedString(@"Maternal antepartum haemorrhage", nil);
                
                [newSection.customText addObject:customText];
            }
            
            // Prolonged rupture of membranes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Prolonged rupture of membranes";
                customText.customText = @"Prolonged rupture of membranes";
                
                [newSection.customText addObject:customText];
            }
            
            // Normal delivery
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Normal delivery";
                customText.customText = @"Normal delivery";
                
                [newSection.customText addObject:customText];
            }
            
            // Em LSCS
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Em LSCS";
                customText.customText = @"Em LSCS";
                
                [newSection.customText addObject:customText];
            }
            
            // Poor condition at birth
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Poor condition at birth";
                customText.customText = @"Poor condition at birth";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal group B Strep
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal group B Strep";
                customText.customText = @"Maternal group B Strep";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal gestational diabetes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal gestational diabetes";
                customText.customText = @"Maternal gestational diabetes";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal pyrexia
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal pyrexia";
                customText.customText = @"Maternal pyrexia";
                
                [newSection.customText addObject:customText];
            }
            
            // Chorioamnionitis
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Chorioamnionitis";
                customText.customText = @"Chorioamnionitis";
                
                [newSection.customText addObject:customText];
            }
            
            // Maternal insulin dependant diabetes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Maternal insulin dependant diabetes";
                customText.customText = @"Maternal insulin dependant diabetes";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Active Problems
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
            
            // Pneumothorax
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Pneumothorax";
                customText.customText = @"Pneumothorax";
                
                [newSection.customText addObject:customText];
            }
            
            // Suspected sepsis
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Suspected sepsis";
                customText.customText = @"Suspected sepsis";
                
                [newSection.customText addObject:customText];
            }
            
            // Establishing enteral feeds
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Establishing enteral feeds";
                customText.customText = @"Establishing enteral feeds";
                
                [newSection.customText addObject:customText];
            }
            
            // Bilious aspirates
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Bilious aspirates";
                customText.customText = @"Bilious aspirates";
                
                [newSection.customText addObject:customText];
            }
            
            // Abdominal concerns
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Abdominal concerns";
                customText.customText = @"Abdominal concerns";
                
                [newSection.customText addObject:customText];
            }
            
            // Hypoxic ischaemic encephalopathy
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = NSLocalizedString(@"Hypoxic ischaemic encephalopathy", nil);
                customText.customText = NSLocalizedString(@"Hypoxic ischaemic encephalopathy", nil);
                
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
        
#pragma mark Resolved Problems
        // 02 - Resolved Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Resolved Problems";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Respiratory distress syndrome
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Respiratory distress syndrome";
                customText.customText = @"Respiratory distress syndrome";
                
                [newSection.customText addObject:customText];
            }
            
            // Suspected sepsis
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Suspected sepsis";
                customText.customText = @"Suspected sepsis";
                
                [newSection.customText addObject:customText];
            }
            
            // Pneumothorax
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Pneumothorax";
                customText.customText = @"Pneumothorax";
                
                [newSection.customText addObject:customText];
            }
            
            // Bilious aspirates
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Bilious aspirates";
                customText.customText = @"Bilious aspirates";
                
                [newSection.customText addObject:customText];
            }
            
            // Abdominal concerns
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Abdominal concerns";
                customText.customText = @"Abdominal concerns";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Recent Significant Events
        // 03 - Recent Significant Events
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Recent Significant Events";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Pneumothorax
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName =  @"Pneumothorax";
                customText.customText = @"Pneumothorax";
                
                [newSection.customText addObject:customText];
            }
            
            // Pulmonary haemorrhage
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = NSLocalizedString(@"Pulmonary haemorrhage", nil);
                customText.customText = NSLocalizedString(@"Pulmonary haemorrhage", nil);
                
                [newSection.customText addObject:customText];
            }
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Ventilation & Sedation
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
            
            // pH
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"pH_";
                customText.customText = @"pH ";
                
                [newSection.customText addObject:customText];
            }
            
            // PCO2
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"PCO2";
                customText.customText = @" PCO2 ";
                
                [newSection.customText addObject:customText];
            }
            
            // PO2
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"PO2";
                customText.customText = @" PO2 ";
                
                [newSection.customText addObject:customText];
            }
            
            // SB
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"SB";
                customText.customText = @" SB ";
                
                [newSection.customText addObject:customText];
            }
            
            // BE
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"BE";
                customText.customText = @" BE ";
                
                [newSection.customText addObject:customText];
            }
            
            // Detailed respiratory exam
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[Detailed respiratory exam]";
                customText.customText = @"";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark CXR
        // 05 - CXR
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"CXR";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Normal appearances
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Normal appearances";
                customText.customText = @"Normal appearances";
                
                [newSection.customText addObject:customText];
            }
            
            // Ground glass appearances
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Ground glass appearances";
                customText.customText = @"Ground glass appearances";
                
                [newSection.customText addObject:customText];
            }
            
            // Fluid in the horizontal fissure
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Fluid in the horizontal fissure";
                customText.customText = @"Fluid in the horizontal fissure";
                
                [newSection.customText addObject:customText];
            }
            
            // No consolidation
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No consolidation";
                customText.customText = @"No consolidation";
                
                [newSection.customText addObject:customText];
            }
            
            // No pneumothorax
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No pneumothorax";
                customText.customText = @"No pneumothorax";
                
                [newSection.customText addObject:customText];
            }
            
            // Nasogastric tube in the stomach
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Nasogastric tube in the stomach";
                customText.customText = @"Nasogastric tube in the stomach";
                
                [newSection.customText addObject:customText];
            }
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Cardiovascular
        // 06 - Cardiovascular
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Cardiovascular";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Stable
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Stable";
                customText.customText = @"Stable";
                
                [newSection.customText addObject:customText];
            }
            
            // Hypotensive
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Hypotensive";
                customText.customText = @"Hypotensive ";
                
                [newSection.customText addObject:customText];
            }
            
            // Mean BP
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Mean BP";
                customText.customText = @"Mean BP ";
                
                [newSection.customText addObject:customText];
            }
            
            // Arterial
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"arterial";
                customText.customText = @" arterial ";
                
                [newSection.customText addObject:customText];
            }
            
            // Cuff
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"cuff";
                customText.customText = @" cuff";
                
                [newSection.customText addObject:customText];
            }
            
            // Fluid bolus
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Fluid bolus";
                customText.customText = @"Fluid bolus ";
                
                [newSection.customText addObject:customText];
            }
            
            // ml/kg
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"ml/kg";
                customText.customText = @" ml/kg ";
                
                [newSection.customText addObject:customText];
            }
            
            // Dobutamine @
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Dobutamine @";
                customText.customText = @"Dobutamine @ ";
                
                [newSection.customText addObject:customText];
            }
            
            // Adrenaline @
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Adrenaline @";
                customText.customText = @"Adrenaline @ ";
                
                [newSection.customText addObject:customText];
            }
            
            // micrograms/kg/min
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"micrograms/kg/min";
                customText.customText = @" micrograms/kg/min";
                
                [newSection.customText addObject:customText];
            }
            
            // Hydrocortisone
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Hydrocortisone";
                customText.customText = @"Hydrocortisone";
                
                [newSection.customText addObject:customText];
            }
            
            // Hb
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Hb";
                customText.customText = @"Hb ";
                
                [newSection.customText addObject:customText];
            }
            
            // WCC
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"WCC";
                customText.customText = @" WCC ";
                
                [newSection.customText addObject:customText];
            }
            
            // aNC
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"aNC";
                customText.customText = @" aNC ";
                
                [newSection.customText addObject:customText];
            }
            
            // Plats
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Plats";
                customText.customText = @" Plats ";
                
                [newSection.customText addObject:customText];
            }
            
            // PT
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"PT";
                customText.customText = @"PT ";
                
                [newSection.customText addObject:customText];
            }
            
            // APTT
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"APTT";
                customText.customText = @" APTT ";
                
                [newSection.customText addObject:customText];
            }
            
            // TT
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"TT";
                customText.customText = @" TT ";
                
                [newSection.customText addObject:customText];
            }
            
            // Fibrinogen
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Fibrinogen";
                customText.customText = @"Fibrinogen ";
                
                [newSection.customText addObject:customText];
            }
            
            // High
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"High";
                customText.customText = @"High ";
                
                [newSection.customText addObject:customText];
            }
            
            // Low
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Low";
                customText.customText = @"Low ";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Lines
        // 07 - Lines
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Lines";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // UVC
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"UVC";
                customText.customText = @"UVC ";
                
                [newSection.customText addObject:customText];
            }
            
            // UAC
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"UAC";
                customText.customText = @"UAC ";
                
                [newSection.customText addObject:customText];
            }
            
            // Broviac line
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Broviac line";
                customText.customText = @"Broviac line ";
                
                [newSection.customText addObject:customText];
            }
            
            // Long line
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Long line";
                customText.customText = @"Long line ";
                
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
                customText.customText = @"hand ";
                
                [newSection.customText addObject:customText];
            }
            
            // foot
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"foot";
                customText.customText = @"foot ";
                
                [newSection.customText addObject:customText];
            }
            
            // antecubital fossa
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"antecubital fossa";
                customText.customText = @"antecubital fossa ";
                
                [newSection.customText addObject:customText];
            }
            
            // long saphenous
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"long saphenous";
                customText.customText = @"long saphenous ";
                
                [newSection.customText addObject:customText];
            }
            
            // No lines
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"No intravenous lines";
                customText.customText = @"No intravenous lines";
                
                [newSection.customText addObject:customText];
            }
            
            // day 0
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[day 0]";
                customText.customText = @"[day 0]";
                
                [newSection.customText addObject:customText];
            }
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Feeds & Fluids
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
            
            // ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"ml/kg/day";
                customText.customText = @"ml/kg/day";
                
                [newSection.customText addObject:customText];
            }
            
            // 60 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"60 ml/kg/day ";
                customText.customText = @"60 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 90 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"90 ml/kg/day ";
                customText.customText = @"90 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 120 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"120 ml/kg/day ";
                customText.customText = @"120 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 135 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"135 ml/kg/day ";
                customText.customText = @"135 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 150 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"150 ml/kg/day ";
                customText.customText = @"150 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 165 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"165 ml/kg/day ";
                customText.customText = @"165 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // 180 ml/kg/day
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"180 ml/kg/day ";
                customText.customText = @"180 ml/kg/day ";
                
                [newSection.customText addObject:customText];
            }
            
            // Parenteral nutrition
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Parenteral nutrition";
                customText.customText = @"Parenteral nutrition";
                
                [newSection.customText addObject:customText];
            }
            
            
            // 10% Dextrose
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"10% Dextrose ";
                customText.customText = @"10% Dextrose ";
                
                [newSection.customText addObject:customText];
            }
            
            // with electrolytes
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"with electrolytes";
                customText.customText = @"with electrolytes";
                
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
            
            // Passing urine
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Passing urine";
                customText.customText = @"Passing urine";
                
                [newSection.customText addObject:customText];
            }
            
            // Bowels opened
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Bowels opened";
                customText.customText = @"Bowels opened";
                
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Fluid Balance
        // 09 - Fluid Balance
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Fluid Balance";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Last 24 hours
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Last 24 hours";
                customText.customText = @"Last 24 hours ";
                
                [newSection.customText addObject:customText];
            }
            
            // INPUT
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"INPUT";
                customText.customText = @"INPUT\n";
                
                [newSection.customText addObject:customText];
            }
            
            // Vamin
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Vamin";
                customText.customText = @"Vamin\t";
                
                [newSection.customText addObject:customText];
            }
            
            // Lipid
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Lipd";
                customText.customText = @"Lipid\t";
                
                [newSection.customText addObject:customText];
            }
            
            // 10% Dextrose
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"10% Dextrose";
                customText.customText = @"10% Dextrose\t";
                
                [newSection.customText addObject:customText];
            }
            
            // Milk
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Milk";
                customText.customText = @"Milk\t";
                
                [newSection.customText addObject:customText];
            }
            
            // OUTPUT
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"OUTPUT";
                customText.customText = @"OUTPUT\n";
                
                [newSection.customText addObject:customText];
            }
            
            // Aspirates
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Aspirates";
                customText.customText = @"Aspirates\t";
                
                [newSection.customText addObject:customText];
            }
            
            // Ileostomy
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Ileostomy";
                customText.customText = @"Ileostomy\t";
                
                [newSection.customText addObject:customText];
            }
            
            // Jejunostomy
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Jejunostomy";
                customText.customText = @"Jejunostomy\t";
                
                [newSection.customText addObject:customText];
            }
            
            // Urine
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Urine";
                customText.customText = @"Urine\t";
                
                [newSection.customText addObject:customText];
            }
            
            // ml/kg/hour
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"ml/kg/hour";
                customText.customText = @" ml/kg/hour ";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Biochemistry
        // 10 - Biochemistry
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Biochemistry";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Jaundice
        // 11 - Jaundice
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Jaundice";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Sepsis
        // 12 - Sepsis
        {
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
            
            // Temperature
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Temperature";
                customText.customText = @"Temperature ";
                
                [newSection.customText addObject:customText];
            }
            
            // CRP
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"CRP";
                customText.customText = @"CRP ";
                
                [newSection.customText addObject:customText];
            }
            
            // Blood cultures 
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Blood cultures";
                customText.customText = @"Blood cultures ";
                
                [newSection.customText addObject:customText];
            }
            
            // pending
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"pending";
                customText.customText = @"pending ";
                
                [newSection.customText addObject:customText];
            }
            
            // no growth
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"no growth";
                customText.customText = @"no growth ";
                
                [newSection.customText addObject:customText];
            }
            
            // [CSF results]
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[CSF results]";
                customText.customText = @"CSF \nClear and colourless\nNo organisms seen\nRC  WC  Polys  Lymphs \nProtein \nGlucose    Blood glucose ";
                
                [newSection.customText addObject:customText];
            }
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Drugs
        // 13 - Drugs
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Drugs";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Abidec
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Abidec";
                customText.customText = @"Abidec ";
            
                [newSection.customText addObject:customText];
            }
        
            // Amoxicillin
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Amoxicillin";
                customText.customText = @"Amoxicillin ";
            
                [newSection.customText addObject:customText];
            }
        
            // Benzylpenicillin
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Benzylpenicillin";
                customText.customText = @"Benzylpenicillin ";
            
                [newSection.customText addObject:customText];
            }
        
            // Breast milk fortifier
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Breast milk fortifier";
            customText.customText = @"Breast milk fortifier ";
            
            [newSection.customText addObject:customText];
        }
        
            // Caffeine
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Caffeine";
            customText.customText = @"Caffeine ";
            
            [newSection.customText addObject:customText];
        }
        
            // Cefotaxime
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Cefotaxime";
            customText.customText = @"Cefotaxime ";
            
            [newSection.customText addObject:customText];
        }
        
            // Flucloxacillin
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Flucloxacillin";
            customText.customText = @"Flucloxacillin ";
            
            [newSection.customText addObject:customText];
        }
        
            // Folic acid
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Folic acid";
            customText.customText = @"Folic acid ";
            
            [newSection.customText addObject:customText];
        }
        
            // Gaviscon
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Gaviscon";
            customText.customText = @"Gaviscon ";
            
            [newSection.customText addObject:customText];
        }
        
            // Gentamicin
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Gentamicin";
            customText.customText = @"Gentamicin ";
            
            [newSection.customText addObject:customText];
        }
        
            // Sytron
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Sytron";
            customText.customText = @"Sytron ";
            
            [newSection.customText addObject:customText];
        }
        
            // Vancomycin
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Vancomycin";
            customText.customText = @"Vancomycin ";
            
            [newSection.customText addObject:customText];
        }
        
            // Vitamins
            {
            customText = [[HandoverSectionCustomText alloc] init];
            customText.customTextReferenceName = @"Vitamins";
            customText.customText = @"Vitamins ";
            
            [newSection.customText addObject:customText];
        }
            
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
                
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Retinopathy of Prematurity
        // 14 - ROP
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Retinopathy of prematurity";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Screening not indicated
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Screening not indicated";
                customText.customText = @"Screening not indicated";
            
                [newSection.customText addObject:customText];
            }
        
            // In ROP book
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"In ROP book";
                customText.customText = @"In ROP book";
            
                [newSection.customText addObject:customText];
            }
        
            // Bilateral
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Bilateral";
                customText.customText = @"Bilateral ";
            
                [newSection.customText addObject:customText];
            }
        
            // grade 1
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"grade 1";
                customText.customText = @"grade 1 ";
            
                [newSection.customText addObject:customText];
            }
        
            // ROP
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"ROP";
                customText.customText = @"ROP ";
            
                [newSection.customText addObject:customText];
            }
        
            // Lazer therapy
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Lazer therapy";
                customText.customText = @"Lazer therapy ";
            
                [newSection.customText addObject:customText];
            }
        
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
            
                [newSection.customText addObject:customText];
            }
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Neurology & Cranial USS
        // 15 - Neurology & Cranial USS
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Neurology & Cranial USS";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Cranial USS ordered
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Cranial USS ordered";
                customText.customText = @"Cranial USS ordered";
            
                [newSection.customText addObject:customText];
            }
        
            // Unilateral
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Unilateral_";
                customText.customText = @"Unilateral ";
            
                [newSection.customText addObject:customText];
            }
        
            // Bilateral
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Bilateral_";
                customText.customText = @"Bilateral ";
            
                [newSection.customText addObject:customText];
            }
        
            // Grade
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"grade_";
                customText.customText = @"grade ";
                
                [newSection.customText addObject:customText];
            }
        
            // germinal matrix haemorrhage
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"germinal matrix haemorrhage";  // need to localise
                customText.customText = @"germinal matrix haemorrhage";
            
                [newSection.customText addObject:customText];
            }
        
            // periventricular leucomalacia
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"periventricular leucomalacia";
                customText.customText = @"periventricular leucomalacia";
            
                [newSection.customText addObject:customText];
            }
        
            // current date
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"[current date]";
                customText.customText = @"[current date]";
            
                [newSection.customText addObject:customText];
            }
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Parents / Social
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
        
#pragma mark Examination
         // 17 - Examination
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Examination";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
        
            // Limited examination
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Limited examination";
                customText.customText = @"Looks well\nPink and well perfused\nSleeping\nHeart rate \nNo respiratory distress\nSaO2";
                
                [newSection.customText addObject:customText];
            }
            
            // Normal examination
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Normal examination";
                customText.customText = @"Pink\nActive\nHR 140\nHeart sounds normal\nNo murmurs\nFemorals bilaterally palpable\nRR 40\nSaO2 97% in air\nNo recession\nAbdomen soft and non-tender\nNo distension or discoloration";
        
                [newSection.customText addObject:customText];
            }
        
            // custom text 02
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Oscillated examination";
                customText.customText = @"Add Text";
            
                [newSection.customText addObject:customText];
            }
            
            // Dysmorphic examination
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"General dysmorphic examination";
                customText.customText = @"Tone: abnormal";
                
                [newSection.customText addObject:customText];
            }
            
            // Down's examination
            {
                customText = [[HandoverSectionCustomText alloc] init];
                customText.customTextReferenceName = @"Down's syndrome examination";  // need to localise
                customText.customText = @"Tone: abnormal";
                
                [newSection.customText addObject:customText];
            }
            
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
