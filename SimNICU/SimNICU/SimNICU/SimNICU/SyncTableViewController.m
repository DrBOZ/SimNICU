//
//  SyncTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "ConnectionViewController.h"
#import "SyncTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "SyncServer.h"
#import "SyncClient.h"

@interface SyncTableViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@end

@implementation SyncTableViewController
{
    NSMutableArray *tableData;
    SyncServer *_Server;
    SyncClient *_Client;
    
    NSString *connectionStatus;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        connectionStatus = @"Inactive";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Sync"];
    
    self.title = @"Sync";
    
    // setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    tableData = [[NSMutableArray alloc] initWithCapacity:3];
    CBTableViewSectionData *sectionData;
    CBTableViewRowData *rowData;
    
    // section 0
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Connection";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Connection Status";
    rowData.detailText = connectionStatus;
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Number of Devices";
    rowData.detailText = @"4";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Transfer";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Start hosting";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Connect to host";
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
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            ConnectionViewController *newViewController = [[ConnectionViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            /*
            if (!_Server)
            {
                _Server = [[SyncServer alloc] init];
                _Server.maxClients = 10;
                [_Server startAcceptingConnectionsForSessionID:SESSION_ID];
                
                CBTableViewSectionData *sectionData;
                CBTableViewRowData *rowData;
                
                sectionData = tableData[0];
                rowData = sectionData.rowData[0];
                rowData.detailText = @"Host";
                
                [self.tableView reloadData];
            }
             */
        }
        else if (indexPath.row == 1)
        {
            /*
            if (!_Client)
            {
                _Client = [[SyncClient alloc] init];
                [_Client startSearchingForServersWithSessionID:SESSION_ID];
                _Client.delegate = self;
            }
            
            CBTableViewSectionData *sectionData;
            CBTableViewRowData *rowData;
            
            sectionData = tableData[0];
            rowData = sectionData.rowData[0];
            rowData.detailText = @"Client";
            
            [self.tableView reloadData];
             */
        }
    }
    else
    {
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
