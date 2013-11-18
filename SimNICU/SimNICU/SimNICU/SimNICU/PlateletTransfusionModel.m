//
//  PlateletTransfusionModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PlateletTransfusionModel.h"
#import "CBWebView.h"

@implementation PlateletTransfusionModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:1];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 125.0f)
                                         header:NSLocalizedString(@"Transfusion Criteria", nil)
                                       resource:@"platelets"
                                 cellIdentifier:@"CellIdentifier"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
