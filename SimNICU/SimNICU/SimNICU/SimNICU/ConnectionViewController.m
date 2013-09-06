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
    
    UIButton *hostButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hostButton.frame = CGRectMake(10.0f, 10.0f, 145.0f, 44.0f);
    // hostButton.backgroundColor = [UIColor clearColor];
    hostButton.titleLabel.text = @"Host";
    hostButton.titleLabel.textColor = [UIColor blackColor];
    hostButton.titleLabel.backgroundColor = [UIColor whiteColor];
    
    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    joinButton.frame = CGRectMake(165.0f, 10.0f, 145.0f, 44.0f);
    joinButton.backgroundColor = [UIColor clearColor];
    joinButton.titleLabel.text = @"Join";
    joinButton.titleLabel.textColor = [UIColor blackColor];
    
    [self.view addSubview:hostButton];
    [self.view addSubview:joinButton];
    
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
