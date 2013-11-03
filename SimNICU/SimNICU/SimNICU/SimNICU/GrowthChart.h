//
//  GrowthChart.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowthChart : NSObject

+ (NSString *)getWeightForSex:(NSString *)sex atCentile:(NSString *)centile atGestation:(NSString *)gestation;

@end
