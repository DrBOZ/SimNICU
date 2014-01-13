/*
 ************************************************
 
 EXAMPLE: Hierarchical State Machine Engine
 AUTHOR: Jonathan Kaye
 
 FILE: State.as (simple state class)
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 Copyright (c) 2009, Jonathan Kaye, All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted
 provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions
 and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 [New BSD License, http://www.opensource.org/licenses/bsd-license.php]
 
 For questions or comments, please refer to http://code.google.com/p/flashsim-state-engines/.
 ************************************************
 */

//
//  State.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "EventDispatcher.h"
#import "Event.h"

/**
 * Event generated on entry to a state.
 * <p>Listeners will be notified when the state becomes active (is entered).</p>
 * @eventType ENTRY
 */

#define ENTRY @"ENTRY"

/**
 * Event generated when the state is no longer active.
 * <p>Listeners will be notified when the state is no longer an active state.</p>
 * @eventType LEAVE
 */

#define LEAVE @"LEAVE"

/**
 A finite state, or a simple, non-hierarchical state.
 
 @class  State
 @package com.flashsim.FStEng.Three
 @author Jonathan Kaye (FlashSim.com)
 */

@class PulseActivity;
@class StateManager;
@class StateEngine;
@class Transition;

@interface State : EventDispatcher

@property (nonatomic, strong) NSString *id;

/**
 * An optional name for the State to give to the State Manager, used for display purposes only. If no
 * name is set, we use id by default.
 */

@property (nonatomic, strong) NSString *name;

/**
 * An Object, keyed by target state id, that contains all the transitions for this State.
 * <p>The value of transitions is itself an array of transitions, because it's possible to have multiple transitions
 * with the same target state (though they must have different event types).</p>
 */

@property (nonatomic, strong) NSMutableDictionary *transitions;

/**
 * An array containing the pulse activities for this state.
 */

@property (nonatomic, strong) NSMutableArray *pulseActivities;
@property (nonatomic, strong) StateEngine *_se;
@property (nonatomic, strong) StateManager *myStMgr;
@property (nonatomic) BOOL handledEvYet;

- (id)init:(NSString *)identifier msm:(StateManager *)msm nm:(NSString *)nm;

- (void)removeState;

- (void)chgSt:(Transition *)trans val:(id)val;

- (BOOL)isActive;

- (Transition *)addTransitionToTarget:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn;

- (Transition *)addTransitionToSelf:(NSString *)tEvtName transFn:(SEL)transFn ulfst:(NSInteger)ulfst;

- (Transition *)addTransitionExternal:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn ulfxt:(NSInteger)ulfxt;

- (Transition *)addTransitionToHistory:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn;

- (void)removeTransition:(Transition *)trans;

- (PulseActivity *)addPulseActivity:(NSInteger)intvl cb:(SEL)cb fb:(BOOL)fb;

- (void)removePulseActivity:(PulseActivity *)pa;

- (BOOL)onEvent:(Event *)ev handledYet:(BOOL)handledYet;  // new feature in FStEng v1.5

- (void)resetHistory;

- (void)registerSubStates:(StateEngine *)stateEng;

- (BOOL)isSubstate:(State *)st;

- (void)enter:(BOOL)hist specIDs:(NSMutableArray *)specIDs;

- (void)leave;

@end
