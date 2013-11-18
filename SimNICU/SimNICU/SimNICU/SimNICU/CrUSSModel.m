//
//  CrUSSModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CrUSSModel.h"
#import "CBWebView.h"

@implementation CrUSSModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 330.0f)
                                         header:NSLocalizedString(@"Indications", nil)
                                       resource:@"crUSS0"
                                 cellIdentifier:@"cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Two
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 170.0f)
                                         header:NSLocalizedString(@"Timings of scans", nil)
                                       resource:@"crUSS1"
                                 cellIdentifier:@"cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
