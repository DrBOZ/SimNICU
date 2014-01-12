//
//  Event.h
//  ObjCAS
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
{
    id currentTarget;
    int eventPhase;
    id target;
    
    BOOL bubbles;
    BOOL cancelable;
    NSString *type;
}

@property (readonly) BOOL bubbles;
@property (readonly) BOOL cancelable;
@property (readonly) NSString *type;

@property (retain) id currentTarget;
@property (retain) id target;
@property (readonly) int eventPhase;

- (Event *)initWithType:(NSString *)_type;
- (Event *)initWithType:(NSString *)_type bubbles:(BOOL)_bubbles cancelable:(BOOL)_cancelable;

- (NSString *)toString;

@end
