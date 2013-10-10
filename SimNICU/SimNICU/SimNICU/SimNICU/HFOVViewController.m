//
//  HFOVViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "HFOVViewController.h"
#import "HFOVModel.h"

@implementation HFOVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"HFOV"];
    
    self.title = @"HFOV";
    
    self.webViewSections = [HFOVModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end