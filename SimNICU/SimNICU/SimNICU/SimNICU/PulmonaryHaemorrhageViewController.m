//
//  PulmonaryHaemorrhageViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PulmonaryHaemorrhageViewController.h"
#import "PulmonaryHaemorrhageModel.h"

@interface PulmonaryHaemorrhageViewController ()

@end

@implementation PulmonaryHaemorrhageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Pulmonary Haemorrhage"];
    
    self.title = NSLocalizedString(@"Pulmonary Haemorrhage", nil);
    
    self.webViewSections = [PulmonaryHaemorrhageModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
