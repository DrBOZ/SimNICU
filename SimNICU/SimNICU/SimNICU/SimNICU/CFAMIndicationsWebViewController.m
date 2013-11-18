//
//  CFAMIndicationsWebViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CFAMIndicationsWebViewController.h"
#import "CFAMIndicationsModel.h"

@implementation CFAMIndicationsWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.webViewSections = [CFAMIndicationsModel webViews];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"CFAM/Indications"];
    
    // self.title = NSLocalizedString(@"Indications", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
