//
//  AppDelegate.h
//  SimNICU
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#define APP_SHADING 0
#define USE_DIMPLE_BACKGROUND 1

#define BACKGROUND_IPHONE_35_PORTRAIT_PNG @"LightGreyWithDimples35inchRetinaPortrait.png"
#define BACKGROUND_IPHONE_4_PORTRAIT_PNG @"LightGreyWithDimples4inchRetinaPortrait.png"

#define GOOGLE_ANALYTICS 0
#define IRATE_PREVIEW_MODE 0
#define IRATE_SET 1
#define DCINTROSPECT_ON 0

// @"LightGrayBackground35inchRetina.png"
// @"LightGrayBackground4inchRetina.png"

#import "ZUUIRevealController.h"
#import "GANTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, GANTrackerDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ZUUIRevealController *revealController;
// @property (strong, nonatomic) ACAccountStore *accountStore;
// @property (strong, nonatomic) ACAccount *twitterAccount;
@property (strong, nonatomic) UIWindow *window;

// - (void)getTwitterAccount;

@end

// WORK IN DEVELOP OR FEATURE

// SWITCH TO RELEASE BRANCH
// (BUG FIXES ONLY)
// 1) GOOGLE_ANALYTICS   set to 0
// 2) IRATE_PREVIEW_MODE set to 0
// 3) IRATE_SET          set to 0
// 4) DCINTROSPECT_ON    set to 0
// 5) Clean
// 6) Increment build
// 7) Git commit
// 8) GitHub Push
// 9) Archive ad hoc
//10) Release to TestFlight

//11) Any bugfixes
//12) Git commit
//13) GitHub push                      beta testing cycle
//14) Swap to develop & merge
//15) Swap back to release branch

//16) Test iOS 4.3.2
//17) Test iOS 5.0
//18) Test iOS 5.1
//19) Test iOS 6.0




// PRE-GOLDEN MASTER CHECKS
//
// 1) GOOGLE_ANALYTICS   set to 1
// 2) IRATE_SET          set to 1
// 3) IRATE_PREVIEW_MODE set to 0
// 4) DCINTROSPECT_ON    set to 0
// 5) Clean
// 6) Increment build
// 6) Increment version and in about
// 7) Git commit (Release)
// 8) GitHub push (Release)
// 9) swap to Develop
//10) Merge release into Develop
//11) swap to MASTER
//12) Merge release into MASTER
//13) GitHub push
//13) Setup in iTunes Connect
//13) ARCHIVE FOR RELEASE
//14) Swap to develop
//15) GitHub push

