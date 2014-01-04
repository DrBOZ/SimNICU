//
//  FluidBalanceViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "FluidBalanceTableViewController.h"
#import "FluidTableViewCell.h"
#import "UnderlineLabel.h"
#import "AddFluidCell.h"

@interface FluidBalanceTableViewController () <UIPickerViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UILabel *totalInMlPerDay;
@property (nonatomic, strong) UILabel *totalInMlPerKgPerDay;

@property (nonatomic, strong) UILabel *totalOutMlPerDay;
@property (nonatomic, strong) UILabel *totalOutMlPerKgPerDay;

@end

@implementation FluidBalanceTableViewController
{
    float workingWeightKGAsFloat;
    double workingWeightKGAsDouble;
    
    // toggle variable to let UITableView know if to display date picker
    BOOL showDatePicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
#warning temporary code
        self.workingWeight = @"1.5";
        
        // setup dummy fluidBalanceData
        {
            self.fluidBalanceData = [[NSMutableDictionary alloc] init];
            
            [self.fluidBalanceData setObject:[NSDate date] forKey:@"FluidBalanceDate"];
            
            // INPUT array
            {
                NSMutableArray *inputData = [[NSMutableArray alloc] initWithCapacity:5];
                
                NSMutableArray *fluid1 = [[NSMutableArray alloc] initWithCapacity:2];
                
                /* create Fluid class
                 / for now create fluid NSSTring
                 */
                
                NSString *fluid1Name = @"10% Dextrose";
                NSNumber *fluid1MlPerDay = @0;
                
                [fluid1 addObject:fluid1Name];
                [fluid1 addObject:fluid1MlPerDay];
                
                [inputData addObject:fluid1];
                
                [self.fluidBalanceData setObject:inputData forKey:@"InputData"];
            }
            
            // OUTPUT array
            {
                NSMutableArray *outputData = [[NSMutableArray alloc] initWithCapacity:5];
                
                NSMutableArray *fluid2 = [[NSMutableArray alloc] initWithCapacity:2];
                
                NSString *fluid2Name = @"Urine";
                NSNumber *fluid2MlPerDay = @0;
                
                [fluid2 addObject:fluid2Name];
                [fluid2 addObject:fluid2MlPerDay];
                
                [outputData addObject:fluid2];
                
                [self.fluidBalanceData setObject:outputData forKey:@"OutputData"];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up buttons if used modally
    if (self.useAsModalViewController)
    {
        // set navigation item buttons and tint for iOS 7
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.view.tintColor = [UIColor redColor];
        }
    }
    
    // check if a working weight has been set - if no working weight then setup instructions
    if (!self.workingWeight)
    {
        self.tableView.tableFooterView = [self setupFooterView];
    }
    else
    {
        // instantiate date picker
        if (!self.datePicker)
        {
            self.datePicker = [UIDatePicker new];
        }
        
        if ([self.editOrAddFluidBalance isEqualToString:@"Edit"])
        {
            // log tracker
            [CBTrackers logEvent:@"Fluid Balance/Edit"];
            
            // hide date picker
            showDatePicker = NO;
            
            // set date
            // self.fluidBalanceDate = [self.sampleData objectForKey:@"Result Date"];
            
            // update date picker
            self.datePicker.date = self.fluidBalanceDate;
            
            // add sample results
            /*
             for (int section = 1; section < tableData.count - 1; section ++)
             {
             CBTableViewSectionData *sectionData = tableData[section];
             int rows = [sectionData.rowData count];
             
             for (int row = 0; row < rows; row ++)
             {
             CBTableViewRowData *rowData = sectionData.rowData[row];
             
             rowData.textField.text = [self.sampleData objectForKey:rowData.reference];
             }
             }
             */
        }
        else
        {
            // log tracker
            [CBTrackers logEvent:@"Fluid Balance/Add"];
            
            // show date picker
            showDatePicker = NO;
            
            // set default blood result date
            self.fluidBalanceDate = [NSDate date];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.workingWeight)
    {
        // goes through the entire string and replaces any commas with full stops in case
        // user is using a european locale
        NSString *UKLocaleWorkingWeight;
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        workingWeightKGAsDouble = [UKLocaleWorkingWeight doubleValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            // present weight as grams
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            self.title = [NSString stringWithFormat:@"%@ %ig", NSLocalizedString(@"Working weight", nil) ,workingWeightGRAMSAsInt];
        }
        else
        {
            // present weight as kilograms
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            // if using arabic locale, force to english
            if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
            {
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            }
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 3;
            
            self.title = [NSString stringWithFormat:@"%@ %@ kg", NSLocalizedString(@"Working weight", nil), [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Weight not entered", nil);
    }
    
    // starts UITableView in editing mode
    // [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
//    if ([self.editOrAddResult isEqualToString:@"Edit"])
//    {
//        // update sample data
//        [self updateSampleData];
//        
//        [self.delegate addBloodResultTableViewController:self didFinishEditingSampleData:self.sampleData];
//    }
//    else
//    {
//        self.sampleData = [NSMutableDictionary dictionary];
//        
//        // add a unique identifier
//        Preferences *preferences = [Preferences sharedPreferences];
//        
//        [self.sampleData setObject:preferences.bloodResultUniqueReferenceCounter forKey:@"Unique Reference"];
//        
//        // increment counter
//        int counter = [preferences.bloodResultUniqueReferenceCounter intValue];
//        counter ++;
//        preferences.bloodResultUniqueReferenceCounter = [NSNumber numberWithInt:counter];
//        
//        // add results to sample data
//        [self updateSampleData];
//        
//        NSString *displayResults = @"NO";
//        
//        [self.sampleData setObject:displayResults forKey:@"Display FBC"];
//        [self.sampleData setObject:displayResults forKey:@"Display Clotting"];
//        [self.sampleData setObject:displayResults forKey:@"Display Fibrinogen"];
//        [self.sampleData setObject:displayResults forKey:@"Display U&Es"];
//        [self.sampleData setObject:displayResults forKey:@"Display CRP"];
//        [self.sampleData setObject:displayResults forKey:@"Display LFTs"];
//        [self.sampleData setObject:displayResults forKey:@"Display Conjugated Bilirubin"];
//        [self.sampleData setObject:displayResults forKey:@"Display Bone Profile"];
//        [self.sampleData setObject:displayResults forKey:@"Display Magnesium"];
//        [self.sampleData setObject:displayResults forKey:@"Display Ammonia"];
//        
//        [self.delegate addBloodResultTableViewController:self didFinishAddingNewSampleData:self.sampleData];
//    }
}

//- (void)updateSampleData
//{
//    // add/update sample date
//    [self.sampleData setObject:self.resultDate forKey:@"Result Date"];
//    
//    // add/update sample results
//    for (int section = 1; section < tableData.count - 1; section ++)
//    {
//        CBTableViewSectionData *sectionData = tableData[section];
//        int rows = [sectionData.rowData count];
//        
//        for (int row = 0; row < rows; row ++)
//        {
//            CBTableViewRowData *rowData = sectionData.rowData[row];
//            
//            [self.sampleData setObject:rowData.textField.text forKey:rowData.reference];
//            
//            NSLog(@"Reference: %@ - Value: %@", rowData.reference, rowData.textField.text);
//        }
//    }
//}

- (void)cancel
{
    [self.delegate fluidBalanceTableViewControllerDidCancel:self];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.workingWeight)
    {
        // if adding a result (i.e. not editing) then do not show 'delete result' section
        if (![self.editOrAddFluidBalance isEqualToString:@"Edit"]) return 4;
        
        // show all sections, even date though might not have a row if used from main screen...
        else return 5;
    }
    else
    {
        // footer view stating that weight is required
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        switch (section)
        {
            // Date picker
            case 0:
                
                if (self.useAsModalViewController)
                {
                    if (showDatePicker) return 2;
                    else return 1;
                }
                
                else return 0;
                
                break;
             
            // INPUT
            case 1:
                
                return [[self.fluidBalanceData objectForKey:@"InputData"] count];
                
                break;
                
            // OUTPUT
            case 2:
                
                return [[self.fluidBalanceData objectForKey:@"OutputData"] count];
                
                break;
                
            // BALANCE
            case 3:
                
                return 0;
                
                break;
                
            default:
                
                return 0;
                
                break;
        }
    }
    
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 44.0f;
    
    if (section == 0) height = 0.0f;
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 1) return NSLocalizedString(@"IN", nil);
        
        else if (section == 2) return NSLocalizedString(@"OUT", nil);
        
        else if (section == 3) return NSLocalizedString(@"BALANCE", nil);
        
        else return nil;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) return 0.0f;
    
    else if (self.workingWeight)
    {
        if (section == 1 || section == 2) return 70.0f;
        
        else return 44.0f;
    }
    else return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 1 || section == 2)
        {
            CGFloat x = 230.0f;
            
            UIView *dailyInputResults = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
            
            // setup button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"addRow.png"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"addRow.png"] forState:UIControlStateHighlighted];
            button.frame = CGRectMake(8.0f, 9.0f, 30.0f, 30.0f);
            button.showsTouchWhenHighlighted = NO;
            button.tag = section;
            [button addTarget:self action:@selector(userPressedAddRowButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [dailyInputResults addSubview:button];
            
            // title
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, (320.0f - x), 22.0f)];
            title.text = (section) ? NSLocalizedString(@"Total OUT", nil) : NSLocalizedString(@"Total IN", nil);
            title.font = [UIFont systemFontOfSize:12.0f];
            
            [dailyInputResults addSubview:title];
            
            // ml/day
            UILabel *miscText = [[UILabel alloc] initWithFrame:CGRectMake(x, 22.0f, (320.0f - x), 22.0f)];
            miscText.font = [UIFont systemFontOfSize:12.0f];
            miscText.text = [CBStringMethods localisedString:@"90 ml/day"];
            
            [dailyInputResults addSubview:miscText];
            
            // ml/kg/day
            UILabel *miscText2 = [[UILabel alloc] initWithFrame:CGRectMake(x, 44.0f, (320.0f - x), 22.0f)];
            miscText2.font = [UIFont systemFontOfSize:12.0f];
            miscText2.text = [CBStringMethods localisedString:@"60 ml/kg/day"];
            
            [dailyInputResults addSubview:miscText2];
            
            return  dailyInputResults;
        }
        else if (section == 3)
        {
            CGFloat x = 90.0f;
            
            UIView *balanceResults = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
            
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, (320.0f - x), 44)];
            balance.font = [UIFont systemFontOfSize:19.0f];
            balance.text = @"+69 ml (+40 ml/kg)";
            
            [balanceResults addSubview:balance];
            
            return balanceResults;
        }
        else return nil;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0 && indexPath.row == 1 && showDatePicker)
    {
        height = 216.0f;
    }
//    else if (indexPath.section == 1 && indexPath.row == 2)
//    {
//        height = 216.0f;
//    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Date";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"24 Hour Period", nil);
            
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            
            cell.detailTextLabel.text = [formatter stringFromDate:self.fluidBalanceDate];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            
            return cell;
        }
        else
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
                self.datePicker.datePickerMode = UIDatePickerModeDate;
                
//                [self.datePicker addTarget:self
//                                    action:@selector(datePickerChangedValue)
//                          forControlEvents:UIControlEventValueChanged];
                
                [cell.contentView addSubview:self.datePicker];
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        CellIdentifier = [NSString stringWithFormat:@"IN - %i", indexPath.row];
        
        FluidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[FluidTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.mlPerDay.text = [[self.fluidBalanceData objectForKey:@"InputData"][indexPath.row][1] stringValue];
            cell.mlPerDay.tag = (indexPath.section * 100) + indexPath.row;
            cell.mlPerDay.delegate = self;
        }
        
        cell.textLabel.text = [self.fluidBalanceData objectForKey:@"InputData"][indexPath.row][0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i ml/kg/%@", [self calculateMlPerKgPerDay:[[self.fluidBalanceData objectForKey:@"InputData"][indexPath.row][1] doubleValue]], NSLocalizedString(@"day", nil)];
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        CellIdentifier = [NSString stringWithFormat:@"OUT - %i", indexPath.row];
        
        FluidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[FluidTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.mlPerDay.text = [[self.fluidBalanceData objectForKey:@"OutputData"][indexPath.row][1] stringValue];
            cell.mlPerDay.tag = (indexPath.section * 100) + indexPath.row;
            cell.mlPerDay.delegate = self;
        }
        
        cell.textLabel.text = [self.fluidBalanceData objectForKey:@"OutputData"][indexPath.row][0];
        cell.detailTextLabel.text = @"40 ml/kg/day";
        
        return cell;
    }
    else return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            return NO;
        }
        else return YES;
    }
    else return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert;
}

- (UIView *)setupFooterView
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    float height = 50.0f;
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        height = 110.0f; // 4 inch Retina
    }
    else
    {
        height = 70.0f; // 3.5 inch Retina
    }
    
    // Instructions, as no working weight entered...
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 300.0f)];
    
    UIView *instructions = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, 0.0f, 200.0f)];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 150.0f)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = UITextAlignmentCenter;
    text.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    text.shadowColor = [UIColor whiteColor];
    text.shadowOffset = CGSizeMake(0.0f, 1.0f);
    text.numberOfLines = 0;
    text.font = [UIFont boldSystemFontOfSize:15.0f];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        text.text = NSLocalizedString(@"A weight is needed for this calculator.\n\nPlease go back and enter a weight or gestation, or select a patient.", nil);
    }
    else
    {
        text.text = NSLocalizedString(@"A weight is needed for this calculator.\n\nPlease go back and press the          \nbutton, or slide the image to the right,\nand enter a weight or gestation\nor select a patient.", nil);
        
        UIImageView *plusButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusButton2.png"]];
        plusButton.frame = CGRectMake(270.0f, 36.0f, 40.0f, 40.0f);
        [instructions addSubview:plusButton];
    }
    
    [instructions addSubview:text];
    
    UnderlineLabel *thankYou = [[UnderlineLabel alloc] initWithFrame:CGRectMake(0.0f, 136.0f, 320.0f, 44.0f)];
    thankYou.backgroundColor = [UIColor clearColor];
    thankYou.textAlignment = UITextAlignmentCenter;
    thankYou.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    thankYou.shadowColor = [UIColor whiteColor];
    thankYou.shadowOffset = CGSizeMake(0.0f, 1.0f);
    thankYou.numberOfLines = 1;
    thankYou.start = 122.0f;
    thankYou.end = 197.0f;
    thankYou.font = [UIFont boldSystemFontOfSize:15.0f];
    thankYou.text = @"Thank you.";
    [instructions addSubview:thankYou];
    
    [footerView addSubview:instructions];
    
    return footerView;
}

#pragma mark UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 4) return indexPath;
    else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        showDatePicker = !showDatePicker;
        
        // update table
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
//    else if (indexPath.section == tableData.count - 1)
//    {
//        // should implement a second check to see if user really wants to do this
//        UIActionSheet *confirmDelete = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Result will be permanently deleted", nil)
//                                                                   delegate:self
//                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
//                                                     destructiveButtonTitle:NSLocalizedString(@"Delete", @"")
//                                                          otherButtonTitles:nil];
//		[confirmDelete showInView:self.view];
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for (int section = 1; section <= 2; section ++)
    {
        NSString *sectionName = (section - 1) ? @"OutputData" : @"InputData";
        
        int rows = [[self.fluidBalanceData objectForKey:sectionName] count];
        
        for (int row = 0; row < rows; row ++)
        {
            FluidTableViewCell *cell = (FluidTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            
            [cell.mlPerDay resignFirstResponder];
        }
    }
}

- (void)userPressedAddRowButton:(UIButton *)sender
{
    // determine section button relates to
    NSString *section = (sender.tag - 1) ? @"OutputData" : @"InputData";
    
    // create new fluid data
    NSMutableArray *fluid = [[NSMutableArray alloc] initWithCapacity:2];
    
    // set fluid name
    NSString *fluidName = [NSString stringWithFormat:@"Fluid %i", ([[self.fluidBalanceData objectForKey:section] count] + 1)];
    
    [fluid addObject:fluidName];
    [fluid addObject:@0];
    
    [[self.fluidBalanceData objectForKey:section] addObject:fluid];
    
    // update table
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:([[self.fluidBalanceData objectForKey:section] count] - 1)
                                               inSection:sender.tag]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    for (int section = 1; section < tableData.count - 1; section ++) // '- 1' for delete button
//    {
//        CBTableViewSectionData *sectionData = tableData[section];
//        int rows = [sectionData.rowData count];
//        
//        for (int row = 0; row < rows; row ++)
//        {
//            CBTableViewRowData *rowData = sectionData.rowData[row];
//            
//            if (textField.tag == rowData.textField.tag)
//            {
//                // scroll up to middle
//                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
//                
//                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//            }
//        }
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    FluidTableViewCell *cell;
    
    NSString *sectionName;
    
    int section = (textField.tag) / 100;
    int row;
    
    if (section == 1)
    {
        sectionName = @"InputData";
        
        row = textField.tag - 100;
    }
    else
    {
        sectionName = @"OutputData";
        row = textField.tag - 200;
    }
    
    // update results
    [self.fluidBalanceData objectForKey:sectionName][row][1] = [NSNumber numberWithDouble:[textField.text doubleValue]];
    
    [self updateResults];
//    cell = (FluidTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i ml/kg/%@", [self calculateMlPerKgPerDay:[[self.fluidBalanceData objectForKey:sectionName][row][1]] doubleValue], NSLocalizedString(@"day", nil)];
}

- (int)calculateMlPerKgPerDay:(double)mlPerDayDouble
{
    double result;
    
    result = mlPerDayDouble / workingWeightKGAsDouble;
    
    return result;
}

- (void)updateResults
{
    double totalIn = 0.0f;
    double totalOut = 0.0f;
    double balance = 0.0f;
    
    // loop through all of the cells
    for (int section = 1; section <= 2; section ++)
    {
        NSString *sectionName = (section - 1) ? @"OutputData" : @"InputData";
        
        int rows = [[self.fluidBalanceData objectForKey:sectionName] count];
        
        for (int row = 0; row < rows; row ++)
        {
            FluidTableViewCell *cell = (FluidTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            
            double mlperDayDouble = [[self.fluidBalanceData objectForKey:sectionName][row][1] doubleValue];
            
            // update individual fluids 'ml/kg/day'
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i ml/kg/%@", [self calculateMlPerKgPerDay:mlperDayDouble], NSLocalizedString(@"day", nil)];
            
            // update footer calculations
            if ([sectionName isEqualToString:@"InputData"])
            {
                totalIn = totalIn + mlperDayDouble;
            }
            else
            {
                totalOut = totalOut + mlperDayDouble;
            }
            
        }
    }
    
    // update balance
    balance = totalIn - totalOut;
    
    NSLog(@"Total In  = %f", totalIn);
    
    NSLog(@"Total Out = %f", totalOut);
    
    NSLog(@"Balance   = %F", balance);
    
    // update labels
}

@end
