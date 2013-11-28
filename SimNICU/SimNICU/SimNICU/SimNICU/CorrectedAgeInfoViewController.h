//
//  CorrectedAgeInfoViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorrectedAgeInfoViewController;

@protocol CorrectedAgeInfoViewControllerDelegate <NSObject>

- (void)correctedAgeInfoViewController:(CorrectedAgeInfoViewController *)controller didChangeCorrectAgeForPrematurityUntilYears:(NSNumber *)correctAgeForPrematurityUntilYears;

@end

@interface CorrectedAgeInfoViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <CorrectedAgeInfoViewControllerDelegate> delegate;

@end
