//
//  FluidBalanceViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "Patient.h"

@class FluidBalanceTableViewController;

@protocol FluidBalanceTableViewControllerDelegate <NSObject>

- (void)fluidBalanceTableViewController:(FluidBalanceTableViewController *)controller didFinish:(NSMutableArray *)newAllFluidBalanceData;

- (void)fluidBalanceTableViewControllerDidCancel:(FluidBalanceTableViewController *)controller;

@end

@interface FluidBalanceTableViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <FluidBalanceTableViewControllerDelegate> delegate;

// patient, and therefore allFluidBalanceData is passed through
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;

// This view controller is used modally from the DailySummaryVC
@property (nonatomic) BOOL isBeingUsedAsAModalViewController;

@property (nonatomic, strong) NSMutableDictionary *fluidBalanceData;
@property (nonatomic, strong) NSDate *fluidBalanceDate;

@end