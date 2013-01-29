//
//  IntubationDrugsBackgroundViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 13/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "IntubationDrugsViewController.h"
#import "IntubationDrugsTableViewCell.h"
#import "AppDelegate.h"

@interface IntubationDrugsViewController ()

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSString *selectedDrug;

@end

@implementation IntubationDrugsViewController

@synthesize workingWeight = _workingWeight;
@synthesize selectedDrug = _selectedDrug;
@synthesize myTableView = _myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.workingWeight)
    {
        
#warning CODE NEEDED
        float workingWeightKGAsFloat = [self.workingWeight floatValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            // NSLocalizedString(@"Working weight", nil)
            
            self.title = [NSString stringWithFormat:@"%@ %i g", NSLocalizedString(@"Working weight", nil), workingWeightGRAMSAsInt];
        }
        else  // present weight as kilograms
        {
            NSString *tempString = [NSString stringWithFormat:@"%1.2f", workingWeightKGAsFloat];
            
            if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
            {
                if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                {
                    self.title = [NSString stringWithFormat:@"%@ %1.0f kg", NSLocalizedString(@"Working weight", nil), workingWeightKGAsFloat];
                }
                else {
                    self.title = [NSString stringWithFormat:@"%@ %1.1f kg", NSLocalizedString(@"Working weight", nil), workingWeightKGAsFloat];
                }
            }
            else
            {
                self.title = [NSString stringWithFormat:@"%@ %1.2f kg", NSLocalizedString(@"Working weight", nil), workingWeightKGAsFloat];
            }
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Weight not entered", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Intubation/Intubation Drugs" withError:nil];
    
#endif
    
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"IntubationDrugsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"IntubationDrugsViewController unloaded properties");
        
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0)
    {
        header = NSLocalizedString(@"Intubation drugs", nil);
    }
    
    if (section == 1)
    {
        header = NSLocalizedString(@"if required", nil);
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    if (section == 0)
    {
        height = 66.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 0)
    {
        footer = NSLocalizedString(@"Repeat doses may be required", nil);
    }
    else if (section == 1)
    {
        footer = NSLocalizedString(@"Atropine used to alleviate vagal side effects OR WITH Neostigmine as an antidote to Atracurium", nil);
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 0;
    
    if (section == 0)
    {
        height = 44.0f;
    }
    else if (section == 1)
    {
        height = 88.0f;
    }
    
    return height;
}

- (IntubationDrugsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntubationDrugsTableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Morphine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                
                /*
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108.0f, 21.0f)];
                drug.font = [UIFont boldSystemFontOfSize:18.0f];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, 7.0f, 142.0f, 21.0f)];
                dose.font = [UIFont boldSystemFontOfSize:18.0f];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.backgroundColor = [UIColor clearColor];
                
                UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
                subLabel2.textColor = [UIColor lightGrayColor];
                subLabel2.font = [UIFont systemFontOfSize:14.0f];
                subLabel2.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:subLabel2];
                 */
                
                cell.drug.text = @"Morphine";
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float morphineDose = workingWeightKGasFloat * 50.0f;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                // if locale has an arabic decimal separator then use english
                if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                {
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                }
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                if (morphineDose)
                {
                    cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:morphineDose]]];
                }
                
                cell.subLabel2.text = @"50 micrograms/kg slow IV bolus";
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Atracurium";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                
                /*
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
                subLabel2.textColor = [UIColor lightGrayColor];
                subLabel2.font = [UIFont systemFontOfSize:14.0f];
                subLabel2.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:subLabel2];
                 */
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                if (workingWeightKGasFloat > 0 && workingWeightKGasFloat < 1.0f)
                {
                    /*
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 290.0f, 21.0f)];
                    drug.font = [UIFont boldSystemFontOfSize:18.0f];
                    drug.adjustsFontSizeToFitWidth = YES;
                    // drug.textColor = [UIColor blackColor];
                     */
                    cell.drug.textColor = [UIColor redColor];
                    cell.drug.shadowColor = [UIColor whiteColor];
                    cell.drug.shadowOffset = CGSizeMake(0.0f, 1.0f);
                    cell.drug.backgroundColor = [UIColor clearColor];
                    // [cell addSubview:drug];
                    
                    cell.drug.text = @"Atracurium not recommended under 1 kg";
                    cell.subLabel2.text = @"500 micrograms/kg slow IV bolus";
                    
                    cell.backgroundColor = [UIColor clearColor];
                    // cell.backgroundColor = [UIColor grayColor];
                }
                else
                {
                    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    /*
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108.0f, 21.0f)];
                    drug.font = [UIFont boldSystemFontOfSize:18.0f];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, 7.0f, 142.0f, 21.0f)];
                    dose.font = [UIFont boldSystemFontOfSize:18.0f];
                    dose.backgroundColor = [UIColor clearColor];
                    dose.adjustsFontSizeToFitWidth = YES;
                    
                    [cell addSubview:drug];
                    [cell addSubview:dose];
                     */
                    
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    cell.drug.text = @"Atracurium";
                    
                    float atracuriumDose = workingWeightKGasFloat * 500.0f;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    // if locale has an arabic decimal separator then use english
                    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                    {
                        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                    }
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 1;
                    
                    if (atracuriumDose)
                    {
                        if (atracuriumDose < 1000)
                        {
                            // dose.text = [NSString stringWithFormat:@"%.0f micrograms",atracuriumDose];
                            
                            cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:atracuriumDose]]];
                        }
                        else
                        {
                            // present dose as milligrams
                            float atracuriumDoseMilligramsAsFloat = (atracuriumDose / 1000);
                            
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                            formatter.numberStyle = NSNumberFormatterDecimalStyle;
                            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                            formatter.minimumFractionDigits = 0;
                            formatter.maximumFractionDigits = 2;
                            
                            cell.dose.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:atracuriumDoseMilligramsAsFloat]]];
                        }
                    }
                    
                    cell.subLabel2.text = @"500 micrograms/kg slow IV bolus";
                }
            }
            
            returnCell = cell;
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Atropine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                
                /*
                cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108, 21.0f)];
                drug.font = [UIFont boldSystemFontOfSize:18.0f];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, 7.0f, 142, 21.0f)];
                dose.font = [UIFont boldSystemFontOfSize:18.0f];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.backgroundColor = [UIColor clearColor];
                
                UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
                subLabel2.textColor = [UIColor lightGrayColor];
                subLabel2.font = [UIFont systemFontOfSize:14.0f];
                subLabel2.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:subLabel2];
                */
                
                cell.drug.text = @"Atropine";
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float atropineDose = workingWeightKGasFloat * 20.0f;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                // if locale has an arabic decimal separator then use english
                if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                {
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                }
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                if (atropineDose)
                {
                    cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:atropineDose]]];
                }
                
                cell.subLabel2.text = @"20 micrograms/kg fast IV bolus";
            }
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Neostigmine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                
                /*
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108.0f, 21.0f)];
                drug.font = [UIFont boldSystemFontOfSize:18.0f];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, 7.0f, 142.0f, 21.0f)];
                dose.font = [UIFont boldSystemFontOfSize:18.0f];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.backgroundColor = [UIColor clearColor];
                
                UILabel *subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
                subLabel2.textColor = [UIColor lightGrayColor];
                subLabel2.font = [UIFont systemFontOfSize:14.0f];
                subLabel2.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:subLabel2];
                */
                
                cell.drug.text = @"Neostigmine";
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float neostigmineDose = workingWeightKGasFloat * 50.0f;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                // if locale has an arabic decimal separator then use english
                if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                {
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                }
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                if (neostigmineDose)
                {
                    cell.dose.text = [NSString stringWithFormat:@"%@ micrograms", [formatter stringFromNumber:[NSNumber numberWithFloat:neostigmineDose]]];
                }
                
                cell.subLabel2.text = @"50 micrograms/kg slow IV bolus";
            }
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

- (IntubationDrugsTableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    IntubationDrugsTableViewCell *cell;
    
    cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108.0f, 21.0f)];
    cell.drug.font = [UIFont boldSystemFontOfSize:18.0f];
    cell.drug.adjustsFontSizeToFitWidth = YES;
    cell.drug.textColor = [UIColor blackColor];
    cell.drug.backgroundColor = [UIColor clearColor];
    
    cell.dose = [[UILabel alloc] initWithFrame:CGRectMake(154.0f, 7.0f, 152.0f, 21.0f)];
    cell.dose.font = [UIFont boldSystemFontOfSize:17.0f];
    cell.dose.adjustsFontSizeToFitWidth = YES;
    cell.dose.backgroundColor = [UIColor clearColor];

    cell.subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
    cell.subLabel2.textColor = [UIColor lightGrayColor];
    cell.subLabel2.font = [UIFont systemFontOfSize:14.0f];
    cell.subLabel2.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:cell.drug];
    [cell addSubview:cell.dose];
    [cell addSubview:cell.subLabel2];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
    
    // return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            self.selectedDrug = @"Morphine";
        }
        else if (indexPath.row == 1)
        {
            self.selectedDrug = @"Atracurium";
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.selectedDrug = @"Atropine";
        }
        else if (indexPath.row == 1)
        {
            self.selectedDrug = @"Neostigmine";
        }
    }
    
    [self performSegueWithIdentifier:@"IntubationDrugDetails" sender:nil];
}

@end
