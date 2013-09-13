//
//  BayEditorTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 13/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BayEditorTableViewController.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

@interface BayEditorTableViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIGestureRecognizer *swipeGestureRecognizer;

- (void)add;
- (void)done;

@end

@implementation BayEditorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Bay Editor";
    
    [CBTrackers logEvent:@"Bay Editor"];
    
    // Setup Add button
    self.navigationItem.rightBarButtonItem = [CBBarButtonItems addBarButtonWithTarget:self action:@selector(add)];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.tableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.tableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView setEditing:YES animated:YES];
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

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.delegate bayEditorTableViewControllerDidFinishEditingBays:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)add
{
    if ([self.bayData count] <20)
    {
        Bay *bay = [[Bay alloc] init];
        bay.bayName = @"New Bay";
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

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 220.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Bay %i",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(10.0f, 5.0f, 220.0f, 33.0f);
        textField.font = [UIFont boldSystemFontOfSize:17.0f];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.tag = indexPath.row;
        textField.delegate = self;
        textField.text = [self.bayData[indexPath.row] bayName];   // note this the TextField's text
        
        [cell.contentView addSubview:textField];
    }
    
    cell.textLabel.text = [self.bayData[indexPath.row] bayName];
    cell.textLabel.hidden = YES;
    
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
        // check if there are any patient in the bay
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

@end
