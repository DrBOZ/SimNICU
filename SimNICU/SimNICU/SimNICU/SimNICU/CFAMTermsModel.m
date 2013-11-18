//
//  CFAMTermsModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CFAMTermsModel.h"
#import "CBWebView.h"

@implementation CFAMTermsModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // EEG
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 330.0f)];
    webView.header = @"EEG";
    webView.resource = @"eeg";
    webView.cellIdentifier = @"EEG";
    webView.heightForRowAtIndexPath = @335.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // aEEG
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 170.0f)];
    webView.header = @"aEEG";
    webView.resource = @"aeeg";
    webView.cellIdentifier = @"aEEG";
    webView.heightForRowAtIndexPath = @175.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // electrode
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 170.0f)];
    webView.header = @"Electrode";
    webView.resource = @"electrode";
    webView.cellIdentifier = @"Electrode";
    webView.heightForRowAtIndexPath = @175.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
