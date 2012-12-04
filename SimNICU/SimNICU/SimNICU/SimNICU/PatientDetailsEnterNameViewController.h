//
//  PatientDetailsEnterNameViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 26/06/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class PatientDetailsEnterNameViewController;

@protocol PatientDetailsEnterNameViewControllerDelegate <NSObject>

- (void)patientDetailsEnterNameViewController:(PatientDetailsEnterNameViewController *)controller didFinishEditingPatientName:(Patient *)patient;
- (void)patientDetailsEnterNameViewController:(PatientDetailsEnterNameViewController *)controller didFinishAddingPatientName:(Patient *)patient;

@end

@interface PatientDetailsEnterNameViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <PatientDetailsEnterNameViewControllerDelegate> delegate;
@property (nonatomic, retain) UITextField *firstname;
@property (nonatomic, retain) Patient *patientToEdit;
@property (nonatomic, retain) UITextField *lastname;

@end