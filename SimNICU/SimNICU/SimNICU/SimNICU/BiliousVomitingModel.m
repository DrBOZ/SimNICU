//
//  BiliousVomitingModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BiliousVomitingModel.h"
#import "CBWebView.h"

@implementation BiliousVomitingModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 310.0f, 445.0f)
                                         header:@"Presentation"
                                       resource:@"biliousVomiting"
                                 cellIdentifier:@"Cell0"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    //    // Section 1
    //    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    //    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 310.0f, 445.0f)
    //                                         header:@"Urate Crystals"
    //                                       resource:@"withdrawlBleed"
    //                                 cellIdentifier:@"Cell1"];
    //    [webViewRows addObject:webView];
    //    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
