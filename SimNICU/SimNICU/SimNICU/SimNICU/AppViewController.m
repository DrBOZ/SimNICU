//
//  AppViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "EnterWeightViewController.h"
#import "ZUUIRevealController.h"
#import "AppViewController.h"
#import "CBTimeMethods.h"
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
#import "BloodProductsViewController.h"
#import "CalculatorViewController.h"
#import "CoolingViewController.h"
#import "CurosurfViewController.h"
#import "CDHViewController.h"
#import "CrUSSViewController.h"
#import "CrUSSOptionsViewController.h"
#import "DrugCategoriesViewController.h"
#import "DrugsViewController.h"
#import "EarlyCareViewController.h"
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
#import "PulmonaryHaemorrhageViewController.h"
#import "ResusViewController.h"
#import "ROPViewController.h"
#import "InfoTabBarController.h"
#import "TransportVentilatorViewController.h"
#import "UVCUACViewController.h"
#import "VitKViewController.h"
#import "WeightConversionViewController.h"
#import "ActionSheetPickerViewController.h"

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
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // self.contentView is a UIView that covers the entire window and contains
    // both the UITableView and the non-scrolling HeaderView (containing the image)
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.width), (appDelegate.window.bounds.size.height))];
    
    // background set to black
    self.view.backgroundColor = [UIColor blackColor];
    
    // info button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems infoBarButtonWithTarget:self action:@selector(showAboutScreen)];
    
    // back button text for subsequent screens
    self.navigationItem.backBarButtonItem = [CBBarButtonItems backBarButtonWithTarget:nil action:nil];
    
    // UITableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0f, 160.0f, 300.0f, (appDelegate.window.bounds.size.height - 230)) style:UITableViewStylePlain];
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 0.0f;
    self.myTableView.sectionHeaderHeight = 0.0f;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.contentView addSubview:self.myTableView];
    
    // Add the screen mask gradient to the UITableView
    self.tableBgView = [[UIImageView alloc] init];
    
    // Different image gradients for iPhone 4 and iPhone 5
    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
    {
        self.tableBgView.frame = CGRectMake(0.0f, 146.0f, 320.0f, (appDelegate.window.bounds.size.height - 196));
        self.tableBgView.image = [UIImage imageNamed:@"bgOverlay.png"];
        // self.tableBgView.alpha = 1.0;
    }
    else
    {
        self.tableBgView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 50));
        self.tableBgView.image = [UIImage imageNamed:@"bgApplication.png"];
    }
    self.tableBgView.userInteractionEnabled = NO;
    [self.contentView addSubview:self.tableBgView];
    
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    self.title = [formatter stringFromDate:currentDate];
        
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      
#ifdef LITE_VERSION
        
        self.title = @"Neonatal Intensive Care";
        
#else
        
        self.title = @"Neonatal Intensive Care";
        
#endif
        
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef LITE_VERSION
    
    if (!self.title) self.title = @"Neonatal Intensive Care";
    
#else
    
    if (!self.title) self.title = @"Neonatal Intensive Care";
    
#endif

// This is used to create the Launch images easily
#if LOADING_GRAPHICS
    
    NSLog(@"LOADING_GRAPHICS SET");
    
    // reset display background
    self.displayBackground.frame = CGRectMake(30.0f, 40.0f, 245.0f, 50.0f);
    self.displayBackground.backgroundColor = [UIColor blackColor];
    self.displayBackground.hidden = NO;
    self.displayBackground.alpha = .4;
    
    // reset displayTextLabel
    self.displayTextLabel.frame = CGRectMake(39.0f, 39.0f, 210.0f, 30.0f);
    self.displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.displayTextLabel.backgroundColor = [UIColor clearColor];
    self.displayTextLabel.textAlignment = UITextAlignmentCenter;
    self.displayTextLabel.textColor = [UIColor whiteColor];
    self.displayTextLabel.adjustsFontSizeToFitWidth = YES;
    self.displayTextLabel.text = @"LOADING";
    self.displayTextLabel.hidden = NO;
    
    // reset displayDetailTextLabel
    self.displayDetailTextLabel.frame = CGRectMake(39.0f, 60.0f, 227.0f, 30.0f);
    self.displayDetailTextLabel.backgroundColor = [UIColor clearColor];
    self.displayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
    self.displayDetailTextLabel.textAlignment = UITextAlignmentCenter;
    self.displayDetailTextLabel.textColor = [UIColor whiteColor];
    self.displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
    self.displayDetailTextLabel.text = @"Please wait...";
    self.displayDetailTextLabel.hidden = NO;
    
#endif
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // check if RevealController can respond to selectors
    if ([appDelegate.revealController respondsToSelector:@selector(revealToggle:)] && [appDelegate.revealController respondsToSelector:@selector(revealGesture:)])
    {
        // transparent button over the app's image triggers reveal transition
        UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        flipButton.frame = CGRectMake(10.0f, 0.0f, 275.0f, 150.0f);
        [flipButton addTarget:appDelegate.revealController action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:flipButton];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:appDelegate.revealController action:@selector(revealGesture:)];
        [flipButton addGestureRecognizer:self.panGestureRecognizer];
        
        // Enter Weight button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:appDelegate.revealController action:@selector(revealToggle:)];
    }
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissButton.frame = CGRectMake(250.0f, 35.0f, 40.0f, 40.0f);
    [self.dismissButton addTarget:self action:@selector(clearScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    // init screens list
    screens = [[NSMutableArray alloc] initWithCapacity:20];
    
    Screen *screen;
    
    screen = [[Screen alloc] init];
    screen.menuText = @"APGAR scores";
    screen.segueId = @"APGAR";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Blood Products";
    screen.segueId = @"BloodProducts";
    [screens addObject:screen];
    
#ifdef CALCULATOR_PREVIEW_MODE
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Calculator";
    screen.detailMenuText = @"Almost finished!";
    screen.segueId = @"Calculator";
    [screens addObject:screen];
    
#endif
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Cooling";
    screen.segueId = @"Cooling";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Corrected Age";
    screen.segueId = @"Age Calculators";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Cranial Ultrasound";
    screen.segueId = @"CrUSS";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Curosurf\u00AE";
    screen.segueId = @"Curosurf";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Diaphragmatic Hernia";
    screen.segueId = @"CDH";
    [screens addObject:screen];
    
#ifdef DRUGS_PREVIEW_MODE
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Drugs";
    screen.detailMenuText = @"Currently working on!";
    screen.segueId = @"Drugs";
    [screens addObject:screen];
    
#endif
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Early Care";
    screen.segueId = @"EarlyCare";
    [screens addObject:screen];
    
#ifdef FEEDS_AND_FLUIDS_PREVIEW_MODE
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Feeds & Fluids";
    screen.detailMenuText = @"Coming soon!";
    screen.segueId = @"FeedsAndFluids";
    [screens addObject:screen];
    
#endif
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Gastroschisis";
    screen.segueId = @"Gastroschisis";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Glucose Load";
    screen.detailMenuText = @"Coming soon!";
    screen.segueId = @"GlucoseInfusionRate";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        screen.menuText = @"High Frequency Oscillation";
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.0)
    {
        screen.menuText = @"HFOV";
    }
    screen.segueId = @"HFOV";
    [screens addObject:screen];
    
#ifdef HYPOGLYCAEMIA_PREVIEW_MODE
    
     screen = [[Screen alloc] init];
     screen.menuText = @"Hypoglycaemia Screen";
     screen.segueId = @"Hypo";
     [screens addObject:screen];
    
#endif
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Infusions";
    screen.segueId = @"Infusions";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Intubation";
    screen.segueId = @"Intubation";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Naloxone (Narcan)";
    screen.segueId = @"Narcan";
    [screens addObject:screen];
    
    // Outcomes
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Oxygenation Index";
    screen.segueId = @"OI";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Phototherapy";
    screen.segueId = @"Phototherapy";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Plastic Bag (at delivery)";
    screen.segueId = @"Thermoregulation";
    [screens addObject:screen];
    
#ifdef POSTNATAL_WARD_PREVIEW_MODE
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Postnatal Ward";
    screen.segueId = @"PostnatalWard";
    [screens addObject:screen];
    
#endif
    
    screen = [[Screen alloc] init];
    screen.menuText = NSLocalizedString(@"Pulmonary Haemorrhage", nil);
    screen.segueId = @"PulmonaryHaemorrhage";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Resuscitation Drugs";
    screen.segueId = @"Resus";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Retinopathy of Prematurity";
    screen.segueId = @"ROP";
    [screens addObject:screen];
    
    // Sarnat score
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Seizures";
     screen.segueId = @"Fits";
     [screens addObject:screen];
     */
    
    // Sodium correction
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Transport Ventilator";
    screen.segueId = @"BabyPac";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"UAC / UVC";
    screen.segueId = @"UACUVC";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Vitamin K";
    screen.segueId = @"VitK";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Weight Conversion";
    screen.segueId = @"WeightConversion";
    [screens addObject:screen];
    
    appDelegate.currentController = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    return UIInterfaceOrientationPortrait;
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
    
    if (section == 0) header = @"Emergency";
    else if (section == 1) header = @"General";
    
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
            
            cell.textLabel.text = @"Infusions";
            
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
            
            cell.textLabel.text = @"Intubation";
            
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
            
            cell.textLabel.text = @"Resuscitation Drugs";
            
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
        cell.detailTextLabel.text = [thisScreen detailMenuText];
        
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
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            newViewController.roundUp = enterWeightViewController.preferences.ETTRoundUp;
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
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
            
            [self.navigationController pushViewController:newAPGARTabBarController animated:YES];
        }
        
#pragma mark Blood Products
        
        else if ([thisScreenType isEqualToString:@"BloodProducts"])
        {
            BloodProductsViewController *newViewController = [[BloodProductsViewController alloc] init];
            newViewController.workingWeight = self.weight;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Calculator
        
        else if ([thisScreenType isEqualToString:@"Calculator"])
        {
            CalculatorViewController *newViewController = [[CalculatorViewController alloc] init];
            
            if (self.selectedPatient)
            {
                newViewController.selectedPatient = self.selectedPatient;
            }
            else if (self.weight)
            {
                Patient *tempPatient = [[Patient alloc] init];
                tempPatient.workingWeight = self.weight;
                
                newViewController.selectedPatient = tempPatient;
            }
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Cooling
        
        else if ([thisScreenType isEqualToString:@"Cooling"])
        {
            CoolingViewController *newViewController = [[CoolingViewController alloc] init];
    
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Curosurf
        
        else if ([thisScreenType isEqualToString:@"Curosurf"])
        {
            CurosurfViewController *newViewController = [[CurosurfViewController alloc] init];

            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Cranial Ultrasound
        
        else if ([thisScreenType isEqualToString:@"CrUSS"])
        {

#ifdef CRUSS_PREVIEW_MODE
            
            CrUSSOptionsViewController *newViewController = [[CrUSSOptionsViewController alloc] init];
            
#else
            
            CrUSSViewController *newViewController = [[CrUSSViewController alloc] init];
            
#endif
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Congenital Diaphragmatic Hernia
        
        else if ([thisScreenType isEqualToString:@"CDH"])
        {
            CDHViewController *newViewController = [[CDHViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Drugs
        
        else if ([thisScreenType isEqualToString:@"Drugs"])
        {
            DrugsViewController *newViewController = [[DrugsViewController alloc] init];
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
            EarlyCareViewController *newViewController = [[EarlyCareViewController alloc] init];
            
            if (self.earlyCareWarningShown)
            {
                newViewController.earlyCareWarningShown = YES;
            }
            else
            {
                self.earlyCareWarningShown = YES;
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
            GastroschisisViewController *newViewController = [[GastroschisisViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Glucose Infusion Rate
        
        else if ([thisScreenType isEqualToString:@"GlucoseInfusionRate"])
        {
            [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
            // GlucoseLoadController *newViewController = [[GlucoseLoadController alloc] init];
            // [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark HFOV
        
        else if ([thisScreenType isEqualToString:@"HFOV"])
        {
            HFOVViewController *newViewController = [[HFOVViewController alloc] init];

            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Infusions
        
        else if ([thisScreenType isEqualToString:@"Infusions"])
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
        
#pragma mark Intubation
        
        else if ([thisScreenType isEqualToString:@"Intubation"])
        {
            IntubationViewController *newViewController = [[IntubationViewController alloc] init];
            
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
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            newViewController.roundUp = enterWeightViewController.preferences.ETTRoundUp;
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Narcan
        
        else if ([thisScreenType isEqualToString:@"Narcan"])
        {
            NSLog(@"showNarcan");
            
            ResusViewController *newViewController = [[ResusViewController alloc] init];
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
            
            OxygenationIndexViewController *newViewController = [[OxygenationIndexViewController alloc] init];
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            newViewController.OIPaO2UnitsIndex = enterWeightViewController.preferences.OIUnits;
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
            [self.navigationController pushViewController:newViewController animated:YES];
            
#endif
            
        }
        
#pragma mark Thermaoregulation
        
        else if ([thisScreenType isEqualToString:@"Thermoregulation"])
        {
            PlasticBagViewController *newViewController = [[PlasticBagViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Phototherapy
        
        else if ([thisScreenType isEqualToString:@"Phototherapy"])
        {
            PhototherapyViewController *newViewController = [[PhototherapyViewController alloc] init];
            
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
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            if (enterWeightViewController.preferences.guidelineCountry)
            {
                newViewController.guidelineCountry = enterWeightViewController.preferences.guidelineCountry;
            }
            
            if (enterWeightViewController.preferences.bilirubinUnits)
            {
                newViewController.bilirubinUnits = enterWeightViewController.preferences.bilirubinUnits;
            }
            
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Pulmonary Haemorrhage
        
        else if ([thisScreenType isEqualToString:@"PulmonaryHaemorrhage"])
        {
            PulmonaryHaemorrhageViewController *newViewController = [[PulmonaryHaemorrhageViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Resuscitation
        
        else if ([thisScreenType isEqualToString:@"Resus"])
        {
            ResusViewController *newViewController = [[ResusViewController alloc] init];
            newViewController.workingWeight = self.weight;
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Retinopathy of Prematurity
        
        else if ([thisScreenType isEqualToString:@"ROP"])
        {
            ROPViewController *newViewController = [[ROPViewController alloc] init];
            
            newViewController.selectedPatient = self.selectedPatient;
            
            if ((!self.selectedPatient) && (self.gestation || self.weight))
            {
                Patient *newPatient = [[Patient alloc] init];
                
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
            TransportVentilatorViewController *newViewController = [[TransportVentilatorViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Umbilical Lines
        
        else if ([thisScreenType isEqualToString:@"UACUVC"])
        {
            UVCUACViewController *newViewController = [[UVCUACViewController alloc] init];
            
            newViewController.selectedPatient = self.selectedPatient;
            
            if ((!self.selectedPatient) && (self.gestation || self.weight))
            {
                Patient *newPatient = [[Patient alloc] init];
                
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
            VitKViewController *newViewController = [[VitKViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];
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
            
            WeightConversionViewController *newViewController = [[WeightConversionViewController alloc] init];
            
            [self.navigationController pushViewController:newViewController animated:YES];

#endif
            
        }
    }
}

#pragma mark -

- (void)showAboutScreen
{
    // AboutSimNICUViewController2 *newViewController = [[AboutSimNICUViewController2 alloc] init];
    
    InfoTabBarController *newViewController = [[InfoTabBarController alloc] init];
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.tintColor = [UIColor blackColor];
    navController.topViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

# pragma mark - enterWeightViewController delegate methods

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishSelectingPatient:(Patient *)patient
{
    self.selectedPatient = patient;
    
    self.displayTextLabel.text = [self.selectedPatient returnDisplayTextLabelText];
    
    if (self.selectedPatient.birthDate)
    {
        self.displayAgeTextLabel.text = [NSString stringWithFormat:@"day %i", [CBTimeMethods getDaysDifferenceIntBetween:self.selectedPatient.birthDate and:[NSDate date]]];
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
    
    // gestation entered but no weight
    if (gestation && !weight)
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
        // self.growthChart = [[GrowthChart alloc] init];
        
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
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
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
    }
    else if(weight && !gestation)
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
        self.displayAgeTextLabel.text = @"";
        self.displayDetailTextLabel.hidden = NO;
        self.displayAgeTextLabel.hidden = NO;
        self.displayBackground.hidden = NO;
        self.displayTextLabel.hidden = NO;
        self.displayDismissButtonView.hidden = NO;
        
        self.weight = weight;
    }
    else if(weight && gestation)
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
}

- (void)clearScreen
{
    self.displayDismissButtonView.hidden = YES;
    self.displayDetailTextLabel.hidden = YES;
    self.displayAgeTextLabel.hidden = YES;
    self.displayBackground.hidden = YES;
    self.displayTextLabel.hidden = YES;
    
    self.estimatedWeightUsed = NULL;
    self.selectedPatient = NULL;
    self.patientSelected = NO;
    self.gestation = NULL;
    self.weight = NULL;
    
    self.infoPassedThrough = @"Cleared";
    
    ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
    
    EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
    
    enterWeightViewController.weight.text = NULL;
    enterWeightViewController.gestation.text = NULL;
}

@end