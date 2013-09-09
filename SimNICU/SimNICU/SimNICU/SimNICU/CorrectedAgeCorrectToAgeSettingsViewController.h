//
//  CorrectedAgeCorrectToAgeSettingsViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 29/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorrectedAgeCorrectToAgeSettingsViewController;

@protocol CorrectedAgeCorrectToAgeSettingsViewControllerDelegate <NSObject>

- (void)correctedAgeCorrectToAgeSettingsViewControllerDidSelectNewAge:(CorrectedAgeCorrectToAgeSettingsViewController *)controller;

@end

@interface CorrectedAgeCorrectToAgeSettingsViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <CorrectedAgeCorrectToAgeSettingsViewControllerDelegate> delegate;

@end
 

