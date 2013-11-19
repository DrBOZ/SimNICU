//
//  CustomTextTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 16/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CustomTextEditorTableViewController.h"
#import "CustomTextTableViewController.h"
// #import "CustomTextModel.h"
#import "HandoverSection.h"
#import "CustomText.h"
@interface CustomTextTableViewController () <UITextFieldDelegate>
{
    NSMutableArray *textFields;
    
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

@property (nonatomic, strong) HandoverSection *handoverSection;

@end

@implementation CustomTextTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.view.tintColor = [UIColor redColor];
    
    textFields = [[NSMutableArray alloc] initWithCapacity:5];
    
    // set trackers
    [CBTrackers logEvent:@"Custom Text"];
    
    // Flexible space to the two buttons
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // Setup Add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    
    // Setup array
    NSArray *items = [NSArray arrayWithObjects:addButton, flexibleItem, self.editButtonItem, flexibleItem, nil];
    
    // setup right bar button items
    self.navigationItem.rightBarButtonItems = items;
    
    // setup back bar button with long press gesture
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:self
                                                                                                                       action:@selector(backButtonPressed)
                                                                                                              longPressTarget:self
                                                                                                              longPressAction:@selector(backButtonLongPressed)];
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonLongPressed
{
    if (!backButtonLongPressed)
    {
        backButtonLongPressed = YES;
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
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
    [self setEditing:NO];
}

- (void)add
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    // create new custom text
    CustomText *newCustomText = [CustomText new];
    newCustomText.customTextReferenceName = @"New custom text";
    newCustomText.customText = @"Enter custom text...";

    // create path to new customText
    NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[handoverSection.customText count] inSection:0], nil];
    
    // add to array
    [handoverSection.customText addObject:newCustomText];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    // allowTextFieldEditing = self.editing;
    
    if (!self.editing)
    {
        for (UITextField *textField in textFields)
        {
            [textField resignFirstResponder];
        }
    }
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"CustomText %i",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(10.0f, 5.0f, 220.0f, 33.0f);
        textField.font = [UIFont systemFontOfSize:17.0f];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.tag = indexPath.row;
        textField.userInteractionEnabled = YES;
        textField.delegate = self;
        
        [textFields addObject:textField];
        
        // singleton object
        Preferences *preferences = [Preferences sharedPreferences];
        
        // get the handover section to display custom text
        HandoverSection *handoverSection = preferences.handoverSections[self.section];
        
        CustomText *customText = handoverSection.customText[indexPath.row];
        
        textField.text = customText.customTextReferenceName;
        
        [cell.contentView addSubview:textField];
    }
    
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
    
    CustomText *ct = handoverSection.customText[sourceIndexPath.row];
    UITextField *textField = textFields[sourceIndexPath.row];
    
    // remove text from old location
    [handoverSection.customText removeObjectAtIndex:sourceIndexPath.row];
    
    // remove TextField from old location in TextFields
    [textFields removeObjectAtIndex:sourceIndexPath.row];
    
    // add text at new location
    [handoverSection.customText insertObject:ct atIndex:destinationIndexPath.row];
    
    // add TextField at new location
    [textFields insertObject:textField atIndex:destinationIndexPath.row];
    
    int x = 0;
    
    // re tag TextFields
    for (UITextField *textField in textFields)
    {
        textField.tag = x;
        
        x = x + 1;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTextEditorTableViewController *newViewController;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        newViewController = [[CustomTextEditorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    else
    {
        newViewController = [[CustomTextEditorTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    
    newViewController.section = self.section;
    newViewController.row = indexPath.row;
    
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Text view delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.editing)
    {
        return YES;
    }
    else
    {
        // use this code to ensure selection colours display
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        // actually select row
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
        
        return NO;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    CustomText *customText = handoverSection.customText[textField.tag];
    
    customText.customTextReferenceName = textField.text;
}

@end
