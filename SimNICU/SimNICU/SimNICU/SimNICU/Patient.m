//
//  Patient.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "CBTimeMethods.h"
#import "GrowthChart.h"
#import "Patient.h"

@interface Patient ()

@end

@implementation Patient
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        // Demographics
        self.lastname = [aDecoder decodeObjectForKey:@"LastName"];
        self.firstname = [aDecoder decodeObjectForKey:@"FirstName"];
        self.birthWeight = [aDecoder decodeObjectForKey:@"BirthWeight"];
        // self.lastWeight = [aDecoder decodeObjectForKey:@"LastWeight"];
        // self.currentWeight = [aDecoder decodeObjectForKey:@"CurrentWeight"];
        self.gestation = [aDecoder decodeObjectForKey:@"Gestation"];
        self.correctedGestation = [aDecoder decodeObjectForKey:@"CorrectedGestation"];
        
        self.birthDate = [aDecoder decodeObjectForKey:@"BirthDate"];
        self.formattedBirthDate = [aDecoder decodeObjectForKey:@"FormattedBirthDate"];
        self.workingWeight = [aDecoder decodeObjectForKey:@"WorkingWeight"];
        self.workingWeightDate = [aDecoder decodeObjectForKey:@"WorkingWeightDate"];
        self.formattedWorkingWeightDate = [aDecoder decodeObjectForKey:@"FormattedWorkingWeightDate"];
        
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
        
        // bilirubin results
        self.bilirubinResults = [aDecoder decodeObjectForKey:@"BilirubinResults"];
        self.birthTimeSet = [aDecoder decodeObjectForKey:@"BirthTimeSet"];
        
        // handover sections
        self.handoverSections = [aDecoder decodeObjectForKey:@"HandoverSections"];
        
        // UITextViews
        self.background = [aDecoder decodeObjectForKey:@"Background"];
        self.activeProblems = [aDecoder decodeObjectForKey:@"ActiveProblems"];
        self.resolvedProblems = [aDecoder decodeObjectForKey:@"ResolvedProblems"];
        self.recentSignificantEvents = [aDecoder decodeObjectForKey:@"RecentSignificantEvents"];
        self.ventilationAndSedation = [aDecoder decodeObjectForKey:@"VentilationAndSedation"];
        self.cxr = [aDecoder decodeObjectForKey:@"CXR"];
        self.cardiovascular = [aDecoder decodeObjectForKey:@"Cardiovascular"];
        self.lines = [aDecoder decodeObjectForKey:@"Lines"];
        self.feedsAndFluids = [aDecoder decodeObjectForKey:@"FeedsAndFluids"];
        self.fluidBalance = [aDecoder decodeObjectForKey:@"FluidBalance"];
        self.electrolytes = [aDecoder decodeObjectForKey:@"Electrolytes"];
        self.jaundice = [aDecoder decodeObjectForKey:@"Jaundice"];
        self.sepsis = [aDecoder decodeObjectForKey:@"Sepsis"];
        self.drugs = [aDecoder decodeObjectForKey:@"Drugs"];
        self.rop = [aDecoder decodeObjectForKey:@"ROP"];
        self.cranialUSS = [aDecoder decodeObjectForKey:@"CranialUSS"];
        self.parentsAndSocial = [aDecoder decodeObjectForKey:@"ParentsAndSocial"];
        self.impression = [aDecoder decodeObjectForKey:@"Impression"];
        self.plan = [aDecoder decodeObjectForKey:@"Plan"];
        self.jobs = [aDecoder decodeObjectForKey:@"Jobs"];
        
        // Blood bank info
        self.maternalBloodGroup = [aDecoder decodeObjectForKey:@"MaternalBloodGroup"];
        self.maternalRhesus = [aDecoder decodeObjectForKey:@"MaternalRhesus"];
        self.maternalAntibodies = [aDecoder decodeObjectForKey:@"MaternalAntibodies"];
        self.babyBloodGroup = [aDecoder decodeObjectForKey:@"BabyBloodGroup"];
        self.babyRhesus = [aDecoder decodeObjectForKey:@"BabyRhesus"];
        self.dct = [aDecoder decodeObjectForKey:@"DCT"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Demographics
    [aCoder encodeObject:self.lastname forKey:@"LastName"];
    [aCoder encodeObject:self.firstname forKey:@"FirstName"];
    [aCoder encodeObject:self.birthWeight forKey:@"BirthWeight"];
    // [aCoder encodeObject:self.lastWeight forKey:@"LastWeight"];
    // [aCoder encodeObject:self.currentWeight forKey:@"CurrentWeight"];
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
    
    // bilirubin results
    [aCoder encodeObject:self.bilirubinResults forKey:@"BilirubinResults"];
    [aCoder encodeObject:self.birthTimeSet forKey:@"BirthTimeSet"];
    
    // handover sections
    [aCoder encodeObject:self.handoverSections forKey:@"HandoverSections"];
    
    // UITextViews
    [aCoder encodeObject:self.background forKey:@"Background"];
    [aCoder encodeObject:self.activeProblems forKey:@"ActiveProblems"];
    [aCoder encodeObject:self.resolvedProblems forKey:@"ResolvedProblems"];
    [aCoder encodeObject:self.recentSignificantEvents forKey:@"RecentSignificantEvents"];
    [aCoder encodeObject:self.ventilationAndSedation forKey:@"VentilationAndSedation"];
    [aCoder encodeObject:self.cxr forKey:@"CXR"];
    [aCoder encodeObject:self.cardiovascular forKey:@"Cardiovascular"];
    [aCoder encodeObject:self.lines forKey:@"Lines"];
    [aCoder encodeObject:self.feedsAndFluids forKey:@"FeedsAndFluids"];
    [aCoder encodeObject:self.fluidBalance forKey:@"FluidBalance"];
    [aCoder encodeObject:self.electrolytes forKey:@"Electrolytes"];
    [aCoder encodeObject:self.jaundice forKey:@"Jaundice"];
    [aCoder encodeObject:self.sepsis forKey:@"Sepsis"];
    [aCoder encodeObject:self.drugs forKey:@"Drugs"];
    [aCoder encodeObject:self.rop forKey:@"ROP"];
    [aCoder encodeObject:self.cranialUSS forKey:@"CranialUSS"];
    [aCoder encodeObject:self.parentsAndSocial forKey:@"ParentsAndSocial"];
    [aCoder encodeObject:self.impression forKey:@"Impression"];
    [aCoder encodeObject:self.plan forKey:@"Plan"];
    [aCoder encodeObject:self.jobs forKey:@"Jobs"];
    
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
    
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
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
