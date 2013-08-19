//
//  PhototherapyGuidelineCountryViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 26/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyGuidelineCountryViewController.h"
#import "AppDelegate.h"

@interface PhototherapyGuidelineCountryViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property UITableView *myTableView;
@property UITableViewCell *cellUS;
@property UITableViewCell *cellUK;

@end

@implementation PhototherapyGuidelineCountryViewController

@synthesize guidelineCountry = _guidelineCountry;
@synthesize delegate = _delegate;
@synthesize cellUS = _cellUS;
@synthesize cellUK = _cellUK;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.title = NSLocalizedString(@"Guidelines", nil);  // needs add to localization string file
        
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
    }
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Phototherapy/Guideline Selector" withError:nil];
    
#endif
    
    [Flurry logEvent:@"PhototherapyGuidelineCountry: viewDidAppear"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyGuidelineCountryViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyGuidelineCountryViewController unloaded properties");
        
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
    return NSLocalizedString(@"Guideline Country", nil); // needs adding to string file
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
        static NSString *CellIdentifier = @"US";
        self.cellUS = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellUS)
        {
            self.cellUS = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellUS.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellUS.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellUS.textLabel.text = @"United States";
        self.cellUS.detailTextLabel.text = @"AAP 2004 Guidelines";
        
        if ([self.guidelineCountry isEqualToString:@"US"])
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
        static NSString *CellIdentifier = @"UK";
        self.cellUK = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellUK)
        {
            self.cellUK = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellUK.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellUK.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellUK.textLabel.text = @"United Kingdom";
        self.cellUK.detailTextLabel.text = @"NICE Guidelines";
        
        if ([self.guidelineCountry isEqualToString:@"UK"])
        {
            self.cellUK.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cellUK.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.cellUK.accessoryType = UITableViewCellAccessoryNone;
            self.cellUK.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.cellUK;
    }
    
    return returnCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.guidelineCountry = @"US";
        
        self.cellUS.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellUS.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellUK.accessoryType = UITableViewCellAccessoryNone;
        self.cellUK.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        self.guidelineCountry = @"UK";
        
        self.cellUK.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellUK.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellUS.accessoryType = UITableViewCellAccessoryNone;
        self.cellUS.textLabel.textColor = [UIColor blackColor];
    }
    
    // [self.myTableView reloadData];
    
    [self.delegate phototherapyGuidelineCountryViewController:self didFinishSelectingGuidelineCountry:self.guidelineCountry];
    
    // [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(popViewController:) userInfo:nil repeats:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
