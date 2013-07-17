//
//  BayEditorViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 16/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BayEditorViewController.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Bay.h"

@interface BayEditorViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation BayEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Bay Editor";
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Setup Add button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(add)];
        
        // Setup Back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(done)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        // Instantiate TableView
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20 - 44)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
        // set background colour
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_4_PORTRAIT_PNG]];
            [tempImageView setFrame:self.myTableView.frame];
            
            self.myTableView.backgroundView = tempImageView;
        }
        else
        {
            // 3.5 inch Retina
            UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BACKGROUND_IPHONE_35_PORTRAIT_PNG]];
            [tempImageView setFrame:self.myTableView.frame];
            
            self.myTableView.backgroundView = tempImageView;
        }
        
        [self.view addSubview:self.myTableView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.myTableView setEditing:YES animated:YES];
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
    
    [self.delegate bayEditorViewControllerDidFinishEditingBays:self];
}

- (void)add
{
    if ([self.bayData count] <20)
    {
        Bay *bay = [[Bay alloc] init];
        bay.bayName = @"New Bay";
        bay.patientsInBay = [[NSMutableArray alloc] initWithCapacity:4];
        
        [self.bayData addObject:bay];
        
        [self.myTableView reloadData];
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

# pragma mark - Table view data source

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(10.0f, 10.0f, 220.0f, 33.0f);
        textField.font = [UIFont boldSystemFontOfSize:17.0f];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.tag = indexPath.row;
        textField.delegate = self;
        textField.text = [self.bayData[indexPath.row] bayName];
        
        [cell.contentView addSubview:textField];
    }
    
    cell.textLabel.text = [self.bayData[indexPath.row] bayName];
    cell.textLabel.hidden = YES;
    
    return cell;
}

# pragma mark Editing

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
            [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
        [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
    NSIndexPath *path = nil;
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // nil
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
    
    [self.myTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
        [self.myTableView reloadData];
	}
}

@end
