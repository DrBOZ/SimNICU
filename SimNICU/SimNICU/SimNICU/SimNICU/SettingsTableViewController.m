//
//  SettingsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryEditorSettingsTableViewController.h"
#import "PDFGenerationTableViewController.h"
#import "BayEditorTableViewController.h"
#import "SettingsTableViewController.h"
#import "DayZeroTableViewController.h"
#import "EnterWeightViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "SettingsModel.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController
{
    NSArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Settings"];
    
    self.title = @"Settings";
    
    // setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    // get table data
    tableData = [SettingsModel getArrayForTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    CBTableViewSectionData *sectionData = tableData[section];
    
    rows = [sectionData.rowData count];
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    CBTableViewSectionData *sectionData = tableData[section];
    header = sectionData.titleForHeader;
    
    return header;
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
        DayZeroTableViewController *vc = [[DayZeroTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        EnterWeightViewController *controller = (EnterWeightViewController *)appDelegate.revealController.rearViewController;
        
        // Bay Editor
        BayEditorTableViewController *bayEditorTableViewController = [[BayEditorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        bayEditorTableViewController.bayData = controller.bayData;
        bayEditorTableViewController.delegate = controller;
        
        [self.navigationController pushViewController:bayEditorTableViewController animated:YES];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            DailySummaryEditorSettingsTableViewController *newViewController = [[DailySummaryEditorSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            PDFGenerationTableViewController *newViewController = [[PDFGenerationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
