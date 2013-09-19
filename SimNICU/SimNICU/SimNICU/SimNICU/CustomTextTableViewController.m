//
//  CustomTextTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CustomTextEditorTableViewController.h"
#import "CustomTextTableViewController.h"
#import "HandoverSectionCustomText.h"
// #import "CustomTextModel.h"
#import "HandoverSection.h"

@interface CustomTextTableViewController ()
{
    // NSArray *tableData;
}

@end

@implementation CustomTextTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get table data
    // tableData = [CustomTextModel getArrayOfCustomTextForHandoverSection:self.section];
    
    // set trackers
    [CBTrackers logEvent:@"Custom Text"];
    
    // Flexible space to the two buttons
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Setup Add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    // Setup array
    NSArray *items = [NSArray arrayWithObjects:addButton, flexibleItem, self.editButtonItem, flexibleItem, nil];
    
    // set right bar button items
    self.navigationItem.rightBarButtonItems = items;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        [self done];
    }
    
    [super viewWillDisappear:animated];
}

- (void)done
{
    // do nothing
}

- (void)add
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    // create new custom text
    HandoverSectionCustomText *newCustomText = [[HandoverSectionCustomText alloc] init];
    newCustomText.customTextReferenceName = @"New custom text";
    newCustomText.customText = @"Enter custom text...";

    // create path to new customText
    NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[handoverSection.customText count] inSection:self.section], nil];
    
    // add to array
    [handoverSection.customText addObject:newCustomText];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // singleton object
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get the handover section to display custom text
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    // return number of custom text objects in handoverSection
    return [handoverSection.customText count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    // singleton object
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get the handover section to display custom text
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    HandoverSectionCustomText *customText = handoverSection.customText[indexPath.row];
    
    cell.textLabel.text = customText.customTextReferenceName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    // delete from singleton
    [handoverSection.customText removeObjectAtIndex:indexPath.row];
    
    // remove from tableView
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

// reorder data source after move
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    HandoverSectionCustomText *ct = handoverSection.customText[sourceIndexPath.row];
    
    // remove text from old location
    [handoverSection.customText removeObjectAtIndex:sourceIndexPath.row];
    
    // add text at new location
    [handoverSection.customText insertObject:ct atIndex:destinationIndexPath.row];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTextEditorTableViewController *newViewController = [[CustomTextEditorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    newViewController.section = self.section;
    newViewController.row = indexPath.row;
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

@end
