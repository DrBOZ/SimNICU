//
//  CorrectedAgeInfoViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CorrectedAgeInfoViewController.h"

@interface CorrectedAgeInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation CorrectedAgeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Info & Settings";
        
        // setup Done button
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [CBBarButtonItems doneBarButtonWithTarget:self action:@selector(closeModal)];
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.rowHeight = 50.0f;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        
        // swipe gesture recognizer
        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
        self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if (section == 1)
    {
        rows = 1;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0)
    {
        header = @"Info";
    }
    else if (section == 1)
    {
        header = @"Settings";
    }
    else if (section == 2)
    {
        header = @"References";
    }
    
    return header;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 0)
    {
        footer = @"This calculator is designed to calculate the chronological age of the baby, and to provide a corrected age.\n\nCountries either correct to 1 or 2 years of age, and you can set your preference below.";
    }
    
    return footer;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 200.0f;
    
    if (section == 1)
    {
        height = 0.0f;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
    footerView.backgroundColor = [UIColor clearColor];
    
    if (section == 0)
    {
        UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f, 200.0f)];
        tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
        tableFooterLabel.backgroundColor = [UIColor clearColor];
        tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tableFooterLabel.textAlignment = UITextAlignmentLeft;
        tableFooterLabel.shadowColor = [UIColor whiteColor];
        tableFooterLabel.numberOfLines = 0;
        tableFooterLabel.text = @"This calculator is designed to calculate the chronological age of the baby, and to provide a corrected age.\n\nCountries either correct to 1 or 2 years of age, and you can set your preference below.";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    else if (section == 2)
    {
        UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f, 100.0f)];
        tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
        tableFooterLabel.backgroundColor = [UIColor clearColor];
        tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tableFooterLabel.textAlignment = UITextAlignmentLeft;
        tableFooterLabel.shadowColor = [UIColor whiteColor];
        tableFooterLabel.numberOfLines = 0;
        tableFooterLabel.text = @"1. Engle WA. Age terminology during the\n    perinatal period. Pediatrics 2004;114:\n    1362-4.";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    
    return footerView;
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
