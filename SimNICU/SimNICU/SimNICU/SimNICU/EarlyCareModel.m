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
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 170.0f)
                                         header:@"Delivery Room Care"
                                       resource:@"earlyCare0"
                                 cellIdentifier:@"Cell00"];
    [webViewRows addObject:webView];
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 132.0f)
                                         header:nil
                                       resource:@"earlyCare1"
                                 cellIdentifier:@"Cell01"];
    [webViewRows addObject:webView];
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 225.0f)
                                         header:nil
                                       resource:@"earlyCare2"
                                 cellIdentifier:@"Cell02"];
    
    /*
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 395.0f)
                                         header:nil
                                       resource:@"earlyCare2"
                                 cellIdentifier:@"Cell02"
                        heightForRowAtIndexPath:@230.0f];
     */
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Two
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    
    // Number localization code
    NSString *resource;
    
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
        resource = @"earlyCareVentSettingsComma";
    else
        resource = @"earlyCareVentSettings";
    
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 155.0f)
                                         header:@"Initial Ventilator Settings"
                                       resource:resource
                                 cellIdentifier:@"Cell1"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Three
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 520.0f)
                                         header:@"NICU Admission"
                                       resource:@"earlyCareNICUAdmission"
                                 cellIdentifier:@"Cell2"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Four
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 340.0f)
                                         header:@"Ventilation Strategies"
                                       resource:@"earlyCareVentStrategies"
                                 cellIdentifier:@"cell3"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    // Section Five
    webViewRows = [[NSMutableArray alloc] initWithCapacity:1];
    webView = [CBWebView createWebViewWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 155.0f)
                                         header:@"Miscellaneous"
                                       resource:@"earlyCareMisc"
                                 cellIdentifier:@"cell4"];
    [webViewRows addObject:webView];
    [webViewSections addObject:webViewRows];
    
    return webViewSections;
}

@end
