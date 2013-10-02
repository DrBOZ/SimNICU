//
//  UVCUACViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "UVCUACViewController.h"
#import "AppDelegate.h"

@interface UVCUACViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) UITableView *myTableView;

@end

@implementation UVCUACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"UAC / UVC";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
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
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
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
            
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:@"Patient selected",
             @"Log",
             nil];
            
            [CBTrackers logEvent:@"UAC / UVC" withParameters:dictionary timed:NO];
        }
        else if (self.selectedPatient.gestation)
        {
            self.title = [NSString stringWithFormat:@"%@/40 gestation", self.selectedPatient.gestation];
            
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:@"Patient or gestation selected",
             @"Log",
             nil];
            
            [CBTrackers logEvent:@"UAC / UVC" withParameters:dictionary timed:NO];
        }
        else if (self.selectedPatient.birthWeight)
        {
            NSString *rawBirthWeight = self.selectedPatient.birthWeight;
            NSString *formattedBirthWeight;
            
            NSString *UKLocaleRawBirthWeight;
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
            
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
            birthWeightInNavBar = YES;
            
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:@"Patient or weight selected",
             @"Log",
             nil];
            
            [CBTrackers logEvent:@"UAC / UVC" withParameters:dictionary timed:NO];
        }
        // Passed in patient does not have a gestation or birth weight, and incomplete name or 'New BABY'
        else
        {
            self.title = @"UAC / UVC";
            
            NSDictionary *dictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:@"No details",
             @"Log",
             nil];
            
            [CBTrackers logEvent:@"UAC / UVC" withParameters:dictionary timed:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"UVCUACViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"UVCUACViewController unloaded properties");
        
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
    self.estimatedWeightUsed = nil;
    self.selectedPatient = nil;
    self.myTableView = nil;
    self.swipeGestureRecognizer = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    switch (section) 
    {
        case 0:
            rows = 3;
            break;
            
        case 1:
            rows = 2;
            break;
            
        default:
            break;
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    switch (section) 
    {
        case 0:
            header = @"Umbilical Arterial Line";
            break;
        case 1:
            header = @"Umbilical Venous Line";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 0) 
    {
        if (self.selectedPatient) 
        {
            NSString *typeOfWeight;
            
            if (self.estimatedWeightUsed) 
            {
                self.selectedPatient.workingWeight = self.selectedPatient.birthWeight;
                typeOfWeight = @"Estimated weight";
            }
            else if (self.selectedPatient.workingWeight)
            {
                typeOfWeight = @"Working weight";
            }
            else if (self.selectedPatient.birthWeight)
            {
                typeOfWeight = @"Birth weight";
            }
            
            if (self.selectedPatient.workingWeight) 
            {
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                
                // float workingWeightKGAsFloat = [self.selectedPatient.workingWeight floatValue];
                
                if (workingWeightKGAsFloat < 1.0f)
                {
                    int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
                    
                    footer = [NSString stringWithFormat:@"%@ %i g", typeOfWeight, workingWeightGRAMSAsInt];
                }
                else
                {
                    // present weight as kilograms
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    // if using arabic locale, force to english
                    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                    {
                        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                    }
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 3;
                    
                    footer = [NSString stringWithFormat:@"%@ %@ kg", typeOfWeight, [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
                }
            }
            else if (self.selectedPatient.birthWeight && !birthWeightInNavBar)
            {
                NSString *UKLocaleBirthWeight;
                UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float birthWeightKGAsFloat = [UKLocaleBirthWeight floatValue];
                
                // float birthWeightKGAsFloat = [self.selectedPatient.birthWeight floatValue];
                
                if (birthWeightKGAsFloat < 1.0f)
                {
                    int birthWeightGRAMSAsInt = birthWeightKGAsFloat * 1000;
                    
                    footer = [NSString stringWithFormat:@"%@ %i grams", typeOfWeight, birthWeightGRAMSAsInt];
                }
                else
                {
                    // present weight as kilograms
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    // if using arabic locale, force to english
                    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                    {
                        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                    }
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 3;
                    
                    footer = [NSString stringWithFormat:@"%@ %@ kg", typeOfWeight, [formatter stringFromNumber:[NSNumber numberWithFloat:birthWeightKGAsFloat]]];
                    
                    /*
                    NSString *tempString = [NSString stringWithFormat:@"%1.2f", birthWeightKGAsFloat];
                    
                    if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
                    {
                        if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                        {
                            footer = [NSString stringWithFormat:@"%@ %1.0f kg",typeOfWeight ,birthWeightKGAsFloat];
                        }
                        else 
                        {
                            footer = [NSString stringWithFormat:@"%@ %1.1f kg", typeOfWeight ,birthWeightKGAsFloat];
                        }
                    }
                    else 
                    {
                        footer = [NSString stringWithFormat:@"%@ %1.2f kg", typeOfWeight,birthWeightKGAsFloat];
                    }
                     */
                }
            }
        }
    }
    else if (section == 1)
    {
        if (!self.selectedPatient && !self.estimatedWeightUsed)
        {
            footer = @"If you are looking for calculated lengths,\nyou need to enter a weight or gestation";
        }
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
    {
        height = 66.0f;
    }
    else
    {
        height = 55.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) 
        {
            static NSString *CellIdentifier = @"cell00";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Length";
            
            if (self.selectedPatient) 
            {
                float length;
                
                if (self.selectedPatient.birthWeight) 
                {
                    NSString *UKLocaleBirthWeight;
                    UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                    
                    length = (([UKLocaleBirthWeight floatValue] * 3) + 9);
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f cm + stump", length];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else 
                {
                    cell.detailTextLabel.text = @"weight not entered";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
            else
            {
                cell.detailTextLabel.text = @"(weight [kg] x 3) + 9 cm";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"cell01";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"High Position";
            cell.detailTextLabel.text = @"T8 - T10";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"cell02";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Low Position";
            cell.detailTextLabel.text = @"L3 - L4";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) 
        {
            static NSString *CellIdentifier = @"cell10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Length";
            
            if (self.selectedPatient) 
            {
                float length;
                
                if (self.selectedPatient.birthWeight) 
                {
                    NSString *UKLocaleBirthWeight;
                    UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    UKLocaleBirthWeight = [self.selectedPatient.birthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                    
                    length = (([UKLocaleBirthWeight floatValue] * 2) + 5);
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f cm + stump", length];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                else 
                {
                    cell.detailTextLabel.text = @"weight not entered";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
            else
            {
                cell.detailTextLabel.text = @"(weight [kg] x 2) + 5 cm";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"cell11";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Position";
            cell.detailTextLabel.text = @"Inferior vena cava";
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
