//
//  CFAMIndicationsModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CFAMIndicationsModel.h"
#import "CBWebView.h"

@implementation CFAMIndicationsModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // EEG
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 300.0f)
                                         header:NSLocalizedString(@"Indications", nil)
                                       resource:@"CFAMIndications"
                                 cellIdentifier:@"CFAM Indications"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
