//
//  PaperSizeTableViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PDFGenerationTableViewController.h"
#import "PaperSizeTableViewController.h"

@interface PaperSizeTableViewController ()

@property (nonatomic, strong) UITableViewCell *cellUS;
@property (nonatomic, strong) UITableViewCell *cellUK;

@end

@implementation PaperSizeTableViewController
{
    // this is to prevent a long press on the back button from triggering two actions
    BOOL backButtonLongPressed;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"Settings/PDF/Paper Size"];
    
    self.title = NSLocalizedString(@"Paper Size", nil);
    
    // setup back bar button with long press gesture
    self.navigationItem.leftBarButtonItem = [CBBarButtonItems customBackBarButtonItemWithLongPressGestureRecognizerWithTarget:self
                                                                                                                       action:@selector(backButtonPressed)
                                                                                                              longPressTarget:self
                                                                                                              longPressAction:@selector(backButtonLongPressed)];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.view.tintColor = [UIColor redColor];
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonLongPressed
{
    if (!backButtonLongPressed)
    {
        backButtonLongPressed = YES;
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    UITableViewCell *returnCell = nil;
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"Letter";
        self.cellUS = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellUS)
        {
            self.cellUS = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellUS.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellUS.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellUS.textLabel.text = @"Letter";
        self.cellUS.detailTextLabel.text = @"";
        
        if ([preferences.paperSize isEqualToString:@"Letter"])
        {
            self.cellUS.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cellUS.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.cellUS.accessoryType = UITableViewCellAccessoryNone;
            self.cellUS.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.cellUS;
    }
    else
    {
        static NSString *CellIdentifier = @"UK";
        self.cellUK = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.cellUK)
        {
            self.cellUK = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            self.cellUK.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.cellUK.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellUK.textLabel.text = @"A4";
        self.cellUK.detailTextLabel.text = @"";
        
        if ([preferences.paperSize isEqualToString:@"A4"])
        {
            self.cellUK.accessoryType = UITableViewCellAccessoryCheckmark;
            self.cellUK.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.cellUK.accessoryType = UITableViewCellAccessoryNone;
            self.cellUK.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.cellUK;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Preferences *preferences = [Preferences sharedPreferences];
    
    if (indexPath.row == 0)
    {
        preferences.paperSize = @"Letter";
        
        self.cellUS.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellUS.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellUK.accessoryType = UITableViewCellAccessoryNone;
        self.cellUK.textLabel.textColor = [UIColor blackColor];
    }
    else
    {
        preferences.paperSize = @"A4";
        
        self.cellUK.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellUK.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        self.cellUS.accessoryType = UITableViewCellAccessoryNone;
        self.cellUS.textLabel.textColor = [UIColor blackColor];
    }
    
    [self.delegate paperSizeTableViewController:self didSelectPaperSize:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
