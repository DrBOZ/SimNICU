//
//  CurosurfViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 10/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CurosurfViewController.h"
#import "CurosurfModel.h"

@interface CurosurfViewController ()

@end

@implementation CurosurfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Curosurf"];
    
    self.title = @"Curosurf\u00AE";
    
    self.webViewSections = [CurosurfModel webViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.curosurfDoseSelected isEqualToString:@"YES"])
    {
        // move table to Curosurf Dose information
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
