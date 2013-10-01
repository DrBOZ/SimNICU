//
//  DailySummaryPDFViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>
#import "Patient.h"

@class DailySummaryPDFViewController;

@protocol DailySummaryPDFViewControllerDelegate <NSObject>

- (void)DailySummaryPDFViewControllerSelectedPreviousPatient:(DailySummaryPDFViewController *)controller;

- (void)DailySummaryPDFViewControllerSelectedNextPatient:(DailySummaryPDFViewController *)controller;

@end

@interface DailySummaryPDFViewController : UIViewController

@property (nonatomic, weak) id <DailySummaryPDFViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *phototherapyChart;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSMutableArray *bayData;

@property (nonatomic, strong) NSNumber *selectedPatientInBayNSNumber;
@property (nonatomic, strong) NSNumber *selectedBayNSNumber;

@end
