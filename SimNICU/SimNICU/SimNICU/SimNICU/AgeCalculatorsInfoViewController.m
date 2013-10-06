//
//  AgeCalculatorsInfoViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AgeCalculatorsInfoViewController.h"
#import "CBTableViewController.h"

@interface AgeCalculatorsInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation AgeCalculatorsInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Age Terminology";
    
    // setup Done button
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem =[CBBarButtonItems doneBarButtonWithTarget:self action:@selector(closeModal)];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height));
    }
    else
    {
        self.myTableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f));
    }
    
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBTableViewController setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self closeModal];
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *headerText = @[@"Gestational Age", @"Chronological Age", @"Postmenstrual Age", @"Corrected Age", @"References"];
    
    return headerText[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *footerHeights = @[@70.0f, @50.0f, @30.0f, @70.0f, @70.0f];
    
    return [footerHeights[section] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    // define text
    NSArray *text = @[@"The time elapsed in completed weeks + days between the first day of the last menstrual period and the day of delivery.", @"The time elapsed from birth (days, weeks, months or years)", @"Gestational age plus chronological age.", @"Chronological age reduced by the number of weeks born before 40 weeks of gestation.", @"1. Engle WA. Age terminology during the\n    perinatal period. Pediatrics 2004;114:\n    1362-4."];
    
    // create label for text
    UILabel *tableFooterLabel = [UILabel new];
    
    // assign text
    tableFooterLabel.text = text[section];
    
    // format text
    [self formatTableFooterLabel:tableFooterLabel];
    
    // add to subview
    [footerView addSubview:tableFooterLabel];
    
    return footerView;
}

- (UILabel *)formatTableFooterLabel:(UILabel *)label
{
    [CBFonts darkGrayOffsetShadowFormattingForLabel:label];
    
    // iOS version differences
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        label.frame = CGRectMake(16.0f, 0.0f, 280.0f, MAXFLOAT);
    }
    else
    {
        label.frame = CGRectMake(20.0f, 0.0f, 280.0f, MAXFLOAT);
    }
    
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = UITextAlignmentLeft;
    
    [label sizeToFit];
    
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    NSString *CellIdentifier = @"Settings";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = @"Correct to age";
    
    returnCell = cell;
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)closeModal
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

@end
