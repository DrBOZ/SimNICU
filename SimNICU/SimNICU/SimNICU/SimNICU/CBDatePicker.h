//
//  CBDatePicker.h
//  SimNICU
//
//  Created by Conrad Bosman on 23/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBDatePicker : NSObject

@property (nonatomic, assign) BOOL hideCancel;

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate target:(id)target action:(SEL)action origin:(id)origin;

- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value;

- (void)showActionSheetPicker;

@end
