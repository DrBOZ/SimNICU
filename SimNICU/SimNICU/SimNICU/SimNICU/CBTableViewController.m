//
//  CBTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 14/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewController.h"

@interface CBTableViewController ()

@property (nonatomic, strong) UIGestureRecognizer *swipeGestureRecognizer;

@end

@implementation CBTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // add TableView background
    // [CBDisplayMethods setBackgroundForTableView:self.tableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.tableView];
    
    // deselect row
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // update TableView background
    [CBDisplayMethods updateBackgroundForTableView:self.tableView];
}

@end
