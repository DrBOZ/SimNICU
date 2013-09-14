//
//  BayEditorTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 13/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BayEditorTableViewController;

@protocol BayEditorTableViewControllerDelegate <NSObject>

@optional

- (void)bayEditorTableViewControllerDidFinishEditingBays:(BayEditorTableViewController *)controller;

@end

@interface BayEditorTableViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <BayEditorTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *bayData;

@end
