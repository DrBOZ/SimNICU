//
//  PDFGenerationTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PDFGenerationTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface PDFGenerationTableViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation PDFGenerationTableViewController
{
    NSMutableArray *tableData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Settings/PDF Generation"];
    
    self.title = @"PDF Settings";
    
    tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"General";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Paper Size";
    rowData.detailText = @"A4";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Hospital Logo";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Unit Address";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Signature";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
