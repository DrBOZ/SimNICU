//
//  PhototherapyGestationViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 04/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyGestationViewController.h"
#import "AppDelegate.h"

@interface PhototherapyGestationViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableViewCell *USPretermGestation;
@property (nonatomic, strong) UITableViewCell *USTermGestation;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation PhototherapyGestationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Phototherapy/Gestation Selector"];
    
    self.title = @"Gestation";
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //menu table
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
    self.myTableView.hidden = NO;
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        if (self.gestation)
        {
            if ([self.gestation integerValue] > 30)
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:([self.gestation integerValue] - 23) inSection:0];
                
                [self.myTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self.myTableView deselectRowAtIndexPath:path animated:YES];
            }
        }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    NSLog(@"PhototherapyGestationViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyGestationIndexViewController unloaded properties");
        
        self.myTableView = nil;
        self.swipeGestureRecognizer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    int rows = 0;
    
    if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        rows = 16;
    }
    else if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        rows = 2;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    float fourInchDisplayPadding = 0.0f;
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        fourInchDisplayPadding = 0.0f;
    }
    
    height = 66.0f + fourInchDisplayPadding;
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Gestation at birth", nil); // need to add to localization string file
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        static NSString *CellIdentifier = @"UK";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        // setting only row text
        if (indexPath.row == 15)
        {
            cell.textLabel.text = @"38+ weeks";
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%i weeks", (indexPath.row + 23)];
        }
        
        // setting initial checkmarks and text colour
        if (self.gestation)
        {
            if ([self.gestation isEqualToNumber:[NSNumber numberWithInt:(indexPath.row + 23)]])
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
                
                // self.selectedUKGestation = [NSNumber numberWithInt:(indexPath.row + 23)];
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textColor = [UIColor blackColor];
            }
        }
        
        returnCell = cell;
    }
    else if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"Younger";
            self.USPretermGestation = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!self.USPretermGestation)
            {
                self.USPretermGestation = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                self.USPretermGestation.selectionStyle = UITableViewCellSelectionStyleBlue;
                self.USPretermGestation.backgroundColor = [UIColor whiteColor];
            }
            
            self.USPretermGestation.textLabel.text = @"35 - 37+6/40";
            
            if (self.gestation)
            {
                if ([self.gestation isEqualToNumber:[NSNumber numberWithInt:35]] || [self.gestation isEqualToNumber:[NSNumber numberWithInt:36]] || [self.gestation isEqualToNumber:[NSNumber numberWithInt:37]])
                {
                    self.USPretermGestation.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.USPretermGestation.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
                }
                else
                {
                    self.USPretermGestation.accessoryType = UITableViewCellAccessoryNone;
                    self.USPretermGestation.textLabel.textColor = [UIColor blackColor];
                }
            }
            
            returnCell = self.USPretermGestation;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"Older";
            self.USTermGestation = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!self.USTermGestation)
            {
                self.USTermGestation = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                self.USTermGestation.selectionStyle = UITableViewCellSelectionStyleBlue;
                self.USTermGestation.backgroundColor = [UIColor whiteColor];
            }
            
            self.USTermGestation.textLabel.text = @"38+ weeks";
            
            if (self.gestation)
            {
                if ([self.gestation isEqualToNumber:[NSNumber numberWithInt:38]] || [self.gestation isEqualToNumber:[NSNumber numberWithInt:39]] || [self.gestation isEqualToNumber:[NSNumber numberWithInt:40]]) // maybe more needed here...
                {
                    self.USTermGestation.accessoryType = UITableViewCellAccessoryCheckmark;
                    self.USTermGestation.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
                }
                else
                {
                    self.USTermGestation.accessoryType = UITableViewCellAccessoryNone;
                    self.USTermGestation.textLabel.textColor = [UIColor blackColor];
                }
            }
            
            returnCell = self.USTermGestation;
        }
        else
        {
            NSLog(@"More needed here");
        }
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if ([preferences.guidelineCountry isEqualToString:@"UK"])
    {
        NSIndexPath *oldCellPath = [NSIndexPath indexPathForRow:([self.gestation integerValue] - 23) inSection:0];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldCellPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor = [UIColor blackColor];
        
        // reference new cell
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.gestation = [NSNumber numberWithInt:(indexPath.row + 23)];
        
        [self.delegate phototherapyGestationViewController:self didFinishSelectingGestation:self.gestation];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([preferences.guidelineCountry isEqualToString:@"US"])
    {
        if (indexPath.row == 0)
        {
            self.gestation = [NSNumber numberWithInt:35];
            
            [self.delegate phototherapyGestationViewController:self didFinishSelectingGestation:self.gestation];
            
            self.USPretermGestation.accessoryType = UITableViewCellAccessoryCheckmark;
            self.USPretermGestation.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            
            self.USTermGestation.accessoryType = UITableViewCellAccessoryNone;
            self.USTermGestation.textLabel.textColor = [UIColor blackColor];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            self.gestation = [NSNumber numberWithInt:38];
            
            [self.delegate phototherapyGestationViewController:self didFinishSelectingGestation:self.gestation];
            
            self.USTermGestation.accessoryType = UITableViewCellAccessoryCheckmark;
            self.USTermGestation.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            
            self.USPretermGestation.accessoryType = UITableViewCellAccessoryNone;
            self.USPretermGestation.textLabel.textColor = [UIColor blackColor];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    // [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(popViewController:) userInfo:nil repeats:NO];
}

#pragma mark

- (void)popViewController:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

@end

