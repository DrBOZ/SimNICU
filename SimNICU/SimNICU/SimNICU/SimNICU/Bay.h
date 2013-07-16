//
//  Bay.h
//  SimNICU
//
//  Created by Conrad Bosman on 16/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bay : NSObject <NSCoding>

@property (nonatomic, retain) NSString *bayName;
@property (nonatomic, retain) NSMutableArray *patientsInBay;

@end
