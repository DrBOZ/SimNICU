//
//  EnterWeightViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "KKPasscodeSettingsViewController.h"
#import "OxygenationIndexViewController.h"
#import "PatientDetailsViewController.h"
#import "PhototherapyViewController.h"
#import "IntubationViewController.h"
#import "APGARTabBarController.h"
#import "ZUUIRevealController.h"
#import "KKPasscodeLock.h" 
#import "Preferences.h"
#import <UIKit/UIKit.h>
#import "CoolButton.h"

@class EnterWeightViewController;
@class Patient;

@protocol EnterWeightViewControllerDelegate <NSObject>

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishSelectingPatient:(Patient *)patient;

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishEnteringWeight:(NSString *)weight orGestation:(NSString *)gestation forSex:(NSString *)sex atCentile:(NSString *)centile;

@end

@interface EnterWeightViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate, patientDetailsViewControllerDelegate, ZUUIRevealControllerDelegate, OxygenationIndexViewControllerDelegate, IntubationViewControllerDelegate, KKPasscodeSettingsViewControllerDelegate, KKPasscodeViewControllerDelegate, APGARTabBarControllerDelegate, PhototherapyViewControllerDelegate>

@property (nonatomic, strong) UINavigationItem *enterWeightViewControllerNavigationBarItem;
@property (nonatomic, strong) UINavigationBar *enterWeightViewControllerNavigationBar;
@property (nonatomic, unsafe_unretained) id <EnterWeightViewControllerDelegate> delegate;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSMutableArray *patientList;
@property (nonatomic) BOOL allowUserToAccessPatientList;
@property (nonatomic, strong) Preferences *preferences;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *bayData;
@property (nonatomic, strong) UITextField *gestation;
@property (nonatomic, strong) NSString *eraseData;
@property (nonatomic, strong) UITextField *weight;
@property (nonatomic, strong) UISwitch *switchObj;
@property (nonatomic) BOOL confidentialityModeOn;

- (void)savePatientList;
- (void)patientConfidentialityModeToggle;
- (void)addPatient;
- (void)dismissKeyboard;

@end
