//
//  JaundiceViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 26/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@class JaundiceViewController;

@protocol JaundiceViewControllerDelegate <NSObject>

- (void)jaundiceViewControllerDidCancel:(JaundiceViewController *)controller;

@end

@interface JaundiceViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <JaundiceViewControllerDelegate> delegate;
@property (nonatomic, strong) Patient *selectedPatient;

@end
