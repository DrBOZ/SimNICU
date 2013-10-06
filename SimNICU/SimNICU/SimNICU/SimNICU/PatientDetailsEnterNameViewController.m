//
//  PatientDetailsEnterNameViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 26/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PatientDetailsEnterNameViewController.h"
#import "AppDelegate.h"

@interface PatientDetailsEnterNameViewController ()

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation PatientDetailsEnterNameViewController

@synthesize patientToEdit = _patientToEdit;
@synthesize myTableView = _myTableView;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Name";
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
        }
        else
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        }
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.bounces = NO;
        self.myTableView.dataSource = self;
        self.myTableView.separatorColor = [UIColor grayColor];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        }
        else
        {
            // set background colour
            [CBDisplayMethods setSecondaryBackgroundForTableView:self.myTableView];
            
            /*
            if (appDelegate.window.bounds.size.height == 568.0f)
            {
                // 4 inch Retina
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
                [tempImageView setFrame:self.myTableView.frame];
                
                self.myTableView.backgroundView = tempImageView;
            }
            else
            {
                // 3.5 inch Retina
                UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SECONDARY_BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
                [tempImageView setFrame:self.myTableView.frame];
                
                self.myTableView.backgroundView = tempImageView;
            }
             */
        }
        
        [self.view addSubview:self.myTableView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.patientToEdit.lastname isEqualToString:@"BABY"])
    {
        self.patientToEdit.lastname = @"";
        self.patientToEdit.firstname = @"";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"PatientDetails/EnterName" withError:nil];
    
#endif
    
    [Flurry logEvent:@"PatientDetailsEnterName viewDidAppear"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.myTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PatientDetailsEnterNameViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PatientDetailsEnterNameViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) 
    {
        if (self.patientToEdit)
        {
            self.patientToEdit.lastname = self.lastname.text;
            self.patientToEdit.firstname = self.firstname.text;
            
            [self.delegate patientDetailsEnterNameViewController:self didFinishEditingPatientName:self.patientToEdit];
        }
        else 
        {
            Patient *newPatientName = [[Patient alloc] init];
            newPatientName.lastname = self.lastname.text;
            newPatientName.firstname = self.firstname.text;
            
            [self.delegate patientDetailsEnterNameViewController:self didFinishAddingPatientName:newPatientName];
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
        
        self.lastname = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 180, 30)];
        self.lastname.borderStyle = UITextBorderStyleRoundedRect;
        self.lastname.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.lastname.adjustsFontSizeToFitWidth = YES;
        self.lastname.returnKeyType = UIReturnKeyNext;
        self.lastname.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.lastname.textAlignment = UITextAlignmentLeft;
        self.lastname.delegate = self;
        self.lastname.text = self.patientToEdit.lastname;
        self.lastname.autocorrectionType = UITextAutocorrectionTypeNo;
        self.lastname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        cell.accessoryView = self.lastname;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = NSLocalizedString(@"Surname", nil);
        // cell.textLabel.font = ...
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        [self.lastname becomeFirstResponder];
    }
    else if (indexPath.row == 1)
    {
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.firstname = [[UITextField alloc] initWithFrame:CGRectMake(1.0, 1.0, 180, 30)];
        self.firstname.borderStyle = UITextBorderStyleRoundedRect;
        self.firstname.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.firstname.adjustsFontSizeToFitWidth = YES;
        self.firstname.returnKeyType = UIReturnKeyNext;
        // not for capitilisation
        self.firstname.textAlignment = UITextAlignmentLeft;
        self.firstname.delegate = self;
        self.firstname.text = self.patientToEdit.firstname;
        self.firstname.autocorrectionType = UITextAutocorrectionTypeNo;
        self.firstname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        cell.accessoryView = self.firstname;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = NSLocalizedString(@"Forename", nil);
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    }
    
    return cell;
}


# pragma mark - Text view delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // if ([textField isEqual:self.lastname])
    if (textField == self.lastname)
    {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([newText length] > 0) 
        {
            self.firstname.returnKeyType = UIReturnKeyDone;
        }
        else 
        {
            // self.firstname.returnKeyType = UIReturnKeyNext;
            self.firstname.returnKeyType = UIReturnKeyDefault;
        }
    }
    else if (textField == self.firstname)
    {
        if ([self.lastname.text length] > 0) 
        {
            self.firstname.returnKeyType = UIReturnKeyDone;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    
    if (textField == self.lastname) 
    {
        NSLog(@"Lastname return");
        
        [self.firstname becomeFirstResponder];
    }
    else
    {
        NSLog(@"Firstname return");
        
        // [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        // [self dismissViewControllerAnimated:YES completion:NULL];
        [self.navigationController popViewControllerAnimated:YES];
        // [self resignFirstResponder];
        // [textField resignFirstResponder];
    }
    
    return NO;
}

@end
