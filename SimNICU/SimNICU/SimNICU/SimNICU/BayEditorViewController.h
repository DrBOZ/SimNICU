//
//  BayEditorViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 16/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BayEditorViewController;

@protocol BayEditorViewControllerDelegate <NSObject>

@optional

- (void)bayEditorViewControllerDidFinishEditingBays:(BayEditorViewController *)controller;

@end

@interface BayEditorViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, unsafe_unretained) id <BayEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *bayData;

@end
