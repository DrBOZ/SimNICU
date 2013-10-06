//
//  PhototherapyAddBilirubinResultViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyHoursOldViewController.h"
#import "BilirubinResult.h"
#import <UIKit/UIKit.h>
#import "Patient.h"

@class PhototherapyAddBilirubinResultViewController;

@protocol PhototherapyAddBilirubinResultViewControllerDelegate <NSObject>

- (void)phototherapyAddBilirubinResultViewController:(PhototherapyAddBilirubinResultViewController *)controller didFinishAddingNewBilirubinResult:(BilirubinResult *)result forBirthDate:(NSDate *)date;

- (void)phototherapyAddBilirubinResultViewControllerDidFinishDeletingBilirubinResults:(PhototherapyAddBilirubinResultViewController *)controller;

- (void)phototherapyAddBilirubinResultViewControllerDidCancel:(PhototherapyAddBilirubinResultViewController *)controller;

@end

@interface PhototherapyAddBilirubinResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PhototherapyHoursOldViewControllerDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyAddBilirubinResultViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *dateAndTimeOfBirthForThisChart;
@property (nonatomic, strong) NSString *bilirubinUnits;
@property (nonatomic, strong) Patient *selectedPatient;

@end