//
//  DrugSection.h
//  SimNICU
//
//  Created by Conrad Bosman on 08/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugSection : NSObject

@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSMutableArray *drugs;

@end
