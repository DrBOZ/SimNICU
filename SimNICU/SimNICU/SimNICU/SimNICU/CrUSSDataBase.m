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
    
    scanSeries.description = @"30/40 - normal";
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
    scanImage.image = [UIImage imageNamed:@"05_30_Normal_Occipital_lobes.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Midline";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"06_30_Normal_Midline_Sagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Right Angled parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"07_30_Normal_Rt_Angled_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Right Tangential parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"08_30_Normal_Rt_Tangential_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Left Angled parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"09_30_Normal_Lt_Angled_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Left Tangential parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"10_30_Normal_Lt_Tangential_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    [scans addObject:scanSeries];
    
    // add another
    scanSeries = [[CrUSSScanSeries alloc] init];
    
    scanSeries.description = @"30/40 - left IVH";
    scanSeries.report = @"Abnormal";
    scanSeries.scans = [[NSMutableArray alloc] initWithCapacity:8];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Frontal lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"01_30_Lt_IVH_Frontal_lobes.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Anterior horns";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"02_30_Lt_IVH_Anterior_horns_of_lateral_ventricles.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Third ventricle";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"03_30_Lt_IVH_Third_ventricle.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Trigone";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"04_30_Lt_IVH_Trigone.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Occipital lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"05_30_Lt_IVH_Occiptal_lobes.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Midline";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"06_30_Lt_IVH_Midline.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Right Angled parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"07_30_Lt_IVH_Rt_Angled_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Right Tangential parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"08_30_Lt_IVH_Rt_Tangential_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Left Angled parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"09_30_Lt_IVH_Lt_Angled_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Left Tangential parasagittal";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"10_30_Lt_IVH_Lt_Tangential_parasagittal.png"];
    [scanSeries.scans addObject:scanImage];
    
    [scans addObject:scanSeries];
    
    return scans;
}

@end
