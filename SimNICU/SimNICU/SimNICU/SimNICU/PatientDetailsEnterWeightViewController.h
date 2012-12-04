//
//  PatientDetailsEnterWeightViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class PatientDetailsEnterWeightViewController;

@protocol PatientDetailsEnterWeightViewControllerDelegate <NSObject>

- (void)patientDetailsEnterWeightViewController:(PatientDetailsEnterWeightViewController *)controller didFinishEditingPatientBirthWeight:(Patient *)patient;
- (void)patientDetailsEnterWeightViewController:(PatientDetailsEnterWeightViewController *)controller didFinishAddingPatientBirthWeight:(Patient *)patient;

@end

@interface PatientDetailsEnterWeightViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <PatientDetailsEnterWeightViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *textFieldToBecomeFirstResponder;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITextField *birthWeight;
@property (nonatomic, strong) UITextField *gestation;
@property (nonatomic, strong) Patient *patientToEdit;

@end