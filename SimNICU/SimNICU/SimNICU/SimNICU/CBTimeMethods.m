//
//  CBTimeMethods.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTimeMethods.h"

@implementation CBTimeMethods

+ (double)getDaysDifferenceDoubleBetween:(NSDate *)dateA and:(NSDate *)dateB
{
    // This method does not accurately describe day differences in time zone or daylight savings time changes
    if ([dateA isEqualToDate:dateB])
        return 0;
    
    double seconds = [dateB timeIntervalSinceDate:dateA];
    
    double days = seconds / (60 * 60 * 24);
    
    return days;
}

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
    
    differenceToReturn = [difference day];

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
