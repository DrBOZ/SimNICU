//
//  DrugRouteOfAdministration.h
//  SimNICU
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugRouteOfAdministration : NSObject

@property (nonatomic, strong) NSString *routeDescription;
@property (nonatomic, strong) NSString *routeAbbreviation;
@property (nonatomic, strong) NSMutableArray *drugDoses;

@end
