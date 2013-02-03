//
//  EnterWeightViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "EnterWeightViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Patient.h"

@interface EnterWeightViewController ()

@property (nonatomic) BOOL userIsStartingToEnterGestationWhenNoWeightEntered;
@property (nonatomic) BOOL weightOrGestationMessageAlreadyDisplayed;
@property (nonatomic, strong) UISegmentedControl *centile;
@property (nonatomic, strong) NSString *selectedCentile;
@property (nonatomic, strong) UISegmentedControl *sex;
@property (nonatomic, strong) NSString *selectedSex;
@property (nonatomic, strong) CoolButton *button;
@property (nonatomic) BOOL userEditingTextField;
@property (nonatomic) BOOL editingModeOn;
@property (nonatomic) int gestationMode;

- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;
- (void)selectCentile;
- (void)selectSex;

@end

@implementation EnterWeightViewController

@synthesize userIsStartingToEnterGestationWhenNoWeightEntered = _userIsStartingToEnterGestationWhenNoWeightEntered;
@synthesize enterWeightViewControllerNavigationBarItem = _enterWeightViewControllerNavigationBarItem;
@synthesize weightOrGestationMessageAlreadyDisplayed = _weightOrGestationMessageAlreadyDisplayed;
@synthesize enterWeightViewControllerNavigationBar = _enterWeightViewControllerNavigationBar;
@synthesize allowUserToAccessPatientList = _allowUserToAccessPatientList;
@synthesize confidentialityModeOn = _confidentialityModeOn;
@synthesize navigationController = _navigationController;
@synthesize userEditingTextField = _userEditingTextField;
@synthesize selectedCentile = _selectedCentile;
@synthesize gestationMode = _gestationMode;
@synthesize editingModeOn = _editingModeOn;
@synthesize preferences = _preferences;
@synthesize myTableView = _myTableView;
@synthesize patientList = _patientList;
@synthesize selectedSex = _selectedSex;
@synthesize switchObj = _switchObj;
@synthesize eraseData = _eraseData;
@synthesize gestation = _gestation;
@synthesize delegate = _delegate;
@synthesize centile = _centile;
@synthesize weight = _weight;
@synthesize button = _button;
@synthesize sex = _sex;

// new properties
@synthesize NumberOfBabiesInBay1 = _NumberOfBabiesInBay1;
@synthesize NumberOfBabiesInBay2 = _NumberOfBabiesInBay2;
@synthesize NumberOfBabiesInBay3 = _NumberOfBabiesInBay3;
@synthesize NumberOfBabiesInLowDependency = _NumberOfBabiesInLowDependency;

- (Preferences *)preferences
{
    if (!_preferences) 
    {
        _preferences = [[Preferences alloc] init];
    }
    
    return _preferences;
}

# pragma mark

- (void)loadPatientList
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.patientList = [unarchiver decodeObjectForKey:@"PatientList"];
        self.preferences = [unarchiver decodeObjectForKey:@"Preferences"];
        
        [unarchiver finishDecoding];
    }
    else
    {
        self.patientList = [[NSMutableArray alloc] initWithCapacity:20];
        self.preferences = [[Preferences alloc] init];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        [self loadPatientList];
        
        self.view.backgroundColor = [UIColor blackColor];
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Custom initialization
        self.enterWeightViewControllerNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.enterWeightViewControllerNavigationBar.barStyle = UIBarStyleBlackOpaque;
        self.enterWeightViewControllerNavigationBar.tintColor = [UIColor blackColor];
        self.enterWeightViewControllerNavigationBar.delegate = self;
        [self.view addSubview:self.enterWeightViewControllerNavigationBar];
        
        self.enterWeightViewControllerNavigationBarItem = [[UINavigationItem alloc] initWithTitle:@"Enter Weight"];
        
        [self.enterWeightViewControllerNavigationBar pushNavigationItem:self.enterWeightViewControllerNavigationBarItem animated:YES];
        
        self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem = self.editButtonItem;
        self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem.enabled = NO;
        
        // Tableview
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 273.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped]; // 4 inch Retina
        self.myTableView.rowHeight = 50;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        
        // self.myTableView.backgroundView.opaque = YES;
        self.myTableView.separatorColor = [UIColor grayColor];
        
        // set background colour
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0)
        {
            if (appDelegate.window.bounds.size.height == 568)
            {
                // 4 inch Retina
                
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollViewBackground4inchRetina.png"]];
                [tempImageView setFrame:self.myTableView.frame];
                
                self.myTableView.backgroundView = tempImageView;
            }
            else
            {
                // 3.5 inch Retina
                
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScrollViewBackground35inchRetina.png"]];
                [tempImageView setFrame:self.myTableView.frame];
                
                self.myTableView.backgroundView = tempImageView;
            }
        }
        else
        {
            self.myTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        }
        
        [self.view addSubview:self.myTableView];
        
        self.confidentialityModeOn = YES;
        self.gestationMode = 0;
        self.selectedSex = @"Unknown";
        self.selectedCentile = @"50th";
    }
    return self;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"SimNICU.plist"];
}

- (void)savePatientList
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.patientList forKey:@"PatientList"];
    [archiver encodeObject:self.preferences forKey:@"Preferences"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    NSLog(@"PatientList saved to SimNICU.plist");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.myTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"EnterWeightViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"EnterWeightViewController DOES NOT UNLOAD properties");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if(section == 0)
    {
        if (self.gestationMode == 2)
        {
            rows = 5;
        }
        else if (self.gestationMode == 1)
        {
            rows = 4;
        }
        else 
        {
            rows = 3;
        }
    }
    else if(section == 1)
    {
        // patient list UISwitch and Passcode lock
        rows = 2;
    }
    else if(section == 2)
    {
        if (self.confidentialityModeOn) 
        {
            rows = 0;
        }
        else 
        {
            if ([self.patientList count] < 5) 
            {
                rows = [self.patientList count];
            }
            else 
            {
                // rows = 4;
                rows = [self.patientList count];
            }
        }
    }
    else
    {
        if (self.confidentialityModeOn) {
            rows = 0;
        }
        else 
        {
            rows = 1;
        }
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat result = 0;
    
    if (!self.confidentialityModeOn) 
    {
        if(section == 2)
        {
            // result = 30;
            
            result = 0;
        }
    }
    
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    return view;  // delete this
    
    if (!self.confidentialityModeOn) 
    {
        if (section == 2) 
        {
            
            UIView *headerView;
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            
            // headerLabel.textColor = [UIColor whiteColor];
            headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            headerLabel.shadowColor = [UIColor whiteColor];
            headerLabel.shadowOffset = CGSizeMake(0, 1);
            headerLabel.backgroundColor = [self.myTableView backgroundColor];
            headerLabel.opaque = YES;
            headerLabel.font = [UIFont boldSystemFontOfSize:18];
            // headerLabel.textAlignment = UITextAlignmentCenter;
            
            headerLabel.text = @"Bay 1";
            
            [headerView addSubview:headerLabel];
            
            view = headerView;
        }
        else if (section == 3) 
        {
            UIView *headerView;
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            
            // headerLabel.textColor = [UIColor whiteColor];
            headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            headerLabel.shadowColor = [UIColor whiteColor];
            headerLabel.shadowOffset = CGSizeMake(0, 1);
            headerLabel.backgroundColor = [self.myTableView backgroundColor];
            headerLabel.opaque = YES;
            headerLabel.font = [UIFont boldSystemFontOfSize:18];
            // headerLabel.textAlignment = UITextAlignmentCenter;
            
            headerLabel.text = @"Bay 2";
            
            [headerView addSubview:headerLabel];
            
            view = headerView;
        }
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"WeightCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.weight = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 120, 30)];
            self.weight.borderStyle = UITextBorderStyleRoundedRect;
            self.weight.placeholder = NSLocalizedString(@"kilograms", nil);
            self.weight.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.weight.clearButtonMode = UITextFieldViewModeAlways;
            self.weight.delegate = self;
            self.weight.tag = 10;
            
            //use the new decimal pad if using iOS 4.1 or greater
            if((UIKeyboardTypeDecimalPad) && ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1))
            {
                [self.weight setKeyboardType:UIKeyboardTypeDecimalPad];
                [self.weight setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            self.weight.textAlignment = UITextAlignmentLeft;
            cell.accessoryView = self.weight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = NSLocalizedString(@"Weight", nil);
            
            returnCell = cell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"GestationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.gestation = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 120, 30)];
            self.gestation.borderStyle = UITextBorderStyleRoundedRect;
            self.gestation.placeholder = NSLocalizedString(@"weeks", nil);
            self.gestation.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.gestation.clearButtonMode = UITextFieldViewModeAlways;
            self.gestation.delegate = self;
            self.gestation.tag = 20;
            
            //use the new decimal pad if using iOS 4.1 or greater
            if((UIKeyboardTypeDecimalPad) && ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1))
            {
                [self.gestation setKeyboardType:UIKeyboardTypeDecimalPad];
                [self.gestation setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            self.gestation.textAlignment = UITextAlignmentLeft;
            cell.accessoryView = self.gestation;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestationSwipeLeft:)];
            swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            // swipeLeft.delegate = self;
            [cell addGestureRecognizer:swipeLeft];
            
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestationSwipeRight:)];
            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
            [cell addGestureRecognizer:swipeRight];
            
            
            cell.textLabel.text = @"Gestation";
            
            returnCell = cell;
        }
        else if(indexPath.row == 4)
        {
            static NSString *CellIdentifier = @"DoneCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            }
            
            self.button = [[CoolButton alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
            [self.button addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
            self.button.selected = NO;
            [self.button setTitle:NSLocalizedString(NSLocalizedString(@"Done", nil), nil) forState:UIControlStateNormal];
            self.button.buttonColor = [UIColor darkGrayColor];
            
            cell.accessoryView = self.button;
            cell.textLabel.text = @"";
            
            returnCell = cell;
        }
        else if(indexPath.row == 2)
        {
            // if (self.userIsStartingToEnterGestationWhenNoWeightEntered)
            if (self.gestationMode == 1 || self.gestationMode == 2)
            {
                static NSString *CellIdentifier = @"SexCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                self.sex = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Male", @"Female", @"Unknown", nil]];
                self.sex.frame = CGRectMake(1.0, 1.0, 240, 40);
                self.sex.tintColor = [UIColor grayColor];
                
                self.sex.segmentedControlStyle = UISegmentedControlStyleBar;
                self.sex.selectedSegmentIndex = 2;
                
                [self.sex addTarget:self 
                             action:@selector(selectSex) 
                   forControlEvents:UIControlEventValueChanged];
                
                cell.accessoryView = self.sex;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                returnCell = cell;
            }
            else 
            {
                static NSString *CellIdentifier = @"DoneCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                self.button = [[CoolButton alloc] initWithFrame:CGRectMake(1.0, 1.0, 120, 30)];
                [self.button addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
                [self.button setSelected:NO];
                [self.button setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
                [self.button setButtonColor:[UIColor darkGrayColor]];
                
                cell.accessoryView = self.button;
                cell.textLabel.text = @"";
                
                returnCell = cell;
            }
            
        }
        else if(indexPath.row == 3)
        {
            // if (self.userIsStartingToEnterGestationWhenNoWeightEntered)
            if (self.gestationMode == 2)
            {
                static NSString *CellIdentifier = @"PercentileCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                self.centile = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"0.4th", @"9th", @"50th", nil]];
                self.centile.frame = CGRectMake(1.0, 1.0, 240, 40);
                self.centile.tintColor = [UIColor grayColor];
                
                self.centile.segmentedControlStyle = UISegmentedControlStyleBar;
                self.centile.selectedSegmentIndex = 2;
                
                [self.centile addTarget:self 
                                 action:@selector(selectCentile) 
                       forControlEvents:UIControlEventValueChanged];
                
                
                cell.accessoryView = self.centile;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                returnCell = cell;
            }
            else 
            {
                static NSString *CellIdentifier = @"DoneCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                self.button = [[CoolButton alloc] initWithFrame:CGRectMake(1.0, 1.0, 120, 30)];
                [self.button addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchDown];
                [self.button setSelected:NO];
                [self.button setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
                [self.button setButtonColor:[UIColor darkGrayColor]];
                
                cell.accessoryView = self.button;
                cell.textLabel.text = @"";
                
                returnCell = cell;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // define switch row
            static NSString *CellIdentifier = @"ConfidentialitySwitch";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
            
            self.switchObj.on = !self.confidentialityModeOn;
            [self.switchObj addTarget:self action:@selector(patientConfidentialityModeToggle) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
            cell.accessoryView = self.switchObj;
            
            cell.textLabel.text = NSLocalizedString(@"Patient list", nil);
            
            returnCell = cell;
            
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Password row";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Passcode Lock", nil);
            
            if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) 
            {
                cell.detailTextLabel.text = NSLocalizedString(@"On", "");
            } else 
            {
                cell.detailTextLabel.text = NSLocalizedString(@"Off", "");
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"PatientCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Patient *thisPatient = (Patient *)[self.patientList objectAtIndex:indexPath.row];
        
        if ([thisPatient.lastname isEqualToString:@""]) 
        {
            thisPatient.lastname = @"BABY";
            thisPatient.firstname = @"New";
        }
        else 
        {
            if ([thisPatient.firstname isEqualToString:@""]) 
            {
                thisPatient.firstname = @"Baby";
            }
        }
        
        NSString *name = [NSString stringWithFormat:@"%@ %@",[thisPatient firstname], [thisPatient lastname]];
        
        NSString *details;
        
        if ([thisPatient.firstname isEqualToString:@"add"] && [thisPatient.lastname isEqualToString:@"new patient"]) 
        {
            details = @"";
        }
        else if (!thisPatient.birthWeight && !thisPatient.gestation)
        {
            details = @"";
        }
        else if (thisPatient.birthWeight && !thisPatient.gestation)
        {
            NSString *rawBirthWeight = [thisPatient birthWeight];
            NSString *formattedBirthWeight;
            
            NSString *rawWorkingWeight = [thisPatient workingWeight];
            NSString *formattedWorkingWeight;
            
            // format birth weight
            NSString *UKLocaleRawBirthWeight;
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
            
            if(birthWeightKGAsFloat < 1)
            {
                // convert to grams as use integer
                int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
                formattedBirthWeight = [NSString stringWithFormat:@"%i grams", birthWeightGRAMSasInt];
            }
            else 
            {
                formattedBirthWeight = [NSString stringWithFormat:@"%@ kg", rawBirthWeight];
            }
            
            // format working weight
            NSString *UKLocaleRawWorkingWeight;
            UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float workingWeightKGAsFloat = [UKLocaleRawWorkingWeight floatValue];
            if(workingWeightKGAsFloat < 1)
            {
                // convert to grams as use integer
                int workingWeightGRAMSasInt = workingWeightKGAsFloat * 1000;
                formattedWorkingWeight = [NSString stringWithFormat:@"%i grams", workingWeightGRAMSasInt];
            }
            else 
            {
                formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", rawWorkingWeight];
            }
            
            details = [NSString stringWithFormat:@"Birth Weight %@", formattedBirthWeight];
        }
        else if (thisPatient.gestation && !thisPatient.birthWeight)
        {
            details = [NSString stringWithFormat:@"%@/40 gestation - no weight", thisPatient.gestation];
        }
        else if (thisPatient.gestation && thisPatient.birthWeight)
        {
            NSString *rawBirthWeight = [thisPatient birthWeight];
            NSString *formattedBirthWeight;
            
            NSString *rawWorkingWeight = [thisPatient workingWeight];
            NSString *formattedWorkingWeight;
            
            // format birth weight
            NSString *UKLocaleRawBirthWeight;
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
            
            if(birthWeightKGAsFloat < 1)
            {
                // convert to grams as use integer
                int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
                formattedBirthWeight = [NSString stringWithFormat:@"%i grams", birthWeightGRAMSasInt];
            }
            else 
            {
                formattedBirthWeight = [NSString stringWithFormat:@"%@ kg", rawBirthWeight];
            }
            
            // format working weight
            NSString *UKLocaleRawWorkingWeight;
            UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float workingWeightKGAsFloat = [UKLocaleRawWorkingWeight floatValue];
            if(workingWeightKGAsFloat < 1)
            {
                // convert to grams as use integer
                int workingWeightGRAMSasInt = workingWeightKGAsFloat * 1000;
                formattedWorkingWeight = [NSString stringWithFormat:@"%i grams", workingWeightGRAMSasInt];
            }
            else 
            {
                formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", rawWorkingWeight];
            }
            
            if (thisPatient.workingWeight && thisPatient.birthDate)
            {
                // details = [NSString stringWithFormat:@"%@ (%@) now %@ (ww %@)", [thisPatient gestation], formattedBirthWeight, [thisPatient correctedGestation], formattedWorkingWeight];
                
                details = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", [thisPatient gestation], formattedBirthWeight, [self calculateCurrentGestation:thisPatient], formattedWorkingWeight];
                thisPatient.correctedGestation = [self calculateCurrentGestation:thisPatient];
            }
            else 
            {
                details = [NSString stringWithFormat:@"%@/40 birth weight %@", [thisPatient gestation], formattedBirthWeight];
            }
        }
        
        //
        //Create patient details cell
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        [cell.textLabel setText:name];
        [cell.detailTextLabel setText:details];
        
        if ([thisPatient.NewBabyAPGARSSaved isEqualToString:@"YES"]) 
        {
            cell.detailTextLabel.text = @"APGARS saved";
        }
        
        returnCell = cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"BayCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            // cell.textLabel.minimumFontSize = 14;
            [cell setBackgroundColor:[UIColor whiteColor]];
            
        }
        
        cell.textLabel.text = @"Organise bays";
        
        returnCell = cell;
    }
    
    return returnCell;
}

# pragma mark Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    
    // only allow editing in PatientList if patient list is on
    if(!self.confidentialityModeOn && self.editingModeOn)
    {
        if (indexPath.section == 2) 
        {
            result = YES;
        }
    }
    
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (!self.confidentialityModeOn)
    {
        [super setEditing:editing animated:animated];
        
        if (editing) 
        {
            self.editingModeOn = YES;
            
            int newRowIndex = [self.patientList count];
            
            Patient *newPatient = [[Patient alloc] init];
            newPatient.firstname = @"add";
            newPatient.lastname = @"new patient";
            
            [self.patientList addObject:newPatient];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:2];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else 
        {
            NSLog(@"not editing");
            
            self.editingModeOn = NO;
            
            int oldRowIndex = [self.patientList count]-1;
            
            [self.patientList removeLastObject];
            
            // [self savePatientList];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldRowIndex inSection:2];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        
        [self.myTableView setEditing:editing animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editingModeOn)
    {
        if (indexPath.section == 2) 
        {
            NSLog(@"([self.patientList count] - 1) = %i", ([self.patientList count] - 1));
            if (indexPath.row == ([self.patientList count] -1))
            {
                return UITableViewCellEditingStyleInsert;
            }
            else
            {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    else 
    {
        if (indexPath.section == 2) 
        {
            if (indexPath.row == [self.patientList count]) 
            {
                return UITableViewCellEditingStyleInsert;
            }
            else
            {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        // check if a delete row
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            [self.patientList removeObjectAtIndex:indexPath.row];
            
            // [self savePatientList];
            
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            [self addPatient];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // BOOL result = YES;
    BOOL result = NO;
    
    if (indexPath.section == 2)
    {
        NSInteger lastRow = [self.patientList count] -1;
        
        if (indexPath.row == lastRow) 
        {
            result = NO;
        }
        else {
            result = YES;
        }
    }
    
    return result;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(sourceIndexPath.section != proposedDestinationIndexPath.section)
    {
        // ensures that if reorder above patient section, sets final place at top of list
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) 
        {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] -2;
        }
        
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    else
    {
        // ensures reorder does not place row beyond new patient cell.
        NSInteger lastRow = [self.patientList count];
        
        if (proposedDestinationIndexPath.row == lastRow -1) 
        {
            return [NSIndexPath indexPathForRow:(lastRow -2) inSection:2];
        }
        
        return proposedDestinationIndexPath;
    }
}

// reorder data source after move
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Patient *patient = [self.patientList objectAtIndex:sourceIndexPath.row];
    
    [self.patientList removeObjectAtIndex:(sourceIndexPath.row)];
    [self.patientList insertObject:patient atIndex:(destinationIndexPath.row)];
    
    // [self savePatientList];
}

# pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == 1) 
    {
        if (indexPath.row == 1 || indexPath.row == 2)
        {
            path = indexPath;
        }
    }
    else if (indexPath.section == 2)
    {
        path = indexPath;
    }
    else if (indexPath.section == 3)
    {
        path = indexPath;
    }
    return path;
}

// select patient details
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        KKPasscodeSettingsViewController *controller = [[KKPasscodeSettingsViewController alloc] init];
        controller.delegate = self;
        
        PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:controller];
        
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        navController.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentModalViewController:navController animated:YES];
    }
    else if(indexPath.section == 2)
    {
        Patient *patient = [self.patientList objectAtIndex:indexPath.row];
        
        
        if (!patient.birthWeight && !patient.gestation && !patient.workingWeight) 
        {
            // no usable data
            // present warning if not already shown before
            
            if (!self.weightOrGestationMessageAlreadyDisplayed) 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"A weight and/or gestation needs to be entered in order to use this patient" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.weightOrGestationMessageAlreadyDisplayed = YES;
            }
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"To use this patient, please click on the blue arrow to enter the baby's birth weight, or gestation." 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        else 
        {
            if (patient.birthWeight && !patient.workingWeight) 
            {
                // could enter a check to see if user want to use birth weight as working weight.
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Message" 
                                          message:@"Working weight set to birth weight" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                patient.workingWeight = patient.birthWeight;
                
                if (patient.birthDate) 
                {
                    patient.workingWeightDate = patient.birthDate;
                }
                else 
                {
                    patient.workingWeightDate = [NSDate date];
                }
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                [formatter setDateStyle:NSDateFormatterShortStyle];
                
                patient.formattedWorkingWeightDate = [formatter stringFromDate:patient.workingWeightDate];
                
                [self.myTableView reloadData];
            }
            
            [self.delegate enterWeightViewController:self didFinishSelectingPatient:patient];
            
            // display front ViewController
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.parentViewController;
            [revealController revealToggle:self];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    PatientDetailsViewController *patientDetailsViewController = [[PatientDetailsViewController alloc] init];
    
    patientDetailsViewController.delegate = self;
    
    Patient *patient = [self.patientList objectAtIndex:indexPath.row];
    
    patient.NewBabyAPGARSSaved = NULL;
    
    patientDetailsViewController.patientToEdit = patient;
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:patientDetailsViewController];
    
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    [self presentModalViewController:navController animated:YES];
}

# pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NSLog(@" ");
    // NSLog(@"newText = %@", newText);
    // NSLog(@"newText.length = %i", newText.length);
    // NSLog(@"string = %@", string);
    
    if ([textField isEqual:self.weight]) 
    {
        if(newText.length > 5)
        {
            allowUserToChangeText = NO;
        }
        if(newText.length == 1)
        {
            if([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                self.weight.text = @"0";
            }
            else if ([string intValue] > 1)
            {
                if ([string intValue] > 6) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"This is a Neonatal App" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
            
        }
        else if(newText.length == 2)
        {
            // first character is a "."
            // if([[newText substringToIndex:1] isEqualToString:@"."] || [[newText substringToIndex:1] isEqualToString:@","])
            if([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if(![[newText substringWithRange:NSMakeRange(1, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"This is a Neonatal App, weight must be less than 10 kg" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.weight.text = @"";
                
                return NO;
            }
        }
        else if(newText.length == 3)
        {            
            // first character is a "."
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
        else if(newText.length == 4)
        {
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(3, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
        else if(newText.length == 5)
        {
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(3, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(4, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
    }
    else if ([textField isEqual:self.gestation]) 
    {
        // NSLog(@"validating Gestation");
        if (newText.length > 0)
        {
            // NSLog(@"newText substringToIndex:1 = %@", [newText substringToIndex:1]);
        }
        
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // NSLog(@"textFieldDidBeginEditing");
    
    // This prevents user from hiding the rear view controller when entering numeric data
    
    self.userEditingTextField = YES; 
    
    // if user has not entered a weight, and is just entering a gestation, then assume they do not know the weight
    // and a selection for sex must be made
    
    // therefore open up a new cell for sex selection
    // must therefore need a private boolean to control this in the table view data source
    
    int tag = textField.tag;
    
    if (tag == 10)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    if (tag == 20)
    {
        // NSLog(@"Editing Gestation");
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        
        [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int tag = textField.tag;
    
    if (tag == 10) 
    {
        // NSLog(@"Validate weight");
    }
    else if (tag == 20)
    {
        // NSLog(@"Validate gestation");
        
    }
    
    self.userEditingTextField = NO;
}

# pragma mark

- (NSString *)formatWeight:(NSNumber *)weightInGrams
{
    NSString *formattedWeight = @"Unknown";
    
    if([weightInGrams intValue] > 1000)
    {
        // return in kilos
        float kilos = ([weightInGrams floatValue] / 1000);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        // if using arabic locale, force to english
        if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
        {
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        }
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        formattedWeight = [NSString stringWithFormat:@"%@kg", [formatter stringFromNumber:[NSNumber numberWithFloat:kilos]]];
        
        // formattedWeight = [NSString stringWithFormat:@"%1.2fkg",kilos];
    }
    else
    {
        // return in grams
        formattedWeight = [NSString stringWithFormat:@"%@g",weightInGrams];
    }
    
    return formattedWeight;
}


- (NSString *)calculateCurrentGestation:(Patient *)patient
{
    NSString *currentGestation = @"0+0";
    
    NSDate *now = [[NSDate alloc] init];
    
    int daysDifference = [self getDaysDifferenceBetween:patient.birthDate and:now];
    int weeksDifference = daysDifference / 7;
    int plusDays = (daysDifference - (weeksDifference * 7));
    int gestationWeeks = [[patient.gestation substringToIndex:2] intValue];
    int gestationDays;
    
    if ([patient.gestation length] > 3) 
    {
        gestationDays = [[patient.gestation substringFromIndex:2] intValue];
    }
    else gestationDays = 0;
    
    int correctedGestationWeeks = gestationWeeks + weeksDifference;
    
    int correctedGestationDays = gestationDays + plusDays;
    
    if (correctedGestationDays > 6) 
    {
        correctedGestationWeeks = correctedGestationWeeks + 1;
        correctedGestationDays = correctedGestationDays - 7;
    }
    
    currentGestation = [NSString stringWithFormat:@"%d+%d",correctedGestationWeeks, correctedGestationDays];
    
    return currentGestation;
}

- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    if ([dateA isEqualToDate:dateB])
        return 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *dateToRound = [dateA earlierDate:dateB];
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    NSDateComponents * dateComponents = 
    [gregorian components:flags fromDate:dateToRound];
    
    NSDate * roundedDate = [gregorian dateFromComponents:dateComponents];
    
    NSDate * otherDate = (dateToRound == dateA) ? dateB : dateA ;
    
    NSInteger diff = abs([roundedDate timeIntervalSinceDate:otherDate]);
    
    NSInteger daysDifference = floor(diff/(24 * 60 * 60));
    
    return daysDifference;
}

- (void)addPatient
{
    NSLog(@"addPatient");
    
    PatientDetailsViewController *patientDetailsViewController = [[PatientDetailsViewController alloc] init];
    patientDetailsViewController.delegate = self;
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:patientDetailsViewController];
    
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    patientDetailsViewController.userWantsToAddAPatient = @"YES";
    
    [self presentModalViewController:navController animated:YES];
}

- (void)selectSex
{
    if (self.sex.selectedSegmentIndex == 0) {
        self.selectedSex = @"Male";
    }
    else if (self.sex.selectedSegmentIndex == 1)
    {
        self.selectedSex = @"Female";
    }
    else {
        self.selectedSex = @"Unknown";
    }
    
    NSLog(@"Sex selected: %@", self.selectedSex);
}

- (void)selectCentile
{
    if (self.centile.selectedSegmentIndex == 0) {
        self.selectedCentile = @"0.4th";
    }
    else if (self.centile.selectedSegmentIndex == 1)
    {
        self.selectedCentile = @"9th";
    }
    else {
        self.selectedCentile = @"50th";
    }
    
    NSLog(@"Centile selected: %@", self.selectedCentile);
}

- (void)dismissKeyboard
{
    [self.weight resignFirstResponder];
    [self.gestation resignFirstResponder];
    
    if (self.gestation.text.length == 3) 
    {
        self.gestation.text = [self.gestation.text substringToIndex:2];
    }
    
    [self.delegate enterWeightViewController:self didFinishEnteringWeight:self.weight.text orGestation:self.gestation.text forSex:self.selectedSex atCentile:self.selectedCentile];
    
    ZUUIRevealController *revealController = (ZUUIRevealController *)self.parentViewController;
    [revealController revealToggle:self];
}

- (void)patientConfidentialityModeToggle
{
    if (!self.confidentialityModeOn) 
    {
        if (self.editingModeOn) 
        {
            [self setEditing:NO animated:YES];
        }
        // ie close patient list
        self.confidentialityModeOn = !self.confidentialityModeOn;
        
        if (!self.confidentialityModeOn) {
            // enable edit button
            self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem.enabled = YES;
        }
        else {
            self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem.enabled = NO;
        }
        
        // reload table
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else  // ie opening patient list
    {
        // first check if passcode set
        if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) 
        {            
            KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
            vc.mode = KKPasscodeModeEnter;
            vc.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(),^
            {
                PortraitOnlyNavigationController *nav = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    nav.modalPresentationStyle = UIModalPresentationFormSheet;
                    nav.navigationBar.barStyle = UIBarStyleBlack;
                    nav.navigationBar.opaque = NO;
                } else {
                    nav.navigationBar.tintColor = _navigationController.navigationBar.tintColor;
                    nav.navigationBar.translucent = _navigationController.navigationBar.translucent;
                    nav.navigationBar.opaque = _navigationController.navigationBar.opaque;
                    nav.navigationBar.barStyle = _navigationController.navigationBar.barStyle;    
                }
                
                nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
                nav.navigationBar.tintColor = [UIColor blackColor];
                
                [self presentModalViewController:nav animated:YES];
            });
            
        }
        
        self.confidentialityModeOn = !self.confidentialityModeOn;
        
        if (!self.confidentialityModeOn) 
        {
            // enable edit button
            self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem.enabled = YES;
        }
        else 
        {
            self.enterWeightViewControllerNavigationBarItem.leftBarButtonItem.enabled = NO;
        }
        
        // reload section 2
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // if patient array is empty then go straight into edit mode
        if ([self.patientList count]) // there is a patient in the list
        {
            NSLog(@"There is a patient in the list");
        }
        else // there isn't
        {
            [self setEditing:YES animated:YES];
        }
    }
}

- (void)handleGestationSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (self.gestationMode == 0)
    {
        self.gestationMode = 1;
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    else if (self.gestationMode == 1)
    {
        NSLog(@"Commented out until all growth chart data entered");
        
        // self.gestationMode = 2;
        
        // [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)handleGestationSwipeRight:(UISwipeGestureRecognizer *)recogniser
{
    if (self.gestationMode == 2)
    {
        self.gestationMode = 1;
        
        self.selectedCentile = @"50th";
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if (self.gestationMode == 1)
    {
        self.gestationMode = 0;
        
        self.selectedSex = @"Unknown";
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}

# pragma mark - PatientDetailsViewController delegate methods

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishAddingPatient:(Patient *)patient
{
    NSLog(@"didFinishAddingPatient");
    
    [self setEditing:NO animated:YES];
    
    int newRowIndex = [self.patientList count];
    [self.patientList addObject:patient];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:2];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishEditingPatient:(Patient *)patient
{
    NSLog(@"didFinishEditingPatient");
    // int index = [self.patientList indexOfObject:patient];
    
    // Patient *oldPatient = [self.patientList objectAtIndex:index];
    // oldPatient.lastname = patient.lastname;
    // oldPatient.firstname = patient.firstname;
    
    // NSString *name = [NSString stringWithFormat:@"%@ %@",[oldPatient firstname], [oldPatient lastname]];
    
    
    // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    // UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    
    // cell.textLabel.text = name;
    
    [self.myTableView reloadData];
    
    // [self savePatientList];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)patientDetailsViewControllerDidCancel:(PatientDetailsViewController *)controller
{
    NSLog(@"patientDetailsViewControllerDidCancel");
    
    [self dismissModalViewControllerAnimated:YES];
}

# pragma mark - ZUUIRevealController delegate methods

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController
{
    // return NO if userEditingTextField = YES
    return (!self.userEditingTextField);
}

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController;
{
    if (self.editingModeOn)
    {
        // set editing to no
        [self setEditing:NO animated:YES];
    }
}

- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController
{
    /*
     self.userIsStartingToEnterGestationWhenNoWeightEntered = NO;
     
     [self.myTableView reloadData];
     
     NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
     
     [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
     
     
     // code here: set sex buttons to 'unknown'
     */
}

#pragma mark - APGARTabBarController delegate

- (void)APGARTabBarController:(APGARTabBarController *)controller didFinishEnteringAPGARValuesForANewPatient:(Patient *)patient
{
    patient.firstname = @"New";
    patient.lastname = @"BABY";
    
    patient.NewBabyAPGARSSaved = @"YES";
    
    patient.birthDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    patient.formattedBirthDate = [formatter stringFromDate:patient.birthDate];
    
    [self.patientList addObject:patient];
    
    [self.myTableView reloadData];
}

#pragma mark - OxygenationIndexViewController delegate

- (void)oxygenationIndexViewController:(OxygenationIndexViewController *)controller didChangePaO2Units:(int)index
{
    self.preferences.OIUnits = [NSString stringWithFormat:@"%i", index];
}

#pragma mark - PhototherapyViewController delegate

- (void)phototherapyViewController:(PhototherapyViewController *)controller didChangeGuidelineCountry:(NSString *)guidelineCountry
{
    // NSLog(@"EnterWeightViewController: phototherapyViewController didChangeGuidelineCountry");
    
    self.preferences.guidelineCountry = guidelineCountry;
}

- (void)phototherapyViewController:(PhototherapyViewController *)controller didChangeBilirubinUnit:(NSString *)bilirubinUnit
{
    // NSLog(@"EnterWeightViewController: phototherapyViewController didChangeBilirubinUnit");
    
    self.preferences.bilirubinUnits = bilirubinUnit;
}

#pragma mark - IntubationViewController delegate

- (void)intubationViewController:(IntubationViewController *)controller didChangeETTRoundUp:(BOOL)selected
{
    self.preferences.ETTRoundUp = [NSString stringWithFormat:@"%i", selected];
    
    NSLog(@"In EnterWeightViewController. selected = %i", selected);
}

#pragma mark - KKPasscodeViewController delegate

- (void)didPasscodeEnteredCorrectly:(KKPasscodeViewController *)viewController
{
    NSLog(@"didPasscodeEnteredCorrectly");
}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    self.switchObj.on = NO;
    [self patientConfidentialityModeToggle];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController 
{
    [self.patientList removeAllObjects];
    [self savePatientList];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times. All account data in this app has been deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    self.switchObj.on = NO;
    [self patientConfidentialityModeToggle];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - KKPasscodeSettingsViewController delegate

- (void)didSettingsChanged:(KKPasscodeSettingsViewController*)viewController
{
    [self.myTableView reloadData];
} 

@end
