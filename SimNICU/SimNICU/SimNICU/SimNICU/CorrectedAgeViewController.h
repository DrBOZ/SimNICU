//
//  CorrectedAgeViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class CorrectedAgeViewController;

@protocol CorrectedAgeViewControllerDelegate <NSObject>

- (void)correctedAgeViewController:(CorrectedAgeViewController *)controller didChangePreferencesForCorrectAgeForPrematurityUntilYears:(NSNumber *)correctAgeForPrematurityUntilYears;

@end

@interface CorrectedAgeViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <CorrectedAgeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSNumber *correctAgeForPrematurityUntilYears;
@property (nonatomic, strong) NSString *typeOfAgeCalculator;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, retain) NSDate *dateOfBirth;

@end
