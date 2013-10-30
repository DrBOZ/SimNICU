//
//  Preferences.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject <NSCoding>

// locale
@property (nonatomic, retain) NSString *locale;

// Infusions
@property (nonatomic, retain) NSNumber *defaultInfusionFluidVolumeMillilitres;

// Intubation
@property (nonatomic, retain) NSString *ETTRoundUp;

// Oxygenation Index
@property (nonatomic, retain) NSString *OIUnits;

// Phototherapy
@property (nonatomic, retain) NSString *bilirubinUnits;
@property (nonatomic, retain) NSString *guidelineCountry;

// Retinopathy of Prematurity
@property (nonatomic, retain) NSString *ROPGestationScreeningThreshold;
@property (nonatomic, retain) NSString *ROPBirthWeightScreeningThreshold;

// Swipe function in EnterWeightViewController
@property (nonatomic, retain) NSString *userKnowsHowToSwipeGestation;
@property (nonatomic, retain) NSString *userKnowsHowToSwipePatientList;

// Corrected age calculator
@property (nonatomic, retain) NSNumber *correctAgeForPrematurityUntilYears;
@property (nonatomic, retain) NSNumber *ageInDaysSetting;                       // 0 for day 0
                                                                                // 1 for day 1
                                                                                // 2 for day 1 before 12:00
                                                                                //           0 after  12:00

// Daily Summary Editor
@property (nonatomic, retain) NSNumber *autocorrection;
@property (nonatomic, retain) NSNumber *trackball;
@property (nonatomic, retain) NSNumber *dynamicText;
@property (nonatomic, retain) NSMutableArray *handoverSections;

// PDF settings
@property (nonatomic, retain) NSString *paperSize;
@property (nonatomic, retain) NSString *signature;
@property (nonatomic, retain) NSNumber *border;
@property (nonatomic, retain) UIImage *image;

// returns singleton object
+ (id)sharedPreferences;

@end
