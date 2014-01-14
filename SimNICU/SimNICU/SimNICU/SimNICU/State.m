//
//  State.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "PulseActivity.h"
#import "EventWithData.h"
#import "StateManager.h"
#import "StateEngine.h"
#import "Transition.h"
#import "HStateC.h"
#import "HState.h"
#import "State.h"

@interface State ()
{
    NSMutableDictionary *transitionEvents;   // List of Events that trigger transition for this state
    EventWithData *entryEvent;
    EventWithData *leaveEvent;
    NSHashTable *hashTable;
}

- (void)startStateActivities;
- (void)leave;
- (void)stopStateActivities;
- (Transition *)addTransitionInstance:(NSString *)targetStateID tEvtName:(NSString *)tEvtName transFn:(SEL)transFn doHistory:(BOOL)doHistory ulfst:(NSInteger)ulfst;

@end

@implementation State

/**
 The constructor for the state class.  Pass in a name, an ID (typically numeric),
 and a pointer to the state network manager.  If this state is the topmost in the
 whole network, the manager is <code>null</code>.
 @method new State
 @param identifier       State identifier (id).  Must be unique among all states in the state engine.
 @param msm                      Pointer to a state manager, or null if this state is topmost
 @param nm                       Display name of the State.  If null (not supplied), routines use the id for the display name.
 */
- (id)init:(NSString *)identifier msm:(StateManager *)msm nm:(NSString *)nm
{
    if((self = [super init]))
    {
        // sets the state's unique identifier.
        self.id = identifier;
        
        // sets the state's name
        if (!nm) self.name = identifier;
        else self.name = nm;
        
        // sets the state's state manager
        self.myStMgr = msm;
        
        // msm.contSt
        if (msm && [msm.contSt isKindOfClass:[HStateC class]])
        {
            [msm.contSt addAsSubState:self];
        }
        
        self.transitions = nil;
        self.pulseActivities = nil;
        
        // entryEvent = new EventWithData(State.ENTRY, false, false, { stateName: "", stateID : "0" } );
        entryEvent = [[EventWithData alloc] initWithType:ENTRY bubbles:NO cancelable:NO dataInit:nil];
        
        // leaveEvent = new EventWithData(State.LEAVE, false, false, { stateName: "", stateID : "0" } );
        leaveEvent = [[EventWithData alloc] initWithType:LEAVE bubbles:NO cancelable:NO dataInit:nil];
        
        transitionEvents = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

/**
 * Deletes memory associated with this state.
 * @method removeState
 */
- (void)removeState
{
    if (self.transitions)
    {
        for (NSString *targetID in self.transitions)
        {
            [self.transitions removeObjectForKey:targetID];
        }
        
        self.transitions = nil;
    }
    
    if (self.pulseActivities)
    {
        for (int i = 0; i < self.pulseActivities.count; i++)
        {
#warning logic needs checking...
            // may have to do this backwards
            // i.e. for (int i = self.pulseActivties.count - 1
            
            [self removePulseActivity:self.pulseActivities[i]];
            [self.pulseActivities removeObjectAtIndex:i];
        }
    }
    
    entryEvent = nil;
    leaveEvent = nil;
    
    if (transitionEvents)
    {
        for (NSString *evtType in transitionEvents)
        {
            [transitionEvents removeObjectForKey:evtType];
        }
        
        transitionEvents = nil;
    }
}

/**
 Called when the state is entered.  This is a private routine and should not be
 overriden by developers.
 @method enter
 @access private
 */
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
 @access private
 */
- (void)enter:(BOOL)hist specIDs:(NSMutableArray *)specIDs
{
    // only put leaf states (State, not HStateC nor HState) into the master list of active states
    if (![self isKindOfClass:[HStateC class]])
    {
#warning logic error here
        // self._se.activeStates ob
        self._se.activeStates[self.id] = [NSNumber numberWithBool:YES];
    }
    
    if ([self hasEventListener:ENTRY])
    {
#warning code required
        // entryEvent.data.stateName  = self.name;
        // entryEvent.data.stateID    = self.id;
        [self dispatchEvent:entryEvent];
    }
    
    [self startStateActivities];
}

/**
 This event is generated upon entering a specified state if the developer has registered
 a state on-entry notice using <code>addEventListener()</code>.
 @event State.ENTRY
 */

/**
 This event is generated upon leaving a specified state if the developer has registered
 a state on-leave notice using <code>addEventListener()</code>.
 @event State.LEAVE
 */

/**
 Start any pulse state activities for this state.
 @method startStateActivities
 @access private
 */
- (void)startStateActivities
{
    // Start any pulse activities for this state
    if (self.pulseActivities)
    {
        for (int i = 0; i < self.pulseActivities.count; i++)
        {
            [(PulseActivity *)self.pulseActivities[i] start];
        }
    }
}

/**
 Called when the state is exited (deactivated).  This is a private routine and should not be
 overriden by developers.
 @method leave
 @access private
 */
- (void)leave
{
    [self._se.activeStates removeObjectForKey:self.id];
    
    [self stopStateActivities];
    
    if ([self hasEventListener:LEAVE])
    {
#warning code required
        // leaveEvent.data.stateName  = self.name;
        // leaveEvent.data.stateID    = self.id;
        [self dispatchEvent:leaveEvent];
    }
}

/**
 Stops any pulse state activities for this state.
 @method stopStateActivities
 @access private
 */
- (void)stopStateActivities
{
    // turn off mode pulse activities
    if (self.pulseActivities)
    {
        for (int i = 0; i < self.pulseActivities.count; i++)
        {
            [self.pulseActivities[i] stop];
        }
    }
}

/**
 <p>Change state using transition trans_i, with an optional value for the
 transition function as a second argument.
 If you look at the code, this function passes the information
 to the chgSt method of the state manager to do the real work.  The reason we define
 this dummy is so that modelers see the direct relationship to the transition id,
 which is unique by state.  For example, if a caller wants to change the current state,
 state 2, using transition 0, the caller would write:</p>
 <code>state2.chgSt(0);</code>
 <p>This implies that the transition 0 is relative to the state.  The same unaltered call
 would be</p>
 <code>sm.chgSt(0);</code>
 <p>in which 'sm' is the state manager of state 2 and its siblings.  It is less obvious from the
 second form that the processor is using the current state (2)'s transition 0, as opposed
 to, perhaps, state 1 or 6's transition with id 0.</p>
 <p>The second argument, val, is an optional value to send in to the transition function.</p>
 @method chgSt
 @param transID
 @param val
 */
- (void)chgSt:(Transition *)trans val:(NSMutableDictionary *)val
{
    if (![trans.source.id isEqualToString:self.myStMgr.cs])
    {
        NSLog(@"Called to change state from %@ but it is not active in this network currently.", trans.source.id);
    }
    else
    {
        [self.myStMgr chgSt:trans val:val];
    }
}

/**
 convenience function.  Returns true if this state is currently active,
 false if not.
 @method isActive
 @return True if the state is active, false if not.
 */
- (BOOL)isActive
{
    return [self.myStMgr.cs isEqualToString:self.id];
}

/**
 * Add a transition from this State to a target state other than history.
 * <p>Use this method to define a transition from one State to another.  If the target state is the same as the source, this method
 * exits the source and re-enters it.  If the developer wants to exit parent states, use <code>addTransitionToSelf</code> which allows
 * the developer to specify exactly how many levels to exit and re-enter.</p>
 * <p>To transition to the history pseudo-state, use <code>addTransitionToHistory</code>.</p>
 * <p>If the developer wants
 * to manually code the event handler, then the developer uses <code>chgSt()</code> to fire
 * this transition when it is triggered (just remember to hold onto the transition instance, which is the return value of this method).</p>
 * <p>By default, when the developer creates a transition with this method, the actual determination of transition path (through which nodes,
 * up/down how many levels, etc.) is postponed until the first activation of the State Engine.  This avoids the problem of defining a transition
 * to a state that does not exist yet, for example, when two states have reciprocal transitions.  However, if the developer has activated the
 * state engine already, or called the state engine's <code>prepareNetwork()</code>, he can add a transition and have its path resolved
 * immediately by first calling <code>transPtr = addTransition()</code>, then, calling <code>transPtr.determineTransition()</code>.</p>
 *
 * @method addTransitionToTarget
 * @param tEvtName                      Name of the event that triggers the transition (if null, then transition must be manually triggered with <State>.chgSt())
 * @param targetStateID         id of the target state
 * @param transFn                       An optional function to execute when the transition is fired
 */
- (Transition *)addTransitionToTarget:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn
{
    if ([self.id isEqualToString:targetStateID])
    {
        return [self addTransitionToSelf:tEvtName transFn:transFn ulfst:0];
    }
    else
    {
        return [self addTransitionInstance:targetStateID tEvtName:tEvtName transFn:transFn doHistory:NO ulfst:nil];
    }
}

/**
 * Add a transition from this State to itself, specifying parents to exit and re-enter.
 * <p>Use this method to transition out of the current state, up any number of parent state levels, then re-enter the state.</p>
 * <p>If the developer wants
 * to manually code the event handler, then the developer uses <code>chgSt()</code> to fire
 * this transition when it is triggered (just remember to hold onto the transition instance, which is the return value of this method).</p>
 * <p>By default, when the developer creates a transition with this method, the actual determination of transition path (through which nodes,
 * up/down how many levels, etc.) is postponed until the first activation of the State Engine.  This avoids the problem of defining a transition
 * to a state that does not exist yet, for example, when two states have reciprocal transitions.  However, if the developer has activated the
 * state engine already, or called the state engine's <code>prepareNetwork()</code>, he can add a transition and have its path resolved
 * immediately by first calling <code>transPtr = addTransition()</code>, then, calling <code>transPtr.determineTransition()</code>.</p>
 *
 * @method addTransitionToSelf
 * @param tEvtName                      Name of the event that triggers the transition (if null, then transition must be manually triggered with <State>.chgSt())
 * @param transFn                       An optional function to execute when the transition is fired
 * @param ulfst                         (abbrev. "up levels for self transition") For a transition to self, this value says how many levels to go up before coming back down.  The developer uses this to determine how many states to exit and re-enter.
 */
- (Transition *)addTransitionToSelf:(NSString *)tEvtName transFn:(SEL)transFn ulfst:(NSInteger)ulfst
{
    return [self addTransitionInstance:self.id tEvtName:tEvtName transFn:transFn doHistory:NO ulfst:ulfst];
}

/**
 * Add an 'external' transition, i.e., from this State to a target state.
 * <p>Use this method to transition out of the current state, up any number of parent state levels, then re-enter the path down towards the current state.</p>
 * <p>If the developer wants
 * to manually code the event handler, then the developer uses <code>chgSt()</code> to fire
 * this transition when it is triggered (just remember to hold onto the transition instance, which is the return value of this method).</p>
 * <p>By default, when the developer creates a transition with this method, the actual determination of transition path (through which nodes,
 * up/down how many levels, etc.) is postponed until the first activation of the State Engine.  This avoids the problem of defining a transition
 * to a state that does not exist yet, for example, when two states have reciprocal transitions.  However, if the developer has activated the
 * state engine already, or called the state engine's <code>prepareNetwork()</code>, he can add a transition and have its path resolved
 * immediately by first calling <code>transPtr = addTransition()</code>, then, calling <code>transPtr.determineTransition()</code>.</p>
 *
 * @method addTransitionExternal
 * @param tEvtName                      Name of the event that triggers the transition (if null, then transition must be manually triggered with <State>.chgSt())
 * @param targetStateID         id of the target state
 * @param transFn                       An optional function to execute when the transition is fired
 * @param ulfxt                         (abbrev. "up levels for external transition") For an external transition, this value says how many levels to go up before re-entering that topmost state.  The developer uses this to determine how many states to exit and re-enter.
 */
- (Transition *)addTransitionExternal:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn ulfxt:(NSInteger)ulfxt
{
    return [self addTransitionInstance:targetStateID tEvtName:tEvtName transFn:transFn doHistory:NO ulfst:ulfxt];
}

/**
 * Add a transition from the current state to the history pseudo-state of a state.
 * <p>The history pseudo-state is an automatic element part of an HState or HStateC.  Conceptually, a transition to history makes the
 * current state the last state visited in that state network.  Therefore, you specify the target state that <i>contains</i> the history
 * state.  For example, if you have three states in the same network, A, B, and C, and A is current but C was the last state visited,
 * you could add a transition from A -> history, and when that was triggered, the state engine would leave A and enter C.</p>
 * <p>If the developer wants
 * to manually code the event handler, then the developer uses <code>chgSt()</code> to fire
 * this transition when it is triggered (just remember to hold onto the transition instance, which is the return value of this method).</p>
 * <p>By default, when the developer creates a transition with this method, the actual determination of transition path (through which nodes,
 * up/down how many levels, etc.) is postponed until the first activation of the State Engine.  This avoids the problem of defining a transition
 * to a state that does not exist yet, for example, when two states have reciprocal transitions.  However, if the developer has activated the
 * state engine already, or called the state engine's <code>prepareNetwork()</code>, he can add a transition and have its path resolved
 * immediately by first calling <code>transPtr = addTransition()</code>, then, calling <code>transPtr.determineTransition()</code>.</p>
 *
 * @method addTransitionToHistory
 * @param tEvtName                      Name of the event that triggers the transition (if null, then transition must be manually triggered with <State>.chgSt())
 * @param targetStateID         id of the target state
 * @param transFn                       An optional function to execute when the transition is fired
 */
- (Transition *)addTransitionToHistory:(NSString *)tEvtName targetStateID:(NSString *)targetStateID transFn:(SEL)transFn
{
    return [self addTransitionInstance:targetStateID tEvtName:tEvtName transFn:transFn doHistory:YES ulfst:nil];
}

/**
 * Internal routine that captures transition.
 * We added convenience methods so it makes it easier for developers to specify the transition type, rather than filling in optional parameters.
 *
 * having to fill in optional parameters.
 * @param       targetStateID   id of the target state
 * @param       tEvtName                Name of the event that triggers the transition (if null, then transition must be manually triggered with <State>.chgSt())
 * @param       transFn                 An optional function to execute when the transition is fired
 * @param       doHistory               Whether or not to go to the history state
 * @param       ulfst                   For external transitions, how many states to go up and then re-enter downward
 * @return
 */
- (Transition *)addTransitionInstance:(NSString *)targetStateID tEvtName:(NSString *)tEvtName transFn:(SEL)transFn doHistory:(BOOL)doHistory ulfst:(NSInteger)ulfst
{
    if (!ulfst) ulfst = 0;
    
    Transition *trans;
    int i;
    
    if (!self.transitions)
    {
        self.transitions = [[NSMutableDictionary alloc] init];
    }
    
    if (tEvtName)
    {
        if ([tEvtName isEqualToString:ENTRY] || [tEvtName isEqualToString:LEAVE])
        {
            NSLog(@"ObjCStEng: You cannot register a transition to a StateEvent %@", tEvtName);
        }
        else if ([self hasEventListener:tEvtName])
        {
            NSLog(@"ObjCStEng: Trying to add a transition triggered by an event (%@) that is already registered to an internal action.", tEvtName);
        }
    }
    
    trans = [[Transition alloc] init:self tid:targetStateID tfn:transFn doHistory:doHistory upLevelsForExternalTransition:ulfst];
    
    if (![self.transitions objectForKey:targetStateID])
    {
        NSMutableArray *transitions = [[NSMutableArray alloc] init];
        [transitions addObject:trans];
        
        [self.transitions setObject:transitions forKey:targetStateID];
    }
    else
    {
        for (i = 0; i < self.transitions.count; i++)
        {
            if (([[[self.transitions objectForKey:targetStateID][i] targetID] isEqualToString:targetStateID]) && ([transitionEvents objectForKey:tEvtName]))
            {
                NSLog(@"Duplicate transition on same event name (%@) from %@ to %@", tEvtName, self.name, targetStateID);
            }
        }
        
        [[self.transitions objectForKey:targetStateID] addObject:trans];
    }
    
    [transitionEvents setObject:trans forKey:tEvtName];
    
    return trans;
}

/**
 * Remove the given transition from this State.
 * <p>Unhook the given transition from the source state.</p>
 * @method removeTransition
 * @param trans Transition instance to remove from source state.
 */
- (void)removeTransition:(Transition *)trans
{
    int ti;
    // int tei;
    BOOL foundTrans = NO;
    BOOL foundEvent = NO;
    
    for (ti = 0; ti < [[self.transitions objectForKey:trans.targetID] count]; ti++)
    {
        if (self.transitions[trans.targetID][ti] == trans) // might need isEqual
        {
            [self.transitions[trans.targetID] removeObjectAtIndex:ti];
            
            for (NSString *tn in transitionEvents)
            {
                if (transitionEvents[tn] == trans)
                {
                    [transitionEvents removeObjectForKey:tn];
                    foundEvent = YES;
                    break;
                }
            }
            
            foundTrans = YES;
            break;
        }
    }
    
    if (!foundTrans)
    {
        NSLog(@"Trying to remove a transition (from %@ to %@ that was not found on %@", trans.source.name, trans.targetID, self.name);
    }
    
    if (!foundEvent)
    {
        NSLog(@"Engine logic error in transition -- did not find transition in transitionEvents (from %@ to %@ on %@)", trans.source.name, trans.targetID, self.name);
    }
}

/**
 Use this method to add an activity to the state that fires at a specified interval.  You
 can specify a function or method to call. Note: if you need to refer to the timeline
 from within a function, use the last example to call your function.
 
 @method addPulseActivity
 @param intvl Interval, in milliseconds, between calls
 @param fnOrMet Function or method to invoke
 @example
 // For a function: myFunc
 myState.addPulseActivity(0, 500, myFunc);
 // For a method: myObj.myMethod
 myState.addPulseActivity(0, 500, myObj.myMethod);
 
 */
- (PulseActivity *)addPulseActivity:(NSInteger)intvl cb:(SEL)cb fb:(BOOL)fb
{
    PulseActivity *pa;
    
    if (!self.pulseActivities)
    {
        self.pulseActivities = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    // Check to see we're not adding a duplicate activity (same callback)
    for (int i = 0; i < self.pulseActivities.count; i++)
    {
        if ([self.pulseActivities[i] handler] == cb)
        {
            NSLog(@"Pulse Activity with that callback already exists for this state <%@>", self.name);
        }
    }
    
    pa = [[PulseActivity alloc] init:intvl origState:self cb:cb fb:fb];
    [self.pulseActivities addObject:pa];
    
    ASFunction *function = [[ASFunction alloc] initWithObject:nil method:cb];
    
    // pa.addEventListener(PulseActivity.TICK, cb, false, 0, true)  // AS3
    [pa addEventListener:@"TICK" listener:function useCapture:NO priority:0 useWeakReference:YES];
    
    return pa;
}

/**
 Removes the specified pulse activity from the state.
 @method removePulseActivity
 @param id ID of the activity
 */
- (void)removePulseActivity:(PulseActivity *)pa
{
    BOOL found = NO;
    
    if (!self.pulseActivities)
    {
        NSLog(@"No pulse activity on %@ with given Function.", self.name);
    }
    
    for (int i = 0; i < self.pulseActivities.count; i++)
    {
        if (self.pulseActivities[i] == pa)
        {
            [self.pulseActivities[i] prepareToRemove];
            [self.pulseActivities[i] removeObjectAtIndex:i];
            found = YES;
            break;
        }
    }
    
    if (!found)
    {
        NSLog(@"The given pulse activity was not found on state %@", self.name);
    }
}

/**
 <p>This is a new feature of FStEng v1.5, which provides an easy way to direct and process
 events.  Rather than having the developer provide an <code>ieh()</code> method, which
 determines the current state and which transitions or actions should be triggered, the
 new mechanism automatically routes the event to the most specific (deepest in network) active state's
 <code>onEvent</code> handler.  The handler, by default, looks through the triggers of
 the transitions and internal actions on the state.  If a trigger is true, it then fires
 the transition or action.  The default routine passes the event to the state's parent
 to check its transitions and actions as well.  If a transition gets fired, then parent
 states do not evaluate their transitions, but still evaluate their internal action
 triggers.</p>
 <p>This extra processing can add time because all triggers are checked in the chain of
 active states, regardless of their chance of success.  The beauty of this system is that
 if a state wants to optimize event handling for itself
 and its sub-networks, it merely needs to override <code>onEvent</code> and follow the
 rules about passing up the event once finished.  If you really need to optimize the
 event handling, you can still override <code>ieh()</code> and bypass this feature
 completely, and do it as described in our book.</p>
 @event onEvent
 */
- (BOOL)onEvent:(Event *)ev handledYet:(BOOL)handledYet  // new feature in FStEng v1.5
{
    HStateC *containingState;
    Transition *tt;
    // int tei;
    
    // Check internal actions
    // See if there are any listeners to handle this event
    if ([self hasEventListener:ev.type])
    {
        [self dispatchEvent:ev];
        handledYet = YES;
    }
    
    // Check transitions
    if (!handledYet)
    {
        // figure out if there's a transition to trigger
        if (transitionEvents[ev.type])
        {
            tt = transitionEvents[ev.type]; // value is the transition
            
            // v1.5
            // Take transition, if supposed to handle it. This mechanism makes highest
            // (outermost) transition take precedence over sub-state transitions. It also
            // makes sure that all internal actions are executed in higher-level states
            // before possibly leaving the state.
            if ([ev isKindOfClass:[EventWithData class]])
            {
                // this.chgSt(tt, EventWithData(ev).data);
#warning this needs fixing
                [self chgSt:tt val:nil];
            }
            else
            {
                [self chgSt:tt val:nil];
            }
            
            // indicate that transition was handled here
            handledYet = YES;
        }
        else
        {
            // For HStateC's, we only want to pass the event up once all the sub-networks
            // have had a chance to handle the event. Therefore, we keep track of how many
            // sub-networks have handled the event so far (using the _conEvCt object in the state engine)
            // which has a count of those sub-networks that has handled event to this point.
            // When that count reaches the # of state managers, we know it's the last one
            // and so we pass it up.
            //
            // Logically, since HState's are HStateC's, we don't need the if..else statement (the code would work
            // without the conditional, just using the code in the else block),
            // but if we are dealing with an HState, we can save a tiny bit of space and time by
            // not setting _concEvCt unnecessarily (since there is only one state manager for an HState).
            containingState = self.myStMgr.contSt;
            
            if ([containingState isKindOfClass:[HState class]])
            {
                handledYet = [containingState onEvent:ev handledYet:NO];
            }
            else if ([containingState isKindOfClass:[HStateC class]])
            {
#warning code required
//                if (this._se._concEvCt[contaningState] == undefined) {
//                    this._se._concEvCt[contaningState] = 1;
//                    contaningState.handledEvYet = handledYet;
//                } else {
//                    this._se._concEvCt[contaningState]++;
//                }
//                contaningState.handledEvYet = contaningState.handledEvYet || handledYet;
//                
//                if (this._se._concEvCt[contaningState] == HStateC(contaningState).numStMgrs) {
//                    handledYet = contaningState.onEvent(ev, contaningState.handledEvYet);
//                }
            }
        }
        
    }
    
    return handledYet;
}

- (void)resetHistory
{
    // History is stored in the manager, and a simple state does not have an internal manager, so we do nothing.
}

/**
 Goes through substates to register them with the state engine.
 @method registerSubStates
 @access private
 */
- (void)registerSubStates:(StateEngine *)stateEng
{
    self._se = stateEng;
    
    if (stateEng.statesByID[self.id])
    {
        NSLog(@"State ID's must be unique. State %@ and %@ cannot share id = %@", [stateEng.statesByID[self.id] name], self.name, self.id);
    }
    else
    {
        stateEng.statesByID[self.id] = self;
    }
}

/**
 * isSubstate allows the caller to ask if a state is a substate of the state being called. It returns true if it
 * is a substate, false if it is not.  For simple states, it always returns false since there are no substates.
 * @method isSubstate
 * @param       st
 */
- (BOOL)isSubstate:(State *)st
{
    return false;
}

@end
