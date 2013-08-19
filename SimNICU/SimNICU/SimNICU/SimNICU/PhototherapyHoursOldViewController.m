//
//  PhototherapyPreGraphViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyHoursOldViewController.h"
#import "PhototherapyGraphViewController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"

@interface PhototherapyHoursOldViewController ()

@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, retain) UITextField *birthDateTextField;
@property (nonatomic, retain) UITextField *birthTimeTextField;
@property (nonatomic, retain) UITextField *dateTextField;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSString *formattedAge;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, strong) NSNumber *ageInDays;

- (void)birthTimeWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)dateButtonTapped:(UIBarButtonItem *)sender;
- (void)selectABirthDate:(id)sender;
- (void)selectABirthTime:(id)sender;
- (void)selectADate:(id)sender;

@end

@implementation PhototherapyHoursOldViewController
#warning check this out
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Sample Age";
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 50.0f;  // was 44.0f
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        // self.myTableView.sectionFooterHeight = 10.0f;
        // self.myTableView.sectionHeaderHeight = 10.0f;
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.hidden = NO;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Phototherapy/Graph/Add Bili/Hours Old" withError:nil];
    
#endif
    
    [Flurry logEvent:@"PhototherapyHoursOld: viewDidAppear"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.dateAndTimeOfBirth = nil;
    self.birthDateTextField = nil;
    self.actionSheetPicker = nil;
    self.dateTextField = nil;
    self.selectedDate = nil;
    self.formattedAge = nil;
    self.selectedDate = nil;
    self.myTableView = nil;
    self.ageInDays = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyHoursOldViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyHoursOldViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if (self.ageInDays && self.formattedAge)
        {
            [self.delegate phototherapyHoursOldViewController:self didFinishAddingAgeInDays:self.ageInDays formattedAge:self.formattedAge forBirthDate:self.dateAndTimeOfBirth];
        }
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"birthDateAndTime";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Birth";
        
        self.birthDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 180.0f, 30.0f)];
        self.birthDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.birthDateTextField.textAlignment = UITextAlignmentCenter;
        self.birthDateTextField.adjustsFontSizeToFitWidth = YES;
        self.birthDateTextField.userInteractionEnabled = NO;
        self.birthDateTextField.delegate = self;
        
        if (self.selectedPatient)
        {
            if (self.selectedPatient.birthDate)
            {
                // check if birth time has been set.
                if ([self.selectedPatient.birthTimeSet isEqualToString:@"YES"])
                {
                    // if yes then display and lock birth date and time.
                    self.birthDateTextField.borderStyle = UITextBorderStyleNone;
                
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeZone:[NSTimeZone localTimeZone]];
                    [formatter setTimeStyle:NSDateFormatterShortStyle];
                    
                    self.birthDateTextField.text = [formatter stringFromDate:self.selectedPatient.birthDate];
                    self.dateAndTimeOfBirth = self.selectedPatient.birthDate;
                    
                    cell.accessoryView = self.birthDateTextField;
                }
                else
                {
                    self.birthDateTextField.borderStyle = UITextBorderStyleRoundedRect;
                    self.birthDateTextField.clearButtonMode = UITextFieldViewModeNever;
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterMediumStyle];
                    [formatter setTimeZone:[NSTimeZone localTimeZone]];
                    [formatter setTimeStyle:NSDateFormatterNoStyle];
                    
                    self.birthDateTextField.text = [NSString stringWithFormat:@"%@ enter time", [formatter stringFromDate:self.selectedPatient.birthDate]];
                    
                    cell.accessoryView = self.birthDateTextField;
                }
            }
            else
            {
                // no birthdate entered!
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Warning"
                                          message:@"Birth date not entered for this patient"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
                
                // allow user to cancel and start again,
                //
                // alternatively, allow to continue to enter birth date and time, which
                // should be then entered into array and displayed on viewController exit.
            }
        }
        else
        {
            self.birthDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 180.0f, 30.0f)];
            self.birthDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
            // if date and time of birth have already been set, then remove rounded rect border
            if (self.dateAndTimeOfBirth)
            {
                self.birthDateTextField.borderStyle = UITextBorderStyleNone;
            }
            else
            {
                self.birthDateTextField.borderStyle = UITextBorderStyleRoundedRect;
            }
            
            self.birthDateTextField.placeholder = @"date and time of birth";
            self.birthDateTextField.textAlignment = UITextAlignmentCenter;
            self.birthDateTextField.adjustsFontSizeToFitWidth = YES;
            self.birthDateTextField.userInteractionEnabled = NO;
            self.birthDateTextField.delegate = self;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            if (self.dateAndTimeOfBirth)
            {
                self.birthDateTextField.text = [formatter stringFromDate:self.dateAndTimeOfBirth];
            }
            else if (self.selectedPatient.birthDate)
            {
                self.birthDateTextField.text = [formatter stringFromDate:self.selectedPatient.birthDate];
            }
            
            cell.accessoryView = self.birthDateTextField;
        }
        
        returnCell = cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"CurrentDateAndTime";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 180.0f, 30.0f)];
        self.dateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.dateTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.dateTextField.clearButtonMode = UITextFieldViewModeNever;
        self.dateTextField.placeholder = @"date and time of sample";
        self.dateTextField.textAlignment = UITextAlignmentCenter;
        self.dateTextField.adjustsFontSizeToFitWidth = YES;
        self.dateTextField.userInteractionEnabled = NO;
        self.dateTextField.delegate = self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
        
        cell.accessoryView = self.dateTextField;
        cell.textLabel.text = @"Sample";
        
        returnCell = cell;
    }
    else if(indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"Sample Age";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Sample Age";
        
        if (self.formattedAge)
        {
            cell.detailTextLabel.text = self.formattedAge;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    // if birthdate set then don't allow to change
    if (indexPath.row == 0)
    {
        if (!self.dateAndTimeOfBirth && !self.selectedPatient.birthTimeSet)
        {
            path = indexPath;
        }
    }
    else if (indexPath.row == 1)
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        if (self.selectedPatient)
        {
            if (!self.dateAndTimeOfBirth && !self.selectedPatient.birthTimeSet)
            {
                [self selectABirthTime:self.birthDateTextField];
            }
            else
            {
                [self selectABirthDate:self.birthDateTextField];
            }
        }
        else
        {
            [self selectABirthDate:self.birthDateTextField];
        }
    }
    else if (indexPath.row == 1)
    {
        [self selectADate:self.dateTextField];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - actions

- (void)selectABirthDate:(UIControl *)sender
{
    // if selected patient has a birth date entered then present picker with this date, otherwise present current date
    if (self.selectedPatient.birthDate)
    {
        self.dateAndTimeOfBirth = self.selectedPatient.birthDate;
    }
    else
    {
        self.dateAndTimeOfBirth = [NSDate date];
    }
    
    /*
    self.actionSheetPicker = [[ActionSheetDatePicker alloc]
                              initWithTitle:@""
                              datePickerMode:UIDatePickerModeDateAndTime
                              selectedDate:self.dateAndTimeOfBirth
                              target:self
                              action:@selector(birthDateWasSelected:element:)
                              origin:sender];
     */
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDateAndTime
                                                             selectedDate:self.dateAndTimeOfBirth
                                                                  minDate:nil
                                                                  maxDate:nil
                                                                   target:self
                                                                   action:@selector(birthDateWasSelected:element:)
                                                                   origin:sender];

    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Today", nil) value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil) value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)selectABirthTime:(UIControl *)sender
{
    /*
    self.actionSheetPicker = [[ActionSheetDatePicker alloc]
                              initWithTitle:@""
                              datePickerMode:UIDatePickerModeTime
                              selectedDate:self.selectedPatient.birthDate
                              target:self
                              action:@selector(birthTimeWasSelected:element:)
                              origin:sender];
     */
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDateAndTime
                                                             selectedDate:self.selectedPatient.birthDate
                                                                  minDate:nil
                                                                  maxDate:nil
                                                                   target:self
                                                                   action:@selector(birthTimeWasSelected:element:)
                                                                   origin:sender];
    
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)selectADate:(UIControl *)sender
{
    
    self.selectedDate = [NSDate date];
    
    /*
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    */
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDateAndTime
                                                             selectedDate:self.selectedDate
                                                                  minDate:nil
                                                                  maxDate:nil
                                                                   target:self
                                                                   action:@selector(dateWasSelected:element:)
                                                                   origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Today", nil) value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil) value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)dateButtonTapped:(UIBarButtonItem *)sender
{
    [self selectADate:sender];
}

#pragma mark - Implementation

- (void)birthTimeWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.selectedPatient.birthTimeSet = @"YES";
    self.dateAndTimeOfBirth = selectedDate;
    
    [self birthDateWasSelected:selectedDate element:element];
}

// Birthdate
- (void)birthDateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (![self.selectedPatient.birthDate isEqualToDate:selectedDate])
    {
        self.selectedPatient.birthDate = selectedDate;
    }
    
    // round selectedDate to remove seconds
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit);
    
    NSDateComponents *dateComponents = [gregorian components:flags fromDate:selectedDate];
    
    selectedDate = [gregorian dateFromComponents:dateComponents];
    
    // Ensure birthdate is not in the future
    if ([CBTimeMethods getDaysDifferenceDoubleBetween:selectedDate and:[NSDate date]] > 0)
    {
        self.dateAndTimeOfBirth = selectedDate;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.birthDateTextField.text = [formatter stringFromDate:self.dateAndTimeOfBirth];
        
        // deselect borderstyle to indicate that UITextField is now set
        self.birthDateTextField.borderStyle = UITextBorderStyleNone;
        
        // if both set display sample age
        if (self.dateAndTimeOfBirth && self.selectedDate)
        {
            [self setAgeInDays];
        }
    }
    else
    {
        self.dateAndTimeOfBirth = nil;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"ERROR!"
                                  message:[NSString stringWithFormat:@"A birthdate cannot be in the future"]
                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// Sample date
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    // round selectedDate to remove seconds
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit);
    
    NSDateComponents *dateComponents = [gregorian components:flags fromDate:selectedDate];
    
    selectedDate = [gregorian dateFromComponents:dateComponents];
    
    // Ensure sample date is not in the future
    if ([CBTimeMethods getDaysDifferenceDoubleBetween:selectedDate and:[NSDate date]] > 0)
    {
        // if birth date set, ensure sample date is not before this...
        if (self.dateAndTimeOfBirth)
        {
            if ([CBTimeMethods getDaysDifferenceDoubleBetween:selectedDate and:self.dateAndTimeOfBirth] > 0)
            {
                self.selectedDate = nil;
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!"
                                          message:[NSString stringWithFormat:@"Sample date cannot be before birthdate"]
                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                self.selectedDate = selectedDate;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                
                self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
                
                if (self.dateAndTimeOfBirth && self.selectedDate)
                {
                    [self setAgeInDays];
                }
            }
        }
        else
        {
            self.selectedDate = selectedDate;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
            
            if (self.dateAndTimeOfBirth && self.selectedDate)
            {
                [self setAgeInDays];
            }
        }
    }
    else
    {
        self.selectedDate = nil;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"ERROR!"
                                  message:[NSString stringWithFormat:@"Sample date cannot be in the future"]
                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// set age in days
- (void)setAgeInDays
{
    // calculate days difference
    double daysDifference = [CBTimeMethods getDaysDifferenceDoubleBetween:self.dateAndTimeOfBirth and:self.selectedDate];
    
    self.ageInDays = [NSNumber numberWithDouble:daysDifference];
    
    self.formattedAge = [CBTimeMethods getFormattedExactDaysHoursMinutesDifferenceBetween:self.dateAndTimeOfBirth and:self.selectedDate];
    
    if ([self.formattedAge isEqualToString:@"No Difference"]) self.formattedAge = @"Cord Sample";

    // update table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.myTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    // if sample age more than 14 days, warn user
    
    if ([self.ageInDays integerValue] > 14)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"WARNING!", nil)
                                  message:[NSString stringWithFormat:NSLocalizedString(@"This chart is designed for interpreting bilirubin levels up to 14 days of age.", nil)]
                                  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// format set age in days

- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

@end
