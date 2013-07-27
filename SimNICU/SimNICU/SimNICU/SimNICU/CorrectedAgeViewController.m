//
//  CorrectedAgeViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CorrectedAgeInfoViewController.h"
#import "CorrectedAgeViewController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "AgeResultsCell.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"

@interface CorrectedAgeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, retain) UITextField *birthDateTextField;
@property (nonatomic, retain) UITextField *birthTimeTextField;
@property (nonatomic, retain) UITextField *dateTextField;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSString *formattedAge;
@property (nonatomic, strong) NSString *formattedAge1;
@property (nonatomic, strong) NSString *formattedAge2;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, strong) NSNumber *ageInDays;
@property (nonatomic) int months;
@property (nonatomic) int years;
@property (nonatomic) int weeks;
@property (nonatomic) int days;

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)dateButtonTapped:(UIBarButtonItem *)sender;
- (void)selectABirthDate:(id)sender;
- (void)selectADate:(id)sender;

@end

@implementation CorrectedAgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Corrected Age";
        
        self.selectedDate = [NSDate date]; // set default to now
        
        // info button
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.frame = CGRectMake(270.0f, 10.0f, 30.0f, 30.0f);
        [infoButton addTarget:self action:@selector(showInfoScreen) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        self.navigationItem.rightBarButtonItem = infoBarButton;
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:nil];
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        
        // swipe gesture recognizer
        // self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        // [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.myTableView addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.myTableView addGestureRecognizer:swipeRight];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        // validate gestation
        
        if (self.gestation.text.length == 3)
        {
            self.gestation.text = [self.gestation.text substringToIndex:2];
        }
        
        // appropriate delegate
        // [self.delegate patientDetailsEnterWeightViewController:self didFinishEditingPatientBirthWeight:self.patientToEdit];
    }
    
    [super viewWillDisappear:animated];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self showInfoScreen];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 50.0f;
    
    if (indexPath.row == 3)
    {
        height = 110.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    NSString *CellIdentifier;
    
    if (indexPath.row == 0)
    {
        CellIdentifier = @"birthDateAndTime";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Date of Birth";
        
        self.birthDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
        self.birthDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.birthDateTextField.textAlignment = UITextAlignmentCenter;
        self.birthDateTextField.adjustsFontSizeToFitWidth = YES;
        self.birthDateTextField.userInteractionEnabled = NO;
        self.birthDateTextField.delegate = self;
        
        if (self.selectedPatient)
        {
            if (self.selectedPatient.birthDate)
            {
                // if yes then display and lock birth date and time.
                self.birthDateTextField.borderStyle = UITextBorderStyleNone;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                
                self.birthDateTextField.text = [formatter stringFromDate:self.selectedPatient.birthDate];
                self.dateOfBirth = self.selectedPatient.birthDate;
                
                cell.accessoryView = self.birthDateTextField;
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
            if (self.dateOfBirth)
            {
                self.birthDateTextField.borderStyle = UITextBorderStyleNone;
            }
            else
            {
                self.birthDateTextField.borderStyle = UITextBorderStyleRoundedRect;
            }
            
            self.birthDateTextField.placeholder = @"date of birth";
            self.birthDateTextField.textAlignment = UITextAlignmentCenter;
            self.birthDateTextField.adjustsFontSizeToFitWidth = YES;
            self.birthDateTextField.userInteractionEnabled = NO;
            self.birthDateTextField.delegate = self;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            // [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            if (self.dateOfBirth)
            {
                self.birthDateTextField.text = [formatter stringFromDate:self.dateOfBirth];
            }
            else if (self.selectedPatient.birthDate)
            {
                self.birthDateTextField.text = [formatter stringFromDate:self.selectedPatient.birthDate];
            }
            
            cell.accessoryView = self.birthDateTextField;
        }
        
        returnCell = cell;
    }
    else if (indexPath.row == 1)
    {
        CellIdentifier = @"Date";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        self.dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
        self.dateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.dateTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.dateTextField.clearButtonMode = UITextFieldViewModeNever;
        self.dateTextField.placeholder = @"date";
        self.dateTextField.textAlignment = UITextAlignmentCenter;
        self.dateTextField.adjustsFontSizeToFitWidth = YES;
        self.dateTextField.userInteractionEnabled = NO;
        self.dateTextField.delegate = self;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        // [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
        
        cell.accessoryView = self.dateTextField;
        cell.textLabel.text = @"Date";
        
        returnCell = cell;
    }
    else if (indexPath.row == 2)
    {
        CellIdentifier = @"Gestation";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            self.gestation = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
            self.gestation.borderStyle = UITextBorderStyleRoundedRect;
            self.gestation.placeholder = @"weeks";
            self.gestation.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.gestation.adjustsFontSizeToFitWidth = YES;
            self.gestation.returnKeyType = UIReturnKeyNext;
            self.gestation.textAlignment = UITextAlignmentCenter;
            self.gestation.delegate = self;
            self.gestation.autocorrectionType = UITextAutocorrectionTypeNo;
            self.gestation.keyboardType = UIKeyboardTypeDecimalPad;
            self.gestation.keyboardAppearance = UIKeyboardAppearanceAlert;
            // [self.gestation becomeFirstResponder];
            
            cell.accessoryView = self.gestation;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Gestation at birth";
        
        returnCell = cell;
    }
    else if (indexPath.row == 3)
    {
        CellIdentifier = @"Age";
        AgeResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[AgeResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Age";
        
        if ([self.formattedAge isEqualToString:self.formattedAge1])
        {
            cell.label1.text = nil;
            cell.label2.text = self.formattedAge;
            cell.label3.text = nil;
            cell.label4.text = self.formattedAge2;
            cell.label5.text = nil;
        }
        else
        {
            cell.label1.text = self.formattedAge;
            cell.label2.text = nil;
            cell.label3.text = self.formattedAge1;
            cell.label4.text = nil;
            cell.label5.text = self.formattedAge2;
        }
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    // if birthdate set then don't allow to change
    if (indexPath.row == 0)
    {
        if (!self.dateOfBirth && !self.selectedPatient.birthTimeSet)
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
            if (!self.dateOfBirth)
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

#pragma mark - TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.gestation])
    {
        if(newText.length > 4)
        {
            allowUserToChangeText = NO;
        }
        else if(newText.length == 1)
        {
            if([[newText substringToIndex:1] isEqualToString:@"."] || [[newText substringToIndex:1] isEqualToString:@"1"] || [[newText substringToIndex:1] isEqualToString:@"5"]  || [[newText substringToIndex:1] isEqualToString:@"6"] || [[newText substringToIndex:1] isEqualToString:@"7"] || [[newText substringToIndex:1] isEqualToString:@"8"] || [[newText substringToIndex:1] isEqualToString:@"9"] || [[newText substringToIndex:1] isEqualToString:@"0"])
            {
                allowUserToChangeText = NO;
            }
        }
        else if(newText.length == 2)
        {
            // if the first character is not a "2", "3" or "4"
            if([[newText substringToIndex:1] isEqualToString:@"."] || [[newText substringToIndex:1] isEqualToString:@"1"] || [[newText substringToIndex:1] isEqualToString:@"5"]  || [[newText substringToIndex:1] isEqualToString:@"6"] || [[newText substringToIndex:1] isEqualToString:@"7"] || [[newText substringToIndex:1] isEqualToString:@"8"] || [[newText substringToIndex:1] isEqualToString:@"9"] || [[newText substringToIndex:1] isEqualToString:@"0"])
            {
                return NO;
            }
            else if([[newText substringToIndex:1] isEqualToString:@"2"])
            {
                // now excluding "2.", "21", "22", "20"
                if([[newText substringFromIndex:1] isEqualToString:@"."] || [[newText substringFromIndex:1] isEqualToString:@"1"] || [[newText substringFromIndex:1] isEqualToString:@"0"] || [[newText substringFromIndex:1] isEqualToString:@"2"])
                {
                    return NO;
                }
                else if (![string isEqualToString:@""])
                {
                    self.gestation.text = [NSString stringWithFormat:@"%@+",newText];
                    allowUserToChangeText = NO;
                }
            }
            else if([[newText substringFromIndex:1] isEqualToString:@"."])
            {
                return NO;
            }
            else if (![string isEqualToString:@""])
            {
                self.gestation.text = [NSString stringWithFormat:@"%@+",newText];
                allowUserToChangeText = NO;
            }
        }
        else if(newText.length == 3)
        {
            if(![string isEqualToString:@""])
            {
                if ([[newText substringFromIndex:2]isEqualToString:@"."] || [[newText substringFromIndex:2]isEqualToString:@"7"] || [[newText substringFromIndex:2]isEqualToString:@"8"] || [[newText substringFromIndex:2]isEqualToString:@"9"])
                {
                    allowUserToChangeText = NO;
                }
                
                self.gestation.text = [self.gestation.text stringByAppendingString:@"+"];
            }
        }
        else if(newText.length == 4)
        {
            if ([[newText substringFromIndex:3] isEqualToString:@"."] || [[newText substringFromIndex:3] isEqualToString:@"7"] || [[newText substringFromIndex:3] isEqualToString:@"8"] || [[newText substringFromIndex:3] isEqualToString:@"9"])
            {
                allowUserToChangeText = NO;
            }
        }
    }
    
    return allowUserToChangeText;
}

#pragma mark - actions

- (void)selectABirthDate:(UIControl *)sender
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    // max age 20 years
    [comps setYear:-20];
    NSDate *currentDateMinus20Years = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    // if selected patient has a birth date entered then present picker with this date, otherwise present current date
    if (self.selectedPatient.birthDate)
    {
        self.dateOfBirth = self.selectedPatient.birthDate;
    }
    else
    {
        self.dateOfBirth = currentDate;
    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDate
                                                             selectedDate:self.dateOfBirth
                                                                  minDate:currentDateMinus20Years
                                                                  maxDate:currentDate
                                                                   target:self
                                                                   action:@selector(birthDateWasSelected:element:)
                                                                   origin:sender];
    
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Today", nil) value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil) value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)selectADate:(UIControl *)sender
{
    // if date has not already been selected, then select current date
    if (!self.selectedDate) self.selectedDate = [NSDate date];
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDate
                                                             selectedDate:self.selectedDate
                                                                  minDate:self.dateOfBirth
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

- (NSMutableArray *)getFormattedYearsMonthsWeeksDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    NSString *formattedDate = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    self.years = [comps year];
    self.months = [comps month];
    self.weeks = [comps week];
    self.days = [comps day];
    
    NSLog(@"Age = %i years, %i months, %i weeks, %i days", self.years, self.months, self.weeks, self.days);
    
    // format in normal English
    if (self.years < 1)
    {
        if (self.months == 0)
        {
            if (self.weeks == 0)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"day of birth"];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i days", self.days];
                }
            }
            else if (self.weeks == 1)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 week"];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 week, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 week, %i days", self.days];
                }
            }
            else
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks", self.weeks];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks, 1 day", self.weeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks, %i days", self.weeks, self.days];
                }
            }
        }
        else if (self.months == 1)
        {
            if (self.weeks == 0)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month"];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i days", self.days];
                }
            }
            else if (self.weeks == 1)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week"];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week, %i days", self.days];
                }
            }
            else
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks", self.weeks];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks, 1 day", self.weeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks, %i days", self.weeks, self.days];
                }
            }
        }
        else // months
        {
            if (self.weeks == 0)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months", self.months];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 day", self.months];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i days", self.months, self.days];
                }
            }
            else if (self.weeks == 1)
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week", self.months];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week, 1 day", self.months];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week, %i days", self.months, self.days];
                }
            }
            else
            {
                if (self.days == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks", self.months, self.weeks];
                }
                else if (self.days == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks, 1 day", self.months, self.weeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks, %i days", self.months, self.weeks, self.days];
                }
            }
        }
    }
    else if (self.years == 1)
    {
        if (self.months == 0)
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year", self.years];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i day", self.years, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year", self.years];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i days", self.years, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year", self.years];
            }
        }
        else if (self.months == 1)
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", self.years, self.months];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i month, %i day", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", self.years, self.months];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i month, %i days", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", self.years, self.months];
            }
        }
        else
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", self.years, self.months];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i months, %i day", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", self.years, self.months];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i months, %i days", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", self.years, self.months];
            }
        }
    }
    else
    {
        if (self.months == 0)
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years", self.years];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i day", self.years, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years", self.years];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i days", self.years, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years", self.years];
            }
        }
        else if (self.months == 1)
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", self.years, self.months];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i month, %i day", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", self.years, self.months];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i month, %i days", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", self.years, self.months];
            }
        }
        else
        {
            if (self.days == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", self.years, self.months];
            }
            else if (self.days == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i months, %i day", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", self.years, self.months];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i months, %i days", self.years, self.months, self.days];
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", self.years, self.months];
            }
        }
    }
    
    // format in days (i.e.  day 57)
    NSString *formattedDate1 = nil;
    unitFlags = NSDayCalendarUnit;
    comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    self.days = [comps day];
    
    if (self.days == 0)
    {
        formattedDate1 = [NSString stringWithFormat:@""];
    }
    else if (self.days == 1)
    {
        formattedDate1 = [NSString stringWithFormat:@"1 day"];
    }
    else
    {
        formattedDate1 = [NSString stringWithFormat:@"%i days", self.days];
    }
    NSLog(@"%i days", self.days);
    
    // format in weeks and days spelt
    NSString *formattedDate2 = nil;
    unitFlags = NSWeekCalendarUnit | NSDayCalendarUnit;
    comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    self.weeks = [comps week];
    self.days = [comps day];
    
    // format in weeks and days (57+4)
    formattedDate2 = [NSString stringWithFormat:@"%i + %i", self.weeks, self.days];
    NSLog(@"%i + %i", self.weeks, self.days);
    
    // create Array
    NSMutableArray *formattedDates = [[NSMutableArray alloc] init];
    [formattedDates addObject:formattedDate];
    [formattedDates addObject:formattedDate1];
    [formattedDates addObject:formattedDate2];
    
    return formattedDates;
}

// return formatted string of days hours minutes difference
- (NSString *)getFormattedDaysHoursMinutesDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
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
        formattedDate = @"Cord sample";
    }
    
    return formattedDate;
}

// Birthdate
- (void)birthDateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (![self.selectedPatient.birthDate isEqualToDate:selectedDate])
    {
        self.selectedPatient.birthDate = selectedDate;
    }
    
    // round selectedDate to remove hours, minutes, seconds
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    
    NSDateComponents *dateComponents = [gregorian components:flags fromDate:selectedDate];
    
    selectedDate = [gregorian dateFromComponents:dateComponents];
    
    // Ensure birthdate is not in the future
    if ([CBTimeMethods getDaysDifferenceDoubleBetween:selectedDate and:[NSDate date]] > 0)
    {
        self.dateOfBirth = selectedDate;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        
        self.birthDateTextField.text = [formatter stringFromDate:self.dateOfBirth];
        
        // deselect borderstyle to indicate that UITextField is now set
        self.birthDateTextField.borderStyle = UITextBorderStyleNone;
        
        // if both set display sample age
        if (self.dateOfBirth && self.selectedDate)
        {
            [self setAgeInDays];
        }
    }
    else
    {
        self.dateOfBirth = nil;
        
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
    // round selectedDate to remove hours, minutes and seconds
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSWeekCalendarUnit | NSDayCalendarUnit);
    
    NSDateComponents *dateComponents = [gregorian components:flags fromDate:selectedDate];
    
    selectedDate = [gregorian dateFromComponents:dateComponents];
    
    // if birth date set, ensure sample date is not before this...
    if (self.dateOfBirth)
    {
        if ([selectedDate compare:self.dateOfBirth] == NSOrderedAscending)
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
            
            self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
            
            if (self.dateOfBirth && self.selectedDate)
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
        
        self.dateTextField.text = [formatter stringFromDate:self.selectedDate];
        
        if (self.dateOfBirth && self.selectedDate)
        {
            [self setAgeInDays];
        }
    }
}

// set age in days
- (void)setAgeInDays
{
    // calculate days difference
    double daysDifference = [CBTimeMethods getDaysDifferenceDoubleBetween:self.dateOfBirth and:self.selectedDate];
    
    self.ageInDays = [NSNumber numberWithDouble:daysDifference];
    
    NSMutableArray *formattedDates = [self getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.dateOfBirth and:self.selectedDate];
    self.formattedAge = formattedDates[0];
    self.formattedAge1 = formattedDates[1];
    self.formattedAge2 = formattedDates[2];
    
    // update table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.myTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

// format set age in days

- (void)actionPickerCancelled:(id)sender
{
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}

- (void)showInfoScreen
{
    CorrectedAgeInfoViewController *newViewController = [[CorrectedAgeInfoViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.tintColor = [UIColor blackColor];
    navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

@end
