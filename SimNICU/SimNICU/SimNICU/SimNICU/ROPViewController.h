//
//  ROPViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "Patient.h"

@interface ROPViewController : UIViewController

@property (nonatomic, strong) NSString *estimatedWeightUsed;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) UILabel *label;

@end
 
