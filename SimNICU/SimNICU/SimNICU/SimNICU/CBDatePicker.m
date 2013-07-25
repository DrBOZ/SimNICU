//
//  CBDatePicker.m
//  SimNICU
//
//  Created by Conrad Bosman on 23/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBDatePicker.h"

@interface CBDatePicker()

// CBDatePicker specific
@property (nonatomic, retain) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, retain) UIView *pickerView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, readonly) CGSize viewSize;
@property (nonatomic, retain) NSMutableArray *customButtons;
@property (nonatomic, assign) CGRect presentFromRect;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIView *origin;

// datePicker specific properties
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSDate *maxDate;

// create toolbar
- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)aTitle;

- (void)done;
- (void)cancel;

@end

@implementation CBDatePicker

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate target:(id)target action:(SEL)action origin:(id)origin;
{
    self = [super init]; // may not need this
    
    if (self)
    {
        self.title = title;
        self.datePickerMode = datePickerMode;
        self.selectedDate = selectedDate;
        self.minDate = minDate;
        self.maxDate = maxDate;
        self.origin = origin;
        
        NSLog(@"%@", self.origin);
    }
    
    return self;
}

// Adds custom buttons to the left of the UIToolbar that select specified values
- (void)addCustomButtonWithTitle:(NSString *)title value:(id)value
{
    if (!self.customButtons)
    {
        self.customButtons = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    if (!title) title = @"";
    
    if (!value) value = [NSNumber numberWithInt:0];
    
    NSDictionary *buttonDetails = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"buttonTitle", value, @"buttonValue", nil];
    
    [self.customButtons addObject:buttonDetails];
}

- (void)showActionSheetPicker
{
    //delegate
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // create master view
    UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 260.0f)];
    
    // create toolbar
    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:self.title];
    [pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [masterView addSubview:pickerToolbar];
    
    // create pickerView
    self.pickerView = [self createDatePickerView];
    [masterView addSubview:self.pickerView];
    
    // present pickerView
    [self presentPickerForView:masterView];
}

#pragma mark - Creating DatePicker methods

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title
{
    //delegate
    // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // define frame
    CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
    
    // create tool bar
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    
    // create toolbar items
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    NSInteger index = 0;
    for (NSDictionary *buttonDetails in self.customButtons)
    {
        NSString *buttonTitle = [buttonDetails objectForKey:@"buttonTitle"];
        //NSInteger buttonValue = [[buttonDetails objectForKey:@"buttonValue"] intValue];
        
        // create button
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(customButtonPressed:)];
        button.tag = index;
        
        [barItems addObject:button];
        
        index++;
    }
    
    // create cancel button
    if (!self.hideCancel)
    {
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        [barItems addObject:cancelBtn];
    }
    
    // create flexible space
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    // create title
    if (title)
    {
        // UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        UILabel *toolBarItemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 30.0f)];
        toolBarItemLabel.textAlignment = UITextAlignmentCenter;
        toolBarItemLabel.textColor = [UIColor whiteColor];
        toolBarItemLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        toolBarItemLabel.backgroundColor = [UIColor clearColor];
        toolBarItemLabel.text = title;
        
        UIBarButtonItem *labelButton = [[UIBarButtonItem alloc]initWithCustomView:toolBarItemLabel];
        
        // add to bar items
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    
    // create done button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    [barItems addObject:doneButton];
    
    // add buttons to toolbar
    [pickerToolbar setItems:barItems animated:NO];
    
    return pickerToolbar;
}

- (UIView *)createDatePickerView
{
    CGRect datePickerFrame = CGRectMake(0.0f, 44.0f, 320.0f, 216.0f);
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    self.datePicker.datePickerMode = self.datePickerMode;
    
    if (self.selectedDate)
    {
        [self.datePicker setDate:self.selectedDate animated:NO];
    }
    else
    {
        // set date to now
        
        // [self.datePicker setDate:[NSDate now] animated:NO];
    }
    
    // set min/max dates
    if (self.minDate) self.datePicker.minimumDate = self.minDate;
    
    if (self.maxDate) self.datePicker.maximumDate = self.maxDate;
    
    // [self.datePicker addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    
    return self.datePicker;
}

- (void)done
{
    // code
}

- (void)cancel
{
    // code
}

- (CGSize)viewSize
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        return CGSizeMake(320, 580);
    }
    else
    {
        return CGSizeMake(320, 480);
    }
}

#pragma mark - Actionsheet stuff

- (void)presentPickerForView:(UIView *)aView
{
    self.presentFromRect = aView.frame;
    
    [self configureAndPresentActionSheetForView:aView];
}

- (void)configureAndPresentActionSheetForView:(UIView *)aView
{
    NSString *paddedSheetTitle = nil;
    
    // CGFloat sheetHeight = self.viewSize.height - 260; // was 47
    
    paddedSheetTitle = @"\n\n\n";
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:paddedSheetTitle delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    // self.actionSheet.bounds = CGRectMake(0.0f, 0.0f, 320.0f, sheetHeight);
    [self.actionSheet addSubview:aView];
    self.actionSheet.bounds = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    [self presentActionSheet:self.actionSheet];
}

- (void)presentActionSheet:(UIActionSheet *)actionSheet
{
    // NSParameterAssert(actionSheet != NULL);
    
    // [actionSheet showFromRect:self.presentFromRect inView:self.containerView animated:YES];
    [actionSheet showInView:self.origin];
}

@end
