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

@interface DailySummaryPDFViewController : UIViewController

@property (nonatomic, strong) Patient *selectedPatient;

@end
