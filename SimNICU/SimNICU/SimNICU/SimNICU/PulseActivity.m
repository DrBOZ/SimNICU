//
//  PulseActivity.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "PulseActivity.h"
#import "EventData.h"
#import "State.h"

@interface PulseActivity ()
{
    NSTimer *timerObj;
    // Sprite *frameSprite;
    NSInteger frameCount;
    BOOL active;
}

- (void)frameElapsed:(Event *)ev;
- (void)timerElapsed:(Event *)ev;

@end

@implementation PulseActivity

/**
 * Creates an instance of a Pulse Activity.
 * <p>Pulse Activities are time- or frame-based triggered actions that do not cause state changes (unless the
 * developer invokes a transition during the handling of the pulse.  Developers send in the handler function to
 * the State's pulse activity creator, <code>myStatePtr.addPulseActivity()</code>.</p>
 * <p>When a tick is generated, the handler receives an <code>EventWithData</code> that has 1 property, <code>event.data.state</code>.
 * This allows the handler to tell which state originated this pulse activity.</p>
 * @param       interval        For time-based activities (the default), use milliseconds.  For frame-based activities, use number of frames.
 * @param       origState       A pointer to the state on which the activity is defined.
 * @param       cb                      Callback function for event handler.
 * @param       fb                      Boolean value that is true for frame-based pulses, or false (default) for time-based.
 */
- (PulseActivity *)init:(NSInteger)interval origState:(State *)origState cb:(SEL)cb fb:(BOOL)fb
{
    if ((self = [super init]))
    {
        self.intvl = interval;
        self.frameBased = fb;
        self.handler = cb;
        
        if (self.frameBased)
        {
            NSLog(@"ObjCStEng: Frame based pulse activities are not supported in this Objective C version.");
        }
        else
        {
            timerObj = [[NSTimer alloc] init];
            // timeObj.addEventListener(TimerEvent.TIMER, timerElapsed, false, 0, true);
        }
        
        EventData *eventData = [EventData new];
        eventData.stateName = nil; // temp code
        eventData.stateID = nil;
        // eventData.stateID = origState;
        
        self.pulseEvent = [[EventWithData alloc] initWithType:TICK bubbles:NO cancelable:NO dataInit:eventData];
    }
    
    return self;
}

/**
 * Stops the activity and unhooks the listeners.
 * This routine is called when a pulse activity is removed.  We unhook the internal listeners so
 * they don't get stranded from garbage collection (though we do explicitly make the listener have a weak reference).
 * @private
 */
- (void)prepareToRemove
{
    // [self removeEventListener:TICK listener:self.handler];
    
    [self stop];
    
    if (!self.frameBased)
    {
        // timerObj.removeEventListener(TimerEvent.TIMER, timerElapsed);
    }
}

/**
 * Start the pulse activity.
 * @private
 */

- (void)start
{
    if (!active)
    {
        if (self.frameBased)
        {
            frameCount = 0;
        
            // frameSprite.addEventListener(Event.ENTER_FRAME, frameElapsed, false, 0 , true);
        }
        else
        {
            // timerObj.reset();
            // timerObj.start();
        }
        
        active = YES;
    }
}

/**
 * Stop the pulse activity.
 * @private
 */
- (void)stop
{
    if (active)
    {
        if (self.frameBased)
        {
            // sprites are not supported
        }
        else
        {
            // timerObj.stop();
        }
        
        active = NO;
    }
}

/**
 * Used for frame-based pulse activities.  We count the frames and at the desired interval, send the pulse.
 * @param       ev
 * @private
 */
- (void)frameElapsed:(Event *)ev
{
    frameCount++;
    
    if (frameCount == self.intvl)
    {
        [self dispatchEvent:self.pulseEvent];
        frameCount = 0;
    }
}

/**
 * Used for time-based pulse activities.  When the interval elapses, we send the pulse.
 * @param       ev
 * @private
 */
- (void)timerElapsed:(Event *)ev
{
    [self dispatchEvent:self.pulseEvent];
}

@end
