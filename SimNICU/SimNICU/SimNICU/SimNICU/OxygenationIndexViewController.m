//
//  OxygenationIndexViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "OxygenationIndexViewController.h"
#import "CBDisplayMethods.h"
#import "AppDelegate.h"

@interface OxygenationIndexViewController()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic) BOOL validParametersEntered;
@property (nonatomic) BOOL resultObtained;

@end

@implementation OxygenationIndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Oxygenation Index"];
    
    self.title = @"Oxygenation Index";
    
    float fourInchDisplayPadding = 0.0f;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        fourInchDisplayPadding = 40.0f;
    }
    
    //set view background
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.scrollEnabled = NO;
    self.myTableView.separatorColor = [UIColor grayColor];
    
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.meanAirwayPressure.delegate = self;
    self.inspiredOxygen.delegate = self;
    self.PaO2.delegate = self;
    
    self.meanAirwayPressure.keyboardType = UIKeyboardTypeDecimalPad;
    self.inspiredOxygen.keyboardType = UIKeyboardTypeDecimalPad;
    self.PaO2.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)viewDidAppear:(BOOL)animated
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    [self.meanAirwayPressure becomeFirstResponder];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *region = [[NSLocale currentLocale] localeIdentifier];
    
    NSLog(@"Language = %@", language);
    NSLog(@"Region = %@", region);

    if (preferences.OIUnits)
    {
        switch ([preferences.OIUnits intValue])
        {
            case 0:
                self.units.selectedSegmentIndex = 0;
                self.PaO2.placeholder = @"mmHg";
                
                NSLog(@"Setting units to mmHg from preferences");
                break;
                
            case 1:
                self.units.selectedSegmentIndex = 1;
                self.PaO2.placeholder = @"kPa";
                
                NSLog(@"Setting units to kPa from preferences");
                break;
                
            default:
                break;
        }
    }
    else
    {
        if ([region isEqualToString:@"en_GB"]) 
        {
            self.units.selectedSegmentIndex = 1;
            self.PaO2.placeholder = @"kPa";
        }
    }

}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.swipeGestureRecognizer = nil;
    self.meanAirwayPressure = nil;
    self.oxygenationIndex = nil;
    self.inspiredOxygen = nil;
    self.PaO2 = nil;
    self.units = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"OxygenationIndexViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"OxygenationIndexViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0.0f;
    
    if (section == 0) 
    {
        float fourInchDisplayPadding = 0.0f;
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            fourInchDisplayPadding = 40.0f;
        }
        
        height = 15.0f + fourInchDisplayPadding;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"MAP";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.meanAirwayPressure = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 6.0f, 107.0f, 31.0f)];
        self.meanAirwayPressure.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.meanAirwayPressure.clearButtonMode = UITextFieldViewModeAlways;
        self.meanAirwayPressure.borderStyle = UITextBorderStyleRoundedRect;
        self.meanAirwayPressure.keyboardType = UIKeyboardTypeDecimalPad;
        self.meanAirwayPressure.font = [UIFont systemFontOfSize:17.0f];
        self.meanAirwayPressure.textAlignment = UITextAlignmentLeft;
        self.meanAirwayPressure.placeholder = @"cm H2O";
        self.meanAirwayPressure.delegate = self;
        self.meanAirwayPressure.tag = 10;
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.meanAirwayPressure.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
        else
        {
            self.meanAirwayPressure.keyboardAppearance = UIKeyboardAppearanceAlert;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.meanAirwayPressure;
        cell.textLabel.text = @"MAP:";
        
        returnCell = cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"FiO2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.inspiredOxygen = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 6.0f, 107.0f, 31.0f)];
        self.inspiredOxygen.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.inspiredOxygen.clearButtonMode = UITextFieldViewModeAlways;
        self.inspiredOxygen.borderStyle = UITextBorderStyleRoundedRect;
        self.inspiredOxygen.keyboardType = UIKeyboardTypeDecimalPad;
        self.inspiredOxygen.font = [UIFont systemFontOfSize:17.0f];
        self.inspiredOxygen.textAlignment = UITextAlignmentLeft;
        self.inspiredOxygen.placeholder = @"%";
        self.inspiredOxygen.delegate = self;
        self.inspiredOxygen.tag = 20;
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.inspiredOxygen.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
        else
        {
            self.inspiredOxygen.keyboardAppearance = UIKeyboardAppearanceAlert;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.inspiredOxygen;
        cell.textLabel.text = @"FiO2:";
        
        returnCell = cell;
    }
    else if(indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"PaO2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.PaO2 = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 6.0f, 107.0f, 31.0f)];
        self.PaO2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.meanAirwayPressure.font = [UIFont systemFontOfSize:17.0f];
        self.PaO2.clearButtonMode = UITextFieldViewModeAlways;
        self.PaO2.borderStyle = UITextBorderStyleRoundedRect;
        [self.PaO2 setKeyboardType:UIKeyboardTypeDecimalPad];
        self.PaO2.textAlignment = UITextAlignmentLeft;
        self.PaO2.placeholder = @"kPa";
        self.PaO2.delegate = self;
        self.PaO2.tag = 30;
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.PaO2.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
        else
        {
            self.PaO2.keyboardAppearance = UIKeyboardAppearanceAlert;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.PaO2;
        cell.textLabel.text = @"PaO2:";
        
        self.units = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"mmHg", @"kPa", nil]];
        self.units.segmentedControlStyle = UISegmentedControlStyleBar;
        self.units.frame = CGRectMake(80.0f, 7.0f, 108.0f, 30.0f);
        
        // set target
        [self.units addTarget:self action:@selector(changeUnits) forControlEvents:UIControlEventValueChanged];
        
        [cell addSubview:self.units];
    
        returnCell = cell;
    }
    else if(indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"OI";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        self.oxygenationIndex = [[UILabel alloc] initWithFrame:CGRectMake(162.0f, 11.0f, 132.0f, 21.0f)];
        self.oxygenationIndex.highlightedTextColor = [UIColor whiteColor];
        self.oxygenationIndex.font = [UIFont boldSystemFontOfSize:17.0f];
        self.oxygenationIndex.backgroundColor = [UIColor clearColor];
        self.oxygenationIndex.textAlignment = UITextAlignmentCenter;
        self.oxygenationIndex.textColor = [UIColor lightGrayColor];
        self.oxygenationIndex.text = @"Calculate";
        
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.accessoryView = self.oxygenationIndex;
        cell.textLabel.text = @"OI:";
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    // only allow user to select the row with 'Calculate'
    if (indexPath.row == 3) 
    {
        path = indexPath;
    }
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.validParametersEntered = YES;
    
    if (self.validParametersEntered) 
    {
        if (self.resultObtained) 
        {
            // clear all
            self.meanAirwayPressure.text = @"";
            self.inspiredOxygen.text = @"";
            self.PaO2.text = @"";
            
            self.oxygenationIndex.textColor = [UIColor grayColor];
            self.oxygenationIndex.text = @"Calculate";
            
            // reset index
            self.resultObtained = NO;
        }
        else 
        {
            // Calculate OI
            NSLog(@"Calculate OI");
            
            // Mean Airway Pressure
            NSString *UKLocaleMeanAirwayPressure;
            UKLocaleMeanAirwayPressure = [self.meanAirwayPressure.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleMeanAirwayPressure = [self.meanAirwayPressure.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            // Inspired Oxygen
            NSString *UKLocaleInspiredOxygen;
            UKLocaleInspiredOxygen = [self.inspiredOxygen.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleInspiredOxygen = [self.inspiredOxygen.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            // Partial Pressure Oxygen
            NSString *UKLocalePartialPressureOxygen;
            UKLocalePartialPressureOxygen = [self.PaO2.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocalePartialPressureOxygen = [self.PaO2.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            // Calculation
            [self calculateOxygenationIndexFromMAP:[UKLocaleMeanAirwayPressure floatValue] andInspiredOxygen:[UKLocaleInspiredOxygen intValue] andPartialPressureOxygenkPa:[UKLocalePartialPressureOxygen floatValue]];
        }
    }
    else if (self.resultObtained) 
    {
        // clear all
        self.oxygenationIndex.textColor = [UIColor grayColor];
        self.oxygenationIndex.text = @"Calculate";
        self.meanAirwayPressure.text = @"";
        self.inspiredOxygen.text = @"";
        self.PaO2.text = @"";
        
        self.resultObtained = NO;
        
        // give focus to MAP textField
        [self.meanAirwayPressure becomeFirstResponder];
    }
}

#pragma mark - Table view delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // reset OI label if a result is showing
    if (!([self.oxygenationIndex.text isEqualToString:@"Calculate"]))
    {
        self.oxygenationIndex.textColor = [UIColor grayColor];
        self.oxygenationIndex.text = @"Calculate";
    }
    
    BOOL allowUserToChangeText = YES;
    
    // NSLog(@"string = %@", string);
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NSLog(@"newText = %@", newText);
    
    if ([textField isEqual:self.meanAirwayPressure]) 
    {
        // NSLog(@"Editing Mean Airway Pressure");
        
        if (newText.length > 4) 
        {
            return NO;
        }
        else if (newText.length == 1)
        {
            if ([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
    }
    else if ([textField isEqual:self.inspiredOxygen])
    {
        NSLog(@"Editing Inspired Oxygen");
        
        // does not allow decimal places to be entered
        // does no stop decimal places from being pasted in...
        if ([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]) 
        {
            return NO;
        }
        else if (newText.length == 1)
        {
            if ([string isEqualToString:@"0"])
            {
                return NO;
            }
        }
        else if (newText.length == 3)
        {
            if (!([newText intValue] == 100))
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"Maximum FiO2 is 100%" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                return NO;
            }
        }
        else if (newText.length > 3) 
        {
            return NO;
        }
    }
    else if ([textField isEqual:self.PaO2])
    {
        NSLog(@"Editing PaO2");
        // more code required...
        if (newText.length > 4)
        {
            return NO;
        }
    }
    
    return allowUserToChangeText; // is this actually used?
}

- (float)calculateOxygenationIndexFromMAP:(float)MAP andInspiredOxygen:(int)oxygen andPartialPressureOxygenkPa:(float)PaO2
{    
    float OI = 0.0f;
    
    switch (self.units.selectedSegmentIndex) 
    {
        case 0: // mmHg
            OI = ((oxygen * MAP) / PaO2);
            break;
            
        case 1: // kPa
            OI = ((oxygen * MAP) / (PaO2 * 7.5));
            break;
            
        default:
            break;
    }

    self.oxygenationIndex.textColor = [UIColor blackColor];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    // if locale has an arabic decimal separator then use english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    
    self.oxygenationIndex.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:OI]]];
    
    // self.oxygenationIndex.text = [NSString stringWithFormat:@"%.1f", OI];
    
    self.resultObtained = YES;
    self.validParametersEntered = NO;
    
    return OI;
}

- (void)changeUnits
{
    NSString *UKLocalePaO2;
    UKLocalePaO2 = [self.PaO2.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocalePaO2 = [self.PaO2.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    // if locale has an arabic decimal separator then use english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    
    switch (self.units.selectedSegmentIndex) 
    {
        case 0:
            // mmHg
            self.PaO2.placeholder = @"mm Hg";
            if (self.PaO2.text.length > 1) 
            {
                float newValue = [UKLocalePaO2 floatValue] * 7.5;
                
                self.PaO2.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:newValue]]];
            }
            break;
            
        case 1:
            // kPa
            self.PaO2.placeholder = @"kPa";
            
            if (self.PaO2.text.length > 1) 
            {
                float newValue = [UKLocalePaO2 floatValue] / 7.5;
                
                self.PaO2.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:newValue]]];
            }
            break;
            
        default:
            break;
    }
    
    // change preferences
    Preferences *preferences = [Preferences sharedPreferences];
    
    preferences.OIUnits = [NSString stringWithFormat:@"%i", self.units.selectedSegmentIndex];
}

@end
