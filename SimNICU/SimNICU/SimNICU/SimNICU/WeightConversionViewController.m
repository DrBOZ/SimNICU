//
//  WeightConversionTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 09/06/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "WeightConversionViewController.h"
#import "AppDelegate.h"

@interface WeightConversionViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, retain) UIWebView *webView;

@end

@implementation WeightConversionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Weight Conversion"];

    self.title = @"Conversion Table";
    self.view.backgroundColor = [UIColor grayColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //webView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height))];
    }
    else
    {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f))];
    }
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:self.webView];
    
    NSString *filename = Nil;
    
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        filename = @"weightConversionTableComma";
    }
    else
    {
        filename = @"weightConversionTable";
    }
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"] isDirectory:NO];
    
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:URLReq];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.webView addGestureRecognizer:self.swipeGestureRecognizer];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.webView = nil;
    self.swipeGestureRecognizer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"WeightConversionViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"WeightConversionViewController unloaded properties");
        
        self.webView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
