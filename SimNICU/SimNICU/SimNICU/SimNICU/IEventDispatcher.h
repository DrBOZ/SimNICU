//
//  IEventDispatcher.h
//  ObjCAS
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "ASFunction.h"

@protocol IEventDispatcher <NSObject> // may need to remove <NSObject>

- (void)addEventListener:(NSString *)_type listener:(ASFunction *)_listener;
- (void)addEventListener:(NSString *)_type listener:(ASFunction *)_listener useCapture:(BOOL)_useCapture priority:(int)_priority useWeakReference:(BOOL)_useWeakReference;
- (BOOL)dispatchEvent:(Event *)event;
- (BOOL)hasEventListener:(NSString *)_type;
- (void)removeEventListener:(NSString *)_type listener:(ASFunction *)_listener;
- (void)removeEventListener:(NSString *)_type listener:(ASFunction *)_listener useCapture:(BOOL)_useCapture;
- (BOOL)willTrigger:(NSString *)_type;

@end
