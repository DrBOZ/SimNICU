//
//  AgeCalculatorsInfoViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 27/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AgeCalculatorsInfoViewController.h"

@interface AgeCalculatorsInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation AgeCalculatorsInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Age Terminology";
        
        // setup Done button
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem =[CBBarButtonItems doneBarButtonWithTarget:self action:@selector(closeModal)];
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
        }
        else
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
        }
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
    NSString *header = nil;
    
    if (section == 0)
    {
        header = @"Gestational Age";
    }
    else if (section == 1)
    {
        header = @"Chronological Age";
    }
    else if (section == 2)
    {
        header = @"Postmenstrual Age";
    }
    else if (section == 3)
    {
        header = @"Corrected Age";
    }
    else if (section == 4)
    {
        header = @"References";
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 100.0f;
    
    if (section == 0)
    {
        height = 70.0f;
    }
    else if (section == 1)
    {
        height = 50.0f;
    }
    else if (section == 2)
    {
        height = 30.0f;
    }
    else if (section == 3)
    {
        height = 70.0f;
    }
    else if (section == 4)
    {
        height = 70.0f;
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
        tableFooterLabel.text = @"The time elapsed in completed weeks + days between the first day of the last menstrual period and the day of delivery.";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    else if (section == 1)
    {
        UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f, 200.0f)];
        tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
        tableFooterLabel.backgroundColor = [UIColor clearColor];
        tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tableFooterLabel.textAlignment = UITextAlignmentLeft;
        tableFooterLabel.shadowColor = [UIColor whiteColor];
        tableFooterLabel.numberOfLines = 0;
        tableFooterLabel.text = @"The time elapsed from birth (days, weeks, months or years)";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    else if (section == 2)
    {
        UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f, 200.0f)];
        tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
        tableFooterLabel.backgroundColor = [UIColor clearColor];
        tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tableFooterLabel.textAlignment = UITextAlignmentLeft;
        tableFooterLabel.shadowColor = [UIColor whiteColor];
        tableFooterLabel.numberOfLines = 0;
        tableFooterLabel.text = @"Gestational age plus chronological age.";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    else if (section == 3)
    {
        UILabel *tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 280.0f, 200.0f)];
        tableFooterLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        tableFooterLabel.font = [UIFont systemFontOfSize:15.0f];
        tableFooterLabel.backgroundColor = [UIColor clearColor];
        tableFooterLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tableFooterLabel.textAlignment = UITextAlignmentLeft;
        tableFooterLabel.shadowColor = [UIColor whiteColor];
        tableFooterLabel.numberOfLines = 0;
        tableFooterLabel.text = @"Chronological age reduced by the number of weeks born before 40 weeks of gestation.";
        [tableFooterLabel sizeToFit];
        [footerView addSubview:tableFooterLabel];
    }
    else if (section == 4)
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
