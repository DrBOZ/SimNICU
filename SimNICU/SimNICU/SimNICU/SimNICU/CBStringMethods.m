//
//  CBStringMethods.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 22/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBStringMethods.h"

@implementation CBStringMethods

+ (NSString *)dayAndMonthInParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale;
{
    // setup date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    // get date as string
    NSString *dateAsString = [formatter stringFromDate:date];
    
    // crop date
    // best approach is to crop the second "/"
    int pointToCrop = 0;
    
    for (int i = 0; i < dateAsString.length; i++)
    {
        NSString *characterAtPointi = [dateAsString substringWithRange:NSMakeRange(i, 1)];
        
        if ([characterAtPointi isEqualToString:@"/"])
        {
            pointToCrop = i;
        }
    }
    
    NSString *formattedDateAsString = [dateAsString substringToIndex:pointToCrop];
    
    // add parentheses
    NSString *formattedDateAsStringInParentheses = [NSString stringWithFormat:@"(%@)", formattedDateAsString];
    
    return formattedDateAsStringInParentheses;
}

+ (NSString *)dayAndMonthWithoutParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale;
{
    // setup date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    // get date as string
    NSString *dateAsString = [formatter stringFromDate:date];
    
    // crop date
    // best approach is to crop the second "/"
    int pointToCrop = 0;
    
    for (int i = 0; i < dateAsString.length; i++)
    {
        NSString *characterAtPointi = [dateAsString substringWithRange:NSMakeRange(i, 1)];
        
        if ([characterAtPointi isEqualToString:@"/"])
        {
            pointToCrop = i;
        }
    }
    
    NSString *formattedDateAsString = [dateAsString substringToIndex:pointToCrop];
    
    // add parentheses
    NSString *formattedDateAsStringInParentheses = [NSString stringWithFormat:@"%@", formattedDateAsString];
    
    return formattedDateAsStringInParentheses;
}

+ (NSString *)dayAndMonthAndTimeInParenthesesForDate:(NSDate *)date andLocale:(NSLocale *)locale
{
    // setup date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeZone = [NSTimeZone localTimeZone];
    
    // get date as string
    NSString *dateAsString = [formatter stringFromDate:date];
    
    // crop date
    // best approach is to crop the second "/"
    int pointToCrop = 0;
    
    for (int i = 0; i < dateAsString.length; i++)
    {
        NSString *characterAtPointi = [dateAsString substringWithRange:NSMakeRange(i, 1)];
        
        if ([characterAtPointi isEqualToString:@"/"])
        {
            pointToCrop = i;
        }
    }
    
    NSString *formattedDateAsString = [dateAsString substringToIndex:pointToCrop];
    
    // crop time
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSString *formattedTimeAsString = [formatter stringFromDate:date];
    
    // add parentheses
    NSString *formattedDateAsStringInParentheses = [NSString stringWithFormat:@"(%@ %@)", formattedDateAsString, formattedTimeAsString];
    
    return formattedDateAsStringInParentheses;
}

+ (NSString *)localisedString:(NSString *)string
{
    if ([string isEqualToString:@"ml/kg/day"])
    {
        return [NSString stringWithFormat:@"ml/kg/%@", NSLocalizedString(@"day", nil)];
    }
    else if ([string isEqualToString:@"ml/day"])
    {
        return [NSString stringWithFormat:@"ml/%@", NSLocalizedString(@"day", nil)];
    }
    else return NSLocalizedString(string, nil);
}

@end
