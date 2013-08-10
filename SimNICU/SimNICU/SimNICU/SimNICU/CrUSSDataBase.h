//
//  CrUSSDataBase.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrUSSDataBase : NSObject

+ (NSMutableArray *)getScansForGestation:(NSInteger)gestation;

@end
