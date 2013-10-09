//
//  EarlyCareViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "EarlyCareViewController.h"
#import "EarlyCareModel.h"

@implementation EarlyCareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.webViewSections = [EarlyCareModel webViews];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Early Care"];
    
    self.title = @"Early Care";
    
    if (!self.earlyCareWarningShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"NOTE!"
                                  message:@"The following is for infants born less than 28 weeks gestation."
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
