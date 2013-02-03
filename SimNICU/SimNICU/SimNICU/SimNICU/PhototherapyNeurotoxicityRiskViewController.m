//
//  PhototherapyNeurotoxicityRiskViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 27/10/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "PhototherapyNeurotoxicityRiskViewController.h"
#import "NeurotoxicityRiskFactor.h"
#import "AppDelegate.h"

@interface PhototherapyNeurotoxicityRiskViewController ()

@property UITableView *myTableView;

@end

@implementation PhototherapyNeurotoxicityRiskViewController
{
    NSMutableArray *riskFactors;
}

@synthesize neurotoxicityRiskFactors = _neurotoxicityRiskFactors;
@synthesize myTableView = _myTableView;
@synthesize delegate = _delegate;

@synthesize neuroRiskAcidosis = _neuroRiskAcidosis;
@synthesize neuroRiskAsphyxia = _neuroRiskAsphyxia;
@synthesize neuroRiskAlbuminLessThanThreeGramsPerDeciLitre = _neuroRiskAlbuminLessThanThreeGramsPerDeciLitre;
@synthesize neuroRiskG6PDPresent = _neuroRiskG6PDPresent;
@synthesize neuroRiskIsoimmunineHaemolyticDiseasePresent = _neuroRiskIsoimmunineHaemolyticDiseasePresent;
@synthesize neuroRiskSepsis = _neuroRiskSepsis;
@synthesize neuroRiskSignificantLethargy = _neuroRiskSignificantLethargy;
@synthesize neuroRiskTemperatureInstability = _neuroRiskTemperatureInstability;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.title = NSLocalizedString(@"Neurotoxicity Risk", nil); // need to add to localization string file
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //menu table
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
        self.myTableView.rowHeight = 44.0f;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.sectionFooterHeight = 10.0f;
        self.myTableView.sectionHeaderHeight = 10.0f;
        self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
        
#if APP_SHADING
        //screen mask covers everything
        UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
        tableBgView.image = tableBgImage;
        tableBgView.userInteractionEnabled = NO;
        [self.view addSubview:tableBgView];
#endif

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    riskFactors = [[NSMutableArray alloc] initWithCapacity:8];
    
    NeurotoxicityRiskFactor *riskFactor;
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Acidosis";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Albumin < 3.0 g/dL"; // localize to mmol/L
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@","])
    {
        // replace dots with commas
        riskFactor.text = [riskFactor.text stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Asphyxia";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"G6PD deficiency";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = NSLocalizedString(@"Isoimmune Haemolytic Disease", nil);
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Sepsis";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Significant Lethargy";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
    
    riskFactor = [[NeurotoxicityRiskFactor alloc] init];
    riskFactor.text = @"Temperature Instability";
    riskFactor.checked = NO;
    [riskFactors addObject:riskFactor];
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Phototherapy/Neurotoxicity Selector" withError:nil];
    
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"PhototherapyNeurotoxicityRiskViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"PhototherapyNeurotoxicityRiskViewController unloaded properties");
        
        self.myTableView = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 22.0f;
    
    if (section == 0)
    {
        float fourInchDisplayPadding = 0.0f;
        
        //delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            fourInchDisplayPadding = 0.0f;
        }
        
        height = 66.0f + fourInchDisplayPadding;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Neurotoxicity risk factors", nil);  // add to localization string file...;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 44.0f;
    
    if (indexPath.row == 1)
    {
        height = 2.0f;
    }
    
    return height;
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NeurotoxicityRiskFactor *riskFactor = [riskFactors objectAtIndex:(indexPath.row -2)];
    
    if (riskFactor.checked)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"None";
        self.neuroRiskNone = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!self.neuroRiskNone)
        {
            self.neuroRiskNone = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            self.neuroRiskNone.selectionStyle = UITableViewCellSelectionStyleBlue;
            self.neuroRiskNone.backgroundColor = [UIColor whiteColor];
        }
        
        self.neuroRiskNone.textLabel.text = @"None";
        
        if ([self.neurotoxicityRiskFactors isEqualToString:@"None"])
        {
            self.neuroRiskNone.accessoryType = UITableViewCellAccessoryCheckmark;
            self.neuroRiskNone.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        }
        else
        {
            self.neuroRiskNone.accessoryType = UITableViewCellAccessoryNone;
            self.neuroRiskNone.textLabel.textColor = [UIColor blackColor];
        }
        
        returnCell = self.neuroRiskNone;
    }
    else if (indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"thickDivider";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor darkGrayColor];
        }
        
        returnCell = cell;
    }
    else if (indexPath.row > 1)
    {
        static NSString *CellIdentifier = @"NeurotoxicityRiskFactor";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        NeurotoxicityRiskFactor *riskFactor = [riskFactors objectAtIndex:(indexPath.row -2)];
        
        cell.textLabel.text = riskFactor.text;
        
        [self configureCheckmarkForCell:cell atIndexPath:indexPath];
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = indexPath;
    
    if (indexPath.row == 1)
    {
        path = nil;
    }
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.neurotoxicityRiskFactors = @"None";
        
        // check 'None'
        self.neuroRiskNone.accessoryType = UITableViewCellAccessoryCheckmark;
        self.neuroRiskNone.textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        
        // go through array and set all parameters
        
        NeurotoxicityRiskFactor *riskFactor;
        NSIndexPath *path = nil;
        
        // for (int i = 0; i == ([riskFactors count] - 1); ++i)
        for (int i = 0; i < [riskFactors count]; ++i)
        {
            riskFactor = [riskFactors objectAtIndex:i];
            riskFactor.checked = NO;
            
            path = [NSIndexPath indexPathForRow:(i + 2) inSection:0];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
            
            [self configureCheckmarkForCell:cell atIndexPath:path];
        }
    }
    else if (indexPath.row > 1)
    {
        self.neurotoxicityRiskFactors = @"Present";
        
        // deselect none tableview cell...
        self.neuroRiskNone.accessoryType = UITableViewCellAccessoryNone;
        self.neuroRiskNone.textLabel.textColor = [UIColor blackColor];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NeurotoxicityRiskFactor *riskFactor = [riskFactors objectAtIndex:(indexPath.row -2)];
        riskFactor.checked = !riskFactor.checked;
        
        [self configureCheckmarkForCell:cell atIndexPath:indexPath];
    }
    
    [self.delegate phototherapyNeurotoxicityRiskViewController:self didFinishSelectingNeurotoxicityRisk:self.neurotoxicityRiskFactors];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
