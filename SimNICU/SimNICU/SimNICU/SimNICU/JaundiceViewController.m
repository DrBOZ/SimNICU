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
	
    [CBTrackers logEvent:@"Jaundice"];
    
    self.title = @"Jaundice";
    
    sectionHeaders = [[NSMutableArray alloc] initWithCapacity:4];
    NSString *header;
    
    header = @"Maternal Blood Group";
    [sectionHeaders addObject:header];
    
    header = @"Antibodies";
    [sectionHeaders addObject:header];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Tableview
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
    
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 44.0f;
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionHeaders[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UISegmentedControl *maternalBloodGroup = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"AB", @"A", @"B", @"O", nil]];
    maternalBloodGroup.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
    maternalBloodGroup.segmentedControlStyle = UISegmentedControlStyleBordered;
    
    cell.accessoryView = maternalBloodGroup;
    
    return cell;
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
