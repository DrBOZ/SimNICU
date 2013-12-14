//
//  AddBloodResultTableViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"

@class AddBloodResultTableViewController;

@protocol AddBloodResultTableViewControllerDelegate <NSObject>

- (void)addBloodResultTableViewControllerDidFinish:(AddBloodResultTableViewController *)controller withSampleData:(NSDictionary *)sampleData;

- (void)addBloodResultTableViewControllerDidFinishEditing:(AddBloodResultTableViewController *)controller withSampleData:(NSDictionary *)sampleData;

- (void)addBloodResultTableViewControllerDidCancel:(AddBloodResultTableViewController *)controller;

@end

@interface AddBloodResultTableViewController : CBTableViewController

@property (nonatomic, unsafe_unretained) id <AddBloodResultTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *sampleData;
@property (nonatomic, strong) NSString *bloodResultOrder;
@property (nonatomic, strong) NSString *editOrAddResult;
@property (nonatomic, strong) NSDate *resultDate;

@end
