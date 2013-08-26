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
            
            UISegmentedControl *maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"AB", @"A", @"B", @"O", nil]];
            maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Blood Group";
            cell.accessoryView = maternalBloodGroup;
            
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
            
            UISegmentedControl *maternalRhesus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            maternalRhesus.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            maternalRhesus.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Rhesus D";
            cell.accessoryView = maternalRhesus;
            
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
            
            UISegmentedControl *maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"No", @"Yes", nil]];
            maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Antibodies";
            cell.accessoryView = maternalBloodGroup;
            
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
            
            UISegmentedControl *maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"AB", @"A", @"B", @"O", nil]];
            maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Blood Group";
            cell.accessoryView = maternalBloodGroup;
            
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
            
            UISegmentedControl *babyResus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            babyResus.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            babyResus.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"Rhesus D";
            cell.accessoryView = babyResus;
            
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
            
            UISegmentedControl *maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Neg", @"Pos", nil]];
            maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 150.0f, 44.0f);
            maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
            
            cell.textLabel.text = @"DCT";
            cell.accessoryView = maternalBloodGroup;
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // code
}

# pragma mark

- (void)done
{
    
}

- (void)cancel
{
    [self.delegate jaundiceViewControllerDidCancel:self];
}

@end
