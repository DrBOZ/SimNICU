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

- (void)fluidBalanceTableViewController:(FluidBalanceTableViewController *)controller
                 didFinishAddingNewData:(NSDictionary *)fluidBalanceData;

- (void)fluidBalanceTableViewController:(FluidBalanceTableViewController *)controller
                   didFinishEditingData:(NSDictionary *)fluidBalanceData;

- (void)fluidBalanceTableViewController:(FluidBalanceTableViewController *)controller
                  didFinishDeletingData:(NSDictionary *)fluidBalanceData;

- (void)fluidBalanceTableViewControllerDidCancel:(FluidBalanceTableViewController *)controller;

@end

@interface FluidBalanceTableViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <FluidBalanceTableViewControllerDelegate> delegate;

@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;

@property (nonatomic) BOOL useAsModalViewController;
@property (nonatomic, strong) NSString *editOrAddFluidBalance;

@property (nonatomic, strong) NSMutableDictionary *fluidBalanceData;
@property (nonatomic, strong) NSDate *fluidBalanceDate;

@end


// Things I need to fix:
//
#warning fix spacing in both modal and non-modal views
#warning fix custom UITableViewCell to display results
#warning fix printing
#warning fix fluid list name editing
#warning fix fluid class to containt futher information
#warning test accuracy of calculations