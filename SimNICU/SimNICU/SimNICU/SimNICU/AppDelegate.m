//
//  AppDelegate.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "EnterWeightViewController.h"
#import "AppViewController.h"
#import "KKPasscodeLock.h"
#import "DCIntrospect.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "iRate.h"

// Google Analytics dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@interface AppDelegate()

@end

@implementation AppDelegate

+ (void)initialize
{
    
#ifdef LITE_VERSION
    
    NSLog(@"SimNICU Lite log:");
    NSLog(@" ");
    
#else
    
    NSLog(@"Neonatal Intensive Care log:");
    NSLog(@" ");
    
#endif

#if IRATE_SET
    
    // using iRate version 1.6.2
    
#ifdef LITE_VERSION
    
    [iRate sharedInstance].appStoreID = 604031639;
    [iRate sharedInstance].applicationBundleID = @"com.conradbosman.SimNICU-Lite";
    [iRate sharedInstance].applicationName = @"SimNICU Lite";
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"Like SimNICU Lite?", nil);
    [iRate sharedInstance].message = NSLocalizedString(@"Please rate it on the App Store.\nIt will only take a moment, and will help me to work hard on future improvements.", nil);
    
    // Will only prompt after 10 days AND/OR 20 uses, with a remind period of 7 days
    
    [iRate sharedInstance].daysUntilPrompt = 10;
    [iRate sharedInstance].usesUntilPrompt = 20;
    [iRate sharedInstance].remindPeriod = 7;
    
#else
    
    [iRate sharedInstance].appStoreID = 518447654;
    [iRate sharedInstance].applicationBundleID = @"com.conradbosman.SimNICU";
    [iRate sharedInstance].applicationName = @"Neonatal Intensive Care";
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"Find the App useful?", nil);
    [iRate sharedInstance].message = NSLocalizedString(@"Please rate it on the App Store.\nIt will only take a moment, and ratings really help me to work hard on future improvements.", nil);
    
    // Will only prompt after 10 days AND/OR 20 uses, with a remind period of 7 days
    
    [iRate sharedInstance].daysUntilPrompt = 10;
    [iRate sharedInstance].usesUntilPrompt = 20;
    [iRate sharedInstance].remindPeriod = 7;
    
#endif //#endif LITE_VERSION

#else
    
    NSLog(@"iRATE OFF");
    [iRate sharedInstance].promptAtLaunch = NO;
    
#endif //#endif IRATE_SET
    
#if IRATE_PREVIEW_MODE
    
    [iRate sharedInstance].previewMode = YES;
    
#endif
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup security
    [[KKPasscodeLock sharedLock] setDefaultSettings];
    
#ifdef LITE_VERSION
    
    // PARSE FRAMEWORK SETUP
    
    [Parse setApplicationId:@"zmGmyZdJF3Hbk2Z1UI3DpAdrwySHxA2smfydCaTY"
                  clientKey:@"QbQfnVkAFNwHWIowNFLaCZIsv7p5Dz8jiZYdQoA7"];
     
     // Register for push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
     

#endif

#if GOOGLE_ANALYTICS
    
    // Google Analytics
    
#ifdef LITE_VERSION
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-35056388-4"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:self];
    
#else
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-35056388-2"
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:self];

#endif //#endif LITE_VERSION
    
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
    
#endif //#endif GOOGLE_ANALYTICS
    
    // set UIStatusBarStyle explicitly - for iOS 4 and 5
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0)
    {
        NSLog(@"iOS version less than 6.0. Setting statusBarStyle to BlackOpaque");
        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
    
    // setup window
    
    // iAD Banner re-code
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    
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
    
#ifdef LITE_VERSION
    
    self.bannerView = [[ADBannerView alloc] init];
    CGRect frame = self.bannerView.frame;
    frame.origin = CGPointMake(CGRectGetMaxX(screenBounds), CGRectGetMaxY(screenBounds));
    self.bannerView.frame = frame;
    self.bannerView.delegate = self;
    
    self.currentController = (UIViewController <BannerViewContainer> *)self.navigationController.topViewController;
    
    // ensure badges are removed
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
#endif //#endif LITE_VERSION
    
    self.drugDatabase = [[DrugDatabase alloc] init];
    
    return YES;
}

#ifdef LITE_VERSION

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

#endif //#endif LITE_VERSION

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

#pragma mark - ADBannerViewDelegate methods

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"%s", __FUNCTION__);
    [self.currentController showBannerView:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%s %@", __FUNCTION__, error);
    [self.currentController hideBannerView:banner];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    if ([self.currentController respondsToSelector:@selector(bannerViewActionWillBegin)])
    {
        [self.currentController bannerViewActionWillBegin];
    }
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    if ([self.currentController respondsToSelector:@selector(bannerViewActionDidFinish:)])
    {
        [self.currentController bannerViewActionDidFinish];
    }
}

@end