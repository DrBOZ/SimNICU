//
//  PostnatalWardTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PostnatalWardTableViewController.h"
#import "PostnatalWardSection.h"
#import "PostnatalWardModel.h"

@interface PostnatalWardTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *postnatalWardSections;

@end

@implementation PostnatalWardTableViewController
{
    NSArray *problems;
    
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        problems = [PostnatalWardModel getListOfPostnatalWardProblems];;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Postnatal Ward"];
    
    self.title = NSLocalizedString(@"Postnatal Ward", nil);
    
    //tableView
    self.tableView.rowHeight = 50.0f;
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *problem;
    
    if (tableView == self.tableView)
    {
        PostnatalWardSection *postnatalWardSection = [self.postnatalWardSections objectAtIndex:indexPath.section];
        
        problem = [postnatalWardSection.problems objectAtIndex:indexPath.row];
        cell.textLabel.text = problem;
    }
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        problem = [searchData objectAtIndex:indexPath.row];

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

@end
