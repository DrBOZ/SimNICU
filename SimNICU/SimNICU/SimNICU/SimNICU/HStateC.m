//
//  HStateC.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "PulseActivity.h"
#import "StateManager.h"
#import "HStateC.h"
#import "HState.h"

@interface HStateC ()

@end

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
- (HStateC *)init:(id)identifier msm:(StateManager *)msm nm:(NSString *)nm
{
    if ((self = [super init:identifier msm:msm nm:nm]))
    {
        self.stMgrs = [[NSMutableDictionary alloc] init];
        self.numStMgrs = 0;
        self.substates = [[NSMutableDictionary alloc] init];
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
    if (self.substates[id])
    {
        if ([self isKindOfClass:[HState class]])
        {
            NSLog(@"Trying to add a sub-state of '%@' with the same id (%@).", self.name, id);
        }
        else
        {
            NSLog(@"Trying to add a sub-state of '%@' with the same id (%@). Remember that all siblings (from any manager) must have a unique id.", self.name, id);
        }
    }
    
    // Check that we have the state's state manager within this state
    if (self.stMgrs[st.myStMgr.id] != st.myStMgr)
    {
        NSLog(@"State %@'s StateManager not found in container state %@'s State Manager list.", st.name, self.name);
    }
    
    self.substates[id] =  st;
}

/**
 * Deletes memory associated with this state.
 * @method removeState
 */
- (void)removeState
{
    [super removeState];
    for (State *s in self.substates)
    {
        [s removeState];
    }
    
    self.substates = nil;
}

/**
 * isSubstate allows the caller to ask if a state is a substate of the state being called. It returns true if it
 * is a substate, false if it is not.
 * @method isSubstate
 * @param       st
 */
- (BOOL)isSubstate:(State *)st
{
    return self.substates[st.id];
}

/**
 * Allows the developer to specify the default start state for a given sub-network.
 * <p>The default start state is specified in the State Manager.  This routine lets the developer
 * specify the start state for this manager.  The same can be done in the StateManager constructor,
 * but this may be a more convenient way to do it.</p>
 * <p>Ordinarily, we could retrieve the manager from the state id alone, but the developer may not have created the state yet.</p>
 * @method setDefaultStartState
 * @param id    String identifier for the state
 * @param mgr   Parameter specifying the manager of the sub-state.  It is declared as optional so that HState (a child class) does not have to require the manager.  For HStateC's, you need to specify which manager is managing the state to make default start.
 */
- (void)setDefaultStartState:(NSString *)id mgr:(StateManager *)mgr
{
    // NSString *i;   // unused variable
    
    if  (!mgr)
    {
        NSLog(@"For %@ (an HStateC), you must supply the manager of state %@.", self.name, id);
    }
    else if (self.stMgrs[mgr.id] != mgr)
    {
        NSLog(@"The manager you supplied %@, is not a manager of state %@.", mgr, self.name);
    }
    
    mgr.defSt = id;
}

/**
 * Adds the specified state manager (StateManager) to this state.
 * <p>The State Manager keeps track of the active state within a sub-network.  Once you have created a new instance of
 * a StateManager, you pass that instance pointer into this routine.
 * State manager id's must be unique among sibling managers.  By convention, state manager id's are alphabetic, though
 * in this implementation, we make identifiers as Strings.</p>
 * @method addStateManager
 * @paramsm     State manager pointer that will control this HStateC's network of states.
 */
- (void)addStateManager:(StateManager *)sm
{
    NSString *id = sm.id;
    
    if (!self.stMgrs[id])
    {
        self.stMgrs[id] = sm;
    }
    else
    {
        // defined already -- issue warning
        NSLog(@"Add State Manager Error: duplicate ID (%@) for state '%@'.", id, self.name);
    }
    
    self.numStMgrs++;
}

/**
 * Goes through substates to register them with the state engine.
 * @method registerSubStates
 * @private
 */
- (void)registerSubStates:(StateEngine *)stateEng
{
    [super registerSubStates:stateEng];
    
    // Go through all the substates and register them. We don't care which sub-network they belong to,
    // as the purpose is just to get a state engine pointer and a unique state id off each state.
    for (NSString *id in self.substates)
    {
        [self.substates[id] registerSubStates:stateEng];
    }
}

/**
 Called when a state is entered.  This routine is for internal use, not for developers
 to override for executing actions on entry.  'hist' is true to use state history, false to use
 default start state.
 When we're told to jump into a specific sub-state, we don't want to allow the default start state or
 the history to get invoked.  'specIDs' tells us which sub-state, if not == null, we're jumping into.
 Therefore, for the state manager of that sub-state, we call activate() with this special
 sub-state id.
 @method enter
 @param hist
 @param specIDs
 @private
 */
- (void)enter:(BOOL)hist specIDs:(NSMutableArray *)specIDs
{
    NSString *curMgrID;
    StateManager *jsm;
    StateManager *sm;
    
    // Fire off entry actions and Start any state activities
    [super enter:nil specIDs:nil];
    
    // If this is a special jump, record which state manager not to activate with default start state
    if (specIDs)
    {
        jsm = [self.substates[specIDs[0]] myStMgr];
    }
    
    // Activate all the state managers, except for the special one dictated by the jump (if specIDs is non-null).
    // Arbitrarily, we activate all the state managers
    // (and consequently their lower level states) before we activate the state manager
    // along the branch that contains the special ids (state path).
    for (curMgrID in self.stMgrs)
    {
        sm = self.stMgrs[curMgrID];
        if (!sm)
        {
            NSLog(@"ERROR: State Manager id = %@ of state %@ is null. Did you delete the manager somewhere?", curMgrID, self.name);
        }
        
        if (!specIDs)
        {
            [sm activate:hist specIDs:nil];
        }
        else if (jsm != sm)
        {
            // history only applies to the last state on the path we're taking on specIDs, so
            // if we're activating a state manager not on this path, don't pass along the history flag.
            // We don't pass along specIDs because this manager does not manage that state (that state is managed by the manager in jsm).
            [sm activate:NO specIDs:nil];
        }
    }
    
    // If there are any other managers, and the caller has given a specific list of states to activate (contravening the default start usage),
    // now we activate that network with the state on the head of the list
    if (specIDs)
    {
        [jsm activate:hist specIDs:specIDs];
    }
}

/**
 * @private
 */
- (void)leave
{
    for (NSString *mgrID in self.stMgrs)
    {
        [self.stMgrs[mgrID] deactivate];
    }
    
    [super leave];
}

/**
 * @private
 */
- (void)resetHistory
{
    // tell managers to reset history
    for (NSString *mgrID in self.stMgrs)
    {
        [self.stMgrs[mgrID] resetHistory];
    }
}

/**
 * Given an identifier, create a new sub-state that is a simple state (State).
 * <p>If a manager has already been declared, use it.  Otherwise, create a new manager.  If we create a new manager,
 * the developer must use <code>setDefaultStartState</code> to initialize the default start state.</p>
 * @param sid   state identifier for the sub-state
 * @param mgr   Manager for the sub-state's network.  We set it as optional so HState users don't need to provide it, but for sub-networks of HStateC's, it is required.
 * @param name  Optional display name for the state.  If not provided, we use the state id.
 */
- (State *)addSubState:(NSString *)sid mgr:(StateManager *)mgr name:(NSString *)name
{
    State *newState = [[State alloc] init:sid msm:[self verifyManagerForStateCreation:sid mgr:mgr] nm:name];
    
    return newState;
}

/**
 * Given an identifier, create a new sub-state that is a hierarchical state (HState).
 * <p>If a manager has already been declared, use it.  Otherwise, create a new manager.  If we create a new manager,
 * the developer must use <code>setDefaultStartState</code> to initialize the default start state.</p>
 * @param sid   state identifier for the sub-state
 * @param mgr   Manager for the sub-state's network.  We set it as optional so HState users don't need to provide it, but for sub-networks of HStateC's, it is required.
 * @param name  Optional display name for the state.  If not provided, we use the state id.
 */
- (HState *)addSubHState:(NSString *)sid mgr:(StateManager *)mgr name:(NSString *)name
{
    HState *newHState = [[HState alloc] init:sid msm:[self verifyManagerForStateCreation:sid mgr:mgr] nm:name];
    
    return newHState;
}

/**
 * Given an identifier, create a new sub-state that is a concurrent, hierarchical state (HStateC).
 * <p>If a manager has already been declared, use it.  Otherwise, create a new manager.  If we create a new manager,
 * the developer must use <code>setDefaultStartState</code> to initialize the default start state.</p>
 * @param sid   state identifier for the sub-state
 * @param mgr   Manager for the sub-state's network.  We set it as optional so HState users don't need to provide it, but for sub-networks of HStateC's, it is required.
 * @param name  Optional display name for the state.  If not provided, we use the state id.
 *
 */
- (HStateC *)addSubHStateC:(NSString *)sid mgr:(StateManager *)mgr name:(NSString *)name
{
    HStateC *newHStateC = [[HStateC alloc] init:sid msm:[self verifyManagerForStateCreation:sid mgr:mgr] nm:name];
    
    return newHStateC;
}

/**
 * Routine checks to see if the proper manager is supplied.  If not, and the state is an HState, we create
 * the manager.  Otherwise we go through checks to ensure caller is using the correct manager.
 * @private
 */
- (StateManager *)verifyManagerForStateCreation:(NSString *)sid mgr:(StateManager *)mgr
{
    NSString *i;
    StateManager *sm = nil;
    
    // 'mgr' is required for HStateC's
    if (!mgr)
    {
        if (![self isKindOfClass:[HState class]])
        {
            NSLog(@"ObjCStEng: You must supply a manager to add state %@ as a sub-state of state %@.", sid, self.name);
        }
        else
        {
            // This is an HState, so retrieve the state manager.
            for (i in self.stMgrs)
            {
                sm = self.stMgrs[i];
            }
            // if no manager has been created yet, sn == null
            if (!sm)
            {
                // automatically create a manager for an HState sub-state
                sm = [[StateManager alloc] init:[NSString stringWithFormat:@"<%@ MANAGER>", self.id] containerState:self defaultState:nil n:nil];
            }
        }
    }
    else
    {
        if ([self.stMgrs objectForKey:mgr.id] != mgr)
        {
            NSLog(@"ObjCStEng: You are trying to add a sub-state to a manager %@ that is not a manager of this state %@.", mgr.name, self.name);
        }
        else
        {
            sm = mgr;
        }
    }
    
    return sm;
}

@end
