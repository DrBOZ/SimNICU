//
//  FluidRequirementsTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 17/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "Patient.h"

@interface FluidRequirementsTableViewController : CBTableViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;

@end
