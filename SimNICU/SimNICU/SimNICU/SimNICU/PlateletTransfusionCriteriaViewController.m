//
//  PlateletTransfusionCriteriaViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/10/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PlateletTransfusionCriteriaViewController.h"
#import "PlateletTransfusionModel.h"

@interface PlateletTransfusionCriteriaViewController ()

@end

@implementation PlateletTransfusionCriteriaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Blood Products/Platelet Transfusion"];
    
    self.title = @"Platelet Transfusion";
    
    self.webViewSections = [PlateletTransfusionModel webViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerTitle;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        footerTitle = @"Bag of platelets should be hung vertically for 10 minutes before transfusion to allow most platelets to settle in the volume being transfused.\n\nThe bag should then be sampled vertically into the syringe used for administration.";
    }
    else
    {
        footerTitle = @"Bag of platelets should be hung vertically for 10 minutes before transfusion to allow most platelets to settle in the volume being transfused.\nThe bag should then be sampled vertically into the syringe used for administration.";
    }
    
    return footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        return 130.0f;
    }
    else
    {
        return 160.0f;
    }
}

@end
