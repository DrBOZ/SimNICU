//
//  IntubationViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "Patient.h"

@interface IntubationViewController : UIViewController

@property (nonatomic, strong) NSString *endotrachealTubeType;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *gestation;
@property (nonatomic, strong) NSString *weight;

@end
