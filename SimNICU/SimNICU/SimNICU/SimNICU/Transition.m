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
#import "HStateC.h"
#import "State.h"

@interface Transition ()
{
    /**
     * Pointer to the target State (HState or HStateC).
     * Important: this value is computed just before the stage engine is activated, or when the developer calls <code>myStateEnginePtr.prepareNetwork()</code>.
     * Therefore, the value may be <code>null</code> if you try to access it before that condition has occurred.
     * @private
     */
    State *target;
    
    /**
     * The number of levels in the state network to go up (towards the root) if this an external transition.
     * @private
     */
    int upLevelsForExtTrans;
}

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
        upLevelsForExtTrans         = upLevelsForExternalTransition;
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
    // NSString *sid; unused variable
    
    NSMutableDictionary *statesByID = self.source._se.statesByID;
    
    target = statesByID[self.targetID];
    
    // make sure not sending to history of simple state
    if ((![target isKindOfClass:[HStateC class]]) && self.hist == YES)
    {
        NSLog(@"ObjCStEng: History pseudo-states are only in hierarchical states. Cannot transition from %@ to history of State %@", self.source.id, self.targetID);
    }
    
    // Check the type of transition to see if it is a sibling transition or cross-boundary transition
    if (self.source == target)  // may be isEqual...
    {
        // (a) This is a transition to self
        stPathArray = [[NSMutableArray alloc] initWithObjects:self.source.id, nil];
        sp = self.source;
        for (int i = upLevelsForExtTrans; i > 0; i--)
        {
            sp = sp.myStMgr.contSt;
            if (!sp)
            {
                NSLog(@"Hit the top of the state network during transition-to-self path determination for state %@ -- up levels must be reduced", self.source.name);
            }
            [stPathArray insertObject:sp.id atIndex:0];
        }
        self.upLvls = upLevelsForExtTrans;
        self.stPath = stPathArray;
    }
    else if (self.source.myStMgr == target.myStMgr)
    {
        // (b) Transition to sibling
        self.upLvls = 0;
        
        // stPath = [target.id]; // AS3 code
        self.stPath = [[NSMutableArray alloc] initWithObjects:target.id, nil];
    }
    else if (self.hist && self.source.myStMgr.contSt == target)
    {
        // (c) Transition to history within same network
        self.upLvls = 0;
        self.stPath = [[NSMutableArray alloc] init];
    }
    else
    {
        // compute ancestor states of source
        lca_src = [[NSMutableArray alloc] init];
        smp = self.source.myStMgr;
        while (smp.contSt)
        {
            [lca_src addObject:smp.contSt.id];
            smp = smp.contSt.myStMgr;
        }
        found = NO;
        // Is target an ancestor of source?
        // Case (a) is a special case of this in which the source and target are the same. Since we've
        // reached here, we know source is not the same as target so we can start our search for target
        // one level above the source state (that's why we didn't put the source state into lca_src[]).
        for (ai = 0; ai < lca_src.count; ai++)
        {
            if (lca_src[ai] == self.targetID)
            {
                // We know we have to go up 'ai' levels to get to the target. We add in upLevelsForExtTrans
                // to allow the external transition to exit the state as high as desired, then re-enter
                self.upLvls = ai + upLevelsForExtTrans;
                self.stPath = [[NSMutableArray alloc] init];
                if (upLevelsForExtTrans > 0)
                {
                    // We have to construct the path back to the level of the state appropriate for
                    // the external transition's descent
                    State *ancestorState = self.source.myStMgr.contSt;
                    int statesUpCt = upLevelsForExtTrans;
                    while (statesUpCt > 0)
                    {
                        [self.stPath addObject:ancestorState.id];
                        ancestorState = ancestorState.myStMgr.contSt;
                        statesUpCt--;
                    }
                    NSArray *stPathReversed = [[self.stPath reverseObjectEnumerator] allObjects];
                    self.stPath = [NSMutableArray arrayWithArray:stPathReversed];
                }
                
                // (d) target is an ancestor of source
                found = YES;
                break;
            }
        }
        
        if (!found)
        {
            // compute ancestors of target
            lca_targ = [[NSMutableArray alloc] initWithObjects:self.targetID, nil];
            smp = target.myStMgr;
            while (smp.contSt) // Conrad, is this correct?
            {
                [lca_targ addObject:smp.contSt.id];
                smp = smp.contSt.myStMgr;
            }
            // Is source as ancestor of target?
            for (ai = 0; ai < lca_targ.count; ai++)
            {
                if (lca_targ[ai] == self.source.id)
                {
                    // (e) source is an ancestor of target
                    // lca_targ.splice(ai + upLevelsForExtTrans, lca_targ - ai - upLevelsForExtTrans); AS3
                    [lca_targ removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(ai + upLevelsForExtTrans, lca_targ.count - ai - upLevelsForExtTrans)]];
                    self.upLvls = -1 + upLevelsForExtTrans;
                    NSArray *lca_targReversed = [[lca_targ reverseObjectEnumerator] allObjects];
                    self.stPath = [NSMutableArray arrayWithArray:lca_targReversed];
                    found = YES;
                    break;
                }
            }
            
            if (!found)
            {
                for (ai = 0; ai < lca_src.count && !found; ai++)
                {
                    for (aj = 1; aj < lca_targ.count; aj++)
                    {
                        if (lca_src[ai] == lca_targ[aj])
                        {
                            // (f) SOURCE AND TARGET IN DIFFERENT PATHS
                            [lca_targ removeObjectAtIndex:aj];
                            self.upLvls = ai;
                            NSArray *lca_targReversed = [[lca_targ reverseObjectEnumerator] allObjects];
                            self.stPath = [NSMutableArray arrayWithArray:lca_targReversed];
                            found = YES;
                            break;
                        }
                    }
                }
                
                if (!found)
                {
                    NSLog(@"ObjCStEng: State Engine logic for transition computation is faulty. Cannot find transition from %@ -> %@", self.source.name, target.name);
                }
            }
        }
    }
}

@end
