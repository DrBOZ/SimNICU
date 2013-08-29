//
//  DailySummaryPDFViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryPDFViewController.h"
#import "PDFRenderer.h"

@interface DailySummaryPDFViewController ()

@end

@implementation DailySummaryPDFViewController

- (void)viewDidLoad
{
    self.title = @"Daily Summary";
    
    NSString* fileName = [self getPDFFileName];
    
    [PDFRenderer drawPDF:fileName forPatient:self.selectedPatient];
    [self showPDFFile];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPDFFileName
{
    NSString *fileName = @"DailySummary.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString *pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
}

-(void)showPDFFile
{
    NSString* fileName = @"DailySummary.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

@end
