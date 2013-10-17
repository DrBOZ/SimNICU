//
//  VitKTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "VitKTableViewController.h"
#import "VitKTableViewCell.h"

@implementation VitKTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Vitamin K"];
    
    self.title = NSLocalizedString(@"Vitamin K", nil);
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Intramuscular";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Ensure parental consent has been given";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
    {
        height = 66.0f;
    }
    else
    {
        height = 55.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    if(indexPath.row == 0)
    {
        VitKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[VitKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.weight.text = [NSString stringWithFormat:@"< 1%@5 kg birth weight", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        cell.vitK.text = [NSString stringWithFormat:@"0%@5 mg Konakion MM", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        returnCell = cell;
    }
    else if(indexPath.row == 1)
    {
        VitKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[VitKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.weight.text = [NSString stringWithFormat:@"> 1%@5 kg", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        cell.vitK.text = @"1 mg Konakion MM";
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
