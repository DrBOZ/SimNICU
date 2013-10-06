//
//  CBTableViewWebViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewWebViewController.h"
#import "CBTableViewWebViewCell.h"

@interface CBTableViewWebViewController ()

@end

@implementation CBTableViewWebViewController

- (id)initWithStyle:(UITableViewStyle)style webViews:(NSArray *)webViews title:(NSString *)title;
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = title;
        self.webViewSections = webViews;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.webViewSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.webViewSections[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.webViewSections[indexPath.section] objectAtIndex:indexPath.row] heightForRowAtIndexPath] floatValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.webViewSections[section] objectAtIndex:0] header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [[self.webViewSections[indexPath.section] objectAtIndex:indexPath.row] cellIdentifier];
    
    CBTableViewWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[CBTableViewWebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier webView:[self.webViewSections[indexPath.section] objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
