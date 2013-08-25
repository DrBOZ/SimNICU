//
//  AdvancedPatientEditorViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface AdvancedPatientEditorViewController : UIViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSMutableArray *bayData;
@property (nonatomic, strong) NSNumber *selectedBayNSNumber;
@property (nonatomic, strong) NSNumber *selectedPatientInBayNSNumber;

@end
