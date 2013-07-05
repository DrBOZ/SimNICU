//
//  DrugsTabBarController.m
//  SimNICU
//
//  Created by Conrad Bosman on 05/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DrugCategoriesViewController.h"
#import "DrugsTabBarController.h"

@interface DrugsTabBarController ()

@property (nonatomic, strong) DrugCategoriesViewController *drugCategoriesViewController;
// @property (nonatomic, strong) SelectedViewController_iPhone *favouritesViewController;

@end

@implementation DrugsTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.drugCategoriesViewController = [[DrugCategoriesViewController alloc] init];
        
        UINavigationController *drugCategoriesNavigationController = [[UINavigationController alloc] initWithRootViewController:self.drugCategoriesViewController];
        drugCategoriesNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        drugCategoriesNavigationController.navigationBar.tintColor = [UIColor blackColor];
        
        self.viewControllers = [NSArray arrayWithObjects:drugCategoriesNavigationController, nil];
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

// Tell the system what we support
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate
{
    return NO;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
