//
//  CurosurfViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "CurosurfViewController.h"
#import "SimNICUWebView.h"
#import "AppDelegate.h"

@interface CurosurfViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic) BOOL selectedPatientMeetsCriteriaForROPScreening;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CurosurfViewController
{
    NSMutableArray *webViewSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Curosurf"];
    
    self.title = @"Curosurf\u00AE";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    // self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStylePlain];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
    // Setup section array
    webViewSections = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableArray *webViewRows;
    SimNICUWebView *webView;
    
    // section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 235.0f)];
    }
    else
    {
        webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 255.0f)];
    }
    webView.header = @"Indications";
    webView.resource = @"curosurfIndications";
    webView.cellIdentifier = @"Cell0";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        webView.heightForRowAtIndexPath = @240.0f;
    }
    else
    {
        webView.heightForRowAtIndexPath = @260.0f;
    }
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 370.0f)];
    webView.header = @"Doses";
    webView.resource = @"curosurfDoses2";
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @375.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 300.0f, 130.0f)];
    webView.header = @"Further doses";
    webView.resource = @"curosurfFurtherDoses";
    webView.cellIdentifier = @"Cell2";
    webView.heightForRowAtIndexPath = @135.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.curosurfDoseSelected isEqualToString:@"YES"])
    {
        // move table to Curosurf Dose information
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"CurosurfViewController unloaded properties");
        
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
