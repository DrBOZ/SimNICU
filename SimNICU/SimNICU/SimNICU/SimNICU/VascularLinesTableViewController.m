//
//  VascularLinesTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "VascularLinesTableViewController.h"

@interface VascularLinesTableViewController ()

@end

@implementation VascularLinesTableViewController
{
    NSMutableArray *sectionHeaders;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Vascular lines Data Entry"];
    
    self.title = NSLocalizedString(@"Add Vascular Line", nil);
    
    sectionHeaders = [[NSMutableArray alloc] initWithCapacity:4];
    NSString *header;
    
    header = NSLocalizedString(@"Maternal", nil);
    [sectionHeaders addObject:header];
    
    header = NSLocalizedString(@"Infant", nil);
    [sectionHeaders addObject:header];
    
    header = NSLocalizedString(@"Direct Coombs Test", nil);
    [sectionHeaders addObject:header];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.view.tintColor = [UIColor redColor];
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
    // return [sectionHeaders count];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = 0;
    
    if (section == 0) numberOfRows = 3;
    
    else if (section == 1) numberOfRows = 2;
    
    else if (section == 2) numberOfRows = 1;
    
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionHeaders[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 40.0f;
    
    else return 30.0f;
}

# pragma mark

- (void)done
{
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:5];
    
    /*
    // Maternal blood group
    NSString *resultsMaternalBloodGroup = nil;
    
    if (self.maternalBloodGroup.selectedSegmentIndex == 0)
    {
        resultsMaternalBloodGroup = @"AB";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 1)
    {
        resultsMaternalBloodGroup = @"A";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 2)
    {
        resultsMaternalBloodGroup = @"B";
    }
    else if (self.maternalBloodGroup.selectedSegmentIndex == 3)
    {
        resultsMaternalBloodGroup = @"O";
    }
    else
    {
        resultsMaternalBloodGroup = @"?";
    }
    
    [results addObject:resultsMaternalBloodGroup];
    
    // Maternal Rhesus D status
    NSString *resultsMaternalRhesus = nil;
    
    if (self.maternalRhesus.selectedSegmentIndex == 0)
    {
        resultsMaternalRhesus = @"Neg";
    }
    else if (self.maternalRhesus.selectedSegmentIndex == 1)
    {
        resultsMaternalRhesus = @"Pos";
    }
    else
    {
        resultsMaternalRhesus = @"?";
    }
    
    [results addObject:resultsMaternalRhesus];
    
    // Maternal antibodies
    NSString *resultsMaternalAntibodies = nil;
    
    if (self.maternalAntibodies.selectedSegmentIndex == 0)
    {
        resultsMaternalAntibodies = @" - no antibodies";
    }
    else if (self.maternalAntibodies.selectedSegmentIndex == 1)
    {
        resultsMaternalAntibodies = @" - antibodies present";
    }
    else
    {
        resultsMaternalAntibodies = @"?";
    }
    
    [results addObject:resultsMaternalAntibodies];
    
    // Baby blood group
    NSString *resultsBabyBloodGroup = nil;
    
    if (self.babyBloodGroup.selectedSegmentIndex == 0)
    {
        resultsBabyBloodGroup = @"AB";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 1)
    {
        resultsBabyBloodGroup = @"A";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 2)
    {
        resultsBabyBloodGroup = @"B";
    }
    else if (self.babyBloodGroup.selectedSegmentIndex == 3)
    {
        resultsBabyBloodGroup = @"O";
    }
    else
    {
        resultsBabyBloodGroup = @"?";
    }
    
    [results addObject:resultsBabyBloodGroup];
    
    // Baby Rhesus D status
    NSString *resultsBabyRhesus = nil;
    
    if (self.babyRhesus.selectedSegmentIndex == 0)
    {
        resultsBabyRhesus = @"Neg";
    }
    else if (self.babyRhesus.selectedSegmentIndex == 1)
    {
        resultsBabyRhesus = @"Pos";
    }
    else
    {
        resultsBabyRhesus = @"?";
    }
    
    [results addObject:resultsBabyRhesus];
    
    // Direct Coombs Test
    NSString *resultsDCT = nil;
    
    if (self.dct.selectedSegmentIndex == 0)
    {
        resultsDCT = @"negative";
    }
    else if (self.dct.selectedSegmentIndex == 1)
    {
        resultsDCT = @"positive";
    }
    else
    {
        resultsDCT = @"?";
    }
    
    [results addObject:resultsDCT];
     */
    
    [self.delegate vascularLinesTableViewControllerDidFinish:self withResults:results];
}

- (void)cancel
{
    [self.delegate vascularLinesTableViewControllerDidCancel:self];
}

@end
