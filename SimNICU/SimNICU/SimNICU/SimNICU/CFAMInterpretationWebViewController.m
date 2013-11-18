//
//  CFAMInterpretationWebViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 18/11/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CFAMInterpretationWebViewController.h"
#import "CFAMInterpretationModel.h"

@implementation CFAMInterpretationWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.webViewSections = [CFAMInterpretationModel webViews];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"CFAM/Interpretation"];
    
    self.title = NSLocalizedString(@"Interpretation", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
