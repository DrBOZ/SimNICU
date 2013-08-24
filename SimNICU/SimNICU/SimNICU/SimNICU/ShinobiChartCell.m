//
//  ShinobiChartCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBShinobiChartPhototherapyDataSource.h"
#import "ShinobiChartCell.h"
#import "BilirubinResult.h"

@implementation ShinobiChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.guidelineCountry = @"UK";
        self.bilirubinUnits = @"SI";  // change this later...
    }
    return self;
}

- (void)layoutSubviews
{
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
    self.chart = [[ShinobiChart alloc] initWithFrame:self.bounds];
    
    self.chart.title = [NSString stringWithFormat:@"Infants born at %i%@ weeks gestation", [self.gestation intValue], plusString];
    
    // self.chart.datasource = self;
    self.chart.datasource = (id)[[CBShinobiChartPhototherapyDataSource alloc] initWithGuideLineCountry:(NSString *)self.guidelineCountry bilirubinUnits:(NSString *)self.bilirubinUnits forNeurotoxicityRisk:(NSString *)self.neurotoxicityRisk forGestation:(NSNumber *)self.gestation andPlotBilirubinResults:(NSMutableArray *)self.bilirubinLevelsToPlot selectedPatient:(Patient *)self.selectedPatient];
    
    self.chart.delegate = nil;
    
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
        
        self.chart.xAxis = self.xAxis;
        self.chart.yAxis = self.yAxis;
        
        [self addSubview:self.chart];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
