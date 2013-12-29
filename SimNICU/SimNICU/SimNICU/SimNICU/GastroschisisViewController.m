//
//  GastroschisisBackgroundViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "GastroschisisViewController.h"
#import "GastroschisisModel.h"

@implementation GastroschisisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Gastroschisis"];
    
    self.title = @"Gastroschisis";
    
    self.webViewSections = [GastroschisisModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
