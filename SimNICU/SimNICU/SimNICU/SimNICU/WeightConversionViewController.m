//
//  WeightConversionTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 09/06/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "WeightConversionViewController.h"
#import "AppDelegate.h"

@interface WeightConversionViewController ()

@property (nonatomic, retain) UIWebView *webView;

@end

@implementation WeightConversionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Conversion Table";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //view background
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    //webView    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64))];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:self.webView];
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"weightConversionTable" ofType:@"html"] isDirectory:NO];
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:URLReq];
    
#if APP_SHADING
    //screen mask covers everything
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    [self.view addSubview:tableBgView];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.webView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Weight Conversion Table" withError:nil];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"WeightConversionViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"WeightConversionViewController unloaded properties");
        
        self.webView = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
