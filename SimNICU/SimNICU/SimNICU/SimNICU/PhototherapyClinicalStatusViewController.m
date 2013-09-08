//
//  PhototherapyClinicalStatusViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 28/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyClinicalStatusViewController.h"
#import "AppDelegate.h"

@interface PhototherapyClinicalStatusViewController ()

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITableViewCell *wellCell;
@property (nonatomic, strong) UITableViewCell *unwellCell;

@end

@implementation PhototherapyClinicalStatusViewController

@synthesize clinicalStatus = _clinicalStatus;
@synthesize unwellCell = _unwellCell;
@synthesize wellCell = _wellCell;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Phototherapy/Clinical Status"];
    
    self.title = NSLocalizedString(@"Clinical Status", nil); // need to add to localization string file
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //menu table
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.hidden = NO;
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyGuidelineCountryViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyGuidelineCountryViewController unloaded properties");
        
        self.myTableView = nil;
    }
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
    return NSLocalizedString(@"Clinical Status", nil);  // add to localization string file...
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 200.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    // footer = @"Acidosis\nAlbumin < 3.0\nAsphyxia\nG6PD deficiency\nIsoimmune Hemolytic Disease\nSepsis\nSignificant Lethargy\nTemperature Instability";
    
    // footer = NSLocalizedString(@"The default unit of measure for total bilirubin is mg/dL.\n\nPlease select µmol/L if your bilirubin values are captured in the global standard SI metric units.\n\nBilirubin conversion from US to SI units is 17.1", nil);
    
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
        static NSString *CellIdentifier = @"well";
        self.wellCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.wellCell)
        {
            self.wellCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            self.wellCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.wellCell.backgroundColor = [UIColor whiteColor];
        }
        
        self.wellCell.textLabel.text = @"Well";
        
        if ([self.clinicalStatus isEqualToString:@"Well"])
        {
            self.wellCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.wellCell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.wellCell.accessoryType = UITableViewCellAccessoryNone;
            self.wellCell.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.wellCell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"unwell";
        self.unwellCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.unwellCell)
        {
            self.unwellCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            self.unwellCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.unwellCell.backgroundColor = [UIColor whiteColor];
        }
        
        self.unwellCell.textLabel.text = @"Unwell";
        
        if ([self.clinicalStatus isEqualToString:@"Unwell"])
        {
            self.unwellCell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.unwellCell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.unwellCell.accessoryType = UITableViewCellAccessoryNone;
            self.unwellCell.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.unwellCell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.clinicalStatus = @"Well";
        
        self.wellCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.wellCell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.unwellCell.accessoryType = UITableViewCellAccessoryNone;
        self.unwellCell.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.clinicalStatus = @"Unwell";
        
        self.unwellCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.unwellCell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.wellCell.accessoryType = UITableViewCellAccessoryNone;
        self.wellCell.textLabel.textColor = [UIColor blackColor];
    }
    
    // [self.myTableView reloadData];
    
    [self.delegate phototherapyClinicalStatusViewController:self didFinishSelectingClinicalStatus:self.clinicalStatus];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(popViewController:) userInfo:nil repeats:NO];
}

#pragma mark

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
