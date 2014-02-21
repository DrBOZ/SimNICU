//
//  CustomTextEditorTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 19/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CustomTextEditorTableViewController.h"
#import "HandoverSection.h"
#import "UDBarTrackballItem.h"
#import "UDInputAccessoryView.h"
#import "CustomText.h"

@interface CustomTextEditorTableViewController () <UITextViewDelegate>
{
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

@property (nonatomic, strong) UITextView *customTextView;

@end

@implementation CustomTextEditorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.title = NSLocalizedString(@"Edit Custom Text", nil);
    
    self.tableView.scrollEnabled = NO;
    
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
        
        // workaround
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.orientation = @"PreventRotation";
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.customTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (UIInterfaceOrientationIsPortrait(fromInterfaceOrientation))
    {
        // set a minimum height for the plan textView
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 64.0f);
        }
        else
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 64.0f);
        }
    }
    else
    {
        // set a minimum height for the plan textView
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 235.0f);
        }
        else
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 147.0f);
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // set the height for the UITableViewCell in portrait
    if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
    {
        return 245.0f;
    }
    else
    {
        return 157.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get textView height
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    CustomText *ct = handoverSection.customText[self.row];
    
    if (!self.customTextView)
    {
        self.customTextView = [[UITextView alloc] init];
    }
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        // set a minimum height for the plan textView
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 64.0f);
        }
        else
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 64.0f);
        }
    }
    else
    {
        // set a minimum height for the plan textView
        if (appDelegate.window.bounds.size.height == 568) // 4 inch Retina
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 235.0f);
        }
        else
        {
            self.customTextView.frame = CGRectMake(5.0f, 5.0f, 280.0f, 147.0f);
        }
    }

    // set values
    self.customTextView.font = [UIFont systemFontOfSize:14.0f];
    self.customTextView.textColor = [UIColor grayColor];
    self.customTextView.backgroundColor = [UIColor clearColor];
    self.customTextView.scrollEnabled = YES;
    
    self.customTextView.text = ct.customText;
    
    // set delegate
    self.customTextView.delegate = self;
    
    // autocorrection option
    if ([preferences.autocorrection intValue] == 1)
    {
        self.customTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    }
    else
    {
        self.customTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    // set trackball
    if ([preferences.trackball intValue] == 1)
    {
        [self addTrackBallForUITextView:self.customTextView];
    }
    
    [cell.contentView addSubview:self.customTextView];
    
    return cell;
}

- (void)addTrackBallForUITextView:(UITextView *)textView
{
    
#if UDBARTRACKBALL
    
    [textView setInputAccessoryView:[self trackballAccessoryViewForUITextView:textView]];
    
#endif
    
}

- (UIView *)trackballAccessoryViewForUITextView:(UITextView *)textView
{
    UIToolbar *trackballToolbar = [[UDInputAccessoryView alloc] init];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // create trackball
    UDBarTrackballItem *trackball = [[UDBarTrackballItem alloc] initForTextView:textView];
    
    [trackballToolbar setItems:@[spacer, trackball, spacer] animated:YES];
    
    return trackballToolbar;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get reference to row data
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    CustomText *customText = handoverSection.customText[self.row];
    
    // This is going to be the main code
    customText.customText = textView.text;
}

@end
