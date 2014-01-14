//
//  StateEngine.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "StateManager.h"
#import "EventWithData.h"
#import "StateEngine.h"
#import "Transition.h"
#import "HStateC.h"

@interface StateEngine ()
{
    HStateC *stNet;             // topmost state in this engine's state network
    NSTimer *eventTimerDelay;
}

@property (nonatomic) BOOL handlingEvent; // true while an event is being processed, false otherwise
@property (nonatomic, strong) NSMutableArray *eventsWaiting; // Array of events waiting to be handled
@property (nonatomic, strong) EventWithData *unhandledEvent; // event object passed when there were no handlers for an event
@property (nonatomic, strong) StateManager *topLevelStateNetworkMgr; // state network's top manager
@property (nonatomic) BOOL networkPrepared; // true when network has already had state engine pointes set in states, and transitions resolved
@property (nonatomic) BOOL active;

- (void)setSubState2SE:(State *)stPtr;
- (BOOL)active;
- (void)activateAndResetHistory:(BOOL)resetHistory;
- (void)deactivate;
- (void)processEvents;
- (void)timeDelayElapsedForEvent:(Event *)event;

@end

@implementation StateEngine

/**
 * Creates a new instance of a state engine data structure.
 * <p>This is the constructor.  Make sure to hold onto the pointer to this somewhere safe (i.e., away from
 * the possibility that it will be garbage-collected).  For example, you typically will set the return value
 * to a property of an class instance in your application.  If you do not hold onto this, Flash may mark
 * the instance for garbage collection and your network could start acting strange.</p>
 *
 * @method new StateEngine
 * @param n                     Optional name (String) for the state engine.  Default is "State Engine".
 * @param stateNetwork  Optional top state (HState, HStateC, or State [under rare circumstances]) of the network.
 *                                              A top state is mandatory, but supplying it in the constructor is optional.  If you don't
 *                                              supply it here, you must use <code>setStateNetwork()</code> and pass in the top state.
 * @example <listing>  // this includes top state in instantiation<br>
 * se = new StateEngine("engine1", new HState("TOP CONTAINER STATE", 0));</listing>
 * @example <listing>// this assumes top state pointer will be supplied via setStateNetwork()<br>
 * se   = new StateEngine("engine1");</listing>
 */
- (StateEngine *)initWithName:(NSString *)n andStateNetwork:(HStateC *)stateNetwork
{
    if ((self = [super init]))
    {
        self.name = n;
        stNet = nil;
        self.active = NO;
        self.eventsWaiting = [NSMutableArray new];
        self.handlingEvent = NO;
#warning self.unhandledEvent needs setting
        self.unhandledEvent = [[EventWithData alloc] init]; // with @"UNHANDLED"
        self.activeStates = [NSMutableDictionary new];
        self.spriteForFramePulse = [NSObject new];
        self.networkPrepared = NO;
        self.statesByID = [NSMutableDictionary new];
        eventTimerDelay = [NSTimer new];
        
#warning this need setting
        // eventTimerDelay.addEventListener(TimerEvent.TIMER_COMPLETE, timeDelayElapsed, false, 0, true);
        
        // Create the first state manager, by default. This is done as a convenience.
        if (stateNetwork)
        {
            [self setStateNetwork:stateNetwork suppressReassign:nil];
            self.topLevelStateNetworkMgr = [[StateManager alloc] init:@"top level State Network Manager" containerState:nil defaultState:stateNetwork.id n:nil];
            stateNetwork.myStMgr = self.topLevelStateNetworkMgr;
        }
        
    }
    
    NSLog(@"ObjCStEng: State Engine <%@> initialised.", self.name);
    
    return self;
}

/**
 * Flag indicating if state engine is active.
 * <p>Setting this flag to true will activate the engine.  Setting it to false will deactive the engine.  Retrieving
 * the value will tell you if the state engine is active or not.
 * @default false
 */
- (void)active:(BOOL)activate
{
    if (activate)
    {
        if (!self.active)
        {
            [self activateAndResetHistory:YES];
        }
        else
        {
            [self deactivate];
        }
    }
}

/**
 * @private
 */
- (BOOL)active
{
    return _active;
}

/**
 * Attaches the state network (referred to by topmost state) to this state engine.
 * You can use this method as an alternative to supplying the top state's pointer in the StateEngine constructor.
 * @method setStateNetwork
 * @param sn     Pointer to topmost state (virtually always HState or HStateC, if you need it to be State, cast your State into an HStateC) for the state network.
 * @param suppressReassign Optional parameter that locks out possibility to change the top state, once it has been assigned. If an
 * attempt is made to change the name, the routine throws an Error.
 * @example <listing>myTopStatePtr = new HState("State Network", 0);<br>se.setStateNetwork(myTopStatePtr);</listing>
 */
- (void)setStateNetwork:(HStateC *)sn suppressReassign:(BOOL)suppressReassign
{
    if (!self.topLevelStateNetworkMgr)
    {
        stNet = sn;
        self.topLevelStateNetworkMgr = sn.myStMgr;
    }
    else
    {
        NSLog(@"ERROR: Trying to set %@ as top state of state engine, but %@ has been set already.", sn.name, stNet.name);
    }
}

/**
 * Topmost state in the state network.
 * Set and retrieve the topmost state (HState, HStateC) in the state network.  The top state can be a State, but that would
 * be a pretty boring state machine.  If you want the top state to be a State, you can cast your State into an HStateC and pass
 * it in, since HStateC is a sub-state of State.
 *
 * You can set this parameter as an alternative to supplying the top state's pointer in the StateEngine constructor.
 * @default null
 */
- (HStateC *)topState
{
    return stNet;
}

/**
 *
 * @private
 */
- (void)setTopState:(HStateC *)topState
{
    stNet = topState;
}

/**
 * Removes memory associated with the state engine passed in.
 * @method removeStateEngine
 */
- (void)removeStateEngine
{
    [stNet removeState];
    
    eventTimerDelay = nil;
}

/**
 Activates the state engine.
 <p>Typically you will use the <code>active</code> property to activate <code>active = true;</code> your state engine.  However,
 you can use this method all the same.  When an engine is activated, it combs through the state network and
 clears all the history markers by default.  If you don't want this to happen, you cannot use <code>active</code>, you
 must use this routine and set the 'resetHistory' parameter to <code>false</code>.</p>
 @method activate
 @param resetHistory (optional) Set this to 'false' if you do not want to reset the history mechanism throughout the system.  Default is true.
 */
- (void)activateAndResetHistory:(BOOL)resetHistory
{
    // Clear all history variables to restart anew
    if (resetHistory)
    {
        [stNet resetHistory];
    }
    
    if (!self.networkPrepared)
    {
        [self prepareNetwork];
    }
    
    self.active = YES;
    
    if ([self hasEventListener:@"ACTIVATE"])
    {
        EventWithData *event = [[EventWithData alloc] initWithType:@"ACTIVATE"];
        
        [self dispatchEvent:event];
    }
    
    // Setup the outermost manager to active.
    stNet.myStMgr.cs = stNet.id;
    stNet.myStMgr.active = YES;
    
    // Enter the state network.
    [stNet enter:NO specIDs:nil];
}

/**
 * Initializes the states and transitions before the engine activates the first time.
 * <p>The State Engine must do two things before activating:</p><ol>
 * <li>Place a state engine pointer in each state (since State's are not related to the State Engine, but States need access)
 * <li>Pre-compute the paths of transitions, to make their execution as efficient as possible.
 * </ol>
 * <p>This routine accomplishes both tasks.  If the developer wants to avoid the time it takes to perform these
 * when the engine activates the first time, he should call this routine.  Once complete, the developer would activate the engine.
 * If the developer does not call this routine, the engine activation will call it automatically.</p>
 * @method prepareNetwork.
 */
- (void)prepareNetwork
{
    [self setSubState2SE:stNet];
    [self computeTransitionPaths];
    self.networkPrepared = YES;
}

/**
 Set the _se property of all states to the controlling state engine.  This is necessary because state engine
 keeps track of the active states.
 
 @method setSubState2SE
 @param  stPtr   State being currently registered.
 @private
 */
- (void)setSubState2SE:(State *)stPtr
{
    // If this step has been done already, skip it!
    if (stPtr._se)
    {
        return;
    }
    else
    {
        [stPtr registerSubStates:self];
    }
}

/**
 * When developers specify transitions, the engine does not compute the path to the transition. The engine
 * knows that when it gets activated, all the states should be present.  Therefore, at that time, it can
 * compute and store the path from the source to the target.  This means that there is a brief delay when
 * the engine is activated -- to run through and resolve all transitions.  If a developer wants to speed things
 * up, he can call this routine before activation, thereby removing the need to compute the paths at activation.
 * @method computeTransitionPaths
 */
- (void)computeTransitionPaths
{
    State *sp;
    NSMutableArray *ta;
    int tpi;
    
    // Go through all the states, looking for transitions. When we find them, compute the transition paths.
    for (NSString *s in self.statesByID)
    {
        sp = [self.statesByID objectForKey:s];
        if (sp.transitions)
        {
            for (NSString *tid in sp.transitions)
            {
                ta = sp.transitions[tid];
                for (tpi = 0; tpi < ta.count; tpi++)
                {
                    [ta[tpi] determineTransition];
                }
            }
        }
    }
}

/**
 Deactivate the state engine.
 <p>Typically you will use the <code>active</code> property to deactivate <code>active = false;</code> your state engine.
 @method deactivate
 @access public
 */
- (void)deactivate
{
    [stNet leave];
    
    // Setup the outermost manager to deactive.
    stNet.myStMgr.cs = nil;
    stNet.myStMgr.active = false;
    
    // Clear the event timer, if active
    // [eventTimerDelay stop];
}

/**
 * Main routine for injecting an event into the state network.
 * <p>The state engine sits in the current state(s) and basically waits until some event comes in.  This method
 * is how you inject an event into the network.  When you pass in an event, this routine sends the event to
 * the active state(s) in the network.  If that/those state(s) don't handle it, the event bubbles up to the
 * parent to take a shot at handling the event, and so on, up to the topmost state. If no state handles the event,
 * the state engine generates a special event, <code>StateEngine.UNHANDLED_EVENT</code>, which you can subscribe to.  In
 * that way, the caller can tell if any state handled the event or not.</p>
 * <p>Events are Priority FIFO-queued.  The engine guarantees run-to-completion by verifying no event is currently being handled
 * when the engine injects the event.  If a new event comes in while one is already being handled, the event gets queued.</p>
 * <p>Callers may indicate to postpone an event for a set amount of time (in milliseconds).  This might be useful, for example, if you need to space
 * out the time a bit due to Flash needing a moment to get to the next frame.</p>
 * <p>Events can be assigned priorities, so that higher-priority (lower number) events can jump in line in front of lower-priority
 * events.  However, because run-to-completion must be observed, there is no way to interrupt an event being handled currently
 * even with a higher-priority event.</p>
 @method postEvent
 @param ev Event object (pointer)
 @param timeDelay Amount of time (in milliseconds) to wait after finishing handling the prior event, and when this event gets processed.  Default value is 0 (immediately).
 @param pty Integer indicating the priority of the event.  By default, all events are given a priority of 1000.
 @acccess public
 */
- (void)postEvent:(Event *)ev timeDelay:(double)timeDelay pty:(int)pty
{
#warning code required
    // code
}

/**
 This is the main event handler for the state engine.  It used to be called "ieh".
 In version 1 of FStEng, developers were supposed to override this method with their
 own event handler that found the active state(s) and executed actions, transitions, and
 activities.  In version 1.5, however, the event handling was modified to alleviate
 this meticulous burden from the developer, at the expense of some small time expense.
 In version 1.5, the default ieh() method sends the event to the active
 state(s) onEvent method.  The state, by default, runs through its transition
 and internal action triggers.  If any are true, then it fires those actions.  See the
 description of onEvent in the state documentation.
 The developer does not override the ieh() method, unless the developer
 needs to optimize the event handling at a global level.
 
 @method processEvent
 @private
 */
- (void)processEvents
{
    while (self.eventsWaiting.count > 0)
    {
        
        
        
        
//        if ([self.eventsWaiting[0].delay] != 0)
//        {
//            <#statements#>
//        }
//        if (self.eventsWaiting[0].delay) {
//            <#statements#>
//        }
    }
    
    // Clearing the handlingEvent flag, so future event postings invoke processEvent. We clear the
    // flag here rather than in postEvent because an event could have been postponed and when the handling resumes, we get called.
    if (self.eventsWaiting.count == 0)
    {
        self.handlingEvent = NO;
    }
}

/**
 * Called when the event delay timer has elapsed, telling us it is time to resume event processing.
 * @method timeDelayElapsed
 * @private
 */
- (void)timeDelayElapsedForEvent:(Event *)event
{
    [self processEvents];
}

@end
