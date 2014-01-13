//
//  PulseActivity.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

/**
 * Time-based or frame-based state activity.
 * <p>A pulse activity is an action that gets triggered at some time- or frame-based interval while a
 * state is active.  Like transitions, developers use a State's <code>addPulseActivity</code> to attach
 * a pulse activity to a given State.</p>
 * When you create a pulse activity, you tell the constructor whether you want to invoke the action (function)
 * at an interval of milliseconds or of number of frames elapsed.
 * @class PulseActivity
 */

#import "EventDispatcher.h"
#import "EventWithData.h"

@class State;

@interface PulseActivity : EventDispatcher

/**
 * Event sent on each pulse of the activity.
 * <p>The developer tells the pulse activity how frequently to emit pulses.  When the time elapses, the engine
 * generates a TICK event that callers can register to listen for.</p>
 * @eventType TICK
 */

// public static const TICK:String = "TICK";

/**
* Interval of pulse.
* <p>Interval is in milliseconds if pulse activity is time-based, or is in number of frames if frame-based.</p>
*/

@property (nonatomic) NSInteger intvl;

/**
 * @private
 */

@property (nonatomic, strong) EventWithData *pulseEvent;

/**
 * Frame-based or time-based.
 * <p>Boolean value indicating true: pulse activity is frame-based, or false: pulse activity is time-based.</p>
 * @default false
 */

@property (nonatomic) BOOL frameBased;

/**
 * Handler routine for this pulse activity.
 */

@property (nonatomic) SEL handler;

- (PulseActivity *)init:(NSInteger)interval origState:(State *)origState cb:(SEL)cb fb:(BOOL)fb;
- (void)prepareToRemove;
- (void)start;
- (void)stop;


@end
