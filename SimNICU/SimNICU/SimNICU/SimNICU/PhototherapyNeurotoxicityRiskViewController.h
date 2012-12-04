//
//  PhototherapyNeurotoxicityRiskViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 27/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhototherapyNeurotoxicityRiskViewController;

@protocol PhototherapyNeurotoxicityRiskViewControllerDelegate <NSObject>

- (void)phototherapyNeurotoxicityRiskViewController:(PhototherapyNeurotoxicityRiskViewController *)controller didFinishSelectingNeurotoxicityRisk:(NSString *)neurotoxicityRisk;

@end

@interface PhototherapyNeurotoxicityRiskViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyNeurotoxicityRiskViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *neurotoxicityRiskFactors;

@property (nonatomic, strong) UITableViewCell *neuroRiskNone;
@property (nonatomic, strong) UITableViewCell *neuroRiskAcidosis;
@property (nonatomic, strong) UITableViewCell *neuroRiskAsphyxia;
@property (nonatomic, strong) UITableViewCell *neuroRiskAlbuminLessThanThreeGramsPerDeciLitre;
@property (nonatomic, strong) UITableViewCell *neuroRiskG6PDPresent;
@property (nonatomic, strong) UITableViewCell *neuroRiskIsoimmunineHaemolyticDiseasePresent;
@property (nonatomic, strong) UITableViewCell *neuroRiskSepsis;
@property (nonatomic, strong) UITableViewCell *neuroRiskSignificantLethargy;
@property (nonatomic, strong) UITableViewCell *neuroRiskTemperatureInstability;

@end