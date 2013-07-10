//
//  DrugsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 08/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugInfoSimpleViewController.h"
#import "DrugsViewController.h"
#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "DrugSection.h"
#import "AppDelegate.h"
#import "Drug.h"

#import "DrugBenzylpenicillinViewController.h"

@interface DrugsViewController ()
{
    int numberOfSectionsInTableView;
    
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong) DrugCategory *drugCategory;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *drugSections;

@end

@implementation DrugsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:nil
                                                                      action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
        //tableView
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - (20 + 44))) style:UITableViewStylePlain];
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.sectionFooterHeight = 0.0f;
        self.myTableView.sectionHeaderHeight = 0.0f;
        self.myTableView.backgroundColor = [UIColor whiteColor];
        self.myTableView.separatorColor = [UIColor grayColor];
        [self.view addSubview:self.myTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = @"Search";
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.delegate = self;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.myTableView.tableHeaderView = searchBar;
    
    searchData = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
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
        // Drug *drugToAdd = [[Drug alloc] init];
        // drugToAdd = drug;
        
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
    
    self.myTableView.contentOffset = CGPointMake(0.0f, 44.0f);
    
    [self.myTableView reloadData];
    
    // scroll to last drug selected
    if (appDelegate.lastDrugPath)
    {
        [self.myTableView scrollToRowAtIndexPath:appDelegate.lastDrugPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
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
    
    if (tableView == self.myTableView)
    {
        sections = [self.drugSections count];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;;
    
    if (tableView == self.myTableView)
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
    
    if (tableView == self.myTableView)
    {
        height = 22.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (tableView == self.myTableView)
    {
        DrugSection *drugSection = [self.drugSections objectAtIndex:section];
        
        header = drugSection.letter;
    }
    
    return header;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *tempArray = NULL;
    
    if (tableView == self.myTableView)
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Drug *drug;
    
    if (tableView == self.myTableView)
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
    
    if (drug.selected)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
    
    // select drug
    if (tableView == self.myTableView)
    {
        DrugSection *drugSection = [self.drugSections objectAtIndex:indexPath.section];
        Drug *drug = [drugSection.drugs objectAtIndex:indexPath.row];
        // drug.selected = !drug.selected;
        // [self.myTableView reloadData];
        
        selectedDrug = drug.name;
        NSLog(@"Drug selected = %@", drug.name);
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        Drug *drug = [searchData objectAtIndex:indexPath.row];
        // drug.selected = !drug.selected;
        // [self.searchDisplayController.searchResultsTableView reloadData];
        selectedDrug = drug.name;
        NSLog(@"Drug selected = %@", drug.name);
    }
    
    if ([selectedDrug isEqualToString:@"Benzylpenicillin"])
    {
        // DrugInfoSimpleViewController *drugInfoSimpleViewController = [[DrugInfoSimpleViewController alloc] init];
        
        DrugBenzylpenicillinViewController *drugBenzylpenicillinViewController = [[DrugBenzylpenicillinViewController alloc] init];
        
        [self.navigationController pushViewController:drugBenzylpenicillinViewController animated:YES];
    }
    /*
     DrugsViewController_iPhone *drugsViewController = [[DrugsViewController_iPhone alloc] init];
     drugsViewController.index = [NSNumber numberWithInt:indexPath.row];
     
     [self.navigationController pushViewController:drugsViewController animated:YES];
     */
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    int i = 0;
    
    if (tableView == self.myTableView)
    {
        if (index == 0)
        {
            [self.myTableView setContentOffset:CGPointZero animated:NO];
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
