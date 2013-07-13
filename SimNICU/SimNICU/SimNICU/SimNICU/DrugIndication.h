//
//  DrugIndication.h
//  SimNICU
//
//  Created by Conrad Bosman on 12/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugIndication : NSObject

@property (nonatomic, strong) NSString *indicationDescription;
@property (nonatomic, strong) NSNumber *heightForHeader;
@property (nonatomic, strong) NSNumber *heightForRow;
@property (nonatomic, strong) NSMutableArray *routesOfAdministration;

// @property (nonatomic, strong) NSMutableArray *drugDosesForIndication;

@end
