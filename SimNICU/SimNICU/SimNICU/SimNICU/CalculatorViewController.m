//
//  CalculatorViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 30/07/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#define TEXTAREA_WIDTH 300
#define TEXTAREA_HEIGHT 46

#define BUTTON_WIDTH 65
#define BUTTON_HEIGHT 40

#define BUTTON_V_PADDING 19
#define BUTTON_H_PADDING 13


#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL equalsButtonWasLastButtonPressed;
@property (nonatomic) BOOL userHasPressedWorkingWeightButton;
@property (nonatomic, strong) UILabel *workingWeightButtonLabel;
@property (nonatomic, strong) NSMutableString *calculation;
@property (nonatomic, strong) UILabel *calculationLabel;

// result
@property (nonatomic, strong) NSMutableString *resultText;
@property (nonatomic, strong) UILabel *resultLabel; // display

@end

@implementation CalculatorViewController
{
    NSNumber *leftOperator;
    NSNumber *lastResult;
    kButton operation;
    BOOL deleteInput;
    double memory;
}

- (void)addButtonWithTitle:(NSString *)aTitle tag:(int)tag row:(int)row column:(int)column width:(int)width height:(int)height
{
    UIButton *button;
    
    float x, y;
    
    x = BUTTON_H_PADDING + (BUTTON_WIDTH + BUTTON_H_PADDING) * column;
    y = TEXTAREA_HEIGHT + BUTTON_V_PADDING + (BUTTON_HEIGHT + BUTTON_V_PADDING) * row;
    
    float buttonWidth = BUTTON_WIDTH;
    float buttonHeight = BUTTON_HEIGHT;
    
    if (width > 1)
        buttonWidth = (BUTTON_WIDTH + BUTTON_H_PADDING) * width - BUTTON_H_PADDING;
    
    if (height > 1)
        buttonHeight = (BUTTON_HEIGHT + BUTTON_V_PADDING) * height - BUTTON_V_PADDING;
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    
    [button setTitle:aTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    NSString *imageFile;
    
    switch (tag)
    {
        case kButtonMC:
            imageFile = @"kButtonMC.png";
            break;
            
        case kButtonMPlus:
            imageFile = @"kButtonMPlus";
            break;
            
        case kButtonMMinus:
            imageFile = @"kButtonMMinus";
            break;
            
        case kButtonMR:
            imageFile = @"kButtonMR";
            break;
            
        case kButtonMultiply:
            imageFile = @"kButtonMultiply";
            break;
            
        case kButtonDivide:
            imageFile = @"kButtonDivide";
            break;
            
        case kButtonChangeSign:
            imageFile = @"kButtonTemplate";
            break;
            
        case kButtonAC:
            imageFile = @"kButtonAC";
            break;
            
        case kButtonSeven:
            imageFile = @"kButtonSeven";
            break;
            
        case kButtonEight:
            imageFile = @"kButtonEight";
            break;
            
        case kButtonNine:
            imageFile = @"kButtonNine";
            break;
            
        case kButtonSubtract:
            imageFile = @"kButtonSubtract";
            break;
            
        case kButtonAdd:
            imageFile = @"kButtonAdd";
            break;
            
        case kButtonSix:
            imageFile = @"kButtonSix";
            break;
            
        case kButtonFive:
            imageFile = @"kButtonFive";
            break;
            
        case kButtonFour:
            imageFile = @"kButtonFour";
            break;
            
        case kButtonOne:
            imageFile = @"kButtonOne";
            break;
            
        case kButtonTwo:
            imageFile = @"kButtonTwo";
            break;
            
        case kButtonThree:
            imageFile = @"kButtonThree";
            break;
            
        case kButtonEqual:
            imageFile = @"kButtonEquals";
            break;
            
        case kButtonDot:
            imageFile = @"kButtonDot";
            break;
            
        case kButtonZero:
            imageFile = @"kButtonZero";
            break;
            
        default:
            break;
    }
    
    if (imageFile)
    {
        UIImage *image = [UIImage imageNamed:imageFile];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    button.backgroundColor = [UIColor clearColor];
    
    button.tag = tag;
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // background
    
    // self.view.backgroundColor = [UIColor lightGrayColor];
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg_calc.png"]];
	self.view.backgroundColor = background;
    
    // display
    self.resultText = [NSMutableString stringWithString:@"0"];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, TEXTAREA_WIDTH, TEXTAREA_HEIGHT)];
    self.resultLabel.backgroundColor = [UIColor clearColor];
    self.resultLabel.text = self.resultText; // default label
    self.resultLabel.textColor = [UIColor whiteColor];
    self.resultLabel.textAlignment = UITextAlignmentRight;
    self.resultLabel.font = [UIFont systemFontOfSize:60];
    
    [self.view addSubview:self.resultLabel];
    
    // patient
    self.calculationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, TEXTAREA_WIDTH, TEXTAREA_HEIGHT)];
    self.calculationLabel.backgroundColor = [UIColor clearColor];
    self.calculationLabel.text = @"";
    self.calculationLabel.textColor = [UIColor whiteColor];
    self.calculationLabel.textAlignment = UITextAlignmentLeft;
    self.calculationLabel.font = [UIFont systemFontOfSize:30];
    
    [self.view addSubview:self.calculationLabel];
    
    memory = 0;
    
    // Add buttons
    // [self addButtonWithTitle:@""      tag:kButtonMC           row:0 column:0 width:1 height:1];
    // [self addButtonWithTitle:@""      tag:kButtonMPlus        row:0 column:1 width:1 height:1];
    // [self addButtonWithTitle:@""      tag:kButtonMMinus       row:0 column:2 width:1 height:1];
    // [self addButtonWithTitle:@""      tag:kButtonMR           row:0 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@""      tag:kButtonAC           row:1 column:0 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonChangeSign   row:1 column:1 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonDivide       row:1 column:2 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonMultiply     row:1 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@""      tag:kButtonSeven        row:2 column:0 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonEight        row:2 column:1 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonNine         row:2 column:2 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonSubtract     row:2 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@""      tag:kButtonFour         row:3 column:0 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonFive         row:3 column:1 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonSix          row:3 column:2 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonAdd          row:3 column:3 width:1 height:1];
    
    [self addButtonWithTitle:@""      tag:kButtonOne          row:4 column:0 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonTwo          row:4 column:1 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonThree        row:4 column:2 width:1 height:1];
    [self addButtonWithTitle:@""      tag:kButtonEqual        row:4 column:3 width:1 height:2];
    
    [self addButtonWithTitle:@""      tag:kButtonZero         row:5 column:0 width:2 height:1];
    [self addButtonWithTitle:@""      tag:kButtonDot          row:5 column:2 width:1 height:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedPatient)
    {
        if (self.selectedPatient.lastname && self.selectedPatient.firstname)
        {
            int nameLength;
            
            nameLength = [self.selectedPatient.firstname length] + [self.selectedPatient.lastname length];
            
            if (nameLength > 15)
            {
                self.title = [NSString stringWithFormat:@"%@", self.selectedPatient.lastname];
            }
            else
            {
                self.title = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
            }
        }
        else
        {
            self.title = @"Calculator";
        }
        
        // Working weight button
        
        if (self.selectedPatient.workingWeight)
        {
            NSString *formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", self.selectedPatient.workingWeight];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:formattedWorkingWeight style:UIBarButtonItemStyleBordered target:self action:@selector(workingWeightPressed)];
        }
    }
    else
    {
        self.title = @"Calculator";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// If you pass 0, it will use the previously saved operation
- (void)doOperation:(int)theOperation
{
    double result;
    
    if (theOperation == 0)
    {
        
        
        theOperation = operation;
    }
    
    NSString *operatorCharacter;
    
    switch (theOperation)
    {
        case kButtonMultiply:
            result = [leftOperator doubleValue] * [self.resultText doubleValue];
            operatorCharacter = @"\u00D7";
            break;
        case kButtonDivide:
            result = [leftOperator doubleValue] / [self.resultText doubleValue];
            operatorCharacter = @"\u00F7";
            break;
        case kButtonAdd:
            result = [leftOperator doubleValue] + [self.resultText doubleValue];
            operatorCharacter = @"+";
            break;
        case kButtonSubtract:
            result = [leftOperator doubleValue] - [self.resultText doubleValue];
            operatorCharacter = @"\u2212";
            break;
        case kButtonChangeSign:
            // result = [leftOperator doubleValue] * -1;
            
            // do nothing for now
            
            self.calculationLabel.font = [UIFont boldSystemFontOfSize:20];
            self.calculationLabel.text = @"Single Strength Dopamine";
            
            break;
    }
    
    if (!self.calculation) 
    {
        self.calculation = [NSMutableString stringWithFormat:@"= %@ %@ %@", [leftOperator stringValue], operatorCharacter, self.resultText];
    }
    else 
    {
        // self.calculation = self.calculation;
        [self.calculation appendFormat:@" %@ %@", operatorCharacter, self.resultText];
    }
    
    self.calculationLabel.text = self.calculation;
    
    // reset the leftOperator
    leftOperator = nil;
    
    // reset workingWeight toggle
    self.userHasPressedWorkingWeightButton = NO;
    
    self.resultText = [NSMutableString stringWithFormat:@"%f", result];
    lastResult = [NSNumber numberWithDouble:result];
}

- (void)performOperation:(int)theOperation
{
    // if we have a right operator already, compute the existing value
    if (leftOperator) 
    {
        [self doOperation:theOperation];
    }
    else 
    {
        // save the existing operation for later
        operation = theOperation;
    }
    
    if (self.equalsButtonWasLastButtonPressed) 
    {
        leftOperator = lastResult;
        self.equalsButtonWasLastButtonPressed = NO;
    }
    else 
    {
        // assign the left operation for later use
        leftOperator = [NSNumber numberWithDouble:[self.resultText doubleValue]];
    }
}

- (NSMutableString *)readableNumberFromString:(NSString *)aString
{
    // given 12.30000 we remove the trailing zeros
    NSMutableString *result = [NSMutableString stringWithString:aString];
    
    // check if it contains a . character.
    if ([result rangeOfString:@"."].location != NSNotFound) {
        
        // start from the end, and remove any 0 or . you find until you find a number greater than 0
        for (int i = [result length] - 1; i >= 0; i--) {
            // get the char
            unichar currentChar = [result characterAtIndex:i];
            
            if (currentChar == '0') {
                // remove it from the string
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
            } else if (currentChar == '.') {
                // remove it from the string
                [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
                break;
            }
            else {
                break;
            }
        }
    }
    
    // assign default value if needed
    if ([result isEqualToString:@""]) {
        [result appendString:@"0"];
    }
    
    // remove the initial 0 if present
    if ([result length] > 1 && [result characterAtIndex:0] == '0') {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    return result;
}

#pragma mark actions

// This is a macro function that I use below to DRY up the code
#define ADD_DIGIT(x) [self.resultText appendFormat:@"%d", x]

- (void)buttonPressed:(id)sender
{
    // We sometimes need to delete the current text, but we never have to do so for the change sign button
    if (deleteInput && [sender tag] != kButtonChangeSign)
    {
        [self.resultText setString:@""];
    }
    deleteInput = NO;
    
    // See which button the user pressed
    switch ([sender tag]) {
        case kButtonMC:
            // reset memory
            memory = 0;
            break;
        case kButtonMPlus:
            // add number to memory
            memory += [self.resultText doubleValue];
            deleteInput = YES;
            break;
        case kButtonMMinus:
            // subract number from memory
            memory -= [self.resultText doubleValue];
            deleteInput = YES;
            break;
        case kButtonMR:
            // recall memory
            self.resultText = [NSMutableString stringWithFormat:@"%f", memory];
            deleteInput = YES;
            break;
        case kButtonAC:
            // reset screen
            self.resultText = [NSMutableString stringWithString:@"0"];
            self.calculationLabel.text = @"";
            leftOperator = nil;
            self.userHasPressedWorkingWeightButton = NO;
            self.equalsButtonWasLastButtonPressed = NO;
            self.calculation = nil;
            break;
        case kButtonChangeSign:
            // force the left operator since we only have one in this case
            // leftOperator = [NSNumber numberWithDouble:[self.resultText doubleValue]];
            
            // [self performOperation:kButtonChangeSign];
            // deleteInput = YES;
            break;
        case kButtonDivide:
            [self performOperation:kButtonDivide];
            deleteInput = YES;
            break;
        case kButtonMultiply:
            [self performOperation:kButtonMultiply];
            deleteInput = YES;
            break;
        case kButtonSeven:
            [self addDigit:7];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonEight:
            [self addDigit:8];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonNine:
            [self addDigit:9];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonSubtract:
            [self performOperation:kButtonSubtract];
            deleteInput = YES;
            break;
        case kButtonFour:
            [self addDigit:4];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonFive:
            [self addDigit:5];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonSix:
            [self addDigit:6];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonAdd:
            [self performOperation:kButtonAdd];
            deleteInput = YES;
            break;
        case kButtonOne:
            [self addDigit:1];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonTwo:
            [self addDigit:2];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonThree:
            [self addDigit:3];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonZero:
            [self addDigit:0];
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonDot:
            // handle later
            self.equalsButtonWasLastButtonPressed = NO;
            break;
        case kButtonEqual:
            [self doOperation:0];
            deleteInput = YES;
            self.equalsButtonWasLastButtonPressed = YES;
            self.calculation = nil;
            break;
    }
    
    // prettify result
    self.resultText = [self readableNumberFromString:self.resultText];
    
    // check if we need to add a dot, like Apple's calculator does.
    if ([sender tag] == kButtonDot) {
        [self.resultText appendString:@"."];
    }
    
    // finally show the text to the user
    self.resultLabel.text = self.resultText;
}

- (void)addDigit:(int)digit
{
    if ([self.resultText length] < 6) 
    {
        [self.resultText appendFormat:@"%d", digit];
    }
}

- (void)workingWeightPressed
{
    deleteInput = NO;
    
    self.resultText = [NSMutableString stringWithString:self.selectedPatient.workingWeight];
    
    self.resultLabel.text = self.resultText;
    
    self.userHasPressedWorkingWeightButton = YES;
}

@end
