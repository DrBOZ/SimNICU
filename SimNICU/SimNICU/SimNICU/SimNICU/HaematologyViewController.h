//
//  HaematologyViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HaematologyViewController;

@protocol HaematologyViewControllerDelegate <NSObject>

- (void)haematologyViewControllerDidFinish:(HaematologyViewController *)controller withResults:(NSMutableArray *)results;

- (void)haematologyViewControllerDidCancel:(HaematologyViewController *)controller;

@end

@interface HaematologyViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <HaematologyViewControllerDelegate> delegate;

@end