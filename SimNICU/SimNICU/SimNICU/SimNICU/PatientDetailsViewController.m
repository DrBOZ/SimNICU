//
//  PatientDetailsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PatientDetailsViewController.h"
#import "AppDelegate.h"

@interface PatientDetailsViewController()

@property (nonatomic, strong) KalViewController *calendar;

- (void)showAndSelectToday;

@end

@implementation PatientDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        // Instantiate TableView
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20 - 44)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
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

- (void)viewWillAppear:(BOOL)animated
{
    if([self.userWantsToAddAPatient isEqualToString:@"YES"])
    {
        self.title = @"New Patient";
        
#if GOOGLE_ANALYTICS
        
        [[GANTracker sharedTracker] trackPageview:@"PatientDetails/NewPatient" withError:nil];
        
#endif
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        if (!self.patientToEdit)
        {
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
        
        if (!self.patientToEdit.firstname && !self.patientToEdit.lastname && !self.patientToEdit.gestation && !self.patientToEdit.birthWeight && !self.patientToEdit.workingWeight) 
        {
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
    }
    else
    {
        self.title = @"Edit Patient";
        
#if GOOGLE_ANALYTICS
        
        [[GANTracker sharedTracker] trackPageview:@"PatientDetails/EditPatient" withError:nil];
        
#endif
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        
        if (!self.patientToEdit.firstname && !self.patientToEdit.lastname && !self.patientToEdit.gestation && !self.patientToEdit.birthWeight && !self.patientToEdit.workingWeight) 
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
            
            self.navigationItem.leftBarButtonItem.enabled = NO;
        }
        else 
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.userWantsToAddAPatient = nil;
    self.myNavigationItem = nil;
    self.myTableView = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PatientDetailsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PatientDetailsViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if (section == 0) 
    {
        rows = 4;
    }
    else if(section == 1)
    {
        rows = 1;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float header = 0;
    
    if (section == 1 || section == 2)
    {
        header = 30;
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 1) 
    {
        UIView *headerView;
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
        
        headerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        headerLabel.shadowColor = [UIColor whiteColor];
        headerLabel.shadowOffset = CGSizeMake(0, 1);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = YES;
        headerLabel.font = [UIFont boldSystemFontOfSize:18];
        
        headerLabel.text = @"Working Weight";
        
        [headerView addSubview:headerLabel];
        
        view = headerView;
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    NSString *CellIdentifier;
    
    if (indexPath.section == 0) 
    {
        CellIdentifier = @"Patient Details";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (indexPath.row == 0)     // Name
        {
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];

            }
            
            cell.textLabel.text = @"Name";
            cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            //
            //
            //
            //
            // The following could be improved...
            
            if (self.patientToEdit.lastname || self.patientToEdit.firstname) 
            {
                if (self.patientToEdit.lastname && self.patientToEdit.firstname) 
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.patientToEdit.firstname, self.patientToEdit.lastname];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
                }
                else if (self.patientToEdit.firstname && !self.patientToEdit.lastname) 
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.patientToEdit.firstname];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
                }
                else 
                {
                    self.patientToEdit.firstname = @"Baby";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.patientToEdit.firstname, self.patientToEdit.lastname];
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
                }
            }
            else 
            {
                cell.detailTextLabel.text = @"";
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            returnCell = cell;
        }
        else if(indexPath.row == 1) // Date of Birth
        {
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = @"Date of Birth";
            cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
            
            if (self.patientToEdit.formattedBirthDate)
            {
                cell.detailTextLabel.text = self.patientToEdit.formattedBirthDate;
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 2) // Gestation
        {
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Gestation";
            cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (self.patientToEdit.gestation)
            {
                if (self.patientToEdit.gestation.length > 0) 
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/40", self.patientToEdit.gestation];
                }
                else 
                {
                    self.patientToEdit.gestation = NULL;
                }
            }
            
            returnCell = cell;
        }
        else if(indexPath.row == 3) // Birth weight
        {
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            cell.textLabel.text = @"Birth Weight";
            cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (self.patientToEdit.birthWeight) 
            {
                NSString *UKLocaleBirthWeight;
                UKLocaleBirthWeight = [self.patientToEdit.birthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleBirthWeight = [self.patientToEdit.birthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleBirthWeight floatValue];
                if(weightKGAsFloat < 1)
                {
                    // convert to grams as use integer
                    int weightGRAMSasInt = weightKGAsFloat * 1000;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i grams", weightGRAMSasInt];
                }
                else 
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kg", self.patientToEdit.birthWeight];
                }
            }
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 1)
    {
        CellIdentifier = @"Working Weight";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(indexPath.row == 0)
        {
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
                [cell setBackgroundColor:[UIColor whiteColor]];
            }
            
            if (self.patientToEdit.formattedWorkingWeightDate) 
            {
                // display formatted workingWeightDate
                cell.textLabel.text = self.patientToEdit.formattedWorkingWeightDate;
            }
            
            cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:11];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (self.patientToEdit.workingWeight)
            {
                NSString *UKLocaleWorkingWeight;
                UKLocaleWorkingWeight = [self.patientToEdit.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWorkingWeight = [self.patientToEdit.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleWorkingWeight floatValue];
                if(weightKGAsFloat < 1)
                {
                    // convert to grams as use integer
                    int weightGRAMSasInt = weightKGAsFloat * 1000;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i grams", weightGRAMSasInt];
                }
                else 
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kg", self.patientToEdit.workingWeight];
                }
            }
            else
            {
                cell.textLabel.text = @"Date";
                cell.detailTextLabel.text = @"";
            }
        }
        
        returnCell = cell;
    }
    
    return returnCell;
}

# pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) 
    {
        if (indexPath.row == 0) // Name
        {
            // create PatientDetailsEnterNameViewController and push onto navigationController stack
            PatientDetailsEnterNameViewController *nameController = [[PatientDetailsEnterNameViewController alloc] init];
            
            nameController.patientToEdit = self.patientToEdit;
            
            nameController.delegate = self;
            
            [self.navigationController pushViewController:nameController animated:YES];
        }
        else if (indexPath.row == 1) // Date of Birth
        {
            if (self.patientToEdit.birthDate) 
            {
                self.calendar = [[KalViewController alloc] initWithSelectedDate:self.patientToEdit.birthDate];
            }
            else 
            {
                self.calendar = [[KalViewController alloc] init];
            }
            
            self.calendar.calendarFunction = @"Setting DOB";
            self.calendar.mainDelegate = self;
            
            [self.navigationController pushViewController:self.calendar animated:YES];
        }
        else if (indexPath.row == 2) // Gestation
        {
            PatientDetailsEnterWeightViewController *weightController = [[PatientDetailsEnterWeightViewController alloc] init];
            weightController.patientToEdit = self.patientToEdit;
            weightController.delegate = self;
            
            weightController.textFieldToBecomeFirstResponder = @"Gestation";
            
            [self.navigationController pushViewController:weightController animated:YES];
        }
        else if (indexPath.row == 3) // Birth Weight
        {
            PatientDetailsEnterWeightViewController *weightController = [[PatientDetailsEnterWeightViewController alloc] init];
            weightController.patientToEdit = self.patientToEdit;
            weightController.delegate = self;
            
            weightController.textFieldToBecomeFirstResponder = @"Birth Weight";
            
            [self.navigationController pushViewController:weightController animated:YES];
        }
    }
    else if (indexPath.section == 1) // Working Weight
    {
        PatientDetailsEnterWorkingWeightViewController *workingWeightController = [[PatientDetailsEnterWorkingWeightViewController alloc] init];
        workingWeightController.patientToEdit = self.patientToEdit;
        workingWeightController.delegate = self;
        
        [self.navigationController pushViewController:workingWeightController animated:YES];
    }
}

# pragma mark - PatientDetailsEnterNameViewController delegate

- (void)patientDetailsEnterNameViewController:(PatientDetailsEnterNameViewController *)controller didFinishAddingPatientName:(Patient *)patient
{
    NSLog(@"DidFinishADDINGPatientName");
    
    if ([patient.lastname isEqualToString:@""]) 
    {
        patient.lastname = NULL;
    }
    
    if ([patient.firstname isEqualToString:@""]) 
    {
        patient.firstname = NULL;
    }
    
    if (!(patient.lastname == NULL && patient.firstname == NULL))
    {
        if (!self.patientToEdit) 
        {
            self.patientToEdit = [[Patient alloc] init];
        }
        
        self.patientToEdit.lastname = patient.lastname;
        self.patientToEdit.firstname = patient.firstname;
        
        if (self.patientToEdit.lastname) 
        {
            if (!self.patientToEdit.firstname) 
            {
                self.patientToEdit.firstname = @"Baby";
            }
        }
    }
    
    [self.myTableView reloadData];
}

- (void)patientDetailsEnterNameViewController:(PatientDetailsEnterNameViewController *)controller didFinishEditingPatientName:(Patient *)patient
{    
    NSLog(@"DidFinishEDITINGPatientName");
    
    NSLog(@"patient.lastname = %@", patient.lastname);
    NSLog(@"patient.firstname = %@", patient.firstname);
    
    if ([patient.lastname isEqualToString:@""]) 
    {
        patient.lastname = NULL;
    }
    
    if ([patient.firstname isEqualToString:@""]) 
    {
        patient.firstname = NULL;
    }
    
    NSLog(@"patient.lastname = %@", patient.lastname);
    NSLog(@"patient.firstname = %@", patient.firstname);
    
    
    self.patientToEdit.lastname = patient.lastname;
    self.patientToEdit.firstname = patient.firstname;
    
    if (self.patientToEdit.lastname) 
    {
        if (!self.patientToEdit.firstname) 
        {
            self.patientToEdit.firstname = @"Baby";
        }
    }
    
    [self.myTableView reloadData];
}

# pragma mark - PatientDetailsEnterWeightViewController delegate

- (void)patientDetailsEnterWeightViewController:(PatientDetailsEnterWeightViewController *)controller didFinishAddingPatientBirthWeight:(Patient *)patient
{
    if (patient.gestation.length > 0 || patient.birthWeight.length > 0) 
    {
        // create patientToEdit if it doesn't already exist
        
        if (!self.patientToEdit) 
        {
            NSLog(@"Creating patientToEdit");
            
            self.patientToEdit = [[Patient alloc] init];
            
            self.patientToEdit.firstname = @"";
            self.patientToEdit.lastname = @"";
            
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
        
    }
    else 
    {
        // nothing entered
        
        NSLog(@"Nothing entered");
    }
    
    self.patientToEdit.gestation = patient.gestation;
    self.patientToEdit.birthWeight = patient.birthWeight;
    
    
    // conditions to allow 'done' button to become active. Was set to ensure first and last name set but I think a new user should be able to be created just on gestation or birth weight
     
     
     // if (self.patientToEdit.lastname && self.patientToEdit.firstname) 
     // {
     // self.navigationItem.leftBarButtonItem.enabled = YES;
     // }
     // else 
     // {
     // self.navigationItem.leftBarButtonItem.enabled = NO;
     // }
    
    [self.myTableView reloadData];
}

- (void)patientDetailsEnterWeightViewController:(PatientDetailsEnterWeightViewController *)controller didFinishEditingPatientBirthWeight:(Patient *)patient
{
    NSLog(@"patientDetailsEnterWeightViewController didFinishEditingPatientWeight");
    
    // self.patientToEdit.birthWeight = patient.birthWeight;
    self.patientToEdit.gestation = patient.gestation;
    
    if (self.patientToEdit.lastname && self.patientToEdit.firstname) 
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else 
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self.myTableView reloadData];
}

# pragma mark - PatientDetailsEnterWorkingWeightViewController delegate

- (void)patientDetailsEnterWorkingWeightViewController:(PatientDetailsEnterWorkingWeightViewController *)controller didFinishAddingPatientWorkingWeight:(Patient *)patient measuredOnDate:(NSDate *)date
{
    NSLog(@"PatientDetailsEnterWorkingWeightViewController didFinishAddingPatientWorkingWeight");
    
    self.patientToEdit.workingWeight = patient.workingWeight;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    self.patientToEdit.workingWeightDate = patient.workingWeightDate;
    
    self.patientToEdit.formattedWorkingWeightDate = [formatter stringFromDate:patient.workingWeightDate];
    
    [self.myTableView reloadData];
}

- (void)patientDetailsEnterWorkingWeightViewController:(PatientDetailsEnterWorkingWeightViewController *)controller didFinishEditingPatientWorkingWeight:(Patient *)patient measuredOnDate:(NSDate *)date
{
    NSLog(@" ");
    NSLog(@"PatientDetailsEnterWorkingWeightViewController didFinishEditingPatientWorkingWeight");

    self.patientToEdit.workingWeight = patient.workingWeight;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    self.patientToEdit.workingWeightDate = patient.workingWeightDate;
    
    self.patientToEdit.formattedWorkingWeightDate = [formatter stringFromDate:patient.workingWeightDate];
    
    [self.myTableView reloadData];
}

# pragma mark - KalViewController delegate

- (void)KalViewControllerDelegate:(KalViewController *)controller didFinishSelectingPatientDOB:(Patient *)patient
{
    // NSLog(@"patient.birthDate = %@", patient.birthDate);
    
    // NSLog(@" ");
    // NSLog(@"KalViewController didFinishSelectingPatientDOB");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    self.patientToEdit.birthDate = patient.birthDate;
    
    self.patientToEdit.formattedBirthDate = [formatter stringFromDate:patient.birthDate];
    
    // NSLog(@"Formated birthdate = %@", self.patientToEdit.formattedBirthDate);
    
    [self.myTableView reloadData];
}

# pragma mark

- (void)done
{
    /*
     if(self.patientToEdit == nil)              ALL THIS WAS ALREADY COMMENTED OUT!!!!
     {
     if ([self.surname.text length] > 0) 
     {
     Patient *patient = [[Patient alloc] init];
     patient.lastname = self.patientLastname;
     patient.firstname = self.patientFirstname;
     
     [self.delegate patientDetailsViewController:self didFinishAddingPatient:patient];
     }
     }
     else 
     {
     if([self.surname.text length] > 0)
     {
     self.patientToEdit.lastname = self.patientLastname;
     self.patientToEdit.firstname = self.patientFirstname;
     [self.delegate patientDetailsViewController:self didFinishEditingPatient:self.patientToEdit];
     }
     else 
     {
     // show alert
     UIAlertView *alertView = [[UIAlertView alloc]
     initWithTitle:@"ERROR!" 
     message:@"Patient 'Last Name' must have a value" 
     delegate:nil cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alertView show];
     }
     }
     */
    
    if ([self.patientToEdit.gestation isEqualToString:@""]) 
    {
        self.patientToEdit.gestation = NULL;
    }
    
    
    if ([self.userWantsToAddAPatient isEqualToString:@"YES"]) 
    {
        [self.delegate patientDetailsViewController:self didFinishAddingPatient:self.patientToEdit];
    }
    else
    {
        [self.delegate patientDetailsViewController:self didFinishEditingPatient:self.patientToEdit];
    }
    
}

- (void)cancel
{
    [self.delegate patientDetailsViewControllerDidCancel:self];
}

- (void)showAndSelectToday
{
    [self.calendar showAndSelectDate:[NSDate date]];
}

- (void)didSelectDate:(KalDate *)date
{
    NSLog(@"Date selected");
}

@end
