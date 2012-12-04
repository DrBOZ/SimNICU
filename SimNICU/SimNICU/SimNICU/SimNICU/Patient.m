//
//  Patient.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "Patient.h"

@implementation Patient

@synthesize formattedBirthDate = _formattedBirthDate;
@synthesize formattedWorkingWeightDate = _formattedWorkingWeightDate;
@synthesize correctedGestation = _correctedGestation;
@synthesize lastname = _lastname;
@synthesize firstname = _firstname;
@synthesize gestation = _gestation;
@synthesize birthTimeSet = _birthTimeSet;

@synthesize birthDate = _birthDate;
@synthesize birthYear = _birthYear;
@synthesize birthMonth = _birthMonth;
@synthesize birthDay = _birthDay;
@synthesize birthHour = _birthHour;
@synthesize birthMinute = _birthMinute;
@synthesize dueDate = _dueDate;
@synthesize birthWeight = _birthWeight;
@synthesize currentWeight = _currentWeight;
@synthesize lastWeight = _lastWeight;
@synthesize workingWeight = _workingWeight;
@synthesize workingWeightDate = _workingWeightDate;
@synthesize gestationWeeks = _gestationWeeks;
@synthesize gestationDays = _gestationDays;

@synthesize NewBabyAPGARSSaved = _NewBabyAPGARSSaved;

@synthesize APGAR1minColour = _APGAR1minColour;
@synthesize APGAR1minHeartRate = _APGAR1minHeartRate;
@synthesize APGAR1minRespiratoryEffort = _APGAR1minRespiratoryEffort;
@synthesize APGAR1minTone = _APGAR1minTone;
@synthesize APGAR1minReflexes = _APGAR1minReflexes;

@synthesize APGAR5minColour = _APGAR5minColour;
@synthesize APGAR5minHeartRate = _APGAR5minHeartRate;
@synthesize APGAR5minRespiratoryEffort = _APGAR5minRespiratoryEffort;
@synthesize APGAR5minTone = _APGAR5minTone;
@synthesize APGAR5minReflexes = _APGAR5minReflexes;

@synthesize APGAR10minColour = _APGAR10minColour;
@synthesize APGAR10minHeartRate = _APGAR10minHeartRate;
@synthesize APGAR10minRespiratoryEffort = _APGAR10minRespiratoryEffort;
@synthesize APGAR10minTone = _APGAR10minTone;
@synthesize APGAR10minReflexes = _APGAR10minReflexes;

@synthesize APGAR15minColour = _APGAR15minColour;
@synthesize APGAR15minHeartRate = _APGAR15minHeartRate;
@synthesize APGAR15minRespiratoryEffort = _APGAR15minRespiratoryEffort;
@synthesize APGAR15minTone = _APGAR15minTone;
@synthesize APGAR15minReflexes = _APGAR15minReflexes;

@synthesize APGAR20minColour = _APGAR20minColour;
@synthesize APGAR20minHeartRate = _APGAR20minHeartRate;
@synthesize APGAR20minRespiratoryEffort = _APGAR20minRespiratoryEffort;
@synthesize APGAR20minTone = _APGAR20minTone;
@synthesize APGAR20minReflexes = _APGAR20minReflexes;

@synthesize bilirubinResults = _bilirubinResults;

// lazily instantiate bilirubinResults;
 
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        // Demographics
        self.lastname = [aDecoder decodeObjectForKey:@"LastName"];
        self.firstname = [aDecoder decodeObjectForKey:@"FirstName"];
        self.birthWeight = [aDecoder decodeObjectForKey:@"BirthWeight"];
        // self.lastWeight = [aDecoder decodeObjectForKey:@"LastWeight"];
        // self.currentWeight = [aDecoder decodeObjectForKey:@"CurrentWeight"];
        self.gestation = [aDecoder decodeObjectForKey:@"Gestation"];
        self.correctedGestation = [aDecoder decodeObjectForKey:@"CorrectedGestation"];
        
        self.birthDate = [aDecoder decodeObjectForKey:@"BirthDate"];
        self.formattedBirthDate = [aDecoder decodeObjectForKey:@"FormattedBirthDate"];
        self.workingWeight = [aDecoder decodeObjectForKey:@"WorkingWeight"];
        self.workingWeightDate = [aDecoder decodeObjectForKey:@"WorkingWeightDate"];
        self.formattedWorkingWeightDate = [aDecoder decodeObjectForKey:@"FormattedWorkingWeightDate"];
        
        self.NewBabyAPGARSSaved = [aDecoder decodeObjectForKey:@"NewBabyAPGARSSaved"];
        
        self.APGAR1minColour = [aDecoder decodeObjectForKey:@"APGAR1minColour"];
        self.APGAR1minHeartRate = [aDecoder decodeObjectForKey:@"APGAR1minHeartRate"];
        self.APGAR1minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR1minRespiratoryEffort"];
        self.APGAR1minTone = [aDecoder decodeObjectForKey:@"APGAR1minTone"];
        self.APGAR1minReflexes = [aDecoder decodeObjectForKey:@"APGAR1minReflexes"];
        
        self.APGAR5minColour = [aDecoder decodeObjectForKey:@"APGAR5minColour"];
        self.APGAR5minHeartRate = [aDecoder decodeObjectForKey:@"APGAR5minHeartRate"];
        self.APGAR5minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR5minRespiratoryEffort"];
        self.APGAR5minTone = [aDecoder decodeObjectForKey:@"APGAR5minTone"];
        self.APGAR5minReflexes = [aDecoder decodeObjectForKey:@"APGAR5minReflexes"];
        
        self.APGAR10minColour = [aDecoder decodeObjectForKey:@"APGAR10minColour"];
        self.APGAR10minHeartRate = [aDecoder decodeObjectForKey:@"APGAR10minHeartRate"];
        self.APGAR10minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR10minRespiratoryEffort"];
        self.APGAR10minTone = [aDecoder decodeObjectForKey:@"APGAR10minTone"];
        self.APGAR10minReflexes = [aDecoder decodeObjectForKey:@"APGAR10minReflexes"];
        
        self.APGAR15minColour = [aDecoder decodeObjectForKey:@"APGAR15minColour"];
        self.APGAR15minHeartRate = [aDecoder decodeObjectForKey:@"APGAR15minHeartRate"];
        self.APGAR15minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR15minRespiratoryEffort"];
        self.APGAR15minTone = [aDecoder decodeObjectForKey:@"APGAR15minTone"];
        self.APGAR15minReflexes = [aDecoder decodeObjectForKey:@"APGAR15minReflexes"];
        
        self.APGAR20minColour = [aDecoder decodeObjectForKey:@"APGAR20minColour"];
        self.APGAR20minHeartRate = [aDecoder decodeObjectForKey:@"APGAR20minHeartRate"];
        self.APGAR20minRespiratoryEffort = [aDecoder decodeObjectForKey:@"APGAR20minRespiratoryEffort"];
        self.APGAR20minTone = [aDecoder decodeObjectForKey:@"APGAR20minTone"];
        self.APGAR20minReflexes = [aDecoder decodeObjectForKey:@"APGAR20minReflexes"];
        
        // bilirubin results
        self.bilirubinResults = [aDecoder decodeObjectForKey:@"BilirubinResults"];
        self.birthTimeSet = [aDecoder decodeObjectForKey:@"BirthTimeSet"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Demographics
    [aCoder encodeObject:self.lastname forKey:@"LastName"];
    [aCoder encodeObject:self.firstname forKey:@"FirstName"];
    [aCoder encodeObject:self.birthWeight forKey:@"BirthWeight"];
    // [aCoder encodeObject:self.lastWeight forKey:@"LastWeight"];
    // [aCoder encodeObject:self.currentWeight forKey:@"CurrentWeight"];
    [aCoder encodeObject:self.gestation forKey:@"Gestation"];
    [aCoder encodeObject:self.correctedGestation forKey:@"CorrectedGestation"];
    
    [aCoder encodeObject:self.birthDate forKey:@"BirthDate"];
    [aCoder encodeObject:self.formattedBirthDate forKey:@"FormattedBirthDate"];
    [aCoder encodeObject:self.workingWeight forKey:@"WorkingWeight"];
    [aCoder encodeObject:self.workingWeightDate forKey:@"WorkingWeightDate"];
    [aCoder encodeObject:self.formattedWorkingWeightDate forKey:@"FormattedWorkingWeightDate"];
    
    [aCoder encodeObject:self.NewBabyAPGARSSaved forKey:@"NewBabyAPGARSSaved"];
    
    [aCoder encodeObject:self.APGAR1minColour forKey:@"APGAR1minColour"];
    [aCoder encodeObject:self.APGAR1minHeartRate forKey:@"APGAR1minHeartRate"];
    [aCoder encodeObject:self.APGAR1minRespiratoryEffort forKey:@"APGAR1minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR1minTone forKey:@"APGAR1minTone"];
    [aCoder encodeObject:self.APGAR1minReflexes forKey:@"APGAR1minReflexes"];
    
    [aCoder encodeObject:self.APGAR5minColour forKey:@"APGAR5minColour"];
    [aCoder encodeObject:self.APGAR5minHeartRate forKey:@"APGAR5minHeartRate"];
    [aCoder encodeObject:self.APGAR5minRespiratoryEffort forKey:@"APGAR5minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR5minTone forKey:@"APGAR5minTone"];
    [aCoder encodeObject:self.APGAR5minReflexes forKey:@"APGAR5minReflexes"];
    
    [aCoder encodeObject:self.APGAR10minColour forKey:@"APGAR10minColour"];
    [aCoder encodeObject:self.APGAR10minHeartRate forKey:@"APGAR10minHeartRate"];
    [aCoder encodeObject:self.APGAR10minRespiratoryEffort forKey:@"APGAR10minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR10minTone forKey:@"APGAR10minTone"];
    [aCoder encodeObject:self.APGAR10minReflexes forKey:@"APGAR10minReflexes"];
    
    [aCoder encodeObject:self.APGAR15minColour forKey:@"APGAR15minColour"];
    [aCoder encodeObject:self.APGAR15minHeartRate forKey:@"APGAR15minHeartRate"];
    [aCoder encodeObject:self.APGAR15minRespiratoryEffort forKey:@"APGAR15minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR15minTone forKey:@"APGAR15minTone"];
    [aCoder encodeObject:self.APGAR15minReflexes forKey:@"APGAR15minReflexes"];
    
    [aCoder encodeObject:self.APGAR20minColour forKey:@"APGAR20minColour"];
    [aCoder encodeObject:self.APGAR20minHeartRate forKey:@"APGAR20minHeartRate"];
    [aCoder encodeObject:self.APGAR20minRespiratoryEffort forKey:@"APGAR20minRespiratoryEffort"];
    [aCoder encodeObject:self.APGAR20minTone forKey:@"APGAR20minTone"];
    [aCoder encodeObject:self.APGAR20minReflexes forKey:@"APGAR20minReflexes"];
    
    // bilirubin results
    [aCoder encodeObject:self.bilirubinResults forKey:@"BilirubinResults"];
    [aCoder encodeObject:self.birthTimeSet forKey:@"BirthTimeSet"];
}

@end
