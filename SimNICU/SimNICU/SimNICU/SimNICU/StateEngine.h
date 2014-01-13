//
//  StateEngine.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "ASMacro.h"
#import "Array.h"
#import "Event.h"
#import "EventDispatcher.h"

@class HStateC;

@interface StateEngine : EventDispatcher

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *activeStates;
@property (nonatomic, strong) NSMutableDictionary *statesByID;
@property (nonatomic, strong) NSMutableDictionary *_concEvCt;
@property (nonatomic, strong) NSObject *spriteForFramePulse;
@property (nonatomic, strong) HStateC *topState;

- (StateEngine *)initWithName:(NSString *)n andStateNetwork:(HStateC *)stateNetwork;
- (void)active:(BOOL)activate;
- (void)prepareNetwork;

@end
