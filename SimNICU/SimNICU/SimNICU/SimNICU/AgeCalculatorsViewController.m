//
//  AgeCalculatorsViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AgeCalculatorsInfoViewController.h"
#import "PortraitOnlyNavigationController.h"
#import "AgeCalculatorsViewController.h"
#import "CorrectedAgeViewController.h"
#import "EnterWeightViewController.h"
#import "ExactAgeViewController.h"
#import "CBTableViewSectionData.h"
#import "ZUUIRevealController.h"
#import "AgeCalculatorsModel.h"
#import "CBTableViewRowData.h"

@implementation AgeCalculatorsViewController
{
    NSMutableArray *calculatorGroup;
    NSMutableArray *calculators;
    NSArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Age Calculators"];
    
    // set title
    if (self.selectedPatient) self.title = NSLocalizedString(@"Patient selected", nil);
    else self.title = NSLocalizedString(@"Age", nil);
    
    // info button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems infoBarButtonWithTarget:self action:@selector(showInfoScreen)];
    
    // get table data
    tableData = [AgeCalculatorsModel getArrayForTableView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    self.tableView.rowHeight = 50.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    return [sectionData.rowData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    return sectionData.titleForHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    cell.textLabel.text = rowData.text;
    cell.detailTextLabel.text = rowData.detailText;
    
    // Specific font for iOS 7
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // Age Calculator name
        [CBFonts textFormattingForLabel:cell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
        
        // Age Calculator details
        [CBFonts detailTextFormattingForLabel:cell.detailTextLabel withTextStyle:UIFontTextStyleFootnote minFontSize:14.0f];
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            ExactAgeViewController *newViewController = [[ExactAgeViewController alloc] init];
            newViewController.selectedPatient = self.selectedPatient;
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            CorrectedAgeViewController *newViewController = [[CorrectedAgeViewController alloc] init];
            
            newViewController.typeOfAgeCalculator = rowData.text;
            newViewController.selectedPatient = self.selectedPatient;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        CorrectedAgeViewController *newViewController = [[CorrectedAgeViewController alloc] init];
        
        newViewController.typeOfAgeCalculator = rowData.text;
        newViewController.selectedPatient = self.selectedPatient;
        
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}

- (void)showInfoScreen
{
    AgeCalculatorsInfoViewController *newViewController = [[AgeCalculatorsInfoViewController alloc] init];
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        navController.navigationBar.barTintColor = [UIColor grayColor];
        navController.navigationBar.tintColor = [UIColor redColor];
    }
    else
    {
        navController.navigationBar.tintColor = [UIColor blackColor];
        navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

@end
