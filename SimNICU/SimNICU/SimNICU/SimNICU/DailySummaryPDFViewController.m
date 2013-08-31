//
//  DailySummaryPDFViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryPDFViewController.h"

#define kA4Width 612.0f
#define kA4Height 792.0f
#define kBorderWidth 5.0f
#define kBorderInset 10.0f
#define kMarginInset 10.0f
#define kLineWidth 2.0f

@interface DailySummaryPDFViewController ()

@property (nonatomic, strong) NSString *fileNamePath;
@property (nonatomic, strong) UIPrintInteractionController *printController;

@end

@implementation DailySummaryPDFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set title
    self.title = @"Daily Summary";
    
    Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
    
    if (printControllerClass)
    {
        self.printController = [printControllerClass sharedPrintController];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *itemPrint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(print)];
        itemPrint.tag = 1;
        
        NSArray *items = [NSArray arrayWithObjects:flexibleItem, itemPrint, flexibleItem, nil];
        self.toolbarItems = items;
    }
    
    // create file name
    NSString *fileName = @"dailySummary.pdf";
    
    // obtain full path to file
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = arrayPaths[0];
    self.fileNamePath = [path stringByAppendingPathComponent:fileName];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(self.fileNamePath, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0f, 0.0f, kA4Width, kA4Height), nil);
    
    // create summary
    
    // [self drawLine];  this works
    
    // [self drawBorder]; this works
    
    // draw image - this works
    // UIImage *icon = [UIImage imageNamed:@"ray-logo.png"];
    // [self.phototherapyChart drawInRect:CGRectMake(320.0f - ((self.phototherapyChart.size.width / 2) / 2), 400.0f, (self.phototherapyChart.size.width / 2), (self.phototherapyChart.size.height / 2))];
    // [self.phototherapyChart drawInRect:CGRectMake(10.0f, 400.0f, (self.phototherapyChart.size.width / 2), (self.phototherapyChart.size.height / 2))];
    
    // draw text
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // set text colour (red, green, blue, alpha)
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    // set text
    NSString *textToDraw = @"Daily Summary";
    
    UIFont *font = [UIFont systemFontOfSize:14.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font
                               constrainedToSize:CGSizeMake(kA4Width - 2*kBorderInset-2*kMarginInset, kA4Height - 2*kBorderInset - 2*kMarginInset)
                                   lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, kA4Width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    
    [textToDraw drawInRect:renderingRect
                  withFont:font
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
#pragma mark Jaundice
    textToDraw = @"Jaundice";
    
    font = [UIFont systemFontOfSize:14.0];
    
    stringSize = [textToDraw sizeWithFont:font
                               constrainedToSize:CGSizeMake(kA4Width - 2*kBorderInset-2*kMarginInset, kA4Height - 2*kBorderInset - 2*kMarginInset)
                                   lineBreakMode:UILineBreakModeWordWrap];
    
    renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 100.0, kA4Width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
    
    [textToDraw drawInRect:renderingRect
                  withFont:font
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
    
    
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    // display PDF
    [self displayPDF];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawLine
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    
    CGPoint startPoint = CGPointMake(kMarginInset + kBorderInset, kMarginInset + kBorderInset + 40.0);
    CGPoint endPoint = CGPointMake(kA4Width - 2*kMarginInset -2*kBorderInset, kMarginInset + kBorderInset + 40.0);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void)drawBorder
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    UIColor *borderColor = [UIColor brownColor];
    CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, kA4Width-kBorderInset*2, kA4Height-kBorderInset*2);
    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, kBorderWidth);
    CGContextStrokeRect(currentContext, rectFrame);
}

- (void)displayPDF
{
    // create webView to display PDF
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    
    NSURL *url = [NSURL fileURLWithPath:self.fileNamePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (void)print
{
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error) NSLog(@"Print error: %@", error);
    };
    
    NSData *pdfData = [NSData dataWithContentsOfFile:self.fileNamePath];
    self.printController.printingItem = pdfData;
    
    [self.printController presentAnimated:YES completionHandler:completionHandler];
}

- (void)deleteFile
{
    [[NSFileManager defaultManager] removeItemAtPath:self.fileNamePath error:nil];
}

@end
