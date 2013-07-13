//
//  DrugDose.h
//  SimNICU
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugDose : NSObject

// description of the drug dose
@property (nonatomic, strong) NSString *description;

// is this dose a loading dose?
@property (nonatomic, strong) NSString *loadingDose;                 // YES or No

// is this dose a subsequent dose?
@property (nonatomic, strong) NSString *subsequentDose;              // YES or No

@property (nonatomic, strong) NSNumber *ageMinInDays;
@property (nonatomic, strong) NSNumber *ageMaxInDays;

@property (nonatomic, strong) NSNumber *gestationMinInWeeks;
@property (nonatomic, strong) NSNumber *gestationMaxInWeeks;

@property (nonatomic, strong) NSNumber *weightMinInKg;
@property (nonatomic, strong) NSNumber *weightMaxInKg;

@property (nonatomic, strong) NSNumber *dose;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *frequency;

@property (nonatomic, strong) NSString *unitsPerKilogram;

@property (nonatomic, strong) NSString *doseDoubled;                  // YES or NO
@property (nonatomic, strong) NSMutableArray *doseDoubledIndications; // strings

@property (nonatomic, strong) NSString *requiresLevelsMonitoring;     // YES or NO

@property (nonatomic, strong) NSNumber *doseToCheckLevel;

@property (nonatomic, strong) NSNumber *roundDosesToNearest;
@property (nonatomic, strong) NSString *alwaysRoundDown;              // YES or NO


@end
