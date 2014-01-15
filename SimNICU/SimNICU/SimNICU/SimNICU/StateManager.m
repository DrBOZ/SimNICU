//
//  StateManager.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "StateManager.h"
#import "StateEngine.h"
#import "Transition.h"
#import "HState.h"
#import "State.h"

@interface StateManager ()

- (void)activate:(BOOL)hist specIDs:(NSMutableArray *)specIDs;

@end

@implementation StateManager

/**
 Constructor for State (network) Manager.  One StateManager is required to manage the
 network of each HState, or each sub-network of an HStateC.
 @method new StateManager
 @param identifier       String identifier (id) for the state manager.  Identifier must be unique only for sibling managers in an HStateC.
 @param containerSt      Pointer to state containing this manager.  'null' if this is manager at state engine (top) level.
 @param defaultSt        Default start state (use the State's id).  It is optional here, but if not given here, the developer must specify one with <code>setDefaultState()</code>.
 @param n                        State manager name (optional).  Used for display purposes only.  If no name passed in, routines use id.
 */
- (StateManager *)init:(NSString *)identifier containerState:(HStateC *)containerState defaultState:(NSString *)defaultState n:(NSString *)n
{
    self.id = identifier;
    
    if (!n)
    {
        self.name = self.id;
    }
    else
    {
        self.name = n;
    }
    
    self.defSt = defaultState;
    
    self.contSt = (HStateC *)containerState;
    
    self.cs = nil;
    
    self.lastSt = nil;
    
    // Register this state manager with the state network
    if (containerState)
    {
        [containerState addStateManager:self];
    }
    
    return self;
}

/**
 * Called when the state engine activates the state network that we (this state manager)
 * manage.  Our job is to activate the network by entering a state.  We can either
 * <li>Enter the default start state;</li>
 * <li>Enter the state that was current before we were last deactivated (history mechanism);</li>
 * <li>Enter a specific state as given by specIDs.</li>
 *
 * <p>If hist is true, we should enter the state most recently visited (lastSt). If false,
 * enter the default start state (defSt). If specIDs is present (not null), we ignore
 * the default start state, we ignore the hist flag, and specIDs is an array of state id's,
 * with the first element being the numeric id of the state we're supposed to enter.
 * This is to handle transitions that span state levels.</p>
 * @method activate
 * @param hist Whether or not to enter the state most recently visited
 * @param specIDs If present (not null), this is an array of state ID's to enter.  This overrides the default start state for the state.
 * @private
 */
- (void)activate:(BOOL)hist specIDs:(NSMutableArray *)specIDs
{
    self.active = YES;
    
    State *ns;
    
    // determine which state to start in. If specIDs is non-null, use it
    if (specIDs)
    {
        // Take off the first state in the state path.  This is for our level.
        self.cs = specIDs[0];
        [specIDs removeObjectAtIndex:0];
        if (specIDs.count == 0)
        {
            specIDs = nil;
        }
    }
    else
    {
        // Use the history mechanism if caller wants, otherwise use default start state
        if (hist && self.lastSt)
        {
            self.cs = self.lastSt;
        }
        else if (!self.defSt)
        {
            NSLog(@"Default start state not defined for state network managed by %@.", self.name);
        }
        else
        {
            self.cs = self.defSt;
        }
        
        // Clear the hist value because we just used it if we were supposed to
        hist = NO;
    }
    
    // If last state visited is undefined, set it to the current state so we don't lose track of the last state visited
    if (!self.lastSt)
    {
        self.lastSt = self.cs;
    }
    
    // Retrieve appropriate state to enter then do the deed!
    if (!self.contSt.substates[self.cs])
    {
        NSLog(@"ObjCStEng: Manager %@ was told to start in state %@ but it does not exist as a substate of %@.", self.name, self.cs, self.contSt.name);
    }
    
    ns = self.contSt.substates[self.cs];
    [ns enter:hist specIDs:specIDs];
}

/**
 Called when the network this state manager manages is deactivated (because
 the state engine has left the state that contains us).
 @method deactivate
 @private
 */
- (void)deactivate
{
    State *sp;
    
    if (self.active && !self.cs)
    {
        sp = self.contSt.substates[self.cs];
        [sp leave];
        // Record last state entered before we get deactivated
        self.lastSt = self.cs;
        self.active = NO;
        // Reset current state
        self.cs = nil;
    }
}

/**
 * Walks through the states controlled by this manager and sub-managers
 * and clears the history variable (lastSt) so that next time through this state network,
 * the last state visited will be undefined.
 * @method resetHistory
 * @private
 */
- (void)resetHistory
{
    // StateManager *smp;
    HStateC *sp;
    
    // if history mechanism is still null, meaning no one has entered this state yet, don't waste time resetting sub-network
    if (!self.lastSt)
    {
        return;
    }
    self.lastSt = nil;
    
    for (NSString *id in self.contSt.substates)
    {
        sp = self.contSt.substates[id];
        
        if ([sp isKindOfClass:[HStateC class]])
        {
            for (NSString *id in sp.stMgrs)
            {
                [sp.stMgrs[id] resetHistory];
            }
        }
    }
}

/**
 * Changes the current state (managed by this manager) based on the given transition ID.
 * <p>In most circumstances, the engine handles triggering transitions based on injected events.  In some rare situations,
 * developers may want to trigger a transition manually.  There is a method of State called <code>chgSt()</code>, which
 * triggers the transition specified by the given transition identifier.  Similarly, the StateManager chgSt() can be used
 * to trigger a transition (identifier of the current state).</p>
 * @method chgSt
 * @param transID Transition ID to use for current state
 * @param val an optional argument that is passed to the transition function
 */
- (void)chgSt:(Transition *)trans val:(id)val
{
    HStateC *stp;
    NSMutableArray *cpyStPath;
    StateManager *nsm;
    StateManager *sm;
    // NSString *tmpcs;
    NSMutableDictionary *mgrs;
    NSString *sid;
    StateManager *curSubStateMgr;
    
    int i;
    
    NSMutableDictionary *statesByID = trans.source._se.statesByID;
    HStateC *hstp;
    
    if (!self.active)
    {
        NSLog(@"Trying to change states through <manager %@>.", self.name);
    }
    
    // Steps:
    // 1. Leave current state
    // 2. Execute transition actions
    // 3. Enter new state
    // RETRIEVE TRANSITION ACTIONS
    if (!trans)
    {
        NSLog(@"'null' transition given to chgSt()");
    }
    else
    {
        if (!self.contSt)
        {
            // We're at top of state engine
            stp = trans.source._se.topState;
        }
        else
        {
            stp = self.contSt.substates[self.cs];
        }
        
        // If there is a path to traverse, copy the contents to a new array because we
        // will progressively delete from the array we pass as transitions occur.
        cpyStPath = [[NSMutableArray alloc] init];
        for (i = 0; i < trans.stPath.count; i++)
        {
            [cpyStPath addObject:trans.stPath[i]];
        }
        
        // LEAVE CURRENT STATE and any ancestors up to common parent state manager
        if (trans.upLvls > 0)
        {
            nsm = [self passUp:trans.upLvls transToAncestorHist:(trans.hist && cpyStPath.count == 0)];
            mgrs = [[NSMutableDictionary alloc] init];
            mgrs[nsm.id] = nsm;
        }
        else
        {
            // upLvls == 0 (meaning to transition to a sibling state) or -1 (meaning to transition within this state). We have
            // to ensure that we leave the current state ONLY if target is outside (upLvls == 0)
            nsm = self;
            
            // if upLvls == 0, we know we're transitioning to a sibling state if the state path (cpyStPath) is non-null. Therefore,
            // mark the current state as the last state visited. If the condition is not true, we are either heading to history
            // in which case we don't want to mark the current state as the last state), or we're descending into this state,
            // as so operation should not change this manager's record of last state.
            if (trans.upLvls == 0 && cpyStPath.count > 0)
            {
                nsm.lastSt = stp.id;
            }
            
            // upLvls == 0 means target is at same level as current state. -1, which means target is within current state
            if (trans.upLvls == 0)
            {
                [stp leave];
                
                // If we should go to history, we don't want to register the current state as the last state or else
                // we would always re-enter the current state. If we are not going to history, we record the current
                // state as the last state.
                if (trans.hist == NO)
                {
                    stp.myStMgr.lastSt = self.cs;
                }
                stp.myStMgr.cs = nil;
                mgrs = [[NSMutableDictionary alloc] init];
                mgrs[nsm.id] = nsm;
            }
            else
            {
                // upLvls must be -1, which means we have to be transitioning somewhere into the current state. This also
                // means that cpyStPath must be non-null or it is a transition to history.
                if (cpyStPath.count > 0)
                {
                    // We have to see if the transition is supposed to go down a sibling sub-state rather than the current sub-state. If
                    // it goes down the current sub-state, we don't re-enter that state. If it goes down a sibling sub-state, we have
                    // to leave the current sub-state
                    for (sid in stp.substates)
                    {
                        HStateC *aHStateC = stp.substates[sid];
                        
                        if (aHStateC.id == cpyStPath[0])
                        {
                            sm = aHStateC.myStMgr;
                            if (sm.cs == cpyStPath[0])
                            {
                                // The transition is going into a state which is already current. Follow the cpyStPath down to make
                                // sure we're leaving states that the transition is not going to go through.
                                i = 1;
                                while (i < cpyStPath.count && [statesByID[cpyStPath[i]] isActive])
                                {
                                    i++;
                                }
                                
                                // If we don't see as active all the way to the target state, then leave those states. If
                                // we get to the target state through the cpyStPath and all are active, we don't want to leave (target
                                // is already current). However, if it's a transition to history, we need to do something special --
                                // we need to leave whatever the current sub-state is and go to the last state visited (history), so
                                // we have to leave the current sub-state.
                                if (i < cpyStPath.count)
                                {
                                    curSubStateMgr = [statesByID[cpyStPath[i]] myStMgr];
                                    [statesByID[curSubStateMgr.cs] leave];
                                    curSubStateMgr.lastSt = curSubStateMgr.cs;
                                    curSubStateMgr.cs = nil;
                                }
                                else if (trans.hist)
                                {
                                    hstp = statesByID[cpyStPath[cpyStPath.count - 1]];
                                    for (StateManager *smp in hstp.stMgrs)
                                    {
                                        [statesByID[smp.cs] leave];
                                        smp.cs = nil;
                                    }
                                }
                            }
                            else
                            {
                                // The transition must take us into a different sub-state from what is current, so leave the current sub-state
                                [statesByID[sm.cs] leave];
                                sm.lastSt = self.cs;
                                sm.cs = nil;
                            }
                            break;
                        }
                    }
                    
                    nsm = [statesByID[cpyStPath[0]] myStMgr];
                }
                else
                {
                    // No more info on which state to go to, so pass message to all managers of substates (only legal move here is a transition to history
                    mgrs = [[NSMutableDictionary alloc] init];
                    if ([stp isKindOfClass:[State class]])
                    {
                        NSLog(@"Logic error in State Manager chgSt() for manager id %@. Preparing to enter a sub-state of %@ but it is not hierachical.", self.id, stp.id);
                    }
                    
                    if (!trans.hist)
                    {
                        NSLog(@"Logic error in State Manager chgSt() for manager id %@. Transition within current state is not to history nor has a descent path.", self.id);
                    }
                    
                    for (sid in stp.substates)
                    {
                        if (!mgrs[sid])
                        {
                            mgrs[sid] = [stp.substates[sid] myStMgr];
                            // Since the transitions have to be in history, we check to see if the current sub-state is the same as the last state visited, which will be entered.
                            // If so, we don't leave the state since we're headed right back in. If the last state visited is different from the current sub-state, we leave
                            // the current sub-state
                            if ([mgrs[sid] lastSt] != [mgrs[sid] cs])
                            {
                                [statesByID[[mgrs[sid] cs]] leave];
                            }
                        }
                    }
                }
            }
        }
        
        // EXECUTE TRANSITION ACTIONS
        if (trans.xFn)
        {
            // trans.xFn(val); AS3
        }
        
        // now have to follow state path downward
        if (cpyStPath.count == 0)
        {
            for (sid in mgrs)
            {
                [mgrs[sid] passDown:cpyStPath hist:trans.hist sep:stp._se];
            }
        }
        else
        {
            [nsm passDown:cpyStPath hist:trans.hist sep:stp._se];
        }
    }
}

/**
 * Used by chgSt() to effect the transition to a state whose common
 * ancestor/parent with the current state is above the current state manager.
 * Called when state transition causes us to leave our level and some
 * number of levels above us.  Go up the state network, leaving each container
 * state, until we reach the appropriate level.  Return the state manager at this level.
 * @method passUp
 * @param upLvls Number of levels to ascend to reach least common ancestor
 * @access private
 */
- (StateManager *)passUp:(int)upLvls transToAncestorHist:(BOOL)transToAncestorHist
{
    StateManager *nsm = self;
    
    while (upLvls > 0)
    {
        [nsm.contSt leave];
        upLvls--;
        // The container state's network is now in limbo as we've left the current
        // state. We put it in limbo so that if a parent manager tries to deactivate
        // concurrent states, our network will not be re-"leave"d.
        if (upLvls == 0 && transToAncestorHist == NO)
        {
            // If we are at the top of where we're supposed to be and we're told to go to the history
            // of the state above us, don't set the last state property since we want to use the true last state
            nsm.contSt.myStMgr.lastSt = nsm.contSt.myStMgr.cs;
        }
        nsm.contSt.myStMgr.cs = nil;
        nsm = nsm.contSt.myStMgr;
        if (!nsm)
        {
            NSLog(@"passUp reached top of state network but was told to go higher. This is logic error in Transition processing");
        }
    }
    
    return nsm;
}

/**
 * Used by chgSt() and passUp() to make transitions that jump to levels
 * within a sibling state but below the current level.
 * @method passDown
 * @param stPath
 * @param hist
 * @private
 */
- (void)passDown:(NSMutableArray *)stPath hist:(BOOL)hist sep:(StateEngine *)sep
{
    HStateC *stp;
    
    if (!stPath && stPath.count == 0)
    {
        stPath = nil;
        if (hist == NO)
        {
            stp = self.contSt.substates[self.defSt];
        }
        else
        {
            stp = self.contSt.substates[self.lastSt];
        }
        stp.myStMgr.cs = stp.id;
        [stp enter:hist specIDs:nil];
    }
    else
    {
        if (!self.contSt)
        {
            // We're at the top of the state network, so the manager has no container state
            stp = sep.statesByID[stPath[0]];
        }
        else
        {
            stp = self.contSt.substates[stPath[0]];
        }
        
        [stPath removeObjectAtIndex:0];
        if (stPath.count == 0)
        {
            // We've reached the right level, so if this state is not active already, enter it
            if (![stp isActive])
            {
                stp.myStMgr.cs = stp.id;
                [stp enter:hist specIDs:nil];
            }
            else if (hist)
            {
                // Tell stp's managers to activate
                for (StateManager *ssm in stp.stMgrs)
                {
                    if (!ssm.lastSt)
                    {
                        ssm.cs = ssm.defSt;
                        ssm.lastSt = nil;
                    }
                    else
                    {
                        NSString *tmpSt = ssm.cs;
                        ssm.cs = ssm.lastSt;
                        ssm.lastSt = tmpSt;
                    }
                    [stp._se.statesByID[ssm.cs] enter:NO specIDs:nil];
                }
            }
        }
    }
}


/**
 * Adds a simple state (State) to the network that this manager manages.
 * Developers can call this routine or create a State using 'new'.
 * @param       id      Unique identifier for this state, unique across all states.
 * @param       nm      Optional display name for the state.  If not supplied, engine use id.
 * @return
 */
- (State *)addState:(NSString *)id nm:(NSString *)nm
{
    State *newState = [[State alloc] init:id msm:self nm:nm];
    
    return newState;
}

/**
 * Adds a hierarchical state (HState) to the network that this manager manages.
 * Developers can call this routine or create a State using 'new'.
 * @param       id      Unique identifier for this state, unique across all states.
 * @param       nm      Optional display name for the state.  If not supplied, engine use id.
 * @return
 */
- (HState *)addHState:(NSString *)id nm:(NSString *)nm
{
    HState *newHState = [[HState alloc] init:id msm:self nm:nm];
    
    return newHState;
}

/**
 * Adds a concurrent, hierarchical state (HStateC) to the network that this manager manages.
 * Developers can call this routine or create a State using 'new'.
 * @param       id      Unique identifier for this state, unique across all states.
 * @param       nm      Optional display name for the state.  If not supplied, engine use id.
 * @return
 */
- (HStateC *)addHStateC:(NSString *)id nm:(NSString *)nm
{
    HStateC *newHStateC = [[HStateC alloc] init:id msm:self nm:nm];
    
    return newHStateC;
}

@end
