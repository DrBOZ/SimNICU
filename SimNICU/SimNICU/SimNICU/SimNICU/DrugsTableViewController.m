//
//  DrugsTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugDosePatientTableViewController.h"
#import "DrugInfoSimpleTableViewController.h"
#import "DrugsTableViewController.h"
#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "DrugSection.h"
#import "AppDelegate.h"
#import "Drug.h"

@interface DrugsTableViewController ()
{
    int numberOfSectionsInTableView;
    
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong) DrugCategory *drugCategory;
@property (nonatomic, strong) NSMutableArray *drugSections;

@end

@implementation DrugsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Drugs"];
    
    //back button
    self.navigationItem.backBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:nil action:nil];
    
    // searchBar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = NSLocalizedString(@"Search", nil);
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.delegate = self;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
    
    searchData = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.workingWeight)
    {
        // goes through the entire string and replaces any commas with full stops in case
        // user is using a european locale
        NSString *UKLocaleWorkingWeight;
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            // present weight as grams
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
        // self.title = self.drugCategory.name;
    }
    
    // workout UITableView values here
    
    // self.drugCategory.drugs is the array
    self.drugCategory = [appDelegate.drugDatabase.drugCategories objectAtIndex:[self.index integerValue]];
    
    // self.drugSections will be populated
    self.drugSections = [[NSMutableArray alloc] initWithCapacity:20];
    
    // Cycle through all of the drugs in the category
    Drug *drug;
    NSString *firstLetterOfDrug;
    DrugSection *drugSection;
    BOOL drugSectionExists = NO;
    
    for(drug in self.drugCategory.drugs)
    {
        // Look at the first letter of the drug
        firstLetterOfDrug = [drug.name substringToIndex:1];
        
        // Cycle through the self.drugSections array
        for (drugSection in self.drugSections)
        {
            //  Check if the first letter of the drug is already in the array
            if ([drugSection.letter isEqualToString:firstLetterOfDrug])
            {
                drugSectionExists = YES;
                
                // If yes, then add the drug to the drugSection.drug array
                [drugSection.drugs addObject:drug];
            }
        }
        
        // If not then create a new drugSection adding the letter to the drugSection.letter
        if (!drugSectionExists)
        {
            DrugSection *newDrugSection = [[DrugSection alloc] init];
            newDrugSection.letter = firstLetterOfDrug;
            
            NSMutableArray *newDrugArray = [[NSMutableArray alloc] initWithCapacity:5];
            [newDrugArray addObject:drug];
            
            newDrugSection.drugs = newDrugArray;
            
            // and add the drug to the drugSection.drug array
            [self.drugSections addObject:newDrugSection];
            
            // reset flag
            drugSectionExists = NO;
        }
        else
        {
            // reset flag
            drugSectionExists = NO;
        }
    }
    
    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
    
    [self.tableView reloadData];
    
    // scroll to last drug selected
    if (appDelegate.lastDrugPath)
    {
        [self.tableView scrollToRowAtIndexPath:appDelegate.lastDrugPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 1;
    
    if (tableView == self.tableView)
    {
        sections = [self.drugSections count];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;;
    
    if (tableView == self.tableView)
    {
        DrugSection *drugSectionToCount = [self.drugSections objectAtIndex:section];
        rows = [drugSectionToCount.drugs count];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        rows = [searchData count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 0.0f;
    
    if (tableView == self.tableView)
    {
        height = 22.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (tableView == self.tableView)
    {
        DrugSection *drugSection = [self.drugSections objectAtIndex:section];
        
        header = drugSection.letter;
    }
    
    return header;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *tempArray = NULL;
    
    if (tableView == self.tableView)
    {
        tempArray = [[NSMutableArray alloc] init];
        
        [tempArray addObject:UITableViewIndexSearch];
        
        DrugSection *drugSection;
        
        for (drugSection in self.drugSections)
        {
            [tempArray addObject:drugSection.letter];
        }
    }
    
    return tempArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Drug Categories";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Drug *drug;
    
    if (tableView == self.tableView)
    {
        DrugSection *drugSection = [self.drugSections objectAtIndex:indexPath.section];
        
        drug = [drugSection.drugs objectAtIndex:indexPath.row];
        cell.textLabel.text = drug.name;
    }
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        drug = [searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = drug.name;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // save this drug as last drug selected
    appDelegate.lastDrugPath = indexPath;
    
    NSString *selectedDrug;
    
    // set selected row and get drug, set drug name
    if (tableView == self.tableView)
    {
        DrugSection *drugSection = [self.drugSections objectAtIndex:indexPath.section];
        Drug *drug = [drugSection.drugs objectAtIndex:indexPath.row];
        
        selectedDrug = drug.name;
        NSLog(@"Drug selected = %@", drug.name);
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Drug *drug = [searchData objectAtIndex:indexPath.row];
        
        selectedDrug = drug.name;
        NSLog(@"Drug selected = %@", drug.name);
    }
    
    // load appropriate Drug view Controller
    
    if (self.selectedPatient)
    {
        // push the drug information for the specific patient
        DrugDosePatientTableViewController *vc = [[DrugDosePatientTableViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.selectedDrug = selectedDrug;
        vc.selectedPatient = self.selectedPatient;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.workingWeight)
    {
        // push DrugDoseWeightViewController
    }
    else
    {
        // push the basic drug information
        DrugInfoSimpleTableViewController *vc = [[DrugInfoSimpleTableViewController alloc] initWithStyle:UITableViewStylePlain];
        vc.selectedDrug = selectedDrug;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    int i = 0;
    
    if (tableView == self.tableView)
    {
        if (index == 0)
        {
            [self.tableView setContentOffset:CGPointZero animated:NO];
            return NSNotFound;
        }
        else
        {
            // return index - 1; // due magnifying glass icon
            i = index - 1;
        }
    }
    
    return i;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    
    Drug *drug;
    
    for(drug in self.drugCategory.drugs)
    {
        NSRange range = [drug.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        if (range.length > 0)
        {
            [searchData addObject:drug];
            NSLog(@"%@", drug.name);
        }
    }
    
    return YES;
}


@end
