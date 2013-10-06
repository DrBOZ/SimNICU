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
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 1000.0f)];
    webView.header = @"Transfusion Criteria";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"bloodTransfusionCriteria0Comma";
    }
    else
    {
        webView.resource = @"bloodTransfusionCriteria0";
    }
    webView.cellIdentifier = @"TransfusionCriteria";
    webView.heightForRowAtIndexPath = @755.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 1
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 1000.0f)];
    webView.header = @"Reticulocytes";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"bloodTransfusionCriteria1Comma";
    }
    else
    {
        webView.resource = @"bloodTransfusionCriteria1";
    }
    webView.cellIdentifier = @"Reticulocytes";
    webView.heightForRowAtIndexPath = @170.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section 2
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 1000.0f)];
    webView.header = NSLocalizedString(@"Frusemide", nil);
    webView.resource = @"bloodTransfusionCriteria2";
    webView.cellIdentifier = @"Frusemide";
    webView.heightForRowAtIndexPath = @190.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
