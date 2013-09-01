//
//  DailySummaryPDFViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryPDFViewController.h"
#import "HandoverSection.h"
#import "HandoverRow.h"

#define kA4Width 612.0f
#define kA4Height 792.0f
#define kBorderWidth 5.0f
#define kBorderInset 10.0f
#define kMarginInsetLeft 70.0f
#define kMarginInsetRight 10.0f
#define kMarginInsetTop 50.0f
#define kMarginInsetBottom 50.0f
#define kLineWidth 2.0f

#define kLeftPrintingAdjustment 0.0f
#define kRightPrintingAdjustment 306.0f

@interface DailySummaryPDFViewController ()

@property (nonatomic, strong) NSString *fileNamePath;
@property (nonatomic, strong) UIPrintInteractionController *printController;

@end

@implementation DailySummaryPDFViewController
{
    CGSize printableArea;
    
    float topInset;
    float leftInset;
    float rightInset;
    
    float verticalPointToPrint;
    float horizontalPointToPrint;
    float rightSidePointToPrint;
    
    float normalSeparator;
    float headingSeparator;
    
    UIFont *font;
    UIFont *headerFont;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        topInset = kBorderInset + kMarginInsetTop;
        leftInset = kBorderInset + kMarginInsetLeft;
        rightInset = kBorderInset + kMarginInsetRight;
    }
    
    return self;
}

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
    font = [UIFont systemFontOfSize:12.0];
    headerFont = [UIFont boldSystemFontOfSize:12.0f];
    
    normalSeparator = 2.0f;
    headingSeparator = 10.0f;
    
    // point to print
    verticalPointToPrint = 50.0f;
    horizontalPointToPrint = kLeftPrintingAdjustment;
    
    // left hand side of page
    printableArea = CGSizeMake((kA4Width / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), kA4Height - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
    
#pragma mark - Daily Summary
    
    [self drawText:@"Daily Summary"
          withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint];
    
#pragma mark Day
    
    [self drawText:@"day 14"
          withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
    
#pragma mark Gestation
    
    [self drawText:@"26+4/40 now 34+3" withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
     
#pragma mark Weights
    // textToDraw = @"BW 1.55 kg  LW 1.56 CW 1.65 kg (gain of 100g) WW 1.55 kg";
    // textToDraw = @"BW\t1.55 kg\nLW\t1.56 kg\nCW\t1.65 kg (gain of 100g)\nWW\t1.55 kg";
    
    [self drawText:@"BW\t1.55 kg\nLW\t1.56 kg\nCW\t1.65 kg (gain of 100g)\nWW\t1.55 kg"
          withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
    
    // need to loop through the sections to deterine printing height and when to start printing on the right hand side of the paper
    
    HandoverSection *section;
    // HandoverRow *row;
    
    for (section in self.selectedPatient.handoverSections)
    {
        
#pragma mark Background
        if ([section.sectionName isEqual:@"Background"] && ([self.selectedPatient.background length] > 0))
        {
            // set rightSidePointToPrint
            rightSidePointToPrint = verticalPointToPrint;
            
            // header
            [self drawText:@"Background" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.background withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Active Problems
        else if ([section.sectionName isEqual:@"Active Problems"] && ([self.selectedPatient.activeProblems length] > 0))
        {
            // header
            [self drawText:@"Active Problems" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.activeProblems withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Resolved Problems
        else if ([section.sectionName isEqual:@"Resolved Problems"] && ([self.selectedPatient.resolvedProblems length] > 0))
        {
            // header
            [self drawText:@"Resolved Problems" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.resolvedProblems withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Recent Significant Events
        else if ([section.sectionName isEqual:@"Recent Significant Events"] && ([self.selectedPatient.recentSignificantEvents length] > 0))
        {
            // header
            [self drawText:@"Recent Significant Events" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.recentSignificantEvents withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Recent Ventilation & Sedation
        else if ([section.sectionName isEqual:@"Ventilation & Sedation"] && ([self.selectedPatient.ventilationAndSedation length] > 0))
        {
            // header
            [self drawText:@"Ventilation & Sedation" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.ventilationAndSedation withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Recent CXR
        else if ([section.sectionName isEqual:@"CXR"] && ([self.selectedPatient.cxr length] > 0))
        {
            // header
            [self drawText:@"CXR" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.cxr withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Cardiovascular
        else if ([section.sectionName isEqual:@"Cardiovascular"] && ([self.selectedPatient.cardiovascular length] > 0))
        {
            // header
            [self drawText:@"Cardiovascular" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.cardiovascular withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Lines
        else if ([section.sectionName isEqual:@"Lines"] && ([self.selectedPatient.lines length] > 0))
        {
            // header
            [self drawText:@"Lines" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        
            // text
            [self drawText:self.selectedPatient.lines withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Feeds & Fluids
        else if ([section.sectionName isEqual:@"Feeds & Fluids"] && ([self.selectedPatient.feedsAndFluids length] > 0))
        {
            // header
            [self drawText:@"Feeds & Fluids" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.feedsAndFluids withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Fluid Balance
        else if ([section.sectionName isEqual:@"Fluid Balance"] && ([self.selectedPatient.fluidBalance length] > 0))
        {
            // header
            [self drawText:@"Fluid Balance" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.fluidBalance withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
#pragma mark Biochemistry
        else if ([section.sectionName isEqual:@"Biochemistry"] && ([self.selectedPatient.electrolytes length] > 0))
        {
            // header
            [self drawText:@"Biochemistry" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.electrolytes withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
        else if ([section.sectionName isEqual:@"Jaundice"])
        {
            // header
            [self drawText:@"Jaundice" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            NSString *phototherapyChartFiller = @"\n\n\n\n\n\n\n\n\n\n\n";
            
            // text
            [self drawText:phototherapyChartFiller withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
            
            if ([self.selectedPatient.dct length] > 0)
            {
                [self drawText:self.selectedPatient.dct withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
            }
        }
        else if ([section.sectionName isEqual:@"Sepsis"] && ([self.selectedPatient.sepsis length] > 0))
        {
            // header
            [self drawText:@"Sepsis" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.sepsis withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
        else if ([section.sectionName isEqual:@"Drugs"] && ([self.selectedPatient.drugs length] > 0))
        {
            // header
            [self drawText:@"Drugs" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.drugs withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
        else if ([section.sectionName isEqual:@"ROP"] && ([self.selectedPatient.rop length] > 0))
        {
            // header
            [self drawText:@"ROP" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.rop withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
        else if ([section.sectionName isEqual:@"Neurology & Cranial USS"] && ([self.selectedPatient.cranialUSS length] > 0))
        {
            // header
            [self drawText:@"Neurology & Cranial USS" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.cranialUSS withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
        else if ([section.sectionName isEqual:@"Parents & Social"] && ([self.selectedPatient.parentsAndSocial length] > 0))
        {
            // header
            [self drawText:@"Parents & Social" withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
            
            // text
            [self drawText:self.selectedPatient.parentsAndSocial withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
        }
    }



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

- (void)drawText:(NSString *)textToDraw withFont:(UIFont *)textFont onLeftSideOfPageAtVerticalPosition:(float)y
{
    // get the size of the text
    CGSize stringSize = [textToDraw sizeWithFont:textFont
                               constrainedToSize:printableArea
                                   lineBreakMode:UILineBreakModeWordWrap];
    
    // check that there is available space on the left hand side of the page
    if ((verticalPointToPrint >= (kA4Height - kBorderInset - kMarginInsetBottom - stringSize.height)) || (([textFont isEqual:headerFont]) && verticalPointToPrint >= (kA4Height - kBorderInset - kMarginInsetBottom - stringSize.height - 60.0f)))
    {
        // start printing on the right
        y = rightSidePointToPrint + headingSeparator;
        verticalPointToPrint = y;
        horizontalPointToPrint = kRightPrintingAdjustment;
        
        printableArea = CGSizeMake((kA4Width / 2) - (kBorderInset) - (kMarginInsetRight + (kMarginInsetLeft / 2)), kA4Height - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
        
        stringSize = [textToDraw sizeWithFont:textFont
                            constrainedToSize:printableArea
                                lineBreakMode:UILineBreakModeWordWrap];
    }
    
    // create a rectangle to display text based on the text size
    CGRect renderingRect;
    
    if (horizontalPointToPrint == kLeftPrintingAdjustment)
    {
        renderingRect = CGRectMake(leftInset, topInset + y, (kA4Width / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), stringSize.height);
    }
    else
    {
        renderingRect = CGRectMake(horizontalPointToPrint, topInset + y, (kA4Width / 2) - kBorderInset - kMarginInsetRight, stringSize.height);
    }
    
    // draw text
    [textToDraw drawInRect:renderingRect
                  withFont:textFont
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
    
    // update next print point
    verticalPointToPrint = y + stringSize.height;
}

- (void)drawLine
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blueColor].CGColor);
    
    CGPoint startPoint = CGPointMake(kMarginInsetLeft + kBorderInset, kMarginInsetTop + kBorderInset + 40.0);
    CGPoint endPoint = CGPointMake(kA4Width - (kMarginInsetLeft + kMarginInsetRight) - (2 * kBorderInset), kMarginInsetTop + kBorderInset + 40.0);
    
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
