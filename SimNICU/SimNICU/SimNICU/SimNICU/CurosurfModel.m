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
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 235.0f)
                                         header:@"Indications"
                                       resource:@"curosurfIndications"
                                 cellIdentifier:@"Cell0"
                        heightForRowAtIndexPath:@240.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 370.0f)
                                         header:@"Doses"
                                       resource:@"curosurfDoses2"
                                 cellIdentifier:@"Cell1"
                        heightForRowAtIndexPath:@375.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(12.0f, 0.0f, 300.0f, 130.0f)
                                         header:@"Further doses"
                                       resource:@"curosurfFurtherDoses"
                                 cellIdentifier:@"Cell2"
                        heightForRowAtIndexPath:@135.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
