//
//  Transition.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@class State;

@interface Transition : NSObject

@property (nonatomic, strong) State *source;
@property (nonatomic, strong) NSString *targetID;

- (Transition *)init:(State *)src tid:(NSString *)tid tfn:(SEL)tfn doHistory:(BOOL)doHistory upLevelsForExternalTransition:(NSInteger)upLevelsForExternalTransition;

@end
