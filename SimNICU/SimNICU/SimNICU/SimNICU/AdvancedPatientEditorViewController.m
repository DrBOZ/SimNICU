//
//  AdvancedPatientEditorViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AdvancedPatientEditorViewController.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

@interface AdvancedPatientEditorViewController () <UITableViewDataSource, UITableViewDelegate>
{
    int selectedBay;
    int selectedPatientInBay;
}

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSString *workingWeight;

@end

@implementation AdvancedPatientEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedBay = 0;
        selectedPatientInBay = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    // setup toolbar
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousPatient)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextPatient)];
    
    NSArray *items = [NSArray arrayWithObjects:item1, flexibleItem, item2, flexibleItem, item3, nil];
    self.toolbarItems = items;
    
    // self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.toolbar.tintColor = [UIColor grayColor];
    
    // tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64 - 44)) style:UITableViewStylePlain];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    if (section == 0)
    {
        returnString = @"Patient";
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 55.0f;
    
    if (indexPath.section == 0)
    {
        height = 70.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"Patient";
        
        // need a dequeue cell for cell identifier call
        UITableViewCell *cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (UITableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    UITableViewCell *cell;
    
    // this is wrong...
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([CellIdentifier isEqualToString:@"Patient"])
    {
        //displayTextLabel (Patient's name)
        UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 22.0f)];
        displayTextLabel.textColor = [UIColor blackColor];
        displayTextLabel.backgroundColor = [UIColor clearColor];
        displayTextLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        displayTextLabel.adjustsFontSizeToFitWidth = NO;
        displayTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayTextLabel];
        
        UILabel *tempTestLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 22.0f, 300.0f, 22.0f)];
        tempTestLabel.textColor = [UIColor grayColor];
        tempTestLabel.backgroundColor = [UIColor clearColor];
        tempTestLabel.font = [UIFont systemFontOfSize:14.0f];
        tempTestLabel.adjustsFontSizeToFitWidth = NO;
        tempTestLabel.textAlignment = UITextAlignmentLeft;
        tempTestLabel.text = @"day 14 (2 + 0)";
        [cell addSubview:tempTestLabel];
        
        //displayDetailTextLabel (Gestation, birth weight, corrected gestation and working weight)
        UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 44.0f, 300.0f, 22.0f)];
        displayDetailTextLabel.textColor = [UIColor grayColor];
        displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        displayDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayDetailTextLabel.adjustsFontSizeToFitWidth = NO;
        displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayDetailTextLabel];
        
        // display patient's name
        displayTextLabel.text = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
        
        NSString *detailTextLabelText = @"";
        
        NSString *rawBirthWeight = self.selectedPatient.birthWeight;
        NSString *formattedBirthWeight;
        
        NSString *rawWorkingWeight = self.selectedPatient.workingWeight;
        NSString *formattedWorkingWeight;
        
        // format birth weight
        NSString *UKLocaleRawBirthWeight;
        UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
        
        if(birthWeightKGAsFloat < 1.0f)
        {
            // convert to grams as use integer
            int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
            formattedBirthWeight = [NSString stringWithFormat:@"%i g", birthWeightGRAMSasInt];
        }
        else
        {
            formattedBirthWeight = [NSString stringWithFormat:@"%@ kg", rawBirthWeight];
        }
        
        // format working weight
        NSString *UKLocaleRawWorkingWeight;
        UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float workingWeightKGAsFloat = [UKLocaleRawWorkingWeight floatValue];
        
        if(workingWeightKGAsFloat < 1.0f)
        {
            // convert to grams as use integer
            int workingWeightGRAMSasInt = workingWeightKGAsFloat * 1000;
            formattedWorkingWeight = [NSString stringWithFormat:@"%i g", workingWeightGRAMSasInt];
        }
        else
        {
            formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", rawWorkingWeight];
        }
        
        // all information present (missing this stage
        if (self.selectedPatient.gestation && self.selectedPatient.birthWeight && self.selectedPatient.correctedGestation && self.selectedPatient.workingWeight)
        {
            detailTextLabelText = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", self.selectedPatient.gestation, formattedBirthWeight, self.selectedPatient.correctedGestation, formattedWorkingWeight];
            
            self.workingWeight = self.selectedPatient.workingWeight;
        }
        else if (self.selectedPatient.workingWeight && self.selectedPatient.gestation)
        {
            detailTextLabelText = [NSString stringWithFormat:@"%@/40 working weight %@", self.selectedPatient.gestation, formattedWorkingWeight];
            
            self.workingWeight = self.selectedPatient.workingWeight;
        }
        else if (self.selectedPatient.workingWeight && !self.selectedPatient.gestation)
        {
            detailTextLabelText = [NSString stringWithFormat:@"working weight %@", formattedWorkingWeight];
            
            self.workingWeight = self.selectedPatient.workingWeight;
        }
        else if (self.selectedPatient.gestation && !self.selectedPatient.workingWeight)
        {
            // no working weight
            NSLog(@"NO WORKING WEIGHT - ERROR!!!!!!!!!!!!!!!");
        }
        
        displayDetailTextLabel.text = detailTextLabelText;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - methods

- (void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)nextPatient
{
    // int numberOfBays = [self.bayData count];
    int numberOfPatientsInCurrentBay = [[self.bayData[selectedBay] patientsInBay] count];
    
    // check to see if there is another patient in the bay
    if (selectedPatientInBay == (numberOfPatientsInCurrentBay - 1))
    {
        // no, last patient in bay
        
        // increment bay (need to add code if last bay)
        selectedBay += 1;
        
        // reset patient info
        selectedPatientInBay = 0;
        
        self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
        self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
        
        [self.myTableView reloadData];
    }
    else
    {
        // yes, there are more patients in the bay
        selectedPatientInBay += 1;
        
        self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
        self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
        
        [self.myTableView reloadData];
    }
    
    // if not then check if there are any more bays
    // if there is another bay then increment bays
}

- (void)previousPatient
{
    // yes, there are more patients in the bay
    selectedPatientInBay -= 1;
    
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    
    [self.myTableView reloadData];
}

@end
