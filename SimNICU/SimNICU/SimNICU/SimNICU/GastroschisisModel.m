//
//  GastroschisisModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "GastroschisisModel.h"
#import "CBWebView.h"

@implementation GastroschisisModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 245.0f)
                                         header:@"Delivery Room Care"
                                       resource:@"gastroschisis0"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 135.0f)
                                         header:@"Neonatal Unit"
                                       resource:@"gastroschisis0"
                                 cellIdentifier:@"Cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
