//
//  CoolingCriteriaEncephalopathyViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "CoolingCriteriaEncephalopathyViewController.h"
#import "CoolingCriteriaEncephalopathyModel.h"

@implementation CoolingCriteriaEncephalopathyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Cooling/Encephalopathy"];
    
    self.title = @"Cooling Criteria";
    
    self.webViewSections = [CoolingCriteriaEncephalopathyModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
    {
        height = 88.0f;
    }
    else
    {
        height = 78.0f;
    }
    
    return height;
}

@end
