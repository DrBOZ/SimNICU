//
//  CalculatorViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 30/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
// #import "CustomButton.h"
#import "Patient.h"

typedef enum
{
    kButtonMC, // 0
    kButtonMPlus, // 1
    kButtonMMinus, // 2
    kButtonMR, // etc
    
    kButtonAC,
    kButtonChangeSign,
    kButtonDivide,
    kButtonMultiply,
    
    kButtonSeven,
    kButtonEight,
    kButtonNine,
    kButtonSubtract,
    
    kButtonFour,
    kButtonFive,
    kButtonSix,
    kButtonAdd,
    
    kButtonOne,
    kButtonTwo,
    kButtonThree,
    
    kButtonZero,
    kButtonDot,
    kButtonEqual
} kButton;

@interface CalculatorViewController : UIViewController
{
    NSNumber *leftOperator;
    NSNumber *lastResult;
    kButton operation;
    BOOL deleteInput;
    double memory;
}

@property (nonatomic, strong) NSMutableString *resultText;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) UILabel *patientDetails;
@property (nonatomic, strong) UILabel *resultLabel;

- (void)buttonPressed:(id)sender;

@end
