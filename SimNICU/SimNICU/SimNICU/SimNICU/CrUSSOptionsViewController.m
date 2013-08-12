//
//  AgeCalculatorsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "CrUSSRadiologyViewController.h"
#import "CrUSSOptionsViewController.h"
#import "CBTableViewSectionData.h"
#import "CrUSSViewController.h"
#import "CBTableViewRowData.h"

@interface CrUSSOptionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CrUSSOptionsViewController
{
    NSMutableArray *tableData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        tableData = [[NSMutableArray alloc] initWithCapacity:3];
        CBTableViewSectionData *sectionData;
        CBTableViewRowData *rowData;
        
        // section 0
        sectionData = [[CBTableViewSectionData alloc] init];
        sectionData.titleForHeader = @"General Information";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = @"Indications & Timings";
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
        
        // section 1
        sectionData = [[CBTableViewSectionData alloc] init];
        sectionData.titleForHeader = @"Technique";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:2];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = @"Holding the probe";
        [sectionData.rowData addObject:rowData];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = @"Standard sequence";
        [sectionData.rowData addObject:rowData];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = @"Measuring ventricular index";
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
        
        // section 2
        sectionData = [[CBTableViewSectionData alloc] init];
        sectionData.titleForHeader = @"Example Scans";
        sectionData.rowData = [[NSMutableArray alloc] initWithCapacity:5];
        
        rowData = [[CBTableViewRowData alloc] init];
        rowData.text = @"Image viewer";
        [sectionData.rowData addObject:rowData];
        
        [tableData addObject:sectionData];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:nil];
        
        // create UITableView
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 50.0f;  // was 44.0f
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.hidden = NO;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        
        // swipe gesture recognizer
        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Cranial Ultrasound";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"CrUSS Options" withError:nil];
    
#endif
    
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
    return [tableData count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    CBTableViewSectionData *sectionData = tableData[section];
    
    rows = [sectionData.rowData count];
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    CBTableViewSectionData *sectionData = tableData[section];
    header = sectionData.titleForHeader;
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CBTableViewSectionData *sectionData = tableData[indexPath.section];
    CBTableViewRowData *rowData = sectionData.rowData[indexPath.row];
    
    cell.textLabel.text = rowData.text;
    cell.detailTextLabel.text = rowData.detailText;
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CrUSSViewController *newViewController = [[CrUSSViewController alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else if (indexPath.section == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == 2)
    {
        CrUSSRadiologyViewController *newViewController = [[CrUSSRadiologyViewController alloc] init];
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
