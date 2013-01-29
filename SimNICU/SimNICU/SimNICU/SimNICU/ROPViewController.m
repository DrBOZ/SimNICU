//
//  ROPViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "ROPViewController.h"
#import "AppDelegate.h"

@interface ROPViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL selectedPatientMeetsCriteriaForROPScreening;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView0;

@end

@implementation ROPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        //background
        self.view.backgroundColor = [UIColor blackColor];
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
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
        UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height - 49))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
        tableBgView.image = tableBgImage;
        tableBgView.userInteractionEnabled = NO;
        tableBgView.alpha = 0.5;
        [self.view addSubview:tableBgView];
#endif
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Determining if a patient has been passed into view controller
    
    if (self.selectedPatient) 
    {
        // Setting title of view controller
        if ((self.selectedPatient.lastname && self.selectedPatient.firstname) && (![self.selectedPatient.lastname isEqualToString:@"BABY"] && ![self.selectedPatient.firstname isEqualToString:@"New"]))
        {
            int nameLength;
            
            nameLength = [self.selectedPatient.firstname length] + [self.selectedPatient.lastname length];
            
            if (nameLength > 15) 
            {
                self.title = [NSString stringWithFormat:@"%@", self.selectedPatient.lastname];
            }
            else 
            {
                self.title = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
            }
        }
        else if (self.selectedPatient.gestation)
        {
            self.title = [NSString stringWithFormat:@"%@/40 gestation", self.selectedPatient.gestation];
        }
        else if (self.selectedPatient.birthWeight)
        {
            NSString *rawBirthWeight = self.selectedPatient.birthWeight;
            NSString *formattedBirthWeight;
            
            float birthWeightKGAsFloat = [rawBirthWeight floatValue];
            if(birthWeightKGAsFloat < 1)
            {
                // convert to grams as use integer
                int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
                formattedBirthWeight = [NSString stringWithFormat:@"%i g", birthWeightGRAMSasInt];
            }
            else 
            {
                formattedBirthWeight = [NSString stringWithFormat:@"%@ kg", rawBirthWeight];
            }
            
            self.title = [NSString stringWithFormat:@"Birth Weight %@", formattedBirthWeight];
            
        }
        // Passed in patient does not have a gestation or birth weight, and incomplete name or 'New BABY'
        else
        {
            self.title = @"ROP";
        }
        
        NSString *conditions = @".";
        
        // Checking that either gestation or birth weight have been set
        if (self.selectedPatient.gestation || self.selectedPatient.birthWeight)
        {
            NSString *nameString = @"This infant";
            NSString *criteriaString = @"";
            NSString *screeningDateString = @"";
            
            int gestation = [self.selectedPatient.gestation intValue];
            float birthWeight = [self.selectedPatient.birthWeight floatValue];
            
            // Both gestation and birth weight must have been set, and meet criteria
            if ((gestation > 0 && gestation < 32) && (birthWeight > 0.0f && birthWeight < 1.5f)) 
            {
                
                // Patient meets criteria for screening, now letting user know why, based on which criteria
                if ([self.estimatedWeightUsed isEqualToString:@"YES"]) 
                {
                    criteriaString = @"gestation";
                }
                else 
                {
                    criteriaString = @"gestation and birth weight";
                }
                
                // Setting name to be displayed
                if ((self.selectedPatient.lastname && self.selectedPatient.firstname) && (![self.selectedPatient.lastname isEqualToString:@"BABY"] && ![self.selectedPatient.firstname isEqualToString:@"New"])) 
                {
                    nameString = self.selectedPatient.firstname;
                    
                }
                else 
                {
                    nameString = @"This infant";
                }
                
                // Checking if birthdate has been set (gestation has already been confirmed)
                if (self.selectedPatient.birthDate) 
                {
                    // Obtaining screening date
                    NSDate *screeningDate = [self ROPScreeningDateFromBirthDate:self.selectedPatient.birthDate andGestation:self.selectedPatient.gestation];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setTimeZone:[NSTimeZone localTimeZone]];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    
                    NSString *formattedScreeningDate = [formatter stringFromDate:screeningDate];
                    
                    int daysTillScreeningDate = [self getDaysDifferenceBetween:screeningDate and:[NSDate date]];
                    
                    if (daysTillScreeningDate == 0) 
                    {
                        formattedScreeningDate = @"Today";
                        screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                    }
                    else
                    {
                        // should check here if screening date is in the future or in the past
                        
                        // do this by seeing if the earlier date is equal to the current date,
                        // therefore screening date is in the future
                        
                        NSDate *now = [NSDate date];
                        
                        NSLog(@"Earlier date between %@ and %@ is %@", screeningDate, now, [screeningDate earlierDate:now]);
                        
                        if ([[screeningDate earlierDate:now] isEqualToDate:now]) 
                        {
                            NSLog(@"Screening Date in the Future");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, in %i days time", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                        }
                        else 
                        {
                            NSLog(@"Screening Date in the Past");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, %i days ago", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should have been performed %@.", formattedScreeningDate];
                        }
                    }
                }
                else 
                {
                    screeningDateString = @".";
                }
                
                self.selectedPatientMeetsCriteriaForROPScreening = YES;
            }
            // Only gestation has been passed in, 
            else if (gestation > 0 && gestation < 32)
            {
                criteriaString = @"gestation";
                
                if ((self.selectedPatient.lastname && self.selectedPatient.firstname) && (![self.selectedPatient.lastname isEqualToString:@"BABY"] && ![self.selectedPatient.firstname isEqualToString:@"New"])) 
                {
                    nameString = self.selectedPatient.firstname;
                }
                else 
                {
                    nameString = @"This infant";
                }
                
                if (self.selectedPatient.birthDate) 
                {
                    NSDate *screeningDate = [self ROPScreeningDateFromBirthDate:self.selectedPatient.birthDate andGestation:self.selectedPatient.gestation];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setTimeZone:[NSTimeZone localTimeZone]];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    
                    NSString *formattedScreeningDate = [formatter stringFromDate:screeningDate];
                    
                    int daysTillScreeningDate = [self getDaysDifferenceBetween:screeningDate and:[NSDate date]];
                    
                    if (daysTillScreeningDate == 0) 
                    {
                        formattedScreeningDate = @"Today";
                    }
                    else
                    {
                        // formattedScreeningDate = [NSString stringWithFormat:@"on %@, in %i days time", formattedScreeningDate, daysTillScreeningDate];
                        
                        // should check here if screening date is in the future or in the past
                        
                        // do this by seeing if the earlier date is equal to the current date,
                        // therefore screening date is in the future
                        
                        NSDate *now = [NSDate date];
                        
                        NSLog(@"Earlier date between %@ and %@ is %@", screeningDate, now, [screeningDate earlierDate:now]);
                        
                        if ([[screeningDate earlierDate:now] isEqualToDate:now]) 
                        {
                            NSLog(@"Screening Date in the Future");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, in %i days time", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                        }
                        else 
                        {
                            NSLog(@"Screening Date in the Past");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, %i days ago", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should have been performed %@.", formattedScreeningDate];
                        }
                    }
                    
                    // screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                }
                else 
                {
                    screeningDateString = @".";
                }
                
                self.selectedPatientMeetsCriteriaForROPScreening = YES;
            }
            else if (birthWeight > 0.0f && birthWeight < 1.5f)
            {
                if ([self.estimatedWeightUsed isEqualToString:@"YES"]) 
                {
                    criteriaString = @"estimated birth weight";
                }
                else 
                {
                    criteriaString = @"birth weight";
                }
                
                if ((self.selectedPatient.lastname && self.selectedPatient.firstname) && (![self.selectedPatient.lastname isEqualToString:@"BABY"] && ![self.selectedPatient.firstname isEqualToString:@"New"])) 
                {
                    nameString = self.selectedPatient.firstname;
                }
                else 
                {
                    nameString = @"This infant";
                }
                
                if (self.selectedPatient.birthDate) 
                {
                    NSDate *screeningDate = [self ROPScreeningDateFromBirthDate:self.selectedPatient.birthDate andGestation:self.selectedPatient.gestation];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    
                    [formatter setTimeZone:[NSTimeZone localTimeZone]];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    
                    NSString *formattedScreeningDate = [formatter stringFromDate:screeningDate];
                    
                    int daysTillScreeningDate = [self getDaysDifferenceBetween:screeningDate and:[NSDate date]];
                    
                    if (daysTillScreeningDate == 0) 
                    {
                        formattedScreeningDate = @"Today";
                    }
                    else
                    {
                        // formattedScreeningDate = [NSString stringWithFormat:@"on %@, in %i days time", formattedScreeningDate, daysTillScreeningDate];
                        
                        // should check here if screening date is in the future or in the past
                        
                        // do this by seeing if the earlier date is equal to the current date,
                        // therefore screening date is in the future
                        
                        NSDate *now = [NSDate date];
                        
                        NSLog(@"Earlier date between %@ and %@ is %@", screeningDate, now, [screeningDate earlierDate:now]);
                        
                        if ([[screeningDate earlierDate:now] isEqualToDate:now]) 
                        {
                            NSLog(@"Screening Date in the Future");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, in %i days time", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                        }
                        else 
                        {
                            NSLog(@"Screening Date in the Past");
                            
                            formattedScreeningDate = [NSString stringWithFormat:@"on %@, %i days ago", formattedScreeningDate, daysTillScreeningDate];
                            screeningDateString = [NSString stringWithFormat:@", which should have been performed %@.", formattedScreeningDate];
                        }
                    }
                    
                    // screeningDateString = [NSString stringWithFormat:@", which should be performed %@.", formattedScreeningDate];
                }
                else 
                {
                    screeningDateString = @".";
                }
                
                self.selectedPatientMeetsCriteriaForROPScreening = YES;
            }
            else 
            {
                if ((self.selectedPatient.lastname && self.selectedPatient.firstname) && (![self.selectedPatient.lastname isEqualToString:@"BABY"] && ![self.selectedPatient.firstname isEqualToString:@"New"])) 
                {
                    nameString = self.selectedPatient.firstname;
                }
                else 
                {
                    nameString = @"This infant";
                }
                
                if ((self.selectedPatient.birthWeight && self.selectedPatient.gestation) && !(self.estimatedWeightUsed)) 
                {
                    conditions = @".";
                }
                else if (self.selectedPatient.gestation)
                {
                    conditions = @", unless birth weight is less than 1.5 kg.";
                }
                else if (self.selectedPatient.birthWeight)
                {
                    conditions = @", unless gestation is less than 32 weeks.";
                }
                
                self.selectedPatientMeetsCriteriaForROPScreening = NO;
            }
            
            // Final stage where UIAlertView is prepared
            if (self.selectedPatientMeetsCriteriaForROPScreening) 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"MEETS CRITERIA" 
                                          message:[NSString stringWithFormat:@"%@ meets criteria for ROP screening, based on %@%@", nameString, criteriaString, screeningDateString]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"DOES NOT MEET CRITERIA" 
                                          message:[NSString stringWithFormat:@"%@ does not meet criteria for ROP screening%@", nameString, conditions]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }
    else 
    {
        self.title = @"ROP";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"ROP" withError:nil];
    
#endif
    
}

- (void)viewDidUnload
{
    self.selectedPatientMeetsCriteriaForROPScreening = NO;
    self.estimatedWeightUsed = NO;
    self.selectedPatient = nil;
    self.myTableView = nil;
    self.webView0 = nil;
    self.label = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ROPViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"ROPViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView0 = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return 3;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    if (section == 0 || section == 1) 
    {
        rows = 2;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0f;
    
    switch (indexPath.section) 
    {
        case 0:
            // height = 120;
            height = 44.0f;
            break;
            
        case 1:
            // height = 125;
            height = 44.0f;
            break;
            
        case 2:
            height = 335.0f;
            break;
            
        default:
            break;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    switch (section) 
    {
        case 0:
            header = @"Indications for Screening";
            break;
            
        case 1:
            header = @"Eye Drops";
            break;
            
        case 2:
            header = @"Timing of First ROP Screen";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 33.0f;
    
    if (section == 0) 
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
        {
            height = 66.0f;
        }
        else
        {
            height = 55.0f;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    switch (section) 
    {
        case 0:
            footer = @"either of the above";
            break;
            
        case 1:
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
            {
                footer = @"one drop of each into both eyes 1 hour before examination";
            }
            else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
            {
                footer = @"one drop of each into both eyes 1 hour before examination";
            }
            else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.0)
            {
                footer = @"one drop of each into both eyes 1 hour\n before examination";
            }
            
            break;
            
        // case 2:
            // footer = @"";
            // break;
            
        default:
            break;
    }
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        switch (indexPath.row) 
        {
            case 0:
                // Gestation
                cell.textLabel.text = @"Gestation";
                cell.detailTextLabel.text = @"< 32/40";
                break;
                
            case 1:
                // Birth Weight
                cell.textLabel.text = @"Birth Weight";
                cell.detailTextLabel.text = @"< 1.5 kg";
                break;
                
            default:
                break;
        }
        
        returnCell = cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        switch (indexPath.row) 
        {
            case 0:
                // Cyclopentolate
                cell.textLabel.text = @"Cyclopentolate 0.5%";
                break;
                
            case 1:
                // Phenylephrine
                cell.textLabel.text = @"Phenylephrine 2.5%";
                break;
                
            default:
                break;
        }
        
        returnCell = cell;
    }
    else if(indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        self.webView0 = [[UIWebView alloc] initWithFrame:CGRectMake(10, 5, 300, 330)];
        self.webView0.backgroundColor = [UIColor clearColor];
        self.webView0.opaque = NO;
        self.webView0.scalesPageToFit = NO;
        
        if ([self.webView0 respondsToSelector:@selector(scrollView)]) 
        {
            self.webView0.scrollView.scrollEnabled = NO;
        } 
        else 
        {
            for (id subview in self.webView0.subviews)
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).scrollEnabled = NO;        
        }
        
        self.webView0.dataDetectorTypes = UIDataDetectorTypeNone;
        self.webView0.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);	
        
        NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rop21" ofType:@"html"] isDirectory:NO];
        NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
        [self.webView0 loadRequest:URLReq];
        
        [cell addSubview:self.webView0];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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

#pragma mark - Features to add in the future

- (void)checkAllPatientsInPatientListForROPScreeningThisWeek
{
    // code
}

@end
