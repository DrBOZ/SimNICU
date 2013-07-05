//
//  CoolingCriteriaEncephalopathyViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "CoolingCriteriaEncephalopathyViewController.h"
#import "AppDelegate.h"

@interface CoolingCriteriaEncephalopathyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView0;

@end

@implementation CoolingCriteriaEncephalopathyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Cooling Criteria";
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
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
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Cooling/Encephalopathy" withError:nil];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"CoolingCriteriaEncephalopathyViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"CoolingCriteriaEncephalopathyViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView0 = nil;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Moderate to Severe\nEncephalopathy, consisting of";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{    
    float height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
    {
        height = 88.0f;
    }
    else
    {
        height = 78.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor whiteColor]];
            
            self.webView0 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 330)];
            self.webView0.backgroundColor = [UIColor clearColor];
            self.webView0.opaque = NO;
            self.webView0.scalesPageToFit = NO;
            
            if ([self.webView0 respondsToSelector:@selector(scrollView)]) 
            {
                self.webView0.scrollView.scrollEnabled = NO;
            } 
            else 
            {
                for (id subview in self.webView0.subviews)
                    if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                        ((UIScrollView *)subview).scrollEnabled = NO;        
            }
            
            self.webView0.dataDetectorTypes = UIDataDetectorTypeNone;
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"cooling2" ofType:@"html"] isDirectory:NO];
            NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
            [self.webView0 loadRequest:URLReq];
            
            [cell addSubview:self.webView0];
        }
        
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
