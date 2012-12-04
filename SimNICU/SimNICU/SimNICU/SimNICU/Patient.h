//
//  Patient.h
//  SimNICU
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
@property (nonatomic, retain) NSString *birthWeight;
@property (nonatomic, retain) NSString *lastWeight;
@property (nonatomic, retain) NSString *currentWeight;
@property (nonatomic, retain) NSString *workingWeight;

// Bilirubin results
@property (nonatomic, strong) NSMutableArray *bilirubinResults;


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
@property (nonatomic) int birthYear;  // Try these as NSNumber if doesn't work.
@property (nonatomic) int birthMonth;
@property (nonatomic) int birthDay;
@property (nonatomic) int birthHour;
@property (nonatomic) int birthMinute;
@property (nonatomic, retain) NSDate *dueDate;

// @property (nonatomic, retain) NSNumber *lastWeight;
// @property (nonatomic, retain) NSNumber *workingWeight;
@property (nonatomic, retain) NSNumber *gestationWeeks;
@property (nonatomic, retain) NSNumber *gestationDays;

@end
