//
//  VascularLinesTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"
#import "Patient.h"

@class VascularLinesTableViewController;

@protocol VascularLinesTableViewControllerDelegate <NSObject>

- (void)vascularLinesTableViewControllerDidFinish:(VascularLinesTableViewController *)controller withResults:(NSMutableArray *)results;

- (void)vascularLinesTableViewControllerDidCancel:(VascularLinesTableViewController *)controller;

@end

@interface VascularLinesTableViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <VascularLinesTableViewControllerDelegate> delegate;
@property (nonatomic, strong) Patient *selectedPatient;

@end
