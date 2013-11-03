//
//  CBWeightMethods.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBWeightMethods.h"

@implementation CBWeightMethods

+ (NSString *)getFormattedWeightFrom:(NSString *)weight
{
    NSString *formattedWeight = nil;
    
    // goes through the entire string and replaces any commas with full stops in case
    // user is using a european locale
    NSString *UKLocaleWorkingWeight;
    UKLocaleWorkingWeight = [weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleWorkingWeight = [weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
    
    if (workingWeightKGAsFloat < 1.0f)
    {
        // present weight as grams
        int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
        
        formattedWeight = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
    }
    else
    {
        // present weight as kilograms
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        // if using arabic locale, force to english
        if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
        {
            formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
        }
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 3;
        
        formattedWeight = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
    }
    
    return formattedWeight;
}

@end
