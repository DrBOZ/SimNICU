//
//  BiliousVomitingViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BiliousVomitingViewController.h"
#import "BiliousVomitingModel.h"

@implementation BiliousVomitingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Postnatal Ward/Bilious vomiting"];
    
    self.title = @"Bilious Vomiting";
    
    self.webViewSections = [BiliousVomitingModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
