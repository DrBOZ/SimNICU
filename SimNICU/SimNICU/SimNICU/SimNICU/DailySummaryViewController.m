//
//  DailySummaryViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PhototherapyAddBilirubinResultViewController.h"
#import "AddBloodResultTableViewController.h"
#import "PortraitOnlyNavigationController.h"
#import "VascularLinesTableViewController.h"
#import "FluidBalanceTableViewController.h"
#import "DailySummaryPDFViewController.h"
#import "PatientDetailsViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "DailySummaryViewController.h"
#import "BloodResultTableViewCell.h"
#import "SuggestionTableViewCell.h"
#import "FluidBalanceHeadingCell.h"
#import "JaundiceViewController.h"
#import "CBTableViewSectionData.h"
#import "FluidBalanceFluidCell.h"
#import "UDInputAccessoryView.h"
#import "CBBarCustomTextItem.h"
#import "UDBarTrackballItem.h"
#import "CBTableViewRowData.h"
#import "DictationCommands.h"
// #import "ShinobiChartCell.h"
#import "BilirubinResult.h"
#import "HandoverSection.h"
#import "CBStringMethods.h"
#import "JLActionSheet.h"
#import "CBTimeMethods.h"
#import "CBModalPanel.h"
#import "HandoverRow.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

// #import "CBBarCustomTableViewTextItem.h"

@interface DailySummaryViewController () <UITableViewDataSource, UITableViewDelegate, SChartDatasource, SChartDelegate, UITextViewDelegate, UIScrollViewDelegate, PatientDetailsViewControllerDelegate, PhototherapyAddBilirubinResultViewControllerDelegate, JaundiceViewControllerDelegate, VascularLinesTableViewControllerDelegate, AddBloodResultTableViewControllerDelegate, FluidBalanceTableViewControllerDelegate, DailySummaryPDFViewControllerDelegate, UAModalPanelDelegate, CBModalPanelDelegate, JLActionSheetDelegate, CBBarButtonTextItemDelegate>
{
    int selectedBay;
    int selectedPatientInBay;
    
    BOOL landscapeOrientationDefaultsSet;
    BOOL portraitOrientationDefaultsSet;
    
    BOOL newPatientWeight;
    BOOL newPatientDetails;
    BOOL newPatientBackground;
    BOOL newActiveProblems;
    BOOL newResolvedProblems;
    BOOL newRecentSignificantEvents;
    BOOL newVentilationAndSedation;
    BOOL newCXR;
    BOOL newCardiovascular;
    BOOL newHaematology;
    BOOL newLines;
    BOOL newEchocardiogram;
    BOOL newFeedsAndFluids;
    BOOL newFluidBalance;
    BOOL newBiochemistry;
    BOOL newBiliChart;
    BOOL newJaundice;
    BOOL newSepsis;
    BOOL newDrugs;
    BOOL newImmunisations;
    BOOL newROP;
    BOOL newCranialUSS;
    BOOL newParentsAndSocial;
    BOOL newExamination;
    BOOL newSummary;
    BOOL newPlan;
    
    BOOL firstButtonPressSinceScroll; // used to line up sections when pressing fast forward
    
    NSMutableArray *biochemistryResultsBackroundColors;
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
@property (nonatomic, strong) NSString *neurotoxicityRiskFactors;
@property (nonatomic, strong) NSString *neurotoxicityRisk;
@property (nonatomic, strong) NSString *clinicalStatus;
@property (nonatomic, strong) NSNumber *gestation;

@property (nonatomic, strong) UITextView *weightTextView;
@property (nonatomic, strong) UITextView *backgroundTextView;
@property (nonatomic, strong) UITextView *activeProblemsTextView;
@property (nonatomic, strong) UITextView *resolvedProblemsTextView;
@property (nonatomic, strong) UITextView *recentSignificantEventsTextView;
@property (nonatomic, strong) UITextView *ventilationAndSedationTextView;
@property (nonatomic, strong) UITextView *cxrTextView;
@property (nonatomic, strong) UITextView *cardiovascularTextView;
@property (nonatomic, strong) UITextView *haematologyTextView;
@property (nonatomic, strong) UITextView *linesTextView;
@property (nonatomic, strong) UITextView *echocardiogramTextView;
@property (nonatomic, strong) UITextView *feedsAndFluidsTextView;
@property (nonatomic, strong) UITextView *fluidBalanceTextView;
@property (nonatomic, strong) UITextView *biochemistryTextView;
@property (nonatomic, strong) UITextView *jaundiceTextView;
@property (nonatomic, strong) UITextView *sepsisTextView;
@property (nonatomic, strong) UITextView *drugsTextView;
@property (nonatomic, strong) UITextView *immunisationsTextView;
@property (nonatomic, strong) UITextView *ropTextView;
@property (nonatomic, strong) UITextView *cranialUSSTextView;
@property (nonatomic, strong) UITextView *parentsAndSocialTextView;
@property (nonatomic, strong) UITextView *examinationTextView;
@property (nonatomic, strong) UITextView *summaryTextView;
@property (nonatomic, strong) UITextView *planTextView;

@property (nonatomic, strong) UITableViewCell *shinobiCell;
@property (nonatomic, strong) UIImage *shinobiChartImage;

@property (nonatomic, strong) UISegmentedControl *clinicalStatusSegmentedControl;
@property (nonatomic, strong) UISegmentedControl *neurotoxicityRiskFactorsSegmentedControl;

@property (nonatomic, strong) CBModalPanel *modalPanel;

@property (nonatomic, strong) UIButton *fingerprintButton;

@property (nonatomic, strong) NSMutableArray *formattedFluidBalanceResults;

- (int)getUserDefinedSectionForTextView:(UITextView *)textView;

@end

@implementation DailySummaryViewController

// things I need to still do
//
// 1) add analytics
// 2) create a weight shinobi chart
// 3) dateAndTimeForThisChart thing for ShinobiChart

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        firstButtonPressSinceScroll = NO;
        
        // default neurotoxicity risk
        self.neurotoxicityRisk = @"Lower";
        self.neurotoxicityRiskFactors = @"None";
        self.clinicalStatus = @"Well";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#warning temp code
    // self.selectedPatient.allFluidBalanceData = nil;
    
    // setup phototherapy chart settings
    {
        // set neurotoxicity risk factors for selected patient
        if (self.selectedPatient.neurotoxicityRiskFactors)
        {
            self.neurotoxicityRiskFactors = self.selectedPatient.neurotoxicityRiskFactors;
        }
        
        // set clinical status for selected patient
        if (self.selectedPatient.clinicalStatus)
        {
            self.clinicalStatus = self.selectedPatient.clinicalStatus;
        }
        
        // set bilirubin neurotoxicity risk
        if (self.neurotoxicityRiskFactors && self.clinicalStatus)
        {
            [self calculateNeurotoxicityRisk];
        }
    }
    
    biochemistryResultsBackroundColors = [[NSMutableArray alloc] initWithCapacity:10];
    
//    NSLog(@"2");
//    
//    NSLog(@"Neurotoxicity risk factors = %@", self.neurotoxicityRiskFactors);
//    NSLog(@"Clinical Status = %@", self.clinicalStatus);
//    NSLog(@"Neurotoxicity risk = %@", self.neurotoxicityRisk);
    
    portraitOrientationDefaultsSet = YES;
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // setup buttons
    {
        // setup back button
        self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self
                                                                                   action:@selector(done)];
        
        // setup edit button
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        // setup toolbar
        self.navigationController.toolbarHidden = NO;
        
        // flexible space
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:self
                                                                                       action:nil];
        
        // previous patient button
        UIBarButtonItem *previousPatient = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                         target:self
                                                                                         action:@selector(previousPatientButtonPressed)];
        previousPatient.tag = 1;
        
        // create PDF button
        UIBarButtonItem *createPDFButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                         target:self
                                                                                         action:@selector(prepareDailySummaryPDFForPatient)];
        createPDFButton.tag = 2;
        
        // next patient from the top button
        UIBarButtonItem *nextPatientFromTheTop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                               target:self
                                                                                               action:@selector(nextPatientButtonPressed:)];
        nextPatientFromTheTop.tag = 3;
        
        // next patient button
        UIBarButtonItem *nextPatient = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                     target:self
                                                                                     action:@selector(nextPatientButtonPressed:)];
        nextPatient.tag = 4;
        
        // setup toolbar
        self.toolbarItems = @[previousPatient, flexibleSpace, createPDFButton, flexibleSpace, nextPatientFromTheTop, flexibleSpace, nextPatient];
    }
    
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
    
    
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    /*
     self.shinobiCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Phototherapy"];
     self.shinobiCell.selectionStyle = UITableViewCellSelectionStyleNone;
     [self.shinobiCell addSubview:self.chart];
     */
    
    // tableView 1
    self.myTableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView1.frame = CGRectMake(0.0f, 0.0f, 320.0f, 92.0f + 64.0f);
        self.myTableView1.separatorColor = [UIColor clearColor];
    }
    else
    {
        self.myTableView1.frame = CGRectMake(0.0f, 0.0f, 320.0f, 92.0f);
        self.myTableView1.separatorColor = [UIColor grayColor];
    }
    self.myTableView1.userInteractionEnabled = YES;
    self.myTableView1.sectionFooterHeight = 10.0f;
    self.myTableView1.sectionHeaderHeight = 10.0f;
    self.myTableView1.scrollEnabled = NO;
    self.myTableView1.rowHeight = 44.0f;
    self.myTableView1.dataSource = self;
    self.myTableView1.delegate = self;
    self.myTableView1.bounces = NO;
    
    [self.view addSubview:self.myTableView1];
    
    // tableView 2
    self.myTableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView2.frame = CGRectMake(0.0f, 92.0f + 64.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 92.0f - 44.0f));
    }
    else
    {
        self.myTableView2.frame = CGRectMake(0.0f, 92.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f - 92.0f - 44.0f));
    }
    self.myTableView2.separatorColor = [UIColor clearColor];
    self.myTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView2.sectionFooterHeight = 10.0f;
    self.myTableView2.sectionHeaderHeight = 10.0f;
    self.myTableView2.rowHeight = 44.0f;
    self.myTableView2.dataSource = self;
    self.myTableView2.delegate = self;
    
    [self.view addSubview:self.myTableView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if  ([tableView isEqual:self.myTableView1]) return 1;
    
    else return [preferences.handoverSections count];
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
        // NOTE:    handoverSection list is ordered by user preferences
        //          number of rows are stored in the patient object
        
        // first get preferences singleton
        Preferences *preferences = [Preferences sharedPreferences];
        
        // get the relevant handoverSection as per user preferences
        HandoverSection *handoverSection = preferences.handoverSections[section];
        
        // cycle through all of the handoverSections saved for the selected patient
        for (HandoverSection *handoverSectionForPatient in self.selectedPatient.handoverSections)
        {
            // and check if it matches the handoverSection ordered by user preferences
            if ([handoverSectionForPatient.sectionName isEqualToString:handoverSection.sectionName])
            {
                // set the number of rows...
                
                // if Phototherapy section and user is using US preferences then add another two rows
                if ([handoverSection.sectionName isEqualToString:@"Jaundice"] && [preferences.guidelineCountry isEqualToString:@"US"])
                {
                    // these extra rows are for the Clinical Status & Neurotoxicity Risk Factors segmented controls
                    rows = [handoverSectionForPatient.rows count] + 2;
                    
                    // could add a toggle here to include another one row (large row) for the blood group / DCT data
                }
                else if ([handoverSection.sectionName isEqualToString:@"Haematology"])
                {
                    // find out how many results to display plus free text
                    rows = ([[self getHaematologyResultsToDisplay] count] + 1);
                }
                else if ([handoverSection.sectionName isEqualToString:@"Fluid Balance"])
                {
                    // NSLog(@"Fluid balance rows = %i", [self.selectedPatient getNumberOfFluidBalanceRows] + 1);
                    rows = [self.selectedPatient getNumberOfFluidBalanceRows] + 1;
                }
                else if ([handoverSection.sectionName isEqualToString:@"Biochemistry"])
                {
                    // find out how many results to display plus free text
                    rows = ([[self getBiochemistryResultsToDisplay] count] + 1);
                }
                else if ([handoverSection.sectionName isEqualToString:@"Sepsis"])
                {
                    // find out how many results to display plus free text
                    rows = ([[self getCRPResultsToDisplay] count] + 1);
                }
                else if ([handoverSection.sectionName isEqualToString:@"Suggestions"])
                {
                    AI *brain = [AI sharedAI];
                    
                    rows = [brain getSuggestionsForPatient:self.selectedPatient].count + 1;
                }
                else
                {
                    // this should always be 1...
                    // I could test for this using a breakpoint and/or NSLog
                    rows = [handoverSectionForPatient.rows count];
                }
            }
        }
        
        if (rows == 0)
        {
            NSLog(@"error");
        }
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForHeader = nil;
    
    // order as per the user's preferences
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[section];
    
    if ([tableView isEqual:self.myTableView1])
    {
        titleForHeader = NSLocalizedString(@"Patient", nil);
    }
    else
    {
        // localisation of section name occurs here
#if AI_SUGGESTIONS_PREVIEW_MODE
        
        titleForHeader = NSLocalizedString(handoverSection.sectionName, nil);
        
#else
        
        if ([handoverSection.sectionName isEqualToString:@"Suggestions"])
        {
            titleForHeader = nil;
        }
        else
        {
            titleForHeader = NSLocalizedString(handoverSection.sectionName, nil);
        }
        
#endif
        
    }
    
    return titleForHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewForHeader = nil;
    
    if ([tableView isEqual:self.myTableView2])
    {
        Preferences *preferences = [Preferences sharedPreferences];
        
        HandoverSection *handoverSection = preferences.handoverSections[section];
        
        if ([handoverSection.sectionName isEqualToString:@"Fluid Balance"] && self.selectedPatient.allFluidBalanceData.count > 1)
        {
            viewForHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 22.0f)];
            viewForHeader.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
            
            UILabel *sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 100.0f, 22.0f)];
            sectionHeaderLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            sectionHeaderLabel.text = NSLocalizedString(@"Fluid Balance", nil);
            
            UILabel *ml = [[UILabel alloc] initWithFrame:CGRectMake(205.0f, 2.0f, 40.0f, 22.0f)];
            ml.font = [UIFont systemFontOfSize:13.0f];
            ml.text = NSLocalizedString(@"ml", nil);
            
            UILabel *mlPerKg = [[UILabel alloc] initWithFrame:CGRectMake(260.0f, 2.0f, 40.0f, 22.0f)];
            mlPerKg.font = [UIFont systemFontOfSize:13.0f];
            mlPerKg.text = NSLocalizedString(@"ml/kg", nil);
            
            [viewForHeader addSubview:sectionHeaderLabel];
            [viewForHeader addSubview:ml];
            [viewForHeader addSubview:mlPerKg];
        }
    }
    
    return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (CGFloat)heightForTextView:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    //  get textView height
    
    /*
     *  This method is called when the user changes text to see if 
     *  the actual textView needs to adjust height.
     
     *  Therefore I can see why it needs a proxy TextView
     */
    
    // as based on textView.tag, get from selected patient info
    // HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];     this was how I was doing it...
    
    UITextView *textViewToMeasure = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
    
    if ([textView isEqual:self.weightTextView])                                     // if ([section.sectionName isEqualToString:@"Weight"])
    {
        textViewToMeasure.text = self.selectedPatient.weight;
    }
    else if ([textView isEqual:self.backgroundTextView])                            // else if ([section.sectionName isEqualToString:@"Background"])
    {
        textViewToMeasure.text = self.selectedPatient.background;
    }
    else if ([textView isEqual:self.activeProblemsTextView])                        // else if ([section.sectionName isEqualToString:@"Active Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.activeProblems;
    }
    else if ([textView isEqual:self.resolvedProblemsTextView])                      // else if ([section.sectionName isEqualToString:@"Resolved Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.resolvedProblems;
    }
    else if ([textView isEqual:self.recentSignificantEventsTextView])               // else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
    {
        textViewToMeasure.text = self.selectedPatient.recentSignificantEvents;
    }
    else if ([textView isEqual:self.ventilationAndSedationTextView])                // else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
    {
        textViewToMeasure.text = self.selectedPatient.ventilationAndSedation;
    }
    else if ([textView isEqual:self.cxrTextView])                                   // else if ([section.sectionName isEqualToString:@"CXR"])
    {
        textViewToMeasure.text = self.selectedPatient.cxr;
    }
    else if ([textView isEqual:self.cardiovascularTextView])                        // else if ([section.sectionName isEqualToString:@"Cardiovascular"])
    {
        textViewToMeasure.text = self.selectedPatient.cardiovascular;
    }
    else if ([textView isEqual:self.haematologyTextView])                           // else if ([section.sectionName isEqualToString:@"Haematology"])
    {
        textViewToMeasure.text = self.selectedPatient.haematology;
    }
    else if ([textView isEqual:self.linesTextView])                                 // else if ([section.sectionName isEqualToString:@"Lines"])
    {
        textViewToMeasure.text = self.selectedPatient.lines;
    }
    else if ([textView isEqual:self.echocardiogramTextView])                        // else if ([section.sectionName isEqualToString:@"Echocardiogram"])
    {
        textViewToMeasure.text = self.selectedPatient.echocardiogram;
    }
    else if ([textView isEqual:self.feedsAndFluidsTextView])                        // else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
    {
        textViewToMeasure.text = self.selectedPatient.feedsAndFluids;
    }
    else if ([textView isEqual:self.fluidBalanceTextView])                          // else if ([section.sectionName isEqualToString:@"Fluid Balance"])
    {
        textViewToMeasure.text = self.selectedPatient.fluidBalance;
    }
    else if ([textView isEqual:self.biochemistryTextView])                          // else if ([section.sectionName isEqualToString:@"Biochemistry"])
    {
        textViewToMeasure.text = self.selectedPatient.biochemistry;
    }
    else if ([textView isEqual:self.jaundiceTextView])                              // else if ([section.sectionName isEqualToString:@"Jaundice"])
    {
        textViewToMeasure.text = self.selectedPatient.jaundice;
    }
    else if ([textView isEqual:self.sepsisTextView])                                // else if ([section.sectionName isEqualToString:@"Sepsis"])
    {
        textViewToMeasure.text = self.selectedPatient.sepsis;
    }
    else if ([textView isEqual:self.drugsTextView])                                 // else if ([section.sectionName isEqualToString:@"Drugs"])
    {
        textViewToMeasure.text = self.selectedPatient.drugs;
    }
    else if ([textView isEqual:self.immunisationsTextView])                         // else if ([section.sectionName isEqualToString:@"Immunisations"])
    {
        textViewToMeasure.text = self.selectedPatient.immunisations;
    }
    else if ([textView isEqual:self.ropTextView])                                   // else if ([section.sectionName isEqualToString:@"ROP"])
    {
        textViewToMeasure.text = self.selectedPatient.rop;
    }
    else if ([textView isEqual:self.cranialUSSTextView])                            // else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
    {
        textViewToMeasure.text = self.selectedPatient.cranialUSS;
    }
    else if ([textView isEqual:self.parentsAndSocialTextView])                      // else if ([section.sectionName isEqualToString:@"Parents / Social"])
    {
        textViewToMeasure.text = self.selectedPatient.parentsAndSocial;
    }
    else if ([textView isEqual:self.examinationTextView])                           // else if ([section.sectionName isEqualToString:@"Examination"])
    {
        textViewToMeasure.text = self.selectedPatient.examination;
    }
    else if ([textView isEqual:self.summaryTextView])                               // else if ([section.sectionName isEqualToString:@"Summary"])
    {
        textViewToMeasure.text = self.selectedPatient.summary;
    }
    else if ([textView isEqual:self.planTextView])                                  // else if ([section.sectionName isEqualToString:@"Plan"])
    {
        textViewToMeasure.text = self.selectedPatient.plan;
    }
    
    // Calculate textViewToMeasure height
    if ([preferences.dynamicText intValue] && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // ensuring iOS 7
        textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    else
    {
        textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
    }
    
    [textViewToMeasure sizeToFit];
    
    CGFloat height = textViewToMeasure.frame.size.height;
    
    // what exactly am I doing here?
    // not sure, so comment out...
    
//    textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//    
//    if ([preferences.dynamicText intValue] && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
//    {
//        textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//    }
//    else
//    {
//        textView.font = [UIFont systemFontOfSize:14.0f];
//    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Note: this is height for row, which includes the UITextView cells and others.
    CGFloat height = 55.0f;
    
    if ([tableView isEqual:self.myTableView1]) height = 90.0f;
    
    else
    {
        // have to use this textView as actual textViews have not been created yet...
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
        
        // in order of preferences
        Preferences *preferences = [Preferences sharedPreferences];
        
        HandoverSection *section = preferences.handoverSections[indexPath.section];
        
        if ([section.sectionName isEqualToString:@"Weight"])
        {
            textView.text = self.selectedPatient.weight;
        }
        else if ([section.sectionName isEqualToString:@"Background"])
        {
            textView.text = self.selectedPatient.background;
        }
        else if ([section.sectionName isEqualToString:@"Active Problems"])
        {
            textView.text = self.selectedPatient.activeProblems;
        }
        else if ([section.sectionName isEqualToString:@"Resolved Problems"])
        {
            textView.text = self.selectedPatient.resolvedProblems;
        }
        else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
        {
            textView.text = self.selectedPatient.recentSignificantEvents;
        }
        else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
        {
            textView.text = self.selectedPatient.ventilationAndSedation;
        }
        else if ([section.sectionName isEqualToString:@"CXR"])
        {
            textView.text = self.selectedPatient.cxr;
        }
        else if ([section.sectionName isEqualToString:@"Cardiovascular"])
        {
            textView.text = self.selectedPatient.cardiovascular;
        }
        else if ([section.sectionName isEqualToString:@"Haematology"])
        {
            int numberOfHaematologyResultsToDisplay = [[self getHaematologyResultsToDisplay] count];
            
            if (numberOfHaematologyResultsToDisplay)
            {
                if (indexPath.row < numberOfHaematologyResultsToDisplay)
                {
                    return 28.0f;
                }
                else
                {
                    textView.text = self.selectedPatient.haematology;
                }
            }
            else
            {
                textView.text = self.selectedPatient.haematology;
            }
        }
        else if ([section.sectionName isEqualToString:@"Lines"])
        {
            textView.text = self.selectedPatient.lines;
        }
        else if ([section.sectionName isEqualToString:@"Echocardiogram"])
        {
            textView.text = self.selectedPatient.echocardiogram;
        }
        else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
        {
            textView.text = self.selectedPatient.feedsAndFluids;
        }
        else if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            if (indexPath.row < [self.selectedPatient getNumberOfFluidBalanceRows])
            {
                return 20.0f;
            }
            else
            {
                textView.text = self.selectedPatient.fluidBalance;
            }
        }
        else if ([section.sectionName isEqualToString:@"Biochemistry"])
        {
            int numberOfBiochemistryResultsToDisplay = [[self getBiochemistryResultsToDisplay] count];
            
            if (numberOfBiochemistryResultsToDisplay)
            {
                if (indexPath.row < numberOfBiochemistryResultsToDisplay)
                {
                    return 28.0f;
                }
                else
                {
                    textView.text = self.selectedPatient.biochemistry;
                }
            }
            else
            {
                textView.text = self.selectedPatient.biochemistry;
            }
        }
        else if ([section.sectionName isEqualToString:@"Jaundice"])
        {
            Preferences *preferences = [Preferences sharedPreferences];
            
            if (indexPath.row == 0)
            {
                /*
                 HandoverRow *row = section.rows[indexPath.row];
                 
                 height = [row.rowHeight floatValue];
                 
                 return height;
                 */
                
                // delegate
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                // Different graph sizes for iPhone 4 and iPhone 5
                if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
                {
                    return 320.0f;
                }
                else
                {
                    return 260.0f;
                }
                
            }
            else
            {
                if ([preferences.guidelineCountry isEqualToString:@"US"])
                {
                    if (indexPath.row == 3)
                    {
                        textView.text = self.selectedPatient.jaundice;
                    }
                }
                else
                {
                    if (indexPath.row == 1)
                    {
                        textView.text = self.selectedPatient.jaundice;
                    }
                }
            }
        }
        else if ([section.sectionName isEqualToString:@"Sepsis"])
        {
            int numberOfCRPResultsToDisplay = [[self getCRPResultsToDisplay] count];
            
            if (numberOfCRPResultsToDisplay)
            {
                if (indexPath.row < numberOfCRPResultsToDisplay)
                {
                    return 28.0f;
                }
                else
                {
                    textView.text = self.selectedPatient.sepsis;
                }
            }
            else
            {
                textView.text = self.selectedPatient.sepsis;
            }
        }
        else if ([section.sectionName isEqualToString:@"Drugs"])
        {
            textView.text = self.selectedPatient.drugs;
        }
        else if ([section.sectionName isEqualToString:@"Immunisations"])
        {
            textView.text = self.selectedPatient.immunisations;
        }
        else if ([section.sectionName isEqualToString:@"ROP"])
        {
            textView.text = self.selectedPatient.rop;
        }
        else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
        {
            textView.text = self.selectedPatient.cranialUSS;
        }
        else if ([section.sectionName isEqualToString:@"Parents / Social"])
        {
            textView.text = self.selectedPatient.parentsAndSocial;
        }
        else if ([section.sectionName isEqualToString:@"Examination"])
        {
            textView.text = self.selectedPatient.examination;
        }
        else if ([section.sectionName isEqualToString:@"Summary"])
        {
            textView.text = self.selectedPatient.summary;
        }
        else if ([section.sectionName isEqualToString:@"Plan"])
        {
            textView.text = self.selectedPatient.plan;
        }
        
        // If section is not the last one, then adjust textView height to text
        if (![section.sectionName isEqualToString:@"Suggestions"])
        {
            Preferences *preferences = [Preferences sharedPreferences];
            
            if ([preferences.dynamicText intValue] && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                // ensuring iOS 7
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
            AI *brain = [AI sharedAI];
            
            int numberOfSuggestionsToDisplay = [brain getSuggestionsForPatient:self.selectedPatient ].count;
            
            if (indexPath.row < numberOfSuggestionsToDisplay)
            {
                return 28.0f;
            }
            else
            {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                // set a minimum height for the 'Suggestions' cell
                if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
                {
                    return 286.0f - 22.0f;
                }
                else
                {
                    return 146.0f - 22.0f;
                }
            }
        }
        
        
        
//        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
//        {
//            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
//            
//            // in order of preferences
//            Preferences *preferences = [Preferences sharedPreferences];
//            
//            HandoverSection *section = preferences.handoverSections[indexPath.section];
//            
//            if ([section.sectionName isEqualToString:@"Weight"])
//            {
//                // textView.text = [NSString stringWithFormat:@"%@", self.selectedPatient.weight];
//                textView.text = self.selectedPatient.weight;
//            }
//            else if ([section.sectionName isEqualToString:@"Background"])
//            {
//                // textView.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
//                textView.text = self.selectedPatient.background;
//            }
//            else if ([section.sectionName isEqualToString:@"Active Problems"])
//            {
//                textView.text = self.selectedPatient.activeProblems;
//            }
//            else if ([section.sectionName isEqualToString:@"Resolved Problems"])
//            {
//                textView.text = self.selectedPatient.resolvedProblems;
//            }
//            else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
//            {
//                textView.text = self.selectedPatient.recentSignificantEvents;
//            }
//            else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
//            {
//                textView.text = self.selectedPatient.ventilationAndSedation;
//            }
//            else if ([section.sectionName isEqualToString:@"CXR"])
//            {
//                textView.text = self.selectedPatient.cxr;
//            }
//            else if ([section.sectionName isEqualToString:@"Cardiovascular"])
//            {
//                textView.text = self.selectedPatient.cardiovascular;
//            }
//            else if ([section.sectionName isEqualToString:@"Haematology"])
//            {
//                int numberOfHaematologyResultsToDisplay = [[self getHaematologyResultsToDisplay] count];
//                
//                if (numberOfHaematologyResultsToDisplay)
//                {
//                    if (indexPath.row < numberOfHaematologyResultsToDisplay)
//                    {
//                        return 28.0f;
//                    }
//                    else
//                    {
//                        textView.text = self.selectedPatient.haematology;
//                    }
//                }
//                else
//                {
//                    textView.text = self.selectedPatient.haematology;
//                }
//            }
//            else if ([section.sectionName isEqualToString:@"Lines"])
//            {
//                textView.text = self.selectedPatient.lines;
//            }
//            else if ([section.sectionName isEqualToString:@"Echocardiogram"])
//            {
//                textView.text = self.selectedPatient.echocardiogram;
//            }
//            else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
//            {
//                textView.text = self.selectedPatient.feedsAndFluids;
//            }
//            else if ([section.sectionName isEqualToString:@"Fluid Balance"])
//            {
//                if (indexPath.row < [self.selectedPatient getNumberOfFluidBalanceRows])
//                {
//                    return 20.0f;
//                }
//                else
//                {
//                    textView.text = self.selectedPatient.fluidBalance;
//                }
//            }
//            else if ([section.sectionName isEqualToString:@"Biochemistry"])
//            {
//                int numberOfBiochemistryResultsToDisplay = [[self getBiochemistryResultsToDisplay] count];
//                
//                if (numberOfBiochemistryResultsToDisplay)
//                {
//                    if (indexPath.row < numberOfBiochemistryResultsToDisplay)
//                    {
//                        return 28.0f;
//                    }
//                    else
//                    {
//                        textView.text = self.selectedPatient.biochemistry;
//                    }
//                }
//                else
//                {
//                    textView.text = self.selectedPatient.biochemistry;
//                }
//            }
//            else if ([section.sectionName isEqualToString:@"Jaundice"])
//            {
//                Preferences *preferences = [Preferences sharedPreferences];
//                
//                if (indexPath.row == 0)
//                {
//                    /*
//                     HandoverRow *row = section.rows[indexPath.row];
//                     
//                     height = [row.rowHeight floatValue];
//                     
//                     return height;
//                     */
//                    
//                    // delegate
//                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    
//                    // Different graph sizes for iPhone 4 and iPhone 5
//                    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
//                    {
//                        return 320.0f;
//                    }
//                    else
//                    {
//                        return 260.0f;
//                    }
//                    
//                }
//                else
//                {
//                    if ([preferences.guidelineCountry isEqualToString:@"US"])
//                    {
//                        if (indexPath.row == 3)
//                        {
//                            textView.text = self.selectedPatient.jaundice;
//                        }
//                    }
//                    else
//                    {
//                        if (indexPath.row == 1)
//                        {
//                            textView.text = self.selectedPatient.jaundice;
//                        }
//                    }
//                }
//            }
//            else if ([section.sectionName isEqualToString:@"Sepsis"])
//            {
//                int numberOfCRPResultsToDisplay = [[self getCRPResultsToDisplay] count];
//                
//                if (numberOfCRPResultsToDisplay)
//                {
//                    if (indexPath.row < numberOfCRPResultsToDisplay)
//                    {
//                        return 28.0f;
//                    }
//                    else
//                    {
//                        textView.text = self.selectedPatient.sepsis;
//                    }
//                }
//                else
//                {
//                    textView.text = self.selectedPatient.sepsis;
//                }
//            }
//            else if ([section.sectionName isEqualToString:@"Drugs"])
//            {
//                textView.text = self.selectedPatient.drugs;
//            }
//            else if ([section.sectionName isEqualToString:@"Immunisations"])
//            {
//                textView.text = self.selectedPatient.immunisations;
//            }
//            else if ([section.sectionName isEqualToString:@"ROP"])
//            {
//                textView.text = self.selectedPatient.rop;
//            }
//            else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
//            {
//                textView.text = self.selectedPatient.cranialUSS;
//            }
//            else if ([section.sectionName isEqualToString:@"Parents / Social"])
//            {
//                textView.text = self.selectedPatient.parentsAndSocial;
//            }
//            else if ([section.sectionName isEqualToString:@"Examination"])
//            {
//                textView.text = self.selectedPatient.examination;
//            }
//            else if ([section.sectionName isEqualToString:@"Summary"])
//            {
//                textView.text = self.selectedPatient.summary;
//            }
//            else if ([section.sectionName isEqualToString:@"Plan"])
//            {
//                textView.text = self.selectedPatient.plan;
//            }
//            
//            // If section is not the last one, then adjust textView height to text
//            if (![section.sectionName isEqualToString:@"Suggestions"])
//            {
//                Preferences *preferences = [Preferences sharedPreferences];
//                
//                if ([preferences.dynamicText intValue])
//                {
//                    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//                }
//                else
//                {
//                    textView.font = [UIFont systemFontOfSize:14.0f];
//                }
//                
//                [textView sizeToFit];
//                
//                height = textView.frame.size.height;
//            }
//            else
//            {
//                AI *brain = [AI sharedAI];
//                
//                int numberOfSuggestionsToDisplay = [brain getSuggestionsForPatient:self.selectedPatient ].count;
//            
//                if (indexPath.row < numberOfSuggestionsToDisplay)
//                {
//                    return 28.0f;
//                }
//                else
//                {
//                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    
//                    // set a minimum height for the 'Suggestions' cell
//                    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
//                    {
//                        return 286.0f - 22.0f;
//                    }
//                    else
//                    {
//                        return 146.0f - 22.0f;
//                    }
//                }
//            }
//        }
//        else
//        {
//            abort();
//            HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
//            
//            HandoverRow *row = section.rows[indexPath.row];
//            
//            height = [row.rowHeight floatValue];
//        }
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.myTableView2])
    {
        Preferences *preferences = [Preferences sharedPreferences];
        
        HandoverSection *section = preferences.handoverSections[indexPath.section];
        
        if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            // only change background color of disclosure indicator if there are results shown
            if ([self.selectedPatient getNumberOfFluidBalanceRows])
            {
                if (indexPath.row == 0)
                {
                    UIColor *systemGray = [UIColor colorWithRed:247.0/255.0
                                                          green:247.0/255.0
                                                           blue:247.0/255.0
                                                          alpha:1.0];
                    
                    cell.contentView.backgroundColor = systemGray;
                    cell.backgroundColor = systemGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.accessoryView.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    NSString *CellIdentifier;
    
    UITableViewCell *cell;
    
    if ([tableView isEqual:self.myTableView1]) // Patient Name, age, etc
    {
        CellIdentifier = @"Patient";
        
        if (newPatientDetails)
        {
            // memory leaks
            // might have to do this:
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell = nil;
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
        HandoverSection *section = preferences.handoverSections[indexPath.section];
        
#pragma mark Weight
        if ([section.sectionName isEqualToString:@"Weight"])
        {
            CellIdentifier = @"Weight";
            
            if (newPatientWeight)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newPatientWeight = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.weightTextView.text = self.selectedPatient.weight;
        }
#pragma mark Background
        else if ([section.sectionName isEqualToString:@"Background"])
        {
            CellIdentifier = @"Background";
            
            if (newPatientBackground)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
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
        }
#pragma mark Active Problems
        else if ([section.sectionName isEqualToString:@"Active Problems"])
        {
            CellIdentifier = @"ActiveProblems";
            
            if (newActiveProblems)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newActiveProblems = NO;
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
        }
#pragma mark Resolved Problems
        else if ([section.sectionName isEqualToString:@"Resolved Problems"])
        {
            CellIdentifier = @"ResolvedProblems";
            
            if (newResolvedProblems)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newResolvedProblems = NO;
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
        }
#pragma mark Recent Significant Events
        else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
        {
            CellIdentifier = @"RecentSignificantEvents";
            
            if (newRecentSignificantEvents)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newRecentSignificantEvents = NO;
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
        }
#pragma mark Ventilation & Sedation
        else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
        {
            CellIdentifier = @"VentilationAndSedation";
            
            if (newVentilationAndSedation)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newVentilationAndSedation = NO;
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
        }
#pragma mark CXR
        else if ([section.sectionName isEqualToString:@"CXR"])
        {
            CellIdentifier = @"CXR";
            
            if (newCXR)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newCXR = NO;
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
        }
#pragma mark Cardiovascular
        else if ([section.sectionName isEqualToString:@"Cardiovascular"])
        {
            CellIdentifier = @"Cardiovascular";
            
            if (newCardiovascular)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newCardiovascular = NO;
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
        }
#pragma mark Haematology
        else if ([section.sectionName isEqualToString:@"Haematology"])
        {
            NSArray *haematologyResults = [self getHaematologyResultsToDisplay];
            
            int numberOfHaematologyResultsToDisplay = [haematologyResults count];
            
            if (indexPath.row < numberOfHaematologyResultsToDisplay)
            {
                CellIdentifier = haematologyResults[indexPath.row][0];
                
                BloodResultTableViewCell *bloodResultCell;
                
                if ([CellIdentifier isEqualToString:@"FBC Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display FBC results
                    bloodResultCell.HbResult.text = haematologyResults[indexPath.row][1];
                    bloodResultCell.WCCResult.text = haematologyResults[indexPath.row][2];
                    bloodResultCell.PlatsResult.text = haematologyResults[indexPath.row][3];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:haematologyResults[indexPath.row][4] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Clotting Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Clotting results
                    bloodResultCell.PTResult.text = haematologyResults[indexPath.row][1];
                    bloodResultCell.APTTResult.text = haematologyResults[indexPath.row][2];
                    bloodResultCell.TTResult.text = haematologyResults[indexPath.row][3];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:haematologyResults[indexPath.row][4] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Fibrinogen Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Clotting results
                    bloodResultCell.FibrinogenResult.text = haematologyResults[indexPath.row][1];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:haematologyResults[indexPath.row][4] andLocale:[NSLocale currentLocale]];
                }
                
                
                // first check number of data rows
                if (numberOfHaematologyResultsToDisplay % 2)
                {
                    if (indexPath.row % 2)
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                    else
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    }
                }
                else
                {
                    if (indexPath.row % 2)
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    }
                    else
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                }
                
                return bloodResultCell;
            }
            else
            {
                CellIdentifier = @"Haematology";
                
                if (newHaematology)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    newHaematology = NO;
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    }
                }
                
                self.haematologyTextView.text = self.selectedPatient.haematology;
            }
        }
#pragma mark Lines
        else if ([section.sectionName isEqualToString:@"Lines"])
        {
            CellIdentifier = @"Lines";
            
            if (newLines)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newLines = NO;
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
        }
#pragma mark Echocardiogram
        else if ([section.sectionName isEqualToString:@"Echocardiogram"])
        {
            CellIdentifier = @"Echocardiogram";
            
            if (newEchocardiogram)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newEchocardiogram = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.echocardiogramTextView.text = self.selectedPatient.echocardiogram;
        }
#pragma mark Feeds & Fluids
        else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
        {
            CellIdentifier = @"FeedsAndFluids";
            
            if (newFeedsAndFluids)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newFeedsAndFluids = NO;
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
        }
#pragma mark Fluid Balance
        else if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            if (indexPath.row < [self.selectedPatient getNumberOfFluidBalanceRows])
            {
                self.formattedFluidBalanceResults = [self.selectedPatient getFormattedFluidBalanceResults];
                
                NSDictionary *dictionary = self.formattedFluidBalanceResults[indexPath.row];
                
                CellIdentifier = dictionary[@"CellIdentifier"];
                
                if ([CellIdentifier isEqualToString:@"FluidBalanceHeading"])
                {
                    FluidBalanceHeadingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [[FluidBalanceHeadingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.contentView.backgroundColor = dictionary[@"CellColor"];
                    cell.heading.text = dictionary[@"HeadingText"];
                    cell.workingWeight.text = dictionary[@"WorkingWeight"];
                    
                    return cell;
                }
                else if ([CellIdentifier isEqualToString:@"FluidBalanceLine"])
                {
                    FluidBalanceFluidCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [[FluidBalanceFluidCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.contentView.backgroundColor = dictionary[@"CellColor"];
                    cell.fluidName.text = dictionary[@"FluidName"];
                    cell.mlPerDay.text = dictionary[@"mlPerDay"];
                    cell.mlPerKgPerDay.text = dictionary[@"mlPerKgPerDay"];
                    
                    if (dictionary[@"drawTotalLines"] == [NSNumber numberWithBool:YES])
                    {
                        cell.drawTotalLines = YES;
                    }
                    else if (dictionary[@"drawDoubleTotalLines"] == [NSNumber numberWithBool:YES])
                    {
                        cell.drawDoubleTotalLines = YES;
                    }
                    
                    return cell;
                }
                else
                {
                    NSLog(@"ERROR - no cell");
                    return nil;
                }
            }
            else
            {
                CellIdentifier = @"FluidBalance";
                
                if (newFluidBalance)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    newFluidBalance = NO;
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
            }
        }
#pragma mark Biochemistry
        else if ([section.sectionName isEqualToString:@"Biochemistry"])
        {
            NSArray *biochemistryResults = [self getBiochemistryResultsToDisplay];
            
            int numberOfBiochemistryResultsToDisplay = [biochemistryResults count];
            
            if (indexPath.row < numberOfBiochemistryResultsToDisplay)
            {
                CellIdentifier = biochemistryResults[indexPath.row][0];
                
                BloodResultTableViewCell *bloodResultCell;
                
                if ([CellIdentifier isEqualToString:@"U&Es Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display U&E results
                    bloodResultCell.NaResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.KResult.text = biochemistryResults[indexPath.row][2];
                    bloodResultCell.UreaResult.text = biochemistryResults[indexPath.row][3];
                    bloodResultCell.CreatinineResult.text = biochemistryResults[indexPath.row][4];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"LFT Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display LFT results
                    bloodResultCell.AlkPhosResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.ALTResult.text = biochemistryResults[indexPath.row][2];
                    bloodResultCell.SBRResult.text = biochemistryResults[indexPath.row][3];
                    bloodResultCell.GammaGTResult.text = biochemistryResults[indexPath.row][4];
                    bloodResultCell.ALBResult.text = biochemistryResults[indexPath.row][5];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Conjugated Bilirubin Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Conjugated bilirubin result
                    bloodResultCell.DirectBiliResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Bone Profile Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Bone Profile results
                    bloodResultCell.CaResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.CaAdjResult.text = biochemistryResults[indexPath.row][2];
                    bloodResultCell.PhosphateResult.text = biochemistryResults[indexPath.row][3];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"LFT Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display U&E results
                    bloodResultCell.AlkPhosResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.ALTResult.text = biochemistryResults[indexPath.row][2];
                    bloodResultCell.SBRResult.text = biochemistryResults[indexPath.row][3];
                    bloodResultCell.GammaGTResult.text = biochemistryResults[indexPath.row][4];
                    bloodResultCell.ALBResult.text = biochemistryResults[indexPath.row][5];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Magnesium Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Magnesium result
                    bloodResultCell.MgResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                else if ([CellIdentifier isEqualToString:@"Ammonia Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display Ammonia result
                    bloodResultCell.AmmoniaResult.text = biochemistryResults[indexPath.row][1];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:biochemistryResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                
#warning code required
                
                // instead of just alternating rows (which is confusing when there are a lot of results
                // could try alternating based on a specific day
                // or a specific sample
                // could allow user to select
                
                // try a specific sample first
                
                // indexPath.row defines the order
                // need an array to reference which would return a value of light / dark to set backgroundColor
                
                if ([biochemistryResultsBackroundColors[indexPath.row] isEqualToNumber:@0])
                {
                    bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                }
                    
                                                       
                                                       
                
                // first check number of data rows
//                if (numberOfBiochemistryResultsToDisplay % 2)
//                {
//                    if (indexPath.row % 2)
//                    {
//                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
//                    }
//                    else
//                    {
//                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
//                    }
//                }
//                else
//                {
//                    if (indexPath.row % 2)
//                    {
//                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
//                    }
//                    else
//                    {
//                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
//                    }
//                }
                
                return bloodResultCell;
            }
            else
            {
                CellIdentifier = @"Biochemistry";
                
                if (newBiochemistry)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    newBiochemistry = NO;
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    }
                }
                
                self.biochemistryTextView.text = self.selectedPatient.biochemistry;
            }
        }
#pragma mark Jaundice
        else if ([section.sectionName isEqualToString:@"Jaundice"])
        {
            if (indexPath.row == 0)
            {
                // phototherapy
                CellIdentifier = @"Phototherapy";
                
                if (newBiliChart)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
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
                Preferences *preferences = [Preferences sharedPreferences];
                
                if ([preferences.guidelineCountry isEqualToString:@"US"])
                {
                    CellIdentifier = @"ClinicalStatus";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!cell)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        self.clinicalStatusSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Well", nil) , NSLocalizedString(@"Unwell", nil)]];
                        self.clinicalStatusSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
                        self.clinicalStatusSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 110.0f, 24.0f);
                        self.clinicalStatusSegmentedControl.tintColor = [UIColor redColor];
                        
                        [self.clinicalStatusSegmentedControl addTarget:self
                                                                action:@selector(selectClinicalStatus)
                                                      forControlEvents:UIControlEventValueChanged];
                        
                        cell.accessoryView = self.clinicalStatusSegmentedControl;
                    }
                    
                    cell.textLabel.text = NSLocalizedString(@"Clinical Status", nil);
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
                    
                    // set clinical status segmented control
                    if (self.clinicalStatus)
                    {
                        if ([self.clinicalStatus isEqualToString:@"Well"])
                        {
                            self.clinicalStatusSegmentedControl.selectedSegmentIndex = 0;
                        }
                        else if ([self.clinicalStatus isEqualToString:@"Unwell"])
                        {
                            self.clinicalStatusSegmentedControl.selectedSegmentIndex = 1;
                        }
                    }
                }
                else
                {
                    // phototherapy
                    CellIdentifier = @"Jaundice";
                    
                    if (newJaundice)
                    {
                        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        cell = nil;
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
                }
            }
            else if (indexPath.row == 2)
            {
                CellIdentifier = @"NeurotoxicityRiskFactors";
                
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    self.neurotoxicityRiskFactorsSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"None", nil) , NSLocalizedString(@"Some", nil)]];
                    self.neurotoxicityRiskFactorsSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
                    self.neurotoxicityRiskFactorsSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 110.0f, 24.0f);
                    self.neurotoxicityRiskFactorsSegmentedControl.tintColor = [UIColor redColor];
                    
                    [self.neurotoxicityRiskFactorsSegmentedControl addTarget:self
                                                                      action:@selector(selectNeurotoxicityRiskFactors)
                                                            forControlEvents:UIControlEventValueChanged];
                    
                    cell.accessoryView = self.neurotoxicityRiskFactorsSegmentedControl;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.textLabel.text = NSLocalizedString(@"Neurotoxicity Risk Factors", nil);
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
                
                if (self.neurotoxicityRiskFactors)
                {
                    if ([self.neurotoxicityRiskFactors isEqualToString:@"None"])
                    {
                        self.neurotoxicityRiskFactorsSegmentedControl.selectedSegmentIndex = 0;
                    }
                    else if ([self.neurotoxicityRiskFactors isEqualToString:@"Present"])
                    {
                        self.neurotoxicityRiskFactorsSegmentedControl.selectedSegmentIndex = 1;
                    }
                }
            }
            else if (indexPath.row == 3)
            {
                // phototherapy
                CellIdentifier = @"Jaundice";
                
                if (newJaundice)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
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
            }
        }
#pragma mark Sepsis
        else if ([section.sectionName isEqualToString:@"Sepsis"])
        {
            NSArray *crpResults = [self getCRPResultsToDisplay];
            
            int numberOfCRPResultsToDisplay = [crpResults count];
            
            if (indexPath.row < numberOfCRPResultsToDisplay)
            {
                CellIdentifier = crpResults[indexPath.row][0];
                
                BloodResultTableViewCell *bloodResultCell;
                
                if ([CellIdentifier isEqualToString:@"CRP Result"])
                {
                    bloodResultCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (!bloodResultCell)
                    {
                        bloodResultCell = [[BloodResultTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                    }
                    
                    // display CRP results
                    bloodResultCell.CRPResult.text = crpResults[indexPath.row][1];
                    bloodResultCell.ResultDate.text = [CBStringMethods dayAndMonthAndTimeInParenthesesForDate:crpResults[indexPath.row][6] andLocale:[NSLocale currentLocale]];
                }
                
                // first check number of data rows
                if (numberOfCRPResultsToDisplay % 2)
                {
                    if (indexPath.row % 2)
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                    else
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    }
                }
                else
                {
                    if (indexPath.row % 2)
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    }
                    else
                    {
                        bloodResultCell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                }
                
                return bloodResultCell;
            }
            else
            {
                CellIdentifier = @"Sepsis";
                
                if (newSepsis)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell = nil;
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    newSepsis = NO;
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
            }
        }
#pragma mark Drugs
        else if ([section.sectionName isEqualToString:@"Drugs"])
        {
            CellIdentifier = @"Drugs";
            
            if (newDrugs)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newDrugs = NO;
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
        }
#pragma mark Immunisations
        else if ([section.sectionName isEqualToString:@"Immunisations"])
        {
            CellIdentifier = @"Immunisations";
            
            if (newImmunisations)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newImmunisations = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.immunisationsTextView.text = self.selectedPatient.immunisations;
        }
#pragma mark ROP
        else if ([section.sectionName isEqualToString:@"ROP"])
        {
            CellIdentifier = @"ROP";
            
            if (newROP)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newROP = NO;
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
        }
#pragma mark Neurology & Cranial USS
        else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
        {
            CellIdentifier = @"NeurologyAndCranialUSS";
            
            if (newCranialUSS)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newCranialUSS = NO;
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
        }
#pragma mark Parents / Social
        else if ([section.sectionName isEqualToString:@"Parents / Social"])
        {
            CellIdentifier = @"ParentsSocial";
            
            if (newParentsAndSocial)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newParentsAndSocial = NO;
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
        }
#pragma mark Examination
        else if ([section.sectionName isEqualToString:@"Examination"])
        {
            CellIdentifier = @"Examination";
            
            if (newExamination)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newExamination = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.examinationTextView.text = self.selectedPatient.examination;
        }
#pragma mark Summary
        else if ([section.sectionName isEqualToString:@"Summary"])
        {
            CellIdentifier = @"Summary";
            
            if (newSummary)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newSummary = NO;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                }
            }
            
            self.summaryTextView.text = self.selectedPatient.summary;
        }
#pragma mark Plan
        else if ([section.sectionName isEqualToString:@"Plan"])
        {
            CellIdentifier = @"Plan";
            
            if (newPlan)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell = nil;
                cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                newPlan = NO;
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
        }
#pragma mark Suggestion
        else if ([section.sectionName isEqualToString:@"Suggestions"])
        {
            AI *brain = [AI sharedAI];
            
            NSArray *suggestions = [brain getSuggestionsForPatient:self.selectedPatient];
            
            int numberOfSuggestionsToDisplay = suggestions.count;
            
            if (indexPath.row < numberOfSuggestionsToDisplay)
            {
                CellIdentifier = [NSString stringWithFormat:@"Suggestion %i", indexPath.row];
                
                SuggestionTableViewCell *suggestionCell;
                
                suggestionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!suggestionCell)
                {
                    suggestionCell = [[SuggestionTableViewCell alloc] initWithStyle:nil reuseIdentifier:CellIdentifier];
                }
                
                NSString *suggestionText = suggestions[indexPath.row];
                
                // special case
                if ([suggestionText isEqualToString:@"None at present"])
                {
                    suggestionCell.noSuggestions.text = suggestionText;
                    suggestionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    suggestionCell.suggestionNumber.text = [NSString stringWithFormat:@"%i.", indexPath.row + 1];
                    suggestionCell.suggestion.text = suggestionText;
                }
                
                return suggestionCell;
            }
            else
            {
                CellIdentifier = @"BlankSpace";
                
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        else
        {
            // stops App from crashing if I add sections
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

- (void)selectClinicalStatus
{
    if ([self.clinicalStatusSegmentedControl selectedSegmentIndex] == 0)
    {
        self.selectedPatient.clinicalStatus = @"Well";
        self.clinicalStatus = @"Well";
    }
    else if ([self.clinicalStatusSegmentedControl selectedSegmentIndex] == 1)
    {
        self.selectedPatient.clinicalStatus = @"Unwell";
        self.clinicalStatus = @"Unwell";
    }
    
    // set neurotoxicity risk if both factors are set
    if (self.neurotoxicityRiskFactors && self.clinicalStatus)
    {
        [self calculateNeurotoxicityRisk];
    }
    
    // update ShinobiChart
    [self.chart reloadData];
    [self.chart redrawChart];
}

- (void)selectNeurotoxicityRiskFactors
{
    if ([self.neurotoxicityRiskFactorsSegmentedControl selectedSegmentIndex] == 0)
    {
        self.selectedPatient.neurotoxicityRiskFactors = @"None";
        self.neurotoxicityRiskFactors = @"None";
    }
    else if ([self.neurotoxicityRiskFactorsSegmentedControl selectedSegmentIndex] == 1)
    {
        self.selectedPatient.neurotoxicityRiskFactors = @"Present";
        self.neurotoxicityRiskFactors = @"Present";
    }
    
    // set neurotoxicity risk if both factors are set
    if (self.neurotoxicityRiskFactors && self.clinicalStatus)
    {
        [self calculateNeurotoxicityRisk];
    }
    
    // update ShinobiChart
    [self.chart reloadData];
    [self.chart redrawChart];
}

- (void)calculateNeurotoxicityRisk
{
    NSLog(@"1");
    
    // this is for the US guideline
    if ([self.selectedPatient.gestation integerValue] >= 38)
    {
        if ([self.clinicalStatus isEqualToString:@"Well"] && [self.neurotoxicityRiskFactors isEqualToString:@"None"])
        {
            self.neurotoxicityRisk = @"Lower";
        }
        else
        {
            self.neurotoxicityRisk = @"Medium";
        }
    }
    else if ([self.selectedPatient.gestation integerValue] >= 35)
    {
        if ([self.clinicalStatus isEqualToString:@"Well"] && [self.neurotoxicityRiskFactors isEqualToString:@"None"])
        {
            self.neurotoxicityRisk = @"Medium";
        }
        else
        {
            self.neurotoxicityRisk = @"Higher";
        }
    }
    else
    {
        // display a message
    }
}

#pragma mark -

- (int)getUserDefinedSectionForTextView:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    // this is because the user can reorder the sections
    HandoverSection *handoverSectionDefaultOrder = self.selectedPatient.handoverSections[textView.tag];
    
    HandoverSection *handoverSectionUserOrder;
    
    int section = 0;
    
    int correctSection;
    
    for (handoverSectionUserOrder in preferences.handoverSections)
    {
        if ([handoverSectionUserOrder.sectionName isEqualToString:handoverSectionDefaultOrder.sectionName])
        {
            correctSection = section;
        }
        
        // increment section
        section = section + 1;
    }
    
    return correctSection;
}

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
        
        // weights label
        UILabel *weightTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 65.0f, 300.0f, 22.0f)];
        weightTextLabel.textColor = [UIColor grayColor];
        weightTextLabel.backgroundColor = [UIColor clearColor];
        weightTextLabel.font = [UIFont systemFontOfSize:14.0f];
        weightTextLabel.adjustsFontSizeToFitWidth = NO;
        weightTextLabel.textAlignment = UITextAlignmentLeft;
        weightTextLabel.text = @"BW 1.255 kg CW 1.155 kg (7% loss) WW 1.255 kg";
        [cell.contentView addSubview:weightTextLabel];
        
        // display patient's name & birthDate
        if (self.selectedPatient.birthDate)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.timeZone = [NSTimeZone localTimeZone];
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
            displayAgeTextLabel.text = [NSString stringWithFormat:@"%@ %i (%@)", NSLocalizedString(@"day", nil), [CBTimeMethods getAgeInDaysOfPatient:self.selectedPatient], correctedAge];
            
            /* display days and corrected age
            displayAgeTextLabel.text = [NSString stringWithFormat:@"%@ %i (%@) %@", NSLocalizedString(@"day", nil), [CBTimeMethods getAgeInDaysOfPatient:self.selectedPatient], correctedAge, [self.selectedPatient returnGestationAndCorrectedGestationOnly]];
             */
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
#pragma mark Weight
    else if ([CellIdentifier isEqualToString:@"Weight"])
    {
        // should I not be using:
        // if (!self.weightTextView...
#warning Possible memory leak...
        self.weightTextView = [[UITextView alloc] init];
        self.weightTextView.tag = 22;
        [self setupTextView:self.weightTextView];
        
        [cell.contentView addSubview:self.weightTextView];
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
#pragma mark Haematology
    else if ([CellIdentifier isEqualToString:@"Haematology"])
    {
        self.haematologyTextView = [[UITextView alloc] init];
        self.haematologyTextView.tag = 20;
        [self setupTextView:self.haematologyTextView];
        
        [cell.contentView addSubview:self.haematologyTextView];
    }
#pragma mark Lines
    else if ([CellIdentifier isEqualToString:@"Lines"])
    {
        self.linesTextView = [[UITextView alloc] init];
        self.linesTextView.tag = 7;
        [self setupTextView:self.linesTextView];
        
        [cell.contentView addSubview:self.linesTextView];
    }
#pragma mark Echocardiogram
    else if ([CellIdentifier isEqualToString:@"Echocardiogram"])
    {
        self.echocardiogramTextView = [[UITextView alloc] init];
        self.echocardiogramTextView.tag = 21;
        [self setupTextView:self.echocardiogramTextView];
        
        [cell.contentView addSubview:self.echocardiogramTextView];
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
        self.biochemistryTextView = [[UITextView alloc] init];
        self.biochemistryTextView.tag = 10;
        [self setupTextView:self.biochemistryTextView];
        
        [cell.contentView addSubview:self.biochemistryTextView];
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
#pragma mark Immunisations
    else if ([CellIdentifier isEqualToString:@"Immunisations"])
    {
        self.immunisationsTextView = [[UITextView alloc] init];
        self.immunisationsTextView.tag = 23;
        [self setupTextView:self.immunisationsTextView];
        
        [cell.contentView addSubview:self.immunisationsTextView];
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
        self.examinationTextView = [[UITextView alloc] init];
        self.examinationTextView.tag = 17;
        [self setupTextView:self.examinationTextView];
        
        [cell.contentView addSubview:self.examinationTextView];
    }
#pragma mark Summary
    else if ([CellIdentifier isEqualToString:@"Summary"])
    {
        self.summaryTextView = [[UITextView alloc] init];
        self.summaryTextView.tag = 18;
        [self setupTextView:self.summaryTextView];
        
        [cell.contentView addSubview:self.summaryTextView];
    }
#pragma mark Plan
    else if ([CellIdentifier isEqualToString:@"Plan"])
    {
        self.planTextView = [[UITextView alloc] init];
        self.planTextView.tag = 19;
        [self setupTextView:self.planTextView];
        
        [cell.contentView addSubview:self.planTextView];
    }
    
    return cell;
}

- (UITextView *)setupTextView:(UITextView *)textView
{
    // Preferences *preferences = [Preferences sharedPreferences];
    
    // get textView height
    HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
    
//    // this could be deleted with code lower down
//    HandoverRow *row;
//    
//    if (textView.tag == 11)
//    {
//        row = section.rows[1];
//    }
//    else
//    {
//        row = section.rows[0];
//    }
    
    // set values
    textView.textColor = [UIColor grayColor];
    textView.scrollEnabled = NO;
    
    
    UITextView *textViewToMeasure;
    
    if (!textViewToMeasure)
    {
        textViewToMeasure = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
    }
    
    if ([section.sectionName isEqualToString:@"Weight"])
    {
        textViewToMeasure.text = self.selectedPatient.weight;
        
        if (self.selectedPatient.weightLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.weightLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Background"])
    {
        // textViewToMeasure.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
        textViewToMeasure.text = self.selectedPatient.background;
        
        if (self.selectedPatient.backgroundLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.backgroundLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Active Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.activeProblems;
        
        if (self.selectedPatient.activeProblemsLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.activeProblemsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Resolved Problems"])
    {
        textViewToMeasure.text = self.selectedPatient.resolvedProblems;
        
        if (self.selectedPatient.resolvedProblemsLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.resolvedProblemsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
    {
        textViewToMeasure.text = self.selectedPatient.recentSignificantEvents;
        
        if (self.selectedPatient.recentSignificantEventsLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.recentSignificantEventsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
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
    else if ([section.sectionName isEqualToString:@"CXR"])
    {
        textViewToMeasure.text = self.selectedPatient.cxr;
        
        if (self.selectedPatient.cxrLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.cxrLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Cardiovascular"])
    {
        textViewToMeasure.text = self.selectedPatient.cardiovascular;
        
        if (self.selectedPatient.cardiovascularLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.cardiovascularLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Haematology"])
    {
        textViewToMeasure.text = self.selectedPatient.haematology;
        
        if (self.selectedPatient.haematologyLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.haematologyLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Lines"])
    {
        textViewToMeasure.text = self.selectedPatient.lines;
        
        if (self.selectedPatient.linesLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.linesLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Echocardiogram"])
    {
        textViewToMeasure.text = self.selectedPatient.echocardiogram;
        
        if (self.selectedPatient.echocardiogramLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.echocardiogramLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
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
    else if ([section.sectionName isEqualToString:@"Fluid Balance"])
    {
        textViewToMeasure.text = self.selectedPatient.fluidBalance;
        
        if (self.selectedPatient.fluidBalanceLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.fluidBalanceLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Biochemistry"])
    {
        textViewToMeasure.text = self.selectedPatient.biochemistry;
        
        if (self.selectedPatient.biochemistryLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.biochemistryLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Jaundice"])
    {
        textViewToMeasure.text = self.selectedPatient.jaundice;
        
        if (self.selectedPatient.jaundiceLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.jaundiceLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Sepsis"])
    {
        textViewToMeasure.text = self.selectedPatient.sepsis;
        
        if (self.selectedPatient.sepsisLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.sepsisLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Drugs"])
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
    else if ([section.sectionName isEqualToString:@"Immunisations"])
    {
        textViewToMeasure.text = self.selectedPatient.immunisations;
        
        if (self.selectedPatient.immunisationsLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.immunisationsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"ROP"])
    {
        textViewToMeasure.text = self.selectedPatient.rop;
        
        if (self.selectedPatient.ropLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.ropLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
    {
        textViewToMeasure.text = self.selectedPatient.cranialUSS;
        
        if (self.selectedPatient.cranialUSSLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.cranialUSSLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Parents / Social"])
    {
        textViewToMeasure.text = self.selectedPatient.parentsAndSocial;
        
        if (self.selectedPatient.parentsAndSocialLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.parentsAndSocialLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Examination"])
    {
        textViewToMeasure.text = self.selectedPatient.examination;
        
        if (self.selectedPatient.examinationLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.examinationLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Summary"])
    {
        textViewToMeasure.text = self.selectedPatient.summary;
        
        if (self.selectedPatient.summaryLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.summaryLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Plan"])
    {
        textViewToMeasure.text = self.selectedPatient.plan;
        
        if (self.selectedPatient.planLastEntryDate)
        {
            if ([self isDate:self.selectedPatient.planLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
            {
                textView.textColor = [UIColor redColor];
            }
        }
    }
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.dynamicText intValue] && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    else
    {
        textView.font = [UIFont systemFontOfSize:14.0f];
        textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
    }
    
    [textViewToMeasure sizeToFit];
    
    CGFloat height = textViewToMeasure.frame.size.height;
    
    textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
    
    
//    // Plan textView must stay large
//    if (![section.sectionName isEqualToString:@"Plan"])
//    {
//        // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
//        
//        [textViewToMeasure sizeToFit];
//        
//        CGFloat height = textViewToMeasure.frame.size.height;
//        
//        textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//    }
//    else
//    {
//        // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
//        
//        [textViewToMeasure sizeToFit];
//        
//        CGFloat height = textViewToMeasure.frame.size.height;
//        
//        // delegate
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        
//        // set a minimum height for the plan textView
//        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
//        {
//            if (height < 344.0f)
//            {
//                height = 344.0f;
//            }
//        }
//        else
//        {
//            if (height < 192.0f)
//            {
//                height = 192.0f;
//            }
//        }
//        
//        textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//    }
    
    //        Preferences *preferences = [Preferences sharedPreferences];
    //
    //        if ([preferences.dynamicText intValue])
    //        {
    //            textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //        }
    //        else
    //        {
    //            textView.font = [UIFont systemFontOfSize:14.0f];
    //        }
    
    
    // iOS 7 specifics
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
//    {
//        UITextView *textViewToMeasure;
//        
//        if (!textViewToMeasure)
//        {
//            textViewToMeasure = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 310.0f, FLT_MAX)];
//        }
//        
//        if ([section.sectionName isEqualToString:@"Weight"])
//        {
//            // textViewToMeasure.text = [NSString stringWithFormat:@"%@", self.selectedPatient.weight];
//            textViewToMeasure.text = self.selectedPatient.weight;
//            
//            if (self.selectedPatient.weightLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.weightLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Background"])
//        {
//            // textViewToMeasure.text = [NSString stringWithFormat:@"%@", self.selectedPatient.background];
//            textViewToMeasure.text = self.selectedPatient.background;
//            
//            if (self.selectedPatient.backgroundLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.backgroundLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Active Problems"])
//        {
//            textViewToMeasure.text = self.selectedPatient.activeProblems;
//            
//            if (self.selectedPatient.activeProblemsLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.activeProblemsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Resolved Problems"])
//        {
//            textViewToMeasure.text = self.selectedPatient.resolvedProblems;
//            
//            if (self.selectedPatient.resolvedProblemsLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.resolvedProblemsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Recent Significant Events"])
//        {
//            textViewToMeasure.text = self.selectedPatient.recentSignificantEvents;
//            
//            if (self.selectedPatient.recentSignificantEventsLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.recentSignificantEventsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Ventilation & Sedation"])
//        {
//            textViewToMeasure.text = self.selectedPatient.ventilationAndSedation;
//            
//            if (self.selectedPatient.ventilationAndSedationLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.ventilationAndSedationLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"CXR"])
//        {
//            textViewToMeasure.text = self.selectedPatient.cxr;
//            
//            if (self.selectedPatient.cxrLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.cxrLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Cardiovascular"])
//        {
//            textViewToMeasure.text = self.selectedPatient.cardiovascular;
//            
//            if (self.selectedPatient.cardiovascularLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.cardiovascularLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Haematology"])
//        {
//            textViewToMeasure.text = self.selectedPatient.haematology;
//            
//            if (self.selectedPatient.haematologyLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.haematologyLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Lines"])
//        {
//            textViewToMeasure.text = self.selectedPatient.lines;
//            
//            if (self.selectedPatient.linesLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.linesLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Echocardiogram"])
//        {
//            textViewToMeasure.text = self.selectedPatient.echocardiogram;
//            
//            if (self.selectedPatient.echocardiogramLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.echocardiogramLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Feeds & Fluids"])
//        {
//            textViewToMeasure.text = self.selectedPatient.feedsAndFluids;
//            
//            if (self.selectedPatient.feedsAndFluidLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.feedsAndFluidLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Fluid Balance"])
//        {
//            textViewToMeasure.text = self.selectedPatient.fluidBalance;
//            
//            if (self.selectedPatient.fluidBalanceLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.fluidBalanceLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Biochemistry"])
//        {
//            textViewToMeasure.text = self.selectedPatient.biochemistry;
//            
//            if (self.selectedPatient.biochemistryLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.biochemistryLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Jaundice"])
//        {
//            textViewToMeasure.text = self.selectedPatient.jaundice;
//            
//            if (self.selectedPatient.jaundiceLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.jaundiceLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Sepsis"])
//        {
//            textViewToMeasure.text = self.selectedPatient.sepsis;
//            
//            if (self.selectedPatient.sepsisLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.sepsisLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Drugs"])
//        {
//            textViewToMeasure.text = self.selectedPatient.drugs;
//            
//            if (self.selectedPatient.drugsLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.drugsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Immunisations"])
//        {
//            textViewToMeasure.text = self.selectedPatient.immunisations;
//            
//            if (self.selectedPatient.immunisationsLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.immunisationsLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"ROP"])
//        {
//            textViewToMeasure.text = self.selectedPatient.rop;
//            
//            if (self.selectedPatient.ropLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.ropLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Neurology & Cranial USS"])
//        {
//            textViewToMeasure.text = self.selectedPatient.cranialUSS;
//            
//            if (self.selectedPatient.cranialUSSLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.cranialUSSLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Parents / Social"])
//        {
//            textViewToMeasure.text = self.selectedPatient.parentsAndSocial;
//            
//            if (self.selectedPatient.parentsAndSocialLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.parentsAndSocialLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Examination"])
//        {
//            textViewToMeasure.text = self.selectedPatient.examination;
//            
//            if (self.selectedPatient.examinationLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.examinationLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Summary"])
//        {
//            textViewToMeasure.text = self.selectedPatient.summary;
//            
//            if (self.selectedPatient.summaryLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.summaryLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        else if ([section.sectionName isEqualToString:@"Plan"])
//        {
//            textViewToMeasure.text = self.selectedPatient.plan;
//            
//            if (self.selectedPatient.planLastEntryDate)
//            {
//                if ([self isDate:self.selectedPatient.planLastEntryDate moreThanTwelveHoursLaterThanDate:[NSDate date]])
//                {
//                    textView.textColor = [UIColor redColor];
//                }
//            }
//        }
//        
//        Preferences *preferences = [Preferences sharedPreferences];
//        
//        if ([preferences.dynamicText intValue])
//        {
//            textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//            textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        }
//        else
//        {
//            textView.font = [UIFont systemFontOfSize:14.0f];
//            textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
//        }
//        
//        [textViewToMeasure sizeToFit];
//        
//        CGFloat height = textViewToMeasure.frame.size.height;
//        
//        textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//        
//        
//        // Plan textView must stay large
//        if (![section.sectionName isEqualToString:@"Plan"])
//        {
//            // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//            textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
//            
//            [textViewToMeasure sizeToFit];
//            
//            CGFloat height = textViewToMeasure.frame.size.height;
//            
//            textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//        }
//        else
//        {
//            // textViewToMeasure.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//            textViewToMeasure.font = [UIFont systemFontOfSize:14.0f];
//            
//            [textViewToMeasure sizeToFit];
//            
//            CGFloat height = textViewToMeasure.frame.size.height;
//            
//            // delegate
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            
//            // set a minimum height for the plan textView
//            if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
//            {
//                if (height < 344.0f)
//                {
//                    height = 344.0f;
//                }
//            }
//            else
//            {
//                if (height < 192.0f)
//                {
//                    height = 192.0f;
//                }
//            }
//            
//            textView.frame = CGRectMake(10.0f, 0.0f, 310.0f, height);
//        }
//        
////        Preferences *preferences = [Preferences sharedPreferences];
////        
////        if ([preferences.dynamicText intValue])
////        {
////            textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
////        }
////        else
////        {
////            textView.font = [UIFont systemFontOfSize:14.0f];
////        }
//    }
//    else
//    {
//        // this could be deleted iOS 6 & iOS 7 should be the same...
//        textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, [row.rowHeight floatValue]);
//        textView.font = [UIFont systemFontOfSize:14.0f];
//    }
    
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

- (void)loseFocusOnAllTextViews
{
    [self.weightTextView resignFirstResponder];
    [self.backgroundTextView resignFirstResponder];
    [self.activeProblemsTextView resignFirstResponder];
    [self.resolvedProblemsTextView resignFirstResponder];
    [self.recentSignificantEventsTextView resignFirstResponder];
    [self.ventilationAndSedationTextView resignFirstResponder];
    [self.cxrTextView resignFirstResponder];
    [self.cardiovascularTextView resignFirstResponder];
    [self.haematologyTextView resignFirstResponder];
    [self.linesTextView resignFirstResponder];
    [self.echocardiogramTextView resignFirstResponder];
    [self.fluidBalanceTextView resignFirstResponder];
    [self.feedsAndFluidsTextView resignFirstResponder];
    [self.biochemistryTextView resignFirstResponder];
    [self.jaundiceTextView resignFirstResponder];
    [self.sepsisTextView resignFirstResponder];
    [self.drugsTextView resignFirstResponder];
    [self.immunisationsTextView resignFirstResponder];
    [self.ropTextView resignFirstResponder];
    [self.cranialUSSTextView resignFirstResponder];
    [self.parentsAndSocialTextView resignFirstResponder];
    [self.examinationTextView resignFirstResponder];
    [self.summaryTextView resignFirstResponder];
    [self.planTextView resignFirstResponder];
}

- (BOOL)isDate:(NSDate *)date moreThanTwelveHoursLaterThanDate:(NSDate *)currentDate
{
    double daysSinceEdit = [CBTimeMethods getDaysDifferenceDoubleBetween:date and:currentDate];
    
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
        // alternative
        Preferences *preferences = [Preferences sharedPreferences];
        
        // whether a section is editable is contained in data from the preferences handover sections
        HandoverSection *section = preferences.handoverSections[indexPath.section];
        
        if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            int numberOfFluidBalanceRows = [self.selectedPatient getNumberOfFluidBalanceRows];
            
            if (indexPath.row < numberOfFluidBalanceRows)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else if ([section.sectionName isEqualToString:@"Jaundice"])
        {
            if ([preferences.guidelineCountry isEqualToString:@"US"])
            {
                if (indexPath.row == 0 || indexPath.row == 3)
                {
                    userCanEditRowAtIndexPath = YES;
                }
            }
            else
            {
                userCanEditRowAtIndexPath = YES;
            }
        }
        else
        {
            userCanEditRowAtIndexPath = [section.sectionEditable boolValue];
        }
    }
    
    return userCanEditRowAtIndexPath;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self loseFocusOnAllTextViews];
    
    [self.myTableView1 setEditing:editing animated:YES];
    [self.myTableView2 setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle *editingStyle = UITableViewCellEditingStyleInsert;
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *section = preferences.handoverSections[indexPath.section];
    
    if ([tableView isEqual:self.myTableView1])
    {
        editingStyle = UITableViewCellEditingStyleInsert;
    }
    else if ([tableView isEqual:self.myTableView2])
    {
        if ([section.sectionName isEqualToString:@"Haematology"])
        {
            int numberOfHaematologyResultsToDisplay = [[self getHaematologyResultsToDisplay] count];
            
            if (indexPath.row < numberOfHaematologyResultsToDisplay)
            {
                // these are for the haematology results
                editingStyle = UITableViewCellEditingStyleDelete;
            }
            else
            {
                // this is for the free text
                editingStyle = UITableViewCellEditingStyleInsert;
            }
        }
        else if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            int numberOfFluidBalanceRows = [self.selectedPatient getNumberOfFluidBalanceRows];
            
            if (indexPath.row < numberOfFluidBalanceRows)
            {
                editingStyle = UITableViewCellEditingStyleNone;
            }
            else
            {
                editingStyle = UITableViewCellEditingStyleInsert;
            }
        }
        else if ([section.sectionName isEqualToString:@"Biochemistry"])
        {
            int numberOfBiochemistryResultsToDisplay = [[self getBiochemistryResultsToDisplay] count];
            
            if (indexPath.row < numberOfBiochemistryResultsToDisplay)
            {
                // these are for the haematology results
                editingStyle = UITableViewCellEditingStyleDelete;
            }
            else
            {
                // this is for the free text
                editingStyle = UITableViewCellEditingStyleInsert;
            }
        }
        else if ([section.sectionName isEqualToString:@"Jaundice"])
        {
            editingStyle = UITableViewCellEditingStyleInsert;
        }
        else if ([section.sectionName isEqualToString:@"Sepsis"])
        {
            int numberOfCRPResultsToDisplay = [[self getCRPResultsToDisplay] count];
            
            if (indexPath.row < numberOfCRPResultsToDisplay)
            {
                // these are for the haematology results
                editingStyle = UITableViewCellEditingStyleDelete;
            }
            else
            {
                // this is for the free text
                editingStyle = UITableViewCellEditingStyleInsert;
            }
        }
        else
        {
            editingStyle = UITableViewCellEditingStyleInsert;
        }
    }
    
    return editingStyle;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleForDeleteConfirmationButton;;
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *section = preferences.handoverSections[indexPath.section];
    
    if ([tableView isEqual:self.myTableView2])
    {
        if ([section.sectionName isEqualToString:@"Haematology"])
        {
            int numberOfHaematologyResultsToDisplay = [[self getHaematologyResultsToDisplay] count];
            
            if (indexPath.row < numberOfHaematologyResultsToDisplay)
            {
                // these are for the haematology results
                titleForDeleteConfirmationButton = NSLocalizedString(@"Hide Result", nil);
            }
        }
        else if ([section.sectionName isEqualToString:@"Biochemistry"])
        {
            int numberOfBiochemistryResultsToDisplay = [[self getBiochemistryResultsToDisplay] count];
            
            if (indexPath.row < numberOfBiochemistryResultsToDisplay)
            {
                // these are for the biochemistry results
                titleForDeleteConfirmationButton = NSLocalizedString(@"Hide Result", nil);
            }
        }
        else if ([section.sectionName isEqualToString:@"Sepsis"])
        {
            int numberOfCRPResultsToDisplay = [[self getCRPResultsToDisplay] count];
            
            if (indexPath.row < numberOfCRPResultsToDisplay)
            {
                // these are for the CRP results
                titleForDeleteConfirmationButton = NSLocalizedString(@"Hide Result", nil);
            }
        }
    }
    
    return titleForDeleteConfirmationButton;
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
        Preferences *preferences = [Preferences sharedPreferences];
        
        HandoverSection *section = preferences.handoverSections[indexPath.section];
        
        if ([section.sectionName isEqualToString:@"Haematology"])
        {
            NSArray *haematologyResults = [self getHaematologyResultsToDisplay];
            
            int numberOfHaematologyResultsToDisplay = [haematologyResults count];
            
            if (indexPath.row < numberOfHaematologyResultsToDisplay)
            {
                // use @"Unique Reference" to change display value
                NSDictionary *sampleData;
                
                // cycle through all selected patient's sampledata
                for (sampleData in self.selectedPatient.allBloodResultSampleData)
                {
                    if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:haematologyResults[indexPath.row][5]])
                    {
                        if ([haematologyResults[indexPath.row][0] isEqualToString:@"FBC Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display FBC"];
                        }
                        else if ([haematologyResults[indexPath.row][0] isEqualToString:@"Clotting Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Clotting"];
                        }
                        else if ([haematologyResults[indexPath.row][0] isEqualToString:@"Fibrinogen Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Fibrinogen"];
                        }
                    }
                }
                
                // delete row
                NSArray *indexPaths = @[indexPath];
                
                [self.myTableView2 deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                JLActionSheet *actionSheet = [[JLActionSheet alloc] initWithTitle:NSLocalizedString(@"Haematology", nil)
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                otherButtonTitles:@[NSLocalizedString(@"Add new results", nil) , NSLocalizedString(@"Show hidden results", nil)]];
                
                actionSheet.tag = 0;
                [actionSheet showOnViewController:self];
            }
        }
        
        // Biochemistry
        else if ([section.sectionName isEqualToString:@"Biochemistry"])
        {
            NSArray *biochemistryResults = [self getBiochemistryResultsToDisplay];
            
            int numberOfBiochemistryResultsToDisplay = [biochemistryResults count];
            
            if (indexPath.row < numberOfBiochemistryResultsToDisplay)
            {
                // use @"Unique Reference" to change display value
                NSDictionary *sampleData;
                
                // cycle through all selected patient's sampledata
                for (sampleData in self.selectedPatient.allBloodResultSampleData)
                {
                    if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:biochemistryResults[indexPath.row][7]])
                    {
                        if ([biochemistryResults[indexPath.row][0] isEqualToString:@"U&Es Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display U&Es"];
                        }
                        else if ([biochemistryResults[indexPath.row][0] isEqualToString:@"LFT Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display LFTs"];
                        }
                        else if ([biochemistryResults[indexPath.row][0] isEqualToString:@"Conjugated Bilirubin Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Conjugated Bilirubin"];
                        }
                        else if ([biochemistryResults[indexPath.row][0] isEqualToString:@"Bone Profile Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Bone Profile"];
                        }
                        else if ([biochemistryResults[indexPath.row][0] isEqualToString:@"Magnesium Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Magnesium"];
                        }
                        else if ([biochemistryResults[indexPath.row][0] isEqualToString:@"Ammonia Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display Ammonia"];
                        }
                    }
                }
                
                // delete row
                NSArray *indexPaths = @[indexPath];
                
                [self.myTableView2 deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
                // calling this to update shading
                // [self getBiochemistryResultsToDisplay];
                
                [self.myTableView2 reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                JLActionSheet *actionSheet = [[JLActionSheet alloc] initWithTitle:NSLocalizedString(@"Biochemistry", nil)
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                otherButtonTitles:@[NSLocalizedString(@"Add new results", nil) , NSLocalizedString(@"Show hidden results", nil)]];
                
                actionSheet.tag = 1;
                [actionSheet showOnViewController:self];
            }
        }
        // Sepsis
        else if ([section.sectionName isEqualToString:@"Sepsis"])
        {
            NSArray *CRPResults = [self getCRPResultsToDisplay];
            
            int numberOfCRPResultsToDisplay = [CRPResults count];
            
            if (indexPath.row < numberOfCRPResultsToDisplay)
            {
                // use @"Unique Reference" to change display value
                NSDictionary *sampleData;
                
                // cycle through all selected patient's sampledata
                for (sampleData in self.selectedPatient.allBloodResultSampleData)
                {
                    if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:CRPResults[indexPath.row][7]])
                    {
                        if ([CRPResults[indexPath.row][0] isEqualToString:@"CRP Result"])
                        {
                            [sampleData setValue:@"NO" forKey:@"Display CRP"];
                        }
                    }
                }
                
                // delete row
                NSArray *indexPaths = @[indexPath];
                
                [self.myTableView2 deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else
            {
                JLActionSheet *actionSheet = [[JLActionSheet alloc] initWithTitle:NSLocalizedString(@"Sepsis", nil)
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                otherButtonTitles:@[NSLocalizedString(@"Add new results", nil) , NSLocalizedString(@"Show hidden results", nil)]];
                
                actionSheet.tag = 2;
                [actionSheet showOnViewController:self];
            }
        }
        
        // Vascular lines
        else if ([section.sectionName isEqualToString:@"Lines"])
        {
            VascularLinesTableViewController *vc = [[VascularLinesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.selectedPatient = self.selectedPatient;
            vc.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
            
            [self setupAndPresentModalNavController:navController];
        }
        
        else if ([section.sectionName isEqualToString:@"Fluid Balance"])
        {
            FluidBalanceTableViewController *vc = [[FluidBalanceTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.selectedPatient = self.selectedPatient;
            vc.isBeingUsedAsAModalViewController = YES;
            vc.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
            
            [self setupAndPresentModalNavController:navController];
        }
        
        // Jaundice
        else if ([section.sectionName isEqualToString:@"Jaundice"])
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
                
                [self setupAndPresentModalNavController:navController];
            }
            else
            {
                // Blood Group Info
                JaundiceViewController *newViewController = [[JaundiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
                
                [self setupAndPresentModalNavController:navController];
            }
        }
    }
}

- (void)setupAndPresentModalNavController:(PortraitOnlyNavigationController *)navController
{
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

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedPath = nil;
    
    if ([tableView isEqual:self.myTableView1])
    {
        [self loseFocusOnAllTextViews];
    }
    else
    {
        selectedPath = indexPath;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *section = preferences.handoverSections[indexPath.section];
    
    if ([section.sectionName isEqualToString:@"Haematology"])
    {
        // get the reference to the selected result
        NSArray *haematologyResults = [self getHaematologyResultsToDisplay];
        
        // use @"Unique Reference" to change display value
#warning unique reference will not be unique if syncing data
        
        NSDictionary *sampleData;
        
        // cycle through all selected patient's sampledata
        for (sampleData in self.selectedPatient.allBloodResultSampleData)
        {
            if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:haematologyResults[indexPath.row][5]])
            {
                // instantiate view controller
                AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                vc.sampleData = [NSMutableDictionary dictionaryWithDictionary:sampleData];
                vc.bloodResultOrder = @"Haematology First";
                vc.editOrAddResult = @"Edit";
                vc.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
                
                [self setupAndPresentModalNavController:navController];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Fluid Balance"])
    {
        // code
    }
    else if ([section.sectionName isEqualToString:@"Biochemistry"])
    {
        // get the reference to the selected result
        NSArray *biochemistryResults = [self getBiochemistryResultsToDisplay];
        
        // use @"Unique Reference" to change display value
        NSDictionary *sampleData;
        
        // cycle through all selected patient's sampledata
        for (sampleData in self.selectedPatient.allBloodResultSampleData)
        {
            if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:biochemistryResults[indexPath.row][7]])
            {
                // instantiate view controller
                AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                vc.sampleData = [NSMutableDictionary dictionaryWithDictionary:sampleData];
                vc.bloodResultOrder = @"Biochemistry First";
                vc.editOrAddResult = @"Edit";
                vc.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
                
                [self setupAndPresentModalNavController:navController];
            }
        }
    }
    else if ([section.sectionName isEqualToString:@"Sepsis"])
    {
        // get the reference to the selected result
        NSArray *CRPResults = [self getCRPResultsToDisplay];
        
        // use @"Unique Reference" to change display value
        NSDictionary *sampleData;
        
        // cycle through all selected patient's sampledata
        for (sampleData in self.selectedPatient.allBloodResultSampleData)
        {
            if ([[sampleData objectForKey:@"Unique Reference"] isEqualToNumber:CRPResults[indexPath.row][7]])
            {
                // instantiate view controller
                AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                vc.sampleData = [NSMutableDictionary dictionaryWithDictionary:sampleData];
                vc.bloodResultOrder = @"Sepsis First";
                vc.editOrAddResult = @"Edit";
                vc.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
                
                [self setupAndPresentModalNavController:navController];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // user can only enter text if editing is off
    return !self.editing;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*  Code to handle the following functions:
     *  1) Determine the correct indexPath.row that the user is at
     *  2) Animate the 'Patient Details' upwards off the screen if the user is using a 3.5inch screen (iPhone 4/4S)
     *  3) Determine scrollPosition depending on height of text in TextView
     */
    
    int row = 0;
    
    // Haematology textView
    if ([textView isEqual:self.haematologyTextView])                            // == (textView.tag == 20)
    {
        row = [self getHaematologyResultsToDisplay].count;
    }
    // Biochemistry textView
    else if ([textView isEqual:self.biochemistryTextView])                      // == (textView.tag == 10)
    {
        row = [self getBiochemistryResultsToDisplay].count;
    }
    // Jaundice cell different
    else if ([textView isEqual:self.jaundiceTextView])                          // == (textView.tag == 11)
    {
        Preferences *preferences = [Preferences sharedPreferences];
        if ([preferences.guidelineCountry isEqualToString:@"US"]) row = 3;
        else row = 1;
    }
    // Sepsis textView
    else if ([textView isEqual:self.sepsisTextView])                            // == (textView.tag == 12)
    {
        row = [self getCRPResultsToDisplay].count;
    }
    
    // check if user is using the 3.5 inch screen or 4 inch screen
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
    {
        // animate patient details off to make room
        [self animatePatientDetailsOff];
    }
    
    // get correct indexPath (as user can reorder sections in preferences)
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:[self getUserDefinedSectionForTextView:textView]];
    
    // check if text is greater than the available screen height
    CGFloat heightOfTextView = [self heightForTextView:textView];
    
    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
    {
        if (heightOfTextView <= 134.0f)
        {
            [self.myTableView2 scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionTop
                                             animated:YES];
        }
    }
    else
    {
        if (heightOfTextView <= 134.0f)
        {
            [self.myTableView2 scrollToRowAtIndexPath:indexPath
                                     atScrollPosition:UITableViewScrollPositionMiddle
                                             animated:NO];
        }
    }
    
    // change right bar button
    [self.navigationItem setRightBarButtonItem:[CBBarButtonItems infoBarButtonWithTarget:self
                                                                                  action:@selector(showModalPanel:)]
                                      animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // animate 'Patient Details' back on if using 3.5inch iPhone 4/4S
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
    {
        [self animatePatientDetailsOn];
    }
    
    // change right bar button back
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:YES];
}

/*
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
 */

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
    
    // This is actually referencing the height of
    // a new textViewToMeasure filled with text from before
    // the change.
    
    heightBeforeChange = [self heightForTextView:textView];
    
//    // iOS 7 specifics
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
//    {
//        // This is actually referencing the height of
//        // a new textViewToMeasure filled with text from before
//        // the change.
//        
//        heightBeforeChange = [self heightForTextView:textView];
//    }
    
    // set text
    {
        if ([textView isEqual:self.weightTextView])
        {
            self.selectedPatient.weight = textView.text;
            self.selectedPatient.weightLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.backgroundTextView])
        {
            self.selectedPatient.background = textView.text;
            self.selectedPatient.backgroundLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.activeProblemsTextView])
        {
            self.selectedPatient.activeProblems = textView.text;
            self.selectedPatient.activeProblemsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.resolvedProblemsTextView])
        {
            self.selectedPatient.resolvedProblems = textView.text;
            self.selectedPatient.resolvedProblemsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.recentSignificantEventsTextView])
        {
            self.selectedPatient.recentSignificantEvents = textView.text;
            self.selectedPatient.recentSignificantEventsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.ventilationAndSedationTextView])
        {
            self.selectedPatient.ventilationAndSedation = textView.text;
            self.selectedPatient.ventilationAndSedationLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.cxrTextView])
        {
            self.selectedPatient.cxr = textView.text;
            self.selectedPatient.cxrLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.cardiovascularTextView])
        {
            self.selectedPatient.cardiovascular = textView.text;
            self.selectedPatient.cardiovascularLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.haematologyTextView])
        {
            self.selectedPatient.haematology = textView.text;
            self.selectedPatient.haematologyLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.linesTextView])
        {
            self.selectedPatient.lines = textView.text;
            self.selectedPatient.linesLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.echocardiogramTextView])
        {
            self.selectedPatient.echocardiogram = textView.text;
            self.selectedPatient.echocardiogramLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.feedsAndFluidsTextView])
        {
            self.selectedPatient.feedsAndFluids = textView.text;
            self.selectedPatient.feedsAndFluidLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.fluidBalanceTextView])
        {
            self.selectedPatient.fluidBalance = textView.text;
            self.selectedPatient.fluidBalanceLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.biochemistryTextView])
        {
            self.selectedPatient.biochemistry = textView.text;
            self.selectedPatient.biochemistryLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.jaundiceTextView])
        {
            self.selectedPatient.jaundice = textView.text;
            self.selectedPatient.jaundiceLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.sepsisTextView])
        {
            self.selectedPatient.sepsis = textView.text;
            self.selectedPatient.sepsisLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.drugsTextView])
        {
            self.selectedPatient.drugs = textView.text;
            self.selectedPatient.drugsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.immunisationsTextView])
        {
            self.selectedPatient.immunisations = textView.text;
            self.selectedPatient.immunisationsLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.ropTextView])
        {
            self.selectedPatient.rop = textView.text;
            self.selectedPatient.ropLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.cranialUSSTextView])
        {
            self.selectedPatient.cranialUSS = textView.text;
            self.selectedPatient.cranialUSSLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.parentsAndSocialTextView])
        {
            self.selectedPatient.parentsAndSocial = textView.text;
            self.selectedPatient.parentsAndSocialLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.examinationTextView])
        {
            self.selectedPatient.examination = textView.text;
            self.selectedPatient.examinationLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.summaryTextView])
        {
            self.selectedPatient.summary = textView.text;
            self.selectedPatient.summaryLastEntryDate = [NSDate date];
        }
        else if ([textView isEqual:self.planTextView])
        {
            self.selectedPatient.plan = textView.text;
            self.selectedPatient.planLastEntryDate = [NSDate date];
        }
    }
    
    // ensure text colour is reset to light gray
    textView.textColor = [UIColor grayColor];
    
    // adjust height
    
    // re-check height of a textField filled with updated text
    // check if an update is required
    if (!([self heightForTextView:textView] == heightBeforeChange))
    {
        // update size of textView
        [self setupTextView:textView];
        
        [self.myTableView2 beginUpdates];
        [self.myTableView2 endUpdates];
    }
    
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
//    {
//        // re-check height of a textField filled with updated text
//        // check if an update is required
//        if (!([self heightForTextView:textView] == heightBeforeChange))
//        {
//            // update size of textView
//            [self setupTextView:textView];
//            
//            [self.myTableView2 beginUpdates];
//            [self.myTableView2 endUpdates];
//        }
//    }
//    else
//    {
//        // this was just for playing around with
//        CGFloat adjustment = 0.0f;
//        
//        // get reference to row data
//        HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
//        HandoverRow *row;
//        
//        if (textView.tag == 11)
//        {
//            row = section.rows[1];
//        }
//        else
//        {
//            row = section.rows[0];
//        }
//        
//        // get row height
//        float rowHeight = [row.rowHeight floatValue];
//        
//        // get textView height
//        float contentHeight = textView.contentSize.height;
//        
//        // first check if contentHeight is greater than rowHeight
//        // YES...
//        if ((contentHeight + adjustment) > rowHeight)
//        {
//            // update rowHeight
//            rowHeight = contentHeight;
//            
//            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
//            
//            // update textView frame
//            textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, rowHeight);
//            
//            // update tableView
//            [self.myTableView2 beginUpdates];
//            [self.myTableView2 endUpdates];
//        }
//        // NO...
//        else if ((contentHeight + adjustment) < rowHeight)
//        {
//            if (textView.tag == 19) // special case for last one
//            {
//                if (rowHeight > (346 + adjustment))
//                {
//                    // rowHeight -= (rowHeight - (contentHeight + adjustment));
//                    rowHeight = contentHeight;
//                }
//            }
//            else
//            {
//                rowHeight = contentHeight;
//            }
//            
//            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
//            
//            textView.frame = CGRectMake(5.0f, 0.0f, 310.0f, (rowHeight + adjustment));
//            
//            [self.myTableView2 beginUpdates];
//            [self.myTableView2 endUpdates];
//        }
//        
//        // This is going to be the main code
//        // row.rowText = textView.text;
//    }
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
    [self.delegate DailySummaryViewControllerDidFinish:self];
}

- (void)previousPatientButtonPressed
{
    // load new data in tableView
    newPatientDetails = YES;
    newPatientWeight = YES;
    newPatientBackground = YES;
    newActiveProblems = YES;
    newResolvedProblems = YES;
    newRecentSignificantEvents = YES;
    newVentilationAndSedation = YES;
    newCXR = YES;
    newCardiovascular = YES;
    newHaematology = YES;
    newLines = YES;
    newEchocardiogram = YES;
    newFeedsAndFluids = YES;
    newFluidBalance = YES;
    newBiochemistry = YES;
    newBiliChart = YES;
    newJaundice = YES;
    newSepsis = YES;
    newDrugs = YES;
    newImmunisations = YES;
    newROP = YES;
    newCranialUSS = YES;
    newParentsAndSocial = YES;
    newExamination = YES;
    newSummary = YES;
    newPlan = YES;
    
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
    newPatientWeight = YES;
    newPatientBackground = YES;
    newActiveProblems = YES;
    newResolvedProblems = YES;
    newRecentSignificantEvents = YES;
    newVentilationAndSedation = YES;
    newCXR = YES;
    newCardiovascular = YES;
    newHaematology = YES;
    newLines = YES;
    newEchocardiogram = YES;
    newFeedsAndFluids = YES;
    newFluidBalance = YES;
    newBiochemistry = YES;
    newBiliChart = YES;
    newJaundice = YES;
    newSepsis = YES;
    newDrugs = YES;
    newImmunisations = YES;
    newROP = YES;
    newCranialUSS = YES;
    newParentsAndSocial = YES;
    newExamination = YES;
    newSummary = YES;
    newPlan = YES;
    
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
    
    // shinobi chart
    
    // set gestation for chart
    NSString *plusString;
    
    if (self.selectedPatient.gestation)
    {
        self.gestation = [NSNumber numberWithInt:[self.selectedPatient.gestation intValue]];
        plusString = @"";
        
        if ([self.gestation integerValue] > 38)
        {
            self.gestation = [NSNumber numberWithInteger:38];
            plusString = @"+";
        }
    }
    
    // instantiate array
    if (!self.bilirubinLevelsToPlot)
    {
        self.bilirubinLevelsToPlot = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    // ShinobiChart
    self.chart = nil; // clear memory
    self.chart = [[ShinobiChart alloc] initWithFrame:frame];
    
    if (!self.gestation)
    {
        self.chart.title = NSLocalizedString(@"Chart requires gestation to be entered", nil);
    }
    else
    {
        self.chart.title = [NSString stringWithFormat:@"Infants born at %i%@ weeks gestation", [self.gestation intValue], plusString];
    }
    
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
        self.yAxis.title = NSLocalizedString(@"Total Serum Bilirubin (µmol/L)", nil);
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
        self.yAxis.title = NSLocalizedString(@"Total Serum Bilirubin (µmol/L)", nil);
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

- (void)addTrackBallForUITextView:(UITextView *)textView
{
    
#if UDBARTRACKBALL
    
    [textView setInputAccessoryView:[self trackballAccessoryViewForUITextView:textView]];
    
#endif
    
}

- (void)fingerprintTouched
{
    [self loseFocusOnAllTextViews];
    
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
        
        self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectZero
                                                        title:NSLocalizedString(@"Dictation Commands", nil)
                                                        array:[DictationCommands returnListOfAppleDictationCommands]
                                                  forTextView:nil];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // check if user is using the 3.5 inch screen or 4 inch screen
            if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
            {
                self.modalPanel.frame = CGRectMake(0.0f, 64.0f, 320.0f, 170.0f);
            }
            else
            {
                self.modalPanel.frame = CGRectMake(0.0f, 64.0f, 320.0f, 260.0f);
            }
        }
        else // iOS 5/6
        {
            // check if user is using the 3.5 inch screen or 4 inch screen
            if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
            {
                self.modalPanel.frame = CGRectMake(0.0f, 0.0f, 320.0f, 170.0f);
            }
            else
            {
                self.modalPanel.frame = CGRectMake(0.0f, 0.0f, 320.0f, 260.0f);
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
    
    self.chart = nil;
    newBiliChart = YES;
    
    // reload shinobichart
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    
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

#pragma mark - AddBloodResultTableViewController delegate

- (void)addBloodResultTableViewController:(AddBloodResultTableViewController *)controller didFinishAddingNewSampleData:(NSDictionary *)sampleData
{
    // update display properties
    [self setDisplayValuesForSampleData:sampleData forSectionName:nil];
    
    // check if array exists
    if (!self.selectedPatient.allBloodResultSampleData)
    {
        // instantiate it
        self.selectedPatient.allBloodResultSampleData = [[NSMutableArray alloc] initWithCapacity:25];
    }
    
    // add sample data to selected patient
    [self.selectedPatient.allBloodResultSampleData addObject:sampleData];
    
    // reorder array
    self.selectedPatient.allBloodResultSampleData = [self reorderArrayByDate:self.selectedPatient.allBloodResultSampleData];
    
    // reload table
    [self.myTableView2 reloadData];
    
    // check if a new bilirubin result has been added
    if (![[sampleData objectForKey:@"Unconjugated Bilirubin value (serum)"] isEqualToString:@""])
    {
        Preferences *preferences = [Preferences sharedPreferences];
        
        // ensure birth date has been added
        if (self.selectedPatient.birthDate)
        {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            
            BilirubinResult *biliresult = [BilirubinResult new];
            biliresult.sampleAgeInDays = [NSNumber numberWithDouble:[CBTimeMethods getDaysDifferenceDoubleBetween:self.selectedPatient.birthDate and:[sampleData objectForKey:@"Result Date"]]];
            
            biliresult.bilirubinResult = [formatter numberFromString:[sampleData objectForKey:@"Unconjugated Bilirubin value (serum)"]];
            biliresult.bilirubinUnit = preferences.bilirubinUnits;
            
            // add result to bilirubin chart
            [self phototherapyAddBilirubinResultViewController:nil
                             didFinishAddingNewBilirubinResult:biliresult
                                                  forBirthDate:self.selectedPatient.birthDate];
        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addBloodResultTableViewController:(AddBloodResultTableViewController *)controller didFinishEditingSampleData:(NSDictionary *)sampleData
{
    // update display properties
    [self setDisplayValuesForSampleData:sampleData forSectionName:nil];
    
    // cycle through all blood result sample data and use the unique refence number to replace sampleData
    for (int i = 0; i < [self.selectedPatient.allBloodResultSampleData count]; i++)
    {
        if ([[self.selectedPatient.allBloodResultSampleData[i] objectForKey:@"Unique Reference"] isEqualToNumber:[sampleData objectForKey:@"Unique Reference"]])
        {
            // replace data
            [self.selectedPatient.allBloodResultSampleData replaceObjectAtIndex:i withObject:sampleData];
        }
    }
    
    // reorder array
    self.selectedPatient.allBloodResultSampleData = [self reorderArrayByDate:self.selectedPatient.allBloodResultSampleData];
    
    // reload table
    [self.myTableView2 reloadData];
    
#warning watch out for changes to bilirubin results already plotted!
    
    [self dismissModalViewControllerAnimated:YES];
    
    // deselect row
    [self.myTableView2 deselectRowAtIndexPath:[self.myTableView2 indexPathForSelectedRow] animated:YES];
}

- (void)addBloodResultTableViewController:(AddBloodResultTableViewController *)controller didFinishDeletingSampleData:(NSDictionary *)sampleData
{
    // cycle through all blood result sample data and use the unique refence number to replace sampleData
    for (int i = 0; i < [self.selectedPatient.allBloodResultSampleData count]; i++)
    {
        if ([[self.selectedPatient.allBloodResultSampleData[i] objectForKey:@"Unique Reference"] isEqualToNumber:[sampleData objectForKey:@"Unique Reference"]])
        {
            // delete data
            [self.selectedPatient.allBloodResultSampleData removeObjectAtIndex:i];
        }
    }
    
    // reload table
    [self.myTableView2 reloadData];
    
#warning watch out for changes to bilirubin results already plotted!
    
    [self dismissModalViewControllerAnimated:YES];
    
    // deselect row
    [self.myTableView2 deselectRowAtIndexPath:[self.myTableView2 indexPathForSelectedRow] animated:YES];
}

- (NSMutableArray *)reorderArrayByDate:(NSMutableArray *)allBloodResultsSampleData
{
    NSArray *sortedBloodResultsSampleData = [allBloodResultsSampleData sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                                             {
                                                 NSDate *first = [(NSDictionary *)a objectForKey:@"Result Date"];
                                                 NSDate *second = [(NSDictionary *)b objectForKey:@"Result Date"];
                                                 return [first compare:second];
                                             }];
    
    return [NSMutableArray arrayWithArray:sortedBloodResultsSampleData];
}

- (void)setDisplayValuesForSampleData:(NSDictionary *)sampleData forSectionName:(NSString *)sectionName
{
    // check Haematology
    if ([sectionName isEqualToString:@"Haematology"] || !sectionName)
    {
        // check FBC
        if (![[sampleData objectForKey:@"Haemoglobin value"] isEqualToString:@""] || ![[sampleData objectForKey:@"Total White Cell Count value"] isEqualToString:@""] || ![[sampleData objectForKey:@"Platelet value"] isEqualToString:@""])
        {
            // there are new FBC results to display
            [sampleData setValue:@"YES" forKey:@"Display FBC"];
        }
        // check Clotting
        if (![[sampleData objectForKey:@"Prothrombin Time value"] isEqualToString:@""] || ![[sampleData objectForKey:@"Activated Partial Thromboplatin Time value"] isEqualToString:@""] || ![[sampleData objectForKey:@"Thrombin Time value"] isEqualToString:@""])
        {
            // there are new Clotting results to display
            [sampleData setValue:@"YES" forKey:@"Display Clotting"];
        }
        // check Fibrinogen
        if (![[sampleData objectForKey:@"Fibrinogen value"] isEqualToString:@""])
        {
            // there are new Fibrinogen results to display
            [sampleData setValue:@"YES" forKey:@"Display Fibrinogen"];
        }
    }
    
    // check Biochemistry
    if ([sectionName isEqualToString:@"Biochemistry"] || !sectionName)
    {
        // check U&Es
        if (![[sampleData objectForKey:@"Sodium value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Potassium value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Urea value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Creatinine value (serum)"] isEqualToString:@""])
        {
            // there are new U&E results to display
            [sampleData setValue:@"YES" forKey:@"Display U&Es"];
        }
        // check CRP
        if (![[sampleData objectForKey:@"C Reactive Protein value"] isEqualToString:@""])
        {
            // there is a new CRP result to display
            [sampleData setValue:@"YES" forKey:@"Display CRP"];
        }
        // check LFTs
        // if (![[sampleData objectForKey:@"Alkaline phosphatase value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Alanine Transaminase value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Unconjugated Bilirubin value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"gamma GT value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Albumin value (serum)"] isEqualToString:@""])
        if (![[sampleData objectForKey:@"Alkaline phosphatase value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Alanine Transaminase value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"gamma GT value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Albumin value (serum)"] isEqualToString:@""])
        {
            // there are new LFTs results to display
            [sampleData setValue:@"YES" forKey:@"Display LFTs"];
        }
        // check Conjugated bilirubin
        if (![[sampleData objectForKey:@"Conjugated Bilirubin value (serum)"] isEqualToString:@""])
        {
            // there is a new conjugated bilirubin result to display
            [sampleData setValue:@"YES" forKey:@"Display Conjugated Bilirubin"];
        }
        
        // temp code, as I did not include phosphate initially
        if (![sampleData objectForKey:@"Phosphate value (serum)"])
        {
            [sampleData setValue:@"" forKey:@"Phosphate value (serum)"];
        }
        
        // check Bone profile
        if (![[sampleData objectForKey:@"Calcium value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Adjusted Calcium value (serum)"] isEqualToString:@""] || ![[sampleData objectForKey:@"Phosphate value (serum)"] isEqualToString:@""])
        {
            // there are new Bone profile results to display
            [sampleData setValue:@"YES" forKey:@"Display Bone Profile"];
        }
        // check Magnesium
        if (![[sampleData objectForKey:@"Magnesium value (serum)"] isEqualToString:@""])
        {
            // there is a new Magnesium result to display
            [sampleData setValue:@"YES" forKey:@"Display Magnesium"];
        }
        // check Ammonia
        if (![[sampleData objectForKey:@"Ammonia value (serum)"] isEqualToString:@""])
        {
            // there is a new Ammonia result to display
            [sampleData setValue:@"YES" forKey:@"Display Ammonia"];
        }
    }
    
    if ([sectionName isEqualToString:@"Sepsis"] || !sectionName)
    {
        // check CRP again
        if (![[sampleData objectForKey:@"C Reactive Protein value"] isEqualToString:@""])
        {
            // there is a new CRP result to display
            [sampleData setValue:@"YES" forKey:@"Display CRP"];
        }
    }
}

- (void)addBloodResultTableViewControllerDidCancel:(AddBloodResultTableViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    // deselect row
    [self.myTableView2 deselectRowAtIndexPath:[self.myTableView2 indexPathForSelectedRow] animated:YES];
}

- (NSArray *)getHaematologyResultsToDisplay
{
    // instantiate array
    NSMutableArray *haematologyResultsToDisplay = [[NSMutableArray alloc] initWithCapacity:[self.selectedPatient.allBloodResultSampleData count]];
    
    NSDictionary *sampleData;
    
    // cycle through all selected patient's sampledata
    for (sampleData in self.selectedPatient.allBloodResultSampleData)
    {
        // check FBC
        if ([[sampleData objectForKey:@"Display FBC"] isEqualToString:@"YES"])
        {
            NSArray *FBCResult = @[@"FBC Result", [sampleData objectForKey:@"Haemoglobin value"], [sampleData objectForKey:@"Total White Cell Count value"], [sampleData objectForKey:@"Platelet value"], [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [haematologyResultsToDisplay addObject:FBCResult];
        }
        
        // check Clotting
        if ([[sampleData objectForKey:@"Display Clotting"] isEqualToString:@"YES"])
        {
            NSArray *ClottingResult = @[@"Clotting Result", [sampleData objectForKey:@"Prothrombin Time value"], [sampleData objectForKey:@"Activated Partial Thromboplatin Time value"], [sampleData objectForKey:@"Thrombin Time value"], [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [haematologyResultsToDisplay addObject:ClottingResult];
        }
        
        // check Fibrinogen
        if ([[sampleData objectForKey:@"Display Fibrinogen"] isEqualToString:@"YES"])
        {
            NSArray *FibrinogenResult = @[@"Fibrinogen Result", [sampleData objectForKey:@"Fibrinogen value"], @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [haematologyResultsToDisplay addObject:FibrinogenResult];
        }
    }
    
    return haematologyResultsToDisplay;
}

- (NSArray *)getBiochemistryResultsToDisplay
{
    // instantiate array
    NSMutableArray *biochemistryResultsToDisplay = [[NSMutableArray alloc] initWithCapacity:[self.selectedPatient.allBloodResultSampleData count]];
    
    NSDictionary *sampleData;
    
    // cycle through all selected patient's sampledata
    for (sampleData in self.selectedPatient.allBloodResultSampleData)
    {
        // check U&Es
        if ([[sampleData objectForKey:@"Display U&Es"] isEqualToString:@"YES"])
        {
            NSArray *UEsResult = @[@"U&Es Result", [sampleData objectForKey:@"Sodium value (serum)"], [sampleData objectForKey:@"Potassium value (serum)"], [sampleData objectForKey:@"Urea value (serum)"], [sampleData objectForKey:@"Creatinine value (serum)"], @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:UEsResult];
        }
        
        // check LFTs
        if ([[sampleData objectForKey:@"Display LFTs"] isEqualToString:@"YES"])
        {
            NSArray *LFTsResult = @[@"LFT Result", [sampleData objectForKey:@"Alkaline phosphatase value (serum)"], [sampleData objectForKey:@"Alanine Transaminase value (serum)"], [sampleData objectForKey:@"Unconjugated Bilirubin value (serum)"], [sampleData objectForKey:@"gamma GT value (serum)"], [sampleData objectForKey:@"Albumin value (serum)"], [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:LFTsResult];
        }
        
        // check Conjugated bilirubin
        if ([[sampleData objectForKey:@"Display Conjugated Bilirubin"] isEqualToString:@"YES"])
        {
            NSArray *ConjugatedBilirubinResult = @[@"Conjugated Bilirubin Result", [sampleData objectForKey:@"Conjugated Bilirubin value (serum)"], @"", @"", @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:ConjugatedBilirubinResult];
        }
        
        // check Bone profile
        if ([[sampleData objectForKey:@"Display Bone Profile"] isEqualToString:@"YES"])
        {
            NSLog(@"Phosphate value (serum) value = %@", [sampleData objectForKey:@"Phosphate value (serum)"]);
            
            NSArray *BoneProfileResult = @[@"Bone Profile Result", [sampleData objectForKey:@"Calcium value (serum)"], [sampleData objectForKey:@"Adjusted Calcium value (serum)"], [sampleData objectForKey:@"Phosphate value (serum)"], @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:BoneProfileResult];
        }
        
        // check Magnesium
        if ([[sampleData objectForKey:@"Display Magnesium"] isEqualToString:@"YES"])
        {
            NSArray *MagnesiumResult = @[@"Magnesium Result", [sampleData objectForKey:@"Magnesium value (serum)"], @"", @"", @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:MagnesiumResult];
        }
        
        // check Ammonia
        if ([[sampleData objectForKey:@"Display Ammonia"] isEqualToString:@"YES"])
        {
            NSArray *AmmoniaResult = @[@"Ammonia Result", [sampleData objectForKey:@"Ammonia value (serum)"], @"", @"", @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [biochemistryResultsToDisplay addObject:AmmoniaResult];
        }
    }
    
    // set background colors array
    
    // set first color
    biochemistryResultsBackroundColors[0] = @0; // @0 = clear ; @1 = highlighted
    
    NSNumber *toggle = @0;
    
    for (int i = 1; i < biochemistryResultsToDisplay.count; i++)
    {
        if ([biochemistryResultsToDisplay[i][7] intValue] == [biochemistryResultsToDisplay[i - 1][7] intValue])
        {
            biochemistryResultsBackroundColors[i-1] = toggle;
            biochemistryResultsBackroundColors[i] = toggle;
        }
        else
        {
            if ([toggle isEqualToNumber:@0])
            {
                toggle = @1;
            }
            else
            {
                toggle = @0;
            }
            
            biochemistryResultsBackroundColors[i] = toggle;
        }
    }
    
    // ensure last set of results is darkened
    if (!(biochemistryResultsBackroundColors.count % 2))
    {
        for (int i = 0; i < biochemistryResultsBackroundColors.count; i++)
        {
            if ([biochemistryResultsBackroundColors[i] isEqualToNumber:@0])
            {
                biochemistryResultsBackroundColors[i] = @1;
            }
            else
            {
                biochemistryResultsBackroundColors[i] = @0;
            }
        }
    }
    
    return biochemistryResultsToDisplay;
}

- (NSArray *)getCRPResultsToDisplay
{
    // instantiate array
    NSMutableArray *crpResultsToDisplay = [[NSMutableArray alloc] initWithCapacity:[self.selectedPatient.allBloodResultSampleData count]];
    
    NSDictionary *sampleData;
    
    // cycle through all selected patient's sampledata
    for (sampleData in self.selectedPatient.allBloodResultSampleData)
    {
        // check CRP
        if ([[sampleData objectForKey:@"Display CRP"] isEqualToString:@"YES"])
        {
            NSArray *CRPResult = @[@"CRP Result", [sampleData objectForKey:@"C Reactive Protein value"], @"", @"", @"", @"", [sampleData objectForKey:@"Result Date"], [sampleData objectForKey:@"Unique Reference"]];
            
            [crpResultsToDisplay addObject:CRPResult];
        }
    }
    
    return crpResultsToDisplay;
}

#pragma mark - FluidBalanceTableViewController delegate

- (void)fluidBalanceTableViewController:(FluidBalanceTableViewController *)controller didFinishAddingNewData:(NSMutableDictionary *)fluidBalanceData
{
    // turn off editing
    [self setEditing:NO animated:NO];
    
    // if selected patient fluid balance array has not been instantiated, then instantiate it
    if (!self.selectedPatient.allFluidBalanceData)
    {
        self.selectedPatient.allFluidBalanceData = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    // ensure all previous data will be shown minimized
    for (NSMutableDictionary *fluidBalanceData in self.selectedPatient.allFluidBalanceData)
    {
        fluidBalanceData[@"ShowMinimized"] = [NSNumber numberWithBool:YES];
    }
    
    // add new data to array
    [self.selectedPatient.allFluidBalanceData addObject:fluidBalanceData];
    
    // sort data by date
    [self reorderFluidBalanceResultsDataByDate:self.selectedPatient.allFluidBalanceData];
    
    // reload table
    [self.myTableView2 reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)fluidBalanceTableViewControllerDidCancel:(FluidBalanceTableViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

// reorder fluid balance data by @"FluidBalanceDate"
- (NSMutableArray *)reorderFluidBalanceResultsDataByDate:(NSMutableArray *)allFluidBalanceResultsData
{
    NSArray *sortedFluidBalanceResultsData = [allFluidBalanceResultsData sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                                              {
                                                  NSDate *first = [(NSDictionary *)a objectForKey:@"FluidBalanceDate"];
                                                  NSDate *second = [(NSDictionary *)b objectForKey:@"FluidBalanceDate"];
                                                  return [first compare:second];
                                              }];
    
    return [NSMutableArray arrayWithArray:sortedFluidBalanceResultsData];
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
        formattedText = [NSString stringWithFormat:@"Mother: %@\nBaby: %@\nDCT: %@\n\n%@", maternalBloodGroupFormatted, babyBloodGroupFormatted, dctFormatted, self.selectedPatient.jaundice];
    }
    else
    {
        // fill the UITextView with new textman
        formattedText = [NSString stringWithFormat:@"Mother: %@\nBaby: %@\nDCT: %@",maternalBloodGroupFormatted, babyBloodGroupFormatted, dctFormatted];
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

#pragma mark - VascularLinesTableViewController delegate

- (void)vascularLinesTableViewControllerDidFinish:(VascularLinesTableViewController *)controller withResults:(NSMutableArray *)results
{
    // dismiss modal
    [self dismissModalViewControllerAnimated:YES];
}

- (void)vascularLinesTableViewControllerDidCancel:(VascularLinesTableViewController *)controller
{
    // dismiss modal
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
    CBBarCustomTextItem *customText1 = [[CBBarCustomTextItem alloc] initForTextView:textView withButtonText:NSLocalizedString(@"done", nil)
                                                              insertingTextViewText:@""];
    customText1.delegate = self;
    
    // create right custom text button
    CBBarCustomTextItem *customText2 = [[CBBarCustomTextItem alloc] initForTextView:textView withButtonText:NSLocalizedString(@"custom", nil)
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
    if ([sender.buttonText isEqualToString:NSLocalizedString(@"done", nil)])
    {
        // close modal
        [self.modalPanel closePressed:nil];
        
        // close keyboard
        [textView resignFirstResponder];
    }
    else if ([sender.buttonText isEqualToString:NSLocalizedString(@"custom", nil)])
    {
        if (!self.modalPanel)
        {
            // get array
            Preferences *preferences = [Preferences sharedPreferences];
            
            int handoverSection = [self getUserDefinedSectionForTextView:textView];
            
            HandoverSection *section = preferences.handoverSections[handoverSection];
            
            
            // setup modal
            
            // delegate
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            // iOS 7 specifics
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                // instead, check if user is using the 3.5 inch screen or 4 inch screen
                if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 170.0f)
                                                                    title:NSLocalizedString(@"Custom text", @"i.e. user customisable text")
                                                                    array:section.customText
                                                              forTextView:textView];
                }
                else
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, 260.0f)
                                                                    title:NSLocalizedString(@"Custom text", @"i.e. user customisable text")
                                                                    array:section.customText
                                                              forTextView:textView];
                }
            }
            else
            {
                // instead, check if user is using the 3.5 inch screen or 4 inch screen
                if (appDelegate.window.bounds.size.height == 480) // 3.5 inch Retina
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 170.0f)
                                                                    title:NSLocalizedString(@"Custom text", @"i.e. user customisable text")
                                                                    array:section.customText
                                                              forTextView:textView];
                }
                else
                {
                    self.modalPanel = [[CBModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 260.0f)
                                                                    title:NSLocalizedString(@"Custom text", @"i.e. user customisable text")
                                                                    array:section.customText
                                                              forTextView:textView];
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

#pragma mark - JLActionSheet delegate

- (void)actionSheet:(JLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Haematology
    if (actionSheet.tag == 0)
    {
        // add blood results
        if (buttonIndex == 2)
        {
            // Add new results
            AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.bloodResultOrder = @"Haematology First";
            vc.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
            
            [self setupAndPresentModalNavController:navController];
        }
        else if (buttonIndex == 1)
        {
            // Show hidden results
            NSDictionary *sampleData;
            
            // cycle through all selected patient's sampledata
            for (sampleData in self.selectedPatient.allBloodResultSampleData)
            {
                // check for FBC/Clotting/Fibrinogen results
                [self setDisplayValuesForSampleData:sampleData forSectionName:@"Haematology"];
            }
            
            // update Haematology section
            [self updateHandoverSection:@"Haematology"];
        }
    }
    // Biochemistry
    else if (actionSheet.tag == 1)
    {
        // add blood results
        if (buttonIndex == 2)
        {
            AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.bloodResultOrder = @"Biochemistry First";
            vc.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
            
            [self setupAndPresentModalNavController:navController];
        }
        else if (buttonIndex == 1)
        {
            // Show hidden results
            NSDictionary *sampleData;
            
            // cycle through all selected patient's sampledata
            for (sampleData in self.selectedPatient.allBloodResultSampleData)
            {
                // check for Biochemistry data
                [self setDisplayValuesForSampleData:sampleData forSectionName:@"Biochemistry"];
            }
            
            // update Biochemistry section
            [self updateHandoverSection:@"Biochemistry"];
        }
    }
    else if (actionSheet.tag == 2)
    {
        // add blood results
        if (buttonIndex == 2)
        {
            AddBloodResultTableViewController *vc = [[AddBloodResultTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.bloodResultOrder = @"Sepsis First";
            vc.delegate = self;
            
            PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:vc];
            
            [self setupAndPresentModalNavController:navController];
        }
        else if (buttonIndex == 1)
        {
            // Show hidden results
            NSDictionary *sampleData;
            
            // cycle through all selected patient's sampledata
            for (sampleData in self.selectedPatient.allBloodResultSampleData)
            {
                // check for CRP results
                [self setDisplayValuesForSampleData:sampleData forSectionName:@"Sepsis"];
            }
            
            // update Sepsis section
            [self updateHandoverSection:@"Sepsis"];
        }
    }
}

- (void)updateHandoverSection:(NSString *)handoverSection
{
    // find section reference
    Preferences *preferences = [Preferences sharedPreferences];
    
    for (int i = 0; i < preferences.handoverSections.count; i++)
    {
        HandoverSection *section = preferences.handoverSections[i];
        
        if ([section.sectionName isEqualToString:handoverSection])
        {
            // reload section
            [self.myTableView2 reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    // turn off editing
    self.editing = !self.editing;
}

- (void)actionSheet:(JLActionSheet *)actionSheet didDismissButtonAtIndex:(NSInteger)buttonIndex
{
    // do nothing
}

@end
