//
//  DrugDosePatientTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugDosePatientTableViewController.h"
#import "DrugDosePatientTableViewCell.h"
#import "DrugInfoSimpleTableViewController.h"
#import "DrugRouteOfAdministration.h"
#import "DrugDoseTableViewCell.h"
#import "DrugIndication.h"
#import "CBTimeMethods.h"
#import "DrugCategory.h"
#import "AppDelegate.h"
#import "Drug.h"

@interface DrugDosePatientTableViewController ()

@property (nonatomic, strong) NSString *workingWeight;
@property (nonatomic, strong) Drug *drug;

@end

@implementation DrugDosePatientTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.selectedDrug;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //back button
    self.navigationItem.backBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:nil action:nil];
    
    // cycle through drug database and find current drugCategory
    DrugCategory *drugCategory;
    
    for (drugCategory in appDelegate.drugDatabase.drugCategories)
    {
        if ([drugCategory.name isEqualToString:@"Drugs"]) // will have to substitue this later
        {
            Drug *drug;
            
            // find selected drug
            for(drug in drugCategory.drugs)
            {
                if ([drug.name isEqualToString:self.selectedDrug])
                {
                    self.drug = drug;
                }
            }
        }
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
    int sections = nil;
    
    sections = 2 + [self.drug.dosingDetails count]; // can simplify this later
    
    return sections;
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
    else if (section == ([self.drug.dosingDetails count] +1))
    {
        returnString = @"";
    }
    else
    {
        returnString = [self.drug.dosingDetails[section - 1] indicationDescription];
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    if (section == ([self.drug.dosingDetails count] +1))
    {
        height = 0.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 55.0f;
    
    if (!(indexPath.section == 0 || indexPath.section == ([self.drug.dosingDetails count] +1)))
    {
        height = [[self.drug.dosingDetails[indexPath.section -1] heightForRow] floatValue];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"Patient";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
        
        returnCell = cell;
    }
    else if (indexPath.section == ([self.drug.dosingDetails count] + 1))
    {
        NSString *CellIdentifier = @"Drug Info";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = @"Drug Information";
        
        returnCell = cell;
    }
    else
    {
        NSString *CellIdentifier = [self.drug.dosingDetails[indexPath.section - 1] indicationDescription];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (UITableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([CellIdentifier isEqualToString:@"Patient"])
    {
        //displayTextLabel (Patient's name)
        UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 210.0f, 30.0f)];
        displayTextLabel.textColor = [UIColor blackColor];
        displayTextLabel.backgroundColor = [UIColor clearColor];
        displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        displayTextLabel.adjustsFontSizeToFitWidth = YES;
        displayTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayTextLabel];
        
        //displayDetailTextLabel (Gestation, birth weight, corrected gestation and working weight)
        UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 21.0f, 227.0f, 30.0f)];
        displayDetailTextLabel.textColor = [UIColor blackColor];
        displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        displayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
        displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
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
    else
    {
        DrugIndication *drugIndication;
        
        for (drugIndication in self.drug.dosingDetails)
        {
            if ([drugIndication.indicationDescription isEqualToString:CellIdentifier])
            {
                // identified correct drugIndication
                DrugRouteOfAdministration *drugRouteOfAdministration;
                
                float y = 10.0f;
                
                for (drugRouteOfAdministration in drugIndication.routesOfAdministration)
                {
                    
                    
                    //displayTextLabel (Patient's name)
                    UILabel *routeDescription = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, y, 300.0f, 60.0f)];
                    routeDescription.textColor = [UIColor blackColor];
                    routeDescription.backgroundColor = [UIColor clearColor];
                    routeDescription.font = [UIFont boldSystemFontOfSize:16.0f];
                    routeDescription.adjustsFontSizeToFitWidth = NO;
                    routeDescription.textAlignment = UITextAlignmentLeft;
                    routeDescription.numberOfLines = 2;
                    routeDescription.text = drugRouteOfAdministration.routeDescription;
                    [routeDescription sizeToFit];
                    [cell addSubview:routeDescription];
                    
                    y = y + 100.0f;
                    
                    // check if drug is gestation dependent
                    // if so then check against current corrected gestation
                    
                    // next check if drug is age dependent
                    // if so then check against current age
                    
                    // calculate rough dose
                    // intelligently round dose
                    
                    // set text
                    
                    /*
                     UILabel *testLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 50.0f, 210.0f, 30.0f)];
                     testLabel2.textColor = [UIColor blackColor];
                     testLabel2.backgroundColor = [UIColor clearColor];
                     testLabel2.font = [UIFont boldSystemFontOfSize:20.0f];
                     testLabel2.adjustsFontSizeToFitWidth = YES;
                     testLabel2.textAlignment = UITextAlignmentLeft;
                     testLabel2.text = @"= 4mg/kg <32 weeks gestation";
                     [cell addSubview:testLabel2];
                     */
                }
            }
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    if (indexPath.section == ([self.drug.dosingDetails count] +1))
    {
        path = indexPath;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == ([self.drug.dosingDetails count] +1))
    {
        DrugInfoSimpleTableViewController *vc = [[DrugInfoSimpleTableViewController alloc] init];
        vc.selectedDrug = self.selectedDrug;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
