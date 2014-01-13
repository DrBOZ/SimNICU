/*
 ************************************************
 
 EXAMPLE: Hierarchical State Machine Engine
 AUTHOR: Jonathan Kaye
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 FILE: HStateC.as (hierarchical state class w/concurrency)
 
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

@class StateManager;

@interface HStateC : State

/**
 * Number of state managers (i.e., sub-networks) within this state.
 */

@property (nonatomic) NSInteger numStMgrs;

/**
 * An object that holds a hash table (indexed by State Manager id's) to the State Managers for this state.
 */

@property (nonatomic, strong) NSMutableDictionary *stMgrs;

/**
 * Collection of children states.
 * An object that holds a hash table (indexed by state id's) to the children of this state.  Grandchildren (if there are
 * any) are stored in the children's states, not here.
 */

@property (nonatomic, strong) NSMutableDictionary *substates;

- (HStateC *)init:(id)identifier msm:(StateManager *)msm nm:(NSString *)nm;

- (void)addAsSubState:(State *)st;

- (void)removeState;

- (BOOL)isSubstate:(State *)st;

- (void)setDefaultStartState:(NSString *)id mgr:(StateManager *)mgr;

- (void)addStateManager:(StateManager *)sm;

@end
