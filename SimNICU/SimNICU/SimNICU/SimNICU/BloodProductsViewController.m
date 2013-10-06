//
//  BloodProductsViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PlateletTransfusionCriteriaViewController.h"
#import "BloodTransfusionCriteriaViewController.h"
#import "BloodProductsViewController.h"
#import "BloodProductsTableViewCell.h"

@interface BloodProductsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation BloodProductsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Blood Products"];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.view.tintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height));
    }
    else
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f));
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
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
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
                
                self.title = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
            }
        }
        else 
        {
            self.title = @"Weight not entered";
        }
    }
    else 
    {
        self.title = @"Blood Products";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.swipeGestureRecognizer = nil;
    self.myTableView = nil;
    self.workingWeight = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"BloodProductViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"BloodProductViewController unloaded properties");
        
        NSLog(@"EnterWeightViewController releasing objects");
        
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
    if (section == 2) return 2;
    else return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *headerTitles = @[NSLocalizedString(@"Anaemia", nil), @"Thrombocytopenia", @"Deranged coagulation", @"Miscellaneous"];
    
    return headerTitles[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) return @"Contact Blood Bank ahead of time";
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 66.0f;
    else return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BloodProductsTableViewCell *returnCell = nil;
    
    // convert if user is using a european locale
    NSString *UKLocaleWorkingWeight;
    UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    // if locale has an arabic decimal separator then use english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.minimumFractionDigits = 0;
    
    if(indexPath.section == 0)
    {
        NSString *CellIdentifier = @"Anaemia";
        BloodProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[BloodProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.bloodProduct.text = @"Packed Red Cells";
        cell.regimen.text = @"20 ml/kg over 4 hours";
        
        float packedCellsTotalVolume = (workingWeightKGAsFloat * 20.0f);
        
        if (packedCellsTotalVolume < 20.0f)
        {
            formatter.maximumFractionDigits = 1;
        }
        else if (packedCellsTotalVolume >= 20.0f)
        {
            formatter.maximumFractionDigits = 0;
        }
        
        if (packedCellsTotalVolume) 
        {
            cell.volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:packedCellsTotalVolume]]];
        }
        else 
        {
            cell.volume.text = @"";
        }
        
        returnCell = cell;
    }
    else if (indexPath.section == 1)
    {
        NSString *CellIdentifier = @"Platelets";
        BloodProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[BloodProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.bloodProduct.text = @"Platelets";
        cell.regimen.text = @"10 ml/kg over 20 minutes";
        
        float plateletsTotalVolume = (workingWeightKGAsFloat * 10.0f);
        
        if (plateletsTotalVolume < 20.0f)
        {
            formatter.maximumFractionDigits = 1;
        }
        else if (plateletsTotalVolume >= 20.0f)
        {
            formatter.maximumFractionDigits = 0;
        }
        
        if (plateletsTotalVolume) 
        {
            cell.volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:plateletsTotalVolume]]];
        }
        else 
        {
            cell.volume.text = @"";
        }
        
        returnCell = cell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) 
        {
            NSString *CellIdentifier = @"FFP";
            BloodProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[BloodProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.bloodProduct.text = @"Fresh Frozen Plasma";
            cell.regimen.text = @"10 ml/kg over 20 minutes";
            
            float FFPTotalVolume = (workingWeightKGAsFloat * 10.0f);
            
            if (FFPTotalVolume < 20.0f)
            {
                formatter.maximumFractionDigits = 1;
            }
            else if (FFPTotalVolume >= 20.0f)
            {
                formatter.maximumFractionDigits = 0;
            }
            
            if (FFPTotalVolume) 
            {
                cell.volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:FFPTotalVolume]]];
            }
            else 
            {
                cell.volume.text = @"";
            }
            
            returnCell = cell;
        }
        else
        {
            NSString *CellIdentifier = @"Cryoprecipitate";
            BloodProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[BloodProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.bloodProduct.text = @"Cryoprecipitate";
            cell.regimen.text = @"10 ml/kg over 20 minutes";
            
            // 10 ml/kg - later put in user defined variable
            float cryoTotalVolume = (workingWeightKGAsFloat * 10.0f);
            
            if (cryoTotalVolume < 20.0f)
            {
                formatter.maximumFractionDigits = 1;
            }
            else if (cryoTotalVolume >= 20.0f)
            {
                formatter.maximumFractionDigits = 0;
            }
            
            if (cryoTotalVolume) 
            {
                cell.volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:cryoTotalVolume]]];
            }
            else 
            {
                cell.volume.text = @"";
            }
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 3) // future feature...
    {
        NSString *CellIdentifier = @"Immunoglobulin";
        BloodProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[BloodProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.bloodProduct.text = @"Immunoglobulin";
        cell.regimen.text = @"";
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) return indexPath;
    else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        BloodTransfusionCriteriaViewController *newViewController = [[BloodTransfusionCriteriaViewController alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        PlateletTransfusionCriteriaViewController *newViewController = [[PlateletTransfusionCriteriaViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}

@end
