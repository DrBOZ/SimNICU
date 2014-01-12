//
//  ASMacro.h
//
//  Created by Conrad Bosman on 09/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

// #define as3delegate(o,m) [[[ASFunction alloc] initWithObject:o method:@selector(m)] autorelease]
#define as3delegate(o,m) [[ASFunction alloc] initWithObject:o method:@selector(m)]

#define as3new(c)[[c alloc] init]

// #define as3newEvent(str)[[[Event alloc] initWithType:@str] autorelease]
#define as3newEvent(str)[[Event alloc] initWithType:@str]

#define this self

#define as3optionalParameterImp(lastParameter,lastParameterAction,optionalParameterAction)id currentObject;va_list argList;int objectCount = 1;if (lastParameter){lastParameterAction;objectCount++;va_start(argList, lastParameter);while ((currentObject = va_arg(argList, id))){optionalParameterAction;objectCount++;}va_end(argList);}
