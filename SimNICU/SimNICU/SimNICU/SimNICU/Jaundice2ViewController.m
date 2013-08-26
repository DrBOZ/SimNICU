//
//  Jaundice2ViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 26/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "Jaundice2ViewController.h"

@interface Jaundice2ViewController ()

@end

@implementation Jaundice2ViewController

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
    
    [CBTrackers logEvent:@"Jaundice"];
    
    self.title = @"Jaundice";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
#if USE_DIMPLE_BACKGROUND
    
    // set background colour
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
    }
    else
    {
        // 3.5 inch Retina
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
    }
    
#else
    
    myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark

- (void)done
{
    
}

- (void)cancel
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
