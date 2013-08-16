//
//  AppDelegate.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#define APP_SHADING 0
#define USE_DIMPLE_BACKGROUND 1

#define BACKGROUND_IPHONE_35_PORTRAIT_PNG @"LightGreyWithDimples35inchRetinaPortrait.png"
#define BACKGROUND_IPHONE_4_PORTRAIT_PNG @"LightGreyWithDimples4inchRetinaPortrait.png"

// Alternatives
// @"LightGrayBackground35inchRetina.png"
// @"LightGrayBackground4inchRetina.png"

#define GOOGLE_ANALYTICS 0
#define FLURRY 1
#define IRATE_SET 0

#define IRATE_PREVIEW_MODE 0
#define DCINTROSPECT_ON 1

// This is just for creating the startup screen images
#define LOADING_GRAPHICS 0

// Features in development
#define FEEDS_AND_FLUIDS_PREVIEW_MODE 0
#define POSTNATAL_WARD_PREVIEW_MODE 0
#define HYPOGLYCAEMIA_PREVIEW_MODE 0
#define CALCULATOR_PREVIEW_MODE 1
#define HANDOVER_PREVIEW_MODE 0
#define CRUSS_PREVIEW_MODE 1
#define DRUGS_PREVIEW_MODE 1

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

@end


