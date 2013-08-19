//
//  PatientDetailsEnterWorkingWeightViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 28/07/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PatientDetailsEnterWorkingWeightViewController.h"
#import "KalViewController.h"
#import "Patient.h"
#import "AppDelegate.h"

@interface PatientDetailsEnterWorkingWeightViewController ()

@property (nonatomic, strong) KalViewController *calendar;
@property (nonatomic, strong) NSString *formattedWorkingWeightDate;

@end

@implementation PatientDetailsEnterWorkingWeightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Working Weight";
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.bounces = NO;
        
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
    
    if (!self.patientToEdit)
    {
        NSLog(@" ");
        NSLog(@"self.patientToEdit = nil");
        NSLog(@"self.workingWeightDate = [NSDate date]");
        
        self.workingWeightDate = [NSDate date];
    }
    else
    {
        NSLog(@" ");
        NSLog(@"self.patientToEdit exists");
        NSLog(@"self.workingWeightDate = self.patientToEdit.workingWeightdate");
        self.workingWeightDate = self.patientToEdit.workingWeightDate;
    }
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PatientDetailsEnterWorkingWeightViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PatientDetailsEnterWorkingWeightViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"PatientDetails/EnterWorkingWeight" withError:nil];
    
#endif
    
    [Flurry logEvent:@"PatientDetailsEnterWorkingWeight: viewDidAppear"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        if (self.patientToEdit)
        {
            if ([self.workingWeight.text length] > 0)
            {
                NSLog(@"Editing");
                
                self.patientToEdit.workingWeight = self.workingWeight.text;
                // self.patientToEdit.workingWeightDate = self.workingWeightDate;
                
                [self.delegate patientDetailsEnterWorkingWeightViewController:self didFinishEditingPatientWorkingWeight:self.patientToEdit measuredOnDate:self.workingWeightDate];
            }
        }
        else
        {
            if ([self.workingWeight.text length] > 0)
            {
                NSLog(@"Adding");
                
                Patient *newPatient = [[Patient alloc] init];
                
                newPatient.workingWeight = self.workingWeight.text;
                newPatient.workingWeightDate = self.workingWeightDate;
                
                [self.delegate patientDetailsEnterWorkingWeightViewController:self didFinishAddingPatientWorkingWeight:newPatient measuredOnDate:self.workingWeightDate];
            }
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
        
        cell.textLabel.text = @"Date";
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        self.formattedWorkingWeightDate = [formatter stringFromDate:self.workingWeightDate];
        
        cell.detailTextLabel.text = self.formattedWorkingWeightDate;
        
    }
    else if (indexPath.row == 1) // working weight textField
    {
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        
        self.workingWeight = [[UITextField alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 180.0f, 30.0f)];
        self.workingWeight.borderStyle = UITextBorderStyleRoundedRect;
        self.workingWeight.placeholder = @"kilograms";
        self.workingWeight.clearButtonMode = UITextFieldViewModeAlways;
        self.workingWeight.adjustsFontSizeToFitWidth = YES;
        self.workingWeight.returnKeyType = UIReturnKeyNext;
        self.workingWeight.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        self.workingWeight.textAlignment = UITextAlignmentLeft;
        self.workingWeight.delegate = self;
        self.workingWeight.text = self.patientToEdit.workingWeight;
        self.workingWeight.autocorrectionType = UITextAutocorrectionTypeNo;
        
        self.workingWeight.keyboardType = UIKeyboardTypeDecimalPad;
        self.workingWeight.keyboardAppearance = UIKeyboardAppearanceAlert;
        
        cell.accessoryView = self.workingWeight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"W. Weight";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        [self.workingWeight becomeFirstResponder];
    }
    
    return cell;
}

# pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        self.calendar = [[KalViewController alloc] initWithSelectedDate:self.workingWeightDate];
        
        self.calendar.calendarFunction = @"Setting WorkingWeightDate";
        self.calendar.mainDelegate = self;
        
        [self.navigationController pushViewController:self.calendar animated:YES];
    }
}

# pragma mark - KalViewController main delegate

- (void)KalViewControllerDelegate:(KalViewController *)controller didFinishSelectingPatientDOB:(Patient *)patient
{
    NSLog(@"in KalViewController main delegate = PatientDetailsEnterWorkingWeightViewController");
    
    self.patientToEdit.workingWeightDate = patient.workingWeightDate;
    self.workingWeightDate = patient.workingWeightDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    self.patientToEdit.formattedWorkingWeightDate = [formatter stringFromDate:patient.workingWeightDate];
    self.formattedWorkingWeightDate = self.patientToEdit.formattedWorkingWeightDate;
    
    NSLog(@"Formated date = %@", self.patientToEdit.formattedWorkingWeightDate);
    
    [self.myTableView reloadData];
}

@end

