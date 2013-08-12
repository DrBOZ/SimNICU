//
//  AboutSimNICUViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 30/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "AboutSimNICUViewController.h"
#import "CBDisplayMethods.h"
#import "UnderlineLabel.h"
#import "AppDelegate.h"
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
    
    self.title = @"About";
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64 - 49)) style:UITableViewStyleGrouped];
    
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
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
    aboutMenuItems = [[NSMutableArray alloc] initWithCapacity:5];
    
#ifdef LITE_VERSION
    
    [aboutMenuItems addObject:@"Neonatal Intensive Care Full Version"];
    [aboutMenuItems addObject:@"Rate on iTunes"];
    
#else
    
    [aboutMenuItems addObject:@"Tutorial"];
    [aboutMenuItems addObject:@"Rate on iTunes"];
    [aboutMenuItems addObject:@"Developer Information"];
    
#endif
    
    [self.myTableView setTableFooterView:[self setupFooterView]];
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
        returnString = @"Version 1.4.1";
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
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
            
            cell.imageView.image = [UIImage imageNamed:@"tutorial.png"];
            
#endif
        }
        else if (indexPath.row == 1)
        {
            cell.imageView.image = [UIImage imageNamed:@"star.png"];
        }
        else if (indexPath.row == 2)
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
        
#ifdef LITE_VERSION
        
        // goto purchase page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=518447654&amp;amp;amp;amp;mt=8"]];
        
#else
        // goto SimNICU mobile website
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.simnicu.co.uk/?page_id=98"]];
        
#endif
        
    }
    else if (indexPath.row == 1)
    {
        [[iRate sharedInstance] openRatingsPageInAppStore];
    }
}

#pragma mark Methods

- (UIView *)setupFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
    
    // Developer
    UILabel *developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    developerLabel.backgroundColor = [UIColor clearColor];
    developerLabel.textAlignment = UITextAlignmentCenter;
    developerLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    developerLabel.shadowColor = [UIColor whiteColor];
    developerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    developerLabel.numberOfLines = 1;
    developerLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    developerLabel.text = @"DEVELOPER";
    [footerView addSubview:developerLabel];
    
    // Conrad Bosman
    UILabel *developerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 90.0f)];
    developerNameLabel.backgroundColor = [UIColor clearColor];
    developerNameLabel.textAlignment = UITextAlignmentCenter;
    developerNameLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    developerNameLabel.shadowColor = [UIColor whiteColor];
    developerNameLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    developerNameLabel.numberOfLines = 3;
    developerNameLabel.font = [UIFont systemFontOfSize:13.0f];
    // developerNameLabel.text = @"Dr Conrad Bosman MBBS (London) MRCPCH\nQueen's Medical Centre\nNottingham, England";
    developerNameLabel.text = @"Dr Conrad Bosman MBBS (London) MRCPCH\nNottingham, England";
    [footerView addSubview:developerNameLabel];
    
    // Acknowledgment text
    UnderlineLabel *acknowledgmentsLabel = [[UnderlineLabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 44.0f)];
    acknowledgmentsLabel.backgroundColor = [UIColor clearColor];
    acknowledgmentsLabel.textAlignment = UITextAlignmentCenter;
    acknowledgmentsLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    // acknowledgmentsLabel.textColor = [UIColor blueColor];
    acknowledgmentsLabel.shadowColor = [UIColor whiteColor];
    acknowledgmentsLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    acknowledgmentsLabel.numberOfLines = 1;
    acknowledgmentsLabel.font = [UIFont systemFontOfSize:15.0f];
    acknowledgmentsLabel.text = @"Thank you for your support";
    [footerView addSubview:acknowledgmentsLabel];
    
    // overlying button to trigger transition
    UIButton *acknowledgmentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acknowledgmentsButton.frame = CGRectMake(0.0f, 100.0f, 320.0f, 44.0f);
    // acknowledgmentsLabel.alpha = 0.0f;
    // acknowledgmentsLabel.backgroundColor = [UIColor clearColor];
    [acknowledgmentsButton addTarget:self action:@selector(gotoAcknowledgments) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:acknowledgmentsButton];
    
    // Copyright text
    UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 140.0f, 320.0f, 44.0f)];
    tableFooterLabel.backgroundColor = [UIColor clearColor];
    tableFooterLabel.textAlignment = UITextAlignmentCenter;
    tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    tableFooterLabel.shadowColor = [UIColor whiteColor];
    tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    tableFooterLabel.numberOfLines = 1;
    tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
    tableFooterLabel.text = @"\nCopyright 2013 © Conrad Bosman";
    [footerView addSubview:tableFooterLabel];
    
    return footerView;
}

@end
