//
//  TwitterViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "TwitterViewController.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"News";
}

- (void)viewWillAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Twitter" withError:nil];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"TwitterViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"TwitterViewController unloaded properties");
        
        // release...
    }
}

@end
