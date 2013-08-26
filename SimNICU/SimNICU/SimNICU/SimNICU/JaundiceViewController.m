//
//  JaundiceViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 26/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "JaundiceViewController.h"
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "SVSegmentedControl.h"

@interface JaundiceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UISegmentedControl *maternalBloodGroup;
@property (nonatomic, strong) UISegmentedControl *maternalRhesus;
@property (nonatomic, strong) UISegmentedControl *maternalAntibodies;
@property (nonatomic, strong) UISegmentedControl *babyBloodGroup;
@property (nonatomic, strong) UISegmentedControl *babyRhesus;
@property (nonatomic, strong) UISegmentedControl *dct;

@end

@implementation JaundiceViewController
{
    NSMutableArray *sectionHeaders;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Jaundice Data Entry"];
    
    self.title = @"Jaundice";
    
    sectionHeaders = [[NSMutableArray alloc] initWithCapacity:4];
    NSString *header;
    
    header = @"Maternal";
    [sectionHeaders addObject:header];
    
    header = @"Baby";
    [sectionHeaders addObject:header];
    
    header = @"Direct Coombs Test";
    [sectionHeaders addObject:header];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Tableview
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
    
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    
    if (section == 0)
    {
        numberOfRows = 3;
    }
    else if (section == 1)
    {
        numberOfRows = 2;
    }
    else if (section == 2)
    {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionHeaders[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Maternal Blood Group";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"AB", @"A", @"B", @"O", nil]];
            self.maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Blood Group";
            cell.accessoryView = self.maternalBloodGroup;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Maternal Rhesus D";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.maternalRhesus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            self.maternalRhesus.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.maternalRhesus.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Rhesus D";
            cell.accessoryView = self.maternalRhesus;
            
            returnCell = cell;
        }
        else if (indexPath.row == 2)
        {
            static NSString *CellIdentifier = @"Maternal Antibodies";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.maternalAntibodies = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"No", @"Yes", nil]];
            self.maternalAntibodies.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.maternalAntibodies.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Antibodies";
            cell.accessoryView = self.maternalAntibodies;
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Baby Blood Group";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.babyBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"AB", @"A", @"B", @"O", nil]];
            self.babyBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.babyBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Blood Group";
            cell.accessoryView = self.babyBloodGroup;
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Baby Rhesus D";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.babyRhesus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            self.babyRhesus.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.babyRhesus.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Rhesus D";
            cell.accessoryView = self.babyRhesus;
            
            returnCell = cell;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"DCT";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            self.dct = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            self.dct.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            self.dct.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"DCT";
            cell.accessoryView = self.dct;
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

# pragma mark

- (void)done
{
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:5];
    
    // Maternal blood group
    NSString *resultsMaternalBloodGroup = nil;
    
    if (self.maternalBloodGroup.selectedSegmentIndex == 0)
    {
        resultsMaternalBloodGroup = @"AB";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 1)
    {
        resultsMaternalBloodGroup = @"A";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 2)
    {
        resultsMaternalBloodGroup = @"B";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 3)
    {
        resultsMaternalBloodGroup = @"O";
    }
    else
    {
        resultsMaternalBloodGroup = @"?";
    }
    
    [results addObject:resultsMaternalBloodGroup];
    
    // Maternal Rhesus D status
    NSString *resultsMaternalRhesus = nil;
    
    if (self.maternalRhesus.selectedSegmentIndex == 0)
    {
        resultsMaternalRhesus = @"Neg";
    }
    else if (self.maternalRhesus.selectedSegmentIndex == 1)
    {
        resultsMaternalRhesus = @"Pos";
    }
    else
    {
        resultsMaternalRhesus = @"?";
    }
    
    [results addObject:resultsMaternalRhesus];
    
    // Maternal antibodies
    NSString *resultsMaternalAntibodies = nil;
    
    if (self.maternalAntibodies.selectedSegmentIndex == 0)
    {
        resultsMaternalAntibodies = @" - no antibodies";
    }
    else if (self.maternalAntibodies.selectedSegmentIndex == 1)
    {
        resultsMaternalAntibodies = @" - antibodies present";
    }
    else
    {
        resultsMaternalAntibodies = @"?";
    }
    
    [results addObject:resultsMaternalAntibodies];
    
    // Baby blood group
    NSString *resultsBabyBloodGroup = nil;
    
    if (self.babyBloodGroup.selectedSegmentIndex == 0)
    {
        resultsBabyBloodGroup = @"AB";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 1)
    {
        resultsBabyBloodGroup = @"A";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 2)
    {
        resultsBabyBloodGroup = @"B";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 3)
    {
        resultsBabyBloodGroup = @"O";
    }
    else
    {
        resultsBabyBloodGroup = @"?";
    }
    
    [results addObject:resultsBabyBloodGroup];
    
    // Baby Rhesus D status
    NSString *resultsBabyRhesus = nil;
    
    if (self.babyRhesus.selectedSegmentIndex == 0)
    {
        resultsBabyRhesus = @"Neg";
    }
    else if (self.babyRhesus.selectedSegmentIndex == 1)
    {
        resultsBabyRhesus = @"Pos";
    }
    else
    {
        resultsBabyRhesus = @"?";
    }
    
    [results addObject:resultsBabyRhesus];
    
    // Direct Coombs Test
    NSString *resultsDCT = nil;
    
    if (self.dct.selectedSegmentIndex == 0)
    {
        resultsDCT = @"negative";
    }
    else if (self.dct.selectedSegmentIndex == 1)
    {
        resultsDCT = @"positive";
    }
    else
    {
        resultsDCT = @"?";
    }
    
    [results addObject:resultsDCT];
    
    [self.delegate jaundiceViewControllerDidFinish:self withResults:results];
}

- (void)cancel
{
    [self.delegate jaundiceViewControllerDidCancel:self];
}








@end
