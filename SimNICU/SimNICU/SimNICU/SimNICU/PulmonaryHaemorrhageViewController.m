//
//  PulmonaryHaemorrhageViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PulmonaryHaemorrhageViewController.h"
#import "SimNICUWebView.h"
#import "AppDelegate.h"

@interface PulmonaryHaemorrhageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIWebView *webView0;
@property (nonatomic, strong) UIWebView *webView1;
@property (nonatomic, strong) UIWebView *webView2;
@property (nonatomic, strong) UIWebView *webView3;

@end

@implementation PulmonaryHaemorrhageViewController
{
    NSMutableArray *webViews;
    NSMutableArray *readyWebViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"PulmonaryHaemorrhageViewController viewDidLoad");
    
    self.title = NSLocalizedString(@"Pulmonary Haemorrhage", nil);
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // tableView
    // self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStylePlain];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
#if APP_SHADING
    //screen mask covers everything
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height - 49))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    tableBgView.alpha = 0.5;
    [self.view addSubview:tableBgView];
#endif
    
    // set up array with pages
    webViews = [[NSMutableArray alloc] initWithCapacity:4];
    
    SimNICUWebView *webView;
    
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 345.0f)];
    webView.header = @"Initial Management";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem0Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem0";
    }
    webView.cellIdentifier = @"Cell0";
    webView.heightForRowAtIndexPath = @350.0f;
    [webViews addObject:webView];
    
    webView = [[SimNICUWebView alloc] init];
    webView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 175.0f);
    webView.header = @"Investigations";
    webView.resource = @"pulmonaryHaem1";
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @180.0f;
    [webViews addObject:webView];
    
    webView = [[SimNICUWebView alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        webView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 230.0f);
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
    {
        webView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 250.0f);
    }
    webView.header = @"Ongoing Management";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem2Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem2";
    }
    webView.cellIdentifier = @"Cell2";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        webView.heightForRowAtIndexPath = @235.0f;
    }
    else
    {
        webView.heightForRowAtIndexPath = @255.0f;
    }
    [webViews addObject:webView];
    
    webView = [[SimNICUWebView alloc] init];
    webView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 175.0f);
    webView.header = @"With blood results";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem3Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem3";
    }
    webView.cellIdentifier = @"Cell3";
    webView.heightForRowAtIndexPath = @180.0f;
    [webViews addObject:webView];
    
    self.webView0 = [self getWebViewforIndexPathSection:0];
    self.webView1 = [self getWebViewforIndexPathSection:1];
    self.webView2 = [self getWebViewforIndexPathSection:2];
    self.webView3 = [self getWebViewforIndexPathSection:3];
    
    readyWebViews = [[NSMutableArray alloc] initWithObjects:self.webView0, self.webView1, self.webView2, self.webView3, nil];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Pulmonary Haemorrhage" withError:nil];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PulmonaryHaemorrhageViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PulmonaryHaemorrhageViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView0 = nil;
        self.webView1 = nil;
        self.webView2 = nil;
        self.webView3 = nil;
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
    self.webView0 = nil;
    self.webView1 = nil;
    self.webView2 = nil;
    self.webView3 = nil;
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
    return [webViews count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [webViews[section] header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
    float height = 44.0f;
    
    if (section == 0) height = 66.0f;
    
    return height;
     */
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[webViews[indexPath.section] heightForRowAtIndexPath] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[readyWebViews[indexPath.section] cellIdentifier]];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[readyWebViews[indexPath.section] cellIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    [cell addSubview:readyWebViews[indexPath.section]];
    
    return cell;
}

- (UIWebView *)getWebViewforIndexPathSection:(int)section
{
    SimNICUWebView *returnWebView;
    
    returnWebView = webViews[section];
    
    returnWebView.backgroundColor = [UIColor clearColor];
    returnWebView.opaque = NO;
    returnWebView.scalesPageToFit = NO;
    
    if ([returnWebView respondsToSelector:@selector(scrollView)]) {
        returnWebView.scrollView.scrollEnabled = NO;
    }
    else
    {
        for (id subview in returnWebView.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).scrollEnabled = NO;
    }
    
    returnWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:returnWebView.resource ofType:@"html"] isDirectory:NO];
    NSMutableURLRequest *URLReq = [NSMutableURLRequest requestWithURL:htmlURL];
    [URLReq setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [returnWebView loadRequest:URLReq];
    
    return returnWebView;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
