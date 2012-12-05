//
//  InfusionDrug.h
//  SimNICU
//
//  Created by Conrad Bosman on 05/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "InfusionDrugPreparation.h"
#import <Foundation/Foundation.h>

@interface InfusionDrug : NSObject

// general properties
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) InfusionDrugPreparation *defaultPreparation;
@property (nonatomic, strong) NSMutableArray *availablePreparations;

// time that can be left out once prepard...


// infusion specific
@property (nonatomic) BOOL *makesUpInDefaultVolume; // user defined i.e. 50mls
@property (nonatomic, strong) NSNumber *VolumeToMakeUpInIfDoesNotMakeUpInDefaultVolume; // if not standard

// there must be a user preference: 'defaultInfusionVolume'

@property (nonatomic, strong) NSMutableArray *allowedDiluents; // array of allowed diluents

// in array
//
// 10% Dextrose, 5% Dextrose, 0.9% Sodium Chloride

@property (nonatomic, strong) NSMutableArray *ySiteCompatibileDrugs;
@property (nonatomic, strong) NSMutableArray *ySiteNonCompatibleDrugs;

@end
