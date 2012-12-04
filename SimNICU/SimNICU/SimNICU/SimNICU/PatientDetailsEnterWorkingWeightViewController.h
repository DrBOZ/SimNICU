//
//  PatientDetailsEnterWorkingWeightViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 28/07/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "KalViewController.h"
#import <UIKit/UIKit.h>
#import "Patient.h"

@class PatientDetailsEnterWorkingWeightViewController;

@protocol PatientDetailsEnterWorkingWeightViewControllerDelegate <NSObject>

- (void)patientDetailsEnterWorkingWeightViewController:(PatientDetailsEnterWorkingWeightViewController *)controller didFinishEditingPatientWorkingWeight:(Patient *)patient measuredOnDate:(NSDate *)date;

- (void)patientDetailsEnterWorkingWeightViewController:(PatientDetailsEnterWorkingWeightViewController *)controller didFinishAddingPatientWorkingWeight:(Patient *)patient measuredOnDate:(NSDate *)date;

@end

@interface PatientDetailsEnterWorkingWeightViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, KalViewControllerDelegate>

@property (nonatomic, unsafe_unretained) id <PatientDetailsEnterWorkingWeightViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *textFieldToBecomeFirstResponder;
@property (nonatomic, strong) NSDate *workingWeightDate;
@property (nonatomic, strong) UITextField *workingWeight;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) Patient *patientToEdit;

@end