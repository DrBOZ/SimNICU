//
//  Calculator.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

+ (Calculator *)calculatorWithText:(NSString *)text andDetailText:(NSString *)detailText
{
    Calculator *calculator = [Calculator new];
    
    calculator.text = text;
    calculator.detailText = detailText;
    
    return calculator;
}

@end
