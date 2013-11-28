//
//  CorrectedAgeInfoViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CorrectedAgeCorrectToAgeSettingsViewController.h"
#import "CorrectedAgeInfoViewController.h"

@interface CorrectedAgeInfoViewController () <CorrectedAgeCorrectToAgeSettingsViewControllerDelegate>

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self closeModal];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"There is currently no global consensus among professionals regarding when to stop correcting a child's age for prematurity.  The majority of professionals correct through to age two years, though it is common to stop at 1 year.";;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) return 140.0f;
    
    else return 200.0f;
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
}

#pragma mark - delegate method

- (void)correctedAgeCorrectToAgeSettingsViewControllerDidSelectNewAge:(CorrectedAgeCorrectToAgeSettingsViewController *)controller
{
    [self.tableView reloadData];
}

@end
