//
//  HStateC.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "HStateC.h"

@implementation HStateC

/**
 * Create a new hierarchical state with more than one sub-network.
 * <p>The State Manager distinguishes states it controls via unique state identifiers (for that network). The identifer
 * must be unique among all states in the State Engine.</p>
 * <p>When you create an HStateC or an HState, you must also create state managers (StateManager).  When you create a StateManager, you
 * specify the hierarchical state which it manages.  Therefore, for HStateC's, you will create several StateManager's and hook them up
 * to the same (container) state.  For HState's, you will only need to create one (1) StateManager.</p>
 *
 * @param identifier    State identifier (id).  Must be unique among all states in the state engine.
 * @param       msm                     Pointer to the StateManager in the network that this HStateC belongs.  Pass in the parent
 * state, not the StateManager that will control this state's sub-network.
 * @param nm                    Display name of the State.  If null (not supplied), routines use the id for the display name.
 */

- (HStateC *)initWithIdentifier:(NSString *)identifier stateManager:(StateManager *)stateManager name:(NSString *)nm
{
    if ((self = [super init]))
    {
        self.stMgrs = [[NSDictionary alloc] init];
        self.numStMgrs = 0;
        self.substates = [[NSDictionary alloc] init];
    }
    
    return self;
}

/**
 * Adds a sub-state to this state.  This is not for developers.  Developers add
 * state managers (addStMgr) and then connect sub-states using those managers.
 *
 * @method addAsSubState
 * @param st
 * @private
 */

- (void)addAsSubState:(State *)st
{
    NSString *id = st.id;
    
    // check for duplicate ID
    if ([self.substates objectForKey:id])
    {
        <#statements#>
    }
    
}

- (void)removeState
{
    
}

@end
