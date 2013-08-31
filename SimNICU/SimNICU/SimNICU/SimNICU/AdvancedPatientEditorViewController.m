//
//  AdvancedPatientEditorViewController.m
//  SimNICU
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
#import "CBTableViewRowData.h"
// #import "ShinobiChartCell.h"
#import "BilirubinResult.h"
#import "HandoverSection.h"
#import "CBTimeMethods.h"
#import "HandoverRow.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

@interface AdvancedPatientEditorViewController () <UITableViewDataSource, UITableViewDelegate, SChartDatasource, SChartDelegate, UITextViewDelegate, UIScrollViewDelegate, patientDetailsViewControllerDelegate, PhototherapyAddBilirubinResultViewControllerDelegate, JaundiceViewControllerDelegate>
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
    BOOL newDCTInfo;
    BOOL newSepsis;
    BOOL newDrugs;
    BOOL newROP;
    BOOL newCranialUSS;
    BOOL newParentsAndSocial;
    BOOL newImpression;
    BOOL newPlan;
    BOOL newJobs;
    
    BOOL firstButtonPressSinceScroll; // used to line up sections when pressing fast forward
    
    NSMutableArray *tableView2Sections;
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
@property (nonatomic, strong) NSString *guidelineCountry;
@property (nonatomic, strong) NSString *bilirubinUnits;
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

@end

@implementation AdvancedPatientEditorViewController

// things I need to still do
//
// 1) query preferences to set self.guidelineCountry & self.bilirubinUnits
// 2) 
// 3) use edit data to allow edits
// 
// 4) add analytics
// 5) create a weight shinobi chart
// 6) dateAndTimeForThisChart thing for ShinobiChart
//
// 7) 
// 8)

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
    
    self.guidelineCountry = @"UK";
    self.bilirubinUnits = @"SI";  // change this later...
    portraitOrientationDefaultsSet = YES;
	
    // self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
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
    
    // self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.toolbar.tintColor = [UIColor grayColor];
    
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
    
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    // sections
    tableView2Sections = [[NSMutableArray alloc] initWithCapacity:12];
    tableView2Sections = [self loadSectionDataForPatientEditing:self.editing]; // don't think I actually need this array
    
    [self loadShinobiChartWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    /*
    self.shinobiCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Phototherapy"];
    self.shinobiCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.shinobiCell addSubview:self.chart];
     */
    
    // tableViews
    self.myTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 92.0f) style:UITableViewStylePlain];
    self.myTableView1.rowHeight = 44.0f;
    self.myTableView1.dataSource = self;
    self.myTableView1.delegate = self;
    self.myTableView1.sectionFooterHeight = 10.0f;
    self.myTableView1.sectionHeaderHeight = 10.0f;
    self.myTableView1.separatorColor = [UIColor grayColor];
    self.myTableView1.bounces = NO;
    self.myTableView1.userInteractionEnabled = YES;
    [self.view addSubview:self.myTableView1];
    
    self.myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 92.0f, 320.0f, (appDelegate.window.bounds.size.height - 44.0f - 156.0f)) style:UITableViewStylePlain];
    self.myTableView2.rowHeight = 44.0f;
    self.myTableView2.dataSource = self;
    self.myTableView2.delegate = self;
    self.myTableView2.sectionFooterHeight = 10.0f;
    self.myTableView2.sectionHeaderHeight = 10.0f;
    self.myTableView2.separatorColor = [UIColor grayColor];
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
    if  ([tableView isEqual:self.myTableView1])
    {
        return 1;
    }
    else
    {
        return [tableView2Sections count];
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
    
    if ([tableView isEqual:self.myTableView1])
    {
        returnString = @"Patient";
    }
    else
    {
        returnString = tableView2Sections[section];
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
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
        HandoverSection *section = self.selectedPatient.handoverSections[indexPath.section];
        
        HandoverRow *row = section.rows[indexPath.row];
        
        height = [row.rowHeight floatValue];
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
        if ([tableView2Sections[indexPath.section] isEqual:@"Background"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Active Problems"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Resolved Problems"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Recent Significant Events"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Ventilation & Sedation"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"CXR"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Cardiovascular"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Lines"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Feeds & Fluids"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Fluid Balance"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Biochemistry"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Jaundice"])
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
                CellIdentifier = @"DCTInfo";
                
                if (newDCTInfo)
                {
                    cell = [self formatCellForTableWithCellIdentifier:CellIdentifier];
                    
                    newDCTInfo = NO;
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
        else if ([tableView2Sections[indexPath.section] isEqual:@"Sepsis"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Drugs"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"ROP"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Neurology & Cranial USS"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Parents / Social"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Examination"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Summary"])
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
        }
        else if ([tableView2Sections[indexPath.section] isEqual:@"Plan"])
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
        UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 22.0f)];
        displayTextLabel.textColor = [UIColor blackColor];
        displayTextLabel.backgroundColor = [UIColor clearColor];
        displayTextLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        displayTextLabel.adjustsFontSizeToFitWidth = YES;
        displayTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayTextLabel];
        
        UILabel *displayAgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 23.0f, 300.0f, 22.0f)];
        displayAgeTextLabel.textColor = [UIColor grayColor];
        displayAgeTextLabel.backgroundColor = [UIColor clearColor];
        displayAgeTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayAgeTextLabel.adjustsFontSizeToFitWidth = NO;
        displayAgeTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayAgeTextLabel];
        
        //displayDetailTextLabel (Gestation, birth weight, corrected gestation and working weight)
        UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 44.0f, 300.0f, 22.0f)];
        displayDetailTextLabel.textColor = [UIColor grayColor];
        displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        displayDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayDetailTextLabel.adjustsFontSizeToFitWidth = NO;
        displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        [cell.contentView addSubview:displayDetailTextLabel];
        
        // display patient's name
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
        
        // display gestation and corrected gestation, birth weight and working weight
        displayDetailTextLabel.text = [self.selectedPatient returnTwoLineDetailDisplayLabelText];
        
        
        if (self.selectedPatient.birthDate)
        {
            NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.selectedPatient.birthDate and:[NSDate date]];
            
            NSString *correctedAge = formattedDates[2];
            
            // display days and corrected age
            displayAgeTextLabel.text = [NSString stringWithFormat:@"day %i (%@)", [CBTimeMethods getDaysDifferenceIntBetween:self.selectedPatient.birthDate and:[NSDate date]], correctedAge];
        }
    }
#pragma mark Background
    else if ([CellIdentifier isEqualToString:@"Background"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[0];
        HandoverRow *row = section.rows[0];
        
        self.backgroundTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.backgroundTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.backgroundTextView.delegate = self;
        self.backgroundTextView.tag = 0;
        
        [cell.contentView addSubview:self.backgroundTextView];
    }
#pragma mark Active Problems
    else if ([CellIdentifier isEqualToString:@"ActiveProblems"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[1];
        HandoverRow *row = section.rows[0];
        
        self.activeProblemsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.activeProblemsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.activeProblemsTextView.delegate = self;
        self.activeProblemsTextView.tag = 1;
        
        [cell.contentView addSubview:self.activeProblemsTextView];
    }
#pragma mark Resolved Problems
    else if ([CellIdentifier isEqualToString:@"ResolvedProblems"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[2];
        HandoverRow *row = section.rows[0];
        
        self.resolvedProblemsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.resolvedProblemsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.resolvedProblemsTextView.delegate = self;
        self.resolvedProblemsTextView.tag = 2;
        
        [cell.contentView addSubview:self.resolvedProblemsTextView];
    }
#pragma mark Recent Significant Events
    else if ([CellIdentifier isEqualToString:@"RecentSignificantEvents"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[3];
        HandoverRow *row = section.rows[0];
        
        self.recentSignificantEventsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.recentSignificantEventsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.recentSignificantEventsTextView.delegate = self;
        self.recentSignificantEventsTextView.tag = 3;
        
        [cell.contentView addSubview:self.recentSignificantEventsTextView];
    }
#pragma mark Ventilation & Sedation
    else if ([CellIdentifier isEqualToString:@"VentilationAndSedation"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[4];
        HandoverRow *row = section.rows[0];
        
        self.ventilationAndSedationTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.ventilationAndSedationTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.ventilationAndSedationTextView.delegate = self;
        self.ventilationAndSedationTextView.tag = 4;
        
        [cell.contentView addSubview:self.ventilationAndSedationTextView];
    }
#pragma mark CXR
    else if ([CellIdentifier isEqualToString:@"CXR"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[5];
        HandoverRow *row = section.rows[0];
        
        self.cxrTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.cxrTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.cxrTextView.delegate = self;
        self.cxrTextView.tag = 5;
        
        [cell.contentView addSubview:self.cxrTextView];
    }
#pragma mark Cardiovascular
    else if ([CellIdentifier isEqualToString:@"Cardiovascular"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[6];
        HandoverRow *row = section.rows[0];
        
        self.cardiovascularTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.cardiovascularTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.cardiovascularTextView.delegate = self;
        self.cardiovascularTextView.tag = 6;
        
        [cell.contentView addSubview:self.cardiovascularTextView];
    }
#pragma mark Lines
    else if ([CellIdentifier isEqualToString:@"Lines"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[7];
        HandoverRow *row = section.rows[0];
        
        self.linesTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.linesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.linesTextView.delegate = self;
        self.linesTextView.tag = 7;
        
        [cell.contentView addSubview:self.linesTextView];
    }
#pragma mark Feeds & Fluids
    else if ([CellIdentifier isEqualToString:@"FeedsAndFluids"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[8];
        HandoverRow *row = section.rows[0];
        
        self.feedsAndFluidsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.feedsAndFluidsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.feedsAndFluidsTextView.delegate = self;
        self.feedsAndFluidsTextView.tag = 8;
        
        [cell.contentView addSubview:self.feedsAndFluidsTextView];
    }
#pragma mark Fluid Balance
    else if ([CellIdentifier isEqualToString:@"FluidBalance"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[9];
        HandoverRow *row = section.rows[0];
        
        self.fluidBalanceTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.fluidBalanceTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.fluidBalanceTextView.delegate = self;
        self.fluidBalanceTextView.tag = 9;
        
        [cell.contentView addSubview:self.fluidBalanceTextView];
    }
#pragma mark Biochemistry
    else if ([CellIdentifier isEqualToString:@"Biochemistry"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[10];
        HandoverRow *row = section.rows[0];
        
        self.electrolytesTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.electrolytesTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.electrolytesTextView.delegate = self;
        self.electrolytesTextView.tag = 10;
        
        [cell.contentView addSubview:self.electrolytesTextView];
    }
#pragma mark Jaundice/Phototherapy
    else if ([CellIdentifier isEqualToString:@"Phototherapy"])
    {
        // self.chart.bounds = cell.bounds;
        [cell addSubview:self.chart];
        
        self.shinobiChartImage = [[UIImage alloc] init];
        
        UIGraphicsBeginImageContext(self.chart.bounds.size);
        
        [self.chart.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        self.shinobiChartImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        /*
        UIGraphicsBeginImageContext(self.chart.bounds.size);
        [self.chart.layer renderInContext:UIGraphicsGetCurrentContext()];
        self.shinobiChartImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
         */
    }
#pragma mark Jaundice/DCT
    else if ([CellIdentifier isEqualToString:@"DCTInfo"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[11];
        HandoverRow *row = section.rows[1];
        
        self.jaundiceTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.jaundiceTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.jaundiceTextView.delegate = self;
        self.jaundiceTextView.tag = 11;
        
        [cell.contentView addSubview:self.jaundiceTextView];
    }
#pragma mark Sepsis
    else if ([CellIdentifier isEqualToString:@"Sepsis"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[12];
        HandoverRow *row = section.rows[0];
        
        self.sepsisTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.sepsisTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.sepsisTextView.delegate = self;
        self.sepsisTextView.tag = 12;
        
        [cell.contentView addSubview:self.sepsisTextView];
    }
#pragma mark Drugs
    else if ([CellIdentifier isEqualToString:@"Drugs"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[13];
        HandoverRow *row = section.rows[0];
        
        self.drugsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.drugsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.drugsTextView.delegate = self;
        self.drugsTextView.tag = 13;
        
        [cell.contentView addSubview:self.drugsTextView];
    }
#pragma mark ROP
    else if ([CellIdentifier isEqualToString:@"ROP"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[14];
        HandoverRow *row = section.rows[0];
        
        self.ropTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.ropTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.ropTextView.delegate = self;
        self.ropTextView.tag = 14;
        
        [cell.contentView addSubview:self.ropTextView];
    }
#pragma mark Cranial USS
    else if ([CellIdentifier isEqualToString:@"NeurologyAndCranialUSS"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[15];
        HandoverRow *row = section.rows[0];
        
        self.cranialUSSTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.cranialUSSTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.cranialUSSTextView.delegate = self;
        self.cranialUSSTextView.tag = 15;
        
        [cell.contentView addSubview:self.cranialUSSTextView];
    }
#pragma mark Parents / Social
    else if ([CellIdentifier isEqualToString:@"ParentsSocial"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[16];
        HandoverRow *row = section.rows[0];
        
        self.parentsAndSocialTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.parentsAndSocialTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.parentsAndSocialTextView.delegate = self;
        self.parentsAndSocialTextView.tag = 16;
        
        [cell.contentView addSubview:self.parentsAndSocialTextView];
    }
#pragma mark Examination
    else if ([CellIdentifier isEqualToString:@"Examination"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[17];
        HandoverRow *row = section.rows[0];
        
        self.impressionTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.impressionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.impressionTextView.delegate = self;
        self.impressionTextView.tag = 17;
        
        [cell.contentView addSubview:self.impressionTextView];
    }
#pragma mark Summary
    else if ([CellIdentifier isEqualToString:@"Summary"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[18];
        HandoverRow *row = section.rows[0];
        
        self.planTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.planTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.planTextView.delegate = self;
        self.planTextView.tag = 18;
        
        [cell.contentView addSubview:self.planTextView];
    }
#pragma mark Plan
    else if ([CellIdentifier isEqualToString:@"Plan"])
    {
        HandoverSection *section = self.selectedPatient.handoverSections[19];
        HandoverRow *row = section.rows[0];
        
        self.jobsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 310.0f, [row.rowHeight floatValue])];
        self.jobsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        self.jobsTextView.delegate = self;
        self.jobsTextView.tag = 19;
        
        [cell.contentView addSubview:self.jobsTextView];
    }
    
    return cell;
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
    
    if ([tableView isEqual:self.myTableView1])
    {
        editingStyle = UITableViewCellEditingStyleInsert;
    }
    else if ([tableView isEqual:self.myTableView2])
    {
        if ([tableView2Sections[indexPath.section] isEqual:@"Jaundice"])
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
        
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        navController.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentModalViewController:navController animated:YES];
    }
    else
    {
        // Jaundice
        if (indexPath.section == 11)
        {
            if (indexPath.row == 0)
            {
                // allow user to enter a bilirubin result for the selected patient
                PhototherapyAddBilirubinResultViewController *newViewController = [[PhototherapyAddBilirubinResultViewController alloc] init];
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.bilirubinUnits = self.bilirubinUnits;
                newViewController.delegate = self;
                
                /*
                if (self.dateAndTimeOfBirthForThisChart)
                {
                    newViewController.dateAndTimeOfBirthForThisChart = self.dateAndTimeOfBirthForThisChart;
                }
                 */
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
                
                navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                navController.navigationBar.tintColor = [UIColor blackColor];
                
                [self presentModalViewController:navController animated:YES];
            }
            else
            {
                // Blood Group Info
                JaundiceViewController *newViewController = [[JaundiceViewController alloc] init];
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.delegate = self;
                
                PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
                
                navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                navController.navigationBar.tintColor = [UIColor blackColor];
                
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
}

- (void)textViewDidChange:(UITextView *)textView
{
    HandoverSection *section;;
    HandoverRow *row;
    
    if ([textView isEqual:self.backgroundTextView])
    {
        section = self.selectedPatient.handoverSections[0];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.backgroundTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.backgroundTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.backgroundTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.backgroundTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.background = textView.text;
    }
    else if ([textView isEqual:self.activeProblemsTextView])
    {
        section = self.selectedPatient.handoverSections[1];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.activeProblemsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.activeProblemsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.activeProblemsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.activeProblemsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.activeProblems = textView.text;
    }
    else if ([textView isEqual:self.resolvedProblemsTextView])
    {
        section = self.selectedPatient.handoverSections[2];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.resolvedProblemsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.resolvedProblemsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.resolvedProblemsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.resolvedProblemsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.resolvedProblems = textView.text;
    }
    else if ([textView isEqual:self.recentSignificantEventsTextView])
    {
        section = self.selectedPatient.handoverSections[3];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.recentSignificantEventsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.recentSignificantEventsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.recentSignificantEventsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.recentSignificantEventsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.recentSignificantEvents = textView.text;
    }
    else if ([textView isEqual:self.ventilationAndSedationTextView])
    {
        section = self.selectedPatient.handoverSections[4];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.ventilationAndSedationTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.ventilationAndSedationTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.ventilationAndSedationTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.ventilationAndSedationTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.ventilationAndSedation = textView.text;
    }
    else if ([textView isEqual:self.cxrTextView])
    {
        section = self.selectedPatient.handoverSections[5];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cxrTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cxrTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cxrTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cxrTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.cxr = textView.text;
    }
    else if ([textView isEqual:self.cardiovascularTextView])
    {
        section = self.selectedPatient.handoverSections[6];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cardiovascularTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cardiovascularTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cardiovascularTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cardiovascularTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.cardiovascular = textView.text;
    }
    else if ([textView isEqual:self.linesTextView])
    {
        section = self.selectedPatient.handoverSections[7];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.linesTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.linesTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.linesTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.linesTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.lines = textView.text;
    }
    else if ([textView isEqual:self.feedsAndFluidsTextView])
    {
        section = self.selectedPatient.handoverSections[8];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.feedsAndFluidsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.feedsAndFluidsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.feedsAndFluidsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.feedsAndFluidsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.feedsAndFluids = textView.text;
    }
    else if ([textView isEqual:self.fluidBalanceTextView])
    {
        section = self.selectedPatient.handoverSections[9];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.fluidBalanceTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.fluidBalanceTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.fluidBalanceTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.fluidBalanceTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.fluidBalance = textView.text;
    }
    else if ([textView isEqual:self.electrolytesTextView])
    {
        section = self.selectedPatient.handoverSections[10];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.electrolytesTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.electrolytesTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.electrolytesTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.electrolytesTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.electrolytes = textView.text;
    }
    else if ([textView isEqual:self.jaundiceTextView])
    {
        section = self.selectedPatient.handoverSections[11];
        row = section.rows[1];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.jaundiceTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.jaundiceTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.jaundiceTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.jaundiceTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.jaundice = textView.text;
    }
    else if ([textView isEqual:self.sepsisTextView])
    {
        section = self.selectedPatient.handoverSections[12];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.sepsisTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.sepsisTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.sepsisTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.sepsisTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.sepsis = textView.text;
    }
    else if ([textView isEqual:self.drugsTextView])
    {
        section = self.selectedPatient.handoverSections[13];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.drugsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.drugsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.drugsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.drugsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.drugs = textView.text;
    }
    else if ([textView isEqual:self.ropTextView])
    {
        section = self.selectedPatient.handoverSections[14];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.ropTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.ropTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.ropTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.ropTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.rop = textView.text;
    }
    else if ([textView isEqual:self.cranialUSSTextView])
    {
        section = self.selectedPatient.handoverSections[15];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cranialUSSTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cranialUSSTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.cranialUSSTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.cranialUSSTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.cranialUSS = textView.text;
    }
    else if ([textView isEqual:self.parentsAndSocialTextView])
    {
        section = self.selectedPatient.handoverSections[16];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.parentsAndSocialTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.parentsAndSocialTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.parentsAndSocialTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.parentsAndSocialTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.parentsAndSocial = textView.text;
    }
    else if ([textView isEqual:self.impressionTextView])
    {
        section = self.selectedPatient.handoverSections[17];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.impressionTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.impressionTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.impressionTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.impressionTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.impression = textView.text;
    }
    else if ([textView isEqual:self.planTextView])
    {
        section = self.selectedPatient.handoverSections[18];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.planTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.planTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            rowHeight -= (rowHeight - (contentHeight + 5.0f));
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.planTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.planTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.plan = textView.text;
    }
    else if ([textView isEqual:self.jobsTextView])
    {
        section = self.selectedPatient.handoverSections[19];
        row = section.rows[0];
        
        float rowHeight = [row.rowHeight floatValue];
        float contentHeight = textView.contentSize.height;
        
        if ((contentHeight + 5.0f) > rowHeight)
        {
            rowHeight += ((contentHeight + 5.0f) - rowHeight);
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.jobsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.jobsTextView.contentSize.height + 10.0f));
        }
        else if ((contentHeight + 5.0f) < rowHeight)
        {
            if (rowHeight > 250.0f)
            {
                rowHeight -= (rowHeight - (contentHeight + 5.0f));
            }
            
            row.rowHeight = [NSNumber numberWithFloat:rowHeight];
            
            [self.myTableView2 beginUpdates];
            [self.myTableView2 endUpdates];
            
            self.jobsTextView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (self.jobsTextView.contentSize.height + 10.0f));
        }
        
        self.selectedPatient.jobs = textView.text;
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
    [self dismissModalViewControllerAnimated:YES];
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
    newDCTInfo = YES;
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

    [self.myTableView2 scrollToRowAtIndexPath:indexPathForLastRow atScrollPosition:UITableViewScrollPositionTop animated:YES];;
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
    newDCTInfo = YES;
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
    NSLog(@"Frame.origin.x = %f", frame.origin.x);
    NSLog(@"Frame.origin.y = %f", frame.origin.y);
    NSLog(@"Frame.size.width = %f", frame.size.width);
    NSLog(@"Frame.size.height = %f", frame.size.height);
    
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
    
    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
    else if ([self.bilirubinUnits isEqualToString:@"US"])
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
        if ([self.bilirubinUnits isEqualToString:@"SI"])
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
        newRow.rowHeight = [NSNumber numberWithFloat:250.0f];
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

#pragma mark - ShinobiChart datasource

// Returns the number of series in the specified chart
- (int)numberOfSeriesInSChart:(ShinobiChart *)chart
{
    int numberOfSeries = 0;
    
    // check if gestation has been set
    if (self.selectedPatient.gestation)
    {
        if ([self.guidelineCountry isEqualToString:@"US"])
        {
            // could implement a conditional statement if user want UK style for US or risk factor lines...
            
            numberOfSeries = 3;
        }
        if ([self.guidelineCountry isEqualToString:@"UK"])
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
    
    if ([self.guidelineCountry isEqualToString:@"US"])
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
    else if ([self.guidelineCountry isEqualToString:@"UK"])
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
    
    if ([self.guidelineCountry isEqualToString:@"US"])
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
    else if ([self.guidelineCountry isEqualToString:@"UK"])
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
    
    if ([self.guidelineCountry isEqualToString:@"US"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
            
            if ([self.bilirubinUnits isEqualToString:@"SI"])
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
            else if ([self.bilirubinUnits isEqualToString:@"US"])
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
    else if ([self.guidelineCountry isEqualToString:@"UK"])
    {
        if (seriesIndex == 0) // Exchange transfusion
        {
            if (dataIndex == 0)
            {
                if ([self.gestation integerValue] == 38)
                {
                    datapoint.xValue = [NSNumber numberWithDouble:0];
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                    
                    if ([self.bilirubinUnits isEqualToString:@"SI"])
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
                
                if ([self.bilirubinUnits isEqualToString:@"SI"])
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
            
            if ([self.bilirubinUnits isEqualToString:@"SI"])
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
            else if ([self.bilirubinUnits isEqualToString:@"US"])
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
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        if (!landscapeOrientationDefaultsSet)
        {
            if ([self.guidelineCountry isEqualToString:@"US"])
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
            else if ([self.guidelineCountry isEqualToString:@"UK"])
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
            if ([self.guidelineCountry isEqualToString:@"US"]) // setting view controller title
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
}

#pragma mark - PhototherapyAddBilirubinResult delegate

- (void)phototherapyAddBilirubinResultViewController:(PhototherapyAddBilirubinResultViewController *)controller didFinishAddingNewBilirubinResult:(BilirubinResult *)result forBirthDate:(NSDate *)date
{
    
}

- (void)phototherapyAddBilirubinResultViewControllerDidFinishDeletingBilirubinResults:(PhototherapyAddBilirubinResultViewController *)controller
{
    
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

#pragma mark - PDF

- (void)prepareDailySummaryPDFForPatient
{
    DailySummaryPDFViewController *newViewController = [[DailySummaryPDFViewController alloc] init];
    newViewController.selectedPatient = self.selectedPatient;
    
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

@end
