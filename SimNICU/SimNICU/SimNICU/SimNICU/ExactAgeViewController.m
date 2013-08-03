//
//  ExactAgeViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "ExactAgeViewController.h"
#import "ActionSheetPicker.h"
#import "CBDisplayMethods.h"
#import "NSDate+TCUtils.h"
#import "CBTimeMethods.h"
#import "CBDatePicker.h"
#import "AppDelegate.h"

#import "CBDatePickerActionSheet.h"


@interface ExactAgeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
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

@implementation ExactAgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Exact Age";
        
        // Delegate
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
        
        // swipe gesture recognizer
        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedPatient.birthDate && self.selectedPatient.birthTimeSet && !self.selectedDate)
    {
        self.dateAndTimeOfBirth = self.selectedPatient.birthDate;
        self.selectedDate = [NSDate date];
        [self dateWasSelected:self.selectedDate element:nil];
        [self setAgeInDays];
        [self.myTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if (self.ageInDays && self.formattedAge)
        {
            // [self.delegate phototherapyHoursOldViewController:self didFinishAddingAgeInDays:self.ageInDays formattedAge:self.formattedAge forBirthDate:self.dateAndTimeOfBirth];
        }
    }
    
    [super viewWillDisappear:animated];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"birthDateAndTime";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
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
        static NSString *CellIdentifier = @"Date";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 180.0f, 30.0f)];
            self.dateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.dateTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.dateTextField.clearButtonMode = UITextFieldViewModeNever;
            self.dateTextField.placeholder = @"date and time";
            self.dateTextField.textAlignment = UITextAlignmentCenter;
            self.dateTextField.adjustsFontSizeToFitWidth = YES;
            self.dateTextField.userInteractionEnabled = NO;
            self.dateTextField.delegate = self;
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
        
        cell.accessoryView = self.dateTextField;
        cell.textLabel.text = @"Timepoint";
        
        returnCell = cell;
    }
    else if(indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"Age";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Exact Age";
        
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
                [self selectABirthTime:self.birthDateTextField]; // request birth time
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

#pragma mark - actions

- (void)selectABirthDate:(UIControl *)sender
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    // max age can be 2 years as this is a neonatal app
    [comps setYear:-2];
    NSDate *currentDateMinus2Years = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    NSDate *maxDate = currentDate;
    
    if (self.selectedDate)
    {
        maxDate = self.selectedDate;
    }
    
    // if selected patient has a birth date entered then present picker with this date, otherwise present current date
    if (self.selectedPatient.birthDate)
    {
        self.dateAndTimeOfBirth = self.selectedPatient.birthDate;
    }
    else
    {
        if (self.selectedDate)
        {
            self.dateAndTimeOfBirth = self.selectedDate;
        }
        else
        {
            self.dateAndTimeOfBirth = currentDate;
        }
    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDateAndTime
                                                             selectedDate:self.dateAndTimeOfBirth
                                                                  minDate:currentDateMinus2Years
                                                                  maxDate:maxDate
                                                                   target:self
                                                                   action:@selector(birthDateWasSelected:element:)
                                                                   origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Today", nil)
                                               value:[NSDate date]];
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil)
                                               value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    
    self.actionSheetPicker.hideCancel = YES;
    
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)selectABirthTime:(UIControl *)sender
{
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime
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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    // max age can be 2 years as this is a neonatal app
    [comps setYear:-2];
    NSDate *currentDateMinus2Years = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    self.selectedDate = currentDate;
    
    // if birth date and time set, then this is the minimum date
    if (self.dateAndTimeOfBirth)
    {
        self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                               datePickerMode:UIDatePickerModeDateAndTime
                                                                 selectedDate:self.selectedDate
                                                                      minDate:self.dateAndTimeOfBirth
                                                                      maxDate:nil
                                                                       target:self
                                                                       action:@selector(dateWasSelected:element:)
                                                                       origin:sender];
    }
    else
    {
        self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                               datePickerMode:UIDatePickerModeDateAndTime
                                                                 selectedDate:self.selectedDate
                                                                      minDate:currentDateMinus2Years
                                                                      maxDate:nil
                                                                       target:self
                                                                       action:@selector(dateWasSelected:element:)
                                                                       origin:sender];
    }
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Today", nil)
                                               value:[NSDate date]];
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil)
                                               value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)dateButtonTapped:(UIBarButtonItem *)sender
{
    [self selectADate:sender];
}

#pragma mark - Implementation

// return formatted string of days hours minutes difference
- (NSString *)getFormattedDaysHoursMinutesDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    // Need to move this code to CBTimeMethods...
    
    NSString *formattedDate;
    double days, hours, minutes, seconds;
    
    seconds = [dateB timeIntervalSinceDate:dateA];
    
    days = seconds / (60 * 60 * 24);
    hours = seconds / (60 * 60);
    minutes = seconds / (60);
    
    if (days >= 1)
    {
        hours = hours - (abs(days) * 24);
        minutes = minutes - (abs(days) * 24 * 60) - (abs(hours) * 60);
        
        if (abs(days) == 1)
        {
            if (abs(hours) == 0)
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = @"1 day";
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = @"1 day and 1 minute";
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 day and %d minutes", abs(minutes)];
                }
            }
            else if (abs(hours) == 1)
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = @"1 day and 1 hour";
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = @"1 day, 1 hour and 1 minute!";
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 day, 1 hour, %d minutes", abs(minutes)];
                }
            }
            else
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 day and %d hours", abs(hours)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 day, %d hours, 1 minute", abs(hours)];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 day, %d hours, %d minutes", abs(hours), abs(minutes)];
                }
            }
        }
        else
        {
            if (abs(hours) == 0)
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days", abs(days)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days and 1 minute", abs(days)];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%d days and %d minutes", abs(days), abs(minutes)];
                }
            }
            else if (abs(hours) == 1)
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days and 1 hour", abs(days)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days, 1 hour, 1 minute", abs(days)];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%d days, 1 hour, %d minutes", abs(days), abs(minutes)];
                }
            }
            else
            {
                if (abs(minutes) == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days and %d hours", abs(days), abs(hours)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%d days, %d hours, 1 minute", abs(days), abs(hours)];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%d days, %d hours, %d minutes", abs(days), abs(hours), abs(minutes)];
                }
            }
        }
    }
    else if (hours >= 1)
    {
        minutes = minutes - (abs(hours) * 60);
        
        if (abs(hours) == 1)
        {
            if (abs(minutes) == 0)
            {
                formattedDate = @"1 hour";
            }
            else if (abs(minutes) == 1)
            {
                formattedDate = @"1 hour and 1 minute";
            }
            else
            {
                formattedDate = [NSString stringWithFormat:@"1 hour and %d minutes", abs(minutes)];
            }
        }
        else
        {
            if (abs(minutes) == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%d hours", abs(hours)];
            }
            else if (abs(minutes) == 1)
            {
                formattedDate = [NSString stringWithFormat:@"%d hours and 1 minute", abs(hours)];
            }
            else
            {
                formattedDate = [NSString stringWithFormat:@"%d hours and %d minutes", abs(hours), abs(minutes)];
            }
        }
    }
    else
    {
        if (abs(minutes) < 1)
        {
            formattedDate = @"less than 1 minute";
        }
        else if (abs(minutes) == 1)
        {
            formattedDate = @"1 minute";
        }
        else
        {
            formattedDate = [NSString stringWithFormat:@"%d minutes", abs(minutes)];
        }
    }
    
    if ([dateA isEqualToDate:dateB])
    {
        formattedDate = @"Birth";
    }
    
    return formattedDate;
}


- (void)birthTimeWasSelected:(NSDate *)selectedDate element:(id)element
{
    self.selectedPatient.birthTimeSet = @"YES";
    self.selectedPatient.birthDate = selectedDate;
    self.dateAndTimeOfBirth = selectedDate;
    
    [self birthDateWasSelected:selectedDate element:element];
}

// Birthdate
- (void)birthDateWasSelected:(NSDate *)selectedDate element:(id)element
{
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
    NSDate *currentDate = [NSDate date];
    
    if ([CBTimeMethods getDaysDifferenceDoubleBetween:selectedDate and:currentDate] > 0)
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

// set age in days
- (void)setAgeInDays
{
    // calculate days difference
    self.ageInDays = [NSNumber numberWithDouble:[CBTimeMethods getDaysDifferenceDoubleBetween:self.dateAndTimeOfBirth and:self.selectedDate]];
    
    self.formattedAge = [CBTimeMethods getFormattedExactDaysHoursMinutesDifferenceBetween:self.dateAndTimeOfBirth and:self.selectedDate];
    
    if ([self.formattedAge isEqualToString:@"No Difference"]) self.formattedAge = @"Birth";
    
    // update table
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]];
    [self.myTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

// format set age in days

- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

@end
