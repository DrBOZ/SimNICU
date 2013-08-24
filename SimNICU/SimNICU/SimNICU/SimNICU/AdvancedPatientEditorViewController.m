//
//  AdvancedPatientEditorViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 17/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AdvancedPatientEditorViewController.h"
#import <ShinobiCharts/ShinobiChart.h>
#import "CBTableViewSectionData.h"
#import "CBTableViewRowData.h"
#import "BilirubinResult.h"
#import "HandoverSection.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

#import "ShinobiChartCell.h"

@interface AdvancedPatientEditorViewController () <UITableViewDataSource, UITableViewDelegate, SChartDatasource, SChartDelegate>
{
    int selectedBay;
    int selectedPatientInBay;
    
    BOOL landscapeOrientationDefaultsSet;
    BOOL portraitOrientationDefaultsSet;
    
    BOOL newPatientDetails;
    BOOL newBiliChart;
    
    NSMutableArray *tableView2Sections;
}

// general table
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView1;
@property (nonatomic, strong) UITableView *myTableView2;
@property (nonatomic, strong) Patient *selectedPatient;
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

@end

@implementation AdvancedPatientEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectedBay = 0;
        selectedPatientInBay = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.guidelineCountry = @"UK";
    self.bilirubinUnits = @"SI";  // change this later...
    portraitOrientationDefaultsSet = YES;
	
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // setup back button
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:self action:@selector(done)];
    
    // setup edit button
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // setup toolbar
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(previousPatient)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextPatient)];
    
    NSArray *items = [NSArray arrayWithObjects:item1, flexibleItem, item2, flexibleItem, item3, nil];
    self.toolbarItems = items;
    
    // self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.toolbar.tintColor = [UIColor grayColor];
    
    // sections
    // tableView2Sections = [[NSMutableArray alloc] initWithCapacity:12];
    // tableView2Sections = [self loadSectionDataForPatient];
    
    // tableViews
    self.myTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 92.0f) style:UITableViewStylePlain];
    self.myTableView1.rowHeight = 44.0f;
    self.myTableView1.dataSource = self;
    self.myTableView1.delegate = self;
    self.myTableView1.sectionFooterHeight = 10.0f;
    self.myTableView1.sectionHeaderHeight = 10.0f;
    self.myTableView1.separatorColor = [UIColor grayColor];
    self.myTableView1.userInteractionEnabled = NO;
    [self.view addSubview:self.myTableView1];
    
    self.myTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 92.0f, 320.0f, (appDelegate.window.bounds.size.height - 44.0f - 156.0f)) style:UITableViewStylePlain];
    self.myTableView2.rowHeight = 44.0f;
    self.myTableView2.dataSource = self;
    self.myTableView2.delegate = self;
    self.myTableView2.sectionFooterHeight = 10.0f;
    self.myTableView2.sectionHeaderHeight = 10.0f;
    self.myTableView2.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView2];
    
    // set the first patient to display
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    
    // sections
    tableView2Sections = [[NSMutableArray alloc] initWithCapacity:12];
    tableView2Sections = [self loadSectionDataForPatientEditing:self.editing];
    
    // create first phototherapy chart
    // self.chart = [self createShinobiChartForPatient:self.selectedPatient];
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
    return 1;
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
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    float height = 55.0f;
    
    if ([tableView isEqual:self.myTableView1])
    {
        height = 70.0f;
    }
    else
    {
        if ([tableView2Sections[indexPath.section] isEqual:@"Jaundice"])
        {
            // Different graph sizes for iPhone 4 and iPhone 5
            if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
            {
                height = 320.0f;
            }
            else
            {
                height = 260.0f;
            }
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
        if ([tableView2Sections[indexPath.section] isEqual:@"Jaundice"])
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 11)
    {
        NSLog(@"cell.bounds.origin.x = %f", cell.bounds.origin.x);
        NSLog(@"cell.bounds.origin.y = %f", cell.bounds.origin.y);
        NSLog(@"cell.bounds.size.width = %f", cell.bounds.size.width);
        NSLog(@"cell.bounds.size.height = %f", cell.bounds.size.height);
    }
}

- (UITableViewCell *)formatCellForTableWithCellIdentifier:(NSString *)CellIdentifier
{
    UITableViewCell *cell;
    
    // this is wrong...?
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([CellIdentifier isEqualToString:@"Patient"])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //displayTextLabel (Patient's name)
        UILabel *displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 22.0f)];
        displayTextLabel.textColor = [UIColor blackColor];
        displayTextLabel.backgroundColor = [UIColor clearColor];
        displayTextLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        displayTextLabel.adjustsFontSizeToFitWidth = NO;
        displayTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayTextLabel];
        
        UILabel *displayAgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 23.0f, 300.0f, 22.0f)];
        displayAgeTextLabel.textColor = [UIColor grayColor];
        displayAgeTextLabel.backgroundColor = [UIColor clearColor];
        displayAgeTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayAgeTextLabel.adjustsFontSizeToFitWidth = NO;
        displayAgeTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayAgeTextLabel];
        
        //displayDetailTextLabel (Gestation, birth weight, corrected gestation and working weight)
        UILabel *displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 44.0f, 300.0f, 22.0f)];
        displayDetailTextLabel.textColor = [UIColor grayColor];
        displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        displayDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        displayDetailTextLabel.adjustsFontSizeToFitWidth = NO;
        displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        [cell addSubview:displayDetailTextLabel];
        
        // display patient's name
        displayTextLabel.text = [self.selectedPatient returnDisplayTextLabelText];
        
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
    else if ([CellIdentifier isEqualToString:@"Phototherapy"])
    {
        // shinobi chart
        
        // temp code
        /*
        ShinobiChartCell *shinobiTestingCell = [[ShinobiChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Testing"];
        shinobiTestingCell.selectedPatient = self.selectedPatient;
        shinobiTestingCell.gestation = self.gestation;
        shinobiTestingCell.neurotoxicityRisk = self.neurotoxicityRisk;
        shinobiTestingCell.guidelineCountry = self.guidelineCountry;
        
        [cell addSubview:shinobiTestingCell];
        */
        
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
        self.chart = [[ShinobiChart alloc] initWithFrame:cell.bounds];
        
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
            // self.yAxis.style.titleStyle.position = SChartTitlePositionBottomOrLeft;
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
            // self.yAxis.style.titleStyle.position = SChartTitlePositionBottomOrLeft;
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
         
        self.chart.bounds = cell.bounds;
        [cell addSubview:self.chart];
        
        // [cell.contentView addSubview:self.chart];
        // ShinobiChartCell *shinobiCell = [[ShinobiChartCell alloc] initWithFrame:cell.bounds];
        // [shinobiCell addSubview:self.chart];
        // return shinobiCell;
    }
    
    return cell;
}

#pragma mark editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    
    result = YES;
    
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    tableView2Sections = [self loadSectionDataForPatientEditing:editing];
    
    [self.myTableView2 setEditing:editing animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle *editingStyle = nil;
    
    if ([tableView isEqual:self.myTableView2])
    {
        if ([tableView2Sections[indexPath.section] isEqual:@"Jaundice"])
        {
            editingStyle = UITableViewCellEditingStyleDelete;
        }
        else
        {
            editingStyle = UITableViewCellEditingStyleInsert;
        }
    }
    
    return editingStyle;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - methods

- (void)done
{
    [self dismissModalViewControllerAnimated:YES];
}

/*
- (ShinobiChart *)createShinobiChartForPatient:(Patient *)patient
{
    ShinobiChart *newChart;
    
    // first check if gestation has been entered
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
    newChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 320.0f)];
    
    newChart.title = [NSString stringWithFormat:@"Infants born at %i%@ weeks gestation", [self.gestation intValue], plusString];
    
    newChart.datasource = self;
    newChart.delegate = self;
    
    // Double tap can either reset zoom or zoom in
    newChart.gestureDoubleTapResetsZoom = NO;
    
    // Choose a theme for the chart
    SChartDarkTheme *darkTheme = [SChartDarkTheme new];
    
    // Perform any theme styling here before applying to the chart
    darkTheme.xAxisStyle.minorTickStyle.showTicks = YES;
    darkTheme.yAxisStyle.minorTickStyle.showTicks = YES;
    
    // Apply theme to chart
    newChart.theme = darkTheme;
    
    // Show the legend
    newChart.legend.hidden = YES;
    newChart.legend.placement = SChartLegendPlacementInsidePlotArea;
    
    newChart.userInteractionEnabled = NO;
    
    newChart.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
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
        // self.yAxis.style.titleStyle.position = SChartTitlePositionBottomOrLeft;
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
        // self.yAxis.style.titleStyle.position = SChartTitlePositionBottomOrLeft;
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
    
    newChart.xAxis = self.xAxis;
    newChart.yAxis = self.yAxis;
    
    return newChart;
}
 */

- (void)nextPatient
{
    // load new data in tableView
    newPatientDetails = YES;
    newBiliChart = YES;
    
    // check the number of patients in the current bay
    int numberOfPatientsInCurrentBay = [[self.bayData[selectedBay] patientsInBay] count];
    
    // check to see if there is another patient in the bay
    if (selectedPatientInBay == (numberOfPatientsInCurrentBay - 1))
    {
        // no, last patient in bay
        
        // increment bay (need to add code if last bay)
        selectedBay += 1;
        
        // reset patient info
        selectedPatientInBay = 0;
        
        self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
        self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
        
        [self.myTableView1 reloadData];
        [self.myTableView2 reloadData];
        
        [self.myTableView1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        // yes, there are more patients in the bay
        selectedPatientInBay += 1;
        
        self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
        self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
        
        [self.myTableView1 reloadData];
        [self.myTableView2 reloadData];
        
        [self.myTableView1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    // if not then check if there are any more bays
    // if there is another bay then increment bays
}

- (void)previousPatient
{
    // load new data in tableView
    newPatientDetails = YES;
    newBiliChart = YES;
    
    // yes, there are more patients in the bay
    selectedPatientInBay -= 1;
    
    self.title = [NSString stringWithFormat:@"%@ - %i", [self.bayData[selectedBay] bayName], (selectedPatientInBay + 1)];
    self.selectedPatient = [[self.bayData[selectedBay] patientsInBay] objectAtIndex:selectedPatientInBay];
    
    [self.myTableView1 reloadData];
    [self.myTableView2 reloadData];
    
    [self.myTableView1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSMutableArray *)loadSectionDataForPatientEditing:(BOOL)editing
{
    NSMutableArray *returnArray = nil;
    
    // logic
    // if editing, then display the full list of sections
    
    // if not editing then display the list of displayed section
    
    // first check to see if any data has alread been added
    if (!self.selectedPatient.handoverSections)
    {
        // instantiate array
        // this is a bit long winded, but allows user to be able to edit it later - saved in Patientlist.
        self.selectedPatient.handoverSections = [[NSMutableArray alloc] initWithCapacity:20];
        
        // create default data - this could a for next loop
        HandoverSection *newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Background";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Active Problems";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Resolved Problems";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Recent Significant Evens";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Ventilation & Sedation";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"CXR";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Cardiovascular";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Lines";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Feeds & Fluids";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Fluid Balance";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Electrolytes";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Jaundice";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Sepsis";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Drugs";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"ROP";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Cranial USS";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Parents / Social";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Impression";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Plan";
        newSection.sectionEditable = @"NO";
        [self.selectedPatient.handoverSections addObject:newSection];
        
        newSection = [[HandoverSection alloc] init];
        newSection.sectionName = @"Jobs";
        newSection.sectionEditable = @"NO";
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
    
    if ([self.guidelineCountry isEqualToString:@"US"])
    {
        // could implement a conditional statement if user want UK style for US or risk factor lines...
        
        numberOfSeries = 3;
    }
    if ([self.guidelineCountry isEqualToString:@"UK"])
    {
        numberOfSeries = 3;
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
    // NSLog(@"sChartRenderFinished");
    
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

@end
