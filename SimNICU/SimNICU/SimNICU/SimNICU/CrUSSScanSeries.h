//
//  CrUSSScanSeries.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrUSSScanSeries : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *report;
@property (nonatomic, strong) NSMutableArray *scans;

@end
