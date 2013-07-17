//
//  Preferences.h
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject <NSCoding>

// alphabetical order

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

@end
