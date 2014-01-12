//
//  Transition.m
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "StateManager.h"
#import "StateEngine.h"
#import "Transition.h"

@interface Transition ()

@property (nonatomic, strong) State *target;
@property (nonatomic) SEL xFn;
@property (nonatomic) BOOL hist;
@property (nonatomic) NSInteger upLevelsForExtTrans;
@property (nonatomic) NSInteger upLvls;
@property (nonatomic, strong) NSMutableArray *stPath;

- (void)determineTransition;

@end

@implementation Transition

/**
 * Creates a Transition instance.
 * <p>Transition instances are used to connect states.  Transitions are triggered by events, but that information is stored in the
 * State to which the Transition is attached.  The transition permits one to invoke a function when the transition is triggered.</p>
 * <p>If <code>upLevelsForExternalTransition</code> is supplied, the developer must ensure that the either the source or the target
 * is the ancestor of the other.  We cannot verify this at the moment this method is called because the target state may not
 * exist yet (it may only be referred to as its id).</p>
 * @param       src Source state pointer.
 * @param       tid Target state identifier.
 * @param       tfn Transition function -- invoked if the Transition is fired.
 * @param       doHistory Boolean value indicating whether or not to go to the History pseudo-state of the target state.
 * @param       upLevelsForExternalTransition This is only for external transitions: it lets one control how many parent states upward the engine exits before returning to enter the state again.
 */

- (Transition *)init:(State *)src tid:(NSString *)tid tfn:(SEL)tfn doHistory:(BOOL)doHistory upLevelsForExternalTransition:(NSInteger)upLevelsForExternalTransition
{
    if((self = [super init]))
    {
        self.source                 = src;
        self.targetID               = tid;
        self.upLevelsForExtTrans    = upLevelsForExternalTransition;
        self.hist                   = doHistory;
        self.xFn                    = tfn;
        self.upLvls                 = 0;
    }
    
    return self;
}

/**
 * Determines the transition path from the source to the target, once we know all states have been instantiated.
 * This routine determines if the transition is simple (among siblings), or a crossbound one (requiring jumping outside
 * current sibling network).  It then sets the type of transition inside this Transition, which the State Manager will
 * use in making the transition.
 * @determineTransition
 * @private
 */

- (void)determineTransition
{
    NSMutableArray *stPathArray;
    State *sp;
    NSMutableArray *lca_src;
    NSMutableArray *lca_targ;
    StateManager *smp;
    int ai;
    int aj;
    BOOL found;
    NSString *sid;
    
    NSDictionary *statesByID = self.source.se;
}

@end
