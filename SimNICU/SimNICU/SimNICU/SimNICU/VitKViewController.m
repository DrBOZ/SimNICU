//
//  VitKViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 12/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "VitKViewController.h"

@interface VitKViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation VitKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Vitamin K"];
    
    self.title = NSLocalizedString(@"Vitamin K", nil);
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //background
    self.view.backgroundColor = [UIColor blackColor];
    
    //tableView
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    }
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"VitKViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"VitKViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView = nil;
    self.swipeGestureRecognizer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Intramuscular";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Ensure parental consent has been given";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)
    {
        height = 66.0f;
    }
    else
    {
        height = 55.0f;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 13.0f, 182.0f, 22.0f)];
        weight.font = [UIFont boldSystemFontOfSize:18.0f];
        weight.textColor = [UIColor blackColor];
        weight.text = [NSString stringWithFormat:@"< 1%@5 kg birth weight", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        UILabel *vitK = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 35.0f, 228.0f, 50.0f)];
        vitK.font = [UIFont systemFontOfSize:17.0f];
        vitK.textColor = [UIColor lightGrayColor];
        vitK.text = [NSString stringWithFormat:@"0%@5 mg Konakion MM", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        [cell addSubview:weight];
        [cell addSubview:vitK];
        
        returnCell = cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 13.0f, 182.0f, 22.0f)];
        weight.font = [UIFont boldSystemFontOfSize:18.0f];
        weight.textColor = [UIColor blackColor];
        weight.text = [NSString stringWithFormat:@"> 1%@5 kg", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
        
        [cell addSubview:weight];
        
        UILabel *vitK = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 35.0f, 228.0f, 50.0f)];
        vitK.font = [UIFont systemFontOfSize:17.0f];
        vitK.textColor = [UIColor lightGrayColor];
        vitK.text = @"1 mg Konakion MM";
        
        [cell addSubview:vitK];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
