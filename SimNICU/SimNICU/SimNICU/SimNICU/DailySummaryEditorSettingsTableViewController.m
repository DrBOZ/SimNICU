//
//  DailySummaryEditorSettingsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryEditorSettingsTableViewController.h"
#import "DailySummaryEditorSettingsModel.h"
#import "CustomTextTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface DailySummaryEditorSettingsTableViewController ()

@property (nonatomic, strong) UISwitch *autocorrection;
@property (nonatomic, strong) UISwitch *trackball;

@end

@implementation DailySummaryEditorSettingsTableViewController
{
    NSMutableArray *tableData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Settings/Daily Summary Editor"];
    
    self.title = @"Daily Summary Editor";
    
    tableData = [DailySummaryEditorSettingsModel getArrayForTableView];
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
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (section == 0)
    {
        return [sectionData.rowData count];
    }
    if ([preferences.trackball intValue] == 1)
    {
        return [sectionData.rowData count];
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (section == 0)
    {
        return sectionData.titleForHeader;;
    }
    if ([preferences.trackball intValue] == 1)
    {
        return sectionData.titleForHeader;;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Autocorrection";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // lazy instantiation
            if (!self.autocorrection)
            {
                self.autocorrection = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
                
                // set target
                [self.autocorrection addTarget:self action:@selector(autocorrectionSwitchChangedValue) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    self.autocorrection.onTintColor = [UIColor redColor];
                }
            }
            
            // set value for switch
            self.autocorrection.on = [preferences.autocorrection intValue];
            
            // add to cell
            cell.accessoryView = self.autocorrection;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Trackball";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // lazy instantiation
            if (!self.trackball)
            {
                self.trackball = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
                
                // add target
                [self.trackball addTarget:self action:@selector(trackballSwitchChangedValue) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    self.trackball.onTintColor = [UIColor redColor];
                }
            }
            
            // set value for switch
            self.trackball.on = [preferences.trackball intValue];
            
            // add to cell
            cell.accessoryView = self.trackball;
            
            returnCell = cell;
        }
        else if (indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"Landscape";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.accessoryView = nil;
            
            returnCell = cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"Custom Text";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.accessoryView = nil;
        
        returnCell = cell;
    }
    
    returnCell.textLabel.text = rowData.text;
    returnCell.detailTextLabel.text = rowData.detailText;
    
    return returnCell;
}

- (void)autocorrectionSwitchChangedValue
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.autocorrection = [NSNumber numberWithInt:self.autocorrection.on];
}

- (void)trackballSwitchChangedValue
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.trackball = [NSNumber numberWithInt:self.trackball.on];
    
    // reload patient sections
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = indexPath;
    
    if (indexPath.section == 0)
    {
        path = nil;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTextTableViewController *vc = [[CustomTextTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.section = indexPath.row;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
