//
//  EventDispatcher.h
//  ObjCAS
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEventDispatcher.h"

@interface EventDispatcher : NSObject <IEventDispatcher>
{
    NSMutableDictionary *dictASFunctions;
    NSNotificationCenter *broadcaster;
    BOOL async;
}

- (id)initSync;

-(void)addEventListener:(NSString*)_type listener:(ASFunction *)_listener;

- (void)addEventListener:(NSString *)_type listener:(ASFunction *)_listener useCapture:(BOOL)_useCapture priority:(int)_priority useWeakReference:(BOOL)_useWeakReference;

@end
