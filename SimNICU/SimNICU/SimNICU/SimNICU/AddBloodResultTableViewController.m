//
//  AddBloodResultTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AddBloodResultTableViewController.h"
#import "CBTableViewSectionData.h"
#import "AddBloodResultModel.h"
#import "CBTableViewRowData.h"

@interface AddBloodResultTableViewController () <UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation AddBloodResultTableViewController
{
    // obtained from AddBloodResultModel
    NSArray *tableData;
    
    // toggle variable to let UITableView know if to display date picker
    BOOL showDatePicker;
    
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set navigation item buttons and tint for iOS 7
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.view.tintColor = [UIColor redColor];
    }
    
    // instantiate date picker
    if (!self.datePicker)
    {
        self.datePicker = [UIDatePicker new];
    }
	
    // get table data
    tableData = [AddBloodResultModel getArrayForTableViewInBloodResultOrder:self.bloodResultOrder];
    
    // setup view controller
    {
        if ([self.editOrAddResult isEqualToString:@"Edit"])
        {
            // log tracker
            [CBTrackers logEvent:@"Edit Blood Result"];
            
            // set title
            self.title = NSLocalizedString(@"Edit Result", nil);
            
            // hide date picker
            showDatePicker = NO;
            
            // set date
            self.resultDate = [self.sampleData objectForKey:@"Result Date"];
            
            // update date picker
            self.datePicker.date = self.resultDate;
        }
        else
        {
            // log tracker
            [CBTrackers logEvent:@"Add Blood Result"];
            
            // set title
            self.title = NSLocalizedString(@"Add Result", nil);
            
            // show date picker
            showDatePicker = YES;
            
            // set default blood result date
            self.resultDate = [NSDate date];
        }
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
    
    switch (section)
    {
        // date and time
        case 0:
            
            if (showDatePicker) return 2;
            else return 1;
            
            break;
            
        default:
            
            return rows;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0 && indexPath.row == 1 && showDatePicker)
    {
        height = 216.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    if (sectionData.titleForHeader) return 44.0f;
    else return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == (tableData.count - 1))
    {
        return 300.0f;
    }
    else return 0.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CBTableViewSectionData *sectionData = tableData[section];
    
    return NSLocalizedString(sectionData.titleForHeader, nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Date and Time";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Sample Date/Time", nil);
            
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterShortStyle;
            
            cell.detailTextLabel.text = [formatter stringFromDate:self.resultDate];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            if (showDatePicker)
            {
                static NSString *CellIdentifier = @"Date Picker";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    // self.datePicker = [UIDatePicker new];
                    self.datePicker.frame = CGRectMake(0.0f, 0.0f, 320.0f, 300.0f);
                    
                    [self.datePicker addTarget:self
                                        action:@selector(datePickerChangedValue)
                              forControlEvents:UIControlEventValueChanged];
                    
                    [cell.contentView addSubview:self.datePicker];
                }
                
                return cell;
            }
            else
            {
                static NSString *CellIdentifier = @"Previous Results";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                cell.textLabel.text = NSLocalizedString(@"Previous Results", nil);
                
                return cell;
            }
            
        }
        else
        {
            static NSString *CellIdentifier = @"Previous Results";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Previous Results", nil);
            
            return cell;
        }
    }
    else
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"%i - %i", indexPath.section, indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        CBTableViewSectionData *sectionData = tableData[indexPath.section];
        CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            cell.textLabel.text = NSLocalizedString(rowData.text, nil);
            
            rowData.textField.frame = CGRectMake(1.0f, 1.0f, 120.0f, 30.0f);
            rowData.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            rowData.textField.keyboardAppearance = UIKeyboardAppearanceAlert;
            rowData.textField.clearButtonMode = UITextFieldViewModeAlways;
            rowData.textField.borderStyle = UITextBorderStyleRoundedRect;
            rowData.textField.keyboardType = UIKeyboardTypeDecimalPad;
            rowData.textField.textAlignment = UITextAlignmentLeft;
            rowData.textField.placeholder = nil;
            rowData.textField.delegate = self;
            
            cell.accessoryView = rowData.textField;
        }
        
        rowData.textField.text = [self.sampleData objectForKey:rowData.reference];
        
        return cell;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (int section = 1; section < [tableData count]; section ++)
    {
        CBTableViewSectionData *sectionData = tableData[section];
        int rows = [sectionData.rowData count];
        
        for (int row = 0; row < rows; row ++)
        {
            CBTableViewRowData *rowData = sectionData.rowData[row];
            
            [rowData.textField resignFirstResponder];
        }
    }
}

#pragma mark UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return indexPath;
    else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        showDatePicker = !showDatePicker;
        
        // update table
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    
    for (int section = 1; section < [tableData count]; section ++)
    {
        CBTableViewSectionData *sectionData = tableData[section];
        int rows = [sectionData.rowData count];
        
        for (int row = 0; row < rows; row ++)
        {
            CBTableViewRowData *rowData = sectionData.rowData[row];
            
            if (textField.tag == rowData.textField.tag)
            {
                // scroll up to middle
                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                
                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
}

# pragma mark

- (void)datePickerChangedValue
{
    self.resultDate = self.datePicker.date;
    
    // update the 'Sampe Date/Time' row with the new date
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)done
{
    self.sampleData = [NSMutableDictionary dictionary];
    
    // add a unique identifier
    Preferences *preferences = [Preferences sharedPreferences];
    
    [self.sampleData setObject:preferences.bloodResultUniqueReferenceCounter forKey:@"Unique Reference"];
    
    // increment counter
    int counter = [preferences.bloodResultUniqueReferenceCounter intValue];
    counter ++;
    preferences.bloodResultUniqueReferenceCounter = [NSNumber numberWithInt:counter];
    
    // add sample date
    [self.sampleData setObject:self.resultDate forKey:@"Result Date"];
    
    // add sample results
    for (int section = 1; section < [tableData count]; section ++)
    {
        CBTableViewSectionData *sectionData = tableData[section];
        int rows = [sectionData.rowData count];
        
        for (int row = 0; row < rows; row ++)
        {
            CBTableViewRowData *rowData = sectionData.rowData[row];
            
            [self.sampleData setObject:rowData.textField.text forKey:rowData.reference];
        }
    }
    
    NSString *displayResults = @"NO";
    
    [self.sampleData setObject:displayResults forKey:@"Display FBC"];
    [self.sampleData setObject:displayResults forKey:@"Display Clotting"];
    [self.sampleData setObject:displayResults forKey:@"Display Fibrinogen"];
    [self.sampleData setObject:displayResults forKey:@"Display U&Es"];
    [self.sampleData setObject:displayResults forKey:@"Display CRP"];
    [self.sampleData setObject:displayResults forKey:@"Display LFTs"];
    [self.sampleData setObject:displayResults forKey:@"Display Conjugated Bilirubin"];
    [self.sampleData setObject:displayResults forKey:@"Display Bone Profile"];
    [self.sampleData setObject:displayResults forKey:@"Display Magnesium"];
    [self.sampleData setObject:displayResults forKey:@"Display Ammonia"];
    
    [self.delegate addBloodResultTableViewControllerDidFinish:self withSampleData:self.sampleData];
}

- (void)cancel
{
    [self.delegate addBloodResultTableViewControllerDidCancel:self];
}

@end
