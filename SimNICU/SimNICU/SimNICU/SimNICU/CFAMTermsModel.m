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
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"EEG", nil)
                                       resource:@"eeg"
                                 cellIdentifier:@"EEG"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // aEEG
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"aEEG", nil)
                                       resource:@"aeeg"
                                 cellIdentifier:@"aEEG"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // electrode
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Electrode", nil)
                                       resource:@"electrode"
                                 cellIdentifier:@"Electrode"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // artefact
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Artefact", nil)
                                       resource:@"artefact"
                                 cellIdentifier:@"Artefact"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // amplitude
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Amplitude", nil)
                                       resource:@"amplitude"
                                 cellIdentifier:@"Amplitude"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // impedance
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Impedance", nil)
                                       resource:@"impedance"
                                 cellIdentifier:@"Impedance"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // upper margin
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Upper Margin", nil)
                                       resource:@"upperMargin"
                                 cellIdentifier:@"Upper Margin"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // lower margin
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Lower Margin", nil)
                                       resource:@"lowerMargin"
                                 cellIdentifier:@"Lower Margin"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // burst suppression
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 45.0f)
                                         header:NSLocalizedString(@"Burst Suppression", nil)
                                       resource:@"burstSuppression"
                                 cellIdentifier:@"Burst Suppression"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
