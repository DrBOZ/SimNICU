//
//  AboutSimNICUViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 08/09/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "AboutSimNICUViewController.h"
#import "AppDelegate.h"

@interface AboutSimNICUViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AboutSimNICUViewController

@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"About";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //view background
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20))];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.userInteractionEnabled = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about2" ofType:@"html"] isDirectory:NO];
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:URLReq];
    
    self.webView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"AboutSimNICUViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"AboutSimNICUViewController unloaded properties");
        
        self.webView = nil;
    }
}

- (void)viewDidUnload
{
    self.webView = nil;
    
    [super viewDidUnload];
}

// Tell the system what we support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate
{
    return NO;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
