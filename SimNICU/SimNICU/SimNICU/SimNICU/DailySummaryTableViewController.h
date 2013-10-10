//
//  DailySummaryTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class DailySummaryTableViewController;

@protocol DailySummaryTableViewControllerDelegate <NSObject>

@optional

- (void)DailySummaryTableViewControllerDidFinish:(DailySummaryTableViewController *)controller;

@end

@interface DailySummaryTableViewController : UITableViewController

@property (nonatomic, weak) id <DailySummaryTableViewControllerDelegate> delegate;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSMutableArray *bayData;
@property (nonatomic, strong) NSNumber *selectedBayNSNumber;
@property (nonatomic, strong) NSNumber *selectedPatientInBayNSNumber;

@end
