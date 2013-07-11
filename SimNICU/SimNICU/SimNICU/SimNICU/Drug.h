//
//  Drug.h
//  SimNICU
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drug : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL favourite;
@property (nonatomic) NSNumber *defaultPortionIndex;
@property (nonatomic, strong) NSMutableArray *info;



@end
