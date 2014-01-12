//
//  StateManager.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transition.h"
#import "HStateC.h"

@class HStateC;
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

- (StateManager *)initWithIdentifier:(NSString *)identifier containerState:(HStateC *)containerState defaultState:(NSString *)defaultState name:(NSString *)n;

- (void)chgSt:(Transition *)trans val:(id)val;

@end
