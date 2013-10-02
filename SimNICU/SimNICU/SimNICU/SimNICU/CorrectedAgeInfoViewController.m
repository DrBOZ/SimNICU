//
//  CorrectedAgeInfoViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CorrectedAgeCorrectToAgeSettingsViewController.h"
#import "CorrectedAgeInfoViewController.h"

@interface CorrectedAgeInfoViewController () <UITableViewDataSource, UITableViewDelegate, CorrectedAgeCorrectToAgeSettingsViewControllerDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CorrectedAgeInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Settings";
    
    [CBTrackers logEvent:@"Age Calculators/Corrected Age/Info"];
    
    // setup Done button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems doneBarButtonWithTarget:self action:@selector(closeModal)];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
    }
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
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self closeModal];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if (section == 0)
    {
        rows = 1;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 0)
    {
        footer = @"There is currently no global consensus among professionals regarding when to stop correcting a child's age for prematurity.  The majority of professionals correct through to age two years, though it is common to stop at 1 year.";
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 200.0f;
    
    if (section == 1)
    {
        height = 0.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    NSString *CellIdentifier = @"Settings";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = @"Correct to age";
    
    if ([preferences.correctAgeForPrematurityUntilYears intValue] == 1)
    {
        cell.detailTextLabel.text = @"1 year";
    }
    else if ([preferences.correctAgeForPrematurityUntilYears intValue] == 2)
    {
        cell.detailTextLabel.text = @"2 years";
    }
    else if ([preferences.correctAgeForPrematurityUntilYears intValue] == 3)
    {
        cell.detailTextLabel.text = @"3 years";
    }
    else if ([preferences.correctAgeForPrematurityUntilYears intValue] == 4)
    {
        cell.detailTextLabel.text = @"4 years";
    }
    else if ([preferences.correctAgeForPrematurityUntilYears intValue] == 5)
    {
        cell.detailTextLabel.text = @"5 years";
    }
    else
    {
        preferences.correctAgeForPrematurityUntilYears = [NSNumber numberWithInt:2];
        cell.detailTextLabel.text = @"2 years";
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CorrectedAgeCorrectToAgeSettingsViewController *newViewController = [[CorrectedAgeCorrectToAgeSettingsViewController alloc] init];
    newViewController.delegate = self;
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)closeModal
{
    [self.delegate correctedAgeInfoViewController:self didChangeCorrectAgeForPrematurityUntilYears:nil];
    
    // [[self navigationController] dismissModalViewControllerAnimated:YES];
}

#pragma mark - delegate method

- (void)correctedAgeCorrectToAgeSettingsViewControllerDidSelectNewAge:(CorrectedAgeCorrectToAgeSettingsViewController *)controller
{
    [self.myTableView reloadData];
}

@end
