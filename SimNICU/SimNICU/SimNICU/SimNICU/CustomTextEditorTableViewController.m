//
//  CustomTextEditorTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 19/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CustomTextEditorTableViewController.h"
#import "HandoverSectionCustomText.h"
#import "HandoverSection.h"
#import "UDBarTrackballItem.h"
#import "UDInputAccessoryView.h"

@interface CustomTextEditorTableViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *customTextView;

@end

@implementation CustomTextEditorTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    // singleton object
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get the handover section to display custom text
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    HandoverSectionCustomText *customText = handoverSection.customText[indexPath.row];
    
    if (customText.customTextHeight)
    {
        height = [customText.customTextHeight floatValue];
    }
    
    return height;
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
    
    HandoverSectionCustomText *ct = handoverSection.customText[self.row];
    
    if (!self.customTextView)
    {
        self.customTextView = [[UITextView alloc] init];
    }
    
    if (!ct.customTextHeight)
    {
        ct.customTextHeight = [NSNumber numberWithFloat:44.0f];;
    }
    
    self.customTextView.frame = CGRectMake(5.0f, 0.0f, 280.0f, [ct.customTextHeight floatValue] - 5);
    
    // set values
    self.customTextView.font = [UIFont systemFontOfSize:14.0f];
    self.customTextView.textColor = [UIColor grayColor];
    self.customTextView.backgroundColor = [UIColor clearColor];
    self.customTextView.scrollEnabled = NO;
    
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

- (void)formatHeightOfTextView:(UITextView *)textView
{
    /*
    HandoverSection *section = self.selectedPatient.handoverSections[textView.tag];
    HandoverRow *row;
    
    if (textView.tag == 11)
    {
        row = section.rows[1];
    }
    else
    {
        row = section.rows[0];
    }
    
    float rowHeight = [row.rowHeight floatValue];
    float contentHeight = textView.contentSize.height;
    
    if ((contentHeight + 5.0f) > rowHeight)
    {
        rowHeight += ((contentHeight + 5.0f) - rowHeight);
        
        row.rowHeight = [NSNumber numberWithFloat:rowHeight];
        
        [self.myTableView2 beginUpdates];
        [self.myTableView2 endUpdates];
        
        textView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (textView.contentSize.height + 10.0f));
    }
    else if ((contentHeight + 5.0f) < rowHeight)
    {
        rowHeight -= (rowHeight - (contentHeight + 5.0f));
        
        row.rowHeight = [NSNumber numberWithFloat:rowHeight];
        
        [self.myTableView2 beginUpdates];
        [self.myTableView2 endUpdates];
        
        textView.frame = CGRectMake(5.0f, 5.0f, 310.0f, (textView.contentSize.height + 10.0f));
    }
     */
}

- (void)textViewDidChange:(UITextView *)textView
{
    // this was just for playing around with
    float adjustment = 5.0f;
    
    Preferences *preferences = [Preferences sharedPreferences];
    
    // get reference to row data
    HandoverSection *handoverSection = preferences.handoverSections[self.section];
    
    HandoverSectionCustomText *customText = handoverSection.customText[self.row];
    
    // get row height
    float rowHeight = [customText.customTextHeight floatValue];
    
    // get textView height
    float contentHeight = textView.contentSize.height;
    
    // first check if contentHeight is greater than rowHeight
    // YES...
    if ((contentHeight + adjustment) > rowHeight)
    {
        // update rowHeight
        rowHeight = contentHeight;
        
        customText.customTextHeight = [NSNumber numberWithFloat:rowHeight];
        
        NSLog(@"height = %f", [customText.customTextHeight floatValue]);
        
        // update textView frame
        textView.frame = CGRectMake(5.0f, 0.0f, 280.0f, (rowHeight + adjustment));
        
        // update tableView
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    // NO...
    else if ((contentHeight + adjustment) < rowHeight)
    {
        rowHeight = contentHeight;
        
        customText.customTextHeight = [NSNumber numberWithFloat:rowHeight];
        
        NSLog(@"height = %f", [customText.customTextHeight floatValue]);
        
        textView.frame = CGRectMake(5.0f, 0.0f, 280.0f, (rowHeight + adjustment));
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
    // This is going to be the main code
    customText.customText = textView.text;
}

@end
