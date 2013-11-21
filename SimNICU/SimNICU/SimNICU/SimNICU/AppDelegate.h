//
//  AppDelegate.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#define USE_DIMPLE_BACKGROUND 1

#define BACKGROUND_IPHONE_35_PORTRAIT_PNG @"LightGreyWithDimples35inchRetinaPortrait.png"
#define BACKGROUND_IPHONE_35_LANDSCAPE_PNG @"LightGreyWithDimples35inchRetinaLandscape.png"
#define BACKGROUND_IPHONE_4_PORTRAIT_PNG @"LightGreyWithDimples4inchRetinaPortrait.png"
#define BACKGROUND_IPHONE_4_LANDSCAPE_PNG @"LightGreyWithDimples4inchRetinaLandscape.png"

#define SECONDARY_BACKGROUND_IPHONE_35_PORTRAIT_PNG @"ScrollViewBackground35inchRetina.png"
#define SECONDARY_BACKGROUND_IPHONE_4_PORTRAIT_PNG @"ScrollViewBackground4inchRetina.png"

// Alternatives
// @"LightGrayBackground35inchRetina.png"
// @"LightGrayBackground4inchRetina.png"

#define GOOGLE_ANALYTICS 0                                  // turn on for release
#define TESTFLIGHT 1                                        // turn off for release
#define FLURRY_LIVE 0
#define IRATE_SET 0                                         // turn on for release

// testing tools
#define IRATE_PREVIEW_MODE 0
#define DCINTROSPECT_ON 0
#define RESET_CELL_INFO 0                                   // WARNING this resets all Daily Summary Data!!!
#define RESET_PREFERENCES_HANDOVER_SECTIONS_CUSTOM_TEXT 1   // this is for custom text
#define CLOCK_IN_TO_HOURSTRACKER_REMINDER 0

// Dynamic Text
#define USE_DYNAMIC_TEXT 1
#define DYNAMIC_TEXT_TESTER 1

// Intro screen
#define INTRO_SCREEN 0                                      // turn on for release (maybe not!)

// This is just for creating the startup screen images
#define LOADING_GRAPHICS 0

// Tools
#define UDBARTRACKBALL 1

// Features in development
// Front VC
#define FEEDS_AND_FLUIDS_PREVIEW_MODE 0
#define POSTNATAL_WARD_PREVIEW_MODE 0
#define FLUID_BALANCE_PREVIEW_MODE 0
#define HYPOGLYCAEMIA_PREVIEW_MODE 0
#define GLUCOSE_LOAD_PREVIEW_MODE 0
#define CALCULATOR_PREVIEW_MODE 0
#define CRUSS_PREVIEW_MODE 0
#define DRUGS_PREVIEW_MODE 0

// Rear VC
#define SYNC_PREVIEW_MODE 0                 // this needs updating for iOS 7

// Settings
#define LOCALISATION_PREVIEW_MODE 0
#define GROWTH_CHART_PREVIEW_MODE 0

#import "ZUUIRevealController.h"
#import "DrugDatabase.h"
#import "GANTracker.h"
#import <iAd/iAd.h>

@protocol BannerViewContainer <NSObject>

- (void)showBannerView:(ADBannerView *)bannerView;
- (void)hideBannerView:(ADBannerView *)bannerView;

@optional

- (void)bannerViewActionWillBegin;
- (void)bannerViewActionDidFinish;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate, GANTrackerDelegate, ADBannerViewDelegate>

@property (nonatomic, assign) UIViewController <BannerViewContainer> *currentController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ZUUIRevealController *revealController;
@property (nonatomic, strong) DrugDatabase *drugDatabase;
@property (nonatomic, strong) NSIndexPath *lastDrugPath;
@property (nonatomic, retain) ADBannerView *bannerView;
@property (strong, nonatomic) UIWindow *window;

// Jobs
// 1) Finish Daily Summary US options
// 2) Now I have started changing over, set standard cell height for all UITableViews?
// 3)
// 4) Add a clear button to Daily Summary Editor
// 5)
// 6) Need to be able to edit the ref of new custom text
// 7) patient.
// 8) Finish dictation commands
// 9) 
//10)
//11) Sort new patient bilirubin graphs
//12) Add current weights

@end


