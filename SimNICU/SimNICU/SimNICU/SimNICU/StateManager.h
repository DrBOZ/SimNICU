/*
 ************************************************
 
 EXAMPLE: Hierarchical State Machine Engine
 AUTHOR: Jonathan Kaye
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 FILE: StateManager.as (state network manager)
 
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
//  StateManager.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HStateC.h"

@class Transition;

@interface StateManager : NSObject

/**
 * An optional name to give to the State Manager, used for display purposes only. If no
 * name is set, we use id by default.
 */
@property (nonatomic, strong) NSString *name;

/**
 * <p>State Manager's identifier that must be different from other StateManager's in sibling networks.  By convention,
 * the identifier is alphabetic.  The identifier uniqueness only really becomes important in HStateC's, since that is
 * the only state class with sibling networks.</p>
 */
@property (nonatomic, strong) NSString *id;

/**
 * Identifier for the default start state.
 * <p>State machine developers indicate which state should be the default start state.  By convention, state identifiers are numeric,
 * but we have implemented them as String's to give more flexibility.</p>
 */
@property (nonatomic, strong) NSString *defSt;

/**
 * Pointer to state containing this manager.
 * <p>Indicates which state encloses this network, in other words, which state is this manager working for.  Set to 'null' if this is manager at state engine (top) level.</p>
 */
@property (nonatomic, strong) HStateC *contSt;

/**
 * Identifier of the current state.
 * <p>If this manager's network is active, this value is the current state's identifier.</p>
 */
@property (nonatomic, strong) NSString *cs;

/**
 * Identifier of the last state entered (for history mechanism)
 * @private
 */
@property (nonatomic, strong) NSString *lastSt;

/**
 * true if state manager is active, false if not
 * @private
 */
@property (nonatomic) BOOL active;

- (StateManager *)init:(NSString *)identifier containerState:(HStateC *)containerState defaultState:(NSString *)defaultState n:(NSString *)n;

- (void)chgSt:(Transition *)trans val:(id)val;

- (void)activate:(BOOL)hist specIDs:(NSMutableArray *)specIDs;

- (void)deactivate;

- (void)resetHistory;

@end
