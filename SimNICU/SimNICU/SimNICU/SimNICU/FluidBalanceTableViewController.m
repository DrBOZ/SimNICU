//
//  FluidBalanceViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "FluidBalanceTableViewController.h"
#import "FluidTableViewCell.h"

@interface FluidBalanceTableViewController ()

@end

@implementation FluidBalanceTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 1;
    
    else if (section == 1) return 1;
    
    else if (section == 2) return 1;
    
    else if (section == 3) return 1;
    
    else return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) return @"IN";

    else if (section == 2) return @"OUT";
    
    else if (section == 3) return @"BALANCE";
    
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 2) return 70.0f;
    
    else return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        CGFloat x = 230.0f;
        
        UIView *dailyInputResults = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        
        UILabel *miscText = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, (320.0f - x), 50.0f)];
        miscText.font = [UIFont systemFontOfSize:12.0f];
        miscText.text = @"ml/day";
        
        [dailyInputResults addSubview:miscText];
        
        UILabel *miscText2 = [[UILabel alloc] initWithFrame:CGRectMake(x, 22.0f, (320.0f - x), 50.0f)];
        miscText2.font = [UIFont systemFontOfSize:12.0f];
        miscText2.text = @"ml/kg/day";
        
        [dailyInputResults addSubview:miscText2];
        
        return  dailyInputResults;
    }
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    if (indexPath.section == 0)
    {
        CellIdentifier = @"Hours over";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = @"Hours";
        cell.detailTextLabel.text = @"Over 24 hours";
        
        return cell;
    }
    else if (indexPath .section == 1)
    {
        CellIdentifier = @"IN";
        
        FluidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[FluidTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"10% Dextrose";
        // cell.detailTextLabel.text = @"316.5 ml";
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        CellIdentifier = @"OUT";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Urine";
        cell.detailTextLabel.text = @"67.4 ml";
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        CellIdentifier = @"BALANCE";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Fluid Balance";
        cell.detailTextLabel.text = @"+ 67 ml";
        
        return cell;
    }
    else return nil;
}

@end
