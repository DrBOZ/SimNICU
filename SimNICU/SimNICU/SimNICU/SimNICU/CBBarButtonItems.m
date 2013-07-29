//
//  CBBarButtonItems.m
//  SimNICU
//
//  Created by Conrad Bosman on 29/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBBarButtonItems.h"

@implementation CBBarButtonItems

+ (UIBarButtonItem *)infoBarButtonWithTarget:(id)target action:(SEL)action
{
    // info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(270.0f, 10.0f, 30.0f, 30.0f);
    [infoButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    return infoBarButton;
}

@end
