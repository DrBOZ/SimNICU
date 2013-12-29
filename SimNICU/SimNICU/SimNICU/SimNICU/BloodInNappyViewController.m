//
//  BloodInNappyViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BloodInNappyViewController.h"
#import "BloodInNappyModel.h"

@implementation BloodInNappyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Postnatal Ward/Blood in Nappy"];
    
    self.title = @"Blood in Nappy";
    
    self.webViewSections = [BloodInNappyModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
