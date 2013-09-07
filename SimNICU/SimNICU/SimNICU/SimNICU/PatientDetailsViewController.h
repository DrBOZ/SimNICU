//
//  PatientDetailsViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 20/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PatientDetailsEnterWorkingWeightViewController.h"
#import "PatientDetailsEnterWeightViewController.h"
#import "PatientDetailsEnterNameViewController.h"
#import "Patient.h"
#import "Kal.h"

@class PatientDetailsViewController;
@class Patient;

@protocol PatientDetailsViewControllerDelegate <NSObject>

@optional

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishEditingPatient:(Patient *)patient;
- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishAddingPatient:(Patient *)patient;
- (void)patientDetailsViewControllerDidCancel:(PatientDetailsViewController *)controller;

@end

# pragma mark

@interface PatientDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PatientDetailsEnterNameViewControllerDelegate, PatientDetailsEnterWeightViewControllerDelegate, KalViewControllerDelegate, PatientDetailsEnterWorkingWeightViewControllerDelegate>

@property (nonatomic, unsafe_unretained) id <PatientDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) UINavigationItem *myNavigationItem;
@property (nonatomic, strong) NSString *userWantsToAddAPatient;
@property (nonatomic, strong) NSString *patientFirstname;
@property (nonatomic, strong) NSString *patientGestation;
@property (nonatomic, strong) NSString *patientLastname;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) Patient *patientToEdit;

- (void)cancel;
- (void)done;

@end
