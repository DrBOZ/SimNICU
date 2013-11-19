//
//  CBBarButtonItems.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBBarButtonItems.h"

@implementation CBBarButtonItems

+ (UIBarButtonItem *)addBarButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:target
                                                                               action:action];
    return addButton;
}

+ (UIBarButtonItem *)backBarButtonWithTarget:(id)target action:(SEL)action
{
    // back button text for subsequent screens
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:target
                                                                  action:action];
    return backButton;
}

+ (UIBarButtonItem *)doneBarButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:action];
    
    return doneButton;
}

+ (UIBarButtonItem *)infoBarButtonWithTarget:(id)target action:(SEL)action
{
    // info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(270.0f, 10.0f, 30.0f, 30.0f);
    [infoButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    return infoBarButton;
}

+ (UIBarButtonItem *)settingsBarButtonWithTarget:(id)target action:(SEL)action
{
    return [CBBarButtonItems customBarButtonWithImageFile:@"settings.png" target:target action:action];
}

+ (UIBarButtonItem *)syncBarButtonWithTarget:(id)target action:(SEL)action
{
    return [CBBarButtonItems customBarButtonWithImageFile:@"sync.png" target:target action:action];
}

+ (UIBarButtonItem *)customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:(id)target action:(SEL)action longPressTarget:(id)longPressTarget longPressAction:(SEL)longPressAction
{
    // setup gesture recogniser
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:longPressTarget
                                                                                                   action:longPressAction];
    // setup view
    UIView *buttonView = [UIView new];
    
    // setup button
    UIButton *button = [UIButton new];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        button.frame = CGRectMake(10.0f, 0.0f, 50.0f, 30.0f);
        
        [button setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        buttonView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
        
        UIImageView *backArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"]];
        backArrow.frame = CGRectMake(-8.0f, 5.0f, (25.0f / 2), (41.0f / 2));
        
        [buttonView addSubview:backArrow];
    }
    else
    {
        button.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
        
        UIImage *backImage = [UIImage imageNamed:@"back_button_normal.png"];
        [button setBackgroundImage:backImage  forState:UIControlStateNormal];
        [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
        
        buttonView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
    }
    
    [buttonView addGestureRecognizer:longPressGesture];
    [buttonView addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:buttonView];
}

+ (UIBarButtonItem *)customBarButtonWithImageFile:(NSString *)imageFile target:(id)target action:(SEL)action
{
    // setup image
    UIImage *image = [UIImage imageNamed:imageFile];
    
    // setup button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // setup view
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [buttonView addSubview:button];
    
    UIBarButtonItem *customBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    
    return customBarButton;
}

+ (UIBarButtonItem *)customBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    // setup button
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:target
                                                                    action:action];
    return customButton;
}

// How to make a custom BarButtonItem...
/*
 UIView *roundIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 48.0f, 48.0f)];
 UIImageView *roundIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SimNICU_round.png"]];
 roundIconImageView.frame = CGRectMake(0.0f, 0.0f, 48.0f, 48.0f);
 roundIconImageView.contentMode = UIViewContentModeScaleToFill;
 [roundIconView addSubview:roundIconImageView];
 
 UIBarButtonItem *SimNICUButton = [[UIBarButtonItem alloc] initWithCustomView:roundIconView];
 self.navigationItem.leftBarButtonItem = SimNICUButton;
 */

@end
