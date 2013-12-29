//
//  TongueTieModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "TongueTieModel.h"
#import "CBWebView.h"

@implementation TongueTieModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 310.0f, 645.0f)
                                         header:@"General"
                                       resource:@"tonguetie"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
