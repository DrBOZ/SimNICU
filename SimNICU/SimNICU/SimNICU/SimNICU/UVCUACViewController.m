//
//  UVCUACViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "UVCUACViewController.h"
#import "AppDelegate.h"

@interface UVCUACViewController () <UITableViewDelegate, UITableViewDataSource>

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
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height - 49))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    tableBgView.alpha = 0.5;
    [self.view addSubview:tableBgView];
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    // Determining if a patient has been passed into view controller
    if (self.selectedPatient)
    {
        NSLog(@"UVCUACBackgroundVC: self.selectedPatient = YES");
        
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
            birthWeightInNavBar = YES;
            
        }
        // Passed in patient does not have a gestation or birth weight, and incomplete name or 'New BABY'
        else
        {
            self.title = @"UAC / UVC";
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"UAC / UVC" withError:nil];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"UVCUACViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"UVCUACViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewDidUnload
{
    self.estimatedWeightUsed = nil;
    self.selectedPatient = nil;
    self.myTableView = nil;
    
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
    int rows;
    
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
                float workingWeightKGAsFloat = [self.selectedPatient.workingWeight floatValue];
                
                if (workingWeightKGAsFloat < 1.0f)
                {
                    int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
                    
                    footer = [NSString stringWithFormat:@"%@ %i g", typeOfWeight, workingWeightGRAMSAsInt];
                }
                else  // present weight as kilograms
                {
                    NSString *tempString = [NSString stringWithFormat:@"%1.2f", workingWeightKGAsFloat];
                    
                    if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
                    {
                        if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                        {
                            footer = [NSString stringWithFormat:@"%@ %1.0f kg",typeOfWeight ,workingWeightKGAsFloat];
                        }
                        else 
                        {
                            footer = [NSString stringWithFormat:@"%@ %1.1f kg", typeOfWeight ,workingWeightKGAsFloat];
                        }
                    }
                    else 
                    {
                        footer = [NSString stringWithFormat:@"%@ %1.2f kg", typeOfWeight,workingWeightKGAsFloat];
                    }
                }
            }
            else if (self.selectedPatient.birthWeight && !birthWeightInNavBar)
            {
                float birthWeightKGAsFloat = [self.selectedPatient.birthWeight floatValue];
                
                if (birthWeightKGAsFloat < 1.0f)
                {
                    int birthWeightGRAMSAsInt = birthWeightKGAsFloat * 1000;
                    
                    footer = [NSString stringWithFormat:@"%@ %i grams", typeOfWeight, birthWeightGRAMSAsInt];
                }
                else  // present weight as kilograms
                {
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
                }
            }
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
                    length = (([self.selectedPatient.birthWeight floatValue] * 3) + 9);
                    
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
                    length = (([self.selectedPatient.birthWeight floatValue] * 2) + 5);
                    
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
