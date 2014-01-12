//
//  StateManager.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "StateManager.h"
#import "Transition.h"
#import "HState.h"

@interface StateManager ()

- (void)activate:(BOOL)hist specIDs:(NSMutableArray *)specIDs;

@end

@implementation StateManager

- (StateManager *)initWithIdentifier:(NSString *)identifier containerState:(HStateC *)containerState defaultState:(NSString *)defaultState name:(NSString *)n
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
    
    // conSt = HStateC(containerState);  AS3 code
    self.contSt = containerState;
    
    self.cs = nil;
    
    self.lastSt = nil;
    
    // Register this state manager with the state network
    if (containerState)
    {
        // containerState.addStateManager(this); AS3 code
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
            // throw new Error("Default start state not defined for state network managed by " + name);
        }
        else
        {
            self.cs = self.defSt;
        }
        
        // Clear the hist value because we just used it if we were supposed to
        hist = nil;
    }
    
    // If last state visited is undefined, set it to the current state so we don't lose track of the last state visited
    if (!self.lastSt)
    {
        self.lastSt = self.cs;
    }
    
    // Retrieve appropriate state to enter then do the deed!
    if (!self.contSt.substates[self.cs])
    {
        // throw new Error("Manager " + name + " was told to start in state " + cs + " but it does not exist as a substate of " + contSt.name);
    }
    
//    ns = self.contSt.substates[self.cs];      AS3 code
//    ns.enter(hist, specIDs);
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
//        sp = this.contSt.substates[cs];
//        sp.leave();
//        // Record last state entered before we get deactivated
//        this.lastSt = cs;
//        active          = false;
//        // Reset current state
//        cs = null;
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
    // code
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
    // code
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
    State *newState = [[State alloc] initWithStateName:nm uniqueID:id stateManager:self];
    
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
    HState *newHState = [[HState alloc] initWithIdentifier:id stateManager:self name:nm];
    
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
    HStateC *newHStateC = [[HStateC alloc] initWithIdentifier:id stateManager:self name:nm];
    
    return newHStateC;
}

@end
