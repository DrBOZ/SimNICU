//
//  PulmonaryHaemorrhageModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 07/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PulmonaryHaemorrhageModel.h"
#import "CBWebView.h"

@implementation PulmonaryHaemorrhageModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:4];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 345.0f)];
    webView.header = @"Initial Management";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem0Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem0";
    }
    webView.cellIdentifier = @"Cell0";
    webView.heightForRowAtIndexPath = @350.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 175.0f)];
    webView.header = @"Investigations";
    webView.resource = @"pulmonaryHaem1";
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @180.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 230.0f)];
    webView.header = @"Ongoing Management";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem2Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem2";
    }
    webView.cellIdentifier = @"Cell02";
    webView.heightForRowAtIndexPath = @235.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 3
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 175.0f)];
    webView.header = @"With blood results";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"pulmonaryHaem3Comma";
    }
    else
    {
        webView.resource = @"pulmonaryHaem3";
    }
    webView.cellIdentifier = @"Cell03";
    webView.heightForRowAtIndexPath = @180.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
