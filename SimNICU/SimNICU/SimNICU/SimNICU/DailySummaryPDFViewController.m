//
//  DailySummaryPDFViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DailySummaryPDFViewController.h"
#import "HandoverSection.h"
#import "CBTimeMethods.h"
#import "HandoverRow.h"
#import "Bay.h"

#define kA0Width 2384.0f
#define kA0Height 3371.0f

#define kA1Width 1685.0f
#define kA1Height 2384.0f

#define kA2Width 1190.0f
#define kA2Height 1684.0f

#define kA3Width 842.0f
#define kA3Height 1190.0f

#define kA4Width 595.0f
#define kA4Height 842.0f

#define kLetterWidth 612.0f
#define kLetterHeight 792.0f

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

@property (nonatomic, strong) UIPrintInteractionController *printController;
@property (nonatomic, strong) NSString *fileNamePath;
@property (nonatomic, strong) UIWebView *webView;

- (void)drawSignature;
- (void)drawBorder;

@end

@implementation DailySummaryPDFViewController
{
    float pageWidth;
    float pageHeight;
    
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
    
    int page;
    
    BOOL displayLinesToWriteOn;
    
    int selectedBay;
    int selectedPatientInBay;
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
    
    selectedPatientInBay = [self.selectedPatientInBayNSNumber intValue];
    selectedBay = [self.selectedBayNSNumber intValue];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // create webView to display PDF
    if (!self.webView)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, (appDelegate.window.bounds.size.height) - 64.0f - 44.0f)];
            [self.webView setScalesPageToFit:YES];
            
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.webView.scrollView.pagingEnabled = YES;
        }
        else
        {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 44.0f))];
            [self.webView setScalesPageToFit:YES];
        }
        
        [self.view addSubview:self.webView];
    }
    
    // setup Print Controller
    Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
    self.printController = [printControllerClass sharedPrintController];
    
    // setup toolbar
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *itemRewind = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousPatientButtonPressed)];
    itemRewind.tag = 2;
    UIBarButtonItem *itemFastForward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextPatientButtonPressed:)];
    itemFastForward.tag = 3;
    UIBarButtonItem *itemPrint = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(print)];
    itemPrint.tag = 1;
    
    NSArray *items;
    
    if (printControllerClass)
    {
        items = [NSArray arrayWithObjects:itemRewind, flexibleItem, itemPrint, flexibleItem, itemFastForward, nil];
    }
    else
    {
        items = [NSArray arrayWithObjects:itemRewind, flexibleItem, flexibleItem, flexibleItem, itemFastForward, nil];
    }
    
    self.toolbarItems = items;
    
    // Get page size
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.paperSize isEqualToString:@"A4"])
    {
        pageWidth = kA4Width;
        pageHeight = kA4Height;
    }
    else
    {
        pageWidth = kLetterWidth;
        pageHeight = kLetterHeight;
    }
    
    // create file name
    NSString *fileName = @"dailySummary2.pdf";
    
    // obtain full path to file
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = arrayPaths[0];
    self.fileNamePath = [path stringByAppendingPathComponent:fileName];
    
    // Create the PDF context using page size
    UIGraphicsBeginPDFContextToFile(self.fileNamePath, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0f, 0.0f, pageWidth, pageHeight), nil);
    
    // create summary
    
    // display patient's name & birthDate
    NSString *nameAndBirthDateText;
    
    if (self.selectedPatient.birthDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone localTimeZone];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        nameAndBirthDateText = [NSString stringWithFormat:@"%@ (%@)", [self.selectedPatient returnDisplayTextLabelText], [formatter stringFromDate:self.selectedPatient.birthDate]];
    }
    else
    {
        nameAndBirthDateText = [self.selectedPatient returnDisplayTextLabelText];
    }
    
    [self drawText:nameAndBirthDateText withFont:[UIFont boldSystemFontOfSize:15.0f] atVerticalPosition:10.0f];
    
    // Draw a line at the top
    [self drawLineAboveDailySummaryText];
    
    // Draw border
    [self drawBorder];
    
    // Draw logo
    [self drawLogo];
    
    // draw text
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // set text colour (red, green, blue, alpha)
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    // set text
    font = [UIFont systemFontOfSize:12.0];
    headerFont = [UIFont boldSystemFontOfSize:12.0f];
    
    // set page number
    page = 1;
    
    normalSeparator = 2.0f;
    headingSeparator = 10.0f;
    
    // point to print
    verticalPointToPrint = 50.0f;
    horizontalPointToPrint = kLeftPrintingAdjustment;
    
    // left hand side of page
    printableArea = CGSizeMake((pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), pageHeight - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
    
#pragma mark Date and Time
    
    CGFloat dateAndTimeAdjustment = -80.0;
    
    // date
    NSDate *currentDateAndTime = [NSDate date];
    
    // create a rectangle to display text based on the page size
    CGRect renderingRect = CGRectMake(20.0f, topInset + verticalPointToPrint + dateAndTimeAdjustment, pageWidth - (kBorderInset * 2) - (kMarginInsetLeft + kMarginInsetRight), 22.0f);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    NSString *date = [NSString stringWithFormat:@"%@", [formatter stringFromDate:currentDateAndTime]];
    
    // draw text
    [date drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    // time
    // create a rectangle to display text based on the page size
    renderingRect = CGRectMake(20.0f, topInset + verticalPointToPrint + (dateAndTimeAdjustment + 18.0f), pageWidth - (kBorderInset * 2) - (kMarginInsetLeft + kMarginInsetRight), 22.0f);
    
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    date = [formatter stringFromDate:currentDateAndTime];
    
    // draw text
    [date drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
#pragma mark - Daily Summary
    
    [self drawText:@"Daily Summary"
          withFont:headerFont onLeftSideOfPageAtVerticalPosition:verticalPointToPrint];
    
#pragma mark Day
    
    NSString *dayText = nil;
    
    if (self.selectedPatient.birthDate)
    {
        NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.selectedPatient.birthDate and:[NSDate date]];
        
        NSString *correctedAge = formattedDates[2];
        
        // display days and corrected age
        dayText = [NSString stringWithFormat:@"day %i (%@)", [CBTimeMethods getDaysDifferenceIntBetween:self.selectedPatient.birthDate and:[NSDate date]], correctedAge];
    }
    
    [self drawText:dayText
          withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
    
#pragma mark Gestation
    
    // get gestation data
    NSString *gestationText = nil;
    
    gestationText = [self.selectedPatient returnGestationAndCorrectedGestationOnly];
    
    [self drawText:gestationText withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + normalSeparator];
     
#pragma mark Weights
    // textToDraw = @"BW 1.55 kg  LW 1.56 CW 1.65 kg (gain of 100g) WW 1.55 kg";
    // textToDraw = @"BW\t1.55 kg\nLW\t1.56 kg\nCW\t1.65 kg (gain of 100g)\nWW\t1.55 kg";
    
    NSString *birthWeightText = nil;
    NSString *workingWeightText = nil;
    
    if (self.selectedPatient.birthWeight)
    {
        birthWeightText = [Patient formatWeight:self.selectedPatient.birthWeight];
    }
    
    if (self.selectedPatient.workingWeight)
    {
        workingWeightText = [Patient formatWeight:self.selectedPatient.workingWeight];
    }
    
    // @"BW\t1.55 kg\nLW\t1.56 kg\nCW\t1.65 kg (gain of 100g)\nWW\t1.55 kg"
    
    NSString *text = [NSString stringWithFormat:@"BW\t%@\nWW\t%@", birthWeightText, workingWeightText];
    
    [self drawText:text
          withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
    
    // need to loop through the sections to deterine printing height and when to start printing on the right hand side of the paper
    
    HandoverSection *section;
    // HandoverRow *row;
    
    for (section in self.selectedPatient.handoverSections) // longwinded but may be useful later...
    {
#pragma mark Background
        if ([section.sectionName isEqual:@"Background"] && ([self.selectedPatient.background length] > 0))
        {
            // set rightSidePointToPrint
            rightSidePointToPrint = verticalPointToPrint;
            
            [self drawHeaderText:@"Background"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.background
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Active Problems
        else if ([section.sectionName isEqual:@"Active Problems"] && ([self.selectedPatient.activeProblems length] > 0))
        {
            [self drawHeaderText:@"Active Problems"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.activeProblems
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Resolved Problems
        else if ([section.sectionName isEqual:@"Resolved Problems"] && ([self.selectedPatient.resolvedProblems length] > 0))
        {
            [self drawHeaderText:@"Resolved Problems"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.resolvedProblems
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Recent Significant Events
        else if ([section.sectionName isEqual:@"Recent Significant Events"] && ([self.selectedPatient.recentSignificantEvents length] > 0))
        {
            [self drawHeaderText:@"Recent Significant Events"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.recentSignificantEvents
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Recent Ventilation & Sedation
        else if ([section.sectionName isEqual:@"Ventilation & Sedation"] && ([self.selectedPatient.ventilationAndSedation length] > 0))
        {
            [self drawHeaderText:@"Ventilation & Sedation"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.ventilationAndSedation
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Recent CXR
        else if ([section.sectionName isEqual:@"CXR"] && ([self.selectedPatient.cxr length] > 0))
        {
            [self drawHeaderText:@"CXR"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.cxr
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Cardiovascular
        else if ([section.sectionName isEqual:@"Cardiovascular"] && ([self.selectedPatient.cardiovascular length] > 0))
        {
            [self drawHeaderText:@"Cardiovascular"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.cardiovascular
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Lines
        else if ([section.sectionName isEqual:@"Lines"] && ([self.selectedPatient.lines length] > 0))
        {
            [self drawHeaderText:@"Lines"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.lines
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Feeds & Fluids
        else if ([section.sectionName isEqual:@"Feeds & Fluids"] && ([self.selectedPatient.feedsAndFluids length] > 0))
        {
            [self drawHeaderText:@"Feeds & Fluids"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.feedsAndFluids
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Fluid Balance
        else if ([section.sectionName isEqual:@"Fluid Balance"] && ([self.selectedPatient.fluidBalance length] > 0))
        {
            [self drawHeaderText:@"Fluid Balance"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.fluidBalance
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Biochemistry
        else if ([section.sectionName isEqual:@"Biochemistry"] && ([self.selectedPatient.electrolytes length] > 0))
        {
            [self drawHeaderText:@"Biochemistry"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.electrolytes
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Jaundice
        else if ([section.sectionName isEqual:@"Jaundice"] && ([self.selectedPatient.jaundice length] > 0))
        {
            [self drawHeaderText:@"Jaundice"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.jaundice
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Sepsis
        else if ([section.sectionName isEqual:@"Sepsis"] && ([self.selectedPatient.sepsis length] > 0))
        {
            [self drawHeaderText:@"Sepsis"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.sepsis
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Drugs
        else if ([section.sectionName isEqual:@"Drugs"] && ([self.selectedPatient.drugs length] > 0))
        {
            [self drawHeaderText:@"Drugs"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.drugs
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark ROP
        else if ([section.sectionName isEqual:@"ROP"] && ([self.selectedPatient.rop length] > 0))
        {
            [self drawHeaderText:@"ROP"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.rop
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Neurology & Cranial USS
        else if ([section.sectionName isEqual:@"Neurology & Cranial USS"] && ([self.selectedPatient.cranialUSS length] > 0))
        {
            [self drawHeaderText:@"Neurology & Cranial USS"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.cranialUSS
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Parents & Social
        else if ([section.sectionName isEqual:@"Parents & Social"] && ([self.selectedPatient.parentsAndSocial length] > 0))
        {
            [self drawHeaderText:@"Parents & Social"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.parentsAndSocial
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Examination
        else if ([section.sectionName isEqual:@"Examination"] && ([self.selectedPatient.impression length] > 0))
        {
            [self drawHeaderText:@"Examination"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.impression
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Summary
        else if ([section.sectionName isEqual:@"Summary"] && ([self.selectedPatient.plan length] > 0))
        {
            [self drawHeaderText:@"Summary"
                        withFont:headerFont
                     andBodyText:self.selectedPatient.plan
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
#pragma mark Plan
        else if ([section.sectionName isEqual:@"Plan"] && ([self.selectedPatient.jobs length] > 0))
        {
            NSString *planWithAddedCarriageReturns;
            
            planWithAddedCarriageReturns = [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n", self.selectedPatient.jobs];
            
            [self drawHeaderText:@"Plan"
                        withFont:headerFont
                     andBodyText:planWithAddedCarriageReturns
                        withFont:font onLeftSideOfPageAtVerticalPosition:verticalPointToPrint + headingSeparator];
        }
    }
    
    // Print lines
    if (displayLinesToWriteOn)
    {
        // draw lines starting at y
        [self drawLinesStartingAtVerticalPosition:verticalPointToPrint + topInset + headingSeparator];
    }
    
    // draw signature line & draw my name, status and GMC number
    [self drawSignature];

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

- (void)drawText:(NSString *)textToDraw withFont:(UIFont *)textFont atVerticalPosition:(float)y
{
    // create a rectangle to display text based on the page size
    CGRect renderingRect = CGRectMake(leftInset, topInset + y, pageWidth - (kBorderInset * 2) - (kMarginInsetLeft + kMarginInsetRight), 22.0f);
    
    // draw text
    [textToDraw drawInRect:renderingRect
                  withFont:textFont
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
}

- (void)drawHeaderText:(NSString *)theHeaderText withFont:(UIFont *)theHeaderFont andBodyText:(NSString *)theBodyText withFont:(UIFont *)theBodyFont onLeftSideOfPageAtVerticalPosition:(float)y
{
    // get the size of both the header text and the body text
    CGSize theHeaderTextSize = [theHeaderText sizeWithFont:theHeaderFont constrainedToSize:printableArea lineBreakMode:UILineBreakModeWordWrap];
    CGSize theBodyTextSize = [theBodyText sizeWithFont:theBodyFont constrainedToSize:printableArea lineBreakMode:UILineBreakModeWordWrap];
    
    float combinedTextHeight = theHeaderTextSize.height + normalSeparator + theBodyTextSize.height;
    
    // check that there is available vertical space on the page
    if (topInset + y >= (pageHeight - kBorderInset - kMarginInsetBottom - combinedTextHeight))
    {
        // No, there is not enought space...
        
        // so check if already printing on the right
        if (horizontalPointToPrint == kRightPrintingAdjustment)
        {
            // Yes, so start a new page...
            
            // Mark the beginning of the new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0f, 0.0f, pageWidth, pageHeight), nil);
            
            // Draw Logo
            [self drawLogo];
            
            // Draw Patient name +/- birthDate
            NSString *nameAndBirthDateText;
            
            if (self.selectedPatient.birthDate)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone localTimeZone];
                formatter.dateStyle = NSDateFormatterShortStyle;
                formatter.timeStyle = NSDateFormatterNoStyle;
                
                nameAndBirthDateText = [NSString stringWithFormat:@"%@ (%@)", [self.selectedPatient returnDisplayTextLabelText], [formatter stringFromDate:self.selectedPatient.birthDate]];
            }
            else
            {
                nameAndBirthDateText = [self.selectedPatient returnDisplayTextLabelText];
            }
            
            [self drawText:nameAndBirthDateText withFont:[UIFont boldSystemFontOfSize:15.0f] atVerticalPosition:10.0f];
            
            // Draw Line
            [self drawLineAboveDailySummaryText];
            
            // Draw border
            [self drawBorder];
            
            // reset counters for 2nd page
            y = 50.0f;
            verticalPointToPrint = y;
            horizontalPointToPrint = kLeftPrintingAdjustment;
            
            // reset printable area as printhead to left hand side of page
            printableArea = CGSizeMake((pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), pageHeight - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
            
            /*
            stringSize = [textToDraw sizeWithFont:textFont
                                constrainedToSize:printableArea
                                    lineBreakMode:UILineBreakModeWordWrap];
             */
            
            // get the size of both the header text and the body text
            theHeaderTextSize = [theHeaderText sizeWithFont:theHeaderFont
                                          constrainedToSize:printableArea
                                              lineBreakMode:UILineBreakModeWordWrap];
            
            theBodyTextSize = [theBodyText sizeWithFont:theBodyFont
                                      constrainedToSize:printableArea
                                          lineBreakMode:UILineBreakModeWordWrap];
            
            combinedTextHeight = theHeaderTextSize.height + theBodyTextSize.height;
            
            // set flag to produce lines to write on
            displayLinesToWriteOn = YES;
            
            // increment page
            page = 2;
        }
        else
        {
            // if not then start printing on the right
            
            // first check which page
            // check if on first page or subsequent pages
            if (page == 1)
            {
                // set print position to match Background information
                y = rightSidePointToPrint + headingSeparator;
            }
            
            verticalPointToPrint = y;
            horizontalPointToPrint = kRightPrintingAdjustment;
            
            printableArea = CGSizeMake((pageWidth / 2) - (kBorderInset) - (kMarginInsetRight), pageHeight - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
            
            /*
            stringSize = [textToDraw sizeWithFont:textFont
                                constrainedToSize:printableArea
                                    lineBreakMode:UILineBreakModeWordWrap];
             */
            
            // get the size of both the header text and the body text with new printable area
            theHeaderTextSize = [theHeaderText sizeWithFont:theHeaderFont constrainedToSize:printableArea lineBreakMode:UILineBreakModeWordWrap];
            theBodyTextSize = [theBodyText sizeWithFont:theBodyFont constrainedToSize:printableArea lineBreakMode:UILineBreakModeWordWrap];
        }
    }
    
    // create a rectangle to display Header text based on the text size
    CGRect renderingRect;
    
    if (horizontalPointToPrint == kLeftPrintingAdjustment)
    {
        renderingRect = CGRectMake(leftInset, topInset + y, (pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), theHeaderTextSize.height);
    }
    else
    {
        renderingRect = CGRectMake(horizontalPointToPrint, topInset + y, (pageWidth / 2) - kBorderInset - kMarginInsetRight, theHeaderTextSize.height);
    }
    
    // draw text
    [theHeaderText drawInRect:renderingRect
                  withFont:theHeaderFont
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
    
    // increment print head vertical position
    y = y + theHeaderTextSize.height + normalSeparator;
    
    // create a rectangle to display body text based on the text size
    if (horizontalPointToPrint == kLeftPrintingAdjustment)
    {
        renderingRect = CGRectMake(leftInset, topInset + y, (pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), theBodyTextSize.height);
    }
    else
    {
        renderingRect = CGRectMake(horizontalPointToPrint, topInset + y, (pageWidth / 2) - kBorderInset - kMarginInsetRight, theBodyTextSize.height);
    }
    
    // draw text
    [theBodyText drawInRect:renderingRect
                  withFont:theBodyFont
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
    
    // update next print point
    verticalPointToPrint = y + theBodyTextSize.height;
}

- (void)drawText:(NSString *)textToDraw withFont:(UIFont *)textFont onLeftSideOfPageAtVerticalPosition:(float)y
{
    // get the size of the text
    CGSize stringSize = [textToDraw sizeWithFont:textFont
                               constrainedToSize:printableArea
                                   lineBreakMode:UILineBreakModeWordWrap];
    
    // check that there is available vertical space on the page
    if ((verticalPointToPrint >= (pageHeight - kBorderInset - kMarginInsetBottom - stringSize.height)) || (([textFont isEqual:headerFont]) && verticalPointToPrint >= (pageHeight - kBorderInset - kMarginInsetBottom - stringSize.height - 60.0f)))
    {
        // check if already printing on the right
        if (horizontalPointToPrint == kRightPrintingAdjustment)
        {
            // Mark the beginning of a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0f, 0.0f, pageWidth, pageHeight), nil);
            
            // Draw Logo
            [self drawLogo];
            
            // Draw Patient name +/- birthDate
            NSString *nameAndBirthDateText;
            
            if (self.selectedPatient.birthDate)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.timeZone = [NSTimeZone localTimeZone];
                formatter.dateStyle = NSDateFormatterShortStyle;
                formatter.timeStyle = NSDateFormatterNoStyle;
                
                nameAndBirthDateText = [NSString stringWithFormat:@"%@ (%@)", [self.selectedPatient returnDisplayTextLabelText], [formatter stringFromDate:self.selectedPatient.birthDate]];
            }
            else
            {
                nameAndBirthDateText = [self.selectedPatient returnDisplayTextLabelText];
            }
            
            [self drawText:nameAndBirthDateText withFont:[UIFont boldSystemFontOfSize:15.0f] atVerticalPosition:10.0f];
            
            // Draw Line
            [self drawLineAboveDailySummaryText];
            
            // Draw border
            [self drawBorder];
            
            // reset counters for 2nd page
            y = 50.0f;
            verticalPointToPrint = y;
            horizontalPointToPrint = kLeftPrintingAdjustment;
            
            // left hand side of page
            printableArea = CGSizeMake((pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), pageHeight - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
            
            stringSize = [textToDraw sizeWithFont:textFont
                                       constrainedToSize:printableArea
                                           lineBreakMode:UILineBreakModeWordWrap];
            
            // set flag to produce lines to write on
            displayLinesToWriteOn = YES;
            
            // increment page
            page = 2;
        }
        else
        {
            // if not then start printing on the right
            
            // first check which page
            // check if on first page or subsequent pages
            if (page == 1)
            {
                // set print position to match Background information
                y = rightSidePointToPrint + headingSeparator;
            }
            
            verticalPointToPrint = y;
            horizontalPointToPrint = kRightPrintingAdjustment;
            
            printableArea = CGSizeMake((pageWidth / 2) - (kBorderInset) - (kMarginInsetRight), pageHeight - (2 * kBorderInset) - (kMarginInsetTop + kMarginInsetBottom) - verticalPointToPrint);
            
            stringSize = [textToDraw sizeWithFont:textFont
                                constrainedToSize:printableArea
                                    lineBreakMode:UILineBreakModeWordWrap];
        }
    }
    
    // create a rectangle to display text based on the text size
    CGRect renderingRect;
    
    if (horizontalPointToPrint == kLeftPrintingAdjustment)
    {
        renderingRect = CGRectMake(leftInset, topInset + y, (pageWidth / 2) - (kBorderInset) - (kMarginInsetLeft + (kMarginInsetRight / 2)), stringSize.height);
    }
    else
    {
        renderingRect = CGRectMake(horizontalPointToPrint, topInset + y, (pageWidth / 2) - kBorderInset - kMarginInsetRight, stringSize.height);
    }
    
    // draw text
    [textToDraw drawInRect:renderingRect
                  withFont:textFont
             lineBreakMode:UILineBreakModeWordWrap
                 alignment:UITextAlignmentLeft];
    
    // update next print point
    verticalPointToPrint = y + stringSize.height;
}

- (void)drawLineAboveDailySummaryText
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, kLineWidth);
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor grayColor].CGColor);
    
    CGPoint startPoint = CGPointMake(kMarginInsetLeft + kBorderInset, kMarginInsetTop + kBorderInset + 40.0);
    CGPoint endPoint = CGPointMake(pageWidth - (kMarginInsetLeft) - (kBorderInset), kMarginInsetTop + kBorderInset + 40.0);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

- (void)drawLinesStartingAtVerticalPosition:(float)y
{
    // settings
    float heightToStopDrawingLines = pageHeight - 180.0f;
    float verticalLineSpacing = 22.0f;
    
    // draw lines
    for (int x = y; x < heightToStopDrawingLines; x = x + verticalLineSpacing)
    {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(currentContext, kLineWidth);
        
        CGContextSetStrokeColorWithColor(currentContext, [UIColor grayColor].CGColor);
        
        CGPoint startPoint = CGPointMake(kMarginInsetLeft + kBorderInset, x);
        CGPoint endPoint = CGPointMake(pageWidth - (kMarginInsetLeft) - (kBorderInset), x);
        
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
        
        CGContextClosePath(currentContext);
        CGContextDrawPath(currentContext, kCGPathFillStroke);
    }
}

- (void)drawSignature
{
    Preferences *preferences = [Preferences sharedPreferences];
    float signatureStartPoint = 165.0f;
    
    // draw line
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(currentContext, (kLineWidth / 2));
    
    CGContextSetStrokeColorWithColor(currentContext, [UIColor blackColor].CGColor);
    
    CGPoint startPoint = CGPointMake(pageWidth - kMarginInsetLeft - kBorderInset - signatureStartPoint, pageHeight - kBorderInset - kMarginInsetBottom - 50.0f);
    CGPoint endPoint = CGPointMake(pageWidth - kMarginInsetLeft - kBorderInset, pageHeight - kBorderInset - kMarginInsetBottom - 50.0f);
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    // draw signature
    CGRect renderingRect = CGRectMake(pageWidth - kMarginInsetLeft - kBorderInset - signatureStartPoint, pageHeight - kBorderInset - kMarginInsetBottom - 40.0f, signatureStartPoint, 84.0f);
    
    // draw text
    [preferences.signature drawInRect:renderingRect withFont:[UIFont systemFontOfSize:10.0f] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
}

- (void)drawBorder
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (preferences.border == [NSNumber numberWithInt:1])
    {
        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
        // UIColor *borderColor = [UIColor blackColor];
        // UIColor *borderColor = [UIColor colorWithRed:0/255 green:72/255 blue:160/255 alpha:1.0f];
        UIColor *borderColor = [UIColor grayColor];
        CGRect rectFrame = CGRectMake(kBorderInset, kBorderInset, pageWidth-kBorderInset * 2, pageHeight-kBorderInset * 2);
        CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
        CGContextSetLineWidth(currentContext, kBorderWidth);
        CGContextStrokeRect(currentContext, rectFrame);
    }
}

- (void)drawLogo
{
    // get logo from Preferences singleton
    Preferences *preferences = [Preferences sharedPreferences];
    UIImage *logo = preferences.image;
    
    // draw logo
    [logo drawInRect:CGRectMake(pageWidth - 225.0f - 30.0f, kBorderInset + 5, 225.0f, 48.75f)];
}

- (void)displayPDF
{
//    // delegate
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    UIWebView *webView;
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
//    {
//        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, (appDelegate.window.bounds.size.height) - 64.0f - 44.0f)];
//        [webView setScalesPageToFit:YES];
//    }
//    else
//    {
//        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 44.0f))];
//        [webView setScalesPageToFit:YES];
//    }
    
    NSURL *url = [NSURL fileURLWithPath:self.fileNamePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
//    [self.view addSubview:webView];
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

- (void)previousPatientButtonPressed
{
    // update AdvancedPatientEditor
    [self.delegate DailySummaryPDFViewControllerSelectedPreviousPatient:self];
    
    
    
    // check to see if there is another patient in the bay
    if (selectedPatientInBay == 0)
    {
        // no, last patient in bay
        
        // decrement bay, unless first bay
        if (selectedBay == 0)
        {
            return;
        }
        else
        {
            // ensure there are patients in any previous bays
            for (int i = selectedBay - 1; i >= 0; --i)
            {
                if ([[self.bayData[i] patientsInBay] count])
                {
                    selectedBay = i;
                    break;
                }
                else
                {
                    // no patient in the next bay
                    
                    if (i == 0)
                    {
                        // no more patients, empty first bay
                        return;
                    }
                }
            }
        }
        
        // set to last patient in new bay
        selectedPatientInBay = [[self.bayData[selectedBay] patientsInBay] count] - 1;
    }
    else
    {
        // yes, there are more patients in the bay
        
        // decrement patient
        selectedPatientInBay -= 1;
    }
    
    // new patient
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    self.selectedBayNSNumber = [NSNumber numberWithInt:selectedBay];
    self.selectedPatientInBayNSNumber = [NSNumber numberWithInt:selectedPatientInBay];
    
    // reset page
    page = 1;
    
    // reset printed lines
    displayLinesToWriteOn = NO;
    
    [self viewDidLoad];
}

- (void)nextPatientButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate DailySummaryPDFViewControllerSelectedNextPatient:self];
    
    // check the number of patients in the current bay
    int numberOfPatientsInCurrentBay = [[self.bayData[selectedBay] patientsInBay] count];
    
    // check to see if there is another patient in the bay
    if (selectedPatientInBay == (numberOfPatientsInCurrentBay - 1))
    {
        // no, last patient in bay
        
        // increment bay unless last bay
        if (selectedBay == [self.bayData count] - 1)
        {
            return;
        }
        else
        {
            // ensure there are are patients in the next bay displayed
            int numberOfBays = [self.bayData count];
            
            for (int i = selectedBay + 1; numberOfBays; i++)
            {
                if ([[self.bayData[i] patientsInBay] count])
                {
                    selectedBay = i;
                    break;
                }
                else
                {
                    // no patients in the next bay
                    
                    // if the second to last bay, then no more patients
                    if (i == numberOfBays - 1)
                    {
                        // no more patients, empty bays
                        return;
                    }
                }
            }
        }
        
        // reset patient info
        selectedPatientInBay = 0;
    }
    else
    {
        // yes, there are more patients in the bay
        
        // increment patient
        selectedPatientInBay += 1;
    }
    
    // new patient
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    self.selectedBayNSNumber = [NSNumber numberWithInt:selectedBay];
    self.selectedPatientInBayNSNumber = [NSNumber numberWithInt:selectedPatientInBay];
    
    // reset page
    page = 1;
    
    // reset printed lines
    displayLinesToWriteOn = NO;
    
    [self viewDidLoad];
}

@end
