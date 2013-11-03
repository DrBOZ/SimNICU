//
//  CBBarButtonItems.h
//  Neonatal Intensive Care
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
+ (UIBarButtonItem *)syncBarButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)customBarButtonWithImageFile:(NSString *)imageFile target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)customBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
