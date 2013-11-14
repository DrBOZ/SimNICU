//
//  CrUSSOptionsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CrUSSOptionsTableViewController.h"
#import "PortraitOnlyNavigationController.h"
#import "CrUSSRadiologyViewController.h"
#import "CBTableViewSectionData.h"
#import "CrUSSViewController.h"
#import "CBTableViewRowData.h"

@interface CrUSSOptionsTableViewController ()

@end

@implementation CrUSSOptionsTableViewController
{
    NSMutableArray *tableData;
}

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
    
    [CBTrackers logEvent:@"CrUSS Options"];
    
    self.title = @"Cranial Ultrasound";
    
    tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"General Information";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Indications & Timings";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Technique";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Holding the probe";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Standard sequence";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Measuring ventricular index";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 2
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Example Scans";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:5];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Image viewer";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CrUSSViewController *newViewController = [[CrUSSViewController alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == 2)
    {
        CrUSSRadiologyViewController *newViewController = [[CrUSSRadiologyViewController alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
