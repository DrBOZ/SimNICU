//
//  EarlyCareModel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 09/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "EarlyCareModel.h"
#import "CBWebView.h"

@implementation EarlyCareModel

+ (NSArray *)webViews
{
    NSMutableArray *webViewSections = [[NSMutableArray alloc] initWithCapacity:2];
    
    CBWebView *webView;
    NSMutableArray *webViewRows;
    
    // Section One
    webViewRows = [[NSMutableArray alloc] initWithCapacity:3];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 170.0f)];
    webView.header = @"Delivery Room Care";
    webView.resource = @"earlyCare0";
    webView.cellIdentifier = @"Cell00";
    webView.heightForRowAtIndexPath = @175.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 132.0f)];
    webView.header = nil;
    webView.resource = @"earlyCare1";
    webView.cellIdentifier = @"Cell01";
    webView.heightForRowAtIndexPath = @137.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 395.0f)];
    webView.header = nil;
    webView.resource = @"earlyCare2";
    webView.cellIdentifier = @"Cell02";
    webView.heightForRowAtIndexPath = @230.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section Two
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 155.0f)];
    webView.header = @"Initial Ventilator Settings";
    // Number localization code
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        webView.resource = @"earlyCareVentSettingsComma";
    }
    else
    {
        webView.resource = @"earlyCareVentSettings";
    }
    webView.cellIdentifier = @"Cell1";
    webView.heightForRowAtIndexPath = @160.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section Three
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 520.0f)];
    webView.header = @"NICU Admission";
    webView.resource = @"earlyCareNICUAdmission";
    webView.cellIdentifier = @"Cell2";
    webView.heightForRowAtIndexPath = @525.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section Four
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 340.0f)];
    webView.header = @"Ventilation Strategies";
    webView.resource = @"earlyCareVentStrategies";
    webView.cellIdentifier = @"cell3";
    webView.heightForRowAtIndexPath = @345.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    // Section Five
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [[CBWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 155.0f)];
    webView.header = @"Miscellaneous";
    webView.resource = @"earlyCareMisc";
    webView.cellIdentifier = @"cell4";
    webView.heightForRowAtIndexPath = @160.0f;
    [webView loadHMTLPageWithFilename:webView.resource];
    [webViewRows addObject:webView];
    
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
