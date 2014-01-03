//
//  FluidBalanceViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "FluidBalanceTableViewController.h"
#import "FluidTableViewCell.h"
#import "UnderlineLabel.h"
#import "AddFluidCell.h"

@interface FluidBalanceTableViewController ()

@end

@implementation FluidBalanceTableViewController
{
    float workingWeightKGAsFloat;
    double workingWeightKGAsDouble;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.workingWeight = @"1.5";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Fluid Balance"];
    
    // set up buttons if used modally
    if (self.useAsModalViewController)
    {
        // set navigation item buttons and tint for iOS 7
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.view.tintColor = [UIColor redColor];
        }
    }
    
    // if no working weight then show instructions
    if (!self.workingWeight)
    {
        self.tableView.tableFooterView = [self setupFooterView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.workingWeight)
    {
        // goes through the entire string and replaces any commas with full stops in case
        // user is using a european locale
        NSString *UKLocaleWorkingWeight;
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        workingWeightKGAsDouble = [UKLocaleWorkingWeight doubleValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            // present weight as grams
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            self.title = [NSString stringWithFormat:@"%@ %ig", NSLocalizedString(@"Working weight", nil) ,workingWeightGRAMSAsInt];
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
            
            self.title = [NSString stringWithFormat:@"%@ %@ kg", NSLocalizedString(@"Working weight", nil), [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Weight not entered", nil);
    }
    
    // starts UITableView in editing mode
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
//    if ([self.editOrAddResult isEqualToString:@"Edit"])
//    {
//        // update sample data
//        [self updateSampleData];
//        
//        [self.delegate addBloodResultTableViewController:self didFinishEditingSampleData:self.sampleData];
//    }
//    else
//    {
//        self.sampleData = [NSMutableDictionary dictionary];
//        
//        // add a unique identifier
//        Preferences *preferences = [Preferences sharedPreferences];
//        
//        [self.sampleData setObject:preferences.bloodResultUniqueReferenceCounter forKey:@"Unique Reference"];
//        
//        // increment counter
//        int counter = [preferences.bloodResultUniqueReferenceCounter intValue];
//        counter ++;
//        preferences.bloodResultUniqueReferenceCounter = [NSNumber numberWithInt:counter];
//        
//        // add results to sample data
//        [self updateSampleData];
//        
//        NSString *displayResults = @"NO";
//        
//        [self.sampleData setObject:displayResults forKey:@"Display FBC"];
//        [self.sampleData setObject:displayResults forKey:@"Display Clotting"];
//        [self.sampleData setObject:displayResults forKey:@"Display Fibrinogen"];
//        [self.sampleData setObject:displayResults forKey:@"Display U&Es"];
//        [self.sampleData setObject:displayResults forKey:@"Display CRP"];
//        [self.sampleData setObject:displayResults forKey:@"Display LFTs"];
//        [self.sampleData setObject:displayResults forKey:@"Display Conjugated Bilirubin"];
//        [self.sampleData setObject:displayResults forKey:@"Display Bone Profile"];
//        [self.sampleData setObject:displayResults forKey:@"Display Magnesium"];
//        [self.sampleData setObject:displayResults forKey:@"Display Ammonia"];
//        
//        [self.delegate addBloodResultTableViewController:self didFinishAddingNewSampleData:self.sampleData];
//    }
}

//- (void)updateSampleData
//{
//    // add/update sample date
//    [self.sampleData setObject:self.resultDate forKey:@"Result Date"];
//    
//    // add/update sample results
//    for (int section = 1; section < tableData.count - 1; section ++)
//    {
//        CBTableViewSectionData *sectionData = tableData[section];
//        int rows = [sectionData.rowData count];
//        
//        for (int row = 0; row < rows; row ++)
//        {
//            CBTableViewRowData *rowData = sectionData.rowData[row];
//            
//            [self.sampleData setObject:rowData.textField.text forKey:rowData.reference];
//            
//            NSLog(@"Reference: %@ - Value: %@", rowData.reference, rowData.textField.text);
//        }
//    }
//}

- (void)cancel
{
//    [self.delegate addBloodResultTableViewControllerDidCancel:self];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.workingWeight)
    {
        return 3;
    }
    else
    {
        // footer view stating that weight is required
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 0) return 1;
        
        else if (section == 1) return 1;
        
        else if (section == 2) return 0;
        
        else return nil;
    }
    else
    {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 0) return NSLocalizedString(@"IN", nil);
        
        else if (section == 1) return NSLocalizedString(@"OUT", nil);
        
        else if (section == 2) return NSLocalizedString(@"BALANCE", nil);
        
        else return nil;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 0 || section == 1) return 70.0f;
        
        else return 44.0f;
    }
    else return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.workingWeight)
    {
        if (section == 0 || section == 1)
        {
            CGFloat x = 230.0f;
            
            UIView *dailyInputResults = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
            
            // setup button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"addRow.png"] forState:UIControlStateNormal];
            button.frame = CGRectMake(8.0f, 9.0f, 30.0f, 30.0f);
            button.showsTouchWhenHighlighted = NO;
            [button addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            
            [dailyInputResults addSubview:button];
            
            // title
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, (320.0f - x), 22.0f)];
            title.font = [UIFont systemFontOfSize:12.0f];
            
            if (section == 0) title.text = NSLocalizedString(@"Total IN", nil);
            else if (section == 1) title.text = NSLocalizedString(@"Total OUT", nil);
            
            [dailyInputResults addSubview:title];
            
            // ml/day
            UILabel *miscText = [[UILabel alloc] initWithFrame:CGRectMake(x, 22.0f, (320.0f - x), 22.0f)];
            miscText.font = [UIFont systemFontOfSize:12.0f];
            miscText.text = [CBStringMethods localisedString:@"90 ml/day"];
            
            [dailyInputResults addSubview:miscText];
            
            // ml/kg/day
            UILabel *miscText2 = [[UILabel alloc] initWithFrame:CGRectMake(x, 44.0f, (320.0f - x), 22.0f)];
            miscText2.font = [UIFont systemFontOfSize:12.0f];
            miscText2.text = [CBStringMethods localisedString:@"60 ml/kg/day"];
            
            [dailyInputResults addSubview:miscText2];
            
            return  dailyInputResults;
        }
        else if (section == 2)
        {
            CGFloat x = 90.0f;
            
            UIView *balanceResults = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
            
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.0f, (320.0f - x), 44)];
            balance.font = [UIFont systemFontOfSize:19.0f];
            balance.text = @"+69 ml (+40 ml/kg)";
            
            [balanceResults addSubview:balance];
            
            return balanceResults;
        }
        else return nil;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        height = 216.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"IN";
            
            FluidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[FluidTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            
            cell.mlPerDay.tag = (indexPath.section * 100) + indexPath.row;
            
            cell.textLabel.text = @"Milk";
            cell.detailTextLabel.text = @"60 ml/kg/day";
            
            return cell;
        }
        else
        {
            CellIdentifier = @"Blank Cell";
            
            AddFluidCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[AddFluidCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        CellIdentifier = @"OUT";
        
        FluidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[FluidTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.mlPerDay.tag = (indexPath.section * 100) + indexPath.row;
        
        cell.textLabel.text = @"Urine";
        cell.detailTextLabel.text = @"40 ml/kg/day";
        
        return cell;
    }
    else return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            return NO;
        }
        else return YES;
    }
    else return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert;
}

- (UIView *)setupFooterView
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    float height = 50.0f;
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        height = 110.0f; // 4 inch Retina
    }
    else
    {
        height = 70.0f; // 3.5 inch Retina
    }
    
    // Instructions, as no working weight entered...
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 300.0f)];
    
    UIView *instructions = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, 0.0f, 200.0f)];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 150.0f)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = UITextAlignmentCenter;
    text.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    text.shadowColor = [UIColor whiteColor];
    text.shadowOffset = CGSizeMake(0.0f, 1.0f);
    text.numberOfLines = 0;
    text.font = [UIFont boldSystemFontOfSize:15.0f];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        text.text = NSLocalizedString(@"A weight is needed for this calculator.\n\nPlease go back and enter a weight or gestation, or select a patient.", nil);
    }
    else
    {
        text.text = NSLocalizedString(@"A weight is needed for this calculator.\n\nPlease go back and press the          \nbutton, or slide the image to the right,\nand enter a weight or gestation\nor select a patient.", nil);
        
        UIImageView *plusButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusButton2.png"]];
        plusButton.frame = CGRectMake(270.0f, 36.0f, 40.0f, 40.0f);
        [instructions addSubview:plusButton];
    }
    
    [instructions addSubview:text];
    
    UnderlineLabel *thankYou = [[UnderlineLabel alloc] initWithFrame:CGRectMake(0.0f, 136.0f, 320.0f, 44.0f)];
    thankYou.backgroundColor = [UIColor clearColor];
    thankYou.textAlignment = UITextAlignmentCenter;
    thankYou.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    thankYou.shadowColor = [UIColor whiteColor];
    thankYou.shadowOffset = CGSizeMake(0.0f, 1.0f);
    thankYou.numberOfLines = 1;
    thankYou.start = 122.0f;
    thankYou.end = 197.0f;
    thankYou.font = [UIFont boldSystemFontOfSize:15.0f];
    thankYou.text = @"Thank you.";
    [instructions addSubview:thankYou];
    
    [footerView addSubview:instructions];
    
    return footerView;
}

@end
