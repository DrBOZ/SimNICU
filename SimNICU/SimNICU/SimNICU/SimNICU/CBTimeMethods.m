//
//  CBTimeMethods.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTimeMethods.h"

@implementation CBTimeMethods

// Exact (non-calendrical) Time Difference Methods

+ (double)getDaysDifferenceDoubleBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    // This method does not accurately describe day differences in time zone or daylight savings time changes
    if ([dateA isEqualToDate:dateB])
        return 0;
    
    double seconds = [dateB timeIntervalSinceDate:dateA];
    
    double days = seconds / (60 * 60 * 24);
    
    return days;
}

+ (NSDate *)getDateFromDaysDifference:(NSInteger)days fromDate:(NSDate *)date
{
    if (days == 0)
    {
        return date;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    NSDateComponents *dateComponents =
    [gregorian components:flags fromDate:date];
    
    NSDate *roundedDate = [gregorian dateFromComponents:dateComponents];
    
    NSTimeInterval timeInterval = days * (24 * 60 * 60);
    
    NSDate *futureDate = [roundedDate dateByAddingTimeInterval:timeInterval];
    
    return futureDate;
}

+ (NSString *)getFormattedExactDaysHoursMinutesDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    NSString *formattedExactTimeDifference;
    double days, hours, minutes, seconds;
    
    seconds = [dateB timeIntervalSinceDate:dateA];
    
    days = seconds / (60 * 60 * 24);
    hours = seconds / (60 * 60);
    minutes = seconds / (60);
    
    if (days >= 1)
    {
        hours = hours - (abs(days) * 24);
        minutes = minutes - (abs(days) * 24 * 60) - (abs(hours) * 60);
        
        if (abs(days) == 1)
        {
            if (abs(hours) == 0)
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = @"1 day";
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = @"1 day and 1 minute";
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"1 day and %d minutes", abs(minutes)];
                }
            }
            else if (abs(hours) == 1)
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = @"1 day and 1 hour";
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = @"1 day, 1 hour and 1 minute!";
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"1 day, 1 hour, %d minutes", abs(minutes)];
                }
            }
            else
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"1 day and %d hours", abs(hours)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"1 day, %d hours, 1 minute", abs(hours)];
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"1 day, %d hours, %d minutes", abs(hours), abs(minutes)];
                }
            }
        }
        else
        {
            if (abs(hours) == 0)
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days", abs(days)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days and 1 minute", abs(days)];
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days and %d minutes", abs(days), abs(minutes)];
                }
            }
            else if (abs(hours) == 1)
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days and 1 hour", abs(days)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days, 1 hour, 1 minute", abs(days)];
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days, 1 hour, %d minutes", abs(days), abs(minutes)];
                }
            }
            else
            {
                if (abs(minutes) == 0)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days and %d hours", abs(days), abs(hours)];
                }
                else if (abs(minutes) == 1)
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days, %d hours, 1 minute", abs(days), abs(hours)];
                }
                else
                {
                    formattedExactTimeDifference = [NSString stringWithFormat:@"%d days, %d hours, %d minutes", abs(days), abs(hours), abs(minutes)];
                }
            }
        }
    }
    else if (hours >= 1)
    {
        minutes = minutes - (abs(hours) * 60);
        
        if (abs(hours) == 1)
        {
            if (abs(minutes) == 0)
            {
                formattedExactTimeDifference = @"1 hour";
            }
            else if (abs(minutes) == 1)
            {
                formattedExactTimeDifference = @"1 hour and 1 minute";
            }
            else
            {
                formattedExactTimeDifference = [NSString stringWithFormat:@"1 hour and %d minutes", abs(minutes)];
            }
        }
        else
        {
            if (abs(minutes) == 0)
            {
                formattedExactTimeDifference = [NSString stringWithFormat:@"%d hours", abs(hours)];
            }
            else if (abs(minutes) == 1)
            {
                formattedExactTimeDifference = [NSString stringWithFormat:@"%d hours and 1 minute", abs(hours)];
            }
            else
            {
                formattedExactTimeDifference = [NSString stringWithFormat:@"%d hours and %d minutes", abs(hours), abs(minutes)];
            }
        }
    }
    else
    {
        if (abs(minutes) < 1)
        {
            formattedExactTimeDifference = @"less than 1 minute";
        }
        else if (abs(minutes) == 1)
        {
            formattedExactTimeDifference = @"1 minute";
        }
        else
        {
            formattedExactTimeDifference = [NSString stringWithFormat:@"%d minutes", abs(minutes)];
        }
    }
    
    if ([dateA isEqualToDate:dateB])
    {
        formattedExactTimeDifference = @"No Difference";
    }
    
    return formattedExactTimeDifference;
}

// Calendrical Time Difference Methods

+ (NSInteger)getDaysDifferenceIntBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    int differenceToReturn = nil;
    
    // This method is fully calendar dependant and not time dependant
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&fromDate
                 interval:NULL
                  forDate:dateA];
    
    [calendar rangeOfUnit:NSDayCalendarUnit
                startDate:&toDate
                 interval:NULL
                  forDate:dateB];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    differenceToReturn = abs([difference day]);
    
    /*
     // Old Int Method (not returned but logged)
     // This method is time dependant and carries summer time errors over for 1 hour
     // It correctly identifies the Samoan issue
     if ([dateA isEqualToDate:dateB])
     return 0;
     
     NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
     
     NSDate *dateToRound = [dateA earlierDate:dateB];
     int flags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
     NSDateComponents *dateComponents = [gregorian components:flags fromDate:dateToRound];
     
     NSDate *roundedDate = [gregorian dateFromComponents:dateComponents];
     
     NSDate *otherDate = (dateToRound == dateA) ? dateB : dateA ;
     
     NSInteger diff = abs([roundedDate timeIntervalSinceDate:otherDate]);
     
     NSInteger daysDifference = floor(diff/(24 * 60 * 60));
     
     NSLog(@"daysBetweenDate (old method) = %i", daysDifference);
     NSLog(@"---------------------------------");
     // differenceToReturn = daysDifference;
     */
    
    return differenceToReturn;
}

+ (NSString *)calculateCurrentGestation:(Patient *)patient
{
    NSString *currentGestation = @"0+0";
    
    NSDate *now = [NSDate date];
    
    int daysDifference = [CBTimeMethods getDaysDifferenceIntBetween:patient.birthDate and:now];
    int weeksDifference = daysDifference / 7;
    int plusDays = (daysDifference - (weeksDifference * 7));
    int gestationWeeks = [[patient.gestation substringToIndex:2] intValue];
    int gestationDays;
    
    if ([patient.gestation length] > 3)
    {
        gestationDays = [[patient.gestation substringFromIndex:2] intValue];
    }
    else gestationDays = 0;
    
    int correctedGestationWeeks = gestationWeeks + weeksDifference;
    
    int correctedGestationDays = gestationDays + plusDays;
    
    if (correctedGestationDays > 6)
    {
        correctedGestationWeeks = correctedGestationWeeks + 1;
        correctedGestationDays = correctedGestationDays - 7;
    }
    
    currentGestation = [NSString stringWithFormat:@"%d+%d",correctedGestationWeeks, correctedGestationDays];
    
    return currentGestation;
}

@end
