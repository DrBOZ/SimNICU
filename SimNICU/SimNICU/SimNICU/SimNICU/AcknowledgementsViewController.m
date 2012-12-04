//
//  AcknowledgementsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 30/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "AcknowledgementsViewController.h"
#import "AppDelegate.h"

@interface AcknowledgementsViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AcknowledgementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"AcknowledgementsViewController viewDidLoad");
	
    self.title = @"Acknowledgements";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //view background
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    //webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20))];
    // self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.userInteractionEnabled = YES;
    self.webView.autoresizesSubviews = YES;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"acknowledgements" ofType:@"html"] isDirectory:NO];
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    [self.webView loadRequest:URLReq];
    
    self.webView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"AcknowledgementsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"AcknowledgementsViewController unloaded properties");
        
        self.webView = nil;
    }
}

- (void)viewDidUnload
{
    self.webView = nil;
}

@end
