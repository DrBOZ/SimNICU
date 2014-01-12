//
//  ASFunction.h
//  ObjCAS
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFunction : NSObject
{
    id obj;
    SEL method;
    id userData;
}

@property (readonly) id obj;
@property (readonly) SEL method;
@property (retain) id userData;

- (ASFunction *)initWithObject:(id)_obj method:(SEL)_method;

@end
