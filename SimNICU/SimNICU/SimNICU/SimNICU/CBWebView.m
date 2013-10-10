//
//  CBWebView.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBWebView.h"

@implementation CBWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.scalesPageToFit = NO;
        
        if ([self respondsToSelector:@selector(scrollView)])
        {
            self.scrollView.scrollEnabled = NO;
        }
        else
        {
            for (id subview in self.subviews)
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).scrollEnabled = NO;
        }
        
        self.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return self;
}

+ (CBWebView *)createWebViewWithFrame:(CGRect)frame header:(NSString *)header resource:(NSString *)resource cellIdentifier:(NSString *)cellIdentifier heightForRowAtIndexPath:(NSNumber *)height
{
    CBWebView *webView;
    
    webView = [[CBWebView alloc] initWithFrame:frame];
    webView.header = header;
    webView.resource = resource;
    webView.cellIdentifier = cellIdentifier;
    webView.heightForRowAtIndexPath = height;
    [webView loadHMTLPageWithFilename:webView.resource];
    
    return  webView;
}

- (void)loadHMTLPageWithFilename:(NSString *)filename
{
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"] isDirectory:NO];
    
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    
    [self loadRequest:URLReq];
}

@end
