//
//  AgeCalculatorsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 18/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AgeCalculatorsViewController.h"
#import "CorrectedAgeViewController.h"
#import "ExactAgeViewController.h"
#import "AppDelegate.h"
#import "Calculator.h"

@interface AgeCalculatorsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation AgeCalculatorsViewController
{
    NSMutableArray *calculatorGroup;
    NSMutableArray *calculators;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Calculator *calculator;
        
        // create arrays
        
        calculatorGroup = [[NSMutableArray alloc] initWithCapacity:2];
        
        calculators = [[NSMutableArray alloc] initWithCapacity:4];
        
        calculator = [[Calculator alloc] init];
        calculator.text = @"Exact age";
        calculator.detailText = @"days, hours, minutes";
        [calculators addObject:calculator];
        
        calculator = [[Calculator alloc] init];
        calculator.text = @"Corrected age";
        calculator.detailText = @"years, months, days";
        [calculators addObject:calculator];
        
        calculator = [[Calculator alloc] init];
        calculator.text = @"Decimal age";
        calculator.detailText = @"for older growth charts";
        [calculators addObject:calculator];
        
        [calculatorGroup addObject:calculators];
        
        calculators = [[NSMutableArray alloc] initWithCapacity:2];
        
        calculator = [[Calculator alloc] init];
        calculator.text = @"Gestational age";
        calculator.detailText = @"from LMP";
        [calculators addObject:calculator];
        
        calculator = [[Calculator alloc] init];
        calculator.text = @"Gestational age";
        calculator.detailText = @"from EDD";
        [calculators addObject:calculator];
        
        [calculatorGroup addObject:calculators];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:nil
                                                                                action:nil];
        
        // create UITableView
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 50.0f;  // was 44.0f
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.hidden = NO;
        self.myTableView.bounces = YES;
        self.myTableView.scrollEnabled = YES;
        [self.view addSubview:self.myTableView];
        
#if USE_DIMPLE_BACKGROUND
        
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
        
#else
        self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
#endif
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.selectedPatient)
    {
        self.title = @"Patient selected";
    }
    else
    {
        self.title = @"Age Calculators";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [calculatorGroup count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [calculatorGroup[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0) header = @"Chronological Age";
    else if (section == 1) header = @"Gestational Age";
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Calculator";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Calculator *calculator;
    calculator = [calculatorGroup[indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = calculator.text;
    cell.detailTextLabel.text = calculator.detailText;
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Calculator *calculator = [calculatorGroup[indexPath.section] objectAtIndex:indexPath.row];
    
    if ([calculator.text isEqualToString:@"Exact age"])
    {
        ExactAgeViewController *newViewController = [[ExactAgeViewController alloc] init];
        newViewController.selectedPatient = self.selectedPatient;
        [self.navigationController pushViewController:newViewController animated:YES];
    }
    else if ([calculator.text isEqualToString:@"Corrected age"])
    {
        CorrectedAgeViewController *newViewController = [[CorrectedAgeViewController alloc] init];
        
        [self.navigationController pushViewController:newViewController animated:YES];
    }
}

@end
