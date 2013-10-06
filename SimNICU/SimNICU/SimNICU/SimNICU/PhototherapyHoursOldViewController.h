//
//  PhototherapyHoursOldViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 13/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class PhototherapyHoursOldViewController;
@class AbstractActionSheetPicker;

@protocol PhototherapyHoursOldViewControllerDelegate <NSObject>

- (void)phototherapyHoursOldViewController:(PhototherapyHoursOldViewController *)controller didFinishAddingAgeInDays:(NSNumber *)age formattedAge:(NSString *)formattedAge forBirthDate:(NSDate *)date;

@end

@interface PhototherapyHoursOldViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyHoursOldViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDate *dateAndTimeOfBirth;
@property (nonatomic, strong) Patient *selectedPatient;

@end
