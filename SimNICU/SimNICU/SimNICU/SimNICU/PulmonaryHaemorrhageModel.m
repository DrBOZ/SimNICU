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
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 345.0f)
                                         header:@"Initial Management"
                                       resource:([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","] ? @"pulmonaryHaem0Comma" : @"pulmonaryHaem0")
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
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 230.0f)
                                         header:@"Ongoing Management"
                                       resource:([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","] ? @"pulmonaryHaem2Comma" : @"pulmonaryHaem2")
                                 cellIdentifier:@"Cell02"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 3
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 175.0f)
                                         header:@"With blood results"
                                       resource:([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","] ? @"pulmonaryHaem3Comma" : @"pulmonaryHaem3")
                                 cellIdentifier:@"Cell03"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
