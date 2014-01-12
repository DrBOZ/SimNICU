//
//  HStateC.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "State.h"

/**
 * A hierarchical state with concurrency.
 * <p>A hierarchical state with concurrency is a state that has multiple sub-networks of states, each operating in parallel.
 * Each sub-network has a State Manager to keep track of the current and last states for that sub-network.  Most of the time,
 * engines will use HState's, which are hierarchical states with a single sub-network of states.  From an implementation point
 * of view, however, HState's are specializations of HStateC's, namely a hierarchical state with concurrency but only a single
 * sub-network (so no real concurrency, then).
 * @class HStateC
 * @package com.flashsim.FStEng.Three
 * @author  Jonathan Kaye (FlashSim.com)
 * @see StateEngine StateEngine definition examples.
 */

@interface HStateC : State

/**
 * Number of state managers (i.e., sub-networks) within this state.
 */

@property (nonatomic) NSInteger numStMgrs;

/**
 * An object that holds a hash table (indexed by State Manager id's) to the State Managers for this state.
 */

// @property (nonatomic, strong) NSObject *stMgrs;
@property (nonatomic, strong) NSDictionary *stMgrs;

/**
 * Collection of children states.
 * An object that holds a hash table (indexed by state id's) to the children of this state.  Grandchildren (if there are
 * any) are stored in the children's states, not here.
 */

// @property (nonatomic, strong) NSObject *substates;
@property (nonatomic, strong) NSDictionary *substates;

- (HStateC *)initWithIdentifier:(NSString *)identifier stateManager:(StateManager *)stateManager name:(NSString *)nm;

- (void)addAsSubState:(State *)st;

- (void)removeState;

@end
