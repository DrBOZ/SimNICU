//
//  PlateletTransfusionCriteriaViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 01/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PlateletTransfusionCriteriaViewController.h"
#import "CBTableViewWebViewCell.h"
#import "AppDelegate.h"

@interface PlateletTransfusionCriteriaViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PlateletTransfusionCriteriaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Blood Products/Platelet Transfusion"];

    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Platelet Transfusion";
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height));
    }
    else
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64));
    }
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBTableViewController setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    self.webView = nil;
    self.swipeGestureRecognizer = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PlateletTransfusionViewController unloaded properties");
        
        self.myTableView = nil;
        self.webView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Transfusion Criteria";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 66.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerTitle;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        footerTitle = @"Bag of platelets should be hung vertically for 10 minutes before transfusion to allow most platelets to settle in the volume being transfused.\n\nThe bag should then be sampled vertically into the syringe used for administration.";
    }
    else
    {
        footerTitle = @"Bag of platelets should be hung vertically for 10 minutes before transfusion to allow most platelets to settle in the volume being transfused.\nThe bag should then be sampled vertically into the syringe used for administration.";
    }
    
    return footerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        return 130.0f;
    }
    else
    {
        return 160.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    CBTableViewWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[CBTableViewWebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell loadHMTLPageWithFilename:@"platelets"];
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end