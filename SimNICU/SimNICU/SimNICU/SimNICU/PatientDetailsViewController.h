//
//  PatientDetailsViewController.h
//  Neonatal Intensive Care
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

/*  Protocol is optional as:
 *  user adds a patient from the EnterWeightViewController class only
 *  
 *  edits a patient from the DailySummaryViewController
 *
 *  cancel should be in both, as it is so important...
 */
@optional

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishAddingPatient:(Patient *)patient atIndexPath:(NSIndexPath *)indexPath;
- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishEditingPatient:(Patient *)patient;
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
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)cancel;
- (void)done;

@end

// This whole thing needs updating...
