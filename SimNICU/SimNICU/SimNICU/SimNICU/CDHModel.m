//
//  CDHModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CDHModel.h"
#import "CBWebView.h"

@implementation CDHModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 160.0f)
                                         header:@"Delivery Room Care"
                                       resource:@"cdh0"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Number localization code
    NSString *resource;
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
        resource = @"cdh1Comma";
    else
        resource = @"cdh1";
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 695.0f)
                                         header:@"Neonatal Unit"
                                       resource:resource
                                 cellIdentifier:@"Cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 95.0f)
                                         header:@"Surgery"
                                       resource:@"cdh2"
                                 cellIdentifier:@"Cell2"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 265.0f)
                                         header:@"Post-Operative Care"
                                       resource:@"cdh3"
                                 cellIdentifier:@"Cell3"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
