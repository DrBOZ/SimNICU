/*
 ************************************************
 
 AUTHOR: Jonathan Kaye
 
 FILE: PulseActivity.as
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 Copyright (c) 2009, Jonathan Kaye, All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted
 provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions
 and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 [New BSD License, http://www.opensource.org/licenses/bsd-license.php]
 
 For questions or comments, please refer to http://code.google.com/p/flashsim-state-engines/.
 ************************************************
 */

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
#define TICK @"TICK"

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
