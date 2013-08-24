//
//  ShinobiChartCell.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <ShinobiCharts/ShinobiChart.h>
#import <UIKit/UIKit.h>
#import "Patient.h"

@interface ShinobiChartCell : UITableViewCell <SChartDatasource, SChartDelegate>

@property (nonatomic, strong) Patient *selectedPatient;

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
