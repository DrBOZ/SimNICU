//
//  CrUSSDataBase.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CrUSSDataBase.h"
#import "CrUSSImage.h"

@implementation CrUSSDataBase

+ (NSMutableArray *)getScansForGestation:(NSInteger)gestation
{
    // code
    
    CrUSSImage *scanImage;
    
    
    NSMutableArray *scanSeries = [[NSMutableArray alloc] initWithCapacity:8];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Frontal lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"01_Frontal_lobes.png"];
    [scanSeries addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Anterior horns";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"02_Anterior_horns_of_lateral_ventricles.png"];
    [scanSeries addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Third ventricle";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"03_Third_ventricle.png"];
    [scanSeries addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Trigone";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"04_Trigone.png"];
    [scanSeries addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Occipital lobes";
    scanImage.orientation = @"Coronal";
    scanImage.image = [UIImage imageNamed:@"05_Final_coronal.png"];
    [scanSeries addObject:scanImage];
    
    scanImage = [[CrUSSImage alloc] init];
    scanImage.text = @"Midline";
    scanImage.orientation = @"Sagittal";
    scanImage.image = [UIImage imageNamed:@"06_Midline_sagittal.png"];
    [scanSeries addObject:scanImage];
    
}

@end
