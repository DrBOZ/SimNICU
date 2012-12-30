//
//  CalculatorBrain.h
//  SimNICU
//
//  Created by Conrad Bosman on 13/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{
	double operand;  //3
	double waitingOperand;  //4
	NSString *currentOperation; //-
}

- (double)performArthematicOperation:(NSString *) operation;
- (double)performTrignometicOperation:(NSString *) operation;
- (double)performAdvancedArthematicOperation:(NSString *) operation;
- (void)setOperand:(double) aOperand;
- (void)reset;

@end