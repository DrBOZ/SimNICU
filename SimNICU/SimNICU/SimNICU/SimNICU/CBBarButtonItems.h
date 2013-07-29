//
//  CBBarButtonItems.h
//  SimNICU
//
//  Created by Conrad Bosman on 29/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBarButtonItems : NSObject

+ (UIBarButtonItem *)addBarButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backBarButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)doneBarButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)infoBarButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)settingsBarButtonWithTarget:(id)target action:(SEL)action;


@end
