//
//  CBShinobiChartPhototherapyDataSource.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import <Foundation/Foundation.h>
#import "Patient.h"

@interface CBShinobiChartPhototherapyDataSource : NSObject

@property (nonatomic, strong) NSMutableArray *bilirubinLevelsToPlot;
@property (nonatomic, strong) NSString *neurotoxicityRisk;
@property (nonatomic, strong) NSString *guidelineCountry;
@property (nonatomic, strong) NSString *bilirubinUnits;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) NSNumber *gestation;

- (id)initWithGuideLineCountry:(NSString *)guidelineCountry bilirubinUnits:(NSString *)bilirubinUnits forNeurotoxicityRisk:(NSString *)neurotoxicityRisk forGestation:(NSNumber *)gestation andPlotBilirubinResults:(NSMutableArray *)bilirubinLevelsToPlot selectedPatient:(Patient *)selectedPatient;

// Returns the number of series in the specified chart
- (int)numberOfSeriesInSChart:(ShinobiChart *)chart;

// Returns the series at the specified index for a given chart
- (SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index;

// Returns the number of points for a specific series in the specified chart
- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex;

// Returns the data point at the specified index for the given series/chart.
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex;

@end
