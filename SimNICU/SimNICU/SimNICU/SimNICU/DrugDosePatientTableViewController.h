//
//  DrugDosePatientTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"
#import "Patient.h"

@interface DrugDosePatientTableViewController : CBTableViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *selectedDrug;

@end
