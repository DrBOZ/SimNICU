//
//  ResusViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 13/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "ResusViewController.h"
#import "AppDelegate.h"

@interface ResusViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation ResusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
    {
        if (self.workingWeight) 
        {
            float workingWeightKGAsFloat = [self.workingWeight floatValue];
            
            if (workingWeightKGAsFloat < 1.0f)
            {
                int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
                
                self.title = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
            }
            else  // present weight as kilograms
            {
                NSString *tempString = [NSString stringWithFormat:@"%1.2f", workingWeightKGAsFloat];
                
                if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
                {
                    if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                    {
                        self.title = [NSString stringWithFormat:@"Working weight %1.0f kg", workingWeightKGAsFloat];
                    }
                    else {
                        self.title = [NSString stringWithFormat:@"Working weight %1.1f kg", workingWeightKGAsFloat];
                    }
                }
                else 
                {
                    self.title = [NSString stringWithFormat:@"Working weight %1.2f kg", workingWeightKGAsFloat];
                }
            }
        }
        else 
        {
            self.title = @"Weight not entered";
        }
    }
    else 
    {
        self.title = @"Resuscitation Drugs";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Resus Drugs" withError:nil];
    
#endif
    
    if ([self.narcanSelected isEqualToString:@"YES"])
    {
        // move table to narcan information
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
        
        [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)viewDidUnload
{
    self.narcanSelected = nil;
    self.workingWeight = nil;
    self.myTableView = nil;
    
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
    
    if (section == 2)
    {
        footer = 300;
    }
    
    return footer;
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
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = [NSString stringWithFormat:@"%@ 1:10,000 IV", NSLocalizedString(@"Adrenaline", nil)];
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float adrenalineDoseMicrograms = (workingWeightKGasFloat * 10.0);
            float adrenalineDoseMLs = (workingWeightKGasFloat * 0.10);
            
            adrenalineDoseMLs = roundf(adrenalineDoseMLs *100.0f)/100.0f;
            
            if (adrenalineDoseMicrograms) 
            {
                dose.text = [NSString stringWithFormat:@"%.0f micrograms",adrenalineDoseMicrograms];
                
                subLabel3.text = [NSString stringWithFormat:@"(%.2f ml of neat solution)", adrenalineDoseMLs];
                
                subLabel4.text = @"";
                equals.hidden = NO;
            }
            
            subLabel2.text = @"10 micrograms/kg = 0.1 ml/kg";
            
            returnCell = cell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"cell01";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = @"8.4% Sodium Bicarbonate IV";
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float bicarbonateDoseMLs = workingWeightKGasFloat;
            
            if (bicarbonateDoseMLs) 
            {
                if (bicarbonateDoseMLs < 1.0f) {
                    // 2 decimal places if not zeros
                    dose.text = [NSString stringWithFormat:@"%.2f ml",bicarbonateDoseMLs];
                }
                else {
                    dose.text = [NSString stringWithFormat:@"%.1f ml",bicarbonateDoseMLs];
                }
                
                equals.hidden = NO;
                subLabel3.text = @"Double volume if using 4.2% solution";
                subLabel4.text = @"";
            }
            
            subLabel2.text = @"1 mmol/kg = 1 ml/kg";
            
            returnCell = cell;
        }
        else if(indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"cell02";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = @"10% Dextrose IV";
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float dextroseDoseMLs = workingWeightKGasFloat * 2.5;
            
            if (dextroseDoseMLs) 
            {
                dose.text = [NSString stringWithFormat:@"%1.1f ml",dextroseDoseMLs];
                equals.hidden = NO;
            }
            subLabel3.text = @"";
            subLabel2.text = @"2.5 ml/kg";
            subLabel4.text = @"";
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"cell10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = @"Calcium Gluconate 10% IV";
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float calciumGluconateDoseMMOL = workingWeightKGasFloat * 0.11;
            float calciumGluconateDoseMls = workingWeightKGasFloat * 0.5;
            
            calciumGluconateDoseMMOL = roundf(calciumGluconateDoseMMOL * 100.0f)/100.0f;
            calciumGluconateDoseMls = roundf(calciumGluconateDoseMls * 100.0f)/100.0f;
            
            if(calciumGluconateDoseMMOL)
            {
                // code to remove zeros to help avoid ten fold errors
                // 
                NSString *tempString = [NSString stringWithFormat:@"%.2f", calciumGluconateDoseMMOL];
                
                if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
                {
                    if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                    {
                        dose.text = [NSString stringWithFormat:@"%.0f mmol", calciumGluconateDoseMMOL];
                    }
                    else {
                        dose.text = [NSString stringWithFormat:@"%.1f mmol", calciumGluconateDoseMMOL];
                    }
                }
                else 
                {
                    dose.text = [NSString stringWithFormat:@"%.2f mmol", calciumGluconateDoseMMOL];
                }
                
                tempString = [NSString stringWithFormat:@"%.2f", calciumGluconateDoseMls];
                
                if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
                {
                    if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                    {
                        subLabel3.text = [NSString stringWithFormat:@"(%.0f ml of neat solution)", calciumGluconateDoseMls];
                    }
                    else {
                        subLabel3.text = [NSString stringWithFormat:@"(%.1f ml of neat solution)", calciumGluconateDoseMls];
                    }
                }
                else 
                {
                    subLabel3.text = [NSString stringWithFormat:@"(%.2f ml of neat solution)", calciumGluconateDoseMls];
                }
                
                // subLabel3.text = [NSString stringWithFormat:@"(%.2f ml of neat solution)", calciumGluconateDoseMls];
                
                subLabel4.text = @"Give over 5-10 minutes if possible";
                
                equals.hidden = NO;
            }
            subLabel2.text = @"0.11 mmol/kg = 0.5 ml/kg";
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"cell20";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            // Delivery suite Naloxone is generally 400 micrograms /ml
            // but can come in 20 micrograms/ml
            
            drug.text = @"Naloxone (Delivery Suite)";
            dose.text = @"200 micrograms IM";
            subLabel3.text = @"0.5 ml of 400 microgram/ml vial";
            subLabel2.text = @"approx 60 micrograms/kg at term";
            subLabel4.text = @"";
            equals.hidden = NO;
            
            if ([self.workingWeight doubleValue] < 2.5)
            {
                UILabel *cautionLabel = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 57.0f, 188.0f, 21.0f)];
                cautionLabel.textColor = [UIColor lightGrayColor];
                cautionLabel.text = @"Intubate and ventilate";
                cautionLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                
                subLabel3.text = @" ";
                
                [cell addSubview:cautionLabel];
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"cell21";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = @"Naloxone IV initial dose";
            subLabel2.text = @"10 micrograms/kg";
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            int naloxoneDose10Micrograms = workingWeightKGasFloat * 10;
            // float naloxoneDose10MLs = workingWeightKGasFloat * 0.5;
            
            if (naloxoneDose10Micrograms) 
            {
                dose.text = [NSString stringWithFormat:@"%i micrograms",naloxoneDose10Micrograms];
                
                // subLabel3.text = [NSString stringWithFormat:@"%.2f ml of 20 micrograms/ml", naloxoneDose10MLs];
                // subLabel4.text = @"Note lower strength ampoule";
                equals.hidden = NO;
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"cell22";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18, 7, 259, 22)];
            drug.font = [UIFont boldSystemFontOfSize:17.0];
            drug.adjustsFontSizeToFitWidth = YES;
            drug.textColor = [UIColor blackColor];
            drug.backgroundColor = [UIColor clearColor];
            UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(69, 57, 188, 21)];
            dose.font = [UIFont boldSystemFontOfSize:17.0];
            dose.backgroundColor = [UIColor clearColor];
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(24, 56, 37, 21)];
            equals.textColor = [UIColor lightGrayColor];
            equals.backgroundColor = [UIColor clearColor];
            equals.textAlignment = UITextAlignmentRight;
            equals.text = @"=";
            equals.hidden = YES;
            UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18, 28, 259, 26)];
            subLabel2.textColor = [UIColor lightGrayColor];
            subLabel2.font = [UIFont systemFontOfSize:14.0];
            subLabel2.backgroundColor = [UIColor clearColor];
            UILabel *subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69, 76, 230, 21)];
            subLabel3.textColor = [UIColor lightGrayColor];
            subLabel3.backgroundColor = [UIColor clearColor];
            subLabel3.adjustsFontSizeToFitWidth = YES;
            UILabel *subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69, 96, 230, 21)];
            subLabel4.textColor = [UIColor lightGrayColor];
            subLabel4.backgroundColor = [UIColor clearColor];
            subLabel4.adjustsFontSizeToFitWidth = YES;
            
            [cell addSubview:drug];
            [cell addSubview:dose];
            [cell addSubview:equals];
            [cell addSubview:subLabel2];
            [cell addSubview:subLabel3];
            [cell addSubview:subLabel4];
            
            drug.text = @"Naloxone IV subsequent doses";
            subLabel2.text = @"100 micrograms/kg";
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            int naloxoneDose100Micrograms = workingWeightKGasFloat * 100;
            // float naloxoneDose100MLs = workingWeightKGasFloat * 5;
            
            if (naloxoneDose100Micrograms) 
            {
                dose.text = [NSString stringWithFormat:@"%i micrograms",naloxoneDose100Micrograms];
                
                // subLabel3.text = [NSString stringWithFormat:@"%.1f ml of 20 micrograms/ml", naloxoneDose100MLs];
                // subLabel4.text = @"Note lower strength ampoule";
                equals.hidden = NO;
            }
            
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
