//
//  EventWithData.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "Event.h"

@interface EventWithData : Event

@property (nonatomic, strong) NSMutableDictionary *data;

- (EventWithData *)initWithType:(NSString *)type bubbles:(BOOL)bubbles cancelable:(BOOL)cancelable dataInit:(id)dataInit;

- (EventWithData *)clone;
- (NSString *)toString;

@end
