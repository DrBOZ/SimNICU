//
//  AppDelegate.m
//  SimNICU
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "EnterWeightViewController.h"
#import "AppViewController.h"
#import "KKPasscodeLock.h"
#import "DCIntrospect.h"
#import "AppDelegate.h"
// #import <Parse/Parse.h>
#import "iRate.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize revealController = _revealController;
@synthesize window = _window;

+ (void)initialize
{
#ifdef LITE_VERSION
    
    NSLog(@"SimNICU Lite log:");
    NSLog(@" ");
    
#else
    
    NSLog(@"SimNICU log:");
    NSLog(@" ");
    
#endif

    
#if IRATE_SET
    
    // using iRate version 1.6.2

	[iRate sharedInstance].appStoreID = 518447654;
    [iRate sharedInstance].applicationBundleID = @"com.conradbosman.SimNICU";
    [iRate sharedInstance].applicationName = @"SimNICU";
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"Like SimNICU?", nil);
    [iRate sharedInstance].message = NSLocalizedString(@"Please rate it on the App Store.\nIt will only take a moment, and will help me to work hard on future improvements.", nil);
    
    // Will only prompt after 10 days AND/OR 20 uses, with a remind period of 7 days
    
    [iRate sharedInstance].daysUntilPrompt = 10;
    [iRate sharedInstance].usesUntilPrompt = 20;
    [iRate sharedInstance].remindPeriod = 7;
    
#else
    
    NSLog(@"iRATE OFF");
    [iRate sharedInstance].promptAtLaunch = NO;
    
#endif
    
#if IRATE_PREVIEW_MODE
    
    [iRate sharedInstance].previewMode = YES;
    
#endif
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup security
    [[KKPasscodeLock sharedLock] setDefaultSettings];
    
    // setup Parse
    
    /*
     [Parse setApplicationId:@"7ULqlR7Nkx7YUpFQ3pyoDavwYBPWwdEDzkyuatbM"
     clientKey:@"MQWPuRvve0p1YHzTUu5hJtUtBuPAk3AVBZK90DEZ"];
     */
    
#if GOOGLE_ANALYTICS
    
    // Google Analytics
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-35056388-2"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:self];
    
    NSError *error;
    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                         name:@"iPhone1"
                                                        value:@"iv1"
                                                    withError:&error])
    {
        // Handle error here
    }
    
    if (![[GANTracker sharedTracker] trackEvent:@"my_category"
                                         action:@"my_action"
                                          label:@"my_label"
                                          value:-1
                                      withError:&error])
    {
        // Handle error here
    }
    
    if (![[GANTracker sharedTracker] trackPageview:@"App Loaded"
                                         withError:&error]) {
        // Handle error here
    }
    
#endif
    
    // set UIStatusBarStyle explicitly - for iOS 4 and 5
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0)
    {
        NSLog(@"iOS version less than 6.0. Setting statusBarStyle to BlackOpaque");
        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    // setup window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // navigationController - (Front Screen)
    self.navigationController = [[UINavigationController alloc] init];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.delegate = self;
    
    // AppViewController
    AppViewController *appViewController = [[AppViewController alloc] init];
    
    // push onto navigation controller
    [self.navigationController pushViewController:appViewController animated:NO];
    
    // enterWeightViewController - (Rear Screen)
    EnterWeightViewController *enterWeightViewController = [[EnterWeightViewController alloc] init];
    enterWeightViewController.delegate = appViewController;
    
    // ZUUIRevealController
    self.revealController = [[ZUUIRevealController alloc] initWithFrontViewController:self.navigationController rearViewController:enterWeightViewController];
    self.revealController.delegate = enterWeightViewController;
    
    // set rootViewController
    self.window.rootViewController  = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    // DCInstropect tool
#if TARGET_IPHONE_SIMULATOR
    
#if DCINTROSPECT_ON
    
    [[DCIntrospect sharedIntrospector] start];
    
#endif
    
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)saveData
{
    EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)self.revealController.rearViewController;
    
    [enterWeightViewController savePatientList];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@" ");
    NSLog(@"applicationDidEnterBackground");
    
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)self.revealController.rearViewController;
    
    // close patient list if passcode lock is on and patient list has been left open
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired])
    {
        if (!enterWeightViewController.confidentialityModeOn)
        {
            enterWeightViewController.switchObj.on = NO;
            [enterWeightViewController patientConfidentialityModeToggle];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@" ");
    NSLog(@"applicationWillTerminate");
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] stopTracker];
    
#endif
    
    [self saveData];
}

// GANTracker delegate
#pragma mark - GANTrackerDelegate methods

- (void)hitDispatched:(NSString *)hitString
{
    NSLog(@"Hit Dispatched: %@", hitString);
}

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)hitsDispatched
              eventsFailedDispatch:(NSUInteger)hitsFailedDispatch
{
    NSLog(@"Dispatch completed (%u OK, %u failed)", hitsDispatched, hitsFailedDispatch);
}

@end