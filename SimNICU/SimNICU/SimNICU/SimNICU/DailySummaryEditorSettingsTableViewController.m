//
//  DailySummaryEditorSettingsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryEditorSettingsTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface DailySummaryEditorSettingsTableViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

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
    
    tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Text Entry";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Autocorrection";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Trackball";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Landscape allowed";
    rowData.detailText = @"This should not be an option!";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.tableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
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
    
    return [sectionData.rowData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0)
    {
        header = @"Text Entry";
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Switch";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (!self.autocorrection)
            {
                self.autocorrection = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
            }
            
            cell.accessoryView = self.autocorrection;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Switch";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (!self.trackball)
            {
                self.trackball = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
            }
            
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
        static NSString *CellIdentifier = @"Misc";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.accessoryView = nil;
        
        returnCell = cell;
    }
    
    returnCell.textLabel.text = rowData.text;
    returnCell.detailTextLabel.text = rowData.detailText;
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
