//
//  AppViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "EnterWeightViewController.h"
#import "KxIntroViewController.h"
#import "ZUUIRevealController.h"
#import "AppViewController.h"
#import "KxIntroViewPage.h"
#import "CBTimeMethods.h"
#import "KxIntroView.h"
#import "AppDelegate.h"
#import "RoundImage.h"
#import "Patient.h"
#import "Screen.h"

// screenControllers - alphabetical order
#import "AboutSimNICUViewController.h"
#import "AgeCalculatorsViewController.h"
#import "APGARTabBarController.h"
#import "APGAR1ViewController.h"
#import "APGAR5ViewController.h"
#import "APGAR10ViewController.h"
#import "APGAR15ViewController.h"
#import "APGAR20ViewController.h"
// #import "BloodProductsTableViewController.h"
#import "BloodProductsViewController.h"
#import "CalculatorViewController.h"
#import "CoolingTableViewController.h"
#import "CurosurfViewController.h"
#import "CDHViewController.h"
#import "CrUSSViewController.h"
#import "CrUSSOptionsTableViewController.h"
#import "DrugsTableViewController.h"
#import "EarlyCareViewController.h"
#import "FluidRequirementsTableViewController.h"
#import "GastroschisisViewController.h"
#import "GlucoseLoadController.h"
#import "CorrectedAgeViewController.h"
#import "HFOVViewController.h"
#import "InfusionsViewController.h"
#import "IntubationViewController.h"
#import "OxygenationIndexViewController.h"
#import "PhototherapyViewController.h"
#import "PhototherapyGraphViewController.h"
#import "PlasticBagViewController.h"
#import "PostnatalWardTableViewController.h"
#import "PulmonaryHaemorrhageViewController.h"
#import "ResusViewController.h"
#import "ROPViewController.h"
#import "InfoTabBarController.h"
#import "TransportVentilatorViewController.h"
#import "UVCUACViewController.h"
#import "VitKTableViewController.h"
#import "WeightConversionViewController.h"
#import "ActionSheetPickerViewController.h"

#import "DynamicTextTesterViewController.h"

@interface AppViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIImageView *displayDismissButtonView;         // gray circle with cross
@property (nonatomic, strong) UIImageView *displaySimNICUDateToggle;         // just to toggle SimNICU / Date
@property (nonatomic, strong) UILabel *displayDetailTextLabel;               // gestation, birth weight, etc
@property (nonatomic, strong) NSString *estimatedWeightUsed;
@property (nonatomic, strong) UILabel *displayAgeTextLabel;
@property (nonatomic, strong) NSString *infoPassedThrough;
@property (nonatomic, strong) UILabel *displayBackground;                    // gray background square
@property (nonatomic, strong) UILabel *displayTextLabel;                     // Patient name
@property (nonatomic, strong) UIImageView *appImageView;                     // Baby being born image
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) GrowthChart *growthChart;
@property (nonatomic, strong) UIImageView *tableBgView;                      // gradient over UITableView
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIView *myHeaderView;
@property (nonatomic, retain) UIView *contentView;                           // both myHeaderView & myTableView
@property (nonatomic) BOOL earlyCareWarningShown;
@property (nonatomic) BOOL patientSelected;

@property (nonatomic, assign) ADBannerView *banner;

- (void)layoutForCurrentOrientation:(BOOL)animated;

@end

@implementation AppViewController
{
    NSMutableArray *screens;
    BOOL appViewControllerLoadingForTheFirstTime;
    
    UILabel *loadingDisplayBackground;
    UILabel *loadingDisplayTextLabel;
    UILabel *loadingDisplayDetailTextLabel;
    
    CGFloat iOS7Adjustment;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // parse code here
        /*
         PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
         [testObject setObject:@"bosman" forKey:@"foo"];
         [testObject saveInBackground];
         */
        
#if GOOGLE_ANALYTICS
        
#else
        NSLog(@"GOOGLE ANALYTICS OFF");
#endif
        
    }
    // System information
    // NSLog(@"uniqueIdentifier: %@", [[UIDevice currentDevice] uniqueIdentifier]);
    NSLog(@" ");
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    NSLog(@"model: %@", [[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@", [[UIDevice currentDevice] localizedModel]);
    NSLog(@"Current locale = %@", [[NSLocale currentLocale] localeIdentifier]);
    NSLog(@" ");
    
    // set toggle
    appViewControllerLoadingForTheFirstTime = YES;
    
    return self;
}

- (void)layoutForCurrentOrientation:(BOOL)animated
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    // by default consumes the entire view area
    CGRect contentFrame = self.view.bounds;
    CGRect myTableViewContentFrame = CGRectMake(10.0f, 160.0f, 300.0f, (appDelegate.window.bounds.size.height - 230));
    
    CGRect myTableBgViewContentFrame;
    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
    {
        myTableBgViewContentFrame = CGRectMake(0.0f, 146.0f, 320.0f, (appDelegate.window.bounds.size.height - 196));
    }
    else
    {
        myTableBgViewContentFrame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 50));
    }

    // the banner still needs to be adjusted further, but this is a reasonable starting point
    // the y value will need to be adjusted by the banner height to get the final position
    CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    if (self.banner != nil)
    {
        // First, setup the banner's content size and adjustment based on the current orientation
        self.banner.currentContentSizeIdentifier = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifierPortrait;
        bannerHeight = self.banner.bounds.size.height;
        
        // Depending on if the banner has been loaded, we adjust the content frame and banner location
        // to accomodate the ad being on or off screen.
        // This layout is for an add at the bottom of the view
        if (self.banner.bannerLoaded)
        {
            contentFrame.size.height -= bannerHeight;
            myTableViewContentFrame.size.height -= bannerHeight;
            myTableBgViewContentFrame.size.height -= bannerHeight;
            
            if (!(appDelegate.window.bounds.size.height == 568)) // 4 inch Retina
            {
                myTableBgViewContentFrame.origin.y += 18;
            }
            
            bannerOrigin.y -= bannerHeight;
        }
        else
        {
            contentFrame.size.height += bannerHeight;
            myTableViewContentFrame.size.height += bannerHeight;
            myTableBgViewContentFrame.size.height += bannerHeight;
            
            if (!(appDelegate.window.bounds.size.height == 568)) // 4 inch Retina
            {
                myTableBgViewContentFrame.origin.y -= 18;
            }
            
            bannerOrigin.y += bannerHeight;
        }
    }
    
    // And finally animate the changes, running layout for the content view if required
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.tableBgView.frame = myTableBgViewContentFrame;
                         [self.tableBgView layoutIfNeeded];
                         self.myTableView.frame = myTableViewContentFrame;
                         [self.myTableView layoutIfNeeded];
                         self.contentView.frame = contentFrame;
                         [self.contentView layoutIfNeeded];
                         
                         self.banner.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y, self.banner.frame.size.width, self.banner.frame.size.height);
                     }];
}

- (void)showBannerView:(ADBannerView *)bannerView
{
    self.banner = bannerView;
    [self.view addSubview:self.banner];
    [self layoutForCurrentOrientation:YES];
}

- (void)hideBannerView:(ADBannerView *)bannerView
{
    [self.banner removeFromSuperview];
    self.banner = nil;
    [self layoutForCurrentOrientation:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        iOS7Adjustment = 20.0f + 44.0f;
    }
    else
    {
        // set the background color to black
        self.view.backgroundColor = [UIColor blackColor];
    }
    
    if ([self.infoPassedThrough isEqualToString:@"Cleared"])
    {
        self.infoPassedThrough = nil;
        NSLog(@"self.infoPassedThrough = nil");
    }
    else if ([self.infoPassedThrough isEqualToString:@"didFinishEnteringWeightOrGestation"] || [self.infoPassedThrough isEqualToString:@"Memory Warning"])
    {
        ZUUIRevealController *revealController = (ZUUIRevealController *)self.parentViewController.parentViewController;
        
        [revealController revealToggle:self];
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Memory Warning"
                                  message:@"Please re-select"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        self.infoPassedThrough = nil;
    }
    else if ([self.infoPassedThrough isEqualToString:@"didFinishSelectingPatient"] || [self.infoPassedThrough isEqualToString:@"Memory Warning"])
    {
        ZUUIRevealController *revealController = (ZUUIRevealController *)self.parentViewController.parentViewController;
        
        [revealController revealToggle:self];
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Memory Warning"
                                  message:@"Please re-select patient"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        self.infoPassedThrough = nil;
    }
    
    NSLog(@"AppViewController viewDidLoad");
    
    // self.contentView is a UIView that covers the entire window and contains
    // both the UITableView and the non-scrolling HeaderView (containing the image)
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f + iOS7Adjustment, (appDelegate.window.bounds.size.width), (appDelegate.window.bounds.size.height - iOS7Adjustment))];
    
    // info button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems infoBarButtonWithTarget:self action:@selector(showAboutScreen)];
    
    // back button text for subsequent screens
    self.navigationItem.backBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:nil action:nil];
    
    // UITableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0f, 160.0f - iOS7Adjustment, 300.0f, (appDelegate.window.bounds.size.height - 230 + iOS7Adjustment)) style:UITableViewStylePlain];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 160.0f - iOS7Adjustment, 320.0f, (appDelegate.window.bounds.size.height - 230 + iOS7Adjustment)) style:UITableViewStylePlain];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0f, 160.0f - iOS7Adjustment, 300.0f, (appDelegate.window.bounds.size.height - 230 + iOS7Adjustment)) style:UITableViewStylePlain];
    }
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 0.0f;
    self.myTableView.sectionHeaderHeight = 0.0f;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.contentView addSubview:self.myTableView];
    
    // Add the screen mask gradient to the UITableView
    self.tableBgView = [UIImageView new];
    
    // screen hack for iOS 7 to prevent options scrolling behind headers
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // Different image gradients for iPhone 4 and iPhone 5
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.tableBgView.frame = CGRectMake(-10.0f, 146.0f, 340.0f, (appDelegate.window.bounds.size.height - 196));
            self.tableBgView.image = [UIImage imageNamed:@"bgOverlay.png"];
        }
        else
        {
            self.tableBgView.frame = CGRectMake(-10.0f, 146.0f, 340.0f, (appDelegate.window.bounds.size.height - 196));
            self.tableBgView.image = [UIImage imageNamed:@"bgOverlay.png"];
        }
    }
    else
    {
        // Different image gradients for iPhone 4 and iPhone 5
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.tableBgView.frame = CGRectMake(0.0f, 146.0f, 320.0f, (appDelegate.window.bounds.size.height - 196));
            self.tableBgView.image = [UIImage imageNamed:@"bgOverlay.png"];
        }
        else
        {
            self.tableBgView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 50));
            self.tableBgView.image = [UIImage imageNamed:@"bgApplication.png"];
        }
    }
    
    self.tableBgView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.tableBgView];
    
    // screen hack for iOS 7 to prevent options scrolling behind headers
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // Different for iPhone 4 and iPhone 5
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            UIImageView *screenHack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScreenHack01.png"]];
            screenHack.frame = CGRectMake(-10.0f, 214.0f - 64.0f, 340.0f, 11.0f);
            [self.contentView addSubview:screenHack];
        }
        else
        {
            UIImageView *screenHack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScreenHack02.png"]];
            screenHack.frame = CGRectMake(-10.0f, 214.0f - 64.0f, 340.0f, 11.0f);
            [self.contentView addSubview:screenHack];
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // header holds image and settings view..
        self.myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 150.0f)];
        
        // IMAGE
        UIImage *image = [UIImage imageNamed:@"SimNICU_MainPhoto640x300.jpg"];
        
        self.appImageView = [[UIImageView alloc] initWithImage:image];
        self.appImageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 150.0f);
        self.appImageView.contentMode = UIViewContentModeScaleToFill;
        [self.myHeaderView addSubview:self.appImageView];
        
        // display background
        self.displayBackground = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 40.0f, 260.0f, 65.0f)];
        self.displayBackground.backgroundColor = [UIColor blackColor];
        self.displayBackground.alpha = .5;
        self.displayBackground.hidden = YES;
        [self.myHeaderView addSubview:self.displayBackground];
        
        // dismiss button image & view
        self.displayDismissButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(265.0f, 42.0f, 22.0f, 22.0f)];
        self.displayDismissButtonView.image = [UIImage imageNamed:@"dismiss2_iOS7.png"];
        self.displayDismissButtonView.userInteractionEnabled = YES;
        self.displayDismissButtonView.hidden = YES;
        [self.myHeaderView addSubview:self.displayDismissButtonView];
        
        // displayTextLabel (Patient's name)
        self.displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 39.0f, 210.0f, 30.0f)];
        self.displayTextLabel.textColor = [UIColor whiteColor];
        self.displayTextLabel.backgroundColor = [UIColor clearColor];
        self.displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.displayTextLabel.adjustsFontSizeToFitWidth = YES;
        self.displayTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayTextLabel];
        
        // displayAgeTextLabel (Age in days)
        self.displayAgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 58.0f, 227.0f, 30.0f)];
        self.displayAgeTextLabel.textColor = [UIColor whiteColor];
        self.displayAgeTextLabel.backgroundColor = [UIColor clearColor];
        self.displayAgeTextLabel.font = [UIFont systemFontOfSize:15.0f];
        self.displayAgeTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayAgeTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayAgeTextLabel];
        
        // displayDetailTextLabel (Gestation, birth weight, corrected gestation, working weight)
        self.displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 76.0f, 230.0f, 30.0f)];
        self.displayDetailTextLabel.textColor = [UIColor whiteColor];
        self.displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        self.displayDetailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        self.displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
        self.displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayDetailTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayDetailTextLabel];
    }
    else
    {
        // header holds image and settings view..
        self.myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 150.0f)];
        
        // IMAGE
        UIImage *image;
        if([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
        {
            // Retina display iPhone
            image = [RoundImage makeRoundCornerImage:[UIImage imageNamed:@"SimNICU_MainPhoto640x300.jpg"]:12:12];
        }
        else
        {
            // non Retina display iPhone/iPod Touch
            image = [RoundImage makeRoundCornerImage:[UIImage imageNamed:@"SimNICU_MainPhoto320x150.jpg"]:6:6];
        }
        
        self.appImageView = [[UIImageView alloc] initWithImage:image];
        self.appImageView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 150.0f);
        self.appImageView.contentMode = UIViewContentModeScaleToFill;
        [self.myHeaderView addSubview:self.appImageView];
        
        // display background
        self.displayBackground = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 40.0f, 245.0f, 65.0f)];
        self.displayBackground.backgroundColor = [UIColor blackColor];
        self.displayBackground.alpha = .5;
        self.displayBackground.hidden = YES;
        [self.myHeaderView addSubview:self.displayBackground];
        
        // dismiss button image & view
        self.displayDismissButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(250.0f, 42.0f, 22.0f, 22.0f)];
        self.displayDismissButtonView.image = [UIImage imageNamed:@"dismiss2.png"];
        self.displayDismissButtonView.userInteractionEnabled = YES;
        self.displayDismissButtonView.hidden = YES;
        [self.myHeaderView addSubview:self.displayDismissButtonView];
        
        // displayTextLabel (Patient's name)
        self.displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 39.0f, 210.0f, 30.0f)];
        self.displayTextLabel.textColor = [UIColor whiteColor];
        self.displayTextLabel.backgroundColor = [UIColor clearColor];
        self.displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.displayTextLabel.adjustsFontSizeToFitWidth = YES;
        self.displayTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayTextLabel];
        
        // displayAgeTextLabel (Age in days)
        self.displayAgeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 58.0f, 227.0f, 30.0f)];
        self.displayAgeTextLabel.textColor = [UIColor whiteColor];
        self.displayAgeTextLabel.backgroundColor = [UIColor clearColor];
        self.displayAgeTextLabel.font = [UIFont systemFontOfSize:15.0f];
        self.displayAgeTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayAgeTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayAgeTextLabel];
        
        // displayDetailTextLabel (Gestation, birth weight, corrected gestation, working weight)
        self.displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 76.0f, 230.0f, 30.0f)];
        self.displayDetailTextLabel.textColor = [UIColor whiteColor];
        self.displayDetailTextLabel.backgroundColor = [UIColor clearColor];
        self.displayDetailTextLabel.font = [UIFont systemFontOfSize:15.0f];
        self.displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
        self.displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
        self.displayDetailTextLabel.hidden = YES;
        [self.myHeaderView addSubview:self.displayDetailTextLabel];
    }
    
    [self.contentView addSubview:self.myHeaderView];
    
    // Add the content view (containing self.myHeaderView and self.myTableView
    [self.view addSubview:self.contentView];
    
    // SimNICU / Date tapGesture button
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    
    // create an invisible UIView over the SimNICU to allow taps
    CGRect frame = CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 44);
    UIView *navBarTapView = [[UIView alloc] initWithFrame:frame];
    [self.navigationController.navigationBar addSubview:navBarTapView];
    navBarTapView.backgroundColor = [UIColor clearColor];
    navBarTapView.userInteractionEnabled = YES;
    [navBarTapView addGestureRecognizer:self.tapGestureRecognizer];
}

-(void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterShortStyle;
    
    self.title = [formatter stringFromDate:currentDate];
        
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        self.title = NSLocalizedString(@"Neonatal Intensive Care", @"App Title, noun");
        
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef LITE_VERSION
    
    if (!self.title) self.title = NSLocalizedString(@"Neonatal Intensive Care", @"App Title, noun");
    
#else
    
    if (!self.title) self.title = NSLocalizedString(@"Neonatal Intensive Care", @"App Title, noun");
    
#endif
    
    if (appViewControllerLoadingForTheFirstTime)
    {
        // recreate loading screen to animate off
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // display background
            loadingDisplayBackground = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 40.0f, 260.0f, 65.0f)];
            loadingDisplayBackground.backgroundColor = [UIColor blackColor];
            loadingDisplayBackground.hidden = NO;
            loadingDisplayBackground.alpha = .4;
            [self.myHeaderView addSubview:loadingDisplayBackground];
            
            // displayTextLabel
            loadingDisplayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f + 70.0f, 39.0f + 8.0f, 210.0f, 30.0f)];
            loadingDisplayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            loadingDisplayTextLabel.backgroundColor = [UIColor clearColor];
            loadingDisplayTextLabel.textAlignment = UITextAlignmentLeft;
            loadingDisplayTextLabel.textColor = [UIColor whiteColor];
            loadingDisplayTextLabel.adjustsFontSizeToFitWidth = YES;
            loadingDisplayTextLabel.text = @"LOADING";
            loadingDisplayTextLabel.hidden = NO;
            [self.myHeaderView addSubview:loadingDisplayTextLabel];
            
            // displayDetailTextLabel
            loadingDisplayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0f + 70.0f, 60.0f + 8.0f, 210.0f, 30.0f)];
            loadingDisplayDetailTextLabel.backgroundColor = [UIColor clearColor];
            loadingDisplayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
            loadingDisplayDetailTextLabel.textAlignment = UITextAlignmentLeft;
            loadingDisplayDetailTextLabel.textColor = [UIColor whiteColor];
            loadingDisplayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
            loadingDisplayDetailTextLabel.text = @"Please wait...";
            loadingDisplayDetailTextLabel.hidden = NO;
            [self.myHeaderView addSubview:loadingDisplayDetailTextLabel];
            
#if CLOCK_IN_TO_HOURSTRACKER_REMINDER
            
            loadingDisplayTextLabel.text = @"CLOCK IN";
            loadingDisplayDetailTextLabel.text = @"";
            
#endif
        }
        else
        {
            // display background
            loadingDisplayBackground = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 40.0f, 245.0f, 50.0f)];
            loadingDisplayBackground.backgroundColor = [UIColor blackColor];
            loadingDisplayBackground.hidden = NO;
            loadingDisplayBackground.alpha = .4;
            [self.myHeaderView addSubview:loadingDisplayBackground];
            
            // displayTextLabel
            loadingDisplayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 39.0f, 210.0f, 30.0f)];
            loadingDisplayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
            loadingDisplayTextLabel.backgroundColor = [UIColor clearColor];
            loadingDisplayTextLabel.textAlignment = UITextAlignmentCenter;
            loadingDisplayTextLabel.textColor = [UIColor whiteColor];
            loadingDisplayTextLabel.adjustsFontSizeToFitWidth = YES;
            loadingDisplayTextLabel.text = @"LOADING";
            loadingDisplayTextLabel.hidden = NO;
            [self.myHeaderView addSubview:loadingDisplayTextLabel];
            
            // displayDetailTextLabel
            loadingDisplayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 60.0f, 227.0f, 30.0f)];
            loadingDisplayDetailTextLabel.backgroundColor = [UIColor clearColor];
            loadingDisplayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
            loadingDisplayDetailTextLabel.textAlignment = UITextAlignmentCenter;
            loadingDisplayDetailTextLabel.textColor = [UIColor whiteColor];
            loadingDisplayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
            loadingDisplayDetailTextLabel.text = @"Please wait...";
            loadingDisplayDetailTextLabel.hidden = NO;
            [self.myHeaderView addSubview:loadingDisplayDetailTextLabel];
        }
    }
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // check if RevealController can respond to selectors
    if ([appDelegate.revealController respondsToSelector:@selector(revealToggle:)] && [appDelegate.revealController respondsToSelector:@selector(revealGesture:)])
    {
        // transparent button over the app's image triggers reveal transition
        UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            flipButton.frame = CGRectMake(00.0f, 0.0f + 64.0f, 320.0f, 150.0f);
        }
        else
        {
            flipButton.frame = CGRectMake(10.0f, 0.0f, 275.0f, 150.0f);
        }
        [flipButton addTarget:appDelegate.revealController action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:flipButton];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:appDelegate.revealController action:@selector(revealGesture:)];
        [flipButton addGestureRecognizer:self.panGestureRecognizer];
        
        // Enter Weight button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:appDelegate.revealController action:@selector(revealToggle:)];
    }
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.dismissButton.frame = CGRectMake(255.0f, 33.0f + 64.0f, 40.0f, 40.0f);
    }
    else
    {
        self.dismissButton.frame = CGRectMake(250.0f, 35.0f, 40.0f, 40.0f);
    }
    
    [self.dismissButton addTarget:self action:@selector(clearScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    // init screens list
    screens = [[NSMutableArray alloc] initWithCapacity:20];
    
    Screen *screen;
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"APGAR scores", nil);
    screen.segueId = @"APGAR";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Blood Products", nil);
    screen.segueId = @"BloodProducts";
    [screens addObject:screen];
    
#if CALCULATOR_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Calculator", nil);
    screen.segueId = @"Calculator";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Cooling", nil);
    screen.segueId = @"Cooling";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Corrected Age", nil);
    screen.segueId = @"Age Calculators";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Cranial Ultrasound", nil);
    screen.segueId = @"CrUSS";
    
    /*
#if CRUSS_PREVIEW_MODE
    
    screen.detailMenuText = @"New Image Viewer!";
    
#endif
     */
    
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = @"Curosurf\u00AE";
    screen.segueId = @"Curosurf";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Diaphragmatic Hernia", nil);
    screen.segueId = @"CDH";
    [screens addObject:screen];
    
#if DRUGS_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Drugs", nil);
    screen.segueId = @"Drugs";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Early Care", nil);
    screen.segueId = @"EarlyCare";
    [screens addObject:screen];
    
#if FLUID_BALANCE_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = @"Fluid Balance";
    screen.segueId = @"FluidBalance";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Fluid Requirements", nil);
    screen.segueId = @"FluidRequirements";
    [screens addObject:screen];
    
#if FEEDS_AND_FLUIDS_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = @"Feeds & Fluids";
    screen.segueId = @"FeedsAndFluids";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Gastroschisis", nil);
    screen.segueId = @"Gastroschisis";
    [screens addObject:screen];
    
#if GLUCOSE_LOAD_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Glucose Load", nil);
    
    screen.detailMenuText = @"Coming soon!";
    screen.segueId = @"GlucoseInfusionRate";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        screen.menuText = NSLocalizedString(@"High Frequency Oscillation", nil);
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.0)
    {
        screen.menuText = @"HFOV";
    }
    screen.segueId = @"HFOV";
    [screens addObject:screen];
    
#if HYPOGLYCAEMIA_PREVIEW_MODE
    
     screen = [Screen new];
     screen.menuText = NSLocalizedString(@"Hypoglycaemia Screen", nil);
     screen.segueId = @"Hypo";
     [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Infusions", nil);
    screen.segueId = @"Infusions";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Intubation", nil);
    screen.segueId = @"Intubation";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Naloxone (Narcan\u00AE)", nil);
    screen.segueId = @"Narcan";
    [screens addObject:screen];
    
    // Outcomes
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Oxygenation Index", nil);
    screen.segueId = @"OI";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Phototherapy", nil);
    screen.segueId = @"Phototherapy";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Plastic Bag (at delivery)", nil);
    screen.segueId = @"Thermoregulation";
    [screens addObject:screen];
    
#if POSTNATAL_WARD_PREVIEW_MODE
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Postnatal Ward Problems", nil);
    screen.segueId = @"PostnatalWard";
    [screens addObject:screen];
    
#endif
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Pulmonary Haemorrhage", nil);
    screen.segueId = @"PulmonaryHaemorrhage";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Resuscitation Drugs", nil);
    screen.segueId = @"Resus";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Retinopathy of Prematurity", nil);
    screen.segueId = @"ROP";
    [screens addObject:screen];
    
    // Sarnat score
    
    /*
     screen = [Screen new];
     screen.menuText = @"Seizures";
     screen.segueId = @"Fits";
     [screens addObject:screen];
     */
    
    // Sodium correction
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Transport Ventilator", nil);
    screen.segueId = @"BabyPac";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"UAC / UVC", nil);
    screen.segueId = @"UACUVC";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Vitamin K", nil);
    screen.segueId = @"VitK";
    [screens addObject:screen];
    
    screen = [Screen new];
    screen.menuText = NSLocalizedString(@"Weight Conversion", nil);
    screen.segueId = @"WeightConversion";
    [screens addObject:screen];
    
#if DYNAMIC_TEXT_TESTER
    
    screen = [Screen new];
    screen.menuText = @"Dynamic Text Tester";
    screen.segueId = @"DynamicTextTester";
    [screens addObject:screen];
    
#endif
    
    appDelegate.currentController = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (appViewControllerLoadingForTheFirstTime)
    {
        // This is used to create the Launch images easily
#if LOADING_GRAPHICS
        
        // do not animate the load screen off...
#else
        // clear loading screen animation
        
#if CLOCK_IN_TO_HOURSTRACKER_REMINDER
        CGFloat animationDuration = 3.0f;
#else
        CGFloat animationDuration = 0.5f;
#endif
        CGFloat animationDelay = 0.0f;
        
        [UIView animateWithDuration:animationDuration
                              delay:animationDelay
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             loadingDisplayDetailTextLabel.alpha = 0.0f;
                             loadingDisplayBackground.alpha = 0.0f;
                             loadingDisplayTextLabel.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             
                             // animation finished
                             loadingDisplayDetailTextLabel.hidden = YES;
                             loadingDisplayBackground.hidden = YES;
                             loadingDisplayTextLabel.hidden = YES;
                             
                             loadingDisplayDetailTextLabel.alpha = 0.4f;
                             loadingDisplayBackground.alpha = 0.4f;
                             loadingDisplayTextLabel.alpha = 0.4f;
                             
                             appViewControllerLoadingForTheFirstTime = NO;
                             
#if INTRO_SCREEN
                             
                             [self showIntroScreen];
                             
#endif
                         }];
        
#endif
        
    }
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.infoPassedThrough = @"Memory Warning";
    
    NSLog(@"AppViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"AppViewController unloaded properties");
        
        self.panGestureRecognizer = nil;
        self.appImageView = nil;
        self.myHeaderView = nil;
        self.myTableView = nil;
        self.tableBgView = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.infoPassedThrough = @"Memory Warning";
    
    self.panGestureRecognizer = nil;
    self.appImageView = nil;
    self.myHeaderView = nil;
    self.myTableView = nil;
    self.tableBgView = nil;
}

- (NSUInteger)supportedInterfaceOrientations
{
    // return UIInterfaceOrientationPortrait;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3; // Emergency
    else return [screens count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (section == 0) header = NSLocalizedString(@"Emergency", nil);
    else if (section == 1) header = NSLocalizedString(@"General", nil);
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    static NSString *CellIdentifier;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            CellIdentifier = @"InfusionsCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Infusions", nil);
            // [CBFonts textFormattingForLabel:cell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
            
            returnCell = cell;
        }
        else if (indexPath.row == 1)
        {
            CellIdentifier = @"IntubationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Intubation", nil);
            // [CBFonts textFormattingForLabel:cell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
            
            returnCell = cell;
        }
        else
        {
            CellIdentifier = @"ResuscitationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Resuscitation Drugs", nil);
            // [CBFonts textFormattingForLabel:cell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
            
            returnCell = cell;
        }
    }
    else
    {
        CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }

        Screen *thisScreen = screens[indexPath.row];
        cell.textLabel.text = [thisScreen menuText];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        cell.detailTextLabel.text = [thisScreen detailMenuText];
        
        // [CBFonts textFormattingForLabel:cell.textLabel withTextStyle:UIFontTextStyleBody minFontSize:17.0f];
        // [CBFonts detailTextFormattingForLabel:cell.detailTextLabel withTextStyle:UIFontTextStyleFootnote minFontSize:14.0f];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if reveal controller is showing rear then do not allow selection
    ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
    
    if (revealController.currentFrontViewPosition) return nil;
    else return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Special 'Emergency'
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            InfusionsViewController *newViewController = [[InfusionsViewController alloc] init];
            
            if (self.selectedPatient.workingWeight)
            {
                newViewController.workingWeight = self.selectedPatient.workingWeight;
            }
            else if (self.weight)
            {
                newViewController.workingWeight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            IntubationViewController *newViewController = [[IntubationViewController alloc] init];
            
            if (self.selectedPatient)
            {
                newViewController.gestation = self.selectedPatient.gestation;
                newViewController.weight = self.selectedPatient.workingWeight;
                newViewController.selectedPatient = self.selectedPatient;
            }
            else
            {
                newViewController.gestation = self.gestation;
                newViewController.weight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        else if (indexPath.row == 2)
        {
            ResusViewController *newViewController = [[ResusViewController alloc] init];
            newViewController.workingWeight = self.weight;

            [self.navigationController pushViewController:newViewController animated:YES];
        }
    }
    else
    {
        Screen *thisScreen = screens[indexPath.row];
        
        // NSString *thisScreenType = [thisScreen segueId];
        NSString *thisScreenType = thisScreen.segueId;
        
#pragma mark Age Calculators
        
        if([thisScreenType isEqualToString:@"Age Calculators"])
        {
            AgeCalculatorsViewController *newViewController = [[AgeCalculatorsViewController alloc] init];
            newViewController.selectedPatient = self.selectedPatient;
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark APGAR
        
        else if([thisScreenType isEqualToString:@"APGAR"])
        {
            APGARTabBarController *newAPGARTabBarController = [[APGARTabBarController alloc] init];
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            newAPGARTabBarController.delegate2 = (EnterWeightViewController *)enterWeightViewController;
            newAPGARTabBarController.selectedPatient = self.selectedPatient;
            newAPGARTabBarController.tempPatient = self.tempPatient;
            newAPGARTabBarController.delegateAppVC = self;
            
            [self.navigationController pushViewController:newAPGARTabBarController animated:YES];
        }
        
#pragma mark Blood Products
        
        else if ([thisScreenType isEqualToString:@"BloodProducts"])
        {
            BloodProductsViewController *newViewController = [BloodProductsViewController new];
            // BloodProductsTableViewController *newViewController = [[BloodProductsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            newViewController.workingWeight = self.weight;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Calculator
        
        else if ([thisScreenType isEqualToString:@"Calculator"])
        {
            CalculatorViewController *newViewController = [CalculatorViewController new];
            
            if (self.selectedPatient)
            {
                newViewController.selectedPatient = self.selectedPatient;
            }
            else if (self.weight)
            {
                Patient *tempPatient =  [Patient new];
                tempPatient.workingWeight = self.weight;
                
                newViewController.selectedPatient = tempPatient;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Cooling
        
        else if ([thisScreenType isEqualToString:@"Cooling"])
        {
            CoolingTableViewController *vc = [[CoolingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
            [self.navigationController pushViewController:vc animated:YES];
        }
        
#pragma mark Curosurf
        
        else if ([thisScreenType isEqualToString:@"Curosurf"])
        {
            CurosurfViewController *newViewController = [CurosurfViewController new];

            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Cranial Ultrasound
        
        else if ([thisScreenType isEqualToString:@"CrUSS"])
        {

#if CRUSS_PREVIEW_MODE
            
            CrUSSOptionsTableViewController *vc = [[CrUSSOptionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
#else
            CrUSSViewController *vc = [CrUSSViewController new];
#endif
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
#pragma mark Congenital Diaphragmatic Hernia
        
        else if ([thisScreenType isEqualToString:@"CDH"])
        {
            CDHViewController *newViewController = [CDHViewController new];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Drugs
        
        else if ([thisScreenType isEqualToString:@"Drugs"])
        {
            // DrugsViewController *newViewController = [DrugsViewController new];
            DrugsTableViewController *newViewController = [[DrugsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            newViewController.index = 0;
            
            if (self.selectedPatient.workingWeight)
            {
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.workingWeight = self.selectedPatient.workingWeight;
            }
            else if (self.weight)
            {
                newViewController.workingWeight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Early Care
        
        else if ([thisScreenType isEqualToString:@"EarlyCare"])
        {
            EarlyCareViewController *vc = [[EarlyCareViewController alloc] initWithStyle:UITableViewStylePlain];
            
            if (self.earlyCareWarningShown)
            {
                vc.earlyCareWarningShown = YES;
            }
            else
            {
                self.earlyCareWarningShown = YES;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        else if ([thisScreenType isEqualToString:@"FluidBalance"])
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
#pragma mark Fluid Requirements
        
        else if ([thisScreenType isEqual:@"FluidRequirements"])
        {
            FluidRequirementsTableViewController *newViewController = [[FluidRequirementsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            if (self.selectedPatient.workingWeight)
            {
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.workingWeight = self.selectedPatient.workingWeight;
            }
            else if (self.weight)
            {
                newViewController.workingWeight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Feeds & Fluids
        
        else if ([thisScreenType isEqualToString:@"FeedsAndFluids"])
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
#pragma mark Gastroschisis
        
        else if ([thisScreenType isEqualToString:@"Gastroschisis"])
        {
            GastroschisisViewController *newViewController = [GastroschisisViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Glucose Load
        
        else if ([thisScreenType isEqualToString:@"GlucoseInfusionRate"])
        {
#if GLUCOSE_LOAD_PREVIEW_MODE
            
            GlucoseLoadController *newViewController = [GlucoseLoadController new];;
            [self.navigationController pushViewController:newViewController animated:YES];
            
#else
            [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
#endif
        }
        
#pragma mark HFOV
        
        else if ([thisScreenType isEqualToString:@"HFOV"])
        {
            HFOVViewController *newViewController = [HFOVViewController new];;

            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Infusions
        
        else if ([thisScreenType isEqualToString:@"Infusions"])
        {
            InfusionsViewController *newViewController = [InfusionsViewController new];;
            
            if (self.selectedPatient.workingWeight)
            {
                newViewController.workingWeight = self.selectedPatient.workingWeight;
            }
            else if (self.weight)
            {
                newViewController.workingWeight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Intubation
        
        else if ([thisScreenType isEqualToString:@"Intubation"])
        {
            IntubationViewController *newViewController = [IntubationViewController new];;
            
            if (self.selectedPatient)
            {
                newViewController.gestation = self.selectedPatient.gestation;
                newViewController.weight = self.selectedPatient.workingWeight;
                newViewController.selectedPatient = self.selectedPatient;        // any changes here to update above also...
            }
            else
            {
                newViewController.gestation = self.gestation;
                newViewController.weight = self.weight;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Narcan
        
        else if ([thisScreenType isEqualToString:@"Narcan"])
        {
            NSLog(@"showNarcan");
            
            ResusViewController *newViewController = [ResusViewController new];;
            newViewController.workingWeight = self.weight;
            newViewController.narcanSelected = @"YES";
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Oxygenation Index
        
        else if ([thisScreenType isEqualToString:@"OI"])
        {
            
#ifdef LITE_VERSION
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"SimNICU Lite Version"
                                      message:@"Oxygenation Index calculator is disabled in the Lite Version."
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
#else
            
            OxygenationIndexViewController *newViewController = [OxygenationIndexViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];
            
#endif
            
        }
        
#pragma mark Thermaoregulation
        
        else if ([thisScreenType isEqualToString:@"Thermoregulation"])
        {
            PlasticBagViewController *newViewController = [PlasticBagViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Phototherapy
        
        else if ([thisScreenType isEqualToString:@"Phototherapy"])
        {
            PhototherapyViewController *newViewController = [PhototherapyViewController new];;
            
            if (self.selectedPatient.gestation)
            {
                NSLog(@"self.selectedPatient.gestation = YES");
                
                newViewController.selectedPatient = self.selectedPatient;
                newViewController.gestationLocked = @"YES";
            }
            else if (self.gestation)
            {
                if ([self.gestation integerValue] >= 38)
                {
                    newViewController.gestation = [NSNumber numberWithInt:38];
                }
                else
                {
                    newViewController.gestation = [NSNumber numberWithInt:[self.gestation integerValue]];
                }
                
                newViewController.gestationLocked = @"YES";
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Postnatal Ward
        
        else if ([thisScreenType isEqualToString:@"PostnatalWard"])
        {
            PostnatalWardTableViewController *newViewController = [[PostnatalWardTableViewController alloc] initWithStyle:UITableViewStylePlain];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Pulmonary Haemorrhage
        
        else if ([thisScreenType isEqualToString:@"PulmonaryHaemorrhage"])
        {
            PulmonaryHaemorrhageViewController *newViewController = [PulmonaryHaemorrhageViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Resuscitation
        
        else if ([thisScreenType isEqualToString:@"Resus"])
        {
            ResusViewController *newViewController = [ResusViewController new];;
            newViewController.workingWeight = self.weight;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Retinopathy of Prematurity
        
        else if ([thisScreenType isEqualToString:@"ROP"])
        {
            ROPViewController *newViewController = [ROPViewController new];;
            
            newViewController.selectedPatient = self.selectedPatient;
            
            if ((!self.selectedPatient) && (self.gestation || self.weight))
            {
                Patient *newPatient = [Patient new];;
                
                if (self.gestation && self.weight)
                {
                    newPatient.gestation = self.gestation;
                    newPatient.birthWeight = self.weight;
                }
                else if (self.gestation)
                {
                    newPatient.gestation = self.gestation;
                    newPatient.birthWeight = NULL;
                }
                else if (self.weight)
                {
                    newPatient.birthWeight = self.weight;
                    newPatient.gestation = NULL;
                }
                
                if ([self.estimatedWeightUsed isEqualToString:@"YES"])
                {
                    newViewController.estimatedWeightUsed = @"YES";
                }
                newViewController.selectedPatient = newPatient;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Transport Ventilator
        
        else if ([thisScreenType isEqualToString:@"BabyPac"])
        {
            TransportVentilatorViewController *newViewController = [TransportVentilatorViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Umbilical Lines

        else if ([thisScreenType isEqualToString:@"UACUVC"])
        {
            UVCUACViewController *newViewController = [UVCUACViewController new];;
            
            newViewController.selectedPatient = self.selectedPatient;
            
            if ((!self.selectedPatient) && (self.gestation || self.weight))
            {
                Patient *newPatient = [Patient new];;
                
                if (self.gestation && self.weight)
                {
                    newPatient.gestation = self.gestation;
                    newPatient.birthWeight = self.weight;
                }
                else if (self.gestation)
                {
                    newPatient.gestation = self.gestation;
                    newPatient.birthWeight = NULL;
                }
                else if (self.weight)
                {
                    newPatient.birthWeight = self.weight;
                    newPatient.gestation = NULL;
                }
                
                if ([self.estimatedWeightUsed isEqualToString:@"YES"])
                {
                    newViewController.estimatedWeightUsed = @"YES";
                }
                newViewController.selectedPatient = newPatient;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Vitamin K
        
        else if ([thisScreenType isEqualToString:@"VitK"])
        {
            VitKTableViewController *vc = [[VitKTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
#pragma mark Weight Conversion
        
        else if ([thisScreenType isEqualToString:@"WeightConversion"])
        {
            
#ifdef LITE_VERSION
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"SimNICU Lite Version"
                                      message:@"Weight conversion table is disabled in the Lite Version."
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            
#else
            
            WeightConversionViewController *newViewController = [WeightConversionViewController new];;
            
            [self.navigationController pushViewController:newViewController animated:YES];

#endif
            
#pragma mark DynamicTextTester
        }
        else if ([thisScreenType isEqualToString:@"DynamicTextTester"])
        {
            DynamicTextTesterViewController *vc = [DynamicTextTesterViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

#pragma mark -

- (void)showIntroScreen
{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"Welcome!"
                                                          withDetail: @"This brief introduction will show you the basics."
                                                           withImage: [UIImage imageNamed:@"SimNICU_MainPhoto640x300.jpg"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"Step One"
                                                          withDetail: @"Press the button in the top left hand corner."
                                                           withImage: [UIImage imageNamed:@"screen01b.png"]];
    
    KxIntroViewPage *page2 = [KxIntroViewPage introViewPageWithTitle: @"Step Two"
                                                          withDetail: @"Enter a weight or gestation, then press Done."
                                                           withImage: [UIImage imageNamed:@"screen02a.png"]];
    
    KxIntroViewPage *page3 = [KxIntroViewPage introViewPageWithTitle: @"Step Three"
                                                          withDetail: @"Select an option from the menu."
                                                           withImage: [UIImage imageNamed:@"screen01c.png"]];
    
    KxIntroViewPage *page4 = [KxIntroViewPage introViewPageWithTitle: @"Done!"
                                                          withDetail: @""
                                                           withImage: [UIImage imageNamed:@"screen03a.png"]];
    
    
    KxIntroViewController *newViewController;
    
    newViewController = [[KxIntroViewController alloc ] initWithPages:@[ page0, page1, page2, page3, page4]];
    newViewController.introView.animatePageChanges = YES;
    newViewController.introView.gradientBackground = YES;
    
    [newViewController presentInViewController:self fullScreenLayout:NO];
}

- (void)showAboutScreen
{
    InfoTabBarController *newViewController = [InfoTabBarController new];;
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        navController.navigationBar.barTintColor = [UIColor grayColor];
        navController.navigationBar.tintColor = [UIColor redColor];
    }
    else
    {
        navController.navigationBar.tintColor = [UIColor blackColor];
        navController.topViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    }
    
    [self presentModalViewController:navController animated:YES];
}

# pragma mark - enterWeightViewController delegate methods

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishSelectingPatient:(Patient *)patient
{
    self.selectedPatient = patient;
    
    self.displayTextLabel.text = [self.selectedPatient returnDisplayTextLabelText];
    
    if (self.selectedPatient.birthDate)
    {
        NSMutableArray *formattedDates = [CBTimeMethods getFormattedYearsMonthsWeeksDaysDifferenceBetween:self.selectedPatient.birthDate and:[NSDate date]];
        
        NSString *correctedAge = formattedDates[2];
        
        // display days and corrected age
        self.displayAgeTextLabel.text = [NSString stringWithFormat:@"day %i (%@)", [CBTimeMethods getAgeInDaysOfPatient:self.selectedPatient], correctedAge];
    }
    
    self.displayDetailTextLabel.text = [self.selectedPatient returnTwoLineDetailDisplayLabelText];
    
    // set weight and gestation
    if (patient.gestation && patient.workingWeight)
    {
        self.gestation = patient.gestation;
        self.weight = patient.workingWeight;
    }
    else if (patient.gestation && !patient.workingWeight)
    {
        self.weight = [GrowthChart getWeightForSex:@"Unknown" atCentile:@"50th" atGestation:patient.gestation];
        self.gestation = patient.gestation;
    }
    else if (!patient.gestation && patient.workingWeight)
    {
        self.weight = patient.workingWeight;
        self.gestation = nil;
    }
    
    // add text
    self.displayBackground.hidden = NO;
    self.displayTextLabel.hidden = NO;
    self.displayAgeTextLabel.hidden = NO;
    self.displayDetailTextLabel.hidden = NO;
    self.displayDismissButtonView.hidden = NO;
    
    self.patientSelected = YES;
}

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishEnteringWeight:(NSString *)weight orGestation:(NSString *)gestation forSex:(NSString *)sex atCentile:(NSString *)centile
{
    // remove patient details, as working with weight or gestation data
    self.selectedPatient = NULL;
    
    // why is this important?
    self.infoPassedThrough = @"didFinishEnteringWeightOrGestation";
    
    // ensure non-valid strings are not entered
    if([weight isEqualToString:@""] || [weight isEqualToString:@"0"] || [weight isEqualToString:@"0."] || [weight isEqualToString:@"0,"] || [weight isEqualToString:@"0٫"] || [weight isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]) weight = NULL;
    
    if([gestation isEqualToString:@""]) gestation = NULL;
    
    // Arabic numbers are not supported. Therefore convert arabic decimal separator to english
    // If weight string contains the arabic decimal separator then replace it with a dot.
    // NSString *arabicDecimalSeparator = @"٫";
    if (!([weight rangeOfString:@"٫"].location == NSNotFound))
    {
        weight = [weight stringByReplacingOccurrencesOfString:@"٫" withString:@"."]; // check this out later
    }
    
    // goes through the entire string and replaces any commas with full stops in case
    // user is using a european locale
    NSString *UKLocaleWeight;
    UKLocaleWeight = [weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleWeight = [weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    // ensure that weight is not less that 300 grams
    float weightFloat = [UKLocaleWeight floatValue];
    
    if (weightFloat < 0.3f && !(weight == NULL))
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"WARNING!"
                                  message:@"This app does not work with weights less than 300 grams"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        weight = NULL;
        
        return;
    }
    
    
    if (gestation && !weight)      // gestation entered but no weight
    {        
        // set display text
        if ([sex isEqualToString:@"Unknown"] && [centile isEqualToString:@"50th"])
        {
            self.displayTextLabel.text = [NSString stringWithFormat:@"%@ weeks gestation", gestation];
        }
        else
        {
            self.displayTextLabel.text = [NSString stringWithFormat:@"%@/40 %@ (%@ centile)", gestation, sex, centile];
        }
        
        // obtain estimated weight from growth chart
        NSString *estimatedWeight;
        
        // create growth chart and retrieve estimated weight
        // self.growthChart = [GrowthChart new];;
        
        estimatedWeight = [GrowthChart getWeightForSex:sex atCentile:centile atGestation:gestation];
        
        // always returns UKLocale value
        float estimatedWeightKGAsFloat = [estimatedWeight floatValue];
        
        if(estimatedWeightKGAsFloat < 1)
        {
            // convert to grams as use integer
            int estimatedWeightGRAMSasInt = estimatedWeightKGAsFloat * 1000;
            
            self.displayDetailTextLabel.text = [NSString stringWithFormat:@"Estimated weight %i grams", estimatedWeightGRAMSasInt];
        }
        else
        {
            NSNumberFormatter *formatter =  [NSNumberFormatter new];;
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            // if locale has an arabic decimal separator then use english
            if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
            {
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            }
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 3;
            
            self.displayDetailTextLabel.text = [NSString stringWithFormat:@"Estimated weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:estimatedWeightKGAsFloat]]];
        }
        
        // add text
        self.displayAgeTextLabel.text = @"";
        self.displayDetailTextLabel.hidden = NO;
        self.displayAgeTextLabel.hidden = NO;
        self.displayBackground.hidden = NO;
        self.displayTextLabel.hidden = NO;
        self.displayDismissButtonView.hidden = NO;
        
        // localisation checker
        if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
        {
            // replace dots with commas
            estimatedWeight = [estimatedWeight stringByReplacingOccurrencesOfString:@"." withString:@","];
        }
        
        self.weight = estimatedWeight;
        
        self.estimatedWeightUsed = @"YES";
        
        self.gestation = gestation;
        
        // Flurry event
        NSDictionary *articleParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Gestation", gestation,
         @"Sex", sex,
         @"Centile", centile,
         nil];
        
        [Flurry logEvent:@"User didFinishEnteringWeightOrGestation" withParameters:articleParams];
    }
    else if(weight && !gestation)  // weight entered but no gestation
    {
        float weightKGAsFloat = [UKLocaleWeight floatValue];
        
        if(weightKGAsFloat < 1)
        {
            // convert to grams as use integer
            int weightGRAMSasInt = weightKGAsFloat * 1000;
            self.displayTextLabel.text = [NSString stringWithFormat:@"%i grams", weightGRAMSasInt];
        }
        else
        {
            self.displayTextLabel.text = [NSString stringWithFormat:@"%@ kg", weight];
        }
        
        self.displayDetailTextLabel.text = NSLocalizedString(@"Working Weight", nil);
        self.displayAgeTextLabel.text = @"";
        self.displayDetailTextLabel.hidden = NO;
        self.displayAgeTextLabel.hidden = NO;
        self.displayBackground.hidden = NO;
        self.displayTextLabel.hidden = NO;
        self.displayDismissButtonView.hidden = NO;
        
        self.weight = weight;
    }
    else if(weight && gestation)   // both weight and gestation entered
    {
        float weightKGAsFloat = [UKLocaleWeight floatValue];
        
        if(weightKGAsFloat < 1)
        {
            // convert to grams as use integer
            int weightGRAMSasInt = weightKGAsFloat * 1000;
            self.displayTextLabel.text = [NSString stringWithFormat:@"%i grams", weightGRAMSasInt];
        }
        else
        {
            self.displayTextLabel.text = [NSString stringWithFormat:@"%@ kg", weight];
        }
        
        self.displayDetailTextLabel.text = @"Working Weight";
        self.displayDetailTextLabel.hidden = NO;
        self.displayAgeTextLabel.hidden = NO;
        self.displayBackground.hidden = NO;
        self.displayTextLabel.hidden = NO;
        self.displayDismissButtonView.hidden = NO;
        
        self.gestation = gestation;
        self.weight = weight;
    }
    
    // APGAR
    if (self.tempPatient)
    {
        self.displayAgeTextLabel.text = @"APGAR scores saved";
    }
}

- (void)clearScreen
{
    CGFloat animationDuration = 0.5f;
    CGFloat animationDelay = 0.0f;
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.displayDismissButtonView.alpha = 0.0f;
                         self.displayDetailTextLabel.alpha = 0.0f;
                         self.displayAgeTextLabel.alpha = 0.0f;
                         self.displayBackground.alpha = 0.0f;
                         self.displayTextLabel.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         // animation finished
                         self.displayDismissButtonView.hidden = YES;
                         self.displayDetailTextLabel.hidden = YES;
                         self.displayAgeTextLabel.hidden = YES;
                         self.displayBackground.hidden = YES;
                         self.displayTextLabel.hidden = YES;
                         
                         // reset alpha
                         self.displayDismissButtonView.alpha = 1.0f;
                         self.displayDetailTextLabel.alpha = 1.0f;
                         self.displayAgeTextLabel.alpha = 1.0f;
                         self.displayBackground.alpha = 0.5f;
                         self.displayTextLabel.alpha = 1.0f;
                     }];
    
    self.estimatedWeightUsed = NULL;
    self.selectedPatient = NULL;
    self.patientSelected = NO;
    self.tempPatient = NULL;  // clears APGAR data
    self.gestation = NULL;
    self.weight = NULL;
    
    self.infoPassedThrough = @"Cleared";
    
    ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
    
    EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
    
    enterWeightViewController.weight.text = NULL;
    enterWeightViewController.gestation.text = NULL;
    
    // deselect patient
    [enterWeightViewController.myTableView deselectRowAtIndexPath:[enterWeightViewController.myTableView indexPathForSelectedRow] animated:NO];
}

#pragma mark - APGARTabBarController delegate

- (void)APGARTabBarController:(APGARTabBarController *)controller didFinishEnteringAPGARValuesForANewPatient:(Patient *)patient
{
    self.tempPatient = patient;
    
    // add text
    self.displayTextLabel.text = @"New BABY";
    self.displayDismissButtonView.hidden = NO;
    self.displayDetailTextLabel.hidden = NO;
    self.displayDetailTextLabel.text = @"";
    self.displayAgeTextLabel.text = @"APGAR scores saved";
    self.displayAgeTextLabel.hidden = NO;
    self.displayBackground.hidden = NO;
    self.displayTextLabel.hidden = NO;
}

#pragma mark - AboutSimNICUViewController delegate

- (void)aboutSimNICUViewControllerDelegateDidSelectFeedback:(AboutSimNICUViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendFeedback];
    }];
}

- (void)sendFeedback
{
    AAMFeedbackViewController *newViewController = [AAMFeedbackViewController new];
    newViewController.toRecipients = [NSArray arrayWithObject:@"conrad.bosman@nhs.net"];
    newViewController.ccRecipients = nil;
    newViewController.bccRecipients = nil;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newViewController];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)aboutSimNICUViewControllerDelegateDidSelectIntroScreen:(AboutSimNICUViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self showIntroScreen];
    }];
}

@end