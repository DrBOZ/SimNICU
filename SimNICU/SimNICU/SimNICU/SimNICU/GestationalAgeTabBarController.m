//
//  GestationalAgeTabBarController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "LMPGestationCalculatorViewController.h"
#import "EDDGestationalAgeViewController.h"
#import "GestationalAgeTabBarController.h"
#import "CorrectedAgeViewController.h"

@interface GestationalAgeTabBarController ()

@property (nonatomic, strong) CorrectedAgeViewController *correctedAgeViewController;
@property (nonatomic, strong) LMPGestationCalculatorViewController *lMPGestationalAgeViewController;
@property (nonatomic, strong) EDDGestationalAgeViewController *eDDGestationalAgeViewController;

@end

@implementation GestationalAgeTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Gestational Age";
        
        // create ViewController
        CorrectedAgeViewController *correctedAgeVC = [[CorrectedAgeViewController alloc] init];
        LMPGestationCalculatorViewController *lMPGestationAgeVC = [[LMPGestationCalculatorViewController alloc] init];
        EDDGestationalAgeViewController *eDDGestationalAgeVC = [[EDDGestationalAgeViewController alloc] init];
        
        self.viewControllers = [NSArray arrayWithObjects:correctedAgeVC, lMPGestationAgeVC, eDDGestationalAgeVC, nil];
        
        self.correctedAgeViewController = [self.viewControllers objectAtIndex:0];
        self.lMPGestationalAgeViewController = [self.viewControllers objectAtIndex:1];
        self.eDDGestationalAgeViewController = [self.viewControllers objectAtIndex:2];
        
        self.correctedAgeViewController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.lMPGestationalAgeViewController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.eDDGestationalAgeViewController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        
#if APP_SHADING
        //screen mask covers everything
        UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height - 49))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
        tableBgView.image = tableBgImage;
        tableBgView.userInteractionEnabled = NO;
        tableBgView.alpha = 0.5;
        [self.view addSubview:tableBgView];
#endif
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
