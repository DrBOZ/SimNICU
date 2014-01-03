//
//  FluidBalanceViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "Patient.h"

@interface FluidBalanceTableViewController : CBTableViewController

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;
@property (nonatomic) BOOL useAsModalViewController;

@end
