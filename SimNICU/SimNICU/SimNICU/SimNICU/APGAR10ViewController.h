//
//  APGAR10TableViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "Patient.h"

@interface APGAR10ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *scoreRespiratoryEffort;
@property (nonatomic, strong) NSString *totalAPGARScore;
@property (nonatomic, strong) UILabel *scoreHeartRate;
@property (nonatomic, strong) UILabel *scoreReflexes;
@property (nonatomic, strong) UILabel *scoreColour;
@property (nonatomic, strong) UILabel *scoreTone;
@property (nonatomic, strong) Patient *patient;

- (void)calculateAndDisplayTotalAPGARScore;

@end