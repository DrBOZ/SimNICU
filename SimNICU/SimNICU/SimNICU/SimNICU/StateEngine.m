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

@interface StateEngine ()
{
    HStateC *stNet;
    NSTimer *eventTimerDelay;
}

// @property (nonatomic, strong) HStateC *stNet;
@property (nonatomic) BOOL handlingEvent;
@property (nonatomic, strong) NSMutableArray *eventsWaiting;
@property (nonatomic, strong) EventWithData *unhandledEvent;
@property (nonatomic, strong) StateManager *topLevelStateNetworkMgr;
@property (nonatomic) BOOL networkPrepared;
@property (nonatomic) BOOL active;

- (void)setStateNetwork:(HStateC *)sn suppressReassign:(BOOL)suppressReassign;

- (void)setSubState2SEwithState:(State *)stPtr;

- (BOOL)active;

- (void)activateAndResetHistory:(BOOL)resetHistory;
- (void)deactivate;
- (void)processEvents;
- (void)timeDelayElapsedForEvent:(Event *)event;

@end

@implementation StateEngine

- (StateEngine *)initWithName:(NSString *)n andStateNetwork:(HStateC *)stateNetwork
{
    if ((self = [super init]))
    {
        self.name = n;
        stNet = nil;
        self.active = NO;
        self.eventsWaiting = [[NSMutableArray alloc] initWithCapacity:1];
        self.handlingEvent = NO;
        self.unhandledEvent = [[EventWithData alloc] init]; // with @"UNHANDLED"
        self.activeStates = [NSMutableDictionary new];
        self.spriteForFramePulse = [NSObject new];
        self.networkPrepared = NO;
        self.statesByID = [NSMutableDictionary new];
        eventTimerDelay = [NSTimer new];
        // eventTimerDelay.addEventListener(TimerEvent.TIMER_COMPLETE, timeDelayElapsed, false, 0, true);
        
        // Create the first state manager, by default. This is done as a convenience.
        if (stateNetwork)
        {
            // setStateNetwork(stateNetwork);
            self.topLevelStateNetworkMgr = [[StateManager alloc] init];
            // topLevelStateNetworkMgr = new StateManager("top level State Network Manager", null, stateNetwork.id);
            // stateNetwork.myStMgr    = topLevelStateNetworkMgr;
        }
        
    }
    
    return self;
}

- (void)setStateNetwork:(HStateC *)sn suppressReassign:(BOOL)suppressReassign
{
    if (!self.topLevelStateNetworkMgr)
    {
        stNet = sn;
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
    if (resetHistory)
    {
        // [self.stNet resetHistory];
    }
    
    if (!self.networkPrepared)
    {
        // [self prepareNetwork];
    }
    
    self.active = YES;
    
    if ([self hasEventListener:@"ACTIVATE"])
    {
        EventWithData *event = [[EventWithData alloc] initWithType:@"ACTIVATE"];
        
        [self dispatchEvent:event];
    }
    
    // self.stNet.myStMgr.cs = self.stNet.id;
    // self.stNet.myStMgr.active = YES;
    
    // Enter the state network.
    // [self.stNet enter];
}

- (void)prepareNetwork
{
    // code
}

- (void)setSubState2SEwithState:(State *)stPtr
{
    if (stPtr.se)
    {
        return;
    }
    else
    {
        // stPtr registerSubStates(this);
    }
}

// this should be changed to better code
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

- (BOOL)active
{
    return _active;
}

- (void)deactivate
{
    
}

- (void)processEvents
{
    while (self.eventsWaiting.count > 0)
    {
//        if (self.eventsWaiting[0].delay) {
//            <#statements#>
//        }
    }
}

- (void)timeDelayElapsedForEvent:(Event *)event
{
    [self processEvents];
}

@end
