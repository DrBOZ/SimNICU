//
//  EnterWeightViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/09/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "SettingsTableViewController.h"
#import "EnterWeightViewController.h"
#import "SyncTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ROPViewController.h"
#import "CBBarButtonItems.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"
#import "PatientCell.h"
#import "Patient.h"
#import "Bay.h"

@interface EnterWeightViewController ()

@property (nonatomic) BOOL userIsStartingToEnterGestationWhenNoWeightEntered;
@property (nonatomic) BOOL weightOrGestationMessageAlreadyDisplayed;
@property (nonatomic, strong) NSString *patientListSwipeText;
@property (nonatomic, strong) NSString *gestationSwipeText;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UISegmentedControl *centile;
@property (nonatomic, strong) NSString *selectedCentile;
@property (nonatomic, strong) UISegmentedControl *sex;
@property (nonatomic, strong) NSString *selectedSex;
@property (nonatomic, strong) CoolButton *button;
@property (nonatomic) BOOL userEditingTextField;
@property (nonatomic) BOOL editingModeOn;
@property (nonatomic) int gestationMode;

- (void)selectCentile;
- (void)selectSex;

@end

@implementation EnterWeightViewController
{
    UIView *tapView;
    CGFloat iOS7Adjustment;
}

- (NSMutableArray *)bayData
{
    if (!_bayData)
    {
        _bayData = [[NSMutableArray alloc] initWithCapacity:7];
        
        // add default bay data
        Bay *bay1 = [[Bay alloc] init];
        bay1.bayName = @"Bay 1";
        bay1.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [_bayData addObject:bay1];
        
        Bay *bay2 = [[Bay alloc] init];
        bay2.bayName = @"Bay 2";
        bay2.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [_bayData addObject:bay2];
        
        Bay *bay3 = [[Bay alloc] init];
        bay3.bayName = @"Bay 3";
        bay3.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [_bayData addObject:bay3];
        
        Bay *bay4 = [[Bay alloc] init];
        bay4.bayName = @"Low Dependency";
        bay4.patientsInBay = [[NSMutableArray alloc] initWithCapacity:8];
        
        [_bayData addObject:bay4];
        
        Bay *bay5 = [[Bay alloc] init];
        bay5.bayName = @"Transitional Care";
        bay5.patientsInBay = [[NSMutableArray alloc] initWithCapacity:8];
        
        [_bayData addObject:bay5];
        
        Bay *bay6 = [[Bay alloc] init];
        bay6.bayName = @"Postnatal Ward";
        bay6.patientsInBay = [[NSMutableArray alloc] initWithCapacity:20];
        
        [_bayData addObject:bay6];
        
        Bay *bay7 = [[Bay alloc] init];
        bay7.bayName = @"Misc";
        bay7.patientsInBay = [[NSMutableArray alloc] initWithCapacity:20];
        
        Patient *patient;
        
        for (patient in self.patientList)
        {
            [bay7.patientsInBay addObject:patient];
        }
        
        [_bayData addObject:bay7];
    }
    
    return _bayData;
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
        
        Preferences *preferences = [Preferences sharedPreferences];
        preferences = [unarchiver decodeObjectForKey:@"Preferences"];
        
        self.bayData = [unarchiver decodeObjectForKey:@"BayData"];
        
        [unarchiver finishDecoding];
    }
    else
    {
        self.patientList = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        [self loadPatientList];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // sets the color of navigation bar
            // self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
            // self.navigationController.view.tintColor = [UIColor redColor];
            iOS7Adjustment = 20.0f + 44.0f;
        }
        else
        {
            // iOS 6 colourings
            self.view.backgroundColor = [UIColor blackColor];
        }
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Custom initialization
        self.enterWeightViewControllerNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
        self.enterWeightViewControllerNavigationBar.barStyle = UIBarStyleBlackOpaque;
        self.enterWeightViewControllerNavigationBar.tintColor = [UIColor blackColor];
        self.enterWeightViewControllerNavigationBar.delegate = self;
        [self.view addSubview:self.enterWeightViewControllerNavigationBar];
        
        // Edit button
        self.enterWeightViewControllerNavigationItem = [[UINavigationItem alloc] init];
        self.enterWeightViewControllerNavigationItem.leftBarButtonItem = self.editButtonItem;
        self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = NO;
        
        // Flexible space to align custom buttons
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        // Settings button
        UIBarButtonItem *settingsButton = [CBBarButtonItems customBarButtonWithImageFile:@"settings.png"
                                                                                  target:self
                                                                                  action:@selector(showSettings)];
    
        // create array
        
#if SYNC_PREVIEW_MODE
        
        // Sync button
        UIBarButtonItem *syncButton = [CBBarButtonItems customBarButtonWithImageFile:@"sync.png"
                                                                              target:self
                                                                              action:@selector(showSync)];
        
        NSArray *items = [NSArray arrayWithObjects:flexibleItem, flexibleItem, settingsButton, flexibleItem, syncButton, flexibleItem, nil];
#else
        NSArray *items = [NSArray arrayWithObjects:flexibleItem, flexibleItem, settingsButton, flexibleItem, flexibleItem, flexibleItem, nil];
#endif
        
        self.enterWeightViewControllerNavigationItem.rightBarButtonItems = items;
        
        // push to navigation bar
        [self.enterWeightViewControllerNavigationBar pushNavigationItem:self.enterWeightViewControllerNavigationItem animated:NO];
        
        // Tableview
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 273.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped]; // 4 inch Retina
        self.myTableView.rowHeight = 50;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        
        // self.myTableView.backgroundView.opaque = YES;
        self.myTableView.separatorColor = [UIColor grayColor];
        
        // set background colour
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.myTableView.frame = CGRectMake(0.0f, 0.0f, 273.0f, (appDelegate.window.bounds.size.height));
        }
        else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0)
        {
            if (appDelegate.window.bounds.size.height == 568)
            {
                // 4 inch Retina
                
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
                [tempImageView setFrame:self.myTableView.frame];
                
                self.myTableView.backgroundView = tempImageView;
            }
            else
            {
                // 3.5 inch Retina
                
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
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
        
        Preferences *preferences = [Preferences sharedPreferences];
        
        if (![preferences.userKnowsHowToSwipeGestation isEqualToString:@"YES"])
        {
            self.gestationSwipeText = @"swipe left";
        }
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
#ifdef LITE_VERSION
    
    return [[self documentsDirectory] stringByAppendingPathComponent:@"SimNICU-Lite.plist"];
    
#else
    
    return [[self documentsDirectory] stringByAppendingPathComponent:@"SimNICU.plist"];
    
#endif
    
}

- (void)savePatientList
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.patientList forKey:@"PatientList"];
    [archiver encodeObject:preferences forKey:@"Preferences"];
    [archiver encodeObject:self.bayData forKey:@"BayData"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    
#ifdef LITE_VERSION
    
    NSLog(@"PatientList saved to SimNICU-Lite.plist");
    
#else
    
    NSLog(@"PatientList saved to SimNICU.plist");
    
#endif

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Ensure that there is at least one bay
    if ([self.bayData count] == 0)
    {
        // create bay
        Bay *bay = [[Bay alloc] init];
        bay.bayName = @"Patients";
        bay.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self.bayData addObject:bay];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
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
    return [self.bayData count] + 2;
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
        else if (self.gestationMode == 1)  // Advanced settings: Male / Female / Unknown displayed
        {
            rows = 4;
        }
        else 
        {
            rows = 3;
        }
    }
    else if(section == 1) // patient list UISwitch and Passcode lock
    {
        rows = 2;
    }
    else
    {
        if (self.confidentialityModeOn) 
        {
            rows = 0;
        }
        else 
        {
            // lookup how many patients in bay
            rows = [[self.bayData[section - 2] patientsInBay] count];
        }
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat result = 0.0f;
    
    if (!self.confidentialityModeOn)
    {
        if(!(section == 0 || section == 1))
        {
            result = 30.0f;
        }
    }
    
    return result;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (!self.confidentialityModeOn) 
    {
        if (!(section == 0 || section == 1))
        {
            UIView *headerView;
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
            
            headerLabel.textColor = [UIColor whiteColor];
            // headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            headerLabel.shadowColor = [UIColor blackColor];
            headerLabel.shadowOffset = CGSizeMake(0, 1);
            headerLabel.backgroundColor = [self.myTableView backgroundColor];
            headerLabel.opaque = YES;
            headerLabel.font = [UIFont boldSystemFontOfSize:18];
            headerLabel.textAlignment = UITextAlignmentLeft;
            headerLabel.adjustsFontSizeToFitWidth = YES;
            
            headerLabel.text = [self.bayData[section - 2] bayName];
            
            [headerView addSubview:headerLabel];
            
            view = headerView;
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
            
            if(!cell)
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
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.gestation = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
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
            [cell addGestureRecognizer:swipeLeft];
            
            UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestationSwipeRight:)];
            swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
            [cell addGestureRecognizer:swipeRight];
            
            cell.textLabel.text = @"Gestation";
            
            Preferences *preferences = [Preferences sharedPreferences];
            
            if ([preferences.userKnowsHowToSwipeGestation isEqualToString:@"YES"])
            {
                cell.detailTextLabel.text = nil;
            }
            else
            {
                cell.detailTextLabel.text = self.gestationSwipeText;
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 2)
        {
            if (self.gestationMode == 1 || self.gestationMode == 2)
            {
                static NSString *CellIdentifier = @"SexCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
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
                
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                self.button = [[CoolButton alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 120.0f, 30.0f)];
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
            if (self.gestationMode == 2)
            {
                static NSString *CellIdentifier = @"PercentileCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
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
                
                if (!cell)
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
        else if(indexPath.row == 4)
        {
            static NSString *CellIdentifier = @"DoneCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
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
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // define switch row
            static NSString *CellIdentifier = @"ConfidentialitySwitch";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.switchObj = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
            
            self.switchObj.on = !self.confidentialityModeOn;
            [self.switchObj addTarget:self action:@selector(patientConfidentialityModeToggle) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
            cell.accessoryView = self.switchObj;
            
            cell.textLabel.text = NSLocalizedString(@"Patient List", nil);
            
            Preferences *preferences = [Preferences sharedPreferences];
            
            if (![preferences.userKnowsHowToSwipePatientList isEqualToString:@"YES"])
            {
                cell.detailTextLabel.text = self.patientListSwipeText;
            }
            else
            {
                cell.detailTextLabel.text = nil;
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Password row";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
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
            
            returnCell = cell;
        }
    }
    else
    {
        NSString *CellIdentifier = [self.bayData[indexPath.section - 2] bayName];
        PatientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[PatientCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        Bay *bay = self.bayData[indexPath.section - 2];
        Patient *patient = bay.patientsInBay[indexPath.row];
        
        cell.textLabel.text = [patient returnDisplayTextLabelText];
        cell.detailTextLabel.text = [patient returnTwoLineDetailDisplayLabelText];
        
        // check if any warnings should be shown in patient list
        // BOOL patientMeetsCriteriaForROPScreening = [patient meetsCriteriaForROPScreening];
        BOOL patientMeetsCriteriaForROPScreening = NO; // disables for next release
        
        BOOL patientMeetsCriteriaForRoutineCrUSS = NO;
        
        if (patientMeetsCriteriaForROPScreening && !patientMeetsCriteriaForRoutineCrUSS)
        {
            // ensure that patient birthdate and gestation have been set
            if (patient.birthDate && patient.gestation) // patient.gestation might already have been checked
            {
                // check if patient is due ROP screening in the next 4 days
                // get ROP due date
                
                NSDate *ROPdate = [ROPViewController ROPScreeningDateFromBirthDate:patient.birthDate andGestation:patient.gestation];
                
                // check if due date is in the next 4 days
                NSDate *dateToCheck = [CBTimeMethods getDateFromDaysDifference:4 fromDate:[NSDate date]];
                
                NSTimeInterval interval = [dateToCheck timeIntervalSinceDate:ROPdate];
                
                NSLog(@"%@: intervalInDays = %f", patient.lastname, (interval / (24 * 60 * 60)));
                
                if ((interval / (24 * 60 * 60) >= 0))
                {
                    cell.imageView.image = [UIImage imageNamed:@"PatientListWarningROP.png"];
                }
                else
                {
                    cell.imageView.image = nil;
                }
            }
        }
        else
        {
            cell.imageView.image = nil;
        }
        
        // Here are the Patient List warnings
        /*
        if (indexPath.section == 2 && indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"PatientListWarningImms.png"];
            
            // SimNICU / Date tapGesture button
            self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
            self.tap.numberOfTapsRequired = 1;
            
            // create an invisible UIView over the SimNICU to allow taps
            CGRect frame = CGRectMake(-20.0f, -20.0f, 60.0f, 60.0f);
            tapView = [[UIView alloc] initWithFrame:frame];
            tapView.backgroundColor = [UIColor clearColor];
            tapView.userInteractionEnabled = YES;
            [tapView addGestureRecognizer:self.tap];
            [cell.contentView addSubview:tapView];
        }
         */
        
        // This must remain
        if ([patient.NewBabyAPGARSSaved isEqualToString:@"YES"])
        {
            cell.detailTextLabel.hidden = NO;
            cell.detailTextLabel.text = @"APGARS saved";
        }
        
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
        if (indexPath.section > 1)
        {
            result = YES;
        }
    }
    
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // turning on Patient List
    if (!self.confidentialityModeOn)
    {
        [super setEditing:editing animated:animated];
        
        if (editing) 
        {
            self.editingModeOn = YES;
            
            // add patient to the last bayData
            int sectionToAddPatient = [self.bayData count] +1;
            
            int newRowIndex = [[self.bayData[([self.bayData count] -1)] patientsInBay] count];
            
            Patient *newPatient = [[Patient alloc] init];
            newPatient.firstname = @"add";
            newPatient.lastname = @"new patient";
            
            [[self.bayData[([self.bayData count] -1)] patientsInBay] addObject:newPatient];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:sectionToAddPatient];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // scroll down 
            // [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        else 
        {
            NSLog(@"not editing");
            
            self.editingModeOn = NO;
            
            int sectionToRemovePatient = [self.bayData count] +1;
            
            int oldRowIndex = [[self.bayData[([self.bayData count] -1)] patientsInBay] count] -1;
            
            [[self.bayData[([self.bayData count] -1)] patientsInBay] removeLastObject];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldRowIndex inSection:sectionToRemovePatient];
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
        if (indexPath.section > 1)
        {
            if (indexPath.section == ([self.bayData count] + 1))
            {
                if (indexPath.row == ([[self.bayData[([self.bayData count] -1)] patientsInBay] count] -1))
                {
                    return UITableViewCellEditingStyleInsert;
                }
                else
                {
                    return UITableViewCellEditingStyleDelete;
                }
            }
            else
            {
                return UITableViewCellEditingStyleDelete;
            }
        }
    }
    else 
    {
        if (indexPath.section > 1)
        {
            if (indexPath.row == [[self.bayData[([self.bayData count] -1)] patientsInBay] count]) 
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
    if(indexPath.section > 1)
    {
        // check if a delete row
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            [[self.bayData[indexPath.section -2] patientsInBay] removeObjectAtIndex:indexPath.row];
            
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [Flurry logEvent:@"EnterWeight: commitEditingStyle: deleteRow"];
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            [Flurry logEvent:@"EnterWeight: commitEditingStyle: addPatient"];
            
            [self addPatient];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    
    if (indexPath.section > 1)
    {
        if (indexPath.section == [self.bayData count] +1) // Unclassified section
        {
            int lastRow = [[self.bayData[([self.bayData count] -1)] patientsInBay] count] -1;
            
            if (!(indexPath.row == lastRow)) result = YES;
        }
        else result = YES;
    }
    
    return result;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *path = proposedDestinationIndexPath;
    
    int miscSection = ([self.bayData count] + 1);
    
    if (proposedDestinationIndexPath.section < 2)                  // above Bay 1
    {
        // ensures that if reorder above patient section, sets final place at top of list in Bay 1
        path = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    else if (proposedDestinationIndexPath.section == miscSection)  // in MiscSection
    {
        // ensures reorder does not place row beyond new patient cell
        Bay *bay = self.bayData[([self.bayData count] - 1)];
        
        int lastRow = [bay.patientsInBay count] - 1;
        
        if (proposedDestinationIndexPath.row >= lastRow)
        {
            if (lastRow == 0)
            {
                // if only 'add new patient'
                path = [NSIndexPath indexPathForRow:(lastRow) inSection:proposedDestinationIndexPath.section]; // ([self.bayData count] +1)
            }
            else
            {
                // more than one patient
                path = [NSIndexPath indexPathForRow:(lastRow - 1) inSection:proposedDestinationIndexPath.section];
            }
        }
    }
    
    return path;
}

// reorder data source after move
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Patient *patient = [[self.bayData[sourceIndexPath.section - 2] patientsInBay] objectAtIndex:sourceIndexPath.row];
    
    [[self.bayData[sourceIndexPath.section -2] patientsInBay] removeObjectAtIndex:sourceIndexPath.row];
    [[self.bayData[destinationIndexPath.section -2] patientsInBay] insertObject:patient atIndex:destinationIndexPath.row];
    
    [Flurry logEvent:@"EnterWeight: moveRowAtIndexPath"];
}

# pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = indexPath;
    
    if (indexPath.section == 1) 
    {
        // disallow 'Patient List' toggle row to be selected
        if (indexPath.row == 0)
        {
            path = nil;
        }
    }
    else if (indexPath.section == 2)
    {
        // lose focus on any selected textField
        [self.weight resignFirstResponder];
        [self.gestation resignFirstResponder];
    }
    
    return path;
}

// select patient details
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            KKPasscodeSettingsViewController *controller = [[KKPasscodeSettingsViewController alloc] init];
            controller.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:controller];
            
            navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            navController.navigationBar.tintColor = [UIColor blackColor];
            
            [self presentModalViewController:navController animated:YES];
            
            /*
            if (self.patientListMode)
            {
                // Bay Editor
                BayEditorViewController *bayEditorViewController = [[BayEditorViewController alloc] init];
                bayEditorViewController.bayData = self.bayData;
                bayEditorViewController.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:bayEditorViewController];
                
                navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                navController.navigationBar.tintColor = [UIColor blackColor];
                
                [self presentModalViewController:navController animated:YES];
            }
             */
            
        }
        else if (indexPath.row == 2)
        {
            // Settings
#if SETTINGS_PREVIEW_MODE
            
            [self showSettings];
            
#else
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
#endif
        }
        else
        {
            KKPasscodeSettingsViewController *controller = [[KKPasscodeSettingsViewController alloc] init];
            controller.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:controller];
            
            navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            navController.navigationBar.tintColor = [UIColor blackColor];
            
            [self presentModalViewController:navController animated:YES];
        }
    }
    else if(indexPath.section > 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Bay *bay;
        bay = self.bayData[indexPath.section - 2];
        Patient *patient = (Patient *)bay.patientsInBay[indexPath.row];
        
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
            if (patient.birthWeight && !patient.workingWeight)                      // selecting a patient where birth weight has been entered and no ww
            {
                // could enter a check to see if user want to use birth weight as working weight.
            
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Message" 
                                          message:@"Working weight set to birth weight" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                patient.workingWeight = patient.birthWeight;                        // set working weight to birth weight
                                                                                    // therefore if birth weight then also ww
                // set the Working Weight date
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
    Bay *bay = self.bayData[indexPath.section - 2];
    Patient *patient = bay.patientsInBay[indexPath.row];
    
    AdvancedPatientEditorViewController *newViewController = [[AdvancedPatientEditorViewController alloc] init];
    newViewController.delegate = self;
    newViewController.bayData = self.bayData;
    newViewController.selectedPatient = patient;
    newViewController.selectedBayNSNumber = [NSNumber numberWithInt:indexPath.section - 2];
    newViewController.selectedPatientInBayNSNumber = [NSNumber numberWithInt:indexPath.row];
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    /*
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
     */
    
    [self presentModalViewController:navController animated:YES];
}

# pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
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
            // first character is a "." or "," or decimal separator
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
        
#ifdef LITE_VERSION
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Estimated weight from gestation is disabled in the Lite Version."
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        allowUserToChangeText = NO;
        
#endif
        
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

- (void)addPatient
{
    [Flurry logEvent:@"EnterWeight: addPatient"];
    
    BOOL allowUserToEnterANewPatient = YES;
    
#ifdef LITE_VERSION
    
    // check how many patients
    // if already two then issue warning and do not allow
    
    int patientCount = 0;
    
    Bay *bay;
    
    for (bay in self.bayData)
    {
        patientCount = patientCount + [bay.patientsInBay count];
    }
    
    if(patientCount > 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only two patients are allowed in the Lite version."
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        allowUserToEnterANewPatient = NO;
    }
    
#endif
    
    if(allowUserToEnterANewPatient)
    {
        PatientDetailsViewController *patientDetailsViewController = [[PatientDetailsViewController alloc] init];
        patientDetailsViewController.delegate = self;
        
        PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:patientDetailsViewController];
        
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        navController.navigationBar.tintColor = [UIColor blackColor];
        
        patientDetailsViewController.userWantsToAddAPatient = @"YES";
        
        [self presentModalViewController:navController animated:YES];
    }
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
    
    if (self.gestation.text.length == 3) self.gestation.text = [self.gestation.text substringToIndex:2];
    
    [self.delegate enterWeightViewController:self didFinishEnteringWeight:self.weight.text orGestation:self.gestation.text forSex:self.selectedSex atCentile:self.selectedCentile];
    
    ZUUIRevealController *revealController = (ZUUIRevealController *)self.parentViewController;
    [revealController revealToggle:self];
}

- (void)patientConfidentialityModeToggle
{
    // lose focus on gestation or weight, if selected
    [self.gestation resignFirstResponder];
    [self.weight resignFirstResponder];
    
    // close patient list
    if (!self.confidentialityModeOn)
    {
        [Flurry logEvent:@"EnterWeight: close patient list"];
        
        if (self.editingModeOn)
        {
            [self setEditing:NO animated:YES];
        }
        // ie close patient list
        self.confidentialityModeOn = !self.confidentialityModeOn;
        
        if (!self.confidentialityModeOn)
        {
            // enable edit button
            self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = YES;
        }
        else {
            self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = NO;
        }
        
        // reload patient sections
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, [self.bayData count])] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else  // ie opening patient list
    {
        [Flurry logEvent:@"EnterWeight: open patient list"];
        
        // first check if passcode set
        if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) 
        {            
            KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
            vc.mode = KKPasscodeModeEnter;
            vc.delegate = self;
            
            dispatch_async(dispatch_get_main_queue(),^
            {
                PortraitOnlyNavigationController *nav = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
                
                nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
                nav.navigationBar.tintColor = [UIColor blackColor];
                
                [self presentModalViewController:nav animated:YES];
            });
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                self.confidentialityModeOn = !self.confidentialityModeOn;
                
                if (!self.confidentialityModeOn)
                {
                    // enable edit button
                    self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = YES;
                }
                else
                {
                    self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = NO;
                }
                
                // reload patient sections
                [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, [self.bayData count])] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                // if patient array is empty then go straight into edit mode
                Bay *bay;
                BOOL patientInDatabase = NO;
                
                for (bay in self.bayData)
                {
                    if ([bay.patientsInBay count] > 1)
                    {
                        patientInDatabase = YES;
                    }
                }
                
                if (patientInDatabase)
                {
                    NSLog(@"There is a patient in the list");
                }
                else // there isn't
                {
                    [self setEditing:YES animated:YES];
                }
            });
        }
        else
        {
            self.confidentialityModeOn = !self.confidentialityModeOn;
            
            if (!self.confidentialityModeOn)
            {
                // enable edit button
                self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = YES;
            }
            else
            {
                self.enterWeightViewControllerNavigationItem.leftBarButtonItem.enabled = NO;
            }
            
            // reload patient sections
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, [self.bayData count])] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            // if patient array is empty then go straight into edit mode
            Bay *bay;
            BOOL patientInDatabase = NO;
            
            for (bay in self.bayData)
            {
                if ([bay.patientsInBay count] >= 1)
                {
                    patientInDatabase = YES;
                }
            }
            
            if (patientInDatabase)
            {
                NSLog(@"There is a patient in the list");
            }
            else // there isn't
            {
                [self setEditing:YES animated:YES];
            }
        }
        
        /*
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
        
        // reload patient sections
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, [self.bayData count])] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // if patient array is empty then go straight into edit mode
        if ([self.patientList count]) // there is a patient in the list
        {
            NSLog(@"There is a patient in the list");
        }
        else // there isn't
        {
            [self setEditing:YES animated:YES];
        }
         */
    }
}

- (void)handleGestationSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (self.gestationMode == 0)
    {
        self.gestationMode = 1;
        self.gestationSwipeText = @"swipe right";
        
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
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (self.gestationMode == 2)
    {
        self.gestationMode = 1;
        
        self.selectedCentile = @"50th";
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if (self.gestationMode == 1)
    {
        self.gestationMode = 0;
        self.gestationSwipeText = nil;
        preferences.userKnowsHowToSwipeGestation = @"YES";
        
        self.selectedSex = @"Unknown";
        
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    CGFloat animationDuration = 1.0f; // 2.0 initially
    CGFloat animationDelay = 0.25f;  // 0.5 initially
    
    CGRect tapViewFrame = tapView.frame;
    tapViewFrame.origin.x = -(tapViewFrame.origin.x);
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tapView.frame = tapViewFrame;

                     }
                     completion:^(BOOL finished){
                         NSLog(@"Animation finished:");
                         [self.myTableView reloadData];
                     }];
    
}

- (void)showSettings
{
    SettingsTableViewController *newViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)showSync
{
    SyncTableViewController *newViewController = [[SyncTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navController.navigationBar.tintColor = [UIColor blackColor];
    
    [self presentModalViewController:navController animated:YES];
}

# pragma mark - PatientDetailsViewController delegate methods

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishAddingPatient:(Patient *)patient
{
    NSLog(@"didFinishAddingPatient");
    
    [self setEditing:NO animated:YES];
    
    // work out where to add new patient, both in database and in table view
    int sectionToAddNewPatient = [self.bayData count] + 1;
    int lastBayInBayData = [self.bayData count] - 1;
    
    Bay *bay = self.bayData[lastBayInBayData];
    int newRowIndex = [bay.patientsInBay count];
    
    // add patient into
    [bay.patientsInBay addObject:patient];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:sectionToAddNewPatient];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    // insert newly added patient into table view
    [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // scroll down to newly added patient
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
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
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)patientDetailsViewControllerDidCancel:(PatientDetailsViewController *)controller
{
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
    
    // Flurry event
    [Flurry endTimedEvent:@"EnterWeightViewController: revealed" withParameters:nil];
}

- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController
{
    // Flurry event
    [Flurry logEvent:@"EnterWeightViewController: revealed" timed:YES];
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
    
    // work out where to add new patient, both in database and in table view
    int lastBayInBayData = [self.bayData count] - 1;
    
    Bay *bay = self.bayData[lastBayInBayData];
    
    // add patient into
    [bay.patientsInBay addObject:patient];
    
    [self.myTableView reloadData];
}

- (void)APGARTabBarController:(APGARTabBarController *)controller updateAPGARValuesForTheNewPatient:(Patient *)patient
{
    // New Baby will be the last one in the list
    
    int lastBayInBayData = [self.bayData count] - 1;
    
    Bay *bay = self.bayData[lastBayInBayData];
    
    int lastPatientInLastBay = bay.patientsInBay.count - 1;
    
    // check that this is the right baby
    Patient *lastPatient = bay.patientsInBay[lastPatientInLastBay];
    if ([lastPatient.firstname isEqualToString:@"New"])
    {
        // update only APGAR data
        lastPatient.APGAR1minColour = patient.APGAR1minColour;
        lastPatient.APGAR1minHeartRate = patient.APGAR1minHeartRate;
        lastPatient.APGAR1minRespiratoryEffort = patient.APGAR1minRespiratoryEffort;
        lastPatient.APGAR1minTone = patient.APGAR1minTone;
        lastPatient.APGAR1minReflexes = patient.APGAR1minReflexes;
        
        lastPatient.APGAR5minColour = patient.APGAR5minColour;
        lastPatient.APGAR5minHeartRate = patient.APGAR5minHeartRate;
        lastPatient.APGAR5minRespiratoryEffort = patient.APGAR5minRespiratoryEffort;
        lastPatient.APGAR5minTone = patient.APGAR5minTone;
        lastPatient.APGAR5minReflexes = patient.APGAR5minReflexes;
        
        lastPatient.APGAR10minColour = patient.APGAR10minColour;
        lastPatient.APGAR10minHeartRate = patient.APGAR10minHeartRate;
        lastPatient.APGAR10minRespiratoryEffort = patient.APGAR10minRespiratoryEffort;
        lastPatient.APGAR10minTone = patient.APGAR10minTone;
        lastPatient.APGAR10minReflexes = patient.APGAR10minReflexes;
        
        lastPatient.APGAR15minColour = patient.APGAR15minColour;
        lastPatient.APGAR15minHeartRate = patient.APGAR15minHeartRate;
        lastPatient.APGAR15minRespiratoryEffort = patient.APGAR15minRespiratoryEffort;
        lastPatient.APGAR15minTone = patient.APGAR15minTone;
        lastPatient.APGAR15minReflexes = patient.APGAR15minReflexes;
        
        lastPatient.APGAR20minColour = patient.APGAR20minColour;
        lastPatient.APGAR20minHeartRate = patient.APGAR20minHeartRate;
        lastPatient.APGAR20minRespiratoryEffort = patient.APGAR20minRespiratoryEffort;
        lastPatient.APGAR20minTone = patient.APGAR20minTone;
        lastPatient.APGAR20minReflexes = patient.APGAR20minReflexes;
    }
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

#pragma mark - BayEditorTableViewController delegate

- (void)bayEditorTableViewControllerDidFinishEditingBays:(BayEditorTableViewController *)controller
{
    // Ensure that there is at least one bay
    if ([self.bayData count] == 0)
    {
        // create bay
        Bay *bay = [[Bay alloc] init];
        bay.bayName = @"Patients";
        bay.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self.bayData addObject:bay];
    }
    
    // [self dismissModalViewControllerAnimated:YES];
    
    // have to reload whole table
    [self.myTableView reloadData];
}

#pragma mark - AdvancedPatientEditorViewControllerDelegate

- (void)AdvancedPatientEditorViewControllerDidFinish:(AdvancedPatientEditorViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    [self.myTableView reloadData];
}

@end
