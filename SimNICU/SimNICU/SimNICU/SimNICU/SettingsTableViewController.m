//
//  SettingsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryEditorSettingsTableViewController.h"
#import "DailySummarySectionsTableViewController.h"
#import "PDFGenerationTableViewController.h"
#import "CorrectedAgeInfoViewController.h"
#import "BayEditorTableViewController.h"
#import "SettingsTableViewController.h"
#import "DayZeroTableViewController.h"
#import "EnterWeightViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "SettingsModel.h"

@implementation SettingsTableViewController
{
    NSArray *tableData;
    
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Settings"];
    
    self.title = NSLocalizedString(@"Settings", nil);
    
    // setup back bar button with long press gesture
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:self
                                                                                                                       action:@selector(backButtonPressed)
                                                                                                              longPressTarget:self
                                                                                                              longPressAction:@selector(backButtonLongPressed)];
    
    // get table data
    tableData = [SettingsModel getArrayForTableView];
}

- (void)backButtonPressed
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)backButtonLongPressed
{
    if (!backButtonLongPressed)
    {
        backButtonLongPressed = YES;
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    int rows = [sectionData.rowData count];
    
    return rows;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    cell.textLabel.text = rowData.text;
    cell.detailTextLabel.text = rowData.detailText;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 0)
    {
        EnterWeightViewController *controller = (EnterWeightViewController *)appDelegate.revealController.rearViewController;
        
        // Bay Editor
        BayEditorTableViewController *bayEditorTableViewController = [[BayEditorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        bayEditorTableViewController.bayData = controller.bayData;
        bayEditorTableViewController.delegate = controller;
        
        [self.navigationController pushViewController:bayEditorTableViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            DailySummarySectionsTableViewController *vc = [[DailySummarySectionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            DailySummaryEditorSettingsTableViewController *newViewController = [[DailySummaryEditorSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == 2)
        {
            PDFGenerationTableViewController *newViewController = [[PDFGenerationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            DayZeroTableViewController *vc = [[DayZeroTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            CorrectedAgeInfoViewController *vc = [[CorrectedAgeInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
