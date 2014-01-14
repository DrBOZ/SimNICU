//
//  StateEngineEvent.h
//  ObjCStEng
//
//  Created by Conrad Bosman on 14/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface StateEngineEvent : NSObject

@property (nonatomic, strong) Event *event;
@property (nonatomic) NSInteger aPriority;
@property (nonatomic, strong) NSNumber *delay;

@end
