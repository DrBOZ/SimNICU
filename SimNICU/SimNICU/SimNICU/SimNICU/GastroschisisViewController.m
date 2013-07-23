//
//  GastroschisisBackgroundViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "GastroschisisViewController.h"
#import "AppDelegate.h"

@interface GastroschisisViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView0;
@property (nonatomic, strong) UIWebView *webView1;

@end

@implementation GastroschisisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Gastroschisis";
    
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
    
    [[GANTracker sharedTracker] trackPageview:@"Gastroschisis" withError:nil];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"GastroschisisViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"GastroschisisViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView0 = nil;
        self.webView1 = nil;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    switch (section) 
    {
        case 0:
            header = @"Delivery Room Care";
            break;
            
        case 1:
            header = @"Neonatal Unit";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    /*
    float height = 44.0f;
    
    if (section == 0) 
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
        {
            height = 66.0f;
        }
        else
        {
            height = 55.0f;
        }
    }
    
    return height;
     */
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0f;
    
    switch (indexPath.section) 
    {
        case 0:
            height = 250.0f;
            break;
            
        case 1:
            height = 140.0f;
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"textView0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            self.webView0 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 245)];
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
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gastroschisis0" ofType:@"html"] isDirectory:NO];
            NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
            [self.webView0 loadRequest:URLReq];
            
            [cell addSubview:self.webView0];
        }
        
        returnCell = cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"textView1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            self.webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 135)];
            self.webView1.backgroundColor = [UIColor clearColor];
            self.webView1.opaque = NO;
            self.webView1.scalesPageToFit = NO;
            
            if ([self.webView1 respondsToSelector:@selector(scrollView)]) 
            {
                self.webView1.scrollView.scrollEnabled = NO;
            } 
            else 
            {
                for (id subview in self.webView1.subviews)
                    if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                        ((UIScrollView *)subview).scrollEnabled = NO;        
            }
            
            self.webView1.dataDetectorTypes = UIDataDetectorTypeNone;
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gastroschisis1" ofType:@"html"] isDirectory:NO];
            NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
            [self.webView1 loadRequest:URLReq];
            
            [cell addSubview:self.webView1];
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
