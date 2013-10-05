//
//  Calculator.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detailText;

+ (Calculator *)calculatorWithText:(NSString *)text andDetailText:(NSString *)detailText;

@end
