//
//  DrugBenzylpenicillinViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugBenzylpenicillinViewController.h"
#import "DrugDatabase.h"
#import "DrugCategory.h"
#import "DrugSection.h"
#import "AppDelegate.h"
#import "DrugInfo.h"
#import "Drug.h"


@interface DrugBenzylpenicillinViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView0;
@property (nonatomic, strong) UIWebView *webView1;
@property (nonatomic, strong) UIWebView *webView2;

@property (nonatomic, strong) DrugCategory *drugCategory;
@property (nonatomic, strong) NSMutableArray *drugSections;

@end

@implementation DrugBenzylpenicillinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Benzylpenicillin";
    
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
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Benzylpenicillin" withError:nil];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"DrugBenzylpenicillinViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"DrugBenzylpenicillinViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView0 = nil;
        self.webView1 = nil;
        self.webView2 = nil;
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
    int sections = 1;
    
    
    return sections;
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
            header = @"Pharmacology";
            break;
            
        case 1:
            header = @"Indications";
            break;
            
        case 2:
            header = @"Presentation";
            break;
            
        case 3:
            header = @"Dose / Route";
            break;
            
        case 4:
            header = @"Preparation / Administration";
            break;
            
        case 5:
            header = @"Incompatibilities";
            break;
            
        case 6:
            header = @"Contraindications / Warnings";
            break;
            
        case 7:
            header = @"Side effects";
            break;
            
        case 8:
            header = @"Monitoring";
            break;
            
        case 9:
            header = @"Licence status";
            break;
            
        case 10:
            header = @"References";
            break;
            
        default:
            break;
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0f;
    
    switch (indexPath.section)
    {
        case 0:
            height = 100.0f;
            break;
            
        case 1:
            height = 80.0f;
            break;
            
        case 2:
            height = 40.0f;
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
            
            self.webView0 = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 245.0f)];
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
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"benzylpenicillinPharmacology" ofType:@"html"] isDirectory:NO];
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
            
            self.webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 135.0f)];
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
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"benzylpenicillinIndications" ofType:@"html"] isDirectory:NO];
            NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
            [self.webView1 loadRequest:URLReq];
            
            [cell addSubview:self.webView1];
        }
        
        returnCell = cell;
    }
    else if(indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"textView2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            self.webView2 = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 135.0f)];
            self.webView2.backgroundColor = [UIColor clearColor];
            self.webView2.opaque = NO;
            self.webView2.scalesPageToFit = NO;
            
            if ([self.webView2 respondsToSelector:@selector(scrollView)])
            {
                self.webView2.scrollView.scrollEnabled = NO;
            }
            else
            {
                for (id subview in self.webView2.subviews)
                    if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                        ((UIScrollView *)subview).scrollEnabled = NO;
            }
            
            self.webView1.dataDetectorTypes = UIDataDetectorTypeNone;
            
            NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"benzylpenicillinPresentation" ofType:@"html"] isDirectory:NO];
            NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
            [self.webView2 loadRequest:URLReq];
            
            [cell addSubview:self.webView2];
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
