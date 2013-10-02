//
//  CorrectedAgeCorrectToAgeSettingsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CorrectedAgeCorrectToAgeSettingsViewController.h"

@interface CorrectedAgeCorrectToAgeSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property UITableView *myTableView;
@property UITableViewCell *oneYear;
@property UITableViewCell *twoYears;
@property UITableViewCell *threeYears;
@property UITableViewCell *fourYears;
@property UITableViewCell *fiveYears;

@end

@implementation CorrectedAgeCorrectToAgeSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor blackColor];
    
    [CBTrackers logEvent:@"Age/CorrectedAge/Settings/AgeSelector"];
    
    self.title = NSLocalizedString(@"Correct to age", nil);  // needs add to localization string file
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //menu table
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    }
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"oneYear";
        self.oneYear = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.oneYear)
        {
            self.oneYear = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.oneYear.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.oneYear.backgroundColor = [UIColor whiteColor];
        }
        
        self.oneYear.textLabel.text = @"1 year";
        
        if ([preferences.correctAgeForPrematurityUntilYears intValue] == 1)
        {
            self.oneYear.accessoryType = UITableViewCellAccessoryCheckmark;
            self.oneYear.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.oneYear.accessoryType = UITableViewCellAccessoryNone;
            self.oneYear.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.oneYear;
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"twoYears";
        self.twoYears = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.twoYears)
        {
            self.twoYears = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.twoYears.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.twoYears.backgroundColor = [UIColor whiteColor];
        }
        
        self.twoYears.textLabel.text = @"2 years";
        
        if ([preferences.correctAgeForPrematurityUntilYears intValue] == 2)
        {
            self.twoYears.accessoryType = UITableViewCellAccessoryCheckmark;
            self.twoYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.twoYears.accessoryType = UITableViewCellAccessoryNone;
            self.twoYears.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.twoYears;
    }
    else if (indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"threeYears";
        self.threeYears = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.threeYears)
        {
            self.threeYears = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.threeYears.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.threeYears.backgroundColor = [UIColor whiteColor];
        }
        
        self.threeYears.textLabel.text = @"3 years";
        
        if ([preferences.correctAgeForPrematurityUntilYears intValue] == 3)
        {
            self.threeYears.accessoryType = UITableViewCellAccessoryCheckmark;
            self.threeYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.threeYears.accessoryType = UITableViewCellAccessoryNone;
            self.threeYears.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.threeYears;
    }
    else if (indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"fourYears";
        self.fourYears = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.fourYears)
        {
            self.fourYears = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.fourYears.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.fourYears.backgroundColor = [UIColor whiteColor];
        }
        
        self.fourYears.textLabel.text = @"4 years";
        
        if ([preferences.correctAgeForPrematurityUntilYears intValue] == 4)
        {
            self.fourYears.accessoryType = UITableViewCellAccessoryCheckmark;
            self.fourYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.fourYears.accessoryType = UITableViewCellAccessoryNone;
            self.fourYears.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.fourYears;
    }
    else if (indexPath.row == 4)
    {
        static NSString *CellIdentifier = @"fiveYears";
        self.fiveYears = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.fiveYears)
        {
            self.fiveYears = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.fiveYears.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.fiveYears.backgroundColor = [UIColor whiteColor];
        }
        
        self.fiveYears.textLabel.text = @"5 years";
        
        if ([preferences.correctAgeForPrematurityUntilYears intValue] == 5)
        {
            self.fiveYears.accessoryType = UITableViewCellAccessoryCheckmark;
            self.fiveYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.fiveYears.accessoryType = UITableViewCellAccessoryNone;
            self.fiveYears.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.fiveYears;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (indexPath.row == 0)
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:1];
        
        // set checkmarks
        self.oneYear.accessoryType = UITableViewCellAccessoryCheckmark;
        self.oneYear.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.twoYears.accessoryType = UITableViewCellAccessoryNone;
        self.twoYears.textLabel.textColor = [UIColor blackColor];
        
        self.threeYears.accessoryType = UITableViewCellAccessoryNone;
        self.threeYears.textLabel.textColor = [UIColor blackColor];
        
        self.fourYears.accessoryType = UITableViewCellAccessoryNone;
        self.fourYears.textLabel.textColor = [UIColor blackColor];
        
        self.fiveYears.accessoryType = UITableViewCellAccessoryNone;
        self.fiveYears.textLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 1)
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:2];
        
        // set checkmarks
        self.oneYear.accessoryType = UITableViewCellAccessoryNone;
        self.oneYear.textLabel.textColor = [UIColor blackColor];
        
        self.twoYears.accessoryType = UITableViewCellAccessoryCheckmark;
        self.twoYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.threeYears.accessoryType = UITableViewCellAccessoryNone;
        self.threeYears.textLabel.textColor = [UIColor blackColor];
        
        self.fourYears.accessoryType = UITableViewCellAccessoryNone;
        self.fourYears.textLabel.textColor = [UIColor blackColor];
        
        self.fiveYears.accessoryType = UITableViewCellAccessoryNone;
        self.fiveYears.textLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 2)
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:3];
        
        // set checkmarks
        self.oneYear.accessoryType = UITableViewCellAccessoryNone;
        self.oneYear.textLabel.textColor = [UIColor blackColor];
        
        self.twoYears.accessoryType = UITableViewCellAccessoryNone;
        self.twoYears.textLabel.textColor = [UIColor blackColor];
        
        self.threeYears.accessoryType = UITableViewCellAccessoryCheckmark;
        self.threeYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.fourYears.accessoryType = UITableViewCellAccessoryNone;
        self.fourYears.textLabel.textColor = [UIColor blackColor];
        
        self.fiveYears.accessoryType = UITableViewCellAccessoryNone;
        self.fiveYears.textLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 3)
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:4];
        
        // set checkmarks
        self.oneYear.accessoryType = UITableViewCellAccessoryNone;
        self.oneYear.textLabel.textColor = [UIColor blackColor];
        
        self.twoYears.accessoryType = UITableViewCellAccessoryNone;
        self.twoYears.textLabel.textColor = [UIColor blackColor];
        
        self.threeYears.accessoryType = UITableViewCellAccessoryNone;
        self.threeYears.textLabel.textColor = [UIColor blackColor];
        
        self.fourYears.accessoryType = UITableViewCellAccessoryCheckmark;
        self.fourYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.fiveYears.accessoryType = UITableViewCellAccessoryNone;
        self.fiveYears.textLabel.textColor = [UIColor blackColor];
    }
    else if (indexPath.row == 4)
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:5];
        
        // set check marks
        self.oneYear.accessoryType = UITableViewCellAccessoryNone;
        self.oneYear.textLabel.textColor = [UIColor blackColor];
        
        self.twoYears.accessoryType = UITableViewCellAccessoryNone;
        self.twoYears.textLabel.textColor = [UIColor blackColor];
        
        self.threeYears.accessoryType = UITableViewCellAccessoryNone;
        self.threeYears.textLabel.textColor = [UIColor blackColor];
        
        self.fourYears.accessoryType = UITableViewCellAccessoryNone;
        self.fourYears.textLabel.textColor = [UIColor blackColor];
        
        self.fiveYears.accessoryType = UITableViewCellAccessoryCheckmark;
        self.fiveYears.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    }
    
    [self.delegate correctedAgeCorrectToAgeSettingsViewControllerDidSelectNewAge:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
