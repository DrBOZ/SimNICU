//
//  HFOVModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HFOVModel.h"
#import "CBWebView.h"

@implementation HFOVModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 335.0f)
                                         header:@"Commencing HFOV"
                                       resource:@"hfov0"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 185.0f)
                                         header:@"Adjustments"
                                       resource:@"hfov1"
                                 cellIdentifier:@"Cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
