//
//  CorrectedAgeViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface CorrectedAgeViewController : UIViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, retain) NSDate *dateOfBirth;
@property (nonatomic, strong) UITextField *gestation;

@end
