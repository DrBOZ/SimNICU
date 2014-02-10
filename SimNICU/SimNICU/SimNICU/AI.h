//
//  AI.h
//  SimNICU
//
//  Created by Conrad Bosman on 10/02/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"

@interface AI : NSObject

// returns singleton object
+ (id)sharedAI;

// instance methods
- (NSMutableArray *)getSuggestionsForPatient:(Patient *)patient;

@end
