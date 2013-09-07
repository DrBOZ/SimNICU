//
//  PostnatalWardTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PostnatalWardTableViewController.h"
#import "PostnatalWardSection.h"

@interface PostnatalWardTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *postnatalWardSections;

@end

@implementation PostnatalWardTableViewController
{
    NSMutableArray *problems;
    
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        [self createProblemList];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Postnatal Ward"];
    
    self.title = @"Postnatal Ward";
    
    //tableView
    self.tableView.rowHeight = 50.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 0.0f;
    self.tableView.sectionHeaderHeight = 0.0f;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor grayColor];
    
    // searchBar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = @"Search";
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.delegate = self;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    self.tableView.tableHeaderView = searchBar;
    
    searchData = [[NSMutableArray alloc] init];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    // populate self.postnatalWardSections
    self.postnatalWardSections = [[NSMutableArray alloc] initWithCapacity:20];
    
    // Cycle through all of the problems
    NSString *problem;
    NSString *firstLetterOfProblem;
    PostnatalWardSection *postnatalWardSection;
    BOOL postnatalWardSectionExists = NO;
    
    for (problem in problems)
    {
        // Look at the first letter of the problem
        firstLetterOfProblem = [problem substringToIndex:1];
        
        // Cycle through the self.postnatalWardSections array
        for (postnatalWardSection in self.postnatalWardSections)
        {
            //  Check if the first letter of the problem is already in the array
            if ([postnatalWardSection.letter isEqualToString:firstLetterOfProblem])
            {
                postnatalWardSectionExists = YES;
                
                // If yes, then add the drug to the drugSection.drug array
                [postnatalWardSection.problems addObject:problem];
            }
        }
        
        // If not then create a new postnatalWardSection adding the letter to the postnatalWardSection.letter
        if (!postnatalWardSectionExists)
        {
            PostnatalWardSection *newPostnatalWardSection = [[PostnatalWardSection alloc] init];
            newPostnatalWardSection.letter = firstLetterOfProblem;
            
            NSMutableArray *newPostnatalWardProblemArray = [[NSMutableArray alloc] initWithCapacity:5];
            [newPostnatalWardProblemArray addObject:problem];
            
            newPostnatalWardSection.problems = newPostnatalWardProblemArray;
            
            [self.postnatalWardSections addObject:newPostnatalWardSection];
            
            // reset flag
            postnatalWardSectionExists = NO;
        }
        else
        {
            // reset flag
            postnatalWardSectionExists = NO;
        }
        
        /*
        // scroll to last problem selected
        if (appDelegate.lastDrugPath)
        {
            [self.myTableView scrollToRowAtIndexPath:appDelegate.lastDrugPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
         */
    }
    
    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections = 1;
    
    if (tableView == self.tableView)
    {
        sections = [self.postnatalWardSections count];
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;;
    
    if (tableView == self.tableView)
    {
        PostnatalWardSection *postnatalWardSectionToCount = [self.postnatalWardSections objectAtIndex:section];
        rows = [postnatalWardSectionToCount.problems count];
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
        PostnatalWardSection *postnatalWardSection = [self.postnatalWardSections objectAtIndex:section];
        
        header = postnatalWardSection.letter;
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
        
        PostnatalWardSection *postnatalWardSection;
        
        for (postnatalWardSection in self.postnatalWardSections)
        {
            [tempArray addObject:postnatalWardSection.letter];
        }
    }
    
    return tempArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    // Drug *drug;
    NSString *problem;
    
    if (tableView == self.tableView)
    {
        PostnatalWardSection *postnatalWardSection = [self.postnatalWardSections objectAtIndex:indexPath.section];
        
        problem = [postnatalWardSection.problems objectAtIndex:indexPath.row];
        cell.textLabel.text = problem;
    }
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        //drug = [searchData objectAtIndex:indexPath.row];
        problem = [searchData objectAtIndex:indexPath.row];
        
        // cell.textLabel.text = drug.name;
        cell.textLabel.text = problem;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    NSString *problem;
    
    for(problem in problems)
    {
        NSRange range = [problem rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        if (range.length > 0)
        {
            [searchData addObject:problem];
        }
    }
    
    return YES;
}

- (void)createProblemList
{
    problems = [[NSMutableArray alloc] initWithCapacity:50];
    
    NSString *problem;
    
    // populate array of problems, in alphabetical order
    problem = @"Anorectal Malformations";
    [problems addObject:problem];
    
    problem = @"Ambiguous Genitalia";
    [problems addObject:problem];
    
    problem = @"BCG Vaccination";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Blood in the Nappy", nil);
    [problems addObject:problem];
    
    problem = @"Brachial Nerve Palsies";
    [problems addObject:problem];
    
    problem = @"Breast Swelling / Mastitis";
    [problems addObject:problem];
    
    problem = @"Breast Feeding";
    [problems addObject:problem];
    
    problem = @"Cardiac Arrhythmia";
    [problems addObject:problem];
    
    problem = @"Cleft Lip & Palate";
    [problems addObject:problem];
    
    problem = @"Cyanosis";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Down's Syndrome", nil);
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Edward's Syndrome", nil);
    [problems addObject:problem];
    
    problem = @"Fever";
    [problems addObject:problem];
    
    problem = @"Group B Strep (Maternal)";
    [problems addObject:problem];
    
    problem = @"Grunting";
    [problems addObject:problem];
    
    problem = @"Heart Murmurs";
    [problems addObject:problem];
    
    problem = @"Hepatitis B";
    [problems addObject:problem];
    
    problem = @"Hip Problems";
    [problems addObject:problem];
    
    problem = @"Hydronephrosis";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Hypoglycaemia", nil);
    [problems addObject:problem];
    
    problem = @"Hypospadias";
    [problems addObject:problem];
    
    problem = @"Hypothermia";
    [problems addObject:problem];
    
    problem = @"Hypotonia";
    [problems addObject:problem];
    
    problem = @"Irritability";
    [problems addObject:problem];
    
    problem = @"Jaundice";
    [problems addObject:problem];
    
    problem = @"Jittery";
    [problems addObject:problem];
    
    problem = @"Limb Abnormalities";
    [problems addObject:problem];
    
    problem = @"Natal Teeth";
    [problems addObject:problem];
    
    problem = @"Noisy Breathing";
    [problems addObject:problem];
    
    problem = @"Offensive Liquor";
    [problems addObject:problem];
    
    problem = @"Opiate Withdrawl";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Patau's Syndrome", nil);
    [problems addObject:problem];
    
    problem = @"Polydactyly";
    [problems addObject:problem];
    
    problem = @"Polyhydraminios";
    [problems addObject:problem];
    
    problem = @"Preauricular Skin Tags";
    [problems addObject:problem];
    
    problem = @"Prolonged Rupture of Membranes (PROM)";
    [problems addObject:problem];
    
    problem = @"Rashes";
    [problems addObject:problem];
    
    problem = @"Red Reflexes";
    [problems addObject:problem];
    
    problem = @"Sacral Dimple";
    [problems addObject:problem];
    
    problem = @"Scalp Swelling";
    [problems addObject:problem];
    
    problem = @"Single Palmar Crease";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Sticky Eyes", nil);
    [problems addObject:problem];
    
    problem = @"Sticky Umbilicus";
    [problems addObject:problem];
    
    problem = NSLocalizedString(@"Tachypnoea", nil);
    [problems addObject:problem];
    
    problem = @"Talipes";
    [problems addObject:problem];
    
    problem = @"Testicular Swelling";
    [problems addObject:problem];
    
    problem = @"Thrombocytopenia";
    [problems addObject:problem];
    
    problem = @"Thyroid Disease (Maternal)";
    [problems addObject:problem];
    
    problem = @"Tongue Tie";
    [problems addObject:problem];
    
    problem = @"Two Vessels in Cord";
    [problems addObject:problem];
    
    problem = @"Undescended Testes";
    [problems addObject:problem];
    
    problem = @"Vitamin K";
    [problems addObject:problem];
    
    problem = @"Vomiting";
    [problems addObject:problem];
    
    problem = @"Weight Loss";
    [problems addObject:problem];
}

@end
