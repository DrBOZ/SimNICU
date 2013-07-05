//
//  CrUSSBackgroundViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "CrUSSViewController.h"
#import "SimNICUWebView.h"
#import "AppDelegate.h"

@interface CrUSSViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CrUSSViewController
{
    NSMutableArray *webViewSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CrUSSViewController viewDidLoad");
    
    self.title = @"Cranial Ultrasound";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped]; // 416
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
#if USE_DIMPLE_BACKGROUND
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    else
    {
        // 3.5 inch Retina
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
        [tempImageView setFrame:self.myTableView.frame];
        
        self.myTableView.backgroundView = tempImageView;
    }
    
#else
    self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
    
#if APP_SHADING
    //screen mask covers everything
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    [self.view addSubview:tableBgView];
#endif
    
    webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSMutableArray *webViewRows;
    SimNICUWebView *webView;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10, 5, 300, 330)];
    webView.header = @"Indications";
    webView.resource = @"crUSS0";
    webView.cellIdentifier = @"cell0";
    webView.heightForRowAtIndexPath = @335.0f;;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section Two
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[SimNICUWebView alloc] initWithFrame:CGRectMake(10, 5, 300, 170)];
    webView.header = @"Timings of scans";
    webView.resource = @"crUSS1";
    webView.cellIdentifier = @"cell1";
    webView.heightForRowAtIndexPath = @175.0f;
    [self formatAndLoadSimNICUWebView:webView];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Cranial Ultrasound" withError:nil];
    
#endif
    
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
    
    NSLog(@"CrUSSViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"CrUSSViewController unloaded properties");
        
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
    float height = 44.0f;
    
    if (section == 0) 
    {
        height = 66.0f;
    }
    
    return height;
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
