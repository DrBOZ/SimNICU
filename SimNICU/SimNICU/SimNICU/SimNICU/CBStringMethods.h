//
//  CBStringMethods.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 22/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBStringMethods : NSObject

+ (NSString *)dayAndMonthInParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale;

+ (NSString *)dayAndMonthWithoutParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale;

+ (NSString *)dayAndMonthAndTimeInParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale;

+ (NSString *)localisedString:(NSString *)string;

@end
