/**
 ***********************************************
 
 EXAMPLE: Hierarchical State Machine Engine
 AUTHOR: Jonathan Kaye
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 FILE: com.flashsim.FStEng.Three.StateEngine.as
 
 This is the main code for the Flash State Engine, created
 by Jonathan Kaye to accompany the book, "Flash for Interactive Simulation"
 (October, 2002), by Jonathan Kaye and David Castillo
 (Delmar Thomson Learning).
 
 Special thanks to Zjnue Brzavi for helping to tighten up the code.
 
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
 *********************************************** ***
 */

//
//  StateEngine.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "EventDispatcher.h"
#import "ASMacro.h"
#import "Array.h"
#import "Event.h"

/**
 * Event sent when the state engine gets activated.
 * @eventType ACTIVATE
 */
#define ACTIVATE @"ACTIVATE"

/**
 * Event sent when the state engine gets deactivated.
 * @eventType DEACTIVATE
 */
#define DEACTIVATE @"DEACTIVATE"

/**
 * Event sent when no state has handled an injected event.
 * <p>If an event is posted but no state has an event handler to handle it.  To help the handler recognize which event went
 * unhandled, the StateEngine has an <code>event</code> property that hangs off of the EventWithData's data object.  For example,
 * <code>myEventWithDataPtr.data.event</code> gives the Event object that went unhandled.  The default handler can examine
 * that event and decide what the default behavior needs to be.</p>
 * @eventType UNHANDLED_EVENT
 */
#define UNHANDLED @"UNHANDLED"

@class HStateC;

/**
 * The StateEngine is the main data structure for the hierarchical state machine.
 * <p>The StateEngine encapsulates the functionality for a state machine (hierarchical or finite states).
 * Once you create an instance of a StateEngine, you then instantiate the state network as a series of
 * State's (simple states), HState's (hierarchical states), and HStateC's (Hierarchical, concurrent states).
 * States are connected with one another via a system of State Managers (<code>StateManager</code>).  Each hierarchical state
 * is required to have a State Manager.  Concurrent hierarchical states can have more than one manager, one to manage each
 * concurrent sub-network.  The State Manager keeps track info needed for the immediate sub-network, such as which state is active, which was
 * the last state visited, etc.</p>
 * <p>To activate the state network, use <code>active = true;</code>, or <code>activate()</code>.  To send events
 * into the StateEngine, use <code>PostEvent()</code>.  Events are processed in a FIFO queue.  The engine guarantees
 * that the network runs-to-completion before processing the next event in the queue.</p>
 * <p>If you only want a finite state machine, you can create a top state as a hierarchical
 * state (HState) and then just add simple states (State) to the network.</p>
 *
 *
 * @class  StateEngine
 * @package com.flashsim.FStEng.Three
 * @author Jonathan Kaye
 * ***********************************************************************************/

@interface StateEngine : EventDispatcher

/**
 * User-defined (String) name of the state engine.
 * @default "State Engine"
 */
@property (nonatomic, strong) NSString *name;

/**
 * A Dictionary (flash.utils.Dictionary) of the currently active states.
 * <p>The State objects are keys, with values being <code>true</code></p>.
 */
@property (nonatomic, strong) NSMutableDictionary *activeStates;

/**
 * Hash table of ids (keys) to their state.  All state ID's must be unique.
 * @private
 */
@property (nonatomic, strong) NSMutableDictionary *statesByID;

/**
 * Count used to know when to pass events up to concurrent (hier) states.  When we pass an event
 * to an HStateC, we have to wait until all the sub-networks have had a chance to handle the event
 * before we give the opportunity to the ancestors.
 * @private
 */
@property (nonatomic, strong) NSMutableDictionary *_concEvCt;

/**
 * An instance of a Sprite to use for frame-based pulse activities.
 * You can make pulse activities (PulseActivity) trigger based on an approximate time value (using Flash's
 * Timer class), or based on number of frames.  We create a Sprite during initialization in case the
 * user wants to have frame-based timings (for which we need to listen for an ENTER_FRAME event).
 * @private
 */
@property (nonatomic, strong) NSObject *spriteForFramePulse;


@property (nonatomic, strong) HStateC *topState;

- (StateEngine *)initWithName:(NSString *)n andStateNetwork:(HStateC *)stateNetwork;
- (void)setStateNetwork:(HStateC *)sn suppressReassign:(BOOL)suppressReassign;
- (void)postEvent:(Event *)ev timeDelay:(NSNumber *)timeDelay pty:(NSInteger)pty;
- (void)active:(BOOL)activate;
- (void)prepareNetwork;

@end
