//
//  CFAMInterpretationModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CFAMInterpretationModel.h"
#import "CBWebView.h"

@implementation CFAMInterpretationModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Normal Tracing
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 270.0f)
                                         header:NSLocalizedString(@"Normal Tracing", nil)
                                       resource:@"CFAMNormal"
                                 cellIdentifier:@"Normal Tracing"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Moderately Abnormal Tracing
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 270.0f)
                                         header:NSLocalizedString(@"Moderately Abnormal", nil)
                                       resource:@"CFAMModeratelyAbnormal"
                                 cellIdentifier:@"Moderately Abnormal"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Severely Abnormal Tracing
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 200.0f)
                                         header:NSLocalizedString(@"Severely Abnormal", nil)
                                       resource:@"CFAMSeverelyAbnormal"
                                 cellIdentifier:@"Severely Abnormal"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Seizures
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 420.0f)
                                         header:NSLocalizedString(@"Seizures", nil)
                                       resource:@"CFAMSeizures"
                                 cellIdentifier:@"Seizures"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
