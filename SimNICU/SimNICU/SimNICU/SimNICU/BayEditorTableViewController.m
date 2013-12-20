//
//  BayEditorTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 13/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BayEditorTableViewController.h"
#import "BayEditorTableViewCell.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

@interface BayEditorTableViewController () <UIActionSheetDelegate, UITextFieldDelegate>

- (void)add;
- (void)done;

@end

@implementation BayEditorTableViewController
{
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Bay Editor", nil);
    
    [CBTrackers logEvent:@"Bay Editor"];  // could add in to return number of patients...
    
    // Setup Add button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems addBarButtonWithTarget:self action:@selector(add)];
    
    // setup back bar button with long press gesture
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:self
                                                                                                                       action:@selector(backButtonPressed)
                                                                                                              longPressTarget:self
                                                                                                              longPressAction:@selector(backButtonLongPressed)];
}

- (void)backButtonPressed
{
    [self done];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonLongPressed
{
    if (!backButtonLongPressed)
    {
        backButtonLongPressed = YES;
        
        [self done];
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // starts UITableView in editing mode
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done
{
    // Ensure that there is at least one bay
    if ([self.bayData count] == 0)
    {
        // create bay
        Bay *bay = [[Bay alloc] init];
        bay.bayName = @"Patients";
        bay.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self.bayData addObject:bay];
    }
    
    // let delegate know that editing has finished, so as to reorder patient list bays
    [self.delegate bayEditorTableViewControllerDidFinishEditingBays:self];
}

- (void)add
{
    if ([self.bayData count] < 20)
    {
        Bay *bay = [[Bay alloc] init];
        bay.bayName = NSLocalizedString(@"New Bay", nil);
        bay.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self.bayData addObject:bay];
        
        // set indexPaths
        NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:([self.bayData count] - 1) inSection:0]];
        
        // insert row
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"The maximum allowed number of bays is 20"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bayData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 220.0f;
}

- (BayEditorTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Bay %i",indexPath.row];
    BayEditorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[BayEditorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textField.delegate = self;
        cell.tag = indexPath.row;
    }
    
    cell.textField.tag = indexPath.row;
    cell.textField.text = [self.bayData[indexPath.row] bayName];
    
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
    // check to see if this is the last bay
    if ([self.bayData count] == 1)
    {
        // check to see if there are any patients in the bay
        if ([[self.bayData[indexPath.row] patientsInBay] count])
        {
            // if there are then then warn the user that they will be deleted
            NSLog(@"There are patients that are going to be deleted");
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"WARNING: Deleting the last bay will\ndelete all remaining patients"
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                 destructiveButtonTitle:NSLocalizedString(@"Delete", @"")
                                                      otherButtonTitles:nil];
            [sheet showInView:self.view];
        }
        else
        {
            // then delete bay
            [self.bayData removeObjectAtIndex:indexPath.row];
            
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else
    {
        // check if there are any patients in the bay
        if ([[self.bayData[indexPath.row] patientsInBay] count])
        {
            // ideally present dialog box to ask user if they want the patients moving or deleting
            // just move them for now
            
            Patient *patientToMove;
            
            // if this is that last bay then copy patients to the bay above
            if (indexPath.row == ([self.bayData count] -1))
            {
                // copy patients to second to last bay
                for (patientToMove in [self.bayData[indexPath.row] patientsInBay])
                {
                    // copy patient
                    [[self.bayData[([self.bayData count] -2)] patientsInBay] addObject:patientToMove];
                }
            }
            else
            {
                // copy patients to last bay
                for (patientToMove in [self.bayData[indexPath.row] patientsInBay])
                {
                    // copy patient
                    [[self.bayData[([self.bayData count] -1)] patientsInBay] addObject:patientToMove];
                }
            }
            
            // then delete patients from bay to be deleted
            [[self.bayData[indexPath.row] patientsInBay] removeAllObjects];
        }
        
        // then delete bay
        [self.bayData removeObjectAtIndex:indexPath.row];
        
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
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
    Bay *bay = self.bayData[sourceIndexPath.row];
    
    // remove bay at old location
    [self.bayData removeObjectAtIndex:sourceIndexPath.row];
    
    // add bay at new location
    [self.bayData insertObject:bay atIndex:destinationIndexPath.row];
}

# pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITextField delegate

- (void)reorderTags
{
    NSString *CellIdentifier;
    
    for (int i = 0; i < self.bayData.count; i++)
    {
        CellIdentifier = [NSString stringWithFormat:@"Bay %i",i];
        
        BayEditorTableViewCell *cell = (BayEditorTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        cell.textField.tag = i;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowUserEditText = YES;
    
    // should check text is not longer than a certain number of characters
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 24)
    {
        allowUserEditText = NO;
    }
    
    return allowUserEditText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // set Bay Name
    Bay *bay = self.bayData[textField.tag];
    bay.bayName = textField.text;
    
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textField.tag = %i", textField.tag);
    
    // to ensure TextField.tag consistency
    [self reorderTags];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // set Bay Name
    Bay *bay = self.bayData[textField.tag];
    bay.bayName = textField.text;
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) // Delete last bay and all remaining patients
    {
		[self.bayData removeAllObjects];
        [self.tableView reloadData];
	}
}

/*
 Jobs:
 
 1) When selecting a bay to rename I could make the animation slicker by checking the tag number of the UITextField and then deciding with the animation is to top or middle.
 2) The large empty footer is not nice.
 3) Something like this would be very useful as a Unit overview, with numbers of babies and levels of care.
 4) Tracker to return number of patients
 
 */

@end
