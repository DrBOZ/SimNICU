//
//  AboutSimNICUViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 30/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

@class AboutSimNICUViewController;

@protocol AboutSimNICUViewControllerDelegate <NSObject>

- (void)aboutSimNICUViewControllerDelegateDidSelectFeedback:(AboutSimNICUViewController *)controller;

@end

@interface AboutSimNICUViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <AboutSimNICUViewControllerDelegate> delegate;

@end
