//
//  PhototherapyAddBilirubinResultViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 14/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyAddBilirubinResultViewController.h"
#import "PhototherapyHoursOldViewController.h"
#import "AppDelegate.h"

@interface PhototherapyAddBilirubinResultViewController()

@property (nonatomic, strong) NSString *formattedSampleAgeInDays;
@property (nonatomic, strong) UITextField *bilirubinTextField;
@property (nonatomic, strong) NSNumber *sampleAgeInDays;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSNumber *bilirubinLevel;

@end

@implementation PhototherapyAddBilirubinResultViewController
{
    NSArray *sortedPreviousBilirubinResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Add Result";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    if (!self.bilirubinLevel || !self.sampleAgeInDays)
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    sortedPreviousBilirubinResults = [self.selectedPatient.bilirubinResults sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
    {
        NSNumber *first = [(BilirubinResult *)a sampleAgeInDays];
        NSNumber *second = [(BilirubinResult *)b sampleAgeInDays];
        return [first compare:second];
    }];
    
    self.selectedPatient.bilirubinResults = [NSMutableArray arrayWithArray:sortedPreviousBilirubinResults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyAddBilirubinResultViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyAddBilirubinResultViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 1;
    
    if (self.selectedPatient)
    {
        if ([self.selectedPatient.bilirubinResults count] > 0)
        {
            sections = 2;
        }
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 2;
    
    if (section == 1)
    {
        rows = [self.selectedPatient.bilirubinResults count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    if (section == 0)
    {
        height = 22.0f;
    }
    else
    {
        height = 44.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (section == 0)
    {
        // header = NSLocalizedString(@"New bilirubin result", nil);
    }
    else if (section == 1)
    {
        header = NSLocalizedString(@"Previous bilirubin results", nil);
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Age";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
#ifdef LITE_VERSION
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
#else
                
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                
#endif
                
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Sample Age";
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            if (self.sampleAgeInDays)
            {
                // cell.detailTextLabel.text = self.formattedSampleAgeInDays;   this might be better
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ days", [formatter stringFromNumber:self.sampleAgeInDays]];
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Bilirubin";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.bilirubinTextField = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 107.0f, 30.0f)];
            self.bilirubinTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.bilirubinTextField.borderStyle = UITextBorderStyleRoundedRect;
            
            if ([self.bilirubinUnits isEqualToString:@"SI"])
            {
                self.bilirubinTextField.placeholder = @"µmol/L";
            }
            else if ([self.bilirubinUnits isEqualToString:@"US"])
            {
                self.bilirubinTextField.placeholder = @"mg/dl";
            }
            
            self.bilirubinTextField.clearButtonMode = UITextFieldViewModeAlways;
            self.bilirubinTextField.adjustsFontSizeToFitWidth = YES;
            self.bilirubinTextField.returnKeyType = UIReturnKeyNext;
            self.bilirubinTextField.textAlignment = UITextAlignmentLeft;
            self.bilirubinTextField.delegate = self;
            
            //use the new decimal pad if using iOS 4.1 or greater
            if((UIKeyboardTypeDecimalPad) && ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1))
            {
                [self.bilirubinTextField setKeyboardType:UIKeyboardTypeDecimalPad];
                [self.bilirubinTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            
            cell.accessoryView = self.bilirubinTextField;
            
            cell.textLabel.text = @"Serum Bilirubin";
            
            if (self.bilirubinLevel)
            {
                self.bilirubinTextField.text = [NSString stringWithFormat:@"%@", self.bilirubinLevel];
            }
            else
            {
                if (self.sampleAgeInDays)
                {
                    [self.bilirubinTextField becomeFirstResponder];  // not sure why this is not working.
                }
            }
            
            returnCell = cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"PreviousBilirubinResults";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.userInteractionEnabled = YES;
        
        BilirubinResult *biliResult = [self.selectedPatient.bilirubinResults objectAtIndex:indexPath.row];
        // BilirubinResult *biliResult = [sortedPreviousBilirubinResults objectAtIndex:indexPath.row];
        
        int sampleAgeInMinutes = abs(([biliResult.sampleAgeInDays doubleValue] * 24 * 60));
        int sampleAgeInHours = abs(([biliResult.sampleAgeInDays doubleValue] * 24));
        
        if (sampleAgeInMinutes < 60)
        {
            if (sampleAgeInMinutes == 0)
            {
                cell.textLabel.text = @"Cord";
            }
            else if (sampleAgeInMinutes == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%i minute", sampleAgeInMinutes];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%i minutes", sampleAgeInMinutes];
            }
        }
        else
        {
            if (sampleAgeInHours == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%i hour", sampleAgeInHours];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%i hours", sampleAgeInHours];
            }
        }
        
        NSString *unitString;
        
        if ([biliResult.bilirubinUnit isEqualToString:@"SI"])
        {
            unitString = @"µmol/L";
        }
        else if ([biliResult.bilirubinUnit isEqualToString:@"US"])
        {
            unitString = @"mg/dL";
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", biliResult.bilirubinResult, unitString];
        
        returnCell = cell;
    }
    
    return returnCell;
}

# pragma mark

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    
    if(indexPath.section == 1)
    {
        result = YES;
    }
    
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    NSLog(@"EDITING!!!!");
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CommitEditingStyle");
    
    if(indexPath.section == 1)
    {
        // remove object at index
        
        [self.selectedPatient.bilirubinResults removeObjectAtIndex:indexPath.row];
        
        if (indexPath.row == 0)
        {
            [self.myTableView reloadData];
        }
        else
        {
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

# pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
#ifdef LITE_VERSION
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"SimNICU Lite Version"
                              message:@"Bilirubin result plotting is not enabled in the Lite version."
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
#else
    
    PhototherapyHoursOldViewController *newViewController = [[PhototherapyHoursOldViewController alloc] init];
    newViewController.dateAndTimeOfBirth = self.dateAndTimeOfBirthForThisChart;
    newViewController.selectedPatient = self.selectedPatient;
    newViewController.delegate = self;
    
    [self.navigationController pushViewController:newViewController animated:YES];
    
#endif
}

#pragma mark - UITextView delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NSLog(@" ");
    // NSLog(@"newText = %@", newText);
    // NSLog(@"newText.length = %i", newText.length);
    // NSLog(@"string = %@", string);
    
    // conditional code here...
    if ([self.bilirubinUnits isEqualToString:@"SI"])
    {
        if ([string isEqualToString:@"."])
        {
            allowUserToChangeText = NO;
        }
        
        if (newText.length > 3)
        {
            allowUserToChangeText = NO;
        }
        else if (newText.length == 1)
        {
            if ([string isEqualToString:@"0"])
            {
                allowUserToChangeText = NO;
            }
        }
    }
    else if ([self.bilirubinUnits isEqualToString:@"US"])
    {
        // US conditions
    }
    
    if (allowUserToChangeText)
    {
        if ([newText length] > 0)
        {
            self.bilirubinLevel = [NSNumber numberWithDouble:[newText doubleValue]];
            
            if (self.sampleAgeInDays)
            {
                self.navigationItem.leftBarButtonItem.enabled = YES;
            }
        }
        else
        {
            self.bilirubinLevel = nil;
            
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
    }
    
#ifdef LITE_VERSION
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"SimNICU Lite Version"
                              message:@"Bilirubin result plotting is not enabled in the Lite version."
                              delegate:nil cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
    allowUserToChangeText = NO;
    
#endif
    
    return allowUserToChangeText;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.bilirubinLevel = nil;
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    return YES;
}

# pragma mark - PhototherapyHoursOldViewController delegate

- (void)phototherapyHoursOldViewController:(PhototherapyHoursOldViewController *)controller didFinishAddingAgeInDays:(NSNumber *)age formattedAge:(NSString *)formattedAge forBirthDate:(NSDate *)date
{
    self.sampleAgeInDays = age;
    
    if (self.sampleAgeInDays && self.bilirubinLevel)
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
    if (self.selectedPatient)
    {
        self.dateAndTimeOfBirthForThisChart = date;
        
        // more code needed here?
    }
    else
    {
        self.dateAndTimeOfBirthForThisChart = date;
    }
    
    [self.myTableView reloadData];
}

# pragma mark

- (void)done
{
    if (self.sampleAgeInDays && self.bilirubinLevel && self.bilirubinUnits)
    {
        BilirubinResult *biliresult = [[BilirubinResult alloc] init];
        biliresult.sampleAgeInDays = self.sampleAgeInDays;
        biliresult.bilirubinResult = self.bilirubinLevel;
        biliresult.bilirubinUnit = self.bilirubinUnits;
        
        [self.delegate phototherapyAddBilirubinResultViewController:self didFinishAddingNewBilirubinResult:biliresult forBirthDate:self.dateAndTimeOfBirthForThisChart];
    }
    else
    {
        [self.delegate phototherapyAddBilirubinResultViewControllerDidFinishDeletingBilirubinResults:self];
    }
}

- (void)cancel
{
    [self.delegate phototherapyAddBilirubinResultViewControllerDidCancel:self];
}


@end

