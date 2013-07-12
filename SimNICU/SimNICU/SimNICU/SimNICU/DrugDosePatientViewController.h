//
//  DrugDosePatientViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface DrugDosePatientViewController : UIViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *selectedDrug;

@end

