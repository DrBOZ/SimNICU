//
//  PhototherapyUnitsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyUnitsViewController.h"
#import "AppDelegate.h"

@interface PhototherapyUnitsViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property UITableView *myTableView;
@property UITableViewCell *cellUS;
@property UITableViewCell *cellSI;

@end

@implementation PhototherapyUnitsViewController

@synthesize guidelineCountry = _guidelineCountry;
@synthesize bilirubinUnits = _bilirubinUnits;
@synthesize myTableView = _myTableView;
@synthesize delegate = _delegate;
@synthesize cellUS = _cellUS;
@synthesize cellSI = _cellSI;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Phototherapy/Units"];
    
    self.title = NSLocalizedString(@"Units", nil);
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //menu table
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyUnitsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyUnitsViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
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
    float height = 22.0f;
    
    float fourInchDisplayPadding = 0.0f;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        fourInchDisplayPadding = 22.0f;
    }
    
    height = 66.0f + fourInchDisplayPadding;
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Serum bilirubin units", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float footer = 0.0f;
    
    if (section == 0)
    {
        // footer = 66.0f;
        footer = 200.0f;
    }
    
    return footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if ([self.guidelineCountry isEqualToString:@"US"])
    {
        footer = NSLocalizedString(@"The default unit of measure for total bilirubin is mg/dL.\n\nPlease select µmol/L if your bilirubin values are captured in the global standard SI metric units.\n\nBilirubin conversion from US to SI units is 17.1", nil);
    }
    else if ([self.guidelineCountry isEqualToString:@"UK"])
    {
        footer = NSLocalizedString(@"The default unit of measure for total bilirubin is µmol/L.\n\nPlease select mg/dL if your bilirubin values are captured in US units.\n\nBilirubin conversion from US to SI units is 17.1", nil);
    }
    
    return footer;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"US";
        self.cellUS = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellUS)
        {
            self.cellUS = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellUS.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellUS.backgroundColor = [UIColor whiteColor];
        }
        
        // self.cellUS.textLabel.text = @"US (mg/dL)";
        self.cellUS.textLabel.text = @"mg/dL";
        self.cellUS.detailTextLabel.text = @"United States";
        
        if ([self.bilirubinUnits isEqualToString:@"US"])
        {
            self.cellUS.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cellUS.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.cellUS.accessoryType = UITableViewCellAccessoryNone;
            self.cellUS.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.cellUS;
    }
    else
    {
        static NSString *CellIdentifier = @"SI";
        self.cellSI = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellSI)
        {
            self.cellSI = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellSI.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellSI.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellSI.textLabel.text = @"µmol/L";
        self.cellSI.detailTextLabel.text = @"International System (SI)";
        
        if ([self.bilirubinUnits isEqualToString:@"SI"])
        {
            self.cellSI.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cellSI.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.cellSI.accessoryType = UITableViewCellAccessoryNone;
            self.cellSI.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.cellSI;
    }

    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // self.gestation = [NSNumber numberWithInt:(indexPath.row + 23)];
    if (indexPath.row == 0)
    {
        self.bilirubinUnits = @"US";
        
        self.cellUS.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellUS.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellSI.accessoryType = UITableViewCellAccessoryNone;
        self.cellSI.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.bilirubinUnits = @"SI";
        
        self.cellSI.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellSI.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellUS.accessoryType = UITableViewCellAccessoryNone;
        self.cellUS.textLabel.textColor = [UIColor blackColor];
    }
    
    // [self.myTableView reloadData];

    [self.delegate phototherapyUnitsViewController:self didFinishSelectingUnits:self.bilirubinUnits];
    
    // [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(popViewController:) userInfo:nil repeats:NO];
}

#pragma mark

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
