//
//  PhototherapyPreGraphViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

// #import "PhototherapyGuidelineCountryViewController.h"
#import "PhototherapyGestationViewController.h"
#import "PhototherapyGraphViewController.h"
#import "PhototherapyUnitsViewController.h"
#import "PhototherapyViewController.h"
#import "AppDelegate.h"

@interface PhototherapyViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation PhototherapyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Phototherapy"];
    
    self.title = NSLocalizedString(@"Phototherapy", nil);
    
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
    self.myTableView.rowHeight = 44.0f;
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

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedPatient)
    {
        self.gestation = [NSNumber numberWithInteger:[self.selectedPatient.gestation integerValue]];
        
        if ([self.gestation integerValue] > 38)
        {
            self.gestation = [NSNumber numberWithInteger:38];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyIndexViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.myTableView = nil;
    self.gestationLocked = nil;
    // self.guidelineCountry = nil;
    self.selectedPatient = nil;
    // self.bilirubinUnits = nil;
    self.gestation = nil;
    self.swipeGestureRecognizer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    int rows = 0;
    
    if (section == 0)
    {
        int extraRows = 0;
        
        if (self.selectedPatient)
        {
            extraRows = 1;
        }
        
        if ([preferences.guidelineCountry isEqualToString:@"UK"])
        {
            rows = 2 + extraRows;
        }
        else if ([preferences.guidelineCountry isEqualToString:@"US"])
        {
            rows = 4 + extraRows;
        }
    }
    else if (section == 1)
    {
        rows = 2;
    }
    else
    {
        rows = 0;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    if (section == 0)
    {
        float fourInchDisplayPadding = 0.0f;

        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            fourInchDisplayPadding = 22.0f;
        }
        
        height = 66.0f + fourInchDisplayPadding;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (section == 0)
    {
        header = NSLocalizedString(@"Treatment threshold", nil);
    }
    else if (section == 1)
    {
        header = NSLocalizedString(@"Guidelines", nil);
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    float footer = 0.0f;
    
    if (section == 0)
    {
        if ([preferences.guidelineCountry isEqualToString:@"US"])
        {
            footer = 66.0f;
        }
        else if ([preferences.guidelineCountry isEqualToString:@"UK"])
        {
            footer = 66.0f;
        }
    }
    
    return footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    NSString *footer = nil;
    
    if (section == 0)
    {
        if ([preferences.guidelineCountry isEqualToString:@"US"])
        {
            footer = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Red Line - Exchange Transfusion", nil), NSLocalizedString(@"Blue Line - Phototherapy", nil)];
        }
        else if ([preferences.guidelineCountry isEqualToString:@"UK"])
        {
            footer = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Red Line - Exchange Transfusion", nil), NSLocalizedString(@"Blue Line - Phototherapy", nil)];
        }
    }
    
    return footer;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    int extraRowsInSectionOne = 0;
    
    if (self.selectedPatient)
    {
        extraRowsInSectionOne = 1;
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 && extraRowsInSectionOne)
        {
            static NSString *CellIdentifier = @"PatientName";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Patient";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            
            returnCell = cell;
        }
        else if(indexPath.row == (0 + extraRowsInSectionOne))
        {
            static NSString *CellIdentifier = @"Gestation";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                
                if ([self.gestationLocked isEqualToString:@"YES"])
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Gestation";
            
            if (self.gestation)
            {
                if ([preferences.guidelineCountry isEqualToString:@"UK"])
                {
                    if ([self.gestation integerValue] >= 38)
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@+/40 at birth", self.gestation];
                    }
                    else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/40 at birth", self.gestation];
                    }
                }
                else if ([preferences.guidelineCountry isEqualToString:@"US"])
                {
                    if ([self.gestation integerValue] < 35)
                    {
                        cell.detailTextLabel.text = @"Below guideline value";
                    }
                    else if (([self.gestation integerValue] >= 35) && ([self.gestation integerValue] < 38))
                    {
                        cell.detailTextLabel.text = @"35 - 37+6/40";
                    }
                    else
                    {
                        cell.detailTextLabel.text = @"38+ weeks";
                    }
                }
            }
            else
            {
                cell.detailTextLabel.text = @"select";
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1 + extraRowsInSectionOne)
        {
            // if guidelineCountry = UK then
            
            if ([preferences.guidelineCountry isEqualToString:@"UK"])
            {
                static NSString *CellIdentifier = @"treatmentThresholdChart";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.text = @"Treatment Chart";
                }
                
                if (!self.gestation)
                {
                    cell.textLabel.textColor = [UIColor grayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
                
                returnCell = cell;
            }
            else if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                static NSString *CellIdentifier = @"clinicalStatus";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.text = @"Clinical Status";
                }
                
                if (self.clinicalStatus)
                {
                    cell.detailTextLabel.text = self.clinicalStatus;
                }
                else
                {
                    cell.detailTextLabel.text = @"select";
                }
                
                returnCell = cell;
            }
        }
        else if (indexPath.row == 2 + extraRowsInSectionOne)
        {
            static NSString *CellIdentifier = @"neurotoxicity";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.text = @"Risk Factors";
            }
            
            if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                if (self.neurotoxicityRiskFactors)
                {
                    cell.detailTextLabel.text = self.neurotoxicityRiskFactors;
                }
                else
                {
                    cell.detailTextLabel.text = @"select";
                }
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 3 + extraRowsInSectionOne)
        {
            static NSString *CellIdentifier = @"treatmentThresholdChart";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.text = @"Treatment Chart";
            }
            
            if (!self.neurotoxicityRiskFactors || !self.clinicalStatus || !self.gestation)
            {
                cell.textLabel.textColor = [UIColor grayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else
            {
                cell.textLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"GuidelineCountry";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.text = @"Country";
            }
            
            if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                cell.detailTextLabel.text = @"United States";
            }
            else if ([preferences.guidelineCountry isEqualToString:@"UK"])
            {
                cell.detailTextLabel.text = @"United Kingdom";
            }
            else
            {
                cell.detailTextLabel.text = @" ";
            }
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"BilirubinUnits";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.text = @"Serum bilirubin";
            }
            
            if ([preferences.bilirubinUnits isEqualToString:@"SI"])
            {
                cell.detailTextLabel.text = @"µmol/L";
            }
            else if ([preferences.bilirubinUnits isEqualToString:@"US"])
            {
                cell.detailTextLabel.text = @"mg/dL";
            }
            else
            {
                NSLog(@"In default bilirubinUnits");
                
                cell.detailTextLabel.text = @" ";
            }
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == 0)
    {        
        if (self.selectedPatient)
        {
            if (indexPath.row == 0)
            {
                // null code
            }
            else if (indexPath.row == 1)
            {
                if (![self.gestationLocked isEqualToString:@"YES"])
                {
                    path = indexPath;
                }
            }
            else
            {
                path = indexPath;
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                if (![self.gestationLocked isEqualToString:@"YES"])
                {
                    path = indexPath;
                }
            }
            else
            {
                path = indexPath;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        path = indexPath;
    }
    
    return path;
}

//on row select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Preferences *preferences = [Preferences sharedPreferences];
    
    int extraRowsInSectionOne = 0;
    
    if (self.selectedPatient)
    {
        extraRowsInSectionOne = 1;
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == (0 + extraRowsInSectionOne))
        {
            PhototherapyGestationViewController *newViewController = [[PhototherapyGestationViewController alloc] init];
            newViewController.gestation = self.gestation;
            newViewController.delegate = self;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == (1 + extraRowsInSectionOne))
        {
            if ([preferences.guidelineCountry isEqualToString:@"UK"])
            {
                if (self.gestation)
                {
                    PhototherapyGraphViewController *newViewController = [[PhototherapyGraphViewController alloc] init];
                    newViewController.gestation = self.gestation;
                    
                    if (self.selectedPatient)
                    {
                        newViewController.selectedPatient = self.selectedPatient;
                    }
                    
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
                    
                    // iOS 7 specifics
                    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                    {
                        navController.navigationBar.barTintColor = [UIColor grayColor];
                        navController.navigationBar.tintColor = [UIColor redColor];
                    }
                    else
                    {
                        navController.navigationBar.tintColor = [UIColor blackColor];
                        navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                    }
                    
                    [appDelegate.navigationController presentModalViewController:navController animated:YES];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@""
                                              message:@"Gestation must be selected"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
            else if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                PhototherapyClinicalStatusViewController *newViewController = [[PhototherapyClinicalStatusViewController alloc] init];
                newViewController.clinicalStatus = self.clinicalStatus;
                newViewController.delegate = self;
                
                [appDelegate.navigationController pushViewController:newViewController animated:YES];
            }
        }
        else if (indexPath.row == (2 + extraRowsInSectionOne))
        {
            PhototherapyNeurotoxicityRiskViewController *newViewController = [[PhototherapyNeurotoxicityRiskViewController alloc] init];
            newViewController.neurotoxicityRiskFactors = self.neurotoxicityRiskFactors;
            newViewController.delegate = self;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == (3 + extraRowsInSectionOne))
        {
            BOOL showGraph = YES;
            
            // check all parameters have been entered
            if (!(self.gestation && self.clinicalStatus && self.neurotoxicityRiskFactors))
            {
                showGraph = NO;
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@""
                                          message:@"Please enter all parameters"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
                
            }
            else
            {
                PhototherapyGraphViewController *newViewController = [[PhototherapyGraphViewController alloc] init];
                // newViewController.guidelineCountry = preferences.guidelineCountry;
                // newViewController.bilirubinUnits = preferences.bilirubinUnits;
                newViewController.gestation = self.gestation;
                
                if (self.selectedPatient)
                {
                    newViewController.selectedPatient = self.selectedPatient;
                }
                
                // calculate and pass over neurotoxicity risk
                if ([self.gestation integerValue] >= 38)
                {
                    if ([self.clinicalStatus isEqualToString:@"Well"] && [self.neurotoxicityRiskFactors isEqualToString:@"None"])
                    {
                        newViewController.neurotoxicityRisk = @"Lower";
                    }
                    else
                    {
                        newViewController.neurotoxicityRisk = @"Medium";
                    }
                }
                else if ([self.gestation integerValue] >= 35)
                {
                    if ([self.clinicalStatus isEqualToString:@"Well"] && [self.neurotoxicityRiskFactors isEqualToString:@"None"])
                    {
                        newViewController.neurotoxicityRisk = @"Medium";
                    }
                    else
                    {
                        newViewController.neurotoxicityRisk = @"Higher";
                    }
                }
                else
                {
                    showGraph = NO;
                    
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Below guideline value"
                                              message:@"2004 AAP Guideline does not cover gestations less than 35 weeks."
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    
                    [alertView show];
                }
                
                if (showGraph)
                {
                    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
                    
                    navController.navigationBar.tintColor = [UIColor blackColor];
                    navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                    
                    [appDelegate.navigationController presentModalViewController:navController animated:YES];
                }
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // Guideline country selection
            PhototherapyGuidelineCountryViewController *newViewController = [[PhototherapyGuidelineCountryViewController alloc] init];
            // newViewController.guidelineCountry = self.guidelineCountry;
            newViewController.delegate = self;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        else
        {
            // Units selection
            PhototherapyUnitsViewController *newViewController = [[PhototherapyUnitsViewController alloc] init];
            // newViewController.guidelineCountry = self.guidelineCountry;
            // newViewController.bilirubinUnits = self.bilirubinUnits;
            newViewController.delegate = self;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
    }
}

#pragma mark - PhototherapyGestationViewController delegate

- (void)phototherapyGestationViewController:(PhototherapyGestationViewController *)controller didFinishSelectingGestation:(NSNumber *)gestation
{
    self.gestation = gestation;
    
    // detailDisclosure for TreatmentChart
    
    [self.myTableView reloadData];
}

#pragma mark - PhototherapyNeurotoxicityRiskViewController delegate

- (void)phototherapyNeurotoxicityRiskViewController:(PhototherapyNeurotoxicityRiskViewController *)controller didFinishSelectingNeurotoxicityRisk:(NSString *)neurotoxicityRisk
{
    self.neurotoxicityRiskFactors = neurotoxicityRisk;
    
    [self.myTableView reloadData];
}

#pragma mark - PhototherapyClinicalStatusViewController delegate

- (void)phototherapyClinicalStatusViewController:(PhototherapyClinicalStatusViewController *)controller didFinishSelectingClinicalStatus:(NSString *)clinicalStatus
{
    self.clinicalStatus = clinicalStatus;
    
    [self.myTableView reloadData];
}

#pragma mark - PhototherapyGuidelineCountryViewController delegate

- (void)phototherapyGuidelineCountryViewController:(PhototherapyGuidelineCountryViewController *)controller didFinishSelectingGuidelineCountry:(NSString *)guidelineCountry
{
    // access singleton
    Preferences *preferences = [Preferences sharedPreferences];
    
    // self.guidelineCountry = guidelineCountry;
    
    // [self.delegate phototherapyViewController:self didChangeGuidelineCountry:guidelineCountry];
    
    // change bilirubin units depending on which country guideline selected
    if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        if ([preferences.bilirubinUnits isEqualToString:@"US"])
        {
            preferences.bilirubinUnits = @"SI";
            // [self.delegate phototherapyViewController:self didChangeBilirubinUnit:@"SI"];
        }
    }
    else if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            preferences.bilirubinUnits = @"US";
            // [self.delegate phototherapyViewController:self didChangeBilirubinUnit:@"US"];
        }
    }
    
    // reload table to show new values
    [self.myTableView reloadData];
}

#pragma mark - PhototherapyUnitsViewController delegate

- (void)phototherapyUnitsViewController:(PhototherapyUnitsViewController *)controller didFinishSelectingUnits:(NSString *)units
{
    // self.bilirubinUnits = units;
    
    // [self.delegate phototherapyViewController:self didChangeBilirubinUnit:units];
    
    // simply reload table to update any changes to the units
    [self.myTableView reloadData];
}

@end
