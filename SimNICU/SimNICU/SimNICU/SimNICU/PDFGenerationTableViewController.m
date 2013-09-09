//
//  PDFGenerationTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PDFGenerationTableViewController.h"
#import "PaperSizeTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface PDFGenerationTableViewController () <PaperSizeTableViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITextView *signatureTextView;

@end

@implementation PDFGenerationTableViewController
{
    NSMutableArray *tableData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
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
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Hospital Logo";
    [sectionData.rowData addObject:rowData];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Unit Address";
    [sectionData.rowData addObject:rowData];
    
    /*
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Signature";
    [sectionData.rowData addObject:rowData];
     */
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    if (section == 0)
    {
        CBTableViewSectionData *sectionData = tableData[section];
        
        rows = [sectionData.rowData count];
    }
    else
    {
        rows = 1;
    }
    
    return rows;
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
        CBTableViewSectionData *sectionData = tableData[section];
        header = sectionData.titleForHeader;
    }
    else
    {
        header = @"Signature";
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44.0f;
    
    if (indexPath.section == 1)
    {
        height = 110.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Paper Size";
            cell.detailTextLabel.text = preferences.paperSize;
        }
        else
        {
            CBTableViewSectionData *sectionData = tableData[indexPath.section];
            CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
            
            cell.textLabel.text = rowData.text;
            cell.detailTextLabel.text = rowData.detailText;
        }
    }
    else if (indexPath.section == 1)
    {
        // create signature cell
        cell.textLabel.text = nil;;
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        self.signatureTextView = [[UITextView alloc] init];
        self.signatureTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 100.0f);
        self.signatureTextView.font = [UIFont systemFontOfSize:16.0f];
        self.signatureTextView.scrollEnabled = NO;
        self.signatureTextView.delegate = self;
        
        self.signatureTextView.text = preferences.signature;
        
        [cell.contentView addSubview:self.signatureTextView];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // paperSize
        PaperSizeTableViewController *newViewController = [[PaperSizeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        newViewController.delegate = self;
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL allowUserToEnterText = YES;
    
    // develop a way to limit the textView to 4 lines...
    
    return allowUserToEnterText;
}

- (void)textViewDidChange:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.signature = textView.text;
}

#pragma mark - PaperSizeTableViewControllerDelegate

- (void)paperSizeTableViewController:(PaperSizeTableViewController *)controller didSelectPaperSize:(NSString *)paperSize
{
    [self.tableView reloadData];
}

@end
