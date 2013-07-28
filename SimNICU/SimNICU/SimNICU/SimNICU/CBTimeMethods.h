//
//  CBTimeMethods.h
//  SimNICU
//
//  Created by Conrad Bosman on 20/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface CBTimeMethods : NSObject

// Exact (non-calendrical) Time Difference Methods 
+ (double)getDaysDifferenceDoubleBetween:(NSDate *)dateA and:(NSDate *)dateB;

+ (NSDate *)getDateFromDaysDifference:(NSInteger)days fromDate:(NSDate *)date;

+ (NSString *)getFormattedExactDaysHoursMinutesDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;

+ (NSString *)convertPostMenstualAgeToTermPlusDays:(NSString *)postMenstrualAge;

+ (NSString *)convertPostMenstrualAgeToCorrectedGestationalAge:(NSString *)postMenstrualAge;

// Calendrical Time Difference Methods
+ (NSInteger)getDaysDifferenceIntBetween:(NSDate *)dateA and:(NSDate *)dateB;

+ (NSMutableArray *)getFormattedYearsMonthsWeeksDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;

+ (NSString *)calculateCurrentGestation:(Patient *)patient;

+ (NSString *)calculatePostMenstrualGestationFromDateOfBirth:(NSDate *)birthDate andCurrentDate:(NSDate *)currentDate withGestation:(NSString *)gestation;

+ (NSDate *)calculateEDDFromBirthDate:(NSDate *)birthDate andGestation:(NSString *)gestation;

@end
