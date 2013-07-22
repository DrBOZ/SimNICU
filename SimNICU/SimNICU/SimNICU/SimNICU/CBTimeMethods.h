//
//  CBTimeMethods.h
//  SimNICU
//
//  Created by Conrad Bosman on 20/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#define CALCULATION_METHOD 0

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface CBTimeMethods : NSObject

// + (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (NSInteger)getDaysDifferenceIntBetween:(NSDate *)dateA and:(NSDate *)dateB;
+ (double)getDaysDifferenceDoubleBetween:(NSDate *)dateA and:(NSDate *)dateB;

+ (NSDate *)getDateFromDaysDifference:(NSInteger)days fromDate:(NSDate *)date;

+ (NSString *)calculateCurrentGestation:(Patient *)patient;

// Exact Time Difference Methods (non-calendrical)
+ (NSString *)getFormattedExactDaysHoursMinutesDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;

@end
