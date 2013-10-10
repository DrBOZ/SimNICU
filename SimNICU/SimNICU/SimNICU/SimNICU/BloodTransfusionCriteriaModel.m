//
//  BloodTransfusionCriteriaModel.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BloodTransfusionCriteriaModel.h"
#import "CBWebView.h"

@implementation BloodTransfusionCriteriaModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:1];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section 0
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 750.0f)
                                         header:@"Transfusion Criteria"
                                       resource:([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","] ? @"bloodTransfusionCriteria0Comma" : @"bloodTransfusionCriteria0")
                                 cellIdentifier:@"TransfusionCriteria"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 165.0f)
                                         header:@"Reticulocytes"
                                       resource:([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","] ? @"bloodTransfusionCriteria1Comma" : @"bloodTransfusionCriteria1")
                                 cellIdentifier:@"Reticulocytes"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 185.0f)
                                         header:NSLocalizedString(@"Frusemide", nil)
                                       resource:@"bloodTransfusionCriteria2"
                                 cellIdentifier:@"Frusemide"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
