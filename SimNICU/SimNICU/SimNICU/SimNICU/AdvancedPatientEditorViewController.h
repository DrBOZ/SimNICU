//
//  AdvancedPatientEditorViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class AdvancedPatientEditorViewController;

@protocol AdvancedPatientEditorViewControllerDelegate <NSObject>

@optional

- (void)AdvancedPatientEditorViewControllerDidFinish:(AdvancedPatientEditorViewController *)controller;

@end

@interface AdvancedPatientEditorViewController : UIViewController

@property (nonatomic, weak) id <AdvancedPatientEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSMutableArray *bayData;
@property (nonatomic, strong) NSNumber *selectedBayNSNumber;
@property (nonatomic, strong) NSNumber *selectedPatientInBayNSNumber;
@property (nonatomic, strong) UIButton *fingerprintButton;

@end
