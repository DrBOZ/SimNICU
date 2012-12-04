//
//  PhototherapyClinicalStatusViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 28/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhototherapyClinicalStatusViewController;

@protocol PhototherapyClinicalStatusViewControllerDelegate <NSObject>

- (void)phototherapyClinicalStatusViewController:(PhototherapyClinicalStatusViewController *)controller didFinishSelectingClinicalStatus:(NSString *)clinicalStatus;

@end

@interface PhototherapyClinicalStatusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyClinicalStatusViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *clinicalStatus;

@end