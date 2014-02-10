//
//  AI.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/02/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "AI.h"

@implementation AI

// Class Singleton method
+ (AI *)sharedAI
{
    static AI *sharedAI = nil;
    static dispatch_once_t onceToken;            // uses Grand Central Dispatch, ie threadsafe
    dispatch_once(&onceToken, ^{
        sharedAI = [[self alloc] init];
    });
    return sharedAI;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // code here
    }
    
    return self;
}

- (NSMutableArray *)getSuggestionsForPatient:(Patient *)patient
{
    NSMutableArray *suggestions = [[NSMutableArray alloc] initWithCapacity:10];
    
    // think about weight loss / gain
    
    // think about Ventilation & Sedation
    
    // think about Cardiovascular
    
    // think about Haematology
    
    // think about Lines
    
    // think about Echocardiogram
    
    // think about Feeds & Fluids
    
    // think about Fluid Balance
    
    // think about Biochemistry
    
    // think about Jaundice
    
    // think about Sepsis
    
    // think about Drugs
    
    // think about Immunisations
    [self checkIfNeedsImmunisations];
    [self checkCriteriaForPalivizumab];
    if ([self doINeedToThinkAboutRotavirusVaccine])
    {
        // code
    }
    
    // think about ROP
    
    // think about Neurology & CrUSS
    if ([self doINeedToConsiderACrUSS])
    {
        // code
    }
    
    // think about Parents & Social
    
    // Finally, if AI has no suggestions
    if (suggestions.count == 0)
    {
        [suggestions addObject:@"None at present"];
    }
    
    return suggestions;
}

- (void)checkIfNeedsImmunisations
{
    // code
}

- (void)checkCriteriaForPalivizumab
{
    // code
}

- (BOOL)doINeedToThinkAboutRotavirusVaccine
{
    return NO;
}

- (BOOL)doINeedToConsiderACrUSS
{
    BOOL answer = NO;
    
    // check if patient meets basic criteria for CrUSS
    
    
    return answer;
}

@end
