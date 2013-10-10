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
    
    // Number localization code
    NSString *resource;
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
        resource = @"pulmonaryHaem0Comma";
    else
        resource = @"pulmonaryHaem0";
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 345.0f)
                                         header:@"Initial Management"
                                       resource:resource
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 175.0f)
                                         header:@"Investigations"
                                       resource:@"pulmonaryHaem1"
                                 cellIdentifier:@"Cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
        resource = @"pulmonaryHaem2Comma";
    else
        resource = @"pulmonaryHaem2";
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 230.0f)
                                         header:@"Ongoing Management"
                                       resource:resource
                                 cellIdentifier:@"Cell02"];
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
