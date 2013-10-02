//
//  CDHViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "CDHViewController.h"
#import "SimNICUWebView.h"
#import "AppDelegate.h"

@interface CDHViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CDHViewController
{
    NSMutableArray *webViewSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"CDH"];
    
    self.title = @"CDH";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStylePlain];
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
    webViewSections = [[NSMutableArray alloc] initWithCapacity:4];
    
    NSMutableArray *webViewRows;
    SimNICUWebView *webView;
    
    // section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 160.0f)];
    webView.header = @"Delivery Room Care";
    webView.resource = @"cdh0";
    webView.cellIdentifier = @"Cell0";
    webView.heightForRowAtIndexPath = @165.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 695.0f)];
    webView.header = @"Neonatal Unit";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"cdh1Comma";
    }
    else
    {
        webView.resource = @"cdh1";
    }
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @700.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 95.0f)];
    webView.header = @"Surgery";
    webView.resource = @"cdh2";
    webView.cellIdentifier = @"Cell2";
    webView.heightForRowAtIndexPath = @100.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 265.0f)];
    webView.header = @"Post-Operative Care";
    webView.resource = @"cdh3";
    webView.cellIdentifier = @"Cell3";
    webView.heightForRowAtIndexPath = @270.0f;
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
    
    NSLog(@"CDHViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"CDHViewController unloaded properties");
        
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[webViewSections[section] objectAtIndex:0] header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[webViewSections[indexPath.section] objectAtIndex:indexPath.row] heightForRowAtIndexPath] floatValue];
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
    
    if ([webView respondsToSelector:@selector(scrollView)])
    {
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
