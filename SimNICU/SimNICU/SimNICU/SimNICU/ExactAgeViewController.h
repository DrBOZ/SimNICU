//
//  ExactAgeViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface ExactAgeViewController : UIViewController

@property (nonatomic, retain) NSDate *dateAndTimeOfBirth;
@property (nonatomic, strong) Patient *selectedPatient;

@end
