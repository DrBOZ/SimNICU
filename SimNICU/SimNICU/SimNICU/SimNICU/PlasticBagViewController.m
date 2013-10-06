//
//  PlasticBagViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "PlasticBagViewController.h"
#import "AppDelegate.h"

@interface PlasticBagViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation PlasticBagViewController

@synthesize myTableView = _myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Thermoregulation"];
    
    self.title = @"Thermoregulation";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    }
    self.myTableView.rowHeight = 120.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    // self.myTableView.scrollEnabled = NO;
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBTableViewController setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 320.0f, 44.0f)];
    tableFooterLabel.numberOfLines = 2;
    tableFooterLabel.textAlignment = UITextAlignmentLeft;
    tableFooterLabel.textColor = [UIColor darkGrayColor];
    tableFooterLabel.shadowColor = [UIColor whiteColor];
    
    tableFooterLabel.shadowOffset = CGSizeMake(0, 1);
    
    tableFooterLabel.text = @" 1. Vohra S et al. Journal of Pediatrics\n     1999";
    tableFooterLabel.backgroundColor = [UIColor clearColor];
    
    [self.myTableView setTableFooterView:tableFooterLabel];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    self.swipeGestureRecognizer = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PlasticBagViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PlasticBagViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    
    float height = 0;
    
    if (section == 0) 
    {
        height = 50.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Plastic bag (at delivery)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"cell01";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *main = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 13.0f, 228.0f, 22.0f)];
        main.text = @"< 32 weeks gestation";
        main.textAlignment = UITextAlignmentLeft;
        main.font = [UIFont boldSystemFontOfSize:18.0f];
        main.textColor = [UIColor blackColor];
        
        UILabel *sub01 = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 35.0f, 228.0f, 50.0f)];
        sub01.text = @"At delivery put infant directly into a plastic bag without drying [1]";
        sub01.numberOfLines = 2;
        sub01.font = [UIFont systemFontOfSize:15.0f];
        sub01.textColor = [UIColor lightGrayColor];
        
        UILabel *sub02 = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 82.0f, 228.0f, 29.0f)];
        sub02.text = @"Cover head with a bonnet";
        sub02.font = [UIFont systemFontOfSize:15.0f];
        sub02.textColor = [UIColor lightGrayColor];
        
        [cell addSubview:main];
        [cell addSubview:sub01];
        [cell addSubview:sub02];
        
        returnCell = cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"cell01";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *main = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 11.0f, 228.0f, 22.0f)];
        main.text = @"> 32 weeks gestation";
        main.textAlignment = UITextAlignmentLeft;
        main.font = [UIFont boldSystemFontOfSize:18.0f];
        main.textColor = [UIColor blackColor];
        
        UILabel *sub01 = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 32.0f, 228.0f, 46.0f)];
        sub01.text = @"Dry baby and replace wet towel with a pre-warmed one";
        sub01.numberOfLines = 2;
        sub01.font = [UIFont systemFontOfSize:15.0f];
        sub01.textColor = [UIColor lightGrayColor];
        
        UILabel *sub02 = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 77.0f, 228.0f, 29.0f)];
        sub02.text = @"Ensure head is covered";
        sub02.font = [UIFont systemFontOfSize:15.0f];
        sub02.textColor = [UIColor lightGrayColor];
        
        [cell addSubview:main];
        [cell addSubview:sub01];
        [cell addSubview:sub02];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
