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
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 170.0f)
                                              header:@"Delivery Room Care"
                                            resource:@"earlyCare0"
                                      cellIdentifier:@"Cell00"
                             heightForRowAtIndexPath:@175.0f];
    [webViewRows addObject:webView];
    
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 132.0f)
                                              header:nil
                                            resource:@"earlyCare1"
                                      cellIdentifier:@"Cell01"
                             heightForRowAtIndexPath:@137.0f];
    [webViewRows addObject:webView];
    
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 395.0f)
                                              header:nil
                                            resource:@"earlyCare2"
                                      cellIdentifier:@"Cell02"
                             heightForRowAtIndexPath:@230.0f];
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
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 520.0f)
                                              header:@"NICU Admission"
                                            resource:@"earlyCareNICUAdmission"
                                      cellIdentifier:@"Cell2"
                             heightForRowAtIndexPath:@525.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Four
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 340.0f)
                                              header:@"Ventilation Strategies"
                                            resource:@"earlyCareVentStrategies"
                                      cellIdentifier:@"cell3"
                             heightForRowAtIndexPath:@345.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Five
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [EarlyCareModel createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 155.0f)
                                              header:@"Miscellaneous"
                                            resource:@"earlyCareMisc"
                                      cellIdentifier:@"cell4"
                             heightForRowAtIndexPath:@160.0f];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

+ (CBWebView *)createWebViewWithFrame:(CGRect)frame header:(NSString *)header resource:(NSString *)resource cellIdentifier:(NSString *)cellIdentifier heightForRowAtIndexPath:(NSNumber *)height
{
    CBWebView *webView;
    
    webView = [[CBWebView alloc] initWithFrame:frame];
    webView.header = header;
    webView.resource = resource;
    webView.cellIdentifier = cellIdentifier;
    webView.heightForRowAtIndexPath = height;
    [webView loadHMTLPageWithFilename:webView.resource];
    
    return  webView;
}

@end
