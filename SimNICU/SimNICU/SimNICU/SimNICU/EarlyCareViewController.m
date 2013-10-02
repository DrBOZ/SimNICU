//
//  EarlyCareBackgroundViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "EarlyCareViewController.h"
#import "SimNICUWebView.h"
#import "AppDelegate.h"

@interface EarlyCareViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation EarlyCareViewController
{
    NSMutableArray *webViewSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Early Care"];
    
    self.title = @"Early Care";
    
    if (!self.earlyCareWarningShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"NOTE!"
                                  message:@"The following is for infants born less than 28 weeks gestation."
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            alertView.tintColor = [UIColor redColor];
        }
        
        [alertView show];
    }
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStylePlain];
        
        // this is mainly for the alert box
        self.view.tintColor = [UIColor redColor];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStylePlain];
    }
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
    // Setup section array
    webViewSections = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSMutableArray *webViewRows;
    SimNICUWebView *webView;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:3];
    
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 170.0f)];
    webView.header = @"Delivery Room Care";
    webView.resource = @"earlyCare0";
    webView.cellIdentifier = @"Cell00";
    webView.heightForRowAtIndexPath = @175.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 132.0f)];
    webView.header = nil;
    webView.resource = @"earlyCare1";
    webView.cellIdentifier = @"Cell01";
    webView.heightForRowAtIndexPath = @137.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 395.0f)];
    webView.header = nil;
    webView.resource = @"earlyCare2";
    webView.cellIdentifier = @"Cell02";
    webView.heightForRowAtIndexPath = @230.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Two
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 155.0f)];
    webView.header = @"Initial Ventilator Settings";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"earlyCareVentSettingsComma";
    }
    else
    {
        webView.resource = @"earlyCareVentSettings";
    }
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @160.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Three
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 520.0f)];
    webView.header = @"NICU Admission";
    webView.resource = @"earlyCareNICUAdmission";
    webView.cellIdentifier = @"Cell2";
    webView.heightForRowAtIndexPath = @525.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    
    // Section Four
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 340.0f)];
    webView.header = @"Ventilation Strategies";
    webView.resource = @"earlyCareVentStrategies";
    webView.cellIdentifier = @"cell3";
    webView.heightForRowAtIndexPath = @345.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Five
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 155.0f)];
    webView.header = @"Miscellaneous";
    webView.resource = @"earlyCareMisc";
    webView.cellIdentifier = @"cell4";
    webView.heightForRowAtIndexPath = @160.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"EarlyCareViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"EarlyCareViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [webViewSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [webViewSections[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[webViewSections[indexPath.section] objectAtIndex:indexPath.row] heightForRowAtIndexPath] floatValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[webViewSections[section] objectAtIndex:0] header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
    float height = 44.0f;
    
    if (section == 0) 
    {
        height = 66.0f;
    }
    
    return height;
     */
    return 22.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[webViewSections[indexPath.section] objectAtIndex:indexPath.row] cellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    [cell addSubview:[webViewSections[indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (SimNICUWebView *)formatAndLoadSimNICUWebView:(SimNICUWebView *)webView
{
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.scalesPageToFit = NO;
    
    if ([webView respondsToSelector:@selector(scrollView)]) {
        webView.scrollView.scrollEnabled = NO;
    }
    else
    {
        for (id subview in webView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).scrollEnabled = NO;
    }
    
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:webView.resource ofType:@"html"] isDirectory:NO];
    NSMutableURLRequest *URLReq = [NSMutableURLRequest requestWithURL:htmlURL];
    [URLReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [webView loadRequest:URLReq];
    
    return webView;
}

@end
