//
//  CalculatorViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 30/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "CalculatorBrain.h"
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

@property (nonatomic, strong) Patient *selectedPatient;

- (void)buttonPressed:(id)sender;

@end
