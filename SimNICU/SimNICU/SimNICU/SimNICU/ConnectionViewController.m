//
//  ConnectionViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "ConnectionViewController.h"

@interface ConnectionViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UIButton *hostButton;
@property (nonatomic, strong) UIButton *joinButton;

@end

@implementation ConnectionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Connection"];
    
    self.title = @"Connection";
    
    self.hostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.hostButton.frame = CGRectMake(10.0f, 44.0f, 145.0f, 44.0f);
    [self.hostButton setTitle:@"Host" forState:UIControlStateNormal];
    // self.hostButton.titleLabel.textColor = [UIColor blackColor];
    // self.hostButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.joinButton.frame = CGRectMake(165.0f, 44.0f, 145.0f, 44.0f);
    [self.joinButton setTitle:@"Join" forState:UIControlStateNormal];
    // self.joinButton.backgroundColor = [UIColor clearColor];
    // self.joinButton.titleLabel.text = @"Join";
    
    // self.hostButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    // self.joinButton.titleLabel.textColor = [UIColor blackColor];
    
    [self.view addSubview:self.hostButton];
    [self.view addSubview:self.joinButton];
    
    
    // info button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems infoBarButtonWithTarget:self action:nil];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.tableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 0)
    {
        
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SyncClientDelegate

- (void)syncClient:(SyncClient *)client serverBecameAvailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

- (void)syncClient:(SyncClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.tableView reloadData];
}

@end
