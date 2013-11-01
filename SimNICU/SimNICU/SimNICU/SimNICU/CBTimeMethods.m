//
//  CBTimeMethods.m
//  Neonatal Intensive Care
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

+ (NSString *)convertPostMenstualAgeToTermPlusDays:(NSString *)postMenstrualAge
{
    // get gestation in weeks from string
    int gestationWeeks = [[postMenstrualAge substringToIndex:2] intValue];
    
    int daysPostTerm;
    
    daysPostTerm = ((gestationWeeks - 40) * 7);
    
    // check postMenstrualAge string is 4 characters long
    if ([postMenstrualAge length] > 2)
    {
        daysPostTerm += [[postMenstrualAge substringFromIndex:3] intValue];
    }
    
    NSString *returnString;
    
    if (daysPostTerm == 0)
    {
        returnString = @"Term";
    }
    else
    {
        returnString = [NSString stringWithFormat:@"Term + %d", daysPostTerm];
    }
    
    return returnString;
}

+ (NSString *)convertPostMenstrualAgeToCorrectedGestationalAge:(NSString *)postMenstrualAge
{
    // get gestation in weeks from string
    int gestationWeeks = [[postMenstrualAge substringToIndex:2] intValue];
    
    // subtract 40
    gestationWeeks -= 40;
    
    // reform string
    NSString *correctedGestation;
    correctedGestation = [NSString stringWithFormat:@"%d%@", gestationWeeks, [postMenstrualAge substringFromIndex:2]];
    
    return correctedGestation;
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
    
    return differenceToReturn;
}

+ (NSInteger)getAgeInDaysOfPatient:(Patient *)patient
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    int age = 0;
    
    age = [self getDaysDifferenceIntBetween:patient.birthDate and:[NSDate date]];
    
    if ([preferences.ageInDaysSetting intValue] == 2)
    {
        if (patient.birthTimeSet)
        {
            // if time of birth is before midday then Day 1
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:patient.birthDate];
            NSInteger currentHour = [components hour];
            
            if (currentHour < 12)
            {
                age = age + 1;
            }
        }
        else
        {
            // time of birth is not set
            age = age + 1;
        }
    }
    else
    {
        age = age + [preferences.ageInDaysSetting intValue];
    }
    
    return age;
}

+ (NSMutableArray *)getFormattedYearsMonthsWeeksDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    NSString *formattedDate = nil;
    
    // set calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // set unitFlags
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit;
    
    // round dates (i.e. pure calendrical operation)
    
    // date A
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:dateA];
    dateA = [gregorian dateFromComponents:comps];
    
    // date B
    comps = [gregorian components:unitFlags fromDate:dateB];
    dateB = [gregorian dateFromComponents:comps];
    
    // between dates
    comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    int compsYears = [comps year];
    int compsMonths = [comps month];
    int compsWeeks = [comps week];
    int compsDays = [comps day];
    
    // NSLog(@"Age = %i years, %i months, %i weeks, %i days", compsYears, compsMonths, compsWeeks, compsDays);
    
    // format in normal English
    if (compsYears < 1)
    {
        if (compsMonths == 0)
        {
            if (compsWeeks == 0)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"day of birth"];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i days", compsDays];
                }
            }
            else if (compsWeeks == 1)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 week"];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 week, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 week, %i days", compsDays];
                }
            }
            else
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks", compsWeeks];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks, 1 day", compsWeeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i weeks, %i days", compsWeeks, compsDays];
                }
            }
        }
        else if (compsMonths == 1)
        {
            if (compsWeeks == 0)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month"];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i days", compsDays];
                }
            }
            else if (compsWeeks == 1)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week"];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week, 1 day"];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, 1 week, %i days", compsDays];
                }
            }
            else
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks", compsWeeks];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks, 1 day", compsWeeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"1 month, %i weeks, %i days", compsWeeks, compsDays];
                }
            }
        }
        else // months
        {
            if (compsWeeks == 0)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months", compsMonths];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 day", compsMonths];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i days", compsMonths, compsDays];
                }
            }
            else if (compsWeeks == 1)
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week", compsMonths];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week, 1 day", compsMonths];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, 1 week, %i days", compsMonths, compsDays];
                }
            }
            else
            {
                if (compsDays == 0)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks", compsMonths, compsWeeks];
                }
                else if (compsDays == 1)
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks, 1 day", compsMonths, compsWeeks];
                }
                else
                {
                    formattedDate = [NSString stringWithFormat:@"%i months, %i weeks, %i days", compsMonths, compsWeeks, compsDays];
                }
            }
        }
    }
    else if (compsYears == 1)
    {
        if (compsMonths == 0)
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year", compsYears];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i day", compsYears, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year", compsYears];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i days", compsYears, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year", compsYears];
            }
        }
        else if (compsMonths == 1)
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", compsYears, compsMonths];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i month, %i day", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", compsYears, compsMonths];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i month, %i days", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year, %i month", compsYears, compsMonths];
            }
        }
        else
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", compsYears, compsMonths];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i months, %i day", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", compsYears, compsMonths];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i year, %i months, %i days", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i year, %i months", compsYears, compsMonths];
            }
        }
    }
    else
    {
        if (compsMonths == 0)
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years", compsYears];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i day", compsYears, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years", compsYears];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i days", compsYears, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years", compsYears];
            }
        }
        else if (compsMonths == 1)
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", compsYears, compsMonths];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i month, %i day", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", compsYears, compsMonths];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i month, %i days", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years, %i month", compsYears, compsMonths];
            }
        }
        else
        {
            if (compsDays == 0)
            {
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", compsYears, compsMonths];
            }
            else if (compsDays == 1)
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i months, %i day", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", compsYears, compsMonths];
            }
            else
            {
                // formattedDate = [NSString stringWithFormat:@"%i years, %i months, %i days", compsYears, compsMonths, compsDays];
                formattedDate = [NSString stringWithFormat:@"%i years, %i months", compsYears, compsMonths];
            }
        }
    }
    
    // format in days (i.e.  day 57)
    NSString *formattedDate1 = nil;
    unitFlags = NSDayCalendarUnit;
    comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    compsDays = [comps day];
    
    if (compsDays == 0)
    {
        formattedDate1 = [NSString stringWithFormat:@""];
    }
    else if (compsDays == 1)
    {
        formattedDate1 = [NSString stringWithFormat:@"1 day"];
    }
    else
    {
        formattedDate1 = [NSString stringWithFormat:@"%i days", compsDays];
    }
    // NSLog(@"%i days", compsDays);
    
    // format in weeks and days spelt
    NSString *formattedDate2 = nil;
    unitFlags = NSWeekCalendarUnit | NSDayCalendarUnit;
    comps = [gregorian components:unitFlags fromDate:dateA  toDate:dateB  options:0];
    compsWeeks = [comps week];
    compsDays = [comps day];
    
    // format in weeks and days (57+4)
    formattedDate2 = [NSString stringWithFormat:@"%i+%i", compsWeeks, compsDays];
    // NSLog(@"%i+%i", compsWeeks, compsDays);
    
    // create Array
    NSMutableArray *formattedDates = [[NSMutableArray alloc] init];
    [formattedDates addObject:formattedDate];
    [formattedDates addObject:formattedDate1];
    [formattedDates addObject:formattedDate2];
    
    return formattedDates;
}

+ (NSInteger)getYearsDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit;
    unsigned int unitFlag = NSYearCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlag fromDate:dateA  toDate:dateB  options:0];
    int compsYears = [comps year];
    
    return compsYears;
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

+ (NSString *)calculatePostMenstrualGestationFromDateOfBirth:(NSDate *)birthDate andCurrentDate:(NSDate *)currentDate withGestation:(NSString *)gestation
{
    NSString *currentGestation = @"0 + 0";
    
    int daysDifference = [CBTimeMethods getDaysDifferenceIntBetween:birthDate and:currentDate];
    int weeksDifference = daysDifference /7;
    int plusDays = (daysDifference - (weeksDifference * 7));
    int gestationWeeks = [[gestation substringToIndex:2] intValue];
    int gestationDays;
    
    if ([gestation length] > 3)
    {
        gestationDays = [[gestation substringFromIndex:2] intValue];
    }
    else gestationDays = 0;
    
    int correctedGestationWeeks = gestationWeeks + weeksDifference;
    
    int correctedGestationDays = gestationDays + plusDays;
    
    if (correctedGestationDays > 6)
    {
        correctedGestationWeeks = correctedGestationWeeks + 1;
        correctedGestationDays = correctedGestationDays - 7;
    }
    
    currentGestation = [NSString stringWithFormat:@"%d+%d", correctedGestationWeeks, correctedGestationDays];
    
    return currentGestation;
}

+ (NSDate *)calculateEDDFromBirthDate:(NSDate *)birthDate andGestation:(NSString *)gestation
{
    NSDate *EDD = nil;
    
    // work out number of days to 40+0 from gestation
    int daysTillEDD;
    
    int GestationWeeks = [[gestation substringToIndex:2] intValue];
    
    daysTillEDD = ((40 - GestationWeeks) * 7) - [[gestation substringFromIndex:3] intValue];
    
    // use a calendrical function to work out days from birthDate
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int flags = (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit);
    NSDateComponents *dateComponents = [gregorian components:flags fromDate:birthDate];
    
    dateComponents.day += daysTillEDD;
    
    EDD = [gregorian dateFromComponents:dateComponents];
    
    return EDD;
}

@end
