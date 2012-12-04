//
//  DisclaimerViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "AppDelegate.h"

@interface DisclaimerViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Legal";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"DisclaimerViewController viewDidLoad");
    
    self.title = @"Legal";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //view background
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    //webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20))];
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.userInteractionEnabled = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"] isDirectory:NO];
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:URLReq];
    
    self.webView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"DisclaimerViewController viewWillAppear");
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Disclaimer" withError:nil];
    
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"DisclaimerViewController viewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"DisclaimerViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"DisclaimerViewController unloaded properties");
        
        self.webView = nil;
    }
}

- (void)viewDidUnload
{
    NSLog(@"DisclaimerViewController viewDidUnload");
    
    self.webView = nil;
}

@end
