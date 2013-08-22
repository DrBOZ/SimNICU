//
//  CorrectedAgeViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "CorrectedAgeInfoViewController.h"
#import "CorrectedAgeViewController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "AgeResultsCell.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"

@interface CorrectedAgeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CorrectedAgeInfoViewControllerDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, retain) UITextField *birthDateTextField;
@property (nonatomic, retain) UITextField *birthTimeTextField;
@property (nonatomic, retain) UITextField *dateTextField;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITextField *gestation;
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
{
    BOOL gestationHasBeenEntered;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Corrected Age"];
    
    self.selectedDate = [NSDate date]; // set default to now
    
    // settings button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems settingsBarButtonWithTarget:self action:@selector(showInfoScreen)];
    
    // back button
    self.navigationItem.backBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:nil action:nil];
    
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
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.myTableView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:swipeRight];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.typeOfAgeCalculator isEqualToString:@"Corrected age"])
    {
        self.title = @"Corrected Age";
    }
    else if ([self.typeOfAgeCalculator isEqualToString:@"Including postmenstrual age"])
    {
        self.title = @"Age";
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 50.0f;
    
    if (indexPath.row == 3)
    {
        height = 110.0f;
    }
    else if (indexPath.row == 4)
    {
        if ([self.typeOfAgeCalculator isEqualToString:@"Corrected age"])
        {
            height = 110.0f;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if ([self.typeOfAgeCalculator isEqualToString:@"Including postmenstrual age"])
    {
        footer = @"The calculator will automatically change to corrected age if the baby is more than 43 weeks postmenstrual age";
    }
    
    return footer;
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
            
            self.birthDateTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
            self.birthDateTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.birthDateTextField.textAlignment = UITextAlignmentCenter;
            self.birthDateTextField.adjustsFontSizeToFitWidth = YES;
            self.birthDateTextField.userInteractionEnabled = NO;
            self.birthDateTextField.delegate = self;
        }
        
        cell.textLabel.text = @"Date of Birth";
        
        if (self.selectedPatient)
        {
            if (self.selectedPatient.birthDate)
            {
                // if yes then display and lock birth date and time.
                self.birthDateTextField.borderStyle = UITextBorderStyleNone;
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                
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
            self.birthDateTextField.borderStyle = UITextBorderStyleRoundedRect;
            
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
        self.dateTextField.textAlignment = UITextAlignmentCenter;
        self.dateTextField.adjustsFontSizeToFitWidth = YES;
        self.dateTextField.userInteractionEnabled = NO;
        self.dateTextField.placeholder = @"date";
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
            self.gestation.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.gestation.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.gestation.autocorrectionType = UITextAutocorrectionTypeNo;
            self.gestation.keyboardAppearance = UIKeyboardAppearanceAlert;
            self.gestation.borderStyle = UITextBorderStyleRoundedRect;
            self.gestation.keyboardType = UIKeyboardTypeDecimalPad;
            self.gestation.textAlignment = UITextAlignmentCenter;
            self.gestation.adjustsFontSizeToFitWidth = YES;
            self.gestation.returnKeyType = UIReturnKeyNext;
            self.gestation.placeholder = @"weeks";
            self.gestation.delegate = self;
            // [self.gestation becomeFirstResponder];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Gestation at birth";
        
        if (self.selectedPatient)
        {
            if (self.selectedPatient.gestation)
            {
                self.gestation.text = self.selectedPatient.gestation;
                self.gestation.borderStyle = UITextBorderStyleNone;
                gestationHasBeenEntered = YES;
            }
        }
        
        cell.accessoryView = self.gestation;
        
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
        
        cell.ageTextLabel.text = @"Chronological Age";
        cell.textLabel.text = @"";
        
        if (self.dateOfBirth && self.selectedDate)
        {
            // calculate days difference
            double daysDifference = [CBTimeMethods getDaysDifferenceDoubleBetween:self.dateOfBirth and:self.selectedDate];
            
            self.ageInDays = [NSNumber numberWithDouble:daysDifference];
            
            NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.dateOfBirth and:self.selectedDate];
            self.formattedAge = formattedDates[0];
            self.formattedAge1 = formattedDates[1];
            self.formattedAge2 = formattedDates[2];
        }
        
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
    else if (indexPath.row == 4)
    {
        CellIdentifier = @"PostmenstrualAgeOrCorrectedAge";
        
        AgeResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[AgeResultsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if ([self.typeOfAgeCalculator isEqualToString:@"Including postmenstrual age"])
        {
            cell.textLabel.text = @"";
            cell.ageTextLabel.text = @"Postmenstrual Age";
            
            if (gestationHasBeenEntered && self.dateOfBirth && self.selectedDate)
            {
                // get postmenstrual age
                NSString *postMenstrualAge = [CBTimeMethods calculatePostMenstrualGestationFromDateOfBirth:self.dateOfBirth andCurrentDate:self.selectedDate withGestation:self.gestation.text];
                
                // get corrected gestation in weeks
                int gestationWeeks;
                
                // postMenstrual age can be 1000+ weeks (1000 weeks is about 20 years old)
                //
                // if postMenstrual Age is < 5 characters then dealing with <100 weeks
                if ([postMenstrualAge length] < 5)
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:2] intValue];
                }
                // dealing with 100 - 999 weeks
                else if ([postMenstrualAge length] == 5)
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:3] intValue];
                }
                else // dealing with >999 weeks
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:4] intValue];
                }
                
                if (gestationWeeks >= 43)
                {
                    self.typeOfAgeCalculator = @"Corrected age";
                    [self.myTableView reloadData];
                }
                else
                {
                    cell.label5.text = postMenstrualAge;
                    cell.label4.text = @"";
                    cell.label3.text = @"";
                    cell.label2.text = @"";
                    cell.label1.text = @"";
                }
            }
        }
        else
        {
            // set default textLabel.text to nil, as this is the one centered on the cell
            cell.textLabel.text = @"";
            cell.ageTextLabel.text = @"Corrected Age"; // this is the label top justified
            
            if (gestationHasBeenEntered && self.dateOfBirth && self.selectedDate)
            {
                // get postmenstrual age
                NSString *postMenstrualAge = [CBTimeMethods calculatePostMenstrualGestationFromDateOfBirth:self.dateOfBirth andCurrentDate:self.selectedDate withGestation:self.gestation.text];
                
                // get corrected gestation in weeks
                int gestationWeeks;
                
                // postMenstrual age can be 1000+ weeks (1000 weeks is about 20 years old)
                //
                // if postMenstrual Age is < 5 characters then dealing with <100 weeks
                if ([postMenstrualAge length] < 5)
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:2] intValue];
                }
                // dealing with 100 - 999 weeks
                else if ([postMenstrualAge length] == 5)
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:3] intValue];
                }
                else // dealing with >999 weeks
                {
                    gestationWeeks = [[postMenstrualAge substringToIndex:4] intValue];
                }
                
                // for corrected gestation calc, gestationWeeks must be >= 40 weeks
                if (gestationWeeks < 40)
                {
                    self.typeOfAgeCalculator = @"Including postmenstrual age";
                    [self.myTableView reloadData];
                }
                else
                {
                    // check if baby is premature or not
                    int gestation = [[self.gestation.text substringToIndex:2] intValue];
                    
                    if (gestation >=  37)
                    {
                        // not premature
                        cell.label5.text = @"";
                        cell.label4.text = @"";
                        cell.label3.text = @"Gestation is > 37 weeks";
                        cell.label2.text = @"";
                        cell.label1.text = @"No need to correct for prematurity";
                    }
                    else
                    {
                        // premature
                        //
                        // convert to corrected age
                        if (gestationWeeks < 43)
                        {
                            // convert postMenstrualGestationalAge to CorrectedGestationalAge
                            cell.label5.text = [CBTimeMethods convertPostMenstrualAgeToCorrectedGestationalAge:postMenstrualAge];
                            
                            // get Term + value
                            cell.label3.text = [CBTimeMethods convertPostMenstualAgeToTermPlusDays:postMenstrualAge];
                            cell.label1.text = @"";
                        }
                        else
                        {
                            // code here to check if age is greater than corrected limit
                            
                            if (self.correctAgeForPrematurityUntilYears)
                            {
                                // find out age in years
                                // NB. this is a calendrical operation
                                int patientAgeInYears = [CBTimeMethods getYearsDifferenceBetween:self.dateOfBirth and:self.selectedDate];
                                
                                if (patientAgeInYears >= [self.correctAgeForPrematurityUntilYears intValue])
                                {
                                    cell.label5.text = @"";
                                    cell.label4.text = @"";
                                    cell.label3.text = [NSString stringWithFormat:@"Patient is over %d years old", [self.correctAgeForPrematurityUntilYears intValue]];
                                    cell.label2.text = @"";
                                    cell.label1.text = @"No need to correct for prematurity";
                                }
                                else
                                {
                                    cell.label5.text = [CBTimeMethods convertPostMenstrualAgeToCorrectedGestationalAge:postMenstrualAge];
                                    
                                    NSLog(@"Method 1: corrected Gestational age = %@", cell.label5.text);
                                    
                                    NSDate *EDD = [CBTimeMethods calculateEDDFromBirthDate:self.dateOfBirth andGestation:self.gestation.text];
                                    
                                    NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:EDD and:self.selectedDate];
                                    self.formattedAge = formattedDates[0];
                                    self.formattedAge1 = formattedDates[1];
                                    self.formattedAge2 = formattedDates[2];
                                    
                                    cell.label3.text = nil;
                                    
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
                                    NSLog(@"Method 2: corrected Gestational age = %@", cell.label5.text);
                                }
                            }
                            else
                            {
                                // too old for Term + value
                                cell.label5.text = [CBTimeMethods convertPostMenstrualAgeToCorrectedGestationalAge:postMenstrualAge];
                                
                                NSLog(@"Method 1: corrected Gestational age = %@", cell.label5.text);
                                
                                NSDate *EDD = [CBTimeMethods calculateEDDFromBirthDate:self.dateOfBirth andGestation:self.gestation.text];
                                
                                NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:EDD and:self.selectedDate];
                                self.formattedAge = formattedDates[0];
                                self.formattedAge1 = formattedDates[1];
                                self.formattedAge2 = formattedDates[2];
                                
                                cell.label3.text = nil;
                                
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
                                NSLog(@"Method 2: corrected Gestational age = %@", cell.label5.text);
                            }
                        }
                    }
                }
            }
        }
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.row == 0 || indexPath.row == 1)
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.placeholder = @"";
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // code
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    gestationHasBeenEntered = NO;
    
    return YES;
}

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
            else
            {
                self.gestation.text = [self.gestation.text stringByAppendingString:string];
                
                [self.gestation resignFirstResponder];
                
                gestationHasBeenEntered = YES;
                
                NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:0]];
                [self.myTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
    NSDate *maxDate = currentDate;
    
    // if selected patient has a birth date entered then present picker with this date, otherwise present current date
    if (self.selectedPatient.birthDate)
    {
        self.dateOfBirth = self.selectedPatient.birthDate;
    }
    else
    {
        if (!self.dateOfBirth)
        {
            self.dateOfBirth = currentDate;
        }
    }
    
    if (self.selectedDate)
    {
        maxDate = self.selectedDate;
    }
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
                                                           datePickerMode:UIDatePickerModeDate
                                                             selectedDate:self.dateOfBirth
                                                                  minDate:currentDateMinus20Years
                                                                  maxDate:maxDate
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
    
    // Do not allow 'Yesterday' if date of birth is today
    //
    // create gregorian calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // setup units
    int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit;
    
    // define the calendrical component differences between dateOfBirth and current date
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self.dateOfBirth toDate:[NSDate date] options:0];
    
    // look at the days difference
    int compsDays = [comps day];
    
    // if days difference is not zero
    if (compsDays)
    {
        [self.actionSheetPicker addCustomButtonWithTitle:NSLocalizedString(@"Yesterday", nil) value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    }
    
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)dateButtonTapped:(UIBarButtonItem *)sender
{
    [self selectADate:sender];
}

#pragma mark - Implementation

// Birthdate
- (void)birthDateWasSelected:(NSDate *)selectedDate element:(id)element
{
    /*
    // I am not sure what this code is meant to do - add comment asap
    if (![self.selectedPatient.birthDate isEqualToDate:selectedDate])
    {
        self.selectedPatient.birthDate = selectedDate;
    }
     */
    
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
        // but only if selectedPatient is loaded
        if (self.selectedPatient)
        {
            self.birthDateTextField.borderStyle = UITextBorderStyleNone;
        }
        
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
    
    // NSMutableArray *formattedDates = [self getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.dateOfBirth and:self.selectedDate];
    NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.dateOfBirth and:self.selectedDate];
    self.formattedAge = formattedDates[0];
    self.formattedAge1 = formattedDates[1];
    self.formattedAge2 = formattedDates[2];
    
    // update table
    NSArray *indexPaths;
    
    if (gestationHasBeenEntered)
    {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
        indexPaths = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
    }
    else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        indexPaths = [NSArray arrayWithObject:indexPath];
    }
    
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
    newViewController.correctAgeForPrematurityUntilYears = self.correctAgeForPrematurityUntilYears;
    newViewController.delegate = self;
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.tintColor = [UIColor blackColor];
    navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

#pragma mark - CorrectedAgeViewController delegate

- (void)correctedAgeInfoViewController:(CorrectedAgeInfoViewController *)controller didChangeCorrectAgeForPrematurityUntilYears:(NSNumber *)correctAgeForPrematurityUntilYears
{
    self.correctAgeForPrematurityUntilYears = correctAgeForPrematurityUntilYears;
    
    [self.delegate correctedAgeViewController:self didChangePreferencesForCorrectAgeForPrematurityUntilYears:correctAgeForPrematurityUntilYears];
    
    [self.myTableView reloadData];
}

@end
