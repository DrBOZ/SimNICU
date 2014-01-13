//
//  HState.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "StateManager.h"
#import "HState.h"

@interface HState ()

@property (nonatomic, strong) StateManager *defaultStateMgr;

@end

@implementation HState

/**
 * Create a new hierarchical state with a single sub-network.
 * <p>You must assign the HState a unique identifier with respect to its sibling states, i.e., the states in the same network as this HState.
 * Identifiers for states are, by convention, numeric, though the implementation uses Strings for identifiers (since numeric comparison is
 * never required).</p>
 * <p>When you create an HState, you must also create a state manager (StateManager).  When you create a StateManager, you
 * specify the hierarchical state which it manages.</p>
 *
 * @param identifier    State identifier (id).  Must be unique among all states in the state engine.
 * @param msm                   Pointer to the StateManager in the network that this HStateC belongs.  Pass in the parent
 * state, not the StateManager that will control this state's sub-network.
 * @param nm                    Display name of the State.  If null (not supplied), routines use the id for the display name.
 */

- (HState *)init:(id)identifier msm:(StateManager *)msm nm:(NSString *)nm
{
    if ((self = [super init:identifier msm:msm nm:nm]))
    {
        // do nothing else
    }
    
    return self;
}

/**
 * @private
 */

- (void)addStateManager:(StateManager *)sm
{
    if (self.numStMgrs == 1)
    {
        NSLog(@"Trying to add more than one StateManager to HState %@ (by definition, HState's only can have one)", self.name);
    }
    
    [super addStateManager:sm];
}

/**
 * Allows the developer to specify the default start state.
 * <p>The default start state is specified in the State Manager, but for HState's, there is
 * only one manager, so we can go ahead (if the manager is set) to adjust the default start
 * state.</p>
 * @method setDefaultStartState
 * @param id    String identifier for the state
 * @param mgr   Optional parameter specifying the manager for the HState's sub-network (who is the manager for the state you're making default start).  This is declared for consistency with HStateC, though it always will be null for HState's (since we can determine it automatically)
 */

- (void)setDefaultStartState:(NSString *)sid mgr:(StateManager *)mgr // note sid rather than id...
{
    NSString *i;
    StateManager *myMgr = nil;
    
    if (self.numStMgrs == 0)
    {
        if (!mgr)
        {
            myMgr = [[StateManager alloc] init:[NSString stringWithFormat:@"<%@ MANAGER", self.id] containerState:self defaultState:nil n:nil];
        }
        else if ([self.stMgrs objectForKey:mgr.id] != mgr)
        {
            NSLog(@"You supplied the wrong manager to manage <state %@>. That state's manager is %@.", self.name, myMgr.name);
        }
    }
    else
    {
        // We need to retrieve the State Manager for this HState. Since HState's only have
        // 1 state manager (but HStateC's, our parent class, have multiple), we loop through
        // our list of managers to retrieve the manager instance.
        for (i in self.stMgrs)
        {
            myMgr = [self.stMgrs objectForKey:i];
        }
    }
    
    // We go ahead and set the default start state without checking to see if the state belongs to this manager,
    // since it is possible the developer has not yet created that state. If, in the end there is no state, it
    // will be caught at run-time when the manager tries to activate it.
    myMgr.defSt = sid;
}

@end
