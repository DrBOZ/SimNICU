//
//  TemplateTableViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 17/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface TemplateTableViewController : UIViewController

@property (nonatomic, strong) Patient *selectedPatient;

@end
