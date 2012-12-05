//
//  InfusionDrugPreparation.h
//  SimNICU
//
//  Created by Conrad Bosman on 05/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfusionDrugPreparation : NSObject

@property (nonatomic, strong) NSString *text; // combination of "ConcentrationDrug / ConcentrationDiluent"

@property (nonatomic, strong) NSNumber *ConcentrationDrug;
@property (nonatomic, strong) NSNumber *ConcentrationDiluent;

@end
