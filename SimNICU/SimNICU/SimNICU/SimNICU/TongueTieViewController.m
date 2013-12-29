//
//  TongueTieViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "TongueTieViewController.h"
#import "TongueTieModel.h"

@interface TongueTieViewController ()

@end

@implementation TongueTieViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Tongue Tie"];
    
    self.title = @"Tongue Tie";
    
    self.webViewSections = [TongueTieModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
