//
//  PhototherapyGraphViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyAddBilirubinResultViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "BilirubinResult.h"
#import "Patient.h"
#import <UIKit/UIKit.h>

@interface PhototherapyGraphViewController : UIViewController <SChartDatasource, SChartDelegate, PhototherapyAddBilirubinResultViewControllerDelegate>

@property (nonatomic, strong) NSDate *dateAndTimeOfBirthForThisChart;
@property (nonatomic, strong) NSMutableArray *bilirubinLevelsToPlot;
@property (nonatomic, strong) NSString *neurotoxicityRisk;
// @property (nonatomic, strong) NSString *guidelineCountry;
@property (nonatomic, strong) NSNumber *sampleAgeInDays;
@property (nonatomic, strong) NSNumber *bilirubinLevel;
// @property (nonatomic, strong) NSString *bilirubinUnits;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSNumber *gestation;

@end