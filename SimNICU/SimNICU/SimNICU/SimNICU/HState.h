//
//  HState.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "HStateC.h"

/**
 A hierarchical state with a single sub-network.
 Hierarchical states can either have a single sub-network (collection of sub-states)--HState, or multiple networks of sub-states (HStateC).
 The HState is really a specialization of an HStateC that only has one sub-network.  Therefore, all the real code is going on in
 HStateC.
 
 @class   HState
 @package com.flashsim.FStEng.Three
 @author  Jonathan Kaye (FlashSim.com)
 */

@interface HState : HStateC

- (void)init;

@end
