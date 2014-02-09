//
//  Patient.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "HandoverSection.h"
#import "CBTimeMethods.h"
#import "GrowthChart.h"
#import "HandoverRow.h"
#import "Patient.h"

@interface Patient ()

@end

@implementation Patient

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setDefaultValues];
    }
    
    return self;
}
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        // Demographics
        {
            self.lastname = [aDecoder decodeObjectForKey:@"LastName"];
            self.firstname = [aDecoder decodeObjectForKey:@"FirstName"];
            self.gestation = [aDecoder decodeObjectForKey:@"Gestation"];
            self.correctedGestation = [aDecoder decodeObjectForKey:@"CorrectedGestation"];
            
            self.birthDate = [aDecoder decodeObjectForKey:@"BirthDate"];
            self.formattedBirthDate = [aDecoder decodeObjectForKey:@"FormattedBirthDate"];
        }
        
        // Weights
        {
            // Birth weight
            self.birthWeight = [aDecoder decodeObjectForKey:@"BirthWeight"];
            
            // Current weights
            self.weights = [aDecoder decodeObjectForKey:@"Weights"];
            
            // Working weights
            self.workingWeight = [aDecoder decodeObjectForKey:@"WorkingWeight"];
            self.workingWeightDate = [aDecoder decodeObjectForKey:@"WorkingWeightDate"];
            self.formattedWorkingWeightDate = [aDecoder decodeObjectForKey:@"FormattedWorkingWeightDate"];
        }
        
        // APGAR scores
        {
            self.NewBabyAPGARSSaved = [aDecoder decodeObjectForKey:@"NewBabyAPGARSSaved"];
            
            self.APGAR1minColour = [aDecoder decodeObjectForKey:@"APGAR1minColour"];
            self.APGAR1minHeartRate = [aDecoder decodeObjectForKey:@"APGAR1minHeartRate"];
            self.APGAR1minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR1minRespiratoryEffort"];
            self.APGAR1minTone = [aDecoder decodeObjectForKey:@"APGAR1minTone"];
            self.APGAR1minReflexes = [aDecoder decodeObjectForKey:@"APGAR1minReflexes"];
            
            self.APGAR5minColour = [aDecoder decodeObjectForKey:@"APGAR5minColour"];
            self.APGAR5minHeartRate = [aDecoder decodeObjectForKey:@"APGAR5minHeartRate"];
            self.APGAR5minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR5minRespiratoryEffort"];
            self.APGAR5minTone = [aDecoder decodeObjectForKey:@"APGAR5minTone"];
            self.APGAR5minReflexes = [aDecoder decodeObjectForKey:@"APGAR5minReflexes"];
            
            self.APGAR10minColour = [aDecoder decodeObjectForKey:@"APGAR10minColour"];
            self.APGAR10minHeartRate = [aDecoder decodeObjectForKey:@"APGAR10minHeartRate"];
            self.APGAR10minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR10minRespiratoryEffort"];
            self.APGAR10minTone = [aDecoder decodeObjectForKey:@"APGAR10minTone"];
            self.APGAR10minReflexes = [aDecoder decodeObjectForKey:@"APGAR10minReflexes"];
            
            self.APGAR15minColour = [aDecoder decodeObjectForKey:@"APGAR15minColour"];
            self.APGAR15minHeartRate = [aDecoder decodeObjectForKey:@"APGAR15minHeartRate"];
            self.APGAR15minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR15minRespiratoryEffort"];
            self.APGAR15minTone = [aDecoder decodeObjectForKey:@"APGAR15minTone"];
            self.APGAR15minReflexes = [aDecoder decodeObjectForKey:@"APGAR15minReflexes"];
            
            self.APGAR20minColour = [aDecoder decodeObjectForKey:@"APGAR20minColour"];
            self.APGAR20minHeartRate = [aDecoder decodeObjectForKey:@"APGAR20minHeartRate"];
            self.APGAR20minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR20minRespiratoryEffort"];
            self.APGAR20minTone = [aDecoder decodeObjectForKey:@"APGAR20minTone"];
            self.APGAR20minReflexes = [aDecoder decodeObjectForKey:@"APGAR20minReflexes"];
        }
        
        // All blood results
        {
            self.allBloodResultSampleData = [aDecoder decodeObjectForKey:@"AllBloodResultSampleData"];
        }
        
        // All fluid balance data
        {
            self.allFluidBalanceData = [aDecoder decodeObjectForKey:@"AllFluidBalanceData"];
        }
        
        // bilirubin results
        {
            self.bilirubinResults = [aDecoder decodeObjectForKey:@"BilirubinResults"];
            self.birthTimeSet = [aDecoder decodeObjectForKey:@"BirthTimeSet"];
            self.neurotoxicityRiskFactors = [aDecoder decodeObjectForKey:@"NeurotoxicityRiskFactors"];
            self.clinicalStatus = [aDecoder decodeObjectForKey:@"ClinicalStatus"];
        }
        
        // UITextViews
        {
            self.weight = [aDecoder decodeObjectForKey:@"Weight"];
            self.background = [aDecoder decodeObjectForKey:@"Background"];
            self.activeProblems = [aDecoder decodeObjectForKey:@"ActiveProblems"];
            self.resolvedProblems = [aDecoder decodeObjectForKey:@"ResolvedProblems"];
            self.recentSignificantEvents = [aDecoder decodeObjectForKey:@"RecentSignificantEvents"];
            self.ventilationAndSedation = [aDecoder decodeObjectForKey:@"VentilationAndSedation"];
            self.cxr = [aDecoder decodeObjectForKey:@"CXR"];
            self.cardiovascular = [aDecoder decodeObjectForKey:@"Cardiovascular"];
            self.haematology = [aDecoder decodeObjectForKey:@"Haematology"];
            self.lines = [aDecoder decodeObjectForKey:@"Lines"];
            self.echocardiogram = [aDecoder decodeObjectForKey:@"Echocardiogram"];
            self.feedsAndFluids = [aDecoder decodeObjectForKey:@"FeedsAndFluids"];
            self.fluidBalance = [aDecoder decodeObjectForKey:@"FluidBalance"];
            self.electrolytes = [aDecoder decodeObjectForKey:@"Electrolytes"];
            self.jaundice = [aDecoder decodeObjectForKey:@"Jaundice"];
            self.sepsis = [aDecoder decodeObjectForKey:@"Sepsis"];
            self.drugs = [aDecoder decodeObjectForKey:@"Drugs"];
            self.immunisations = [aDecoder decodeObjectForKey:@"Immunisations"];
            self.rop = [aDecoder decodeObjectForKey:@"ROP"];
            self.cranialUSS = [aDecoder decodeObjectForKey:@"CranialUSS"];
            self.parentsAndSocial = [aDecoder decodeObjectForKey:@"ParentsAndSocial"];
            self.impression = [aDecoder decodeObjectForKey:@"Impression"];
            self.plan = [aDecoder decodeObjectForKey:@"Plan"];
            self.jobs = [aDecoder decodeObjectForKey:@"Jobs"];
        }
        
        // UITextView entry dates
        {
            self.weightLastEntryDate = [aDecoder decodeObjectForKey:@"WeightLastEntryDate"];
            self.backgroundLastEntryDate = [aDecoder decodeObjectForKey:@"BackgroundLastEntryDate"];
            self.activeProblemsLastEntryDate = [aDecoder decodeObjectForKey:@"ActiveProblemsLastEntryDate"];
            self.resolvedProblemsLastEntryDate = [aDecoder decodeObjectForKey:@"ResolvedProblemsLastEntryDate"];
            self.recentSignificantEventsLastEntryDate = [aDecoder decodeObjectForKey:@"RecentSignificantEventsLastEntryDate"];
            self.ventilationAndSedationLastEntryDate = [aDecoder decodeObjectForKey:@"VentilationAndSedationLastEntryDate"];
            self.cxrLastEntryDate = [aDecoder decodeObjectForKey:@"CXRLastEntryDate"];
            self.cardiovascularLastEntryDate = [aDecoder decodeObjectForKey:@"CardiovascularLastEntryDate"];
            self.haematologyLastEntryDate = [aDecoder decodeObjectForKey:@"HaematologyLastEntryDate"];
            self.linesLastEntryDate = [aDecoder decodeObjectForKey:@"LinesLastEntryDate"];
            self.echocardiogramLastEntryDate = [aDecoder decodeObjectForKey:@"EchocardiogramLastEntryDate"];
            self.feedsAndFluidLastEntryDate = [aDecoder decodeObjectForKey:@"FeedsAndFluidsLastEntryDate"];
            self.fluidBalanceLastEntryDate = [aDecoder decodeObjectForKey:@"FluidBalanceLastEntryDate"];
            self.electrolytesLastEntryDate = [aDecoder decodeObjectForKey:@"ElectrolytesLastEntryDate"];
            self.jaundiceLastEntryDate = [aDecoder decodeObjectForKey:@"JaundiceLastEntryDate"];
            self.sepsisLastEntryDate = [aDecoder decodeObjectForKey:@"SepsisLastEntryDate"];
            self.drugsLastEntryDate = [aDecoder decodeObjectForKey:@"DrugsLastEntryDate"];
            self.immunisationsLastEntryDate = [aDecoder decodeObjectForKey:@"ImmunisationsLastEntryDate"];
            self.ropLastEntryDate = [aDecoder decodeObjectForKey:@"ROPLastEntryDate"];
            self.cranialUSSLastEntryDate = [aDecoder decodeObjectForKey:@"CranialUSSLastEntryDate"];
            self.parentsAndSocialLastEntryDate = [aDecoder decodeObjectForKey:@"ParentsAndSocialLastEntryDate"];
            self.impressionLastEntryDate = [aDecoder decodeObjectForKey:@"ImpressionLastEntryDate"];
            self.planLastEntryDate = [aDecoder decodeObjectForKey:@"PlanLastEntryDate"];
            self.jobsLastEntryDate = [aDecoder decodeObjectForKey:@"JobsLastEntryDate"];
        }
        
        // handover sections
        self.handoverSections = [aDecoder decodeObjectForKey:@"HandoverSections"];
        
        // Blood bank info
        {
            self.maternalBloodGroup = [aDecoder decodeObjectForKey:@"MaternalBloodGroup"];
            self.maternalRhesus = [aDecoder decodeObjectForKey:@"MaternalRhesus"];
            self.maternalAntibodies = [aDecoder decodeObjectForKey:@"MaternalAntibodies"];
            self.babyBloodGroup = [aDecoder decodeObjectForKey:@"BabyBloodGroup"];
            self.babyRhesus = [aDecoder decodeObjectForKey:@"BabyRhesus"];
            self.dct = [aDecoder decodeObjectForKey:@"DCT"];
        }
        
        [self setDefaultValues];
    }
    return self;
}

- (void)setDefaultValues
{
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.clinicalStatus = @"Well";              // @"Unwell"
    self.neurotoxicityRiskFactors = @"None";    // @"Present"
    
    // reset code
#if RESET_CELL_INFO
    self.handoverSections = nil;
#endif
    
    // set default sections here
    if (!self.handoverSections)
    {
        // NOTE: this list is ordered by TextView.tag
        
        self.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        HandoverRow *newRow;
        
        // 00 - Background
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Background";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.background;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 01 - Active Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Active Problems";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.activeProblems;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 02 - Resolved Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Resolved Problems";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.resolvedProblems;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 03 - Recent Significant Events
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Recent Significant Events";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.recentSignificantEvents;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 04 - Ventilation & Sedation
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Ventilation & Sedation";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.ventilationAndSedation;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 05 - CXR
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"CXR";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.cxr;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 06 - Cardiovascular
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Cardiovascular";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.cardiovascular;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 07 - Lines
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Lines";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.lines;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 08 - Feeds & Fluids
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Feeds & Fluids";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.feedsAndFluids;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 09 - Fluid Balance
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Fluid Balance";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.fluidBalance;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 10 - Biochemistry
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Biochemistry";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.electrolytes;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 11 - Jaundice
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Jaundice";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:2];
        
        newRow = [[HandoverRow alloc] init];
        // Different graph sizes for iPhone 4 and iPhone 5
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            newRow.rowHeight = [NSNumber numberWithFloat:320.0f];
        }
        else
        {
            newRow.rowHeight = [NSNumber numberWithFloat:260.0f];
        }
        [newSection.rows addObject:newRow];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.jaundice;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 12 - Sepsis
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Sepsis";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.sepsis;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 13 - Drugs
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Drugs";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.drugs;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 14 - ROP
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"ROP";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.rop;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 15 - Neurology & Cranial USS
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Neurology & Cranial USS";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.cranialUSS;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 16 - Parents / Social
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Parents / Social";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.parentsAndSocial;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 17 - Examination
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Examination";
        // newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.impression;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 18 - Summary
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Summary";
        // newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.plan;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 19 - Plan
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Plan";
        // newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:346.0f];
        newRow.rowText = self.jobs;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 20 - Haematology
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Haematology";
        // newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.haematology;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 21 - Echocardiogram
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Echocardiogram";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.echocardiogram;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 22 - Weight
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Weight";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.echocardiogram;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
        
        // 23 - Immunisations
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Immunisations";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        newRow.rowText = self.immunisations;
        [newSection.rows addObject:newRow];
        
        [self.handoverSections addObject:newSection];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Demographics
    [aCoder encodeObject:self.lastname forKey:@"LastName"];
    [aCoder encodeObject:self.firstname forKey:@"FirstName"];
    [aCoder encodeObject:self.birthWeight forKey:@"BirthWeight"];
    [aCoder encodeObject:self.weights forKey:@"Weights"];
    [aCoder encodeObject:self.gestation forKey:@"Gestation"];
    [aCoder encodeObject:self.correctedGestation forKey:@"CorrectedGestation"];
    
    [aCoder encodeObject:self.birthDate forKey:@"BirthDate"];
    [aCoder encodeObject:self.formattedBirthDate forKey:@"FormattedBirthDate"];
    [aCoder encodeObject:self.workingWeight forKey:@"WorkingWeight"];
    [aCoder encodeObject:self.workingWeightDate forKey:@"WorkingWeightDate"];
    [aCoder encodeObject:self.formattedWorkingWeightDate forKey:@"FormattedWorkingWeightDate"];
    
    [aCoder encodeObject:self.NewBabyAPGARSSaved forKey:@"NewBabyAPGARSSaved"];
    
    [aCoder encodeObject:self.APGAR1minColour forKey:@"APGAR1minColour"];
    [aCoder encodeObject:self.APGAR1minHeartRate forKey:@"APGAR1minHeartRate"];
    [aCoder encodeObject:self.APGAR1minRespiratoryEffort forKey:@"APGAR1minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR1minTone forKey:@"APGAR1minTone"];
    [aCoder encodeObject:self.APGAR1minReflexes forKey:@"APGAR1minReflexes"];
    
    [aCoder encodeObject:self.APGAR5minColour forKey:@"APGAR5minColour"];
    [aCoder encodeObject:self.APGAR5minHeartRate forKey:@"APGAR5minHeartRate"];
    [aCoder encodeObject:self.APGAR5minRespiratoryEffort forKey:@"APGAR5minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR5minTone forKey:@"APGAR5minTone"];
    [aCoder encodeObject:self.APGAR5minReflexes forKey:@"APGAR5minReflexes"];
    
    [aCoder encodeObject:self.APGAR10minColour forKey:@"APGAR10minColour"];
    [aCoder encodeObject:self.APGAR10minHeartRate forKey:@"APGAR10minHeartRate"];
    [aCoder encodeObject:self.APGAR10minRespiratoryEffort forKey:@"APGAR10minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR10minTone forKey:@"APGAR10minTone"];
    [aCoder encodeObject:self.APGAR10minReflexes forKey:@"APGAR10minReflexes"];
    
    [aCoder encodeObject:self.APGAR15minColour forKey:@"APGAR15minColour"];
    [aCoder encodeObject:self.APGAR15minHeartRate forKey:@"APGAR15minHeartRate"];
    [aCoder encodeObject:self.APGAR15minRespiratoryEffort forKey:@"APGAR15minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR15minTone forKey:@"APGAR15minTone"];
    [aCoder encodeObject:self.APGAR15minReflexes forKey:@"APGAR15minReflexes"];
    
    [aCoder encodeObject:self.APGAR20minColour forKey:@"APGAR20minColour"];
    [aCoder encodeObject:self.APGAR20minHeartRate forKey:@"APGAR20minHeartRate"];
    [aCoder encodeObject:self.APGAR20minRespiratoryEffort forKey:@"APGAR20minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR20minTone forKey:@"APGAR20minTone"];
    [aCoder encodeObject:self.APGAR20minReflexes forKey:@"APGAR20minReflexes"];
    
    // All blood results
    [aCoder encodeObject:self.allBloodResultSampleData forKey:@"AllBloodResultSampleData"];
    
    // All fluid balance data
    [aCoder encodeObject:self.allFluidBalanceData forKey:@"AllFluidBalanceData"];
    
    // bilirubin results
    [aCoder encodeObject:self.bilirubinResults forKey:@"BilirubinResults"];
    [aCoder encodeObject:self.birthTimeSet forKey:@"BirthTimeSet"];
    [aCoder encodeObject:self.neurotoxicityRiskFactors forKey:@"NeurotoxicityRiskFactors"];
    [aCoder encodeObject:self.clinicalStatus forKey:@"ClinicalStatus"];
    
    // UITextViews
    [aCoder encodeObject:self.weight forKey:@"Weight"];
    [aCoder encodeObject:self.background forKey:@"Background"];
    [aCoder encodeObject:self.activeProblems forKey:@"ActiveProblems"];
    [aCoder encodeObject:self.resolvedProblems forKey:@"ResolvedProblems"];
    [aCoder encodeObject:self.recentSignificantEvents forKey:@"RecentSignificantEvents"];
    [aCoder encodeObject:self.ventilationAndSedation forKey:@"VentilationAndSedation"];
    [aCoder encodeObject:self.cxr forKey:@"CXR"];
    [aCoder encodeObject:self.cardiovascular forKey:@"Cardiovascular"];
    [aCoder encodeObject:self.haematology forKey:@"Haematology"];
    [aCoder encodeObject:self.lines forKey:@"Lines"];
    [aCoder encodeObject:self.echocardiogram forKey:@"Echocardiogram"];
    [aCoder encodeObject:self.feedsAndFluids forKey:@"FeedsAndFluids"];
    [aCoder encodeObject:self.fluidBalance forKey:@"FluidBalance"];
    [aCoder encodeObject:self.electrolytes forKey:@"Electrolytes"];
    [aCoder encodeObject:self.jaundice forKey:@"Jaundice"];
    [aCoder encodeObject:self.sepsis forKey:@"Sepsis"];
    [aCoder encodeObject:self.drugs forKey:@"Drugs"];
    [aCoder encodeObject:self.immunisations forKey:@"Immunisations"];
    [aCoder encodeObject:self.rop forKey:@"ROP"];
    [aCoder encodeObject:self.cranialUSS forKey:@"CranialUSS"];
    [aCoder encodeObject:self.parentsAndSocial forKey:@"ParentsAndSocial"];
    [aCoder encodeObject:self.impression forKey:@"Impression"];
    [aCoder encodeObject:self.plan forKey:@"Plan"];
    [aCoder encodeObject:self.jobs forKey:@"Jobs"];
    
    // UITextView text entry dates
    [aCoder encodeObject:self.weightLastEntryDate forKey:@"WeightLastEntryDate"];
    [aCoder encodeObject:self.backgroundLastEntryDate forKey:@"BackgroundLastEntryDate"];
    [aCoder encodeObject:self.activeProblemsLastEntryDate forKey:@"ActiveProblemsLastEntryDate"];
    [aCoder encodeObject:self.resolvedProblemsLastEntryDate forKey:@"ResolvedProblemsLastEntryDate"];
    [aCoder encodeObject:self.recentSignificantEventsLastEntryDate forKey:@"RecentSignificantEventsLastEntryDate"];
    [aCoder encodeObject:self.ventilationAndSedationLastEntryDate forKey:@"VentilationAndSedationLastEntryDate"];
    [aCoder encodeObject:self.cxrLastEntryDate forKey:@"CXRLastEntryDate"];
    [aCoder encodeObject:self.cardiovascularLastEntryDate forKey:@"CardiovascularLastEntryDate"];
    [aCoder encodeObject:self.haematologyLastEntryDate forKey:@"HaematologyLastEntryDate"];
    [aCoder encodeObject:self.linesLastEntryDate forKey:@"LinesLastEntryDate"];
    [aCoder encodeObject:self.echocardiogramLastEntryDate forKey:@"EchocardiogramLastEntryDate"];
    [aCoder encodeObject:self.feedsAndFluidLastEntryDate forKey:@"FeedsAndFluidsLastEntryDate"];
    [aCoder encodeObject:self.fluidBalanceLastEntryDate forKey:@"FluidBalanceLastEntryDate"];
    [aCoder encodeObject:self.electrolytesLastEntryDate forKey:@"ElectrolytesLastEntryDate"];
    [aCoder encodeObject:self.jaundiceLastEntryDate forKey:@"JaundiceLastEntryDate"];
    [aCoder encodeObject:self.sepsisLastEntryDate forKey:@"SepsisLastEntryDate"];
    [aCoder encodeObject:self.drugsLastEntryDate forKey:@"DrugsLastEntryDate"];
    [aCoder encodeObject:self.immunisations forKey:@"ImmunisationsLastEntryDate"];
    [aCoder encodeObject:self.ropLastEntryDate forKey:@"ROPLastEntryDate"];
    [aCoder encodeObject:self.cranialUSSLastEntryDate forKey:@"CranialUSSLastEntryDate"];
    [aCoder encodeObject:self.parentsAndSocialLastEntryDate forKey:@"ParentsAndSocialLastEntryDate"];
    [aCoder encodeObject:self.impressionLastEntryDate forKey:@"ImpressionLastEntryDate"];
    [aCoder encodeObject:self.planLastEntryDate forKey:@"PlanLastEntryDate"];
    [aCoder encodeObject:self.jobsLastEntryDate forKey:@"JobsLastEntryDate"];
    
    // handover sections
    [aCoder encodeObject:self.handoverSections forKey:@"HandoverSections"];
    
    // Blood bank info
    [aCoder encodeObject:self.maternalBloodGroup forKey:@"MaternalBloodGroup"];
    [aCoder encodeObject:self.maternalRhesus forKey:@"MaternalRhesus"];
    [aCoder encodeObject:self.maternalAntibodies forKey:@"MaternalAntibodies"];
    [aCoder encodeObject:self.babyBloodGroup forKey:@"BabyBloodGroup"];
    [aCoder encodeObject:self.babyRhesus forKey:@"BabyRhesus"];
    [aCoder encodeObject:self.dct forKey:@"DCT"];
}

- (NSString *)returnDisplayTextLabelText
{
    if ([self.lastname isEqualToString:@""])
    {
        self.lastname = @"BABY";
        self.firstname = @"New";
    }
    else
    {
        if ([self.firstname isEqualToString:@""])
        {
            self.firstname = @"Baby";
        }
    }
    
    if (self.firstname && self.lastname)
    {
        return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", self.firstname];
    }
}

- (NSString *)returnDayOfLifeAndAgePlusGestationAndCorrectedGestation
{
    NSString *detailDisplayText;
    
    if ([self.lastname isEqualToString:@""])                                                        // Nil of names entered
    {
        self.lastname = @"BABY";
        self.firstname = @"New";
    }
    else if ([self.firstname isEqualToString:@""]) self.firstname = @"Baby";                        // Surname only
    
    if ([self.firstname isEqualToString:@"add"] && [self.lastname isEqualToString:@"new patient"])  // New patient
    {
        detailDisplayText = @"";
    }
    else if (!self.birthWeight && !self.gestation)                                                  // Name only
    {
        detailDisplayText = @"";
    }
    else if (self.birthWeight && !self.gestation)                                                   // Birth weight (or ww) but no gestation
    {
        if (self.workingWeight)
        {
            NSString *formattedWorkingWeight = [Patient formatWeight:self.workingWeight];
            detailDisplayText = [NSString stringWithFormat:@"Working weight %@", formattedWorkingWeight];
        }
        else
        {
            NSString *formattedBirthWeight = [Patient formatWeight:self.birthWeight];
            detailDisplayText = [NSString stringWithFormat:@"Birth Weight %@", formattedBirthWeight];
        }
    }
    else if (self.gestation && !self.birthWeight)                                                   // Gestation but no birth weight
    {
        NSString *estimatedWeight = [GrowthChart getWeightForSex:@"Unknown" atCentile:@"50th" atGestation:self.gestation];
        
        NSString *formattedEstimatedWeight = [Patient formatWeight:estimatedWeight];
        
        detailDisplayText = [NSString stringWithFormat:@"%@/40 estimated weight %@", self.gestation, formattedEstimatedWeight];
        // detailDisplayText = [NSString stringWithFormat:@"%@/40 gestation - no weight", self.gestation];
    }
    else if (self.gestation && self.birthWeight)                                                    // Gestation and birth weight
    {
        NSString *formattedBirthWeight = [Patient formatWeight:[self birthWeight]];
        NSString *formattedWorkingWeight = [Patient formatWeight:[self workingWeight]];
        
        if (self.workingWeight && self.birthDate)                                                   // + Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", [self gestation], formattedBirthWeight, [CBTimeMethods calculateCurrentGestation:self], formattedWorkingWeight];
            self.correctedGestation = [CBTimeMethods calculateCurrentGestation:self];
        }
        else                                                                                        // - Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@/40 birth weight %@", [self gestation], formattedBirthWeight];
        }
    }
    
    return detailDisplayText;
}

- (NSString *)returnTwoLineDetailDisplayLabelText
{
    NSString *detailDisplayText;
    
    if ([self.lastname isEqualToString:@""])                                                        // Nil of names entered
    {
        self.lastname = @"BABY";
        self.firstname = @"New";
    }
    else if ([self.firstname isEqualToString:@""]) self.firstname = @"Baby";                        // Surname only
    
    if ([self.firstname isEqualToString:@"add"] && [self.lastname isEqualToString:@"new patient"])  // New patient
    {
        detailDisplayText = @"";
    }
    else if (!self.birthWeight && !self.gestation)                                                  // Name only
    {
        detailDisplayText = @"";
    }
    else if (self.birthWeight && !self.gestation)                                                   // Birth weight (or ww) but no gestation
    {
        if (self.workingWeight)
        {
            NSString *formattedWorkingWeight = [Patient formatWeight:self.workingWeight];
            detailDisplayText = [NSString stringWithFormat:@"Working weight %@", formattedWorkingWeight];
        }
        else
        {
            NSString *formattedBirthWeight = [Patient formatWeight:self.birthWeight];
            detailDisplayText = [NSString stringWithFormat:@"Birth Weight %@", formattedBirthWeight];
        }
    }
    else if (self.gestation && !self.birthWeight)                                                   // Gestation but no birth weight
    {
        NSString *estimatedWeight = [GrowthChart getWeightForSex:@"Unknown" atCentile:@"50th" atGestation:self.gestation];
        
        NSString *formattedEstimatedWeight = [Patient formatWeight:estimatedWeight];
        
        detailDisplayText = [NSString stringWithFormat:@"%@/40 estimated weight %@", self.gestation, formattedEstimatedWeight];
        // detailDisplayText = [NSString stringWithFormat:@"%@/40 gestation - no weight", self.gestation];
    }
    else if (self.gestation && self.birthWeight)                                                    // Gestation and birth weight
    {
        NSString *formattedBirthWeight = [Patient formatWeight:[self birthWeight]];
        NSString *formattedWorkingWeight = [Patient formatWeight:[self workingWeight]];
        
        if (self.workingWeight && self.birthDate)                                                   // + Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", [self gestation], formattedBirthWeight, [CBTimeMethods calculateCurrentGestation:self], formattedWorkingWeight];
            self.correctedGestation = [CBTimeMethods calculateCurrentGestation:self];
        }
        else                                                                                        // - Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@/40 birth weight %@", [self gestation], formattedBirthWeight];
        }
    }
    
    return detailDisplayText;
}

- (NSString *)returnGestationAndCorrectedGestationOnly
{
    NSString *detailDisplayText;
    
    if ([self.lastname isEqualToString:@""])                                                        // Nil of names entered
    {
        self.lastname = @"BABY";
        self.firstname = @"New";
    }
    else if ([self.firstname isEqualToString:@""]) self.firstname = @"Baby";                        // Surname only
    
    if ([self.firstname isEqualToString:@"add"] && [self.lastname isEqualToString:@"new patient"])  // New patient
    {
        detailDisplayText = @"";
    }
    else if (!self.birthWeight && !self.gestation)                                                  // Name only
    {
        detailDisplayText = @"";
    }
    else if (self.birthWeight && !self.gestation)                                                   // Birth weight (or ww) but no gestation
    {
        if (self.workingWeight)
        {
            NSString *formattedWorkingWeight = [Patient formatWeight:self.workingWeight];
            detailDisplayText = [NSString stringWithFormat:@"Working weight %@", formattedWorkingWeight];
        }
        else
        {
            NSString *formattedBirthWeight = [Patient formatWeight:self.birthWeight];
            detailDisplayText = [NSString stringWithFormat:@"Birth Weight %@", formattedBirthWeight];
        }
    }
    else if (self.gestation && !self.birthWeight)                                                   // Gestation but no birth weight
    {
        NSString *estimatedWeight = [GrowthChart getWeightForSex:@"Unknown" atCentile:@"50th" atGestation:self.gestation];
        
        NSString *formattedEstimatedWeight = [Patient formatWeight:estimatedWeight];
        
        detailDisplayText = [NSString stringWithFormat:@"%@/40 estimated weight %@", self.gestation, formattedEstimatedWeight];
        // detailDisplayText = [NSString stringWithFormat:@"%@/40 gestation - no weight", self.gestation];
    }
    else if (self.gestation && self.birthWeight)                                                    // Gestation and birth weight
    {
        if (self.workingWeight && self.birthDate)                                                   // + Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@ now %@", [self gestation], [CBTimeMethods calculateCurrentGestation:self]];
            self.correctedGestation = [CBTimeMethods calculateCurrentGestation:self];
        }
        else                                                                                        // - Working Weight
        {
            detailDisplayText = [NSString stringWithFormat:@"%@/40 gestation", [self gestation]];
        }
    }
    
    return detailDisplayText;
}

- (NSString *)returnDaysAndCorrectedGestationalAge;
{
    NSString *daysAndCorrectedGestationalAge = nil;
    
    return daysAndCorrectedGestationalAge;
}

+ (NSString *)formatWeight:(NSString *)weight
{
    NSString *formattedWeight = nil;
    
    // format weight
    NSString *UKLocaleRawWeight;
    UKLocaleRawWeight = [weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleRawWeight = [weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float weightKGAsFloat = [UKLocaleRawWeight floatValue];
    
    if(weightKGAsFloat < 1.0f)
    {
        // convert to grams as use integer
        int weightGRAMSasInt = weightKGAsFloat * 1000;
        formattedWeight = [NSString stringWithFormat:@"%i g", weightGRAMSasInt];
    }
    else
    {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  // this all came from the estimated weight code
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        // if locale has an arabic decimal separator then use english
        if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
        {
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        }
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 3;
        
        formattedWeight = [NSString stringWithFormat:@"%@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:weightKGAsFloat]]];
        // formattedWeight = [NSString stringWithFormat:@"%@ kg", weight];
    }
    
    return formattedWeight;
}

+ (Patient *)createDemoPatient:(NSNumber *)number
{
    Patient *patient = [Patient new];
    
    if ([number isEqualToNumber:@1])
    {
        patient.firstname = @"Demo";
        patient.lastname = @"Patient";
        patient.birthDate = [NSDate dateWithTimeIntervalSinceNow:-244800];
        patient.birthTimeSet = @"YES";
        patient.gestation = @"27+5";
        patient.birthWeight = @"1.255";
        patient.workingWeight = @"1.255";
        
        patient.activeProblems = @"Prematurity\nRDS\nAnaemia of prematurity\nPDA\nHyponatraemia";
        patient.resolvedProblems = @"Distended abdomen\nSuspected sepsis\n- Group B Srep positive";
        patient.ventilationAndSedation = @"NCPAP 31% FiO2\nOccasional self-correcting desats and bradys";
        patient.cardiovascular = @"HR 140 - 160\nMean BP > 32";
        patient.lines = @"24G dorsum right hand\nLong line right long saphenous (day 2)";
        patient.jaundice = @"Well below phototherapy line";
        patient.sepsis = @"Temp 36.5 - 36.4";
        patient.drugs = @"Chlorothiazide 10ml/kg BD\nSpironolactone 1mg/kg BD\nCaffeine citrate";
        patient.rop = @"In book for 23rd December";
        patient.cranialUSS = @"Day 2 CrUSS normal\nDay 7 CrUSS normal";
        patient.impression = @"Pink\nActive\nHR 157\nNo murmurs\nNo bounding pulses\nCRT less than 1 sec\nRR 50\nMinimal recession\nSaO2 91% on NCPAP FiO2 31%\nAbdomen distended with everted umbilicus\nNon-tender, not shiny or tense\nNot oedematous";
        patient.plan = @"Persisting NCPAP requirement in higher FiO2.\nAbdomen more distended than yesterday now nearing full enteral feeds";
        
        
        patient.allBloodResultSampleData = [[NSMutableArray alloc] initWithCapacity:5];
        
        NSMutableDictionary *sampleData = [NSMutableDictionary dictionary];
        
        // admission blood results (30 min)
        [sampleData setValue:@"YES" forKey:@"Display FBC"];
        [sampleData setValue:@"18.6" forKey:@"Haemoglobin value"];
        [sampleData setValue:@"15.6" forKey:@"Total White Cell Count value"];
        [sampleData setValue:@"366" forKey:@"Platelet value"];
        
        [sampleData setValue:@"YES" forKey:@"Display CRP"];
        [sampleData setValue:@"<5" forKey:@"C Reactive Protein value"];
        
        [sampleData setValue:[NSDate dateWithTimeIntervalSinceNow:-243000] forKey:@"Result Date"];
        [sampleData setValue:@1 forKey:@"Unique Reference"];
        
        [patient.allBloodResultSampleData addObject:sampleData];
        
        sampleData = [NSMutableDictionary dictionary];
        
        // 8 hour blood results
        [sampleData setValue:@"YES" forKey:@"Display FBC"];
        [sampleData setValue:@"16.4" forKey:@"Haemoglobin value"];
        [sampleData setValue:@"12.7" forKey:@"Total White Cell Count value"];
        [sampleData setValue:@"290" forKey:@"Platelet value"];
        
        [sampleData setValue:@"YES" forKey:@"Display U&Es"];
        [sampleData setValue:@"139" forKey:@"Sodium value (serum)"];
        [sampleData setValue:@"5.0" forKey:@"Potassium value (serum)"];
        [sampleData setValue:@"7.3" forKey:@"Urea value (serum)"];
        [sampleData setValue:@"58" forKey:@"Creatinine value (serum)"];
        
        [sampleData setValue:@"YES" forKey:@"Display CRP"];
        [sampleData setValue:@"<5" forKey:@"C Reactive Protein value"];
        
        [sampleData setValue:[NSDate dateWithTimeIntervalSinceNow:-216000] forKey:@"Result Date"];
        [sampleData setValue:@2 forKey:@"Unique Reference"];
        
        [patient.allBloodResultSampleData addObject:sampleData];
    }
    
    return patient;
}

- (BOOL)meetsCriteriaForROPScreening
{
    BOOL patientMeetsCriteria = NO;
    
    int gestation = [self.gestation intValue];
    float birthWeight = [self.birthWeight floatValue];
    
    if ((gestation > 0 && gestation < 32) || (birthWeight > 0.0f && birthWeight < 1.5f))
    {
        patientMeetsCriteria = YES;
    }
    
    return patientMeetsCriteria;
}

@end
