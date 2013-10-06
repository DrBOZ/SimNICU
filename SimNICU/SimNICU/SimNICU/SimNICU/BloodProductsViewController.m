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
#import "AppDelegate.h"

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
    int rows = 1;
    
    if (section == 2) 
    {
        rows = 2;
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0) {
        header = NSLocalizedString(@"Anaemia", nil);
    }
    else if (section == 1)
    {
        header = @"Thrombocytopenia";
    }
    else if (section == 2)
    {
        header = @"Deranged coagulation";
    }
    else if (section == 3)
    {
        header = @"Miscellaneous";
    }
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 1)
    {
        footer = @"Contact Blood Bank ahead of time";
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (section == 0) 
    {
        height = 66.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
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
        static NSString *CellIdentifier = @"Anaemia";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        UILabel *bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 9.0f, 177.0f, 21.0f)];
        bloodProduct.font = [UIFont boldSystemFontOfSize:17.0f];
        bloodProduct.backgroundColor = [UIColor clearColor];
        bloodProduct.textColor = [UIColor blackColor];
        bloodProduct.adjustsFontSizeToFitWidth = YES;
        
        UILabel *volume = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 9.0f, 80.0f, 21.0f)];
        volume.font = [UIFont boldSystemFontOfSize:17.0f];
        volume.backgroundColor = [UIColor clearColor];
        volume.textAlignment = UITextAlignmentRight;
        
        UILabel *regimen = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 33.0f, 237.0f, 21.0f)];
        regimen.backgroundColor = [UIColor clearColor];
        regimen.font = [UIFont systemFontOfSize:14.0f];
        regimen.textColor = [UIColor lightGrayColor];
        regimen.adjustsFontSizeToFitWidth = YES;
        
        bloodProduct.text = @"Packed Red Cells";
        regimen.text = @"20 ml/kg over 4 hours";
        
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
            volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:packedCellsTotalVolume]]];
        }
        else 
        {
            volume.text = @"";
        }
        
        [cell addSubview:bloodProduct];
        [cell addSubview:regimen];
        [cell addSubview:volume];
        
        returnCell = cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Platelets";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        UILabel *bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 9.0f, 177.0f, 21.0f)];
        bloodProduct.font = [UIFont boldSystemFontOfSize:17.0f];
        bloodProduct.backgroundColor = [UIColor clearColor];
        bloodProduct.textColor = [UIColor blackColor];
        bloodProduct.adjustsFontSizeToFitWidth = YES;
        
        UILabel *volume = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 9.0f, 80.0f, 21.0f)];
        volume.font = [UIFont boldSystemFontOfSize:17.0f];
        volume.backgroundColor = [UIColor clearColor];
        volume.textAlignment = UITextAlignmentRight;
        
        UILabel *regimen = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 33.0f, 237.0f, 21.0f)];
        regimen.backgroundColor = [UIColor clearColor];
        regimen.font = [UIFont systemFontOfSize:14.0f];
        regimen.textColor = [UIColor lightGrayColor];
        regimen.adjustsFontSizeToFitWidth = YES;
        
        bloodProduct.text = @"Platelets";
        regimen.text = @"10 ml/kg over 20 minutes";
        
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
            volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:plateletsTotalVolume]]];
        }
        else 
        {
            volume.text = @"";
        }
        
        [cell addSubview:bloodProduct];
        [cell addSubview:regimen];
        [cell addSubview:volume];
        
        returnCell = cell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) 
        {
            static NSString *CellIdentifier = @"FFP";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            UILabel *bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 9.0f, 160.0f, 21.0f)];
            bloodProduct.font = [UIFont boldSystemFontOfSize:17.0f];
            bloodProduct.backgroundColor = [UIColor clearColor];
            bloodProduct.textColor = [UIColor blackColor];
            bloodProduct.adjustsFontSizeToFitWidth = YES;
            
            UILabel *volume = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 9.0f, 80.0f, 21.0f)];
            volume.font = [UIFont boldSystemFontOfSize:17.0f];
            volume.backgroundColor = [UIColor clearColor];
            volume.textAlignment = UITextAlignmentRight;
            
            UILabel *regimen = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 33.0f, 237.0f, 21.0f)];
            regimen.backgroundColor = [UIColor clearColor];
            regimen.font = [UIFont systemFontOfSize:14.0f];
            regimen.textColor = [UIColor lightGrayColor];
            regimen.adjustsFontSizeToFitWidth = YES;
            
            bloodProduct.text = @"Fresh Frozen Plasma";
            regimen.text = @"10 ml/kg over 20 minutes";
            
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
                volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:FFPTotalVolume]]];
            }
            else 
            {
                volume.text = @"";
            }
            
            [cell addSubview:bloodProduct];
            [cell addSubview:regimen];
            [cell addSubview:volume];
            
            returnCell = cell;
        }
        else
        {
            static NSString *CellIdentifier = @"Cryoprecipitate";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            UILabel *bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 9.0f, 177.0f, 21.0f)];
            bloodProduct.font = [UIFont boldSystemFontOfSize:17.0f];
            bloodProduct.backgroundColor = [UIColor clearColor];
            bloodProduct.textColor = [UIColor blackColor];
            bloodProduct.adjustsFontSizeToFitWidth = YES;
            
            UILabel *volume = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 9.0f, 80.0f, 21.0f)];
            volume.font = [UIFont boldSystemFontOfSize:17.0f];
            volume.backgroundColor = [UIColor clearColor];
            volume.textAlignment = UITextAlignmentRight;
            
            UILabel *regimen = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 33.0f, 237.0f, 21.0f)];
            regimen.backgroundColor = [UIColor clearColor];
            regimen.font = [UIFont systemFontOfSize:14.0f];
            regimen.textColor = [UIColor lightGrayColor];
            regimen.adjustsFontSizeToFitWidth = YES;
            
            bloodProduct.text = @"Cryoprecipitate";
            regimen.text = @"10 ml/kg over 20 minutes";
            
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
                volume.text = [NSString stringWithFormat:@"%@ ml", [formatter stringFromNumber:[NSNumber numberWithFloat:cryoTotalVolume]]];
            }
            else 
            {
                volume.text = @"";
            }
            
            [cell addSubview:bloodProduct];
            [cell addSubview:regimen];
            [cell addSubview:volume];
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 3) // future feature...
    {
        static NSString *CellIdentifier = @"Immunoglobulin";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        UILabel *bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20, 9, 177, 21)];
        bloodProduct.font = [UIFont boldSystemFontOfSize:17.0];
        bloodProduct.backgroundColor = [UIColor clearColor];
        bloodProduct.textColor = [UIColor blackColor];
        bloodProduct.adjustsFontSizeToFitWidth = YES;
        
        UILabel *volume = [[UILabel alloc] initWithFrame:CGRectMake(220, 9, 80, 21)];
        volume.font = [UIFont boldSystemFontOfSize:17.0];
        volume.backgroundColor = [UIColor clearColor];
        volume.textAlignment = UITextAlignmentRight;
        
        UILabel *regimen = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, 237, 21)];
        regimen.backgroundColor = [UIColor clearColor];
        regimen.font = [UIFont systemFontOfSize:14.0];
        regimen.textColor = [UIColor lightGrayColor];
        regimen.adjustsFontSizeToFitWidth = YES;
        
        bloodProduct.text = @"Immunoglobulin";
        regimen.text = @"";
        
        [cell addSubview:bloodProduct];
        [cell addSubview:regimen];
        [cell addSubview:volume];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == 0 || indexPath.section == 1) 
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 0) 
    {
        BloodTransfusionCriteriaViewController *newViewController = [[BloodTransfusionCriteriaViewController alloc] init];
        [appDelegate.navigationController pushViewController:newViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        PlateletTransfusionCriteriaViewController *newViewController = [[PlateletTransfusionCriteriaViewController alloc] init];
        [appDelegate.navigationController pushViewController:newViewController animated:YES];
    }
}

@end
