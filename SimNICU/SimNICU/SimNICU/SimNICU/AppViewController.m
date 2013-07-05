#//
//  AppViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "PortraitOnlyNavigationController.h"
#import "EnterWeightViewController.h"
#import "ZUUIRevealController.h"
#import "AppViewController.h"
#import "AppDelegate.h"
#import "RoundImage.h"
#import "Patient.h"
#import "Screen.h"

// screenControllers - alphabetical order
#import "AboutSimNICUViewController.h"
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
#import "DrugCategoriesViewController.h"
#import "EarlyCareViewController.h"
#import "GastroschisisViewController.h"
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
@property (nonatomic, strong) NSString *estimatedWeightUsed;
@property (nonatomic, strong) NSString *infoPassedThrough;
@property (nonatomic, strong) Patient *selectedPatient;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) GrowthChart *growthChart;
@property (nonatomic, strong) UIImageView *tableBgView;
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
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (appDelegate.window.bounds.size.width), (appDelegate.window.bounds.size.height))];
    
    //background
    self.view.backgroundColor = [UIColor blackColor];
    
    //info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(270.0f, 10.0f, 30.0f, 30.0f);
    [infoButton addTarget:self action:@selector(showAboutScreen) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoBarButton;
    
    //back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0f, 160.0f, 300.0f, (appDelegate.window.bounds.size.height - 230)) style:UITableViewStylePlain];
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 0.0f;
    self.myTableView.sectionHeaderHeight = 0.0f;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.contentView addSubview:self.myTableView];
    // [self.view addSubview:self.myTableView];
    
    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
    {
        // NSLog(@"iPhone 5 height for png file = %f", (appDelegate.window.bounds.size.height - 50));
        
        //screen mask covers everything
        self.tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 146.0f, 320.0f, (appDelegate.window.bounds.size.height - 196))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
        self.tableBgView.image = tableBgImage;
        self.tableBgView.userInteractionEnabled = NO;
        self.tableBgView.alpha = 1.0;
        [self.contentView addSubview:self.tableBgView];
        // [self.view addSubview:tableBgView];
    }
    else
    {
        //screen mask covers everything
        self.tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 50))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgApplication.png"];
        self.tableBgView.image = tableBgImage;
        self.tableBgView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.tableBgView];
        // [self.view addSubview:self.tableBgView];
    }
    
    //header holds image and settings view..
    self.myHeaderView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 150.0f)];
    
    //IMAGE
    if([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
    {
        //Retina display iPhone
        self.appImage = [RoundImage makeRoundCornerImage:[UIImage imageNamed:@"SimNICU_MainPhoto640x300.jpg"]:12:12];
    }
    else
    {
        //non Retina display iPhone/iPod Touch
        self.appImage = [RoundImage makeRoundCornerImage:[UIImage imageNamed:@"SimNICU_MainPhoto320x150.jpg"]:6:6];
    }
    
    self.appImageView = [[UIImageView alloc] initWithImage:self.appImage];
    self.appImageView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 150.0f);
    self.appImageView.contentMode = UIViewContentModeScaleToFill;
    [self.myHeaderView addSubview:self.appImageView];
    
    //display background
    self.displayBackground = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 40.0f, 245.0f, 50.0f)];
    self.displayBackground.backgroundColor = [UIColor blackColor];
    self.displayBackground.alpha = .4;
    self.displayBackground.hidden = YES;
    [self.myHeaderView addSubview:self.displayBackground];
    
    //dismiss button image & view
    self.displayDismissButtonView = [[UIImageView alloc] initWithFrame:CGRectMake(250.0f, 42.0f, 22.0f, 22.0f)];
    UIImage *displayDismissButton = [UIImage imageNamed:@"dismiss2.png"];
    self.displayDismissButtonView.image = displayDismissButton;
    self.displayDismissButtonView.userInteractionEnabled = YES;
    self.displayDismissButtonView.hidden = YES;
    [self.myHeaderView addSubview:self.displayDismissButtonView];
    
    //displayTextLabel (Patient's name or working weight)
    self.displayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 39.0f, 210.0f, 30.0f)];
    self.displayTextLabel.textColor = [UIColor whiteColor];
    self.displayTextLabel.backgroundColor = [UIColor clearColor];
    self.displayTextLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    self.displayTextLabel.adjustsFontSizeToFitWidth = YES;
    self.displayTextLabel.textAlignment = UITextAlignmentLeft;
    self.displayTextLabel.hidden = YES;
    [self.myHeaderView addSubview:self.displayTextLabel];
    
    //displayDetailTextLabel (Patient's name or working weight)
    self.displayDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(39.0f, 60.0f, 227.0f, 30.0f)];
    self.displayDetailTextLabel.textColor = [UIColor whiteColor];
    self.displayDetailTextLabel.backgroundColor = [UIColor clearColor];
    self.displayDetailTextLabel.font = [UIFont systemFontOfSize:18.0f];
    self.displayDetailTextLabel.adjustsFontSizeToFitWidth = YES;
    self.displayDetailTextLabel.textAlignment = UITextAlignmentLeft;
    self.displayDetailTextLabel.hidden = YES;
    [self.myHeaderView addSubview:self.displayDetailTextLabel];
    
    [self.contentView addSubview:self.myHeaderView];
    
    [self.view addSubview:self.contentView];
    // [self.view addSubview:self.myHeaderView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifdef LITE_VERSION
    
    self.title = @"SimNICU Lite";
    
#else
    
    self.title = @"SimNICU";
    
#endif
    
#if LOADING_GRAPHICS
    
    NSLog(@"LOADING_GRAPHICS SET");
    
    self.displayBackground.hidden = NO;
    
    self.displayTextLabel.text = @"LOADING";
    self.displayTextLabel.textAlignment = UITextAlignmentCenter;
    self.displayTextLabel.hidden = NO;
    
    self.displayDetailTextLabel.text = @"Please wait...";
    self.displayDetailTextLabel.textAlignment = UITextAlignmentCenter;
    self.displayDetailTextLabel.hidden = NO;
    
#endif
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //check if RevealController can respond to selectors
    if ([appDelegate.revealController respondsToSelector:@selector(revealToggle:)] && [appDelegate.revealController respondsToSelector:@selector(revealGesture:)])
    {
        //transparent button over the app's image triggers reveal transition
        UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        flipButton.frame = CGRectMake(10.0f, 0.0f, 275.0f, 150.0f);
        [flipButton addTarget:appDelegate.revealController action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:flipButton];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:appDelegate.revealController action:@selector(revealGesture:)];
        [flipButton addGestureRecognizer:self.panGestureRecognizer];
        
        // Enter Weight button
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:appDelegate.revealController action:@selector(revealToggle:)];
        
        /*
        UIView *roundIconView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 48.0f, 48.0f)];
        UIImageView *roundIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SimNICU_round.png"]];
        roundIconImageView.frame = CGRectMake(0.0f, 0.0f, 48.0f, 48.0f);
        roundIconImageView.contentMode = UIViewContentModeScaleToFill;
        [roundIconView addSubview:roundIconImageView];
        
        UIBarButtonItem *SimNICUButton = [[UIBarButtonItem alloc] initWithCustomView:roundIconView];
        self.navigationItem.leftBarButtonItem = SimNICUButton;
        */
        
        /*
        //info button
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.frame = CGRectMake(270.0f, 10.0f, 30.0f, 30.0f);
        [infoButton addTarget:self action:@selector(showAboutScreen) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
        self.navigationItem.rightBarButtonItem = infoBarButton;
         */
        
    }
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissButton.frame = CGRectMake(250.0f, 35.0f, 40.0f, 40.0f);
    [self.dismissButton addTarget:self action:@selector(clearScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    // init screens list
    screens = [[NSMutableArray alloc] initWithCapacity:20];
    
    Screen *screen;
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Antibiotics";
     screen.segueId = @"Antibiotics";
     [screens addObject:screen];
     */
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Phototherapy";
     screen.segueId = @"Phototherapy";
     [screens addObject:screen];
     */
    
    screen = [[Screen alloc] init];
    screen.menuText = @"APGAR scores";
    screen.segueId = @"APGAR";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Blood Products";
    screen.segueId = @"BloodProducts";
    [screens addObject:screen];
    
    // screen = [[Screen alloc] init];
    // screen.menuText = @"Calculator";
    // screen.segueId = @"Calculator";
    // [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Cooling";
    screen.segueId = @"Cooling";
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
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Drugs";
    screen.segueId = @"Drugs";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Early Care";
    screen.segueId = @"EarlyCare";
    [screens addObject:screen];
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Feeds & Fluids";
     screen.segueId = @"EarlyCare";
     [screens addObject:screen];
     */
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Gastroschisis";
    screen.segueId = @"Gastroschisis";
    [screens addObject:screen];
    
    // Gentamicin levels
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Glucose Infusion Rate";
     screen.segueId = @"GlucoseInfusionRate";
     [screens addObject:screen];
     */
    
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
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Hypoglycaemia Screen";
     screen.segueId = @"Hypo";
     [screens addObject:screen];
     */
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Infusions";
    screen.segueId = @"Infusions";
    [screens addObject:screen];
    
    screen = [[Screen alloc] init];
    screen.menuText = @"Intubation";
    screen.segueId = @"Intubation";
    [screens addObject:screen];
    
    // screen = [[Screen alloc] init];
    // screen.menuText = @"Nitric Oxide";
    // screen.segueId = @"Nitric Oxide";
    // [screens addObject:screen];
    
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
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Transitional Care";
     screen.segueId = @"TC";
     [screens addObject:screen];
     */
    
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
    
    /*
     screen = [[Screen alloc] init];
     screen.menuText = @"Weight Conversion";
     screen.segueId = @"WeightTemp";
     [screens addObject:screen];
     */
    
    // screen = [[Screen alloc] init];
    // screen.menuText = @"E-mail suggestions";
    // screen.segueId = @"E-mail";
    // [screens addObject:screen];
    
    //delegate
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // appDelegate.currentController = (UIViewController <BannerViewContainer> *)self;
    appDelegate.currentController = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // NSLog(@"AppViewController viewDidAppear");
    
    NSLog(@"viewDidAppear: UITableView height = %f", self.myTableView.frame.size.height);
    NSLog(@"viewDidAppear: Shadow height = %f", self.tableBgView.frame.size.height);
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
        self.appImage = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // NSLog(@"AppViewController viewDidUnload");
    
    self.infoPassedThrough = @"Memory Warning";
    
    self.panGestureRecognizer = nil;
    self.appImageView = nil;
    self.myHeaderView = nil;
    self.myTableView = nil;
    self.tableBgView = nil;
    self.appImage = nil;
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

//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3;
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
                [cell setBackgroundColor:[UIColor whiteColor]];
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
                [cell setBackgroundColor:[UIColor whiteColor]];
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
                [cell setBackgroundColor:[UIColor whiteColor]];
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }

        Screen *thisScreen = screens[indexPath.row];
        cell.textLabel.text = [thisScreen menuText];
        
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
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
            
        }
        else if (indexPath.row == 1)
        {
            NSLog(@"showIntubation");
            
            IntubationViewController *newViewController = [[IntubationViewController alloc] init];
            
            newViewController.gestation = self.gestation;
            newViewController.weight = self.weight;
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            NSLog(@"enterWeightViewController.preferences.ETTRoundUp = %@", enterWeightViewController.preferences.ETTRoundUp);
            
            newViewController.roundUp = enterWeightViewController.preferences.ETTRoundUp;
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        else if (indexPath.row == 2)
        {
            NSLog(@"showResus");
            
            ResusViewController *newViewController = [[ResusViewController alloc] init];
            newViewController.workingWeight = self.weight;
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
    }
    else
    {
        Screen *thisScreen = screens[indexPath.row];
        
        // NSString *thisScreenType = [thisScreen segueId];
        NSString *thisScreenType = thisScreen.segueId;
        
#pragma mark Antibiotics
        
        if([thisScreenType isEqualToString:@"Antibiotics"])
        {
            // code
        }
        
#pragma mark APGAR
        
        else if([thisScreenType isEqualToString:@"APGAR"])
        {
            APGARTabBarController *newAPGARTabBarController = [[APGARTabBarController alloc] init];
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            newAPGARTabBarController.delegate2 = (EnterWeightViewController *)enterWeightViewController;
            
            newAPGARTabBarController.selectedPatient = self.selectedPatient;
            
            [appDelegate.navigationController pushViewController:newAPGARTabBarController animated:YES];
        }
        
#pragma mark Blood Products
        
        else if ([thisScreenType isEqualToString:@"BloodProducts"])
        {
            NSLog(@"showBloodProducts");
            
            BloodProductsViewController *newViewController = [[BloodProductsViewController alloc] init];
            newViewController.workingWeight = self.weight;
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Calculator
        
        else if ([thisScreenType isEqualToString:@"Calculator"])
        {
            NSLog(@"showCalculator");
            
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Cooling
        
        else if ([thisScreenType isEqualToString:@"Cooling"])
        {
            NSLog(@"showCooling");
            
            CoolingViewController *newViewController = [[CoolingViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Curosurf
        
        else if ([thisScreenType isEqualToString:@"Curosurf"])
        {
            NSLog(@"showCurosurf");
            
            CurosurfViewController *newViewController = [[CurosurfViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Cranial Ultrasound
        
        else if ([thisScreenType isEqualToString:@"CrUSS"])
        {
            NSLog(@"showCrUSS");
            CrUSSViewController *newViewController = [[CrUSSViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Congenital Diaphragmatic Hernia
        
        else if ([thisScreenType isEqualToString:@"CDH"])
        {
            NSLog(@"showCDH");
            CDHViewController *newViewController = [[CDHViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Drugs
        
        else if ([thisScreenType isEqualToString:@"Drugs"])
        {
            NSLog(@"showDrugs");
            // DrugsTabBarController *newTabBarController = [[DrugsTabBarController alloc] init];
            // [appDelegate.navigationController pushViewController:newTabBarController animated:YES];
            DrugCategoriesViewController *newViewController = [[DrugCategoriesViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Early Care
        
        else if ([thisScreenType isEqualToString:@"EarlyCare"])
        {
            NSLog(@"showEarlyCare");
            
            EarlyCareViewController *newViewController = [[EarlyCareViewController alloc] init];
            
            if (self.earlyCareWarningShown)
            {
                newViewController.earlyCareWarningShown = YES;
            }
            else
            {
                self.earlyCareWarningShown = YES;
            }
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Gastroschisis
        
        else if ([thisScreenType isEqualToString:@"Gastroschisis"])
        {
            NSLog(@"showGastroschisis");
            GastroschisisViewController *newViewController = [[GastroschisisViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark HFOV
        
        else if ([thisScreenType isEqualToString:@"HFOV"])
        {
            NSLog(@"showHFOV");
            HFOVViewController *newViewController = [[HFOVViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Infusions
        
        else if ([thisScreenType isEqualToString:@"Infusions"])
        {
            NSLog(@" ");
            
            InfusionsViewController *newViewController = [[InfusionsViewController alloc] init];
            
            if (self.selectedPatient.workingWeight)
            {
                newViewController.workingWeight = self.selectedPatient.workingWeight;
            }
            else if (self.weight)
            {
                newViewController.workingWeight = self.weight;
            }
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Intubation
        
        else if ([thisScreenType isEqualToString:@"Intubation"])
        {
            NSLog(@" ");
            
            IntubationViewController *newViewController = [[IntubationViewController alloc] init];
            
            newViewController.gestation = self.gestation;
            newViewController.weight = self.weight;
            
            ZUUIRevealController *revealController = (ZUUIRevealController *)self.navigationController.parentViewController;
            
            EnterWeightViewController *enterWeightViewController = (EnterWeightViewController *)revealController.rearViewController;
            
            NSLog(@"enterWeightViewController.preferences.ETTRoundUp = %@", enterWeightViewController.preferences.ETTRoundUp);
            
            newViewController.roundUp = enterWeightViewController.preferences.ETTRoundUp;
            newViewController.delegate = (EnterWeightViewController *)enterWeightViewController;
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Narcan
        
        else if ([thisScreenType isEqualToString:@"Narcan"])
        {
            NSLog(@"showNarcan");
            
            ResusViewController *newViewController = [[ResusViewController alloc] init];
            newViewController.workingWeight = self.weight;
            newViewController.narcanSelected = @"YES";
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
#endif
            
        }
        
#pragma mark Thermaoregulation
        
        else if ([thisScreenType isEqualToString:@"Thermoregulation"])
        {
            PlasticBagViewController *newViewController = [[PlasticBagViewController alloc] init];
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
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
                NSLog(@"self.selectedPatient = NO & self.gestation = YES");
                
                if ([self.gestation integerValue] >= 38)
                {
                    newViewController.gestation = [NSNumber numberWithInt:38];
                }
                else
                {
                    newViewController.gestation = [NSNumber numberWithInt:[self.gestation integerValue]];
                }
                
                newViewController.gestationLocked = @"YES";
                
                NSLog(@"newViewController.gestation = %@", newViewController.gestation);
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Pulmonary Haemorrhage
        
        else if ([thisScreenType isEqualToString:@"PulmonaryHaemorrhage"])
        {
            NSLog(@"showPulmonaryHaemorrhage");
            
            PulmonaryHaemorrhageViewController *newViewController = [[PulmonaryHaemorrhageViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Resuscitation
        
        else if ([thisScreenType isEqualToString:@"Resus"])
        {
            NSLog(@"showResus");
            
            ResusViewController *newViewController = [[ResusViewController alloc] init];
            newViewController.workingWeight = self.weight;
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Retinopathy of Prematurity
        
        else if ([thisScreenType isEqualToString:@"ROP"])
        {
            NSLog(@"showROP");
            
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
        }
        
#pragma mark Transport Ventilator
        
        else if ([thisScreenType isEqualToString:@"BabyPac"])
        {
            NSLog(@"showTransportVent");
            
            TransportVentilatorViewController *newViewController = [[TransportVentilatorViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Umbilical Lines
        
        else if ([thisScreenType isEqualToString:@"UACUVC"])
        {
            NSLog(@"showUACUVC");
            
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
            
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
        }
        
#pragma mark Vitamin K
        
        else if ([thisScreenType isEqualToString:@"VitK"])
        {
            NSLog(@"showVitK");
            
            VitKViewController *newViewController = [[VitKViewController alloc] init];
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
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
            [appDelegate.navigationController pushViewController:newViewController animated:YES];
            
#endif
            
        }
    }
}

#pragma mark -

- (void)showAboutScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // AboutSimNICUViewController2 *newViewController = [[AboutSimNICUViewController2 alloc] init];
    
    InfoTabBarController *newViewController = [[InfoTabBarController alloc] init];
    
    PortraitOnlyNavigationController *navController = [[PortraitOnlyNavigationController alloc] initWithRootViewController:newViewController];
    
    navController.navigationBar.tintColor = [UIColor blackColor];
    // navController.topViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navController.topViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    
    [appDelegate.navigationController presentModalViewController:navController animated:YES];
}

# pragma mark - enterWeightViewController delegate methods

- (void)enterWeightViewController:(EnterWeightViewController *)controller didFinishSelectingPatient:(Patient *)patient
{
    self.selectedPatient = patient;
    
    // display patient's name
    self.displayTextLabel.text = [NSString stringWithFormat:@"%@ %@", patient.firstname, patient.lastname];
    
    NSString *detailTextLabelText = @"";
    
    NSString *rawBirthWeight = patient.birthWeight;
    NSString *formattedBirthWeight;
    
    NSString *rawWorkingWeight = patient.workingWeight;
    NSString *formattedWorkingWeight;
    
    // format birth weight
    NSString *UKLocaleRawBirthWeight;
    UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleRawBirthWeight = [rawBirthWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float birthWeightKGAsFloat = [UKLocaleRawBirthWeight floatValue];
    
    if(birthWeightKGAsFloat < 1.0f)
    {
        // convert to grams as use integer
        int birthWeightGRAMSasInt = birthWeightKGAsFloat * 1000;
        formattedBirthWeight = [NSString stringWithFormat:@"%i g", birthWeightGRAMSasInt];
    }
    else
    {
        formattedBirthWeight = [NSString stringWithFormat:@"%@ kg", rawBirthWeight];
    }
    
    // format working weight
    NSString *UKLocaleRawWorkingWeight;
    UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
    UKLocaleRawWorkingWeight = [rawWorkingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
    
    float workingWeightKGAsFloat = [UKLocaleRawWorkingWeight floatValue];
    
    if(workingWeightKGAsFloat < 1.0f)
    {
        // convert to grams as use integer
        int workingWeightGRAMSasInt = workingWeightKGAsFloat * 1000;
        formattedWorkingWeight = [NSString stringWithFormat:@"%i g", workingWeightGRAMSasInt];
    }
    else
    {
        formattedWorkingWeight = [NSString stringWithFormat:@"%@ kg", rawWorkingWeight];
    }
    
    // all information present (missing this stage
    if (patient.gestation && patient.birthWeight && patient.correctedGestation && patient.workingWeight)
    {
        detailTextLabelText = [NSString stringWithFormat:@"%@/40 (%@) now %@ (ww %@)", patient.gestation, formattedBirthWeight, patient.correctedGestation, formattedWorkingWeight];
        
        self.weight = patient.workingWeight;
    }
    else if (patient.workingWeight && patient.gestation)
    {
        detailTextLabelText = [NSString stringWithFormat:@"%@/40 working weight %@", patient.gestation, formattedWorkingWeight];
        
        self.weight = patient.workingWeight;
    }
    else if (patient.workingWeight && !patient.gestation)
    {
        detailTextLabelText = [NSString stringWithFormat:@"working weight %@", formattedWorkingWeight];
        
        self.weight = patient.workingWeight;
    }
    else if (patient.gestation && !patient.workingWeight)
    {
        // code here for just gestation
        
        // obtain estimated weight from growth chart
        
        NSString *estimatedWeight;
        
        self.growthChart = [[GrowthChart alloc] init];
        
        // temp code
        NSString *sex = @"Unknown";
        NSString *centile = @"50th";
        
        estimatedWeight = [self.growthChart getWeightForSex:sex atCentile:centile atGestation:patient.gestation];
        
        // NSLog(@"Estimated Weight = %@", estimatedWeight);
        
        NSString *UKLocaleEstimatedWeight;
        UKLocaleEstimatedWeight = [estimatedWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleEstimatedWeight = [estimatedWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float estimatedWeightKGAsFloat = [UKLocaleEstimatedWeight floatValue];
        NSString *estimatedWeightAsString;
        
        if(estimatedWeightKGAsFloat < 1)
        {
            // convert to grams as use integer
            int estimatedWeightGRAMSasInt = estimatedWeightKGAsFloat * 1000;
            
            estimatedWeightAsString = [NSString stringWithFormat:@"%i grams", estimatedWeightGRAMSasInt];
        }
        else
        {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            // if using arabic locale, force to english
            if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
            {
                formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            }
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 3;
            
            estimatedWeightAsString = [NSString stringWithFormat:@"%@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:estimatedWeightKGAsFloat]]];
            
            // estimatedWeightAsString = [NSString stringWithFormat:@"%.2f kg", estimatedWeightKGAsFloat];
        }
        
        detailTextLabelText = [NSString stringWithFormat:@"%@/40 estimated weight %@", patient.gestation, estimatedWeightAsString];
        
        self.weight = estimatedWeight;
        self.gestation = patient.gestation;
    }
    
    
    self.displayDetailTextLabel.text = detailTextLabelText;
    
    self.displayBackground.hidden = NO;
    self.displayTextLabel.hidden = NO;
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
        weight = [weight stringByReplacingOccurrencesOfString:@"٫" withString:@"."];
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
        self.growthChart = [[GrowthChart alloc] init];
        
        estimatedWeight = [self.growthChart getWeightForSex:sex atCentile:centile atGestation:gestation];
        
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
        
        self.displayDetailTextLabel.hidden = NO;
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
        self.displayDetailTextLabel.hidden = NO;
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