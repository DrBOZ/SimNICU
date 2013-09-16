//
//  CustomTextTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverSectionCustomText.h"
#import "CustomTextTableViewController.h"
#import "CustomTextModel.h"
#import "HandoverSection.h"

@interface CustomTextTableViewController ()
{
    NSArray *tableData;
}

@end

@implementation CustomTextTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [CustomTextModel getArrayOfCustomTextForHandoverSection:self.section];
    
    /*
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    tableData = handoverSection.customText;
     */
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
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    HandoverSectionCustomText *customText = tableData[indexPath.row];
    
    cell.textLabel.text = customText.customTextReferenceName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
