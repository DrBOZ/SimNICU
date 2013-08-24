//
//  CBShinobiChartPhototherapyDataSource.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBShinobiChartPhototherapyDataSource.h"
#import "BilirubinResult.h"

@implementation CBShinobiChartPhototherapyDataSource

- (id)initWithGuideLineCountry:(NSString *)guidelineCountry bilirubinUnits:(NSString *)bilirubinUnits forNeurotoxicityRisk:(NSString *)neurotoxicityRisk forGestation:(NSNumber *)gestation andPlotBilirubinResults:(NSMutableArray *)bilirubinLevelsToPlot selectedPatient:(Patient *)selectedPatient
{
    self = [super init];
    
    if (self)
    {
        self.bilirubinLevelsToPlot = bilirubinLevelsToPlot;
        self.neurotoxicityRisk = neurotoxicityRisk;
        self.guidelineCountry = guidelineCountry;
        self.selectedPatient = selectedPatient;
        self.bilirubinUnits = bilirubinUnits;
        self.gestation = gestation;
    }
    
    return self;
}

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

@end
