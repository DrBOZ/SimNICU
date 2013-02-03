//
//  PatientDetailsEnterWeightViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "PatientDetailsEnterWeightViewController.h"
#import "AppDelegate.h"

@interface PatientDetailsEnterWeightViewController ()

@end

@implementation PatientDetailsEnterWeightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Gestation / Weight";
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        [self.myTableView setSeparatorColor:[UIColor grayColor]];
        [self.myTableView setDataSource:self];
        [self.myTableView setRowHeight:50.0f];
        [self.myTableView setBounces:NO];
        
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
        
        [self.view addSubview:self.myTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.myTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PatientDetailsEnterWeightViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PatientDetailsEnterWeightViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"PatientDetails/EnterWeightGestation" withError:nil];
    
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if (self.patientToEdit)
        {
            // ie editing
            
            // validate gestation
            
            
            if (self.gestation.text.length == 3)
            {
                self.gestation.text = [self.gestation.text substringToIndex:2];
            }
            
            self.patientToEdit.gestation = self.gestation.text;
            
            // validate birthweight already done
            
            self.patientToEdit.birthWeight = self.birthWeight.text;
            
            [self.delegate patientDetailsEnterWeightViewController:self didFinishEditingPatientBirthWeight:self.patientToEdit];
        }
        else
        {
            Patient *newPatient = [[Patient alloc] init];
            
            if (self.gestation.text.length == 3)
            {
                self.gestation.text = [self.gestation.text substringToIndex:2];
            }
            newPatient.gestation = self.gestation.text;
            newPatient.birthWeight = self.birthWeight.text;
            
            [self.delegate patientDetailsEnterWeightViewController:self didFinishAddingPatientBirthWeight:newPatient];
        }
    }
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (indexPath.row == 0)
    {
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.gestation = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 180, 30)];
        self.gestation.borderStyle = UITextBorderStyleRoundedRect;
        self.gestation.placeholder = @"weeks";
        self.gestation.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.gestation.adjustsFontSizeToFitWidth = YES;
        self.gestation.returnKeyType = UIReturnKeyNext;
        // not for capitilisation
        self.gestation.textAlignment = UITextAlignmentLeft;
        self.gestation.delegate = self;
        self.gestation.text = self.patientToEdit.gestation;
        self.gestation.autocorrectionType = UITextAutocorrectionTypeNo;
        
        self.gestation.keyboardType = UIKeyboardTypeDecimalPad;
        self.gestation.keyboardAppearance = UIKeyboardAppearanceAlert;
        
        cell.accessoryView = self.gestation;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Gestation";
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        if ([self.textFieldToBecomeFirstResponder isEqualToString:@"Gestation"])
        {
            [self.gestation becomeFirstResponder];
        }
    }
    else if (indexPath.row == 1)
    {
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.birthWeight = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 180, 30)];
        self.birthWeight.borderStyle = UITextBorderStyleRoundedRect;
        self.birthWeight.placeholder = @"kilograms";
        self.birthWeight.clearButtonMode = UITextFieldViewModeAlways;
        self.birthWeight.adjustsFontSizeToFitWidth = YES;
        self.birthWeight.returnKeyType = UIReturnKeyNext;
        self.birthWeight.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.birthWeight.textAlignment = UITextAlignmentLeft;
        self.birthWeight.delegate = self;
        self.birthWeight.text = self.patientToEdit.birthWeight;
        self.birthWeight.autocorrectionType = UITextAutocorrectionTypeNo;
        
        self.birthWeight.keyboardType = UIKeyboardTypeDecimalPad;
        self.birthWeight.keyboardAppearance = UIKeyboardAppearanceAlert;
        
        cell.accessoryView = self.birthWeight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Birth Weight";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        if ([self.textFieldToBecomeFirstResponder isEqualToString:@"Birth Weight"])
        {
            [self.birthWeight becomeFirstResponder];
        }
    }
    
    return cell;
}

#pragma mark - TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserToChangeText = YES;
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.birthWeight])
    {
        if(newText.length > 5)
        {
            allowUserToChangeText = NO;
        }
        if(newText.length == 1)
        {
            if([string isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                self.birthWeight.text = @"0";
            }
            else if ([string intValue] > 1)
            {
                if ([string intValue] > 6)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"WARNING!"
                                              message:@"This is a Neonatal App"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if(newText.length == 2)
        {
            // first character is a "." or ","
            if([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if(![[newText substringWithRange:NSMakeRange(1, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"ERROR!"
                                          message:@"This is a Neonatal App, weight must be less than 10 kg"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
                self.birthWeight.text = @"";
                
                return NO;
            }
        }
        else if(newText.length == 3)
        {
            // first character is a "."
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
        else if(newText.length == 4)
        {
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(3, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
        else if(newText.length == 5)
        {
            if ([[newText substringToIndex:1] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(2, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(3, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
            else if ([[newText substringWithRange:NSMakeRange(4, 1)] isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]])
            {
                return NO;
            }
        }
    }
    else if ([textField isEqual:self.gestation])
    {
        // validating gestation
        if (newText.length > 0)
        {
            // NSLog(@"newText substringToIndex:1 = %@", [newText substringToIndex:1]);
        }
        
        if(newText.length > 4)
        {
            allowUserToChangeText = NO;
        }
        else if(newText.length == 1)
        {
            if([[newText substringToIndex:1] isEqualToString:@"."] || [[newText substringToIndex:1] isEqualToString:@"1"] || [[newText substringToIndex:1] isEqualToString:@"5"]  || [[newText substringToIndex:1] isEqualToString:@"6"] || [[newText substringToIndex:1] isEqualToString:@"7"] || [[newText substringToIndex:1] isEqualToString:@"8"] || [[newText substringToIndex:1] isEqualToString:@"9"] || [[newText substringToIndex:1] isEqualToString:@"0"])
            {
                allowUserToChangeText = NO;
            }
        }
        else if(newText.length == 2)
        {
            // if the first character is not a "2", "3" or "4"
            if([[newText substringToIndex:1] isEqualToString:@"."] || [[newText substringToIndex:1] isEqualToString:@"1"] || [[newText substringToIndex:1] isEqualToString:@"5"]  || [[newText substringToIndex:1] isEqualToString:@"6"] || [[newText substringToIndex:1] isEqualToString:@"7"] || [[newText substringToIndex:1] isEqualToString:@"8"] || [[newText substringToIndex:1] isEqualToString:@"9"] || [[newText substringToIndex:1] isEqualToString:@"0"])
            {
                return NO;
            }
            else if([[newText substringToIndex:1] isEqualToString:@"2"])
            {
                // now excluding "2.", "21", "22", "20"
                if([[newText substringFromIndex:1] isEqualToString:@"."] || [[newText substringFromIndex:1] isEqualToString:@"1"] || [[newText substringFromIndex:1] isEqualToString:@"0"] || [[newText substringFromIndex:1] isEqualToString:@"2"])
                {
                    return NO;
                }
                else if (![string isEqualToString:@""])
                {
                    self.gestation.text = [NSString stringWithFormat:@"%@+",newText];
                    allowUserToChangeText = NO;
                }
            }
            else if([[newText substringFromIndex:1] isEqualToString:@"."])
            {
                return NO;
            }
            else if (![string isEqualToString:@""])
            {
                self.gestation.text = [NSString stringWithFormat:@"%@+",newText];
                allowUserToChangeText = NO;
            }
        }
        else if(newText.length == 3)
        {
            if(![string isEqualToString:@""])
            {
                if ([[newText substringFromIndex:2]isEqualToString:@"."] || [[newText substringFromIndex:2]isEqualToString:@"7"] || [[newText substringFromIndex:2]isEqualToString:@"8"] || [[newText substringFromIndex:2]isEqualToString:@"9"])
                {
                    allowUserToChangeText = NO;
                }
                
                self.gestation.text = [self.gestation.text stringByAppendingString:@"+"];
            }
        }
        else if(newText.length == 4)
        {
            if ([[newText substringFromIndex:3] isEqualToString:@"."] || [[newText substringFromIndex:3] isEqualToString:@"7"] || [[newText substringFromIndex:3] isEqualToString:@"8"] || [[newText substringFromIndex:3] isEqualToString:@"9"])
            {
                allowUserToChangeText = NO;
            }
        }
    }
    
    return allowUserToChangeText;
}

@end
