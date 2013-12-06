//
//  DailySummaryViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class DailySummaryViewController;

@protocol DailySummaryViewControllerDelegate <NSObject>

@optional

- (void)DailySummaryViewControllerDidFinish:(DailySummaryViewController *)controller;

@end

@interface DailySummaryViewController : UIViewController

@property (nonatomic, weak) id <DailySummaryViewControllerDelegate> delegate;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSMutableArray *bayData;
@property (nonatomic, strong) NSNumber *selectedBayNSNumber;
@property (nonatomic, strong) NSNumber *selectedPatientInBayNSNumber;

@end