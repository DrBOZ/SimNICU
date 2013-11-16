//
//  DayZeroTableViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 30/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "DayZeroTableViewController.h"

@interface DayZeroTableViewController ()

@property UITableViewCell *day0;
@property UITableViewCell *day1;
@property UITableViewCell *dayMixed;

@end

@implementation DayZeroTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) return NSLocalizedString(@"Day 0 if infant is born before 12:00 midday, Day 1 if born after.", nil);
    
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"day0";
            self.day0 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!self.day0)
            {
                self.day0 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                self.day0.selectionStyle = UITableViewCellSelectionStyleBlue;
                self.day0.backgroundColor = [UIColor whiteColor];
            }
            
            self.day0.textLabel.text = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"day", @"noun"), 0];
            
            if ([preferences.ageInDaysSetting intValue] == 0)
            {
                self.day0.accessoryType = UITableViewCellAccessoryCheckmark;
                self.day0.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            }
            else
            {
                self.day0.accessoryType = UITableViewCellAccessoryNone;
                self.day0.textLabel.textColor = [UIColor blackColor];
            }
            
            returnCell = self.day0;
        }
        else if (indexPath.row == 1)
        {
            static NSString *CellIdentifier = @"day1";
            self.day1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (!self.day1)
            {
                self.day1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                self.day1.selectionStyle = UITableViewCellSelectionStyleBlue;
                self.day1.backgroundColor = [UIColor whiteColor];
            }
            
            self.day1.textLabel.text = [NSString stringWithFormat:@"%@ %i", NSLocalizedString(@"day", @"noun"), 1];
            
            if ([preferences.ageInDaysSetting intValue] == 1)
            {
                self.day1.accessoryType = UITableViewCellAccessoryCheckmark;
                self.day1.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            }
            else
            {
                self.day1.accessoryType = UITableViewCellAccessoryNone;
                self.day1.textLabel.textColor = [UIColor blackColor];
            }
            
            returnCell = self.day1;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"dayMixed";
        self.dayMixed = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.dayMixed)
        {
            self.dayMixed = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            self.dayMixed.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.dayMixed.backgroundColor = [UIColor whiteColor];
        }
        
        self.dayMixed.textLabel.text = NSLocalizedString(@"Depends on time of birth", nil);
        
        if ([preferences.ageInDaysSetting intValue] == 2)
        {
            self.dayMixed.accessoryType = UITableViewCellAccessoryCheckmark;
            self.dayMixed.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.dayMixed.accessoryType = UITableViewCellAccessoryNone;
            self.dayMixed.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.dayMixed;
    }
    
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            preferences.ageInDaysSetting = [NSNumber numberWithInt:0];
            
            // set checkmarks
            self.day0.accessoryType = UITableViewCellAccessoryCheckmark;
            self.day0.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            
            self.day1.accessoryType = UITableViewCellAccessoryNone;
            self.day1.textLabel.textColor = [UIColor blackColor];
            
            self.dayMixed.accessoryType = UITableViewCellAccessoryNone;
            self.dayMixed.textLabel.textColor = [UIColor blackColor];
        }
        else if (indexPath.row == 1)
        {
            preferences.ageInDaysSetting = [NSNumber numberWithInt:1];
            
            // set checkmarks
            self.day0.accessoryType = UITableViewCellAccessoryNone;
            self.day0.textLabel.textColor = [UIColor blackColor];
            
            self.day1.accessoryType = UITableViewCellAccessoryCheckmark;
            self.day1.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            
            self.dayMixed.accessoryType = UITableViewCellAccessoryNone;
            self.dayMixed.textLabel.textColor = [UIColor blackColor];
        }
    }
    else
    {
        preferences.ageInDaysSetting = [NSNumber numberWithInt:2];
        
        // set checkmarks
        self.day0.accessoryType = UITableViewCellAccessoryNone;
        self.day0.textLabel.textColor = [UIColor blackColor];
        
        self.day1.accessoryType = UITableViewCellAccessoryNone;
        self.day1.textLabel.textColor = [UIColor blackColor];
        
        self.dayMixed.accessoryType = UITableViewCellAccessoryCheckmark;
        self.dayMixed.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
