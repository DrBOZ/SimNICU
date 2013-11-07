//
//  AboutSimNICUViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 30/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "AboutSimNICUViewController.h"
#import "KxIntroViewController.h"
#import "CBTableViewController.h"
#import "AppViewController.h"
#import "KxIntroViewPage.h"
#import "UnderlineLabel.h"
#import "AppDelegate.h"
#import "KxIntroView.h"
#import "iRate.h"

@interface AboutSimNICUViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation AboutSimNICUViewController
{
    NSMutableArray *aboutMenuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"About", nil);
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // tableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f - 49.0f)) style:UITableViewStyleGrouped];
    }
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    self.myTableView.userInteractionEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add icon
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    UIImage *image = [UIImage imageNamed:@"SimNICU_RoundedIcon1000x1000.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(60.0f, 20.0f, 200.0f, 200.0f);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [headerView addSubview:imageView];
    
    self.myTableView.tableHeaderView = headerView;
    self.myTableView.tableFooterView = [self setupFooterView];
    
    // add TableView background
    [CBTableViewController setBackgroundForTableView:self.myTableView];
    
    aboutMenuItems = [[NSMutableArray alloc] initWithCapacity:5];
    
#ifdef LITE_VERSION
    
    [aboutMenuItems addObject:@"Neonatal Intensive Care Full Version"];
    [aboutMenuItems addObject:@"Rate on iTunes"];
    
#else
    
    // [aboutMenuItems addObject:@"Intro screen"];
    [aboutMenuItems addObject:NSLocalizedString(@"Rate on iTunes", nil)];
    [aboutMenuItems addObject:[NSString stringWithFormat:@"%@ / %@", NSLocalizedString(@"Feedback", @"Feedback about the App"), NSLocalizedString(@"Requests", @"Requests by the user for new features for the App")]];
    // [aboutMenuItems addObject:@"Developer Information"];
    
#endif
    
    // [self.myTableView setTableFooterView:[self setupFooterView]];
}

- (void)viewWillAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"About" withError:nil];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"AboutSimNICUViewController2 didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"AboutSimNICUViewController2 unloaded properties");
        
        self.myTableView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if (section == 0)
    {
        rows = [aboutMenuItems count];
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    if (section == 0)
    {
        // Obtain App Version String
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        // Convert decimal point to user's locale decimal separator
        NSString *formattedAppVersion = [appVersion stringByReplacingOccurrencesOfString:@"." withString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        // return formatted text
        returnString = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Version", @"As in App 'Version' i.e. 2.0") ,formattedAppVersion];
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 44.0f;
    
    if (section == 0)
    {
        height = 66.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"Section One";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = [aboutMenuItems objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0)
        {
#ifdef LITE_VERSION
            
            cell.imageView.image = [UIImage imageNamed:@"SimNICU_RoundedIcon.png"];
            
#else
            
            // cell.imageView.image = [UIImage imageNamed:@"intro01.png"];
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
#endif
        }
        else if (indexPath.row == 1)
        {
            // cell.imageView.image = [UIImage imageNamed:@"star.png"];
            cell.imageView.image = [UIImage imageNamed:@"mail01.png"];
        }
        else if (indexPath.row == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"mail01.png"];
        }
        else if (indexPath.row == 3)
        {
            cell.imageView.image = [UIImage imageNamed:@"safari.png"];
        }
        
        returnCell = cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Section Two";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = [aboutMenuItems objectAtIndex:indexPath.row];
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        // [self showIntroScreen];
        [[iRate sharedInstance] openRatingsPageInAppStore];
    }
    else if (indexPath.row == 1)
    {
        // [[iRate sharedInstance] openRatingsPageInAppStore];
        [self.delegate aboutSimNICUViewControllerDelegateDidSelectFeedback:self];
    }
    else if (indexPath.row == 2)
    {
        [self.delegate aboutSimNICUViewControllerDelegateDidSelectFeedback:self];
    }
    else if (indexPath.row == 3)
    {
#ifdef LITE_VERSION
        
        // goto purchase page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=518447654&amp;amp;amp;amp;mt=8"]];
        
#else
        // goto SimNICU mobile website
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.simnicu.co.uk/?page_id=98"]];
#endif
    }
}

#pragma mark Methods

- (UIView *)setupFooterView
{
    UIView *footerView = [UIView new];
    
    // Obtain user's language setting
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSLog(@"User's language setting = %@", language);
    
    // set height of footer view
    CGFloat footerViewHeight;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // if iPhone Language setting = Português then extend height for translator information
        if ([language isEqualToString:@"pt"])
        {
            footerViewHeight = 350.0f;
        }
        else
        {
            footerViewHeight = 250.0f; // default
        }
    }
    else
    {
        // if iPhone Language setting = Português then extend height for translator information
        if ([language isEqualToString:@"pt"])
        {
            footerViewHeight = 300.0f;
        }
        else
        {
            footerViewHeight = 200.0f; // default
        }
    }
    
    footerView.frame = CGRectMake(0.0f, 0.0f, 320.0f, footerViewHeight);
    
    // Developer
    UILabel *developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    [CBFonts darkGrayOffsetShadowFormattingForLabel:developerLabel];
    developerLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    developerLabel.numberOfLines = 1;
    developerLabel.text = NSLocalizedString(@"DEVELOPER", @"Noun, the developer of the App");
    [footerView addSubview:developerLabel];
    
    // Conrad Bosman
    UILabel *developerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 90.0f)];
    [CBFonts darkGrayOffsetShadowFormattingForLabel:developerNameLabel];
    developerNameLabel.numberOfLines = 3;
    developerNameLabel.font = [UIFont systemFontOfSize:13.0f];
    // developerNameLabel.text = @"Dr Conrad Bosman MBBS (London) MRCPCH\nQueen's Medical Centre\nNottingham, England";
    // developerNameLabel.text = @"Dr Conrad Bosman MBBS (London) MRCPCH\nNottingham, England";
    developerNameLabel.text = [NSString stringWithFormat:@"Dr Conrad Bosman MBBS (%@) MRCPCH\nNottingham, %@", NSLocalizedString(@"London", nil), NSLocalizedString(@"England", nil)];
    [footerView addSubview:developerNameLabel];
    
    // Translator
    if ([language isEqualToString:@"pt"])
    {
        // PORTUGUÊS TRANSLATION
        UILabel *translatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 44.0f)];
        [CBFonts darkGrayOffsetShadowFormattingForLabel:translatorLabel];
        translatorLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        translatorLabel.numberOfLines = 1;
        translatorLabel.text = @"TRADUÇÃO PORTUGUÊS";
        [footerView addSubview:translatorLabel];
        
        // Márcio Fossari
        UILabel *translatorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 120.0f, 320.0f, 90.0f)];
        [CBFonts darkGrayOffsetShadowFormattingForLabel:translatorNameLabel];
        translatorNameLabel.numberOfLines = 3;
        translatorNameLabel.font = [UIFont systemFontOfSize:13.0f];
        // developerNameLabel.text = @"Dr Conrad Bosman MBBS (London) MRCPCH\nQueen's Medical Centre\nNottingham, England";
        translatorNameLabel.text = @"Dr Márcio Fossari\nSanta Catarina, Brasil";
        [footerView addSubview:translatorNameLabel];
    }
    
    // Acknowledgment text
    
    CGFloat startingHeightForAcknowledgementText;
    // if iPhone Language setting = Português then extend height for translator information
    if ([language isEqualToString:@"pt"])
    {
        startingHeightForAcknowledgementText = 200.0f;
    }
    else
    {
        startingHeightForAcknowledgementText = 100.0f; // default
    }
    
    UnderlineLabel *acknowledgmentsLabel = [[UnderlineLabel alloc] initWithFrame:CGRectMake(0.0f, startingHeightForAcknowledgementText, 320.0f, 44.0f)];
    [CBFonts darkGrayOffsetShadowFormattingForLabel:acknowledgmentsLabel];
    acknowledgmentsLabel.numberOfLines = 1;
    acknowledgmentsLabel.font = [UIFont systemFontOfSize:15.0f];
    
    CGFloat acknowledgementLabelStartPoint;
    CGFloat acknowledgementLabelEndPoint;
    
    if ([language isEqualToString:@"pt"])
    {
        acknowledgementLabelStartPoint = 78.0f;
        acknowledgementLabelEndPoint = 242.0f;
    }
    else
    {
        acknowledgementLabelStartPoint = 70.0f; // defaults
        acknowledgementLabelEndPoint = 251.0f;
    }
    
    acknowledgmentsLabel.start = acknowledgementLabelStartPoint;
    acknowledgmentsLabel.end = acknowledgementLabelEndPoint;
    acknowledgmentsLabel.text = NSLocalizedString(@"Thank you for your support", nil);
    [footerView addSubview:acknowledgmentsLabel];
    
    /*
    // overlying button to trigger transition
    UIButton *acknowledgmentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acknowledgmentsButton.frame = CGRectMake(0.0f, 100.0f, 320.0f, 44.0f);
    // acknowledgmentsLabel.alpha = 0.0f;
    // acknowledgmentsLabel.backgroundColor = [UIColor clearColor];
    [acknowledgmentsButton addTarget:self action:@selector(gotoAcknowledgments) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:acknowledgmentsButton];
     */
    
    // Copyright text
    UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, startingHeightForAcknowledgementText + 40.0f, 320.0f, 44.0f)];
    [CBFonts darkGrayOffsetShadowFormattingForLabel:tableFooterLabel];
    tableFooterLabel.numberOfLines = 2;
    tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
    tableFooterLabel.text = [NSString stringWithFormat:@"\n%@ 2013 © Conrad Bosman", NSLocalizedString(@"Copyright", nil)];
    [footerView addSubview:tableFooterLabel];
    
    return footerView;
}

- (void)showIntroScreen
{
    [self.delegate aboutSimNICUViewControllerDelegateDidSelectIntroScreen:self];
}

@end
