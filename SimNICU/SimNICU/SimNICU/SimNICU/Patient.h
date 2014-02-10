//
//  Patient.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patient : NSObject <NSCoding>
{
    int *gestationWeeks;
}

// Demographics
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *firstname;

// Birth date
@property (nonatomic, retain) NSDate *birthDate;
@property (nonatomic, retain) NSString *formattedBirthDate;
@property (nonatomic, strong) NSString *birthTimeSet;

// Gestation
@property (nonatomic, retain) NSString *gestation;
@property (nonatomic, retain) NSString *correctedGestation;

// Working Weight Date
@property (nonatomic, retain) NSDate *workingWeightDate;
@property (nonatomic, retain) NSString *formattedWorkingWeightDate;

// Weights
@property (nonatomic, retain) NSArray *weights;
@property (nonatomic, retain) NSString *birthWeight;
@property (nonatomic, retain) NSString *workingWeight;

// Estimated Weight
@property (nonatomic, strong) NSString *estimatedWeight;

// All blood result sample data
@property (nonatomic, strong) NSMutableArray *allBloodResultSampleData;

// Fluid balance data
@property (nonatomic, strong) NSMutableArray *allFluidBalanceData;

// Bilirubin results
@property (nonatomic, strong) NSMutableArray *bilirubinResults; // all plotted

@property (nonatomic, strong) NSString *neurotoxicityRiskFactors;
@property (nonatomic, strong) NSString *clinicalStatus;

// APGAR Scores
// Could use an array for this
@property (nonatomic, retain) NSString *NewBabyAPGARSSaved;

@property (nonatomic, retain) NSString *APGAR1minColour;
@property (nonatomic, retain) NSString *APGAR1minHeartRate;
@property (nonatomic, retain) NSString *APGAR1minRespiratoryEffort;
@property (nonatomic, retain) NSString *APGAR1minTone;
@property (nonatomic, retain) NSString *APGAR1minReflexes;

@property (nonatomic, retain) NSString *APGAR5minColour;
@property (nonatomic, retain) NSString *APGAR5minHeartRate;
@property (nonatomic, retain) NSString *APGAR5minRespiratoryEffort;
@property (nonatomic, retain) NSString *APGAR5minTone;
@property (nonatomic, retain) NSString *APGAR5minReflexes;

@property (nonatomic, retain) NSString *APGAR10minColour;
@property (nonatomic, retain) NSString *APGAR10minHeartRate;
@property (nonatomic, retain) NSString *APGAR10minRespiratoryEffort;
@property (nonatomic, retain) NSString *APGAR10minTone;
@property (nonatomic, retain) NSString *APGAR10minReflexes;

@property (nonatomic, retain) NSString *APGAR15minColour;
@property (nonatomic, retain) NSString *APGAR15minHeartRate;
@property (nonatomic, retain) NSString *APGAR15minRespiratoryEffort;
@property (nonatomic, retain) NSString *APGAR15minTone;
@property (nonatomic, retain) NSString *APGAR15minReflexes;

@property (nonatomic, retain) NSString *APGAR20minColour;
@property (nonatomic, retain) NSString *APGAR20minHeartRate;
@property (nonatomic, retain) NSString *APGAR20minRespiratoryEffort;
@property (nonatomic, retain) NSString *APGAR20minTone;
@property (nonatomic, retain) NSString *APGAR20minReflexes;

// I am not sure what these are doing???
// @property (nonatomic) int birthYear;  // Try these as NSNumber if doesn't work.
// @property (nonatomic) int birthMonth;
// @property (nonatomic) int birthDay;
// @property (nonatomic) int birthHour;
// @property (nonatomic) int birthMinute;
@property (nonatomic, retain) NSDate *dueDate;

// @property (nonatomic, retain) NSNumber *lastWeight;
// @property (nonatomic, retain) NSNumber *workingWeight;
// @property (nonatomic, retain) NSNumber *gestationWeeks;
// @property (nonatomic, retain) NSNumber *gestationDays;

@property (nonatomic, retain) NSMutableArray *handoverSections;

@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *background;
@property (nonatomic, retain) NSString *activeProblems;
@property (nonatomic, retain) NSString *resolvedProblems;
@property (nonatomic, retain) NSString *recentSignificantEvents;
@property (nonatomic, retain) NSString *ventilationAndSedation;
@property (nonatomic, retain) NSString *cxr;
@property (nonatomic, retain) NSString *cardiovascular;
@property (nonatomic, retain) NSString *haematology;
@property (nonatomic, retain) NSString *lines;
@property (nonatomic, retain) NSString *echocardiogram;
@property (nonatomic, retain) NSString *feedsAndFluids;
@property (nonatomic, retain) NSString *fluidBalance;
@property (nonatomic, retain) NSString *electrolytes;
@property (nonatomic, retain) NSString *jaundice;
@property (nonatomic, retain) NSString *sepsis;
@property (nonatomic, retain) NSString *drugs;
@property (nonatomic, retain) NSString *immunisations;
@property (nonatomic, retain) NSString *rop;
@property (nonatomic, retain) NSString *cranialUSS;
@property (nonatomic, retain) NSString *parentsAndSocial;
@property (nonatomic, retain) NSString *impression;
@property (nonatomic, retain) NSString *plan;
@property (nonatomic, retain) NSString *jobs;

// text entry dates
@property (nonatomic, retain) NSDate *weightLastEntryDate;
@property (nonatomic, retain) NSDate *backgroundLastEntryDate;
@property (nonatomic, retain) NSDate *activeProblemsLastEntryDate;
@property (nonatomic, retain) NSDate *resolvedProblemsLastEntryDate;
@property (nonatomic, retain) NSDate *recentSignificantEventsLastEntryDate;
@property (nonatomic, retain) NSDate *ventilationAndSedationLastEntryDate;
@property (nonatomic, retain) NSDate *cxrLastEntryDate;
@property (nonatomic, retain) NSDate *cardiovascularLastEntryDate;
@property (nonatomic, retain) NSDate *haematologyLastEntryDate;
@property (nonatomic, retain) NSDate *linesLastEntryDate;
@property (nonatomic, retain) NSDate *echocardiogramLastEntryDate;
@property (nonatomic, retain) NSDate *feedsAndFluidLastEntryDate;
@property (nonatomic, retain) NSDate *fluidBalanceLastEntryDate;
@property (nonatomic, retain) NSDate *electrolytesLastEntryDate;
@property (nonatomic, retain) NSDate *jaundiceLastEntryDate;
@property (nonatomic, retain) NSDate *sepsisLastEntryDate;
@property (nonatomic, retain) NSDate *drugsLastEntryDate;
@property (nonatomic, retain) NSDate *immunisationsLastEntryDate;
@property (nonatomic, retain) NSDate *ropLastEntryDate;
@property (nonatomic, retain) NSDate *cranialUSSLastEntryDate;
@property (nonatomic, retain) NSDate *parentsAndSocialLastEntryDate;
@property (nonatomic, retain) NSDate *impressionLastEntryDate;
@property (nonatomic, retain) NSDate *planLastEntryDate;
@property (nonatomic, retain) NSDate *jobsLastEntryDate;

@property (nonatomic, retain) NSString *maternalBloodGroup;
@property (nonatomic, retain) NSString *maternalRhesus;
@property (nonatomic, retain) NSString *maternalAntibodies;
@property (nonatomic, retain) NSString *babyBloodGroup;
@property (nonatomic, retain) NSString *babyRhesus;
@property (nonatomic, retain) NSString *dct;

+ (NSString *)formatWeight:(NSString *)weight;
+ (Patient *)createDemoPatient:(NSNumber *)number;

- (NSString *)returnDisplayTextLabelText;
- (NSString *)returnTwoLineDetailDisplayLabelText;
- (NSString *)returnDayOfLifeAndAgePlusGestationAndCorrectedGestation;
- (NSString *)returnDaysAndCorrectedGestationalAge;
- (NSString *)returnGestationAndCorrectedGestationOnly;

- (BOOL)meetsCriteriaForROPScreening;

// fluid balance data
- (NSInteger)getNumberOfFluidBalanceRows;
- (NSMutableArray *)getFormattedFluidBalanceResults;
- (NSString *)getFormattedFluidBalanceResultsForPrinting;

@end
