//
//  TransportVentilatorViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 13/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "TransportVentilatorViewController.h"
#import "AppDelegate.h"

@interface TransportVentilatorViewController() <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inspiratoryTime;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic) BOOL userHasTypedAVeryFastRateIn;
@property (nonatomic, strong) UILabel *expiratoryTime;
@property (nonatomic) BOOL validParametersEntered;
@property (nonatomic, strong) UITextField *rate;
@property (nonatomic) BOOL resultObtained;

@end

@implementation TransportVentilatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Transport Ventilator";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f))
                                                    style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.scrollEnabled = NO;
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
    
    self.inspiratoryTime.keyboardType = UIKeyboardTypeDecimalPad;
    self.rate.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Transport Ventilator" withError:nil];
    
#endif
    
    [self.inspiratoryTime becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"TransportVentilatorViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"TransportVentilatorViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    self.inspiratoryTime = nil;
    self.expiratoryTime = nil;
    self.rate = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    float fourInchDisplayPadding = 0.0f;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        fourInchDisplayPadding = 40.0f;
    }
    
    height = 40.0f + fourInchDisplayPadding;
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"InspiratoryTime";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            self.inspiratoryTime = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 6.0f, 132.0f, 31.0f)];
            self.inspiratoryTime.borderStyle = UITextBorderStyleRoundedRect;
            self.inspiratoryTime.placeholder = @"seconds";
            self.inspiratoryTime.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.inspiratoryTime.clearButtonMode = UITextFieldViewModeAlways;
            self.inspiratoryTime.delegate = self;
            self.inspiratoryTime.tag = 10;
            self.inspiratoryTime.keyboardType = UIKeyboardTypeDecimalPad;
            self.inspiratoryTime.keyboardAppearance = UIKeyboardAppearanceAlert;
            self.inspiratoryTime.textAlignment = UITextAlignmentLeft;
            
            cell.accessoryView = self.inspiratoryTime;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Inspiratory time:";
            
            returnCell = cell;
        }
        else if(indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"DesiredRate";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            self.rate = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 6.0f, 132.0f, 31.0f)];
            self.rate.borderStyle = UITextBorderStyleRoundedRect;
            self.rate.placeholder = @"per minute";
            self.rate.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            self.rate.clearButtonMode = UITextFieldViewModeAlways;
            self.rate.delegate = self;
            self.rate.tag = 20;
            self.rate.keyboardType = UIKeyboardTypeDecimalPad;
            self.rate.keyboardAppearance = UIKeyboardAppearanceAlert;
            self.rate.textAlignment = UITextAlignmentLeft;
            
            cell.accessoryView = self.rate;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"Desired rate:";
            
            returnCell = cell;
        }
        else if(indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"ExpiratoryTime";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0f];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.expiratoryTime = [[UILabel alloc] initWithFrame:CGRectMake(162.0f, 11.0f, 132.0f, 21.0f)];
            self.expiratoryTime.font = [UIFont boldSystemFontOfSize:17.0f];
            self.expiratoryTime.textColor = [UIColor lightGrayColor];
            self.expiratoryTime.highlightedTextColor = [UIColor whiteColor];
            self.expiratoryTime.textAlignment = UITextAlignmentCenter;
            self.expiratoryTime.text = @"Calculate";
            self.expiratoryTime.backgroundColor = [UIColor clearColor];
            cell.accessoryView = self.expiratoryTime;
            
            cell.textLabel.text = @"Expiratory time:";
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    // only allow user to select the row with 'Calculate'
    if (indexPath.row == 2) 
    {
        path = indexPath;
    }
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // NSLog(@"section = %d", indexPath.section);
    // NSLog(@"row = %d", indexPath.row);
    
    if (self.validParametersEntered) 
    {
        if (self.resultObtained) 
        {
            // clear all
            self.inspiratoryTime.text = @"";
            self.rate.text = @"";
            
            self.expiratoryTime.textColor = [UIColor grayColor];
            self.expiratoryTime.text = @"Calculate";
            
            // reset index
            self.resultObtained = NO;
        }
        else 
        {
            // Calculate Te
            
            // Mean Airway Pressure
            NSString *UKLocaleRate;
            UKLocaleRate = [self.rate.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleRate = [self.rate.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            // Inspired Oxygen
            NSString *UKLocaleInspiratoryTime;
            UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            [self calculateExpiratoryTimefromRate:[UKLocaleRate floatValue] andInspiratoryTime:[UKLocaleInspiratoryTime floatValue]];
        }
    }
    else if (self.resultObtained) 
    {
        // clear all
        self.expiratoryTime.textColor = [UIColor grayColor];
        self.expiratoryTime.text = @"Calculate";
        self.inspiratoryTime.text = @"";
        self.rate.text = @"";
        
        self.resultObtained = NO;
        
        // give focus to Ti textField
        [self.inspiratoryTime becomeFirstResponder];
    }
}

#pragma mark - Textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // reset ExpiratoryTime label if a result is showing
    if (!([self.expiratoryTime.text isEqualToString:@"Calculate"])) 
    {
        self.expiratoryTime.textColor = [UIColor grayColor];
        self.expiratoryTime.text = @"Calculate";
    }
    
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // validate inspiratory time
    if([textField isEqual:self.inspiratoryTime])
    {
        if(newText.length > 4)
        {
            return NO;
        }
        else if(newText.length == 1)
        {
            if([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                self.inspiratoryTime.text = @"0";
            }
            else if ([string floatValue] > 1)
            {
                if ([string floatValue] > 1.4 && [string floatValue] < 2.2) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"You should not be using \nan inspiratory time this high for babies" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    return NO;
                }
                else if ([string floatValue] >= 2.2)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"You should not be using \nan inspiratory time this high" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    return NO;
                }
            }
            else if ([string intValue] == 1)
            {
                if (([self.rate.text intValue])) 
                {
                    // if impossibly high Ti scenario
                    
                    if ([self.rate.text intValue] > 59) 
                    {
                        // too high alert
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"WARNING!" 
                                                  message:@"This is an impossibly high inspiratory time for the rate you have entered" 
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        
                        self.inspiratoryTime.text = @"";
                        
                        return NO;
                    }
                    
                    if ([self.rate.text intValue] > 30) 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"WARNING!" 
                                                  message:@"Reversed ratio" 
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                    
                    self.validParametersEntered = YES;
                    self.expiratoryTime.textColor = [UIColor blackColor];
                }
            }
        }
        else if(newText.length == 2)
        {
            if(!([newText isEqualToString:[NSString stringWithFormat:@"0%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]] || [newText isEqualToString:[NSString stringWithFormat:@"1%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]]))
            {
                return NO;
            }
            else if(self.resultObtained)
            {
                self.resultObtained = NO;
            }
        }
        else if(newText.length == 3)
        {
            // ensure first two characters are "0." or "1," or number localised version
            if(!([[newText substringToIndex:2] isEqualToString:[NSString stringWithFormat:@"0%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]] || [[newText substringToIndex:2] isEqualToString:[NSString stringWithFormat:@"1%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]]))
            {
                return NO;
            }
            // ensure third character is not a decimal
            if([[newText substringFromIndex:2] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            
            
            // warn against very low Ti

            NSString *UKLocaleInspiratoryTime;
            UKLocaleInspiratoryTime = [newText stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleInspiratoryTime = [newText stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float Ti = [UKLocaleInspiratoryTime floatValue];
            NSLog(@"Ti = %f", Ti);
            
            if (Ti >= 0.1 && Ti < 0.2) 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"WARNING!" 
                                          message:@"Very low inspiratory time" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            else if (Ti < 0.1)
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"Inspiratory time too low. \nPlease enter a value equal to, or greater than 0.1 seconds" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                // clear textField
                self.inspiratoryTime.text = @"";
                
                return NO;
            }
            
            // should be ready for calculation if valid rate entered...
            if (([self.rate.text intValue])) 
            {
                // ensure Ti not too high
                
                // Ti
                // float Ti = [newText floatValue]; Conrad change Sunday night
                // NSLog(@"Ti = %f", Ti);
                
                // calculate Te
                float Te = ((60 / [self.rate.text intValue]) - Ti);
                // NSLog(@"Te = %f", Te);
                
                // check that Te is not impossible
                if(Te < 0 || Te == INFINITY || Te == 0)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Inspiratory time is impossibly high" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    self.inspiratoryTime.text = @"";
                    
                    return NO;
                }
                // if Ti is possible, check that there is not an inverse ratio
                else if(Te < Ti) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Reversed ratio" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
                
                // warn against very low Ti
                if (Ti < 0.2 && Ti >= 0.1) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Very low inspiratory time" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else if (Ti < 0.1)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"ERROR!" 
                                              message:@"Inspiratory time too low. \nPlease enter a value equal to, or greater than 0.1 seconds" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    // clear textField
                    self.inspiratoryTime.text = @"";
                    
                    return NO;
                }
                
                self.validParametersEntered = YES;
                self.expiratoryTime.textColor = [UIColor blackColor];
            }
        }
        else if(newText.length == 4)
        {
            if(!([[newText substringToIndex:2] isEqualToString:[NSString stringWithFormat:@"0%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]] || [[newText substringToIndex:2] isEqualToString:[NSString stringWithFormat:@"1%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]]))
            {
                return NO;
            }
            NSRange thirdCharacter = NSMakeRange(3, 0);
            NSLog(@"%@", [newText substringWithRange:thirdCharacter]);
            if([[newText substringWithRange:thirdCharacter] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            NSLog(@"%@", [newText substringFromIndex:3]);
            if([[newText substringFromIndex:3] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
    }
    // validate rate
    else if([textField isEqual:self.rate])
    {
        // check that no decimal places are being used
        if ([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]) 
        {
            return NO;
        }
        
        if (newText.length == 2) 
        {
            // check if value is greater than 60
            if(([newText intValue] > 60) && ([newText intValue] < 81))
            {
                if (self.userHasTypedAVeryFastRateIn) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Rates 60 or below are recommended" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    return NO;
                }
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"BEWARE!" 
                                          message:@"Rates above 60 can lead to dangerously low PaCO2 levels." 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            // check if value is greater than 80
            if([newText intValue] > 80)
            {
                if (self.userHasTypedAVeryFastRateIn) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Rates 60 or below are recommended" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    return NO;
                }
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"WARNING!" 
                                          message:@"Rates above 80 are not recommend." 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.userHasTypedAVeryFastRateIn = YES;
            }
            
            // check if Ti has been entered. i.e. valid rate and Ti
#warning CODE NEEDED
            NSString *UKLocaleInspiratoryTime;
            UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            if ([UKLocaleInspiratoryTime floatValue] > 0)
            {
                // NSLog(@"Calculation READY!!!!!!!!!!!");
                self.expiratoryTime.textColor = [UIColor blackColor];
                
                self.validParametersEntered = YES;
                self.resultObtained = NO;
            }
        }
        
        // check value is not greater than 2 digits
        if(newText.length > 2)
        {
            if ([newText intValue] < 120)
            {
                if (self.userHasTypedAVeryFastRateIn) 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!" 
                                              message:@"Rates 60 or below are recommended" 
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    
                    return NO;
                }
                
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"WARNING!" 
                                          message:@"This really is a very fast rate, what are you trying to do!" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.userHasTypedAVeryFastRateIn = YES;
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!" 
                                          message:@"I assume that you have incorrecly entered that rate.\nRates must be below 120" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.rate.text = @"";
                return NO;
            }
        }
        
        // check that last digit hasn't been deleted
        if([newText isEqualToString:@""]) 
        {
            self.rate.text = @"";
            return NO;
        }
        
        // if inspiratory time has been entered already
        NSString *UKLocaleInspiratoryTime;
        UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleInspiratoryTime = [self.inspiratoryTime.text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
        if ([UKLocaleInspiratoryTime floatValue] > 0.0f)
        {
            // report Ti
            float Ti = [UKLocaleInspiratoryTime floatValue];
            // NSLog(@"Ti = %f", Ti);
            
            // calculate Te
            float Te = ((60 / [newText floatValue]) - Ti);
            // NSLog(@"Te = %f", Te);
            
            // check that Te is not impossible
            if(Te < 0 || Te == INFINITY || Te == 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"WARNING!" 
                                          message:@"Rate is impossibly high" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.rate.text = @"";
                
                return NO;
            }
            // if Te is possible, check that there is not an inverse ratio
            else if(Te < Ti) 
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"WARNING!" 
                                          message:@"Reversed ratio" 
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                /*
                 self.expiratoryTime.textColor = [UIColor blackColor];
                 self.expiratoryTime.text = [NSString stringWithFormat:@"%1.2f sec",Te];
                 
                 self.resultObtained = YES;
                 self.validParametersEntered = NO;
                 
                 return NO;
                 
                 // may need to delete the above 'early result'   YES, trying it without...
                 */
            }
        }
    }
    
    return allowUserToChangeText;
}

- (float)calculateExpiratoryTimefromRate:(float)rate andInspiratoryTime:(float)time
{
    float Te = ((60 / rate) - time);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    // if using arabic locale, force to english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    
    self.expiratoryTime.textColor = [UIColor blackColor];
    
    if(Te == 1)
    {
        self.expiratoryTime.text = [NSString stringWithFormat:@"%@ second", [formatter stringFromNumber:[NSNumber numberWithFloat:Te]]];
    }
    else
    {
        self.expiratoryTime.text = [NSString stringWithFormat:@"%@ seconds", [formatter stringFromNumber:[NSNumber numberWithFloat:Te]]];
    }
    
    self.resultObtained = YES;
    self.validParametersEntered = NO;
    
    return Te;
}

@end
