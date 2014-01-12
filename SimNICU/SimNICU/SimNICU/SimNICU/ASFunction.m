//
//  ASFunction.m
//  ObjCAS
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "ASFunction.h"

@implementation ASFunction

@synthesize obj;
@synthesize method;
@synthesize userData;

- (ASFunction *)initWithObject:(id)_obj method:(SEL)_method
{
    if((self = [super init]))
    {
        obj = _obj;
        method = _method;
    }
    return self;
}

@end
