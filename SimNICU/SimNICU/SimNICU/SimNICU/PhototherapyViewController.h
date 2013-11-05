//
//  PhototherapyPreGraphViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyNeurotoxicityRiskViewController.h"
#import "PhototherapyGuidelineCountryViewController.h"
#import "PhototherapyClinicalStatusViewController.h"
#import "PhototherapyGestationViewController.h"
#import "PhototherapyUnitsViewController.h"
#import <UIKit/UIKit.h>
#import "Patient.h"

@interface PhototherapyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PhototherapyGestationViewControllerDelegate, PhototherapyUnitsViewControllerDelegate, PhototherapyGuidelineCountryViewControllerDelegate, PhototherapyNeurotoxicityRiskViewControllerDelegate, PhototherapyClinicalStatusViewControllerDelegate>

@property (nonatomic, strong) NSString *neurotoxicityRiskFactors;
@property (nonatomic, strong) NSString *gestationLocked;
@property (nonatomic, strong) NSString *clinicalStatus;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSNumber *gestation;

@end