//
//  Drug.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drug : NSObject

// drug list name
@property (nonatomic, strong) NSString *name;

// drug favourite toggle
@property (nonatomic) BOOL favourite;

// array to store dosing information
@property (nonatomic, strong) NSMutableArray *dosingDetails;

// array containing all the information to display the HTML information
@property (nonatomic, strong) NSMutableArray *info;

@end
