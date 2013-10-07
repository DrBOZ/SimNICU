//
//  CurosurfModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CurosurfModel.h"
#import "CBWebView.h"

@implementation CurosurfModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:1];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 235.0f)];
    webView.header = @"Indications";
    webView.resource = @"curosurfIndications";
    webView.cellIdentifier = @"Cell0";
    webView.heightForRowAtIndexPath = @240.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 370.0f)];
    webView.header = @"Doses";
    webView.resource = @"curosurfDoses2";
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @375.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(12.0f, 0.0f, 300.0f, 130.0f)];
    webView.header = @"Further doses";
    webView.resource = @"curosurfFurtherDoses";
    webView.cellIdentifier = @"Cell2";
    webView.heightForRowAtIndexPath = @135.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
