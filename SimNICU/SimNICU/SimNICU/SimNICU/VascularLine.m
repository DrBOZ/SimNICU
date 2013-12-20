//
//  VascularLine.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "VascularLine.h"

@implementation VascularLine

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        self.lineDescription = [aDecoder decodeObjectForKey:@"LineDescription"];
        self.lineSite = [aDecoder decodeObjectForKey:@"LineSite"];
        self.dateInserted = [aDecoder decodeObjectForKey:@"LineDateInserted"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Demographics
    [aCoder encodeObject:self.lineDescription forKey:@"LineDescription"];
    [aCoder encodeObject:self.lineSite forKey:@"LineSite"];
    [aCoder encodeObject:self.dateInserted forKey:@"LineDateInserted"];
}

+ (NSArray *)getLineDescriptions
{
    NSMutableArray *lineDescriptions;

    NSString *lineDescription;
    
    lineDescription = @"UVC";
    [lineDescriptions addObject:lineDescription];
    
    lineDescription = @"UAC";
    [lineDescriptions addObject:lineDescription];
    
    lineDescription = @"PICC";
    [lineDescriptions addObject:lineDescription];
    
    lineDescription = @"Broviac";
    [lineDescriptions addObject:lineDescription];
    
    lineDescription = @"Peripheral venous cannula";
    [lineDescriptions addObject:lineDescription];
    
    return lineDescriptions;
}

+ (NSArray *)getLineSites
{
    NSMutableArray *lineSites;
    
    NSString *lineSite;
    
    lineSite = @"Long saphenous vein";
    [lineSites addObject:lineSite];
    
    return lineSites;
}

@end
