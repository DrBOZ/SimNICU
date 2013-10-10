//
//  CoolingCriteriaEncephalopathyModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CoolingCriteriaEncephalopathyModel.h"
#import "CBWebView.h"

@implementation CoolingCriteriaEncephalopathyModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:3];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 270.0f)
                                         header:@"Moderate to Severe\nEncephalopathy, consisting of"
                                       resource:@"cooling2"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
