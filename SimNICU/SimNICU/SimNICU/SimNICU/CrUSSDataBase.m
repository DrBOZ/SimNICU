//
//  CrUSSDataBase.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CrUSSScanSeries.h"
#import "CrUSSDataBase.h"
#import "CrUSSImage.h"

@implementation CrUSSDataBase

+ (NSMutableArray *)getScansForGestation:(NSInteger)gestation
{
    NSMutableArray *scans = [[NSMutableArray alloc] initWithCapacity:5];
    
    CrUSSScanSeries *scanSeries;
    CrUSSImage *scanImage;
    
    scanSeries = [[CrUSSScanSeries alloc] init];
    
    scanSeries.description = @"Normal";
    scanSeries.report = @"Normal";
    scanSeries.scans = [[NSMutableArray alloc] initWithCapacity:8];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Frontal lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"01_30_Normal_Frontal_lobes.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Anterior horns";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"02_30_Normal_Anterior_horns_of_lateral_ventricles.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Third ventricle";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"03_30_Normal_Third_ventricle.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Trigone";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"04_30_Normal_Trigone.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Occipital lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"05_30_Normal_Final_coronal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Midline";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"06_30_Normal_Midline_sagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    [scans addObject:scanSeries];
    
    // add another
    scanSeries = [[CrUSSScanSeries alloc] init];
    
    scanSeries.description = @"Abnormal";
    scanSeries.report = @"Abnormal";
    scanSeries.scans = [[NSMutableArray alloc] initWithCapacity:8];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Frontal lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"01_30_Normal_Frontal_lobes.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Anterior horns";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"02_30_Normal_Anterior_horns_of_lateral_ventricles.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Third ventricle";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"03_30_Normal_Third_ventricle.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Trigone";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"04_30_Normal_Trigone.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Occipital lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"05_30_Normal_Final_coronal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Midline";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"06_30_Normal_Midline_sagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    [scans addObject:scanSeries];
    
    return scans;
}

@end
