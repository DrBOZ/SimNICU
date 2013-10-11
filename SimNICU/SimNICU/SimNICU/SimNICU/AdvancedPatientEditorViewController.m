//
//  AdvancedPatientEditorViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PhototherapyAddBilirubinResultViewController.h"
#import "AdvancedPatientEditorViewController.h"
#import "PortraitOnlyNavigationController.h"
#import "DailySummaryPDFViewController.h"
#import "PatientDetailsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "JaundiceViewController.h"
#import "CBTableViewSectionData.h"
#import "UDInputAccessoryView.h"
#import "CBBarCustomTextItem.h"
#import "UDBarTrackballItem.h"
#import "CBTableViewRowData.h"
#import "DictationCommands.h"
// #import "ShinobiChartCell.h"
#import "BilirubinResult.h"
#import "HandoverSection.h"
#import "CBTimeMethods.h"
#import "CBModalPanel.h"
#import "HandoverRow.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

// #import "CBBarCustomTableViewTextItem.h"

@interface AdvancedPatientEditorViewController () <UITableViewDataSource, UITableViewDelegate, SChartDatasource, SChartDelegate, UITextViewDelegate, UIScrollViewDelegate, PatientDetailsViewControllerDelegate, PhototherapyAddBilirubinResultViewControllerDelegate, JaundiceViewControllerDelegate, DailySummaryPDFViewControllerDelegate, UAModalPanelDelegate, CBModalPanelDelegate, CBBarButtonTextItemDelegate>
{
    int selectedBay;
    int selectedPatientInBay;
    
    BOOL landscapeOrientationDefaultsSet;
    BOOL portraitOrientationDefaultsSet;
    
    BOOL newPatientDetails;
    BOOL newPatientBackground;
    BOOL newActiveProblems;
    BOOL newResolvedProblems;
    BOOL newRecentSignificantEvents;
    BOOL newVentilationAndSedation;
    BOOL newCXR;
    BOOL newCardiovascular;
    BOOL newLines;
    BOOL newFeedsAndFluids;
    BOOL newFluidBalance;
    BOOL newElectrolytes;
    BOOL newBiliChart;
    BOOL newJaundice;
    BOOL newSepsis;
    BOOL newDrugs;
    BOOL newROP;
    BOOL newCranialUSS;
    BOOL newParentsAndSocial;
    BOOL newImpression;
    BOOL newPlan;
    BOOL newJobs;
    
    BOOL firstButtonPressSinceScroll; // used to line up sections when pressing fast forward
    
    // NSMutableArray *tableView2Sections;
}

// general table
@property (nonatomic, strong) UITableView *myTableView1;
@property (nonatomic, strong) UITableView *myTableView2;
@property (nonatomic, strong) NSString *workingWeight;

// phototherapy
@property (nonatomic, strong) SChartNumberAxis *xAxisLong;
@property (nonatomic, strong) SChartNumberAxis *xAxis;
@property (nonatomic, strong) SChartNumberAxis *yAxis;
@property (nonatomic, strong) ShinobiChart *chart;

@property (nonatomic, strong) NSMutableArray *bilirubinLevelsToPlot;
@property (nonatomic, strong) NSString *neurotoxicityRisk;
@property (nonatomic, strong) NSNumber *gestation;

@property (nonatomic, strong) UITextView *backgroundTextView;
@property (nonatomic, strong) UITextView *activeProblemsTextView;
@property (nonatomic, strong) UITextView *resolvedProblemsTextView;
@property (nonatomic, strong) UITextView *recentSignificantEventsTextView;
@property (nonatomic, strong) UITextView *ventilationAndSedationTextView;
@property (nonatomic, strong) UITextView *cxrTextView;
@property (nonatomic, strong) UITextView *cardiovascularTextView;
@property (nonatomic, strong) UITextView *linesTextView;
@property (nonatomic, strong) UITextView *feedsAndFluidsTextView;
@property (nonatomic, strong) UITextView *fluidBalanceTextView;
@property (nonatomic, strong) UITextView *electrolytesTextView;
@property (nonatomic, strong) UITextView *jaundiceTextView;
@property (nonatomic, strong) UITextView *sepsisTextView;
@property (nonatomic, strong) UITextView *drugsTextView;
@property (nonatomic, strong) UITextView *ropTextView;
@property (nonatomic, strong) UITextView *cranialUSSTextView;
@property (nonatomic, strong) UITextView *parentsAndSocialTextView;
@property (nonatomic, strong) UITextView *impressionTextView;
@property (nonatomic, strong) UITextView *planTextView;
@property (nonatomic, strong) UITextView *jobsTextView;

@property (nonatomic, strong) UITableViewCell *shinobiCell;
@property (nonatomic, strong) UIImage *shinobiChartImage;

@property (nonatomic, strong) CBModalPanel *modalPanel;

@property (nonatomic, strong) UIButton *fingerprintButton;

@end

@implementation AdvancedPatientEditorViewController

// things I need to still do
//
// 1) Add option to calcualate first day as day 0, day 1 or mixture
// 2) 
// 3) use edit data to allow edits
// 
// 4) add analytics
// 5) create a weight shinobi chart
// 6) dateAndTimeForThisChart thing for ShinobiChart
//
// 7)
// 8) 
// 9) 
//10) Add Time and Date
//11) Add weight chart
//12) Add phototherapy chart
//13)
//14) 
//15) 
//16) 
//17) Add biochemistry edit
//18) change names of patient properties to match UITextFields
//19) 
//20) 'Plan' cell height should not reduce

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        firstButtonPressSinceScroll = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    portraitOrientationDefaultsSet = YES;
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    // setup edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // setup toolbar
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousPatientButtonPressed)];
    item1.tag = 1;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(prepareDailySummaryPDFForPatient)];
    item2.tag = 2;
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(nextPatientButtonPressed:)];
    item3.tag = 3;
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextPatientButtonPressed:)];
    item4.tag = 4;
    
    NSArray *items = [NSArray arrayWithObjects:item1, flexibleItem, item2, flexibleItem, item3, flexibleItem, item4, nil];
    self.toolbarItems = items;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.navigationController.toolbar.barTintColor = [UIColor lightGrayColor];
        self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    }
    else
    {
        // self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
        self.navigationController.toolbar.tintColor = [UIColor grayColor];
    }
    
    // set the first patient to display
    if (!self.selectedPatient)
    {
        // need to find first patient, not assume 0,0
        self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    }
    else
    {
        selectedBay = [self.selectedBayNSNumber intValue];
        selectedPatientInBay = [self.selectedPatientInBayNSNumber intValue];
    }
    
    // set title
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    // sections
    // tableView2Sections = [[NSMutableArray alloc] initWithCapacity:12];
    // tableView2Sections = [self loadSectionDataForPatientEditing:self.editing]; // don't think I actually need this array
    
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    /*
    self.shinobiCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Phototherapy"];
    self.shinobiCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.shinobiCell addSubview:self.chart];
     */
    
    // tableViews
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 92.0f + 64.0f) style:UITableViewStylePlain];
        // self.myTableView1.userInteractionEnabled = YES;
        self.myTableView1.separatorColor = [UIColor clearColor];
    }
    else
    {
        self.myTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 92.0f) style:UITableViewStylePlain];
        // self.myTableView1.userInteractionEnabled = YES;
        self.myTableView1.separatorColor = [UIColor grayColor];
    }
    self.myTableView1.rowHeight = 44.0f;
    self.myTableView1.dataSource = self;
    self.myTableView1.delegate = self;
    self.myTableView1.sectionFooterHeight = 10.0f;
    self.myTableView1.sectionHeaderHeight = 10.0f;
    
    self.myTableView1.bounces = NO;
    
    [self.view addSubview:self.myTableView1];
    
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 92.0f + 64.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 92.0f - 44.0f)) style:UITableViewStylePlain];
    }
    else
    {
        self.myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 92.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 92.0f - 44.0f)) style:UITableViewStylePlain];
    }
    self.myTableView2.rowHeight = 44.0f;
    self.myTableView2.dataSource = self;
    self.myTableView2.delegate = self;
    self.myTableView2.sectionFooterHeight = 10.0f;
    self.myTableView2.sectionHeaderHeight = 10.0f;
    self.myTableView2.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView2];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
    [self textViewDidChange:self.backgroundTextView];
    [self textViewDidChange:self.activeProblemsTextView];
    [self textViewDidChange:self.resolvedProblemsTextView];
    [self textViewDidChange:self.recentSignificantEventsTextView];
    [self textViewDidChange:self.ventilationAndSedationTextView];
    [self textViewDidChange:self.cxrTextView];
    [self textViewDidChange:self.cardiovascularTextView];
    [self textViewDidChange:self.linesTextView];
    [self textViewDidChange:self.feedsAndFluidsTextView];
    [self textViewDidChange:self.fluidBalanceTextView];
    [self textViewDidChange:self.electrolytesTextView];
    [self textViewDidChange:self.jaundiceTextView];
    [self textViewDidChange:self.sepsisTextView];
    [self textViewDidChange:self.drugsTextView];
    [self textViewDidChange:self.ropTextView];
    [self textViewDidChange:self.cranialUSSTextView];
    [self textViewDidChange:self.parentsAndSocialTextView];
    [self textViewDidChange:self.impressionTextView];
    [self textViewDidChange:self.planTextView];
    [self textViewDidChange:self.jobsTextView];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if  ([tableView isEqual:self.myTableView1])
    {
        return 1;
    }
    else
    {
        return [self.selectedPatient.handoverSections count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    if ([tableView isEqual:self.myTableView1])
    {
        rows = 1;
    }
    else
    {
        HandoverSection *handoverSection = self.selectedPatient.handoverSections[section];
        
        rows = [handoverSection.rows count];
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    HandoverSection *handoverSection = self.selectedPatient.handoverSections[section];
    
    if ([tableView isEqual:self.myTableView1])
    {
        returnString = @"Patient";
    }
    else
    {
        returnString = handoverSection.sectionName;
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (CGFloat)heightForTextView:(UITextView *)textView
{
    // get textView height
    HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
    
    UITextView *textViewToMeasure;
    
    if (!textViewToMeasure)
    {
        textViewToMeasure = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
    }
    
    if ([section.sectionName isEqual:@"Background"])
    {
        textViewToMeasure.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
    }
    else if ([section.sectionName isEqual:@"Active Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.activeProblems;
    }
    else if ([section.sectionName isEqual:@"Resolved Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.resolvedProblems;
    }
    else if ([section.sectionName isEqual:@"Recent Significant Events"])
    {
        textViewToMeasure.text = self.selectedPatient.recentSignificantEvents;
    }
    else if ([section.sectionName isEqual:@"Ventilation & Sedation"])
    {
        textViewToMeasure.text = self.selectedPatient.ventilationAndSedation;
    }
    else if ([section.sectionName isEqual:@"CXR"])
    {
        textViewToMeasure.text = self.selectedPatient.cxr;
    }
    else if ([section.sectionName isEqual:@"Cardiovascular"])
    {
        textViewToMeasure.text = self.selectedPatient.cardiovascular;
    }
    else if ([section.sectionName isEqual:@"Lines"])
    {
        textViewToMeasure.text = self.selectedPatient.lines;
    }
    else if ([section.sectionName isEqual:@"Feeds & Fluids"])
    {
        textViewToMeasure.text = self.selectedPatient.feedsAndFluids;
    }
    else if ([section.sectionName isEqual:@"Fluid Balance"])
    {
        textViewToMeasure.text = self.selectedPatient.fluidBalance;
    }
    else if ([section.sectionName isEqual:@"Biochemistry"])
    {
        textViewToMeasure.text = self.selectedPatient.electrolytes;
    }
    else if ([section.sectionName isEqual:@"Jaundice"])
    {
        textViewToMeasure.text = self.selectedPatient.jaundice;
    }
    else if ([section.sectionName isEqual:@"Sepsis"])
    {
        textViewToMeasure.text = self.selectedPatient.sepsis;
    }
    else if ([section.sectionName isEqual:@"Drugs"])
    {
        textViewToMeasure.text = self.selectedPatient.drugs;
    }
    else if ([section.sectionName isEqual:@"ROP"])
    {
        textViewToMeasure.text = self.selectedPatient.rop;
    }
    else if ([section.sectionName isEqual:@"Neurology & Cranial USS"])
    {
        textViewToMeasure.text = self.selectedPatient.cranialUSS;
    }
    else if ([section.sectionName isEqual:@"Parents / Social"])
    {
        textViewToMeasure.text = self.selectedPatient.parentsAndSocial;
    }
    else if ([section.sectionName isEqual:@"Examination"])
    {
        textViewToMeasure.text = self.selectedPatient.impression;
    }
    else if ([section.sectionName isEqual:@"Summary"])
    {
        textViewToMeasure.text = self.selectedPatient.plan;
    }
    else if ([section.sectionName isEqual:@"Plan"])
    {
        textViewToMeasure.text = self.selectedPatient.jobs;
    }
    
    // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
    
    [textViewToMeasure sizeToFit];
    
    CGFloat height = textViewToMeasure.frame.size.height;
    
    textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.dynamicText intValue])
    {
        textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    else
    {
        textView.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 55.0f;
    
    if ([tableView isEqual:self.myTableView1])
    {
        height = 70.0f;
    }
    else
    {
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            UITextView *textView;
            
            if (!textView)
            {
                textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
            }
            
            HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
            
            if ([section.sectionName isEqual:@"Background"])
            {
                textView.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
            }
            else if ([section.sectionName isEqual:@"Active Problems"])
            {
                textView.text = self.selectedPatient.activeProblems;
            }
            else if ([section.sectionName isEqual:@"Resolved Problems"])
            {
                textView.text = self.selectedPatient.resolvedProblems;
            }
            else if ([section.sectionName isEqual:@"Recent Significant Events"])
            {
                textView.text = self.selectedPatient.recentSignificantEvents;
            }
            else if ([section.sectionName isEqual:@"Ventilation & Sedation"])
            {
                textView.text = self.selectedPatient.ventilationAndSedation;
            }
            else if ([section.sectionName isEqual:@"CXR"])
            {
                textView.text = self.selectedPatient.cxr;
            }
            else if ([section.sectionName isEqual:@"Cardiovascular"])
            {
                textView.text = self.selectedPatient.cardiovascular;
            }
            else if ([section.sectionName isEqual:@"Lines"])
            {
                textView.text = self.selectedPatient.lines;
            }
            else if ([section.sectionName isEqual:@"Feeds & Fluids"])
            {
                textView.text = self.selectedPatient.feedsAndFluids;
            }
            else if ([section.sectionName isEqual:@"Fluid Balance"])
            {
                textView.text = self.selectedPatient.fluidBalance;
            }
            else if ([section.sectionName isEqual:@"Biochemistry"])
            {
                textView.text = self.selectedPatient.electrolytes;
            }
            else if ([section.sectionName isEqual:@"Jaundice"])
            {
                if (indexPath.row == 0)
                {
                    HandoverRow *row = section.rows[indexPath.row];
                    
                    height = [row.rowHeight floatValue];
                    
                    return height;
                }
                else if (indexPath.row == 1)
                {
                    textView.text = self.selectedPatient.jaundice;
                }
            }
            else if ([section.sectionName isEqual:@"Sepsis"])
            {
                textView.text = self.selectedPatient.sepsis;
            }
            else if ([section.sectionName isEqual:@"Drugs"])
            {
                textView.text = self.selectedPatient.drugs;
            }
            else if ([section.sectionName isEqual:@"ROP"])
            {
                textView.text = self.selectedPatient.rop;
            }
            else if ([section.sectionName isEqual:@"Neurology & Cranial USS"])
            {
                textView.text = self.selectedPatient.cranialUSS;
            }
            else if ([section.sectionName isEqual:@"Parents / Social"])
            {
                textView.text = self.selectedPatient.parentsAndSocial;
            }
            else if ([section.sectionName isEqual:@"Examination"])
            {
                textView.text = self.selectedPatient.impression;
            }
            else if ([section.sectionName isEqual:@"Summary"])
            {
                textView.text = self.selectedPatient.plan;
            }
            else if ([section.sectionName isEqual:@"Plan"])
            {
                textView.text = self.selectedPatient.jobs;
            }
            
            Preferences *preferences = [Preferences sharedPreferences];
            
            if ([preferences.dynamicText intValue])
            {
                textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            }
            else
            {
                textView.font = [UIFont systemFontOfSize:14.0f];
            }
            
            [textView sizeToFit];
            
            height = textView.frame.size.height;
        }
        else
        {
            HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
            
            HandoverRow *row = section.rows[indexPath.row];
            
            height = [row.rowHeight floatValue];
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    
    UITableViewCell *cell;
    
    if ([tableView isEqual:self.myTableView1]) // Patient Name, age, etc
    {
        CellIdentifier = @"Patient";
        
        if (newPatientDetails)
        {
            cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            
            newPatientDetails = NO;
        }
        else
        {
            // need a dequeue cell for cell identifier call
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
        }
    }
    else
    {
        HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
        
        if ([section.sectionName isEqual:@"Background"])
        {
            CellIdentifier = @"Background";
            
            if (newPatientBackground)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                
                newPatientBackground = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.backgroundTextView.text = self.selectedPatient.background;
            // [self formatHeightOfTextView:self.backgroundTextView];
        }
        else if ([section.sectionName isEqual:@"Active Problems"])
        {
            CellIdentifier = @"ActiveProblems";
            
            if (newActiveProblems)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.activeProblemsTextView.text = self.selectedPatient.activeProblems;
            // [self formatHeightOfTextView:self.activeProblemsTextView];
        }
        else if ([section.sectionName isEqual:@"Resolved Problems"])
        {
            CellIdentifier = @"ResolvedProblems";
            
            if (newResolvedProblems)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.resolvedProblemsTextView.text = self.selectedPatient.resolvedProblems;
            // [self formatHeightOfTextView:self.resolvedProblemsTextView];
        }
        else if ([section.sectionName isEqual:@"Recent Significant Events"])
        {
            CellIdentifier = @"RecentSignificantEvents";
            
            if (newRecentSignificantEvents)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.recentSignificantEventsTextView.text = self.selectedPatient.recentSignificantEvents;
            // [self formatHeightOfTextView:self.recentSignificantEventsTextView];
        }
        else if ([section.sectionName isEqual:@"Ventilation & Sedation"])
        {
            CellIdentifier = @"VentilationAndSedation";
            
            if (newVentilationAndSedation)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.ventilationAndSedationTextView.text = self.selectedPatient.ventilationAndSedation;
            // [self formatHeightOfTextView:self.ventilationAndSedationTextView];
        }
        else if ([section.sectionName isEqual:@"CXR"])
        {
            CellIdentifier = @"CXR";
            
            if (newCXR)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.cxrTextView.text = self.selectedPatient.cxr;
            // [self formatHeightOfTextView:self.cxrTextView];
        }
        else if ([section.sectionName isEqual:@"Cardiovascular"])
        {
            CellIdentifier = @"Cardiovascular";
            
            if (newCardiovascular)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.cardiovascularTextView.text = self.selectedPatient.cardiovascular;
            // [self formatHeightOfTextView:self.cardiovascularTextView];
        }
        else if ([section.sectionName isEqual:@"Lines"])
        {
            CellIdentifier = @"Lines";
            
            if (newLines)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.linesTextView.text = self.selectedPatient.lines;
            // [self formatHeightOfTextView:self.linesTextView];
        }
        else if ([section.sectionName isEqual:@"Feeds & Fluids"])
        {
            CellIdentifier = @"FeedsAndFluids";
            
            if (newFeedsAndFluids)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.feedsAndFluidsTextView.text = self.selectedPatient.feedsAndFluids;
            // [self formatHeightOfTextView:self.feedsAndFluidsTextView];
        }
        else if ([section.sectionName isEqual:@"Fluid Balance"])
        {
            CellIdentifier = @"FluidBalance";
            
            if (newFluidBalance)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.fluidBalanceTextView.text = self.selectedPatient.fluidBalance;
            // [self formatHeightOfTextView:self.fluidBalanceTextView];
        }
        else if ([section.sectionName isEqual:@"Biochemistry"])
        {
            CellIdentifier = @"Biochemistry";
            
            if (newElectrolytes)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.electrolytesTextView.text = self.selectedPatient.electrolytes;
            // [self formatHeightOfTextView:self.electrolytesTextView];
        }
        else if ([section.sectionName isEqual:@"Jaundice"])
        {
            if (indexPath.row == 0)
            {
                // phototherapy
                CellIdentifier = @"Phototherapy";
                
                if (newBiliChart)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    
                    newBiliChart = NO;
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    }
                }
            }
            else if (indexPath.row == 1)
            {
                // phototherapy
                CellIdentifier = @"Jaundice";
                
                if (newJaundice)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    
                    newJaundice = NO;
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    }
                }
                
                self.jaundiceTextView.text = self.selectedPatient.jaundice;
                // [self formatHeightOfTextView:self.jaundiceTextView];
            }
        }
        else if ([section.sectionName isEqual:@"Sepsis"])
        {
            CellIdentifier = @"Sepsis";
            
            if (newSepsis)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.sepsisTextView.text = self.selectedPatient.sepsis;
            // [self formatHeightOfTextView:self.sepsisTextView];
        }
        else if ([section.sectionName isEqual:@"Drugs"])
        {
            CellIdentifier = @"Drugs";
            
            if (newDrugs)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.drugsTextView.text = self.selectedPatient.drugs;
            // [self formatHeightOfTextView:self.drugsTextView];
        }
        else if ([section.sectionName isEqual:@"ROP"])
        {
            CellIdentifier = @"ROP";
            
            if (newROP)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.ropTextView.text = self.selectedPatient.rop;
            // [self formatHeightOfTextView:self.ropTextView];
        }
        else if ([section.sectionName isEqual:@"Neurology & Cranial USS"])
        {
            CellIdentifier = @"NeurologyAndCranialUSS";
            
            if (newCranialUSS)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.cranialUSSTextView.text = self.selectedPatient.cranialUSS;
            // [self formatHeightOfTextView:self.cranialUSSTextView];
        }
        else if ([section.sectionName isEqual:@"Parents / Social"])
        {
            CellIdentifier = @"ParentsSocial";
            
            if (newParentsAndSocial)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.parentsAndSocialTextView.text = self.selectedPatient.parentsAndSocial;
            // [self formatHeightOfTextView:self.parentsAndSocialTextView];
        }
        else if ([section.sectionName isEqual:@"Examination"])
        {
            CellIdentifier = @"Examination";
            
            if (newImpression)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.impressionTextView.text = self.selectedPatient.impression;
            // [self formatHeightOfTextView:self.impressionTextView];
        }
        else if ([section.sectionName isEqual:@"Summary"])
        {
            CellIdentifier = @"Summary";
            
            if (newPlan)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.planTextView.text = self.selectedPatient.plan;
            // [self formatHeightOfTextView:self.planTextView];
        }
        else if ([section.sectionName isEqual:@"Plan"])
        {
            CellIdentifier = @"Plan";
            
            if (newJobs)
            {
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.jobsTextView.text = self.selectedPatient.jobs;
            // [self formatHeightOfTextView:self.jobsTextView];
        }
        else
        {
            CellIdentifier = @"Misc";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    
    return cell;
}

#pragma mark -

- (UITableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
#pragma mark Patient
    if ([CellIdentifier isEqualToString:@"Patient"])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //displayTextLabel (Patient's name)
        UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 0.0f, 300.0f, 22.0f)];
        displayTextLabel.textColor = [UIColor blackColor];
        displayTextLabel.backgroundColor = [UIColor clearColor];
        displayTextLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        displayTextLabel.adjustsFontSizeToFitWidth = YES;
        displayTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayTextLabel];
        
        UILabel *displayAgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 23.0f, 300.0f, 22.0f)];
        displayAgeTextLabel.textColor = [UIColor grayColor];
        displayAgeTextLabel.backgroundColor = [UIColor clearColor];
        displayAgeTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayAgeTextLabel.adjustsFontSizeToFitWidth = NO;
        displayAgeTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayAgeTextLabel];
        
        //displayDetailTextLabel (Gestation, birth weight, corrected gestation and working weight)
        UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 44.0f, 300.0f, 22.0f)];
        displayDetailTextLabel.textColor = [UIColor grayColor];
        displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        displayDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayDetailTextLabel.adjustsFontSizeToFitWidth = NO;
        displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayDetailTextLabel];
        
        // display patient's name & birthDate
        if (self.selectedPatient.birthDate)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.timeStyle = [NSTimeZone localTimeZone];
            formatter.dateStyle = NSDateFormatterShortStyle;
            formatter.timeStyle = NSDateFormatterNoStyle;
            
            displayTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", [self.selectedPatient returnDisplayTextLabelText], [formatter stringFromDate:self.selectedPatient.birthDate]];
        }
        else
        {
            displayTextLabel.text = [self.selectedPatient returnDisplayTextLabelText];
        }
        
        // display day of life and (corrected weeks + days)
        if (self.selectedPatient.birthDate)
        {
            NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.selectedPatient.birthDate and:[NSDate date]];
            
            NSString *correctedAge = formattedDates[2];
            
            // display days and corrected age
            displayAgeTextLabel.text = [NSString stringWithFormat:@"day %i (%@)", [CBTimeMethods getDaysDifferenceIntBetween:self.selectedPatient.birthDate and:[NSDate date]], correctedAge];
        }
        
        // display gestation and corrected gestation, birth weight and working weight
        displayDetailTextLabel.text = [self.selectedPatient returnTwoLineDetailDisplayLabelText];
        
        // add fingerprint button
        /*
        self.fingerprintButton = [[UIButton alloc] init];
        self.fingerprintButton.frame = CGRectMake(320.0f - 40.0f, 15.0f, 30.0f, 37.8f);
        [self.fingerprintButton setImage:[UIImage imageNamed:@"FingerprintGray.png"] forState:UIControlStateNormal];
        [self.fingerprintButton setImage:[UIImage imageNamed:@"FingerprintGray.png"] forState:UIControlStateHighlighted];
        self.fingerprintButton.userInteractionEnabled = NO;
        self.fingerprintButton.alpha = 0.0f;
        self.fingerprintButton.hidden = YES;
        
        [cell.contentView addSubview:self.fingerprintButton];
         */
    }
#pragma mark Background
    else if ([CellIdentifier isEqualToString:@"Background"])
    {
        self.backgroundTextView = [[UITextView alloc] init];
        self.backgroundTextView.tag = 0;
        [self setupTextView:self.backgroundTextView];
        
        [cell.contentView addSubview:self.backgroundTextView];
    }
#pragma mark Active Problems
    else if ([CellIdentifier isEqualToString:@"ActiveProblems"])
    {
        self.activeProblemsTextView = [[UITextView alloc] init];
        self.activeProblemsTextView.tag = 1;
        [self setupTextView:self.activeProblemsTextView];
        
        [cell.contentView addSubview:self.activeProblemsTextView];
    }
#pragma mark Resolved Problems
    else if ([CellIdentifier isEqualToString:@"ResolvedProblems"])
    {
        self.resolvedProblemsTextView = [[UITextView alloc] init];
        self.resolvedProblemsTextView.tag = 2;
        [self setupTextView:self.resolvedProblemsTextView];
        
        [cell.contentView addSubview:self.resolvedProblemsTextView];
    }
#pragma mark Recent Significant Events
    else if ([CellIdentifier isEqualToString:@"RecentSignificantEvents"])
    {
        self.recentSignificantEventsTextView = [[UITextView alloc] init];
        self.recentSignificantEventsTextView.tag = 3;
        [self setupTextView:self.recentSignificantEventsTextView];
        
        [cell.contentView addSubview:self.recentSignificantEventsTextView];
    }
#pragma mark Ventilation & Sedation
    else if ([CellIdentifier isEqualToString:@"VentilationAndSedation"])
    {
        self.ventilationAndSedationTextView = [[UITextView alloc] init];
        self.ventilationAndSedationTextView.tag = 4;
        [self setupTextView:self.ventilationAndSedationTextView];
        
        [cell.contentView addSubview:self.ventilationAndSedationTextView];
    }
#pragma mark CXR
    else if ([CellIdentifier isEqualToString:@"CXR"])
    {
        self.cxrTextView = [[UITextView alloc] init];
        self.cxrTextView.tag = 5;
        [self setupTextView:self.cxrTextView];
        
        [cell.contentView addSubview:self.cxrTextView];
    }
#pragma mark Cardiovascular
    else if ([CellIdentifier isEqualToString:@"Cardiovascular"])
    {
        self.cardiovascularTextView = [[UITextView alloc] init];
        self.cardiovascularTextView.tag = 6;
        [self setupTextView:self.cardiovascularTextView];
        
        [cell.contentView addSubview:self.cardiovascularTextView];
    }
#pragma mark Lines
    else if ([CellIdentifier isEqualToString:@"Lines"])
    {
        self.linesTextView = [[UITextView alloc] init];
        self.linesTextView.tag = 7;
        [self setupTextView:self.linesTextView];
        
        [cell.contentView addSubview:self.linesTextView];
    }
#pragma mark Feeds & Fluids
    else if ([CellIdentifier isEqualToString:@"FeedsAndFluids"])
    {
        self.feedsAndFluidsTextView = [[UITextView alloc] init];
        self.feedsAndFluidsTextView.tag = 8;
        [self setupTextView:self.feedsAndFluidsTextView];
        
        [cell.contentView addSubview:self.feedsAndFluidsTextView];
    }
#pragma mark Fluid Balance
    else if ([CellIdentifier isEqualToString:@"FluidBalance"])
    {
        self.fluidBalanceTextView = [[UITextView alloc] init];
        self.fluidBalanceTextView.tag = 9;
        [self setupTextView:self.fluidBalanceTextView];
        
        [cell.contentView addSubview:self.fluidBalanceTextView];
    }
#pragma mark Biochemistry
    else if ([CellIdentifier isEqualToString:@"Biochemistry"])
    {
        self.electrolytesTextView = [[UITextView alloc] init];
        self.electrolytesTextView.tag = 10;
        [self setupTextView:self.electrolytesTextView];
        
        [cell.contentView addSubview:self.electrolytesTextView];
    }
#pragma mark Jaundice/Phototherapy
    else if ([CellIdentifier isEqualToString:@"Phototherapy"])
    {
        [cell addSubview:self.chart];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // change chart title font
            self.chart.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        
        // attempts to recreate chart on PDF
        /*
        self.shinobiChartImage = [[UIImage alloc] init];
        
        UIGraphicsBeginImageContext(self.chart.bounds.size);
        
        [self.chart.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        self.shinobiChartImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
        
        /*
        UIGraphicsBeginImageContext(self.chart.bounds.size);
        [self.chart.layer renderInContext:UIGraphicsGetCurrentContext()];
        self.shinobiChartImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
         */
    }
#pragma mark Jaundice/DCT
    else if ([CellIdentifier isEqualToString:@"Jaundice"])
    {
        self.jaundiceTextView = [[UITextView alloc] init];
        self.jaundiceTextView.tag = 11;
        [self setupTextView:self.jaundiceTextView];
        
        [cell.contentView addSubview:self.jaundiceTextView];
    }
#pragma mark Sepsis
    else if ([CellIdentifier isEqualToString:@"Sepsis"])
    {
        self.sepsisTextView = [[UITextView alloc] init];
        self.sepsisTextView.tag = 12;
        [self setupTextView:self.sepsisTextView];
        
        [cell.contentView addSubview:self.sepsisTextView];
    }
#pragma mark Drugs
    else if ([CellIdentifier isEqualToString:@"Drugs"])
    {
        self.drugsTextView = [[UITextView alloc] init];
        self.drugsTextView.tag = 13;
        [self setupTextView:self.drugsTextView];
        
        [cell.contentView addSubview:self.drugsTextView];
    }
#pragma mark ROP
    else if ([CellIdentifier isEqualToString:@"ROP"])
    {
        self.ropTextView = [[UITextView alloc] init];
        self.ropTextView.tag = 14;
        [self setupTextView:self.ropTextView];
        
        [cell.contentView addSubview:self.ropTextView];
    }
#pragma mark Cranial USS
    else if ([CellIdentifier isEqualToString:@"NeurologyAndCranialUSS"])
    {
        self.cranialUSSTextView = [[UITextView alloc] init];
        self.cranialUSSTextView.tag = 15;
        [self setupTextView:self.cranialUSSTextView];
        
        [cell.contentView addSubview:self.cranialUSSTextView];
    }
#pragma mark Parents / Social
    else if ([CellIdentifier isEqualToString:@"ParentsSocial"])
    {
        self.parentsAndSocialTextView = [[UITextView alloc] init];
        self.parentsAndSocialTextView.tag = 16;
        [self setupTextView:self.parentsAndSocialTextView];
        
        [cell.contentView addSubview:self.parentsAndSocialTextView];
    }
#pragma mark Examination
    else if ([CellIdentifier isEqualToString:@"Examination"])
    {
        self.impressionTextView = [[UITextView alloc] init];
        self.impressionTextView.tag = 17;
        [self setupTextView:self.impressionTextView];
        
        [cell.contentView addSubview:self.impressionTextView];
    }
#pragma mark Summary
    else if ([CellIdentifier isEqualToString:@"Summary"])
    {
        self.planTextView = [[UITextView alloc] init];
        self.planTextView.tag = 18;
        [self setupTextView:self.planTextView];
        
        [cell.contentView addSubview:self.planTextView];
    }
#pragma mark Plan
    else if ([CellIdentifier isEqualToString:@"Plan"])
    {
        self.jobsTextView = [[UITextView alloc] init];
        self.jobsTextView.tag = 19;
        [self setupTextView:self.jobsTextView];
        
        [cell.contentView addSubview:self.jobsTextView];
    }
    
    return cell;
}

- (UITextView *)setupTextView:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get textView height
    HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
    HandoverRow *row;
    
    if (textView.tag == 11)
    {
        row = section.rows[1];
    }
    else
    {
        row = section.rows[0];
    }
    
    // set values
    textView.textColor = [UIColor grayColor];
    textView.scrollEnabled = NO;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        UITextView *textViewToMeasure;
        
        if (!textViewToMeasure)
        {
            textViewToMeasure = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
        }
        
        if ([section.sectionName isEqual:@"Background"])
        {
            textViewToMeasure.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
        }
        else if ([section.sectionName isEqual:@"Active Problems"])
        {
            textViewToMeasure.text = self.selectedPatient.activeProblems;
        }
        else if ([section.sectionName isEqual:@"Resolved Problems"])
        {
            textViewToMeasure.text = self.selectedPatient.resolvedProblems;
        }
        else if ([section.sectionName isEqual:@"Recent Significant Events"])
        {
            textViewToMeasure.text = self.selectedPatient.recentSignificantEvents;
        }
        else if ([section.sectionName isEqual:@"Ventilation & Sedation"])
        {
            textViewToMeasure.text = self.selectedPatient.ventilationAndSedation;
            
            if (self.selectedPatient.ventilationAndSedationLastEntryDate)
            {
                if ([self isDate:self.selectedPatient.ventilationAndSedationLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
                {
                    textView.textColor = [UIColor redColor];
                }
            }
        }
        else if ([section.sectionName isEqual:@"CXR"])
        {
            textViewToMeasure.text = self.selectedPatient.cxr;
        }
        else if ([section.sectionName isEqual:@"Cardiovascular"])
        {
            textViewToMeasure.text = self.selectedPatient.cardiovascular;
        }
        else if ([section.sectionName isEqual:@"Lines"])
        {
            textViewToMeasure.text = self.selectedPatient.lines;
        }
        else if ([section.sectionName isEqual:@"Feeds & Fluids"])
        {
            textViewToMeasure.text = self.selectedPatient.feedsAndFluids;
            
            if (self.selectedPatient.feedsAndFluidLastEntryDate)
            {
                if ([self isDate:self.selectedPatient.feedsAndFluidLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
                {
                    textView.textColor = [UIColor redColor];
                }
            }
        }
        else if ([section.sectionName isEqual:@"Fluid Balance"])
        {
            textViewToMeasure.text = self.selectedPatient.fluidBalance;
        }
        else if ([section.sectionName isEqual:@"Biochemistry"])
        {
            textViewToMeasure.text = self.selectedPatient.electrolytes;
        }
        else if ([section.sectionName isEqual:@"Jaundice"])
        {
            textViewToMeasure.text = self.selectedPatient.jaundice;
        }
        else if ([section.sectionName isEqual:@"Sepsis"])
        {
            textViewToMeasure.text = self.selectedPatient.sepsis;
        }
        else if ([section.sectionName isEqual:@"Drugs"])
        {
            textViewToMeasure.text = self.selectedPatient.drugs;
            
            if (self.selectedPatient.drugsLastEntryDate)
            {
                if ([self isDate:self.selectedPatient.drugsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
                {
                    textView.textColor = [UIColor redColor];
                }
            }
        }
        else if ([section.sectionName isEqual:@"ROP"])
        {
            textViewToMeasure.text = self.selectedPatient.rop;
        }
        else if ([section.sectionName isEqual:@"Neurology & Cranial USS"])
        {
            textViewToMeasure.text = self.selectedPatient.cranialUSS;
        }
        else if ([section.sectionName isEqual:@"Parents / Social"])
        {
            textViewToMeasure.text = self.selectedPatient.parentsAndSocial;
        }
        else if ([section.sectionName isEqual:@"Examination"])
        {
            textViewToMeasure.text = self.selectedPatient.impression;
        }
        else if ([section.sectionName isEqual:@"Summary"])
        {
            textViewToMeasure.text = self.selectedPatient.plan;
        }
        else if ([section.sectionName isEqual:@"Plan"])
        {
            textViewToMeasure.text = self.selectedPatient.jobs;
        }
        
        // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
        
        [textViewToMeasure sizeToFit];
        
        CGFloat height = textViewToMeasure.frame.size.height;
        
        textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
        
        Preferences *preferences = [Preferences sharedPreferences];
        
        if ([preferences.dynamicText intValue])
        {
            textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        }
        else
        {
            textView.font = [UIFont systemFontOfSize:14.0f];
        }
    }
    else
    {
        textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, [row.rowHeight floatValue]);
        textView.font = [UIFont systemFontOfSize:14.0f];
    }
    
    // set delegate
    textView.delegate = self;
    
    // autocorrection option
    if ([preferences.autocorrection intValue] == 1)
    {
        textView.autocorrectionType = UITextAutocorrectionTypeYes;
    }
    else
    {
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    // set trackball
    if ([preferences.trackball intValue] == 1)
    {
        [self addTrackBallForUITextView:textView];
    }
    
    return textView;
}

- (BOOL)isDate:(NSDate *)date moreThanTwelveHoursLaterThanDate:(NSDate *)currentDate
{
    double daysSinceEdit = [CBTimeMethods getDaysDifferenceDoubleBetween:date and:currentDate];
    
    NSLog(@"days since edit = %f", daysSinceEdit);
    
    return ((daysSinceEdit > 0.5) ? YES : NO);
}

#pragma mark -

#pragma mark editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL userCanEditRowAtIndexPath = NO;
    
    // patient details is always editable
    if ([tableView isEqual:self.myTableView1])
    {
        userCanEditRowAtIndexPath = YES;
    }
    // sections may or may not be editable
    else if ([tableView isEqual:self.myTableView2])
    {
        // lookup if cell allows editing
        HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
        
        userCanEditRowAtIndexPath = [section.sectionEditable boolValue];
    }
    
    return userCanEditRowAtIndexPath;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.backgroundTextView resignFirstResponder];
    [self.activeProblemsTextView resignFirstResponder];
    [self.resolvedProblemsTextView resignFirstResponder];
    [self.recentSignificantEventsTextView resignFirstResponder];
    [self.ventilationAndSedationTextView resignFirstResponder];
    [self.cxrTextView resignFirstResponder];
    [self.cardiovascularTextView resignFirstResponder];
    [self.linesTextView resignFirstResponder];
    [self.fluidBalanceTextView resignFirstResponder];
    [self.feedsAndFluidsTextView resignFirstResponder];
    [self.electrolytesTextView resignFirstResponder];
    [self.jaundiceTextView resignFirstResponder];
    [self.sepsisTextView resignFirstResponder];
    [self.drugsTextView resignFirstResponder];
    [self.ropTextView resignFirstResponder];
    [self.cranialUSSTextView resignFirstResponder];
    [self.parentsAndSocialTextView resignFirstResponder];
    [self.impressionTextView resignFirstResponder];
    [self.planTextView resignFirstResponder];
    [self.jobsTextView resignFirstResponder];
    
    // tableView2Sections = [self loadSectionDataForPatientEditing:editing];
    
    [self.myTableView1 setEditing:editing animated:YES];
    [self.myTableView2 setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle *editingStyle = UITableViewCellEditingStyleInsert;
    
    HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
    
    if ([tableView isEqual:self.myTableView1])
    {
        editingStyle = UITableViewCellEditingStyleInsert;
    }
    else if ([tableView isEqual:self.myTableView2])
    {
        if ([section.sectionName isEqual:@"Jaundice"])
        {
            editingStyle = UITableViewCellEditingStyleInsert;
        }
        else
        {
            editingStyle = UITableViewCellEditingStyleInsert;
        }
    }
    
    return editingStyle;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.myTableView1])
    {
        PatientDetailsViewController *patientDetailsViewController = [[PatientDetailsViewController alloc] init];
        patientDetailsViewController.delegate = self;
        
        patientDetailsViewController.patientToEdit = self.selectedPatient;
        patientDetailsViewController.patientToEdit.NewBabyAPGARSSaved = NULL;
        
        PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:patientDetailsViewController];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            navController.navigationBar.barTintColor = [UIColor grayColor];
            navController.navigationBar.tintColor = [UIColor redColor];
        }
        else
        {
            navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
            navController.navigationBar.tintColor = [UIColor blackColor];
        }
        
        [self presentModalViewController:navController animated:YES];
    }
    else
    {
        // Jaundice
        if (indexPath.section == 11)
        {
            if (indexPath.row == 0)
            {
                Preferences *preferences = [Preferences sharedPreferences];
                
                // allow user to enter a bilirubin result for the selected patient
                PhototherapyAddBilirubinResultViewController *newViewController = [[PhototherapyAddBilirubinResultViewController alloc] init];
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.bilirubinUnits = preferences.bilirubinUnits;
                newViewController.delegate = self;
                
                /*
                if (self.dateAndTimeOfBirthForThisChart)
                {
                    newViewController.dateAndTimeOfBirthForThisChart = self.dateAndTimeOfBirthForThisChart;
                }
                 */
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    navController.navigationBar.barTintColor = [UIColor grayColor];
                    navController.navigationBar.tintColor = [UIColor redColor];
                }
                else
                {
                    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                    navController.navigationBar.tintColor = [UIColor blackColor];
                }
                
                [self presentModalViewController:navController animated:YES];
            }
            else
            {
                // Blood Group Info
                JaundiceViewController *newViewController = [[JaundiceViewController alloc] init];
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
                
                // iOS 7 specifics
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
                {
                    navController.navigationBar.barTintColor = [UIColor grayColor];
                    navController.navigationBar.tintColor = [UIColor redColor];
                }
                else
                {
                    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                    navController.navigationBar.tintColor = [UIColor blackColor];
                }
                
                [self presentModalViewController:navController animated:YES];
            }
        }
    }
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedPath = nil;
    
    if ([tableView isEqual:self.myTableView1])
    {
        [self.backgroundTextView resignFirstResponder];
        [self.activeProblemsTextView resignFirstResponder];
        [self.resolvedProblemsTextView resignFirstResponder];
        [self.recentSignificantEventsTextView resignFirstResponder];
        [self.ventilationAndSedationTextView resignFirstResponder];
        [self.cxrTextView resignFirstResponder];
        [self.cardiovascularTextView resignFirstResponder];
        [self.linesTextView resignFirstResponder];
        [self.fluidBalanceTextView resignFirstResponder];
        [self.feedsAndFluidsTextView resignFirstResponder];
        [self.electrolytesTextView resignFirstResponder];
        [self.jaundiceTextView resignFirstResponder];
        [self.sepsisTextView resignFirstResponder];
        [self.drugsTextView resignFirstResponder];
        [self.ropTextView resignFirstResponder];
        [self.cranialUSSTextView resignFirstResponder];
        [self.parentsAndSocialTextView resignFirstResponder];
        [self.impressionTextView resignFirstResponder];
        [self.planTextView resignFirstResponder];
        [self.jobsTextView resignFirstResponder];
    }
    else
    {
        selectedPath = indexPath;
    }
    
    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL userCanEditTextField = YES;
    
    if (self.editing)
    {
        userCanEditTextField = NO;
    }
    
    return userCanEditTextField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    int row = 0;
    
    // Jaundice cell different
    if (textView.tag == 11)
    {
        row = 1;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:textView.tag];
    
    [self.myTableView2 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    // animate the fingerprint in
    // [self animateFingerprintIn];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // instead, check if user is using the 3.5 inch screen or 4 inch screen
    if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
    {
        // animate patient details off to make room
        [self animatePatientDetailsOff];
    }
    
    // change right bar button
    [self.navigationItem setRightBarButtonItem:[CBBarButtonItems infoBarButtonWithTarget:self action:@selector(showModalPanel:)] animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // animate the fingerprint off
    // [self animateFingerprintOut];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
    {
        [self animatePatientDetailsOn];
    }
    
    // change right bar button back
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
}

- (void)formatHeightOfTextView:(UITextView *)textView
{
    HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
    HandoverRow *row;
    
    if (textView.tag == 11)
    {
        row = section.rows[1];
    }
    else
    {
        row = section.rows[0];
    }
    
    float rowHeight = [row.rowHeight floatValue];
    float contentHeight = textView.contentSize.height;
    
    if ((contentHeight + 5.0f) > rowHeight)
    {
        rowHeight += ((contentHeight + 5.0f) - rowHeight);
        
        row.rowHeight = [NSNumber numberWithFloat:rowHeight];
        
        [self.myTableView2 beginUpdates];
        [self.myTableView2 endUpdates];
        
        textView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (textView.contentSize.height + 10.0f));
    }
    else if ((contentHeight + 5.0f) < rowHeight)
    {
        rowHeight -= (rowHeight - (contentHeight + 5.0f));
        
        row.rowHeight = [NSNumber numberWithFloat:rowHeight];
        
        [self.myTableView2 beginUpdates];
        [self.myTableView2 endUpdates];
        
        textView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (textView.contentSize.height + 10.0f));
    }
}

/*
- (NSIndexPath *)keyForIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath class] == [NSIndexPath class])
    {
        return indexPath;
    }
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
}
 */

- (void)textViewDidChange:(UITextView *)textView
{
    // get height of UITextView before change
    CGFloat heightBeforeChange;
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        heightBeforeChange = [self heightForTextView:textView];
    }
    
    // set text
    {
        if ([textView isEqual:self.backgroundTextView])
        {
            self.selectedPatient.background = textView.text;
        }
        else if ([textView isEqual:self.activeProblemsTextView])
        {
            self.selectedPatient.activeProblems = textView.text;
        }
        else if ([textView isEqual:self.resolvedProblemsTextView])
        {
            self.selectedPatient.resolvedProblems = textView.text;
        }
        else if ([textView isEqual:self.recentSignificantEventsTextView])
        {
            self.selectedPatient.recentSignificantEvents = textView.text;
        }
        else if ([textView isEqual:self.ventilationAndSedationTextView])
        {
            self.selectedPatient.ventilationAndSedation = textView.text;
            self.selectedPatient.ventilationAndSedationLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.cxrTextView])
        {
            self.selectedPatient.cxr = textView.text;
        }
        else if ([textView isEqual:self.cardiovascularTextView])
        {
            self.selectedPatient.cardiovascular = textView.text;
        }
        else if ([textView isEqual:self.linesTextView])
        {
            self.selectedPatient.lines = textView.text;
        }
        else if ([textView isEqual:self.feedsAndFluidsTextView])
        {
            self.selectedPatient.feedsAndFluids = textView.text;
            self.selectedPatient.feedsAndFluidLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.fluidBalanceTextView])
        {
            self.selectedPatient.fluidBalance = textView.text;
        }
        else if ([textView isEqual:self.electrolytesTextView])
        {
            self.selectedPatient.electrolytes = textView.text;
        }
        else if ([textView isEqual:self.jaundiceTextView])
        {
            self.selectedPatient.jaundice = textView.text;
        }
        else if ([textView isEqual:self.sepsisTextView])
        {
            self.selectedPatient.sepsis = textView.text;
        }
        else if ([textView isEqual:self.drugsTextView])
        {
            self.selectedPatient.drugs = textView.text;
            self.selectedPatient.drugsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.ropTextView])
        {
            self.selectedPatient.rop = textView.text;
        }
        else if ([textView isEqual:self.cranialUSSTextView])
        {
            self.selectedPatient.cranialUSS = textView.text;
        }
        else if ([textView isEqual:self.parentsAndSocialTextView])
        {
            self.selectedPatient.parentsAndSocial = textView.text;
        }
        else if ([textView isEqual:self.impressionTextView])
        {
            self.selectedPatient.impression = textView.text;
        }
        else if ([textView isEqual:self.planTextView])
        {
            self.selectedPatient.plan = textView.text;
        }
        else if ([textView isEqual:self.jobsTextView])
        {
            self.selectedPatient.jobs = textView.text;
        }
    }
    
    // adjust height
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // check if an update is required
        if (!([self heightForTextView:textView] == heightBeforeChange))
        {
            // update size of textView
            [self setupTextView:textView];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
        }
    }
    else
    {
        // this was just for playing around with
        float adjustment = 0.0f;
        
        // get reference to row data
        HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
        HandoverRow *row;
        
        if (textView.tag == 11)
        {
            row = section.rows[1];
        }
        else
        {
            row = section.rows[0];
        }
        
        // get row height
        float rowHeight = [row.rowHeight floatValue];
        
        // get textView height
        float contentHeight = textView.contentSize.height;
        
        // first check if contentHeight is greater than rowHeight
        // YES...
        if ((contentHeight + adjustment) > rowHeight)
        {
            // update rowHeight
            rowHeight = contentHeight;
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            // update textView frame
            textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, rowHeight);
            
            // update tableView
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
        }
        // NO...
        else if ((contentHeight + adjustment) < rowHeight)
        {
            if (textView.tag == 19) // special case for last one
            {
                if (rowHeight > (346 + adjustment))
                {
                    // rowHeight -= (rowHeight - (contentHeight + adjustment));
                    rowHeight = contentHeight;
                }
            }
            else
            {
                rowHeight = contentHeight;
            }
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, (rowHeight + adjustment));
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
        }
        
        // This is going to be the main code
        // row.rowText = textView.text;
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // reset
    firstButtonPressSinceScroll = YES;
}

#pragma mark - methods

- (void)done
{
    [self.delegate AdvancedPatientEditorViewControllerDidFinish:self];
}

- (void)previousPatientButtonPressed
{
    // load new data in tableView
    newPatientDetails = YES;
    newPatientBackground = YES;
    newActiveProblems = YES;
    newResolvedProblems = YES;
    newRecentSignificantEvents = YES;
    newVentilationAndSedation = YES;
    newCXR = YES;
    newCardiovascular = YES;
    newLines = YES;
    newFeedsAndFluids = YES;
    newFluidBalance = YES;
    newElectrolytes = YES;
    newBiliChart = YES;
    newJaundice = YES;
    newSepsis = YES;
    newDrugs = YES;
    newROP = YES;
    newCranialUSS = YES;
    newParentsAndSocial = YES;
    newImpression = YES;
    newPlan = YES;
    newJobs = YES;
    
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
    
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    [self loadSectionDataForPatientEditing:self.editing];
    
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
    [self.myTableView1 reloadData];
    [self.myTableView2 reloadData];
    
    NSArray *indexPaths = [self.myTableView2 indexPathsForVisibleRows];
    NSIndexPath *indexPathForLastRow = indexPaths[firstButtonPressSinceScroll];
    
    if (selectedBay == 0 && selectedPatientInBay == 0)
    {
        firstButtonPressSinceScroll = YES; // hack to correct the jump that happens when going to first patient in bay 0
    }
    else
    {
        firstButtonPressSinceScroll = NO;
    }

    [self.myTableView2 scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)nextPatientButtonPressed:(UIBarButtonItem *)sender
{
    // load new data in tableView
    newPatientDetails = YES;
    newPatientBackground = YES;
    newActiveProblems = YES;
    newResolvedProblems = YES;
    newRecentSignificantEvents = YES;
    newVentilationAndSedation = YES;
    newCXR = YES;
    newCardiovascular = YES;
    newLines = YES;
    newFeedsAndFluids = YES;
    newFluidBalance = YES;
    newElectrolytes = YES;
    newBiliChart = YES;
    newJaundice = YES;
    newSepsis = YES;
    newDrugs = YES;
    newROP = YES;
    newCranialUSS = YES;
    newParentsAndSocial = YES;
    newImpression = YES;
    newPlan = YES;
    newJobs = YES;
    
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
    
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    [self loadSectionDataForPatientEditing:self.editing];
    
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
    [self.myTableView1 reloadData];
    [self.myTableView2 reloadData];
    
    if (sender.tag == 4)
    {
        // do not jump to the top
        NSArray *indexPaths = [self.myTableView2 indexPathsForVisibleRows];
        NSIndexPath *indexPathForLastRow = indexPaths[firstButtonPressSinceScroll];
        firstButtonPressSinceScroll = NO;
        
        [self.myTableView2 scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        // jumps to the top. i.e. in handover
        [self.myTableView2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)loadShinobiChartWithFrame:(CGRect)frame
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    // NSLog(@"Frame.origin.x = %f", frame.origin.x);
    // NSLog(@"Frame.origin.y = %f", frame.origin.y);
    // NSLog(@"Frame.size.width = %f", frame.size.width);
    // NSLog(@"Frame.size.height = %f", frame.size.height);
    
    // shinobi chart
    
    // set gestation for chart
    self.gestation = [NSNumber numberWithInt:[self.selectedPatient.gestation intValue]];
    NSString *plusString = @"";
    
    if ([self.gestation integerValue] > 38)
    {
        self.gestation = [NSNumber numberWithInteger:38];
        plusString = @"+";
    }
    
    // instantiate array
    self.bilirubinLevelsToPlot = [[NSMutableArray alloc] initWithCapacity:5];
    
    // ShinobiChart
    // self.chart = [[ShinobiChart alloc] initWithFrame:cell.bounds];
    self.chart = [[ShinobiChart alloc] initWithFrame:frame];
    // self.chart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    
    self.chart.title = [NSString stringWithFormat:@"Infants born at %i%@ weeks gestation", [self.gestation intValue], plusString];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.chart.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    self.chart.datasource = self;
    self.chart.delegate = self;
    
    // Double tap can either reset zoom or zoom in
    self.chart.gestureDoubleTapResetsZoom = NO;
    
    // Choose a theme for the chart
    SChartDarkTheme *darkTheme = [SChartDarkTheme new];
    
    // Perform any theme styling here before applying to the chart
    darkTheme.xAxisStyle.minorTickStyle.showTicks = YES;
    darkTheme.yAxisStyle.minorTickStyle.showTicks = YES;
    
    // Apply theme to chart
    self.chart.theme = darkTheme;
    
    // Show the legend
    self.chart.legend.hidden = YES;
    self.chart.legend.placement = SChartLegendPlacementInsidePlotArea;
    
    self.chart.userInteractionEnabled = NO;
    
    self.chart.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    // Use a number axis for the x axis.
    SChartNumberRange *xRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:7]];
    self.xAxis = [[SChartNumberAxis alloc] initWithRange:xRange];
    self.xAxis.title = @"Days";
    self.xAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
    self.xAxis.zoomInLimit = 1;
    self.xAxis.anchorPoint = 0;
    self.xAxis.majorTickFrequency = [NSNumber numberWithDouble:1.00];
    self.xAxis.minorTickFrequency = [NSNumber numberWithDouble:0.25];
    self.xAxis.enableGesturePanning = NO;
    self.xAxis.enableGestureZooming = NO;
    self.xAxis.enableMomentumPanning = NO;
    self.xAxis.enableMomentumZooming = NO;
    self.xAxis.allowPanningOutOfDefaultRange = NO;
    self.xAxis.allowPanningOutOfMaxRange = NO;
    
    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
    {
        // Use a number axis for the y axis.
        SChartNumberRange *yRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:550]];
        self.yAxis = [[SChartNumberAxis alloc] initWithRange:yRange];
        self.yAxis.title = @"Total Serum Bilirubin (µmol/L)";
        self.yAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
        self.yAxis.zoomInLimit = 1;
        self.yAxis.majorTickFrequency = [NSNumber numberWithInt:50];
        self.yAxis.minorTickFrequency = [NSNumber numberWithInt:10];
        self.yAxis.enableGesturePanning = NO;
        self.yAxis.enableGestureZooming = NO;
        self.yAxis.enableMomentumPanning = NO;
        self.yAxis.enableMomentumZooming = NO;
        self.yAxis.allowPanningOutOfDefaultRange = NO;
        self.yAxis.allowPanningOutOfMaxRange = NO;
    }
    else if ([preferences.bilirubinUnits isEqualToString:@"US"])
    {
        // Use a number axis for the y axis.
        SChartNumberRange *yRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:30]];
        self.yAxis = [[SChartNumberAxis alloc] initWithRange:yRange];
        self.yAxis.title = @"Total Serum Bilirubin (mg/dL)";
        self.yAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
        self.yAxis.zoomInLimit = 2;
        self.yAxis.majorTickFrequency = [NSNumber numberWithInt:5];
        self.yAxis.minorTickFrequency = [NSNumber numberWithInt:1];
        self.yAxis.enableGesturePanning = YES;
        self.yAxis.enableGestureZooming = YES;
        self.yAxis.enableMomentumPanning = YES;
        self.yAxis.enableMomentumZooming = YES;
        self.yAxis.allowPanningOutOfDefaultRange = YES;
        self.yAxis.allowPanningOutOfMaxRange = NO;
    }
    
    // ensure all plots can be seen
    
    int maxResultInDays = 7;
    
    int yAxisLimitSI = 550;
    int yAxisLimitUS = 30;
    
    int maxBiliResultSI = 0;
    int maxBiliResultUS = 0;
    
    int i = 0;
    
    if (self.selectedPatient)
    {
        do
        {
            if ([self.selectedPatient.bilirubinResults count] > 0)
            {
                // obtain bilirubin result, sample age, and units
                BilirubinResult *checkResult = [self.selectedPatient.bilirubinResults objectAtIndex:i];
                
                // check if there is a 'cord sample'
                if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                {
                    self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                }
                
                // update maxResultInDays
                if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                {
                    maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                }
                
                // update maxBiliResult
                if ([checkResult.bilirubinUnit isEqualToString:@"SI"])
                {
                    // yes, bilirubin unit is in mmol/L
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultSI)
                    {
                        maxBiliResultSI = [checkResult.bilirubinResult integerValue];
                    }
                    
                    // next check if it is greater than of equal to 550...
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitSI)
                    {
                        // yes it is...
                        yAxisLimitSI = [checkResult.bilirubinResult integerValue] + 25;
                    }
                }
                else // bilirubin unit is in mg/dL
                {
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultUS)
                    {
                        // maxBiliResultUS = [checkResult.bilirubinResult integerValue] + 5;
                        maxBiliResultUS = [checkResult.bilirubinResult integerValue];
                    }
                    
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitUS)
                    {
                        yAxisLimitUS = [checkResult.bilirubinResult integerValue] + 5;
                    }
                }
            }
            
            i = i + 1;
            
        } while (i < [self.selectedPatient.bilirubinResults count]);
        
        // after this we have maxBiliResultSI, maxBiliResultUS, yAxisLimitSI, yAxisLimitUS
        
        // recreate x-Axis
        SChartNumberRange *newxRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
        self.xAxis.defaultRange = newxRange;
        
        // recreate y-Axis
        SChartNumberRange *newyRange;
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            NSLog(@"Chart is in SI units");
            if ((maxBiliResultUS * 17.1) > yAxisLimitSI)
            {
                yAxisLimitSI = (maxBiliResultUS * 17.1) + 25;
            }
            NSLog(@"new yAxisLimitSI = %i", yAxisLimitSI);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitSI]];
            self.yAxis.defaultRange = newyRange;
        }
        else // chart is in mg/dL
        {
            NSLog(@"Chart is in US units");
            if ((maxBiliResultSI / 17.1) > yAxisLimitUS)
            {
                yAxisLimitUS = (maxBiliResultSI / 17.1) + 5;
            }
            NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitUS]];
            self.yAxis.defaultRange = newyRange;
        }
    }
    
    self.chart.xAxis = self.xAxis;
    self.chart.yAxis = self.yAxis;
}

- (NSMutableArray *)loadSectionDataForPatientEditing:(BOOL)editing
{
    NSMutableArray *returnArray = nil;
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // temp toggle to reset cell heights and ability to edit
#if RESET_CELL_INFO
    self.selectedPatient.handoverSections = nil;
#endif
    
    /*
    self.selectedPatient.background = nil;
    self.selectedPatient.activeProblems = nil;
    self.selectedPatient.resolvedProblems = nil;
    self.selectedPatient.recentSignificantEvents = nil;
    self.selectedPatient.ventilationAndSedation = nil;
    self.selectedPatient.cxr = nil;
    self.selectedPatient.cardiovascular = nil;
    self.selectedPatient.lines = nil;
    self.selectedPatient.feedsAndFluids = nil;
    self.selectedPatient.fluidBalance = nil;
    self.selectedPatient.electrolytes = nil;
    self.selectedPatient.jaundice = nil;
    self.selectedPatient.sepsis = nil;
    self.selectedPatient.drugs = nil;
    self.selectedPatient.rop = nil;
    self.selectedPatient.cranialUSS = nil;
    self.selectedPatient.parentsAndSocial = nil;
    self.selectedPatient.impression = nil;
    self.selectedPatient.plan = nil;
    self.selectedPatient.jobs = nil;
     */
    
    // first check to see if any data has alread been added
    if (!self.selectedPatient.handoverSections)
    {
        // instantiate array
        self.selectedPatient.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        HandoverSection *newSection;
        HandoverRow *newRow;
        
        // 00 - Background
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Background";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 01 - Active Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Active Problems";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 02 - Resolved Problems
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Resolved Problems";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 03 - Recent Significant Events
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Recent Significant Events";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 04 - Ventilation & Sedation
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Ventilation & Sedation";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 05 - CXR
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"CXR";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 06 - Cardiovascular
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Cardiovascular";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 07 - Lines
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Lines";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 08 - Feeds & Fluids
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Feeds & Fluids";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 09 - Fluid Balance
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Fluid Balance";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 10 - Biochemistry
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Biochemistry";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 11 - Jaundice
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Jaundice";
        newSection.sectionEditable = @"YES";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:2];
        
        newRow = [[HandoverRow alloc] init];
        // Different graph sizes for iPhone 4 and iPhone 5
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            newRow.rowHeight = [NSNumber numberWithFloat:320.0f];
        }
        else
        {
            newRow.rowHeight = [NSNumber numberWithFloat:260.0f];
        }
        [newSection.rows addObject:newRow];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 12 - Sepsis
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Sepsis";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 13 - Drugs
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Drugs";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 14 - ROP
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"ROP";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 15 - Neurology & Cranial USS
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Neurology & Cranial USS";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 16 - Parents / Social
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Parents / Social";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 17 - Examination
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Examination";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 18 - Summary
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Summary";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:55.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
        
        // 19 - Plan
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Plan";
        newSection.sectionEditable = @"NO";
        newSection.rows = [[NSMutableArray alloc] initWithCapacity:1];
        
        newRow = [[HandoverRow alloc] init];
        newRow.rowHeight = [NSNumber numberWithFloat:346.0f];
        [newSection.rows addObject:newRow];
        
        [self.selectedPatient.handoverSections addObject:newSection];
    }
    
    returnArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    HandoverSection *section;
    
    for (section in self.selectedPatient.handoverSections)
    {
        [returnArray addObject:section.sectionName];
    }
    
    return returnArray;
}

- (void)addTrackBallForUITextView:(UITextView *)textView
{
    
#if UDBARTRACKBALL
    
    [textView setInputAccessoryView:[self trackballAccessoryViewForUITextView:textView]];
    
#endif
    
}

- (void)fingerprintTouched
{
    [self.backgroundTextView resignFirstResponder];
    [self.activeProblemsTextView resignFirstResponder];
    [self.resolvedProblemsTextView resignFirstResponder];
    [self.recentSignificantEventsTextView resignFirstResponder];
    [self.ventilationAndSedationTextView resignFirstResponder];
    [self.cxrTextView resignFirstResponder];
    [self.cardiovascularTextView resignFirstResponder];
    [self.linesTextView resignFirstResponder];
    [self.fluidBalanceTextView resignFirstResponder];
    [self.feedsAndFluidsTextView resignFirstResponder];
    [self.electrolytesTextView resignFirstResponder];
    [self.jaundiceTextView resignFirstResponder];
    [self.sepsisTextView resignFirstResponder];
    [self.drugsTextView resignFirstResponder];
    [self.ropTextView resignFirstResponder];
    [self.cranialUSSTextView resignFirstResponder];
    [self.parentsAndSocialTextView resignFirstResponder];
    [self.impressionTextView resignFirstResponder];
    [self.planTextView resignFirstResponder];
    [self.jobsTextView resignFirstResponder];
    
    if (self.fingerprintButton.hidden == NO)
    {
        self.fingerprintButton.hidden = YES;
    }
}

- (void)animateFingerprintIn
{
    self.fingerprintButton.hidden = NO;
    
    CGFloat animationDuration = 0.5f;
    CGFloat animationDelay = 0.0f;
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.fingerprintButton.alpha = 0.5f;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)animateFingerprintOut
{
    CGFloat animationDuration = 0.25f;
    CGFloat animationDelay = 0.0f;
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.fingerprintButton.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished){
                         
                         self.fingerprintButton.hidden = YES;
                         
                     }];
}

- (void)animatePatientDetailsOff
{
    CGFloat y = self.myTableView1.frame.origin.y - self.myTableView1.frame.size.height;
    CGFloat y2 = self.myTableView2.frame.origin.y - self.myTableView1.frame.size.height;
    
    CGRect patientDetailsEndingFrame = CGRectMake(self.myTableView1.frame.origin.x, y, self.myTableView1.frame.size.width, self.myTableView1.frame.size.height);
    
    CGRect dailySummaryEndingFrame = CGRectMake(self.myTableView2.frame.origin.x, y2, self.myTableView2.frame.size.width, self.myTableView2.frame.size.height);
    
    CGFloat animationDuration = 0.25f;
    CGFloat animationDelay = 0.0f;
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.myTableView1.frame = patientDetailsEndingFrame;
                         self.myTableView2.frame = dailySummaryEndingFrame;
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)animatePatientDetailsOn
{
    CGFloat y = 0.0f;
    CGFloat y2 = self.myTableView2.frame.origin.y + self.myTableView1.frame.size.height;
    
    CGRect patientDetailsEndingFrame = CGRectMake(self.myTableView1.frame.origin.x, y, self.myTableView1.frame.size.width, self.myTableView1.frame.size.height);
    
    CGRect dailySummaryEndingFrame = CGRectMake(self.myTableView2.frame.origin.x, y2, self.myTableView2.frame.size.width, self.myTableView2.frame.size.height);
    
    CGFloat animationDuration = 0.25f;
    CGFloat animationDelay = 0.0f;
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.myTableView1.frame = patientDetailsEndingFrame;
                         self.myTableView2.frame = dailySummaryEndingFrame;
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                         
                     }];
}

- (void)showModalPanel:(id)sender
{
    // this is called from the info box
    
    if (!self.modalPanel)
    {
        // delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // check if user is using the 3.5 inch screen or 4 inch screen
            if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
            {
                self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 170.0f) title:@"Dictation Commands" array:[DictationCommands returnListOfAppleDictationCommands] forTextView:nil];
            }
            else
            {
                self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 260.0f) title:@"Dictation Commands" array:[DictationCommands returnListOfAppleDictationCommands] forTextView:nil];
            }
        }
        else // iOS 5/6
        {
            // check if user is using the 3.5 inch screen or 4 inch screen
            if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
            {
                self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 170.0f) title:@"Dictation Commands" array:[DictationCommands returnListOfAppleDictationCommands] forTextView:nil];
            }
            else
            {
                self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 260.0f) title:@"Dictation Commands" array:[DictationCommands returnListOfAppleDictationCommands] forTextView:nil];
            }
        }
        
        self.modalPanel.delegate = self;
        self.modalPanel.whoCreatedMe = @"InfoBox";
        
        [self.view addSubview:self.modalPanel];
        [self.modalPanel showFromPoint:[sender center]];
    }
    else
    {
        if ([self.modalPanel.whoCreatedMe isEqualToString:@"InfoBox"])
        {
            [self.modalPanel closePressed:nil];
        }
    }
}

- (void)willCloseModalPanel:(CBModalPanel *)modalPanel
{
    self.modalPanel = nil;
}

#pragma mark - ShinobiChart datasource

// Returns the number of series in the specified chart
- (int)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    int numberOfSeries = 0;
    
    // check if gestation has been set
    if (self.selectedPatient.gestation)
    {
        Preferences *preferences = [Preferences sharedPreferences];
        
        if ([preferences.guidelineCountry isEqualToString:@"US"])
        {
            // could implement a conditional statement if user want UK style for US or risk factor lines...
            
            numberOfSeries = 3;
        }
        if ([preferences.guidelineCountry isEqualToString:@"UK"])
        {
            numberOfSeries = 3;
        }
    }
    
    return numberOfSeries;
}

// Returns the series at the specified index for a given chart
-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index
{
    SChartSeries *series = nil;
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        // UK style
        if (self)
        {
            if (index == 0)
            {
                // Customise the Exchange Transfusion series
                SChartLineSeries *exchangeLineSeries = [[SChartLineSeries alloc] init];
                
                exchangeLineSeries.title = @"Exchange Transfusion";
                exchangeLineSeries.style.lineColor = [UIColor redColor];
                exchangeLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
                
                series = exchangeLineSeries;
            }
            else if (index == 1)
            {
                // Customise the Phototherapy series
                SChartLineSeries *phototherapyLineSeries = [[SChartLineSeries alloc] init];
                
                phototherapyLineSeries.title = @"Phototherapy";
                phototherapyLineSeries.style.lineColor = [UIColor blueColor];
                phototherapyLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
                
                series = phototherapyLineSeries;
            }
            else if (index == 2)
            {
                // Customise data plots
                SChartScatterSeries *dataSeries = [[SChartScatterSeries alloc] init];
                dataSeries.style.pointStyle.color = [UIColor clearColor];
                dataSeries.style.pointStyle.innerColor = [UIColor whiteColor];
                
                series = dataSeries;
            }
        }
        else
        {
            if (index == 0)
            {
                // Customise the Lower Risk series
                SChartLineSeries *exchangeLineSeries = [[SChartLineSeries alloc] init];
                
                exchangeLineSeries.title = @"Lower Risk";
                exchangeLineSeries.style.lineColor = [UIColor greenColor];
                exchangeLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
                
                series = exchangeLineSeries;
            }
            else if (index == 1)
            {
                // Customise the Medium Risk series
                SChartLineSeries *phototherapyLineSeries = [[SChartLineSeries alloc] init];
                
                phototherapyLineSeries.title = @"Medium Risk";
                phototherapyLineSeries.style.lineColor = [UIColor orangeColor];
                phototherapyLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
                
                series = phototherapyLineSeries;
            }
            else if (index == 2)
            {
                // Customise the High Risk series
                SChartLineSeries *phototherapyLineSeries = [[SChartLineSeries alloc] init];
                
                phototherapyLineSeries.title = @"High Risk";
                phototherapyLineSeries.style.lineColor = [UIColor redColor];
                phototherapyLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
                
                series = phototherapyLineSeries;
            }
            else if (index == 3)
            {
                // Customise data plots
                SChartScatterSeries *dataSeries = [[SChartScatterSeries alloc] init];
                dataSeries.style.pointStyle.color = [UIColor clearColor];
                dataSeries.style.pointStyle.innerColor = [UIColor whiteColor];
                
                series = dataSeries;
            }
        }
    }
    else if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        if (index == 0)
        {
            // Customise the Exchange Transfusion series
            SChartLineSeries *exchangeLineSeries = [[SChartLineSeries alloc] init];
            
            exchangeLineSeries.title = @"Exchange Transfusion";
            exchangeLineSeries.style.lineColor = [UIColor redColor];
            exchangeLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
            
            series = exchangeLineSeries;
        }
        else if (index == 1)
        {
            // Customise the Phototherapy series
            SChartLineSeries *phototherapyLineSeries = [[SChartLineSeries alloc] init];
            
            phototherapyLineSeries.title = @"Phototherapy";
            phototherapyLineSeries.style.lineColor = [UIColor blueColor];
            phototherapyLineSeries.style.lineWidth = [NSNumber numberWithInt:2];
            
            series = phototherapyLineSeries;
        }
        else if (index == 2)
        {
            // Customise data plots
            SChartScatterSeries *dataSeries = [[SChartScatterSeries alloc] init];
            dataSeries.style.pointStyle.color = [UIColor clearColor];
            dataSeries.style.pointStyle.innerColor = [UIColor whiteColor];
            
            series = dataSeries;
        }
    }
    
    return series;
}

// Returns the number of points for a specific series in the specified chart
- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex
{
    int points = 0;
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        if (self) // change this later to give user an option...re exchange/photo vs risk factor lines
        {
            if(seriesIndex == 0) // Exchange transfusion
            {
                if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
                {
                    // point @ 0 days 16 g/dL
                    // point @ 1 day  19 g/dL
                    // point @ 1.5 d  21 g/dL
                    // point @ 2 days 22 g/dL
                    // point @ 3 days 24 g/dL
                    // point @ 4 days 25 g/dL
                    // point @ 7 days 25 g/dL
                    
                    points = 7;
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
                {
                    // point @ 0 days 13.8 g/dL
                    // point @ 1 day  16.6 g/dL
                    // point @ 2.5 d  20 g/dL
                    // point @ 3.5 days 22 g/dL
                    // point @ 4 days 22.5 g/dL
                    // point @ 7 days 22.5 g/dL
                    
                    points = 6;
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
                {
                    // point @ 0 days 12 g/dL
                    // point @ 1 day  15 g/dL
                    // point @ 2.5 d  18 g/dL
                    // point @ 3 days 18.5 g/dL
                    // point @ 4 days 19 g/dL
                    // point @ 7 days 19 g/dL
                    
                    points = 6;
                }
                else
                {
                    // code
                }
            }
            else if (seriesIndex == 1) // Phototherapy
            {
                if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
                {
                    // point @ 0 days 6.6 g/dL                                          12  0.5         108 4.5
                    // point @ 1 day  11.6 g/dL                                         24  1.0         120 5.0
                    // point @ 1.5 d  13.5 g/dL                                         36  1.5         132 5.5
                    // point @ 2 days 15.2 g/dL                                         48  2.0         144 6.0
                    // point @ 3 days 17.7 g/dL                                         60  2.5         156 6.5
                    // point @ 4 days 19.9 g/dL                                         72  3.0         168 7.0
                    // point @ 5 days 21.0 g/dL                                         84  3.5
                    // point @ 7 days 21.0 g/dL                                         96  4.0
                    
                    points = 8;
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
                {
                    // point @ 0 days   5.0
                    // point @ 0.5 days 7.8
                    // point @ 1 day    9.6
                    // point @ 1.5 days 11.6
                    // point @ 2.0 days 13.0
                    // point @ 2.5 days 14.6
                    // point @ 3.0 days 15.2
                    // point @ 3.5 days 16.4
                    // point @ 4.0 days 17.1
                    // point @ 4.5 days 18.0
                    // point @ 7 days 18
                    
                    points = 10;
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
                {
                    // point @ 0 days   3.7
                    // point @ 0.5 days 6.0
                    // point @ 1 day    7.8
                    // point @ 1.5 days 9.5
                    // point @ 2 days   11.1
                    // point @ 2.5 days 12.5
                    // point @ 3 days   13.5
                    // point @ 3.5 days 14.0
                    // point @ 4 days   14.5
                    // point @ 5 days   15.0
                    // point @ 7 days   15.0
                    
                    points = 11;
                }
                else
                {
                    // code
                }
            }
            else if (seriesIndex == 2) // data points
            {
                if (self.selectedPatient)
                {
                    NSLog(@"self.selectedPatient.bilirubinResults = %i", [self.selectedPatient.bilirubinResults count]);
                    points = [self.selectedPatient.bilirubinResults count];
                }
                else
                {
                    NSLog(@"self.bilirubinLevelsToPlot = %i", [self.bilirubinLevelsToPlot count]);
                    points = [self.bilirubinLevelsToPlot count];
                }
            }
        }
        else
        {
            if(seriesIndex == 0) // Lower Risk
            {
                points = 3;
            }
            else if (seriesIndex == 1) // Medium Risk
            {
                points = 3;
            }
            else if (seriesIndex == 2) // High Risk
            {
                points = 3;
            }
            else if (seriesIndex == 3) // data points
            {
                if (self.selectedPatient)
                {
                    points = [self.selectedPatient.bilirubinResults count];
                }
                else
                {
                    points = [self.bilirubinLevelsToPlot count];
                }
            }
        }
    }
    else if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        if(seriesIndex == 0) // Exchange transfusion
        {
            points = 3;
        }
        else if (seriesIndex == 1) // Phototherapy
        {
            if ([self.gestation integerValue] == 38)
            {
                points = 4;
            }
            else
            {
                points = 3;
            }
        }
        else if (seriesIndex == 2) // data points
        {
            if (self.selectedPatient)
            {
                NSLog(@"self.selectedPatient.bilirubinResults = %i", [self.selectedPatient.bilirubinResults count]);
                points = [self.selectedPatient.bilirubinResults count];
            }
            else
            {
                NSLog(@"self.bilirubinLevelsToPlot = %i", [self.bilirubinLevelsToPlot count]);
                points = [self.bilirubinLevelsToPlot count];
            }
        }
    }
    
    return points;
}

// Returns the data point at the specified index for the given series/chart.
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex
{
    
    //Construct a data point to return
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
    
    // access singleton
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        if (seriesIndex == 0) // Exchange transfusion
        {
            if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
            {
                // point @ 0 days 16 g/dL
                // point @ 1 day  19 g/dL
                // point @ 1.5 d  21 g/dL
                // point @ 2 days 22 g/dL
                // point @ 3 days 24 g/dL
                // point @ 4 days 25 g/dL
                // point @ 7 days 25 g/dL   7 points
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(16.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:16.0];
                    }
                    
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(19.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:19.0];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(20.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:20.5];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(22.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:22.0];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(24.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:24.0];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(25.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:25.0];
                    }
                }
                else if (dataIndex == 6)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(25.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:25.0];
                    }
                }
            }
            else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
            {
                // point @ 0 days 13.8 g/dL
                // point @ 1 day  16.6 g/dL
                // point @ 2.5 d  20 g/dL
                // point @ 3.5 days 22 g/dL
                // point @ 4 days 22.5 g/dL
                // point @ 7 days 22.5 g/dL
                
                // points = 6;
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(13.8 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:13.8];
                    }
                    
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(16.6 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:16.6];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(20.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:20.0];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(22.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:22.0];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(22.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:22.5];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(22.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:22.5];
                    }
                }
            }
            else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
            {
                // point @ 0 days 12 g/dL
                // point @ 1 day  15 g/dL
                // point @ 2.5 d  18 g/dL
                // point @ 3 days 18.5 g/dL
                // point @ 4 days 19 g/dL
                // point @ 7 days 19 g/dL
                
                // points = 6;
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(12.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:12.0];
                    }
                    
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(15.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:15.0];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(18.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:18.0];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(18.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:18.5];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(19.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:19.0];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(19.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:19.0];
                    }
                }
            }
        }
        else if (seriesIndex == 1) // Phototherapy
        {
            if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
            {
                // point @ 0 days 6.6 g/dL
                // point @ 1 day  11.6 g/dL
                // point @ 1.5 d  13.5 g/dL
                // point @ 2 days 15.2 g/dL
                // point @ 3 days 17.7 g/dL
                // point @ 4 days 19.9 g/dL
                // point @ 5 days 21.0
                // point @ 7 days 21.0 g/dL   8 points
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(6.6 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:6.6];
                    }
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(11.6 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:11.6];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(13.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:13.5];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(15.2 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:15.2];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(17.7 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:17.7];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(19.9 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:19.9];
                    }
                }
                else if (dataIndex == 6)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:5.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(21.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:21.0];
                    }
                }
                else if (dataIndex == 7)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(21.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:21.0];
                    }
                }
            }
            else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
            {
                // point @ 0 days   5.0
                // point @ 0.5 days 7.8
                // point @ 1 day    9.6
                // point @ 1.5 days 11.6
                // point @ 2.0 days 13.0
                // point @ 2.5 days 14.6
                // point @ 3.0 days 15.2
                // point @ 3.5 days 16.4
                // point @ 4.0 days 17.1
                // point @ 4.5 days 18.0
                // point @ 7 days 18
                
                // points = 11;
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(5.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:5.0];
                    }
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(7.8 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:7.8];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(9.6 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:9.6];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(11.6 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:11.6];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(13.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:13.0];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(15.2 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:15.2];
                    }
                }
                else if (dataIndex == 6)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(16.4 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:16.4];
                    }
                }
                else if (dataIndex == 7)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(17.3 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:17.3];
                    }
                }
                else if (dataIndex == 8)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(18.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:18.0];
                    }
                }
                else if (dataIndex == 9)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(18.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:18.0];
                    }
                }
            }
            else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
            {
                // point @ 0 days   3.7
                // point @ 0.5 days 6.0
                // point @ 1 day    7.8
                // point @ 1.5 days 9.5
                // point @ 2 days   11.1
                // point @ 2.5 days 12.5
                // point @ 3 days   13.5
                // point @ 3.5 days 14.0
                // point @ 4 days   14.5
                // point @ 5 days   15.0
                // point @ 7 days   15.0
                
                // points = 10;
                
                if (dataIndex == 0)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(3.7 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:3.7];
                    }
                }
                else if (dataIndex == 1)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(6.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:6.0];
                    }
                }
                else if (dataIndex == 2)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(7.8 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:7.8];
                    }
                }
                else if (dataIndex == 3)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(9.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:9.5];
                    }
                }
                else if (dataIndex == 4)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(11.1 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:11.1];
                    }
                }
                else if (dataIndex == 5)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:2.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(12.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:12.5];
                    }
                }
                else if (dataIndex == 6)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(13.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:13.5];
                    }
                }
                else if (dataIndex == 7)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.5];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(14.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:14.0];
                    }
                }
                else if (dataIndex == 8)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(14.5 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:14.5];
                    }
                }
                else if (dataIndex == 9)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:5.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(15.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:15.0];
                    }
                }
                else if (dataIndex == 10)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:7.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(15.0 * 17.1)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:15.0];
                    }
                }
            }
        }
        else if (seriesIndex == 2)
        {
            // NSLog(@"Plotting data points - dataIndex = %i", dataIndex);
            
            BilirubinResult *resultToPlot;
            
            if (self.selectedPatient)
            {
                resultToPlot = (BilirubinResult *)[self.selectedPatient.bilirubinResults objectAtIndex:dataIndex];
            }
            else
            {
                resultToPlot = (BilirubinResult *)[self.bilirubinLevelsToPlot objectAtIndex:dataIndex];
            }
            
            datapoint.xValue = resultToPlot.sampleAgeInDays;
            
            if ([preferences.bilirubinUnits isEqualToString:@"SI"])
            {
                if ([resultToPlot.bilirubinUnit isEqualToString:@"SI"])
                {
                    datapoint.yValue = resultToPlot.bilirubinResult;
                }
                else if ([resultToPlot.bilirubinUnit isEqualToString:@"US"])
                {
                    NSNumber *convertedBilirubinResult;
                    
                    convertedBilirubinResult = [NSNumber numberWithDouble:([resultToPlot.bilirubinResult doubleValue] * 17.1)];
                    
                    datapoint.yValue = convertedBilirubinResult;
                }
            }
            else if ([preferences.bilirubinUnits isEqualToString:@"US"])
            {
                if ([resultToPlot.bilirubinUnit isEqualToString:@"US"])
                {
                    datapoint.yValue = resultToPlot.bilirubinResult;
                }
                else if ([resultToPlot.bilirubinUnit isEqualToString:@"SI"])
                {
                    NSNumber *convertedBilirubinResult;
                    
                    convertedBilirubinResult = [NSNumber numberWithDouble:([resultToPlot.bilirubinResult doubleValue] / 17.1)];
                    
                    datapoint.yValue = convertedBilirubinResult;
                }
            }
        }
    }
    else if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        if (seriesIndex == 0) // Exchange transfusion
        {
            if (dataIndex == 0)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:100];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(100 / 17.1)];
                    }
                }
                else
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:80];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(80 / 17.1)];
                    }
                }
            }
            else if (dataIndex == 1)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.75];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:450];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(450 / 17.1)];
                    }
                }
                else
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.00];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:([self.gestation doubleValue] * 10)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(([self.gestation doubleValue] * 10) / 17.1)];
                    }
                }
            }
            else if (dataIndex == 2)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:14.00];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:450];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(450 / 17.1)];
                    }
                }
                else
                {
                    // day 14
                    datapoint.xValue = [NSNumber numberWithDouble:14.00];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:([self.gestation doubleValue] * 10)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(([self.gestation doubleValue] * 10) / 17.1)];
                    }
                }
                
            }
        }
        else if (seriesIndex == 1) // Phototherapy
        {
            if (dataIndex == 0)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:100];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(100 / 17.1)];
                    }
                }
                else
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:40];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(40 / 17.1)];
                    }
                }
            }
            else if (dataIndex == 1)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:1.0];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:200];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(200 / 17.1)];
                    }
                }
                else
                {
                    datapoint.xValue = [NSNumber numberWithDouble:3.00];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(([self.gestation doubleValue] * 10) - 100)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:((([self.gestation doubleValue] * 10) - 100) / 17.1)];
                    }
                }
            }
            else if (dataIndex == 2)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:4];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:350];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(350 / 17.1)];
                    }
                }
                else
                {
                    datapoint.xValue = [NSNumber numberWithDouble:14.00];
                    
                    if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:(([self.gestation doubleValue] * 10) - 100)];
                    }
                    else
                    {
                        datapoint.yValue = [NSNumber numberWithDouble:((([self.gestation doubleValue] * 10) - 100) / 17.1)];
                    }
                }
            }
            else if (dataIndex == 3)
            {
                datapoint.xValue = [NSNumber numberWithDouble:14];
                
                if ([preferences.bilirubinUnits isEqualToString:@"SI"])
                {
                    datapoint.yValue = [NSNumber numberWithDouble:350];
                }
                else
                {
                    datapoint.yValue = [NSNumber numberWithDouble:(350 / 17.1)];
                }
            }
        }
        else if (seriesIndex == 2)
        {
            // NSLog(@"Plotting data points - dataIndex = %i", dataIndex);
            
            BilirubinResult *resultToPlot;
            
            if (self.selectedPatient)
            {
                // NSLog(@"resultToPlot = self.selectedPatient.bilirubinResults objectAtIndex:dataIndex");
                resultToPlot = (BilirubinResult *)[self.selectedPatient.bilirubinResults objectAtIndex:dataIndex];
            }
            else
            {
                // NSLog(@"resultToPlot = self.bilirubinLevelsToPlot objectAtIndex:dataIndex");
                resultToPlot = (BilirubinResult *)[self.bilirubinLevelsToPlot objectAtIndex:dataIndex];
            }
            
            datapoint.xValue = resultToPlot.sampleAgeInDays;
            
            if ([preferences.bilirubinUnits isEqualToString:@"SI"])
            {
                if ([resultToPlot.bilirubinUnit isEqualToString:@"SI"])
                {
                    datapoint.yValue = resultToPlot.bilirubinResult;
                }
                else if ([resultToPlot.bilirubinUnit isEqualToString:@"US"])
                {
                    NSNumber *convertedBilirubinResult;
                    
                    convertedBilirubinResult = [NSNumber numberWithDouble:([resultToPlot.bilirubinResult doubleValue] * 17.1)];
                    
                    datapoint.yValue = convertedBilirubinResult;
                }
            }
            else if ([preferences.bilirubinUnits isEqualToString:@"US"])
            {
                if ([resultToPlot.bilirubinUnit isEqualToString:@"US"])
                {
                    datapoint.yValue = resultToPlot.bilirubinResult;
                }
                else if ([resultToPlot.bilirubinUnit isEqualToString:@"SI"])
                {
                    NSNumber *convertedBilirubinResult;
                    
                    convertedBilirubinResult = [NSNumber numberWithDouble:([resultToPlot.bilirubinResult doubleValue] / 17.1)];
                    
                    datapoint.yValue = convertedBilirubinResult;
                }
            }
        }
    }
    else
    {
        NSLog(@"ERROR");
    }
    
    return datapoint;
}

#pragma mark - ShinobiChart delegate

- (void)sChartRenderFinished:(ShinobiChart *)chart
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if (!landscapeOrientationDefaultsSet)
        {
            if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
                {
                    self.title = @"Lower risk lines (US 2004 AAP Guideline)";
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
                {
                    self.title = @"Medium risk lines (US 2004 AAP Guideline)";
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
                {
                    self.title = @"Higher risk lines (US 2004 AAP Guidelines)";
                }
                
                SChartNumberRange *xRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:7]];
                self.xAxis.defaultRange = xRange;
                self.xAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
            }
            else if ([preferences.guidelineCountry isEqualToString:@"UK"])
            {
                if ([self.gestation isEqualToNumber:[NSNumber numberWithInt:38]])
                {
                    self.title = [NSString stringWithFormat:@"Born at %@+/40 (UK NICE Guidelines)", self.gestation];
                }
                else
                {
                    self.title = [NSString stringWithFormat:@"Born at %@/40 (UK NICE Guidelines)", self.gestation];
                }
                
                SChartNumberRange *xRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:14]];
                self.xAxis.defaultRange = xRange;
                self.xAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
            }
            
            self.chart.title = @"Treatment threshold graph for babies with neonatal jaundice";
            
            int maxResultInDays = 7;
            
            int i = 0;
            
            if (self.selectedPatient)
            {
                do
                {
                    if ([self.selectedPatient.bilirubinResults count] > 0)
                    {
                        BilirubinResult *checkResult = [self.selectedPatient.bilirubinResults objectAtIndex:i];
                        
                        // update maxResultInDays
                        if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                        {
                            maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                        }
                        
                        // check if there is a 'cord sample'
                        if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                        {
                            self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                        }
                    }
                    
                    i = i + 1;
                    
                } while (i < [self.selectedPatient.bilirubinResults count]);
            }
            else
            {
                do
                {
                    if ([self.bilirubinLevelsToPlot count] > 0)
                    {
                        BilirubinResult *checkResult = [self.bilirubinLevelsToPlot objectAtIndex:i];
                        
                        // update maxResultInDays
                        if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                        {
                            maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                        }
                        
                        // check if there is a 'cord sample'
                        if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                        {
                            self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                        }
                    }
                    
                    i = i + 1;
                    
                } while (i < [self.bilirubinLevelsToPlot count]);
            }
            
            SChartNumberRange *xRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
            self.xAxis.defaultRange = xRange;
            self.xAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
            
            landscapeOrientationDefaultsSet = YES;
            portraitOrientationDefaultsSet = NO;
        }
    }
    else // portrait
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (!portraitOrientationDefaultsSet)
        {
            if ([preferences.guidelineCountry isEqualToString:@"US"]) // setting view controller title
            {
                if ([self.neurotoxicityRisk isEqualToString:@"Lower"])
                {
                    self.title = @"Lower risk lines";
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Medium"])
                {
                    self.title = @"Medium risk lines";
                }
                else if ([self.neurotoxicityRisk isEqualToString:@"Higher"])
                {
                    self.title = @"Higher risk lines";
                }
            }
            else
            {
                if ([self.gestation isEqualToNumber:[NSNumber numberWithInt:38]])
                {
                    self.title = [NSString stringWithFormat:@"Born at %@+/40", self.gestation];
                }
                else
                {
                    self.title = [NSString stringWithFormat:@"Born at %@/40", self.gestation];
                }
            }
            
            self.chart.title = @"Treatment threshold graph for jaundice"; // setting graph title
            
            // iOS 7 specifics
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                self.chart.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            }
            
            int maxResultInDays = 7;
            
            int i = 0;
            
            if (self.selectedPatient)
            {
                do
                {
                    if ([self.selectedPatient.bilirubinResults count] > 0)
                    {
                        BilirubinResult *checkResult = [self.selectedPatient.bilirubinResults objectAtIndex:i];
                        
                        // update maxResultInDays
                        if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                        {
                            maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                        }
                        
                        // check if there is a 'cord sample'
                        if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                        {
                            self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                        }
                    }
                    
                    i = i + 1;
                    
                } while (i < [self.selectedPatient.bilirubinResults count]);
            }
            else
            {
                do
                {
                    if ([self.bilirubinLevelsToPlot count] > 0)
                    {
                        BilirubinResult *checkResult = [self.bilirubinLevelsToPlot objectAtIndex:i];
                        
                        // update maxResultInDays
                        if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                        {
                            maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                        }
                        
                        // check if there is a 'cord sample'
                        if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                        {
                            self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                        }
                    }
                    
                    i = i + 1;
                    
                } while (i < [self.bilirubinLevelsToPlot count]);
            }
            
            SChartNumberRange *xRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
            self.xAxis.defaultRange = xRange;
            self.xAxis.rangePaddingHigh = [NSNumber numberWithFloat:0.25f];
            
            portraitOrientationDefaultsSet = YES;
            landscapeOrientationDefaultsSet = NO;
        }
    }
}

#pragma mark - PatientDetailsViewController delegate

- (void)patientDetailsViewController:(PatientDetailsViewController *)controller didFinishEditingPatient:(Patient *)patient
{
    newPatientDetails = YES;
    
    [self.myTableView1 reloadData];
    [self.myTableView2 reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
    
    self.editing = NO;
}

#pragma mark - PhototherapyAddBilirubinResult delegate

- (void)phototherapyAddBilirubinResultViewController:(PhototherapyAddBilirubinResultViewController *)controller didFinishAddingNewBilirubinResult:(BilirubinResult *)result forBirthDate:(NSDate *)date
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (self.selectedPatient)
    {
        if (!self.selectedPatient.bilirubinResults)
        {
            self.selectedPatient.bilirubinResults = [[NSMutableArray alloc] initWithCapacity:5];
        }
        
        [self.selectedPatient.bilirubinResults addObject:result];
    }
    else
    {
        [self.bilirubinLevelsToPlot addObject:result];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    landscapeOrientationDefaultsSet = NO;
    portraitOrientationDefaultsSet = NO;
    
    //
    // ensure all plots can be seen
    
    int maxResultInDays = 7;
    
    int yAxisLimitSI = 550;
    int yAxisLimitUS = 30;
    
    int maxBiliResultSI = 0;
    int maxBiliResultUS = 0;
    
    int i = 0;
    
    if (self.selectedPatient)
    {
        NSLog(@" ");
        NSLog(@" ");
        NSLog(@"selectedPatient diagnostic");
        
        do
        {
            if ([self.selectedPatient.bilirubinResults count] > 0)
            {
                // obtain bilirubin result, sample age, and units
                BilirubinResult *checkResult = [self.selectedPatient.bilirubinResults objectAtIndex:i];
                
                // check if there is a 'cord sample'
                if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                {
                    self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                }
                
                // update maxResultInDays
                if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                {
                    maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                }
                
                // update maxBiliResult
                if ([checkResult.bilirubinUnit isEqualToString:@"SI"])
                {
                    // yes, bilirubin unit is in mmol/L
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultSI)
                    {
                        maxBiliResultSI = [checkResult.bilirubinResult integerValue];
                    }
                    
                    // next check if it is greater than of equal to 550...
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitSI)
                    {
                        // yes it is...
                        yAxisLimitSI = [checkResult.bilirubinResult integerValue] + 25;
                    }
                }
                else // bilirubin unit is in mg/dL
                {
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultUS)
                    {
                        // maxBiliResultUS = [checkResult.bilirubinResult integerValue] + 5;
                        maxBiliResultUS = [checkResult.bilirubinResult integerValue];
                    }
                    
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitUS)
                    {
                        yAxisLimitUS = [checkResult.bilirubinResult integerValue] + 5;
                    }
                }
            }
            
            i = i + 1;
            
        } while (i < [self.selectedPatient.bilirubinResults count]);
        
        // after this we have maxBiliResultSI, maxBiliResultUS, yAxisLimitSI, yAxisLimitUS
        
        NSLog(@"maxBiliResultSI = %i", maxBiliResultSI);
        NSLog(@"maxBiliResultUS = %i", maxBiliResultUS);
        NSLog(@" ");
        NSLog(@"yAxisLimitSI = %i", yAxisLimitSI);
        NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
        NSLog(@" ");
        
        // recreate x-Axis
        SChartNumberRange *newxRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
        self.xAxis.defaultRange = newxRange;
        
        // recreate y-Axis
        SChartNumberRange *newyRange;
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            NSLog(@"Chart is in SI units");
            if ((maxBiliResultUS * 17.1) > yAxisLimitSI)
            {
                yAxisLimitSI = (maxBiliResultUS * 17.1) + 25;
            }
            NSLog(@"new yAxisLimitSI = %i", yAxisLimitSI);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitSI]];
            self.yAxis.defaultRange = newyRange;
        }
        else // chart is in mg/dL
        {
            NSLog(@"Chart is in US units");
            if ((maxBiliResultSI / 17.1) > yAxisLimitUS)
            {
                yAxisLimitUS = (maxBiliResultSI / 17.1) + 5;
            }
            NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitUS]];
            self.yAxis.defaultRange = newyRange;
        }
    }
    else
    {
        NSLog(@" ");
        NSLog(@" ");
        NSLog(@"NO selectedPatient diagnostic");
        
        do
        {
            if ([self.bilirubinLevelsToPlot count] > 0)
            {
                // obtain bilirubin result, sample age, and units
                BilirubinResult *checkResult = [self.bilirubinLevelsToPlot objectAtIndex:i];
                
                // check if there is a 'cord sample'
                if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                {
                    self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                }
                
                // update maxResultInDays
                if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                {
                    maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                }
                
                // update maxBiliResult
                if ([checkResult.bilirubinUnit isEqualToString:@"SI"])
                {
                    // yes, bilirubin unit is in mmol/L
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultSI)
                    {
                        maxBiliResultSI = [checkResult.bilirubinResult integerValue];
                    }
                    
                    // next check if it is greater than of equal to 550...
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitSI)
                    {
                        // yes it is...
                        yAxisLimitSI = [checkResult.bilirubinResult integerValue] + 25;
                    }
                }
                else // bilirubin unit is in mg/dL
                {
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultUS)
                    {
                        // maxBiliResultUS = [checkResult.bilirubinResult integerValue] + 5;
                        maxBiliResultUS = [checkResult.bilirubinResult integerValue];
                    }
                    
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitUS)
                    {
                        yAxisLimitUS = [checkResult.bilirubinResult integerValue] + 5;
                    }
                }
            }
            
            i = i + 1;
            
        } while (i < [self.bilirubinLevelsToPlot count]);
        
        // after this we have maxBiliResultSI, maxBiliResultUS, yAxisLimitSI, yAxisLimitUS
        
        NSLog(@"maxBiliResultSI = %i", maxBiliResultSI);
        NSLog(@"maxBiliResultUS = %i", maxBiliResultUS);
        NSLog(@" ");
        NSLog(@"yAxisLimitSI = %i", yAxisLimitSI);
        NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
        NSLog(@" ");
        
        // recreate x-Axis
        SChartNumberRange *newxRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
        self.xAxis.defaultRange = newxRange;
        
        // recreate y-Axis
        SChartNumberRange *newyRange;
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            NSLog(@"Chart is in SI units");
            if ((maxBiliResultUS * 17.1) > yAxisLimitSI)
            {
                yAxisLimitSI = (maxBiliResultUS * 17.1) + 25;
            }
            NSLog(@"new yAxisLimitSI = %i", yAxisLimitSI);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitSI]];
            self.yAxis.defaultRange = newyRange;
        }
        else // chart is in mg/dL
        {
            NSLog(@"Chart is in US units");
            if ((maxBiliResultSI / 17.1) > yAxisLimitUS)
            {
                yAxisLimitUS = (maxBiliResultSI / 17.1) + 5;
            }
            NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitUS]];
            self.yAxis.defaultRange = newyRange;
        }
        
    }
    
    [self.chart reloadData];
    [self.chart redrawChart];
    
    // self.dateAndTimeOfBirthForThisChart = date;
}

- (void)phototherapyAddBilirubinResultViewControllerDidFinishDeletingBilirubinResults:(PhototherapyAddBilirubinResultViewController *)controller
{
    // access singleton
    Preferences *preferences = [Preferences sharedPreferences];
    
    //
    // ensure all plots can be seen
    
    int maxResultInDays = 7;
    
    int yAxisLimitSI = 550;
    int yAxisLimitUS = 30;
    
    int maxBiliResultSI = 0;
    int maxBiliResultUS = 0;
    
    int i = 0;
    
    if (self.selectedPatient)
    {
        NSLog(@" ");
        NSLog(@" ");
        NSLog(@"selectedPatient diagnostic");
        
        do
        {
            if ([self.selectedPatient.bilirubinResults count] > 0)
            {
                // obtain bilirubin result, sample age, and units
                BilirubinResult *checkResult = [self.selectedPatient.bilirubinResults objectAtIndex:i];
                
                // check if there is a 'cord sample'
                if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                {
                    self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                }
                
                // update maxResultInDays
                if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                {
                    maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                }
                
                // update maxBiliResult
                if ([checkResult.bilirubinUnit isEqualToString:@"SI"])
                {
                    // yes, bilirubin unit is in mmol/L
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultSI)
                    {
                        maxBiliResultSI = [checkResult.bilirubinResult integerValue];
                    }
                    
                    // next check if it is greater than of equal to 550...
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitSI)
                    {
                        // yes it is...
                        yAxisLimitSI = [checkResult.bilirubinResult integerValue] + 25;
                    }
                }
                else // bilirubin unit is in mg/dL
                {
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultUS)
                    {
                        // maxBiliResultUS = [checkResult.bilirubinResult integerValue] + 5;
                        maxBiliResultUS = [checkResult.bilirubinResult integerValue];
                    }
                    
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitUS)
                    {
                        yAxisLimitUS = [checkResult.bilirubinResult integerValue] + 5;
                    }
                }
            }
            
            i = i + 1;
            
        } while (i < [self.selectedPatient.bilirubinResults count]);
        
        // after this we have maxBiliResultSI, maxBiliResultUS, yAxisLimitSI, yAxisLimitUS
        
        NSLog(@"maxBiliResultSI = %i", maxBiliResultSI);
        NSLog(@"maxBiliResultUS = %i", maxBiliResultUS);
        NSLog(@" ");
        NSLog(@"yAxisLimitSI = %i", yAxisLimitSI);
        NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
        NSLog(@" ");
        
        // recreate x-Axis
        SChartNumberRange *newxRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
        self.xAxis.defaultRange = newxRange;
        
        // recreate y-Axis
        SChartNumberRange *newyRange;
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            NSLog(@"Chart is in SI units");
            if ((maxBiliResultUS * 17.1) > yAxisLimitSI)
            {
                yAxisLimitSI = (maxBiliResultUS * 17.1) + 25;
            }
            NSLog(@"new yAxisLimitSI = %i", yAxisLimitSI);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitSI]];
            self.yAxis.defaultRange = newyRange;
        }
        else // chart is in mg/dL
        {
            NSLog(@"Chart is in US units");
            if ((maxBiliResultSI / 17.1) > yAxisLimitUS)
            {
                yAxisLimitUS = (maxBiliResultSI / 17.1) + 5;
            }
            NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitUS]];
            self.yAxis.defaultRange = newyRange;
        }
    }
    else
    {
        NSLog(@" ");
        NSLog(@" ");
        NSLog(@"NO selectedPatient diagnostic");
        
        do
        {
            if ([self.bilirubinLevelsToPlot count] > 0)
            {
                // obtain bilirubin result, sample age, and units
                BilirubinResult *checkResult = [self.bilirubinLevelsToPlot objectAtIndex:i];
                
                // check if there is a 'cord sample'
                if ([checkResult.sampleAgeInDays doubleValue] <= 0.08)
                {
                    self.xAxis.rangePaddingLow = [NSNumber numberWithFloat:0.08f];
                }
                
                // update maxResultInDays
                if ([checkResult.sampleAgeInDays integerValue] >= maxResultInDays)
                {
                    maxResultInDays = [checkResult.sampleAgeInDays integerValue] + 1;
                }
                
                // update maxBiliResult
                if ([checkResult.bilirubinUnit isEqualToString:@"SI"])
                {
                    // yes, bilirubin unit is in mmol/L
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultSI)
                    {
                        maxBiliResultSI = [checkResult.bilirubinResult integerValue];
                    }
                    
                    // next check if it is greater than of equal to 550...
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitSI)
                    {
                        // yes it is...
                        yAxisLimitSI = [checkResult.bilirubinResult integerValue] + 25;
                    }
                }
                else // bilirubin unit is in mg/dL
                {
                    if ([checkResult.bilirubinResult integerValue] > maxBiliResultUS)
                    {
                        // maxBiliResultUS = [checkResult.bilirubinResult integerValue] + 5;
                        maxBiliResultUS = [checkResult.bilirubinResult integerValue];
                    }
                    
                    if ([checkResult.bilirubinResult integerValue] >= yAxisLimitUS)
                    {
                        yAxisLimitUS = [checkResult.bilirubinResult integerValue] + 5;
                    }
                }
            }
            
            i = i + 1;
            
        } while (i < [self.bilirubinLevelsToPlot count]);
        
        // after this we have maxBiliResultSI, maxBiliResultUS, yAxisLimitSI, yAxisLimitUS
        
        NSLog(@"maxBiliResultSI = %i", maxBiliResultSI);
        NSLog(@"maxBiliResultUS = %i", maxBiliResultUS);
        NSLog(@" ");
        NSLog(@"yAxisLimitSI = %i", yAxisLimitSI);
        NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
        NSLog(@" ");
        
        // recreate x-Axis
        SChartNumberRange *newxRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:maxResultInDays]];
        self.xAxis.defaultRange = newxRange;
        
        // recreate y-Axis
        SChartNumberRange *newyRange;
        if ([preferences.bilirubinUnits isEqualToString:@"SI"])
        {
            NSLog(@"Chart is in SI units");
            if ((maxBiliResultUS * 17.1) > yAxisLimitSI)
            {
                yAxisLimitSI = (maxBiliResultUS * 17.1) + 25;
            }
            NSLog(@"new yAxisLimitSI = %i", yAxisLimitSI);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitSI]];
            self.yAxis.defaultRange = newyRange;
        }
        else // chart is in mg/dL
        {
            NSLog(@"Chart is in US units");
            if ((maxBiliResultSI / 17.1) > yAxisLimitUS)
            {
                yAxisLimitUS = (maxBiliResultSI / 17.1) + 5;
            }
            NSLog(@"yAxisLimitUS = %i", yAxisLimitUS);
            
            newyRange = [[SChartNumberRange alloc] initWithMinimum:[NSNumber numberWithInt:0] andMaximum:[NSNumber numberWithInt:yAxisLimitUS]];
            self.yAxis.defaultRange = newyRange;
        }
        
    }
    
    [self.chart reloadData];
    [self.chart redrawChart];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)phototherapyAddBilirubinResultViewControllerDidCancel:(PhototherapyAddBilirubinResultViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - JaundiceViewController delegate

- (void)jaundiceViewControllerDidFinish:(JaundiceViewController *)controller withResults:(NSMutableArray *)results
{
    // set values for selected patient
    self.selectedPatient.maternalBloodGroup = results[0];
    self.selectedPatient.maternalRhesus = results[1];
    self.selectedPatient.maternalAntibodies = results[2];
    self.selectedPatient.babyBloodGroup = results[3];
    self.selectedPatient.babyRhesus = results[4];
    self.selectedPatient.dct = results[5];
    
    // format baby blood group and rhesus status
    NSString *maternalBloodGroupFormatted;
    
    if ([self.selectedPatient.maternalBloodGroup isEqualToString:@"?"] || [self.selectedPatient.maternalRhesus isEqualToString:@"?"])
    {
        maternalBloodGroupFormatted = @"unknown";
    }
    else
    {
        if ([self.selectedPatient.maternalAntibodies isEqualToString:@"?"])
        {
            maternalBloodGroupFormatted = [NSString stringWithFormat:@"%@ Rh D %@", self.selectedPatient.maternalBloodGroup, self.selectedPatient.maternalRhesus];
        }
        else
        {
            maternalBloodGroupFormatted = [NSString stringWithFormat:@"%@ Rh D %@ %@", self.selectedPatient.maternalBloodGroup, self.selectedPatient.maternalRhesus, self.selectedPatient.maternalAntibodies];
        }
    }
    
    // format baby blood group and rhesus status
    NSString *babyBloodGroupFormatted;
    
    if ([self.selectedPatient.babyBloodGroup isEqualToString:@"?"] || [self.selectedPatient.babyRhesus isEqualToString:@"?"])
    {
        babyBloodGroupFormatted = @"unknown";
    }
    else
    {
        babyBloodGroupFormatted = [NSString stringWithFormat:@"%@ Rh D %@", self.selectedPatient.babyBloodGroup, self.selectedPatient.babyRhesus];
    }
    
    // format DCT
    NSString *dctFormatted;
    
    if ([self.selectedPatient.dct isEqualToString:@"?"])
    {
        dctFormatted = @"unknown";
    }
    else
    {
        dctFormatted = self.selectedPatient.dct;
    }
    
    // create formatted string to add to handover sheet
    NSString *formattedText;
    // check if jaundice property is empty or set to @""
    if ((![self.selectedPatient.jaundice isEqualToString:@""]) || !self.selectedPatient.jaundice)
    {
        // add the next text above the current text
        formattedText = [NSString stringWithFormat:@"Mother\t: %@\nBaby\t: %@\nDCT\t\t: %@\n\n%@", maternalBloodGroupFormatted, babyBloodGroupFormatted, dctFormatted, self.selectedPatient.jaundice];
    }
    else
    {
        // fill the UITextView with new textman
        formattedText = [NSString stringWithFormat:@"Mother\t: %@\nBaby\t: %@\nDCT\t\t: %@",maternalBloodGroupFormatted, babyBloodGroupFormatted, dctFormatted];
    }
    
    // set the text in the TextView
    self.jaundiceTextView.text = formattedText;
    
    // adjust the height of the Jaundice TextView
    [self textViewDidChange:self.jaundiceTextView];
    
    // dismiss the JaundiceViewController
    [self dismissModalViewControllerAnimated:YES];
}

- (void)jaundiceViewControllerDidCancel:(JaundiceViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - DailySummaryPDFViewController delegate

- (void)DailySummaryPDFViewControllerSelectedPreviousPatient:(DailySummaryPDFViewController *)controller
{
    [self previousPatientButtonPressed];
}

- (void)DailySummaryPDFViewControllerSelectedNextPatient:(DailySummaryPDFViewController *)controller
{
    [self nextPatientButtonPressed:nil];
}

#pragma mark - PDF

- (void)prepareDailySummaryPDFForPatient
{
    DailySummaryPDFViewController *newViewController = [[DailySummaryPDFViewController alloc] init];
    newViewController.selectedPatient = self.selectedPatient;
    newViewController.bayData = self.bayData;
    newViewController.delegate = self;
    newViewController.selectedBayNSNumber = [NSNumber numberWithInt:selectedBay];
    newViewController.selectedPatientInBayNSNumber = [NSNumber numberWithInt:selectedPatientInBay];
    
    /*
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 640.0f, 640.0f)];
    
    [tempView addSubview:self.chart];
    
    UIGraphicsBeginImageContext(tempView.bounds.size);
    
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    newViewController.phototherapyChart = self.shinobiChartImage;
     */
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (UIView *)trackballAccessoryViewForUITextView:(UITextView *)textView
{
    // Tool 1: Simple tool
    // UIToolbar *trackballToolbar = [[UIToolbar alloc] init];
    // [trackballToolbar sizeToFit];
    // [trackballToolbar setTintColor:[UIColor colorWithRed:145/255. green:153/255. blue:164/255. alpha:1]];
    
    // Tool 2: Special input accessory view; allows smaller height in landscape orientation
    
    // Create toolbar
    UIToolbar *trackballToolbar = [UDInputAccessoryView new];
    
    // create trackball
    UDBarTrackballItem *trackball = [[UDBarTrackballItem alloc] initForTextView:textView];
    
    // create left custom text button
    CBBarCustomTextItem *customText1 = [[CBBarCustomTextItem alloc] initForTextView:textView withButtonText:@"done"
                                                              insertingTextViewText:@""];
    customText1.delegate = self;
    
    // create right custom text button
    CBBarCustomTextItem *customText2 = [[CBBarCustomTextItem alloc] initForTextView:textView withButtonText:@"custom"
                                                              insertingTextViewText:@""];
    customText2.delegate = self;
    
    /* Spacer, if required
     UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     */
    
    [trackballToolbar setItems:@[customText2, trackball, customText1] animated:YES];
    
    return trackballToolbar;
}

#pragma mark - CBBarCustomTextItem delegate

- (void)CBBarButtonTextItem:(CBBarCustomTextItem *)sender wasPressedInTextView:(UITextView *)textView
{
    // work out which button was pressed
    if ([sender.buttonText isEqualToString:@"done"])
    {
        // close modal
        [self.modalPanel closePressed:nil];
        
        // close keyboard
        [textView resignFirstResponder];
    }
    else if ([sender.buttonText isEqualToString:@"custom"])
    {
        if (!self.modalPanel)
        {
            // get array
            Preferences *preferences = [Preferences sharedPreferences];
            
            HandoverSection *section = preferences.handoverSections[textView.tag];
            
            // setup modal
            
            // delegate
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            // iOS 7 specifics
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                // instead, check if user is using the 3.5 inch screen or 4 inch screen
                if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 170.0f) title:@"Custom text" array:section.customText forTextView:textView];
                }
                else
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 260.0f) title:@"Custom text" array:section.customText forTextView:textView];
                }
            }
            else
            {
                // instead, check if user is using the 3.5 inch screen or 4 inch screen
                if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 170.0f) title:@"Custom text" array:section.customText forTextView:textView];
                }
                else
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 260.0f) title:@"Custom text" array:section.customText forTextView:textView];
                }
            }
            
            self.modalPanel.delegate = self;
            self.modalPanel.whoCreatedMe = @"CustomButton";
            
            // add modal
            [self.view addSubview:self.modalPanel];
            
            // show from button
            [self.modalPanel showFromPoint:CGPointMake(20.0f, 300.0f)];
        }
        else
        {
            if ([self.modalPanel.whoCreatedMe isEqualToString:@"CustomButton"])
            {
                // close modal
                [self.modalPanel closePressed:nil];
            }
        }
    }
}

#pragma mark - CBModalPanel delegate

- (void)CBModalPanelUserDidSelectCustomTextToPaste:(CBModalPanel *)modalPanel inTextView:(UITextView *)textView
{
    // paste text
    [textView paste:nil];
    
    /*
    // copy a carriage return - later set this up as an option in settings
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"\n";
    
    [textView paste:nil];
     */
}

@end
