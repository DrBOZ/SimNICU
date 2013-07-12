//
//  DrugDosePatientViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugDosePatientViewController.h"
#import "DrugDosePatientTableViewCell.h"
#import "DrugInfoSimpleViewController.h"
#import "AppDelegate.h"

@interface DrugDosePatientViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSString *workingWeight;

@end

@implementation DrugDosePatientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.selectedDrug;
    
    // self.selectedPatient must be true to even get here
    
    // to calculate drug dose we must have age of patient and weight
    
    // Display patient name and details working out age
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
#if USE_DIMPLE_BACKGROUND
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    else
    {
        // 3.5 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    
#else
    self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
    
#if APP_SHADING
    //screen mask covers everything
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    [self.view addSubview:tableBgView];
#endif
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    if (section == 0)
    {
        rows = 1;
    }
    else if (section == 1)
    {
        rows = 2;
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    if (section == 0)
    {
        returnString = @"Patient";
    }
    else
    {
        returnString = @"Dose";
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"Patient";
        DrugDosePatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
        
        returnCell = cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            NSString *CellIdentifier = @"Dose";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            returnCell = cell;
        }
        else
        {
            NSString *CellIdentifier = @"Drug Info";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = @"Drug Information";
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

- (DrugDosePatientTableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    DrugDosePatientTableViewCell *cell;
    
    cell = [[DrugDosePatientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //displayTextLabel (Patient's name or working weight)
    UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 210.0f, 30.0f)];
    displayTextLabel.textColor = [UIColor blackColor];
    displayTextLabel.backgroundColor = [UIColor clearColor];
    displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    displayTextLabel.adjustsFontSizeToFitWidth = YES;
    displayTextLabel.textAlignment = UITextAlignmentLeft;
    [cell addSubview:displayTextLabel];
    
    //displayDetailTextLabel (Patient's name or working weight)
    UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 21.0f, 227.0f, 30.0f)];
    displayDetailTextLabel.textColor = [UIColor blackColor];
    displayDetailTextLabel.backgroundColor = [UIColor clearColor];
    displayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
    displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
    displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
    [cell addSubview:displayDetailTextLabel];
    
    // display patient's name
    displayTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
    
    NSString *detailTextLabelText = @"";
    
    NSString *rawBirthWeight = self.selectedPatient.birthWeight;
    NSString *formattedBirthWeight;
    
    NSString *rawWorkingWeight = self.selectedPatient.workingWeight;
    NSString *formattedWorkingWeight;
    
    // format birth weight
    NSString *UKLocaleRawBirthWeight;
    UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
    
    if(birthWeightKGAsFloat < 1.0f)
    {
        // convert to grams as use integer
        int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
        formattedBirthWeight = [NSString stringWithFormat:@"%i g", birthWeightGRAMSasInt];
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
    
    if(workingWeightKGAsFloat < 1.0f)
    {
        // convert to grams as use integer
        int workingWeightGRAMSasInt = workingWeightKGAsFloat * 1000;
        formattedWorkingWeight = [NSString stringWithFormat:@"%i g", workingWeightGRAMSasInt];
    }
    else
    {
        formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", rawWorkingWeight];
    }
    
    // all information present (missing this stage
    if (self.selectedPatient.gestation && self.selectedPatient.birthWeight && self.selectedPatient.correctedGestation && self.selectedPatient.workingWeight)
    {
        detailTextLabelText = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", self.selectedPatient.gestation, formattedBirthWeight, self.selectedPatient.correctedGestation, formattedWorkingWeight];
        
        self.workingWeight = self.selectedPatient.workingWeight;
    }
    else if (self.selectedPatient.workingWeight && self.selectedPatient.gestation)
    {
        detailTextLabelText = [NSString stringWithFormat:@"%@/40 working weight %@", self.selectedPatient.gestation, formattedWorkingWeight];
        
        self.workingWeight = self.selectedPatient.workingWeight;
    }
    else if (self.selectedPatient.workingWeight && !self.selectedPatient.gestation)
    {
        detailTextLabelText = [NSString stringWithFormat:@"working weight %@", formattedWorkingWeight];
        
        self.workingWeight = self.selectedPatient.workingWeight;
    }
    else if (self.selectedPatient.gestation && !self.selectedPatient.workingWeight)
    {
        // no working weight
        NSLog(@"NO WORKING WEIGHT - ERROR!!!!!!!!!!!!!!!");
    }
    
    displayDetailTextLabel.text = detailTextLabelText;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        DrugInfoSimpleViewController *newViewController = [[DrugInfoSimpleViewController alloc] init];
        newViewController.selectedDrug = self.selectedDrug;
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}

#pragma mark - Methods

- (NSString *)calculateCurrentGestation:(Patient *)patient
{
    NSString *currentGestation = @"0+0";
    // NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *now = [[NSDate alloc] init];
    // NSLog(@"%@",now);
    
    int daysDifference = [self getDaysDifferenceBetween:patient.birthDate and:now];
    
    NSLog(@" ");
    NSLog(@"Patient: %@ %@", patient.firstname, patient.lastname);
    NSLog(@"Days difference = %i", daysDifference);
    
    
    int weeksDifference = daysDifference / 7;
    
    NSLog(@"Weeks difference = %i", weeksDifference);
    
    int plusDays = (daysDifference - (weeksDifference * 7));
    
    NSLog(@"Age = %i weeks + %i days", weeksDifference, plusDays);
    
    
    // int gestationWeeks = [patient.gestationWeeks intValue];
    // int gestationDays = [patient.gestationDays intValue];
    
    int gestationWeeks = [[patient.gestation substringToIndex:2] intValue];
    NSLog(@"gestationWeeks = %i", gestationWeeks);
    
    int gestationDays;
    if ([patient.gestation length] > 3)
    {
        gestationDays = [[patient.gestation substringFromIndex:2] intValue];
    }
    else
    {
        gestationDays = 0;
    }
    NSLog(@"gestationDays = %i", gestationDays);
    
    int correctedGestationWeeks = gestationWeeks + weeksDifference;
    
    int correctedGestationDays = gestationDays + plusDays;
    
    if (correctedGestationDays > 6)
    {
        correctedGestationWeeks = correctedGestationWeeks + 1;
        correctedGestationDays = correctedGestationDays - 7;
    }
    
    currentGestation = [NSString stringWithFormat:@"%d+%d",correctedGestationWeeks, correctedGestationDays];
    
    NSLog(@"Corrected gestation = %i+%i", correctedGestationWeeks, correctedGestationDays);
    
    // NSNumber *correctedGestationWeeks = ([patient gestationWeeks] + [NSNumber numberWithInt:intWeeks]);
    
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
    
    NSDate *roundedDate = [gregorian dateFromComponents:dateComponents];
    
    NSDate *otherDate = (dateToRound == dateA) ? dateB : dateA ;
    
    NSInteger diff = abs([roundedDate timeIntervalSinceDate:otherDate]);
    
    NSInteger daysDifference = floor(diff/(24 * 60 * 60));
    
    return daysDifference;
}

- (NSDate *)getDateFromDaysDifference:(NSInteger)days fromDate:(NSDate *)date;
{
    if (days == 0)
    {
        return date;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    NSDateComponents *dateComponents =
    [gregorian components:flags fromDate:date];
    
    NSDate *roundedDate = [gregorian dateFromComponents:dateComponents];
    
    NSTimeInterval timeInterval = days * (24 * 60 * 60);
    
    NSDate *futureDate = [roundedDate dateByAddingTimeInterval:timeInterval];
    
    return futureDate;
}

- (NSDate *)ROPScreeningDateFromBirthDate:(NSDate *)birthDate andGestation:(NSString *)gestation
{
    NSDate *screeningDate;
    
    int gestationWeeks;
    int gestationDays;
    int days;
    int weeks;
    
    // determine corrected gestation at which to screen from gestation passed in
    NSString *correctedGestationToScreenWeeks = [self ROPScreeningGestationFromGestation:gestation];
    
    gestationWeeks = [[gestation substringToIndex:2] intValue];
    
    NSLog(@" ");
    NSLog(@"gestation = %@", gestation);
    NSLog(@"[gestation length] = %i", [gestation length]);
    
    // check if gestation has days as well as weeks
    if ([gestation length] > 3)
    {
        gestationDays = [[gestation substringFromIndex:2] intValue];
    }
    else
    {
        gestationDays = 0;
    }
    
    weeks = [correctedGestationToScreenWeeks intValue] - gestationWeeks;
    
    // calculate number of days between corrected gestation at which to screen and birth gestation
    // this number of days added onto birth date will give screening date
    if (gestationDays == 0)
    {
        days = weeks * 7;
    }
    else
    {
        days = ((weeks - 1) * 7) + (7 - gestationDays);
    }
    
    NSLog(@"Days = %i", days);
    
    // add days to birthdate to get screening date
    
    screeningDate = [self getDateFromDaysDifference:days fromDate:birthDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *formattedScreeningDate = [formatter stringFromDate:screeningDate];
    
    NSLog(@"formattedScreeningDate = %@", formattedScreeningDate);
    
    // number of days between screening date and current date is number of days to ROP screening
    int daysTillScreeningDate = [self getDaysDifferenceBetween:screeningDate and:[NSDate date]];
    
    NSLog(@"daysTillScreeningDate = %i", daysTillScreeningDate);
    
    
    return screeningDate;
}

- (NSString *)ROPScreeningGestationFromGestation:(NSString *)gestation;
{
    NSString *screeningGestation;
    
    NSString *gestationalAgeinWeeks;
    
    if ([gestation length] > 2)
    {
        gestationalAgeinWeeks = [gestation substringToIndex:2];
    }
    else
    {
        gestationalAgeinWeeks = gestation;
    }
    
    if ([gestationalAgeinWeeks isEqualToString:@"22"] || [gestationalAgeinWeeks isEqualToString:@"23"] || [gestationalAgeinWeeks isEqualToString:@"24"] || [gestationalAgeinWeeks isEqualToString:@"25"] || [gestationalAgeinWeeks isEqualToString:@"26"])
    {
        screeningGestation = @"30";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"27"])
    {
        screeningGestation = @"31";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"28"])
    {
        screeningGestation = @"32";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"29"])
    {
        screeningGestation = @"33";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"30"])
    {
        screeningGestation = @"34";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"31"])
    {
        screeningGestation = @"35";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"32"])
    {
        screeningGestation = @"36";
    }
    else if ([gestationalAgeinWeeks isEqualToString:@"33"])
    {
        screeningGestation = @"37";
    }
    else
    {
        screeningGestation = @"38";
    }
    
    return screeningGestation;
}

@end
