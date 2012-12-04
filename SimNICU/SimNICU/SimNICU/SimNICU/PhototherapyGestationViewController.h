//
//  PhototherapyGestationViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 04/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhototherapyGestationViewController;

@protocol PhototherapyGestationViewControllerDelegate <NSObject>

- (void)phototherapyGestationViewController:(PhototherapyGestationViewController *)controller didFinishSelectingGestation:(NSNumber *)gestation;

@end
 
@interface PhototherapyGestationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, unsafe_unretained) id <PhototherapyGestationViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *guidelineCountry;
@property (nonatomic, strong) NSNumber *gestation;

@end