//
//  ResusViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 13/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "ResusViewTableViewCell.h"
#import "ResusViewController.h"
#import "AppDelegate.h"

@interface ResusViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation ResusViewController
{
    UILabel *drug;
    UILabel *dose;
    UILabel *equals;
    UILabel *subLabel2;
    UILabel *subLabel3;
    UILabel *subLabel4;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Resus"];
    
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
    [CBTableViewController setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.workingWeight)
    {
        NSString *UKLocaleWorkingWeight;
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            self.title = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
        }
        else  // present weight as kilograms
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
            
            self.title = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
        }
    }
    else
    {
        self.title = @"Weight not entered";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.narcanSelected isEqualToString:@"YES"])
    {
        // move table to narcan information
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
        
        [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.narcanSelected = nil;
    self.workingWeight = nil;
    self.myTableView = nil;
    self.swipeGestureRecognizer = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ResusViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"ResusViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    if (section == 0)
    {
        rows = 3;
    }
    else if (section == 2)
    {
        rows = 3;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 55;
    
    if (self.workingWeight) 
    {
        height = 102;
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            height = 84;
        }
    }
    if (indexPath.section == 1)
    {
        if (self.workingWeight)
        {
            height = 124;
        }
    }
    else if (indexPath.section == 2) 
    {
        if(indexPath.row == 0)
        {
            height = 102;
        }
        else if(self.workingWeight)
        {
            // height = 124;
            height = 85;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    if (section == 0) 
    {
        returnString = @"Cardiac Arrest";
    }
    else if (section == 1) 
    {
        // returnString = @"Hypocalcemia / hyperkalemia";
        returnString = [NSString stringWithFormat:@"%@ / %@", NSLocalizedString(@"Hypocalcaemia", nil), NSLocalizedString(@"hyperkalaemia", nil)];
    }
    else if (section == 2)
    {
        returnString = @"Opiate overdose";
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (section == 0) height = 66.0f;
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 2)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
        {
            footer = @"In severe respiratory depression after birth, breathing should first be established (using mask or endotracheal intubation) and naloxone administered only if opiates given to the mother within 4 hours of delivery is thought to be the cause of the respiratory depression; the infant should be monitored closely and further doses of naloxone administered as necessary.\n\nNEVER give to infants of narcotic addicted mothers as severe refractory seizures may occur.";
        }
        else 
        {
            footer = @"In severe respiratory depression after\nbirth, breathing should first be established\n(using mask or endotracheal intubation)\nand naloxone administered only if opiates\ngiven to the mother within 4 hours of\ndelivery is thought to be the cause of the\nrespiratory depression; the infant should\nbe monitored closely and further doses of\nnaloxone administered as necessary.\n\nNEVER give to infants of narcotic\naddicted mothers as severe refractory\nseizures may occur.";
        }
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int footer = 0;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        if (section == 2)
        {
            footer = 240;
        }
    }
    else
    {
        if (section == 2)
        {
            footer = 300;
        }
    }
    
    return footer;
}

- (ResusViewTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResusViewTableViewCell *returnCell = nil;
    
    // this is to ensure that if using a european locale, the commas are replaced with dots.
    NSString *UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
    
    // instantiate number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    // if locale has an arabic decimal separator then use english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSString *CellIdentifier = @"cell00";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];

            cell.drug.text = [NSString stringWithFormat:@"%@ 1:10,000 IV", NSLocalizedString(@"Adrenaline", nil)];
            
            float adrenalineDoseMicrograms = (workingWeightKGAsFloat * 10.0f);
            float adrenalineDoseMLs = (workingWeightKGAsFloat * 0.10f);
            
            if (adrenalineDoseMicrograms) 
            {
                formatter.maximumFractionDigits = 0;
                cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:adrenalineDoseMicrograms]]];
                
                formatter.maximumFractionDigits = 2;
                cell.subLabel3.text = [NSString stringWithFormat:@"%@ ml of neat solution", [formatter stringFromNumber:[NSNumber numberWithFloat:adrenalineDoseMLs]]];
                
                cell.subLabel4.text = @"";
                cell.equals.hidden = NO;
            }
            
            cell.subLabel2.text = @"10 micrograms/kg = 0.1 ml/kg";
            
            // Number localization code
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
                cell.drug.text = [cell.drug.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
                cell.subLabel2.text = [cell.subLabel2.text stringByReplacingOccurrencesOfString:@"." withString:@","];
                cell.subLabel3.text = [cell.subLabel3.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 1)
        {
            NSString *CellIdentifier = @"cell01";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            cell.drug.text = @"8.4% Sodium Bicarbonate IV";
            
            float bicarbonateDoseMLs = workingWeightKGAsFloat;
            
            if (bicarbonateDoseMLs) 
            {
                if (bicarbonateDoseMLs < 1.0f)
                {
                    formatter.maximumFractionDigits = 2;
                    
                    cell.dose.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:bicarbonateDoseMLs]]];
                }
                else
                {
                    formatter.maximumFractionDigits = 1;
                    
                    cell.dose.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:bicarbonateDoseMLs]]];
                }
                
                cell.equals.hidden = NO;
                cell.subLabel3.text = @"Double volume if using 4.2% solution";
                cell.subLabel4.text = @"";
            }
            
            cell.subLabel2.text = @"1 mmol/kg = 1 ml/kg";
            
            // Number localization code
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
                cell.drug.text = [cell.drug.text stringByReplacingOccurrencesOfString:@"." withString:@","];
                cell.subLabel3.text = [cell.subLabel3.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 2)
        {
            NSString *CellIdentifier = @"cell02";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            cell.drug.text = @"10% Dextrose IV";
            
            float dextroseDoseMLs = workingWeightKGAsFloat * 2.5f;
            
            if (dextroseDoseMLs) 
            {
                formatter.maximumFractionDigits = 1;
                
                cell.dose.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:dextroseDoseMLs]]];
                
                cell.equals.hidden = NO;
            }
            cell.subLabel3.text = @"";
            cell.subLabel2.text = @"2.5 ml/kg";
            cell.subLabel4.text = @"";
            
            // Number localization code
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
        
                cell.subLabel2.text = [cell.subLabel2.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            NSString *CellIdentifier = @"cell10";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            cell.drug.text = @"Calcium Gluconate 10% IV";
            
            float calciumGluconateDoseMMOL = workingWeightKGAsFloat * 0.11f;
            float calciumGluconateDoseMls = workingWeightKGAsFloat * 0.5f;
            
            if(calciumGluconateDoseMMOL)
            {
                formatter.maximumFractionDigits = 2;
                
                cell.dose.text = [NSString stringWithFormat:@"%@ mmol", [formatter stringFromNumber:[NSNumber numberWithFloat:calciumGluconateDoseMMOL]]];
                
                cell.subLabel3.text = [NSString stringWithFormat:@"(%@ ml of neat solution)", [formatter stringFromNumber:[NSNumber numberWithFloat:calciumGluconateDoseMls]]];
                
                cell.subLabel4.text = @"Give over 5-10 minutes if possible";
                
                cell.equals.hidden = NO;
            }
            cell.subLabel2.text = @"0.11 mmol/kg = 0.5 ml/kg";
            
            // Number localization code
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
                
                cell.subLabel2.text = [cell.subLabel2.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            NSString *CellIdentifier = @"cell20";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            // Delivery suite Naloxone is generally 400 micrograms /ml
            // but can come in 20 micrograms/ml
            
            cell.drug.text = @"Naloxone (Delivery Suite)";
            cell.dose.text = @"200 micrograms IM";
            cell.subLabel3.text = @"0.5 ml of 400 microgram/ml vial";
            cell.subLabel2.text = @"approx 60 micrograms/kg at term";
            cell.subLabel4.text = @"";
            cell.equals.hidden = NO;
            
            if (self.workingWeight && ([UKLocaleWorkingWeight doubleValue] < 2.5))
            {
                UILabel *cautionLabel = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 57.0f, 188.0f, 21.0f)];
                cautionLabel.textColor = [UIColor lightGrayColor];
                cautionLabel.text = @"Intubate and ventilate";
                cautionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                
                cell.dose.text = nil;
                cell.subLabel3.text = nil;
                
                [cell addSubview:cautionLabel];
            }
            
            // Number localization code
            if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
            {
                
                cell.subLabel3.text = [cell.subLabel3.text stringByReplacingOccurrencesOfString:@"." withString:@","];
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            NSString *CellIdentifier = @"cell21";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            cell.drug.text = @"Naloxone IV initial dose";
            cell.subLabel2.text = @"10 micrograms/kg";
            
            float naloxoneDose10Micrograms = workingWeightKGAsFloat * 10.0f;
            
            if (naloxoneDose10Micrograms) 
            {
                formatter.maximumFractionDigits = 0;
                
                cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:naloxoneDose10Micrograms]]];

                cell.equals.hidden = NO;
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 2)
        {
            NSString *CellIdentifier = @"cell22";
            ResusViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            cell.drug.text = @"Naloxone IV subsequent doses";
            cell.subLabel2.text = @"100 micrograms/kg";
            
            float naloxoneDose100Micrograms = workingWeightKGAsFloat * 100.0f;
            
            if (naloxoneDose100Micrograms) 
            {
                formatter.maximumFractionDigits = 0;
                
                cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:naloxoneDose100Micrograms]]];
                
                // cell.dose.text = [NSString stringWithFormat:@"%i micrograms",naloxoneDose100Micrograms];
                
                // subLabel3.text = [NSString stringWithFormat:@"%.1f ml of 20 micrograms/ml", naloxoneDose100MLs];
                // subLabel4.text = @"Note lower strength ampoule";
                cell.equals.hidden = NO;
            }
            
            cell.subLabel3 = nil;
            cell.subLabel4 = nil;
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

- (ResusViewTableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    ResusViewTableViewCell *cell;
    
    cell = [[ResusViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat leftTextPosition;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        leftTextPosition = 15.0f;
    }
    else
    {
        leftTextPosition = 18.0f;
    }
    cell.drug = [[UILabel alloc] initWithFrame:CGRectMake(leftTextPosition, 7.0f, 259.0f, 22.0f)];
    cell.drug.font = [UIFont boldSystemFontOfSize:17.0f];
    cell.drug.adjustsFontSizeToFitWidth = YES;
    cell.drug.textColor = [UIColor blackColor];
    cell.drug.backgroundColor = [UIColor clearColor];
    
    cell.dose = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 57.0f, 188.0f, 21.0f)];
    cell.dose.font = [UIFont boldSystemFontOfSize:17.0f];
    cell.dose.backgroundColor = [UIColor clearColor];
    
    cell.equals = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, 56.0f, 37.0f, 21.0f)];
    cell.equals.textColor = [UIColor lightGrayColor];
    cell.equals.backgroundColor = [UIColor clearColor];
    cell.equals.textAlignment = UITextAlignmentRight;
    cell.equals.text = @"=";
    cell.equals.hidden = YES;
    
    cell.subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(leftTextPosition, 28.0f, 259.0f, 26.0f)];
    cell.subLabel2.textColor = [UIColor lightGrayColor];
    cell.subLabel2.font = [UIFont systemFontOfSize:14.0f];
    cell.subLabel2.backgroundColor = [UIColor clearColor];
    
    cell.subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 76.0f, 230.0f, 21.0f)];
    cell.subLabel3.textColor = [UIColor lightGrayColor];
    cell.subLabel3.backgroundColor = [UIColor clearColor];
    cell.subLabel3.adjustsFontSizeToFitWidth = YES;
    
    cell.subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 96.0f, 230.0f, 21.0f)];
    cell.subLabel4.textColor = [UIColor lightGrayColor];
    cell.subLabel4.backgroundColor = [UIColor clearColor];
    cell.subLabel4.adjustsFontSizeToFitWidth = YES;
    
    [cell addSubview:cell.drug];
    [cell addSubview:cell.dose];
    [cell addSubview:cell.equals];
    [cell addSubview:cell.subLabel2];
    [cell addSubview:cell.subLabel3];
    [cell addSubview:cell.subLabel4];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
