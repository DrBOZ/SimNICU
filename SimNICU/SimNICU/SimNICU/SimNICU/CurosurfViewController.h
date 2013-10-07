//
//  CurosurfViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewWebViewController.h"
#import "Patient.h"

@interface CurosurfViewController : CBTableViewWebViewController

@property (nonatomic, strong) NSString *curosurfDoseSelected;
@property (nonatomic, strong) NSString *estimatedWeightUsed;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) UILabel *label;

@end
