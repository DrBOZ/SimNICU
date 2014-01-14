/*
 ************************************************
 
 EXAMPLE: Hierarchical State Machine Engine
 AUTHOR: Jonathan Kaye
 RELEASE:        August, 2009
 Implementation originally conceived and developed DECEMBER 2001
 
 FILE: Transition.as (generic transition class)
 
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
//  Transition.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class State;

@interface Transition : NSObject

/**
 * Pointer to the source State (HState or HStateC).
 */
@property (nonatomic, strong) State *source;

/**
 * ID of the target state.
 * Identifier must be unique across all states in the state engine.
 */
@property (nonatomic, strong) NSString *targetID;

/**
 * An array consisting of state identifiers from the LCA to the target state.
 */
@property (nonatomic, strong) NSMutableArray *stPath;

/**
 * The number of levels in the state network to go up to reach the Least Common Ancestor.
 */
@property (nonatomic) NSInteger upLvls;

/**
 * @private
 */
@property (nonatomic) BOOL hist;

/**
 * @private
 */
@property (nonatomic) SEL xFn;

- (Transition *)init:(State *)src tid:(NSString *)tid tfn:(SEL)tfn doHistory:(BOOL)doHistory upLevelsForExternalTransition:(NSInteger)upLevelsForExternalTransition;

- (void)determineTransition;

@end
