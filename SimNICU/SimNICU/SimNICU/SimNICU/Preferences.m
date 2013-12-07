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
        self.ageInDaysSetting = [aDecoder decodeObjectForKey:@"ageInDaysSetting"];
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
    [aCoder encodeObject:self.ageInDaysSetting
                  forKey:@"ageInDaysSetting"];
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
    
    if (!self.ageInDaysSetting)
    {
        self.ageInDaysSetting = [NSNumber numberWithInt:1];
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
    
#if RESET_PREFERENCES_HANDOVER_SECTIONS_CUSTOM_TEXT
    
    self.HandoverSections = nil;
    
#endif
    
    if (!self.handoverSections)
    {
        // create array - note this is similar but different to the patient handover Sections
        // which includes individual patient rowHeight data for information contained in the sections
        
        // NOTE: do not localise sectionNames...
        
        self.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        
#pragma mark Weight
        // 00 - Weight
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Weight";
            newSection.sectionEditable = @"YES";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // kg
            [newSection.customText addObject:[self customText:NSLocalizedString(@" kg ", nil)
                                                          ref:NSLocalizedString(@"kg", nil)]];
            
            // (gain of  g in days)
            [newSection.customText addObject:[self customText:NSLocalizedString(@"(gain of g in  days)", nil)
                                                          ref:NSLocalizedString(@"(gain of  g in days)", nil)]];
            
            // % weight loss
            [newSection.customText addObject:[self customText:NSLocalizedString(@"% weight loss", nil)
                                                          ref:NSLocalizedString(@"% weight loss", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Background
        // 01 - Background
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Background";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Transfer from 
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Transfer from", nil)]
                                                          ref:NSLocalizedString(@"Transfer from", nil)]];
            
            // Spontaneous preterm labour
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Spontaneous preterm labour", nil)
                                                          ref:NSLocalizedString(@"Spontaneous preterm labour", nil)]];
            
            // Maternal antepartum haemorrhage
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Maternal APH", nil)
                                                          ref:NSLocalizedString(@"Maternal APH", nil)]];
            
            // Em LSCS
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Em LSCS", @"Emergency Lower Segment Caesarean Section")
                                                          ref:NSLocalizedString(@"Em LSCS", @"Emergency Lower Segment Caesarean Section")]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Active Problems
        // 02 - Active Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Active Problems";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Prematurity
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Prematurity", nil)
                                                          ref:NSLocalizedString(@"Prematurity", nil)]];
            
            // RDS
            [newSection.customText addObject:[self customText:NSLocalizedString(@"RDS", nil)
                                                          ref:NSLocalizedString(@"RDS", nil)]];
            
            // Hypotension
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Hypotension", nil)
                                                          ref:NSLocalizedString(@"Hypotension", nil)]];
            
            // Anaemia
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Anaemia", nil)
                                                          ref:NSLocalizedString(@"Anaemia", nil)]];
            
            // Establishing enteral feeds
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Establishing enteral feeds", nil)
                                                          ref:NSLocalizedString(@"Establishing enteral feeds", nil)]];
            
            // Hypoglycaemia
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Hypoglycaemia", nil)
                                                          ref:NSLocalizedString(@"Hypoglycaemia", nil)]];
            
            // Jaundice requiring phototherapy
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Jaundice requiring phototherapy", nil)
                                                          ref:NSLocalizedString(@"Jaundice requiring phototherapy", nil)]];
            
            // Suspected sepsis
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Suspected sepsis", nil)
                                                          ref:NSLocalizedString(@"Suspected Sepsis", nil)]];
            
            // Maternal Group B Strep positive
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Maternal Group B Strep positive", nil)
                                                          ref:NSLocalizedString(@"Maternal Group B Strep positive", nil)]];
            
            // Breech
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Breech", nil)
                                                          ref:NSLocalizedString(@"Breech", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Resolved Problems
        // 03 - Resolved Problems
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Resolved Problems";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // RDS
            [newSection.customText addObject:[self customText:NSLocalizedString(@"RDS", nil)
                                                          ref:NSLocalizedString(@"RDS", nil)]];
            
            // Hypotension
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Hypotension", nil)
                                                          ref:NSLocalizedString(@"Hypotension", nil)]];
            
            // Anaemia
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Anaemia", nil)
                                                          ref:NSLocalizedString(@"Anaemia", nil)]];
            
            // Hypoglycaemia
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Hypoglycaemia", nil)
                                                          ref:NSLocalizedString(@"Hypoglycaemia", nil)]];
            
            // Jaundice requiring phototherapy
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Jaundice requiring phototherapy", nil)
                                                          ref:NSLocalizedString(@"Jaundice requiring phototherapy", nil)]];
            
            // Suspected sepsis
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Suspected sepsis", nil)
                                                          ref:NSLocalizedString(@"Suspected Sepsis", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Recent Significant Events
        // 04 - Recent Significant Events
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Recent Significant Events";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // ml/kg/day
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"ml/kg/day", nil)]
                                                          ref:NSLocalizedString(@"ml/kg/day", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Ventilation & Sedation
        // 05 - Ventilation & Sedation
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Ventilation & Sedation";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Breathing in air
            [newSection.customText addObject:[self customText:@"Breathing in air"
                                                          ref:@"Breathing in air"]];
            
            // No events
            [newSection.customText addObject:[self customText:@"No events"
                                                          ref:@"No events"]];
            
            // pH
            [newSection.customText addObject:[self customText:@"pH "
                                                          ref:@"pH"]];
            
            // PCO2
            [newSection.customText addObject:[self customText:@" PCO2 "
                                                          ref:@"PCO2"]];
            
            // PO2
            [newSection.customText addObject:[self customText:@" PO2 "
                                                          ref:@"PO2"]];
            
            // SB
            [newSection.customText addObject:[self customText:@" SB "
                                                          ref:@"SB"]];
            
            // BE
            [newSection.customText addObject:[self customText:@" BE "
                                                          ref:@"BE"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark CXR
        // 06 - CXR
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"CXR";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Ground glass appearances
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Ground glass appearances", nil)
                                                          ref:NSLocalizedString(@"Ground glass appearances", nil)]];
            
            // Fluid in the horizontal fissure
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Fluid in the horizontal fissure", nil)
                                                          ref:NSLocalizedString(@"Fluid in the horizontal fissure", nil)]];
            
            // No pneumothorax
            [newSection.customText addObject:[self customText:NSLocalizedString(@"No obvious pneumothorax", nil)
                                                          ref:NSLocalizedString(@"No obvious pneumothorax", nil)]];
            
            // Nasogastric tube in the stomach
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Nasogastric tube in the stomach", nil)
                                                          ref:NSLocalizedString(@"Nasogastric tube in the stomach", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Cardiovascular
        // 07 - Cardiovascular
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Cardiovascular";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // micrograms/kg/min
            [newSection.customText addObject:[self customText:@" micrograms/kg/min"
                                                          ref:@"micrograms/kg/min"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Haematology
        // 08 - Haematology
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Haematology";
            newSection.sectionEditable = @"YES";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Hb
            [newSection.customText addObject:[self customText:@"Hb "
                                                          ref:@"Hb"]];
            
            // WCC
            [newSection.customText addObject:[self customText:@" WCC "
                                                          ref:NSLocalizedString(@"WCC", nil)]];
            
            // Plats
            [newSection.customText addObject:[self customText:@" Plats "
                                                          ref:NSLocalizedString(@"Plats", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Lines
        // 09 - Lines
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Lines";
            newSection.sectionEditable = @"YES";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // 24G
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"24G", nil)]
                                                          ref:NSLocalizedString(@"24G", nil)]];
            
            // dorsum
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"dorsum", nil)]
                                                          ref:NSLocalizedString(@"dorsum", nil)]];
            
            // left
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"left", nil)]
                                                          ref:NSLocalizedString(@"left", nil)]];
            
            // right
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"right", nil)]
                                                          ref:NSLocalizedString(@"right", nil)]];
            
            // hand
            [newSection.customText addObject:[self customText:NSLocalizedString(@"hand", nil)
                                                          ref:NSLocalizedString(@"hand", nil)]];
            
            // foot
            [newSection.customText addObject:[self customText:NSLocalizedString(@"foot ", nil)
                                                          ref:NSLocalizedString(@"foot", nil)]];
            
            // antecubital fossa
            [newSection.customText addObject:[self customText:NSLocalizedString(@"antecubital fossa", nil)
                                                          ref:NSLocalizedString(@"antecubital fossa", nil)]];
            
            // long line
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Long line", nil)
                                                          ref:NSLocalizedString(@"Long line", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Echocardiogram
        // 10 - Echocardiogram
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Echocardiogram";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Feeds & Fluids
        // 11 - Feeds & Fluids
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Feeds & Fluids";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:5];
            
            // Fully enterally fed
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Fully enterally fed", nil)
                                                          ref:NSLocalizedString(@"Fully enterally fed", nil)]];
            
            // ml/kg/day
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"ml/kg/day", nil)]
                                                          ref:NSLocalizedString(@"ml/kg/day", nil)]];
            
            // Minimal milky aspirates
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Minimal milky aspirates", nil)
                                                          ref:NSLocalizedString(@"Minimal milky aspirates", nil)]];
            
            // No vomits
            [newSection.customText addObject:[self customText:NSLocalizedString(@"No vomits", nil)
                                                          ref:NSLocalizedString(@"No vomits", nil)]];
            
            // Parenteral nutrition
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Standard preterm PN", nil)
                                                          ref:NSLocalizedString(@"Standard preterm PN", nil)]];
            
            // Yellow regime
            [newSection.customText addObject:[self customText:@"Yellow regime" ref:@"Yellow regime"]];
            
            // Green regime
            [newSection.customText addObject:[self customText:@"Green regime" ref:@"Green regime"]];
            
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Fluid Balance
        // 12 - Fluid Balance
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Fluid Balance";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // ml/kg
            [newSection.customText addObject:[self customText:@" ml/kg" ref:@"ml/kg"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Biochemistry
        // 13 - Biochemistry
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Biochemistry";
            newSection.sectionEditable = @"YES";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Na
            [newSection.customText addObject:[self customText:@"Na " ref:@"Na"]];
            
            // K
            [newSection.customText addObject:[self customText:@" K " ref:@"K"]];
            
            // U
            [newSection.customText addObject:[self customText:@" U " ref:@"U"]];
            
            // Cr
            [newSection.customText addObject:[self customText:@" Cr "
                                                          ref:@"Cr"]];
            
            // Ca
            [newSection.customText addObject:[self customText:@"Ca "
                                                          ref:@"Ca"]];
            
            // Adj Ca
            [newSection.customText addObject:[self customText:@" Adj Ca "
                                                          ref:@"Adj Ca"]];
            
            // ionised Ca
            [newSection.customText addObject:[self customText:@" Ca (i)"
                                                          ref:@"Ca ionised"]];
            
            // Phosphate
            [newSection.customText addObject:[self customText:@" PO4  "
                                                          ref:@"PO4"]];
            
            // Mg
            [newSection.customText addObject:[self customText:@"Mg "
                                                          ref:@"Mg"]];
            
            // Alkaline Phosphatase
            [newSection.customText addObject:[self customText:@"ALP "
                                                          ref:@"Alk Phos"]];
            
            // ALT
            [newSection.customText addObject:[self customText:@" ALT "
                                                          ref:@"ALT"]];
            
            // ALB
            [newSection.customText addObject:[self customText:@" ALB "
                                                          ref:@"ALB"]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
            
            // current date and time
            [newSection.customText addObject:[self customText:@"[current date and time]"
                                                          ref:@"[current date and time]"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Jaundice
        // 14 - Jaundice
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Jaundice";
            newSection.sectionEditable = @"YES";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Below phototherapy line
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Below phototherapy line", nil)
                                                          ref:NSLocalizedString(@"Below phototherapy line", nil)]];
            
            // Above phototherapy line
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Above phototherapy line", nil)
                                                          ref:NSLocalizedString(@"Above phototherapy line", nil)]];
            
            // Prophylactic phototherapy
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Prophylactic phototherapy", nil)
                                                          ref:NSLocalizedString(@"Prophylactic phototherapy", nil)]];
            
            // Direct Bilirubin
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Direct bilirubin", nil)]
                                                          ref:NSLocalizedString(@"Direct bilirubin", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
       
#pragma mark Sepsis
        // 15 - Sepsis
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Sepsis";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // CRP
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"CRP ", nil)]
                                                          ref:NSLocalizedString(@"CRP", nil)]];
            
            // < 5
            [newSection.customText addObject:[self customText:@"< 5"
                                                          ref:@"< 5"]];
            
            // Blood cultures
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Blood cultures", nil)
                                                          ref:NSLocalizedString(@"Blood cultures", nil)]];
            
            // Blood cultures
            [newSection.customText addObject:[self customText:[NSString stringWithFormat:@" %@", NSLocalizedString(@"no growth", nil)]
                                                          ref:NSLocalizedString(@"no growth", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]"
                                                          ref:NSLocalizedString(@"[current date]", nil)]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Drugs
        // 16 - Drugs
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Drugs";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
            
            // Nil
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Nil", nil)
                                                          ref:NSLocalizedString(@"Nil", nil)]];
            
            // Stopped antibiotics
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Stopped antibiotics", nil)
                                                          ref:NSLocalizedString(@"Stopped antibiotics", nil)]];
            
            // Aciclovir
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Aciclovir", nil)
                                                          ref:NSLocalizedString(@"Aciclovir", nil)]];
        
            // Benzylpenicillin
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Benzylpenicillin", nil)
                                                          ref:NSLocalizedString(@"Benzylpenicillin", nil)]];
        
            // Flucloxacillin
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Flucloxacillin", nil)
                                                          ref:NSLocalizedString(@"Flucloxacillin", nil)]];
            
            // Gentamicin
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Gentamicin", nil)
                                                          ref:NSLocalizedString(@"Gentamicin", nil)]];
            
            // Caffeine
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Caffeine", nil)
                                                          ref:NSLocalizedString(@"Caffeine", nil)]];
            
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Retinopathy of Prematurity
        // 17 - ROP
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"ROP";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // Screening not indicated
            [newSection.customText addObject:[self customText:NSLocalizedString(@"Screening not indicated", nil)
                                                          ref:NSLocalizedString(@"Screening not indicated", nil)]];
            
            // In ROP book
            [newSection.customText addObject:[self customText:@"In ROP book" ref:@"In ROP book"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Neurology & Cranial USS
        // 18 - Neurology & Cranial USS
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Neurology & Cranial USS";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:10];
        
            // current date
            [newSection.customText addObject:[self customText:@"[current date]" ref:@"[current date]"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Parents / Social
        // 19 - Parents / Social
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Parents / Social";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // No concerns
            [newSection.customText addObject:[self customText:@"No concerns" ref:@"No concerns"]];
            
            // Visiting regularly
            [newSection.customText addObject:[self customText:@"Visiting regularly" ref:@"Visiting regularly"]];
            
            // Social concerns
            [newSection.customText addObject:[self customText:@"Social concerns" ref:@"Social concerns"]];
        
            [self.handoverSections addObject:newSection];
        } 
        
#pragma mark Examination
         // 20 - Examination
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Examination";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:1];
            
            // Normal examination
            [newSection.customText addObject:[self customText:@"Pink\nActive\nHR 140\nHeart sounds normal\nNo murmurs\nFemorals bilaterally palpable\nRR 40\nSaO2 97% in air\nNo recession\nAbdomen soft and non-tender\nNo distension or discoloration"
                                                          ref:@"Normal examination"]];
            
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Summary
        // 21 - Summary
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Summary";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // Preterm infant establishing enteral feeds
            [newSection.customText addObject:[self customText:@"Preterm infant establishing enteral feeds" ref:@"Preterm infant establishing enteral feeds"]];
            
            // Medically fit for discharge
            [newSection.customText addObject:[self customText:@"Medically fit for discharge" ref:@"Medically fit for discharge"]];
        
            [self.handoverSections addObject:newSection];
        }
        
#pragma mark Plan
        // 22 - Plan
        {
            newSection = [[HandoverSection alloc] init];
            newSection.sectionName = @"Plan";
            newSection.sectionEditable = @"NO";
            newSection.customText = [[NSMutableArray alloc] initWithCapacity:2];
            
            // ml/kg/day
            [newSection.customText addObject:[self customText:@" ml/kg/day" ref:@"ml/kg/day"]];
        
            [self.handoverSections addObject:newSection];
        }
    }
}

@end
