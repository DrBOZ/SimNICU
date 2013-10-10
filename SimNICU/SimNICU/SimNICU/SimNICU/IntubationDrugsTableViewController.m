//
//  IntubationDrugsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "IntubationDrugsTableViewController.h"
#import "IntubationDrugsTableViewCell.h"

@interface IntubationDrugsTableViewController ()

@end

@implementation IntubationDrugsTableViewController

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
    
    [CBTrackers logEvent:@"Intubation/Drugs"];
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
            
            self.title = [NSString stringWithFormat:@"%@ %i g", NSLocalizedString(@"Working weight", nil), workingWeightGRAMSAsInt];
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
            formatter.minimumFractionDigits = 1;
            formatter.maximumFractionDigits = 3;
            
            self.title = [NSString stringWithFormat:@"%@ %@ kg", NSLocalizedString(@"Working weight", nil), [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Weight not entered", nil);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    float height;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        if (section == 0)
        {
            height = 66.0f;
        }
        else
        {
            height = 44.0f;
        }
    }
    else
    {
        if (section == 0)
        {
            height = 66.0f;
        }
        else
        {
            height = 22.0f;
        }
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
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        if (section == 0)
        {
            height = 32.0f;
        }
        else if (section == 1)
        {
            height = 66.0f;
        }
    }
    else
    {
        if (section == 0)
        {
            height = 44.0f;
        }
        else if (section == 1)
        {
            height = 88.0f;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntubationDrugsTableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
#pragma mark Morphine
        if (indexPath.row == 0)
        {
            NSString *CellIdentifier = @"Morphine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                // cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.drug.text = @"Morphine";
                
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                
                float morphineDose = workingWeightKGAsFloat * 50.0f;
                
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
#pragma mark Atracurium
        else if(indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Atracurium";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                // cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                
                if (workingWeightKGAsFloat > 0 && workingWeightKGAsFloat < 1.0f)
                {
                    cell.drug.textColor = [UIColor redColor];
                    cell.drug.shadowColor = [UIColor whiteColor];
                    cell.drug.shadowOffset = CGSizeMake(0.0f, 1.0f);
                    cell.drug.backgroundColor = [UIColor clearColor];
                    cell.drug.frame = CGRectMake(18.0f, 7.0f, 280.0f, 21.0f);
                    
                    cell.drug.text = @"Atracurium not recommended under 1 kg";
                    cell.subLabel2.text = @"500 micrograms/kg slow IV bolus";
                    
                    cell.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    cell.drug.text = @"Atracurium";
                    
                    float atracuriumDose = workingWeightKGAsFloat * 500.0f;
                    
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
#pragma mark Atropine
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Atropine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                // cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.drug.text = @"Atropine";
                
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                
                float atropineDose = workingWeightKGAsFloat * 20.0f;
                
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
#pragma mark Neostigmine
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Neostigmine";
            IntubationDrugsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                // cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                cell = [[IntubationDrugsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.drug.text = @"Neostigmine";
                
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                
                float neostigmineDose = workingWeightKGAsFloat * 50.0f;
                
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

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
