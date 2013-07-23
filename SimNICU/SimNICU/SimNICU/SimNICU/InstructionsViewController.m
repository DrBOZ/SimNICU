//
//  InstructionsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 26/11/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "InstructionsViewController.h"
#import "AppDelegate.h"

@interface InstructionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation InstructionsViewController
{
    NSMutableArray *instructionGeneralItems;
    NSMutableArray *instructionSpecificItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"Instructions";
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64 - 49)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    self.myTableView.userInteractionEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    
#if APP_SHADING
    //screen mask covers everything
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
    UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
    tableBgView.image = tableBgImage;
    tableBgView.userInteractionEnabled = NO;
    [self.view addSubview:tableBgView];
#endif
    
    // construct menu items
    instructionGeneralItems = [[NSMutableArray alloc] initWithCapacity:5];
    
    [instructionGeneralItems addObject:@"Overview"];
    [instructionGeneralItems addObject:@"Patient List"];
    [instructionGeneralItems addObject:@"Passcode Lock"];
    
    instructionSpecificItems = [[NSMutableArray alloc] initWithCapacity:5];
    
    [instructionSpecificItems addObject:@"APGAR scores"];
    [instructionSpecificItems addObject:@"Phototherapy"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Instructions" withError:nil];
    
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"InstructionsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"InstructionsViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    
    if (section == 0)
    {
        rows = [instructionGeneralItems count];
    }
    else
    {
        rows = [instructionSpecificItems count];
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString = nil;
    
    if (section == 0)
    {
        returnString = @"General";
    }
    else if (section == 1)
    {
        returnString = @"Specific";
    }
    
    return returnString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (section == 0)
    {
        height = 66.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"section1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = [instructionGeneralItems objectAtIndex:indexPath.row];
        
        returnCell = cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"section2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = [instructionSpecificItems objectAtIndex:indexPath.row];
        
        returnCell = cell;
    }
    
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
