//
//  CoolingTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CoolingCriteriaEncephalopathyViewController.h"
#import "CoolingTableViewController.h"

@interface CoolingTableViewController ()

@end

@implementation CoolingTableViewController

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
	
    [CBTrackers logEvent:@"Cooling"];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    self.title = @"Cooling Criteria";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *numberOfRows = @[@1, @3, @2];
    
    return [numberOfRows[section] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *headerTitles = @[@"Selection Criteria", @"with at least one of the following", @"AND any of the following"];
    
    return headerTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (section == 0)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
        {
            height = 55.0f;
        }
        else
        {
            height = 55.0f;
        }
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        cell.textLabel.text = @"Gestation 36/40 or more";
        cell.detailTextLabel.text = @"";
        
        returnCell = cell;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"cell10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"APGAR score";
            cell.detailTextLabel.text = @"less than 6 at 10 minutes";
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"cell11";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Resuscitation";
            cell.detailTextLabel.text = @"Still required at 10 minutes";
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"CordGases";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Cord gases";
            cell.detailTextLabel.text = @"any pH < 7.0 or BE < -15 within 60 min of birth";
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
                // replace dots with commas
                cell.detailTextLabel.text = [cell.detailTextLabel.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"cell20";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Seizures";
            cell.detailTextLabel.text = @"Clinical or on cerebral function monitoring";
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"cell21";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Moderate to severe encephalopathy";
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.text = @"Repeated neurological assessment";
            
            returnCell = cell;
        }
    }
    
    // Dynamic text formatting for iOS 7
    [CBFonts textFormattingForLabel:returnCell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
    [CBFonts detailTextFormattingForLabel:returnCell.detailTextLabel withTextStyle:UIFontTextStyleFootnote minFontSize:14.0f];
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path;
    
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CoolingCriteriaEncephalopathyViewController *newViewController = [[CoolingCriteriaEncephalopathyViewController alloc] init];
        // [appDelegate.navigationController pushViewController:newViewController animated:YES];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}

@end
