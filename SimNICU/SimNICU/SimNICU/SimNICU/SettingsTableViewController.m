//
//  SettingsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PDFGenerationTableViewController.h"
#import "SettingsTableViewController.h"
#import "EnterWeightViewController.h"
#import "BayEditorViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface SettingsTableViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation SettingsTableViewController
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
    
    [CBTrackers logEvent:@"Settings"];
    
    self.title = @"Settings";
    
    // setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"General";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Corrected Age";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Fluid Requirements";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Intubation";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Phototherapy";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Patient List";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Bay Editor";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Daily Summary Editor";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"PDF Generation";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#if SYNCRONISATION_PREVIEW_MODE
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Syncronisation";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Local";
    rowData.detailText = @"4/9/2013 08:00";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"iCloud";
    rowData.detailText = @"Off";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#endif
    
#if LOCALISATION_PREVIEW_MODE
    
    // section 3
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Localisation";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Language";
    rowData.detailText = @"UK English";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Decimal Separator";
    rowData.detailText = @"Point";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
#endif
    
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

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
             EnterWeightViewController *controller = (EnterWeightViewController *)appDelegate.revealController.rearViewController;
            
            // Bay Editor
            BayEditorViewController *bayEditorViewController = [[BayEditorViewController alloc] init];
            bayEditorViewController.bayData = controller.bayData;
            bayEditorViewController.delegate = controller;
            
            [self.navigationController pushViewController:bayEditorViewController animated:YES];
        }
        else if (indexPath.row == 2)
        {
            PDFGenerationTableViewController *newViewController = [[PDFGenerationTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            newViewController.paperSize = self.preferences.paperSize;
            
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
