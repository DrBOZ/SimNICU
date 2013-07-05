//
//  DrugCategoriesViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugCategoriesViewController.h"
#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "Drug.h"
#import "AppDelegate.h"

@interface DrugCategoriesViewController ()
{
    int numberOfSectionsInTableView;
    
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation DrugCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Drugs";
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //tableView
        // self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - (20 + 44 + 49))) style:UITableViewStylePlain];
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
	// Do any additional setup after loading the view.
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = @"Search All Drugs";
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
    self.myTableView.contentOffset = CGPointMake(0.0f, 44.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int rows = 0;
    
    if (tableView == self.myTableView)
    {
        rows = [appDelegate.drugDatabase.drugCategories count];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        rows = [searchData count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    static NSString *CellIdentifier = @"Drug Categories";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (tableView == self.myTableView)
    {
        DrugCategory *drugCategory = [appDelegate.drugDatabase.drugCategories objectAtIndex:(indexPath.row)];
        cell.textLabel.text = drugCategory.name;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        // remember searching all foods
        Drug *drug = [searchData objectAtIndex:indexPath.row];
        cell.textLabel.text = drug.name;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        if (drug.selected)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.myTableView)
    {
        // FoodsViewController *foodsViewController = [[FoodsViewController alloc] init];
        // foodsViewController.index = [NSNumber numberWithInt:indexPath.row];
        
        // [self.navigationController pushViewController:foodsViewController animated:YES];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Drug *drug = [searchData objectAtIndex:indexPath.row];
        drug.selected = !drug.selected;
        // reload
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [searchData removeAllObjects];
    
    DrugCategory *drugCategory; // search through all food categories
    
    for(drugCategory in appDelegate.drugDatabase.drugCategories)
    {
        Drug *drug;             // search through all foods in a food category
        
        for(drug in drugCategory.drugs)
        {
            NSRange range = [drug.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if (range.length > 0)
            {
                [searchData addObject:drug];
            }
        }
    }
    
    // finally alphebetize searchData
    
    /* this alphebetizes only
     NSArray *sortedSearchData;
     
     sortedSearchData = [searchData sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
     {
     NSString *first = [(Food *)a name];
     NSString *second = [(Food *)b name];
     return [first compare:second];
     }];
     
     searchData = [NSMutableArray arrayWithArray:sortedSearchData];
     */
    
    // really what I want to do is reorder by exact match
    /*
     NSArray *sortedSearchData;
     Food *food;
     
     for (food in searchData)
     {
     NSLog(@"%@", food.name);
     }
     */
    
    return YES;
}

@end
