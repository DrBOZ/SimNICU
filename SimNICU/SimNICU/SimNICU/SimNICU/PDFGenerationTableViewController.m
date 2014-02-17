//
//  PDFGenerationTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PDFGenerationTableViewController.h"
#import "CBPhotoCropperViewController.h"
#import "PaperSizeTableViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"

@interface PDFGenerationTableViewController () <PaperSizeTableViewControllerDelegate, UITextViewDelegate, CBPhotoCropperDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *signatureTextView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UISwitch *grayscaleSwitch;
@property (nonatomic, strong) UISwitch *borderSwitch;

@end

@implementation PDFGenerationTableViewController
{
    NSMutableArray *tableData;
    
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Settings/PDF Generation"];
    
    self.title = NSLocalizedString(@"PDF Settings", nil);
    
    // setup back bar button with long press gesture
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:self
                                                                                                                       action:@selector(backButtonPressed)
                                                                                                              longPressTarget:self
                                                                                                              longPressAction:@selector(backButtonLongPressed)];
    
    tableData = [[NSMutableArray alloc] initWithCapacity:2];
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
    rowData.text = @"Border";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
    
    // section 1
    sectionData = [[CBTableViewSectionData alloc] init];
    sectionData.titleForHeader = @"Printing";
    sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
    
    rowData = [[CBTableViewRowData alloc] init];
    rowData.text = @"Grayscale";
    [sectionData.rowData addObject:rowData];
    
    [tableData addObject:sectionData];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITable view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    if (section == 0 || section == 1)
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
    
    if (section == 0 || section == 1)
    {
        CBTableViewSectionData *sectionData = tableData[section];
        header = sectionData.titleForHeader;
    }
    else if (section == 2)
    {
        header = @"Hospital Logo";
    }
    else if (section == 3)
    {
        header = @"Name & Designation";
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44.0f;
    
    if (indexPath.section == 2)
    {
        height = 110.0f;
    }
    else if (indexPath.section == 3)
    {
        height = 110.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        return 240.0f;
    }
    else return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Paper Size";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Paper Size";
            cell.detailTextLabel.text = preferences.paperSize;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Border";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Border";
            
            if (!self.borderSwitch)
            {
                self.borderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
                [self.borderSwitch addTarget:self
                                      action:@selector(switchChangedValue:)
                            forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    self.borderSwitch.onTintColor = [UIColor redColor];
                }
            }
            
            self.borderSwitch.on = [preferences.border intValue];
            cell.accessoryView = self.borderSwitch;
            cell.detailTextLabel.text = nil;
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"Misc";
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
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Grayscale";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Grayscale";
            
            if (!self.grayscaleSwitch)
            {
                self.grayscaleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
                [self.grayscaleSwitch addTarget:self
                                         action:@selector(switchChangedValue:)
                               forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    self.grayscaleSwitch.onTintColor = [UIColor redColor];
                }
            }
            
            self.grayscaleSwitch.on = [preferences.grayscale intValue];
            cell.accessoryView = self.grayscaleSwitch;
            cell.detailTextLabel.text = nil;
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"Logo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        // Hospital Logo
        
        // Preferences singleton
        Preferences *preferences = [Preferences sharedPreferences];
        
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!self.logoImageView)
        {
            self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 25.0f, 250.0f, 54.0f)];
        }
        
        self.logoImageView.image = preferences.image;
        
        [cell.contentView addSubview:self.logoImageView];
        
        returnCell = cell;
    }
    else if (indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"Name & Designation";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        // create signature cell
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = nil;
        
        self.signatureTextView = [[UITextView alloc] init];
        self.signatureTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 100.0f);
        self.signatureTextView.font = [UIFont systemFontOfSize:16.0f];
        self.signatureTextView.scrollEnabled = NO;
        self.signatureTextView.delegate = self;
        
        self.signatureTextView.text = preferences.signature;
        
        [cell.contentView addSubview:self.signatureTextView];
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (void)switchChangedValue:(UISwitch *)sender
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([sender isEqual:self.borderSwitch])
    {
        preferences.border = [NSNumber numberWithInt:self.borderSwitch.on];
    }
    else if ([sender isEqual:self.grayscaleSwitch])
    {
        preferences.grayscale = [NSNumber numberWithInt:self.grayscaleSwitch.on];
    }
}

#pragma mark - UITable view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.signatureTextView resignFirstResponder];
    
    NSIndexPath *path = indexPath;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            path = nil;
        }
    }
    else if (indexPath.section == 1)
    {
        path = nil;
    }
    else if (indexPath.section == 3)
    {
        path = nil;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            // paperSize
            PaperSizeTableViewController *newViewController = [[PaperSizeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            newViewController.delegate = self;
    
            [self.navigationController pushViewController:newViewController animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        CBPhotoCropperViewController *newViewController = [[CBPhotoCropperViewController alloc] init];
        newViewController.delegate = self;
        newViewController.photo = preferences.image;
        
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // move tableview up
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // create string with new text
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    // work out the size of the old text
    CGSize oldSize = [textView.text sizeWithFont:textView.font constrainedToSize:CGSizeMake(textView.frame.size.width, textView.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    // create a larger text size to compare any word wrap
    CGSize tallerSize = CGSizeMake(textView.frame.size.width - 20.0f, textView.frame.size.height * 2);
    
    // work out the size of the new text in the larger rect
    CGSize newSize = [newText sizeWithFont:textView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
    
    // 84.0f is the max height of the UITextView I am using
    if (newSize.height > 84.0f)
    {
        return NO;
    }
    else
    {
        // size doesn't increase if the user enters a carriage return,(but it does still word wrap), so check for this
        if (oldSize.height == 84.0f && [text isEqualToString:@"\n"])
        {
            return NO;
        }
        else
        {
            // this is to prevent word wrapping
            if (!([text isEqualToString:@"\n"]) && (newSize.height > oldSize.height)) // ie a character
            {
                return NO;
            }
            else
                return YES;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.signature = textView.text;
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // check if textview has focus
    if ([self.signatureTextView isFirstResponder])
    {
        // lose keyboard
        [self.signatureTextView resignFirstResponder];
        
        // other way to do it is to reset footer height and update table
        
        // scroll tableView back
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - PaperSizeTableViewControllerDelegate

- (void)paperSizeTableViewController:(PaperSizeTableViewController *)controller didSelectPaperSize:(NSString *)paperSize
{
    [self.tableView reloadData];
}

#pragma mark - CBPhotoCropper delegate

- (void)photoCropperDidCancel:(CBPhotoCropperViewController *)photoCropper
{
    
}

- (void)photoCropper:(CBPhotoCropperViewController *)photoCropper didCropPhoto:(UIImage *)photo
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.image = photo;
    
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
