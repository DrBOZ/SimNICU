//
//  IntubationViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 11/08/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "IntubationDrugsViewController.h"
#import "IntubationViewController.h"
#import "CurosurfViewController.h"
#import "CBTimeMethods.h"
#import "AppDelegate.h"

@interface IntubationViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *intubationArray;
@property (nonatomic, strong) UILabel *suggestionBasedOn;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UISwitch *roundedSwitch;
@property (nonatomic) BOOL displayLengthToCutETT;

@end

@implementation IntubationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // code
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // setting default, as haven't coded options yet
    self.endotrachealTubeType = @"Portex Blue Line + holder";
    
    if ([self.endotrachealTubeType isEqualToString:@"Portex Blue Line + holder"])
    {
        self.displayLengthToCutETT = YES;
    }
    
    // check which version of iOS user is using
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        NSLog(@"IntubationViewController iOS 5.0+ pathway");
        
        float roundedSwitchHeight = 160.0f;
        float pickerHeight = 180.0f;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            roundedSwitchHeight = 180.0f;
            pickerHeight = 216.0f;
        }
        
        //menu table
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.sectionFooterHeight = 10.0f;
        self.myTableView.sectionHeaderHeight = 10.0f;
        self.myTableView.rowHeight = 44.0f;
        self.myTableView.dataSource = self;
        self.myTableView.scrollEnabled = NO;
        self.myTableView.delegate = self;
        self.myTableView.bounces = NO;
        self.myTableView.hidden = NO;
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        
        // rounded Switch
        self.roundedSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230.0f, roundedSwitchHeight, 80.0f, 44.0f)];
        [self.roundedSwitch addTarget:self action:@selector(changeRoundUp) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.roundedSwitch];
        
        UILabel *roundingLabel = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, roundedSwitchHeight, 100.0f, 30.0f)];
        roundingLabel.text = @"Round up";
        roundingLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        roundingLabel.backgroundColor = [UIColor clearColor];
        roundingLabel.shadowColor = [UIColor whiteColor];
        roundingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        roundingLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:roundingLabel];
        
        self.suggestionBasedOn = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 60.0f), 286.0f, 30.0f)];
        self.suggestionBasedOn.text = @"";
        self.suggestionBasedOn.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        self.suggestionBasedOn.backgroundColor = [UIColor clearColor];
        self.suggestionBasedOn.shadowColor = [UIColor whiteColor];
        self.suggestionBasedOn.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.suggestionBasedOn.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:self.suggestionBasedOn];
        
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 31.0f), 65.0f, 30.0f)]; // 205
        weight.text = @"Weight";
        weight.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        weight.backgroundColor = [UIColor clearColor];
        weight.shadowColor = [UIColor whiteColor];
        weight.shadowOffset = CGSizeMake(0.0f, 1.0f);
        weight.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:weight];
        
        UILabel *gest = [[UILabel alloc] initWithFrame:CGRectMake(83.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 31.0f), 65.0f, 30.0f)];
        gest.text = @"Gest";
        gest.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        gest.backgroundColor = [UIColor clearColor];
        gest.shadowColor = [UIColor whiteColor];
        gest.shadowOffset = CGSizeMake(0.0f, 1.0f);
        gest.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:gest];
        
        UILabel *ETTsize = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 31.0f), 65.0f, 30.0f)];
        ETTsize.text = @"Size";
        ETTsize.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        ETTsize.backgroundColor = [UIColor clearColor];
        ETTsize.shadowColor = [UIColor whiteColor];
        ETTsize.shadowOffset = CGSizeMake(0.0f, 1.0f);
        ETTsize.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:ETTsize];
        
        UILabel *oral = [[UILabel alloc] initWithFrame:CGRectMake(205.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 31.0f), 65.0f, 30.0f)];
        oral.text = @"Oral";
        oral.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        oral.backgroundColor = [UIColor clearColor];
        oral.shadowColor = [UIColor whiteColor];
        oral.shadowOffset = CGSizeMake(0.0f, 1.0f);
        oral.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:oral];
        
        UILabel *cut = [[UILabel alloc] initWithFrame:CGRectMake(262.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64.0f - 31.0f), 65.0f, 30.0f)];
        
        if (self.displayLengthToCutETT) {
            cut.text = @"Cut";
        }
        else {
            cut.text = @"Nasal";
        }
        
        cut.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];  //iOS 6.0
        cut.backgroundColor = [UIColor clearColor];
        cut.shadowColor = [UIColor whiteColor];
        cut.shadowOffset = CGSizeMake(0.0f, 1.0f);
        cut.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:cut];
        
        //intubation array
        self.intubationArray = [[NSMutableArray alloc] initWithCapacity:7];
        [self.intubationArray addObject:@"500       24      2.5      6.0     8.0"];
        [self.intubationArray addObject:@"1000     27      2.5      6.5     8.5"];
        [self.intubationArray addObject:@"1500     30   2.5/3.0   7.0     9.0"];
        [self.intubationArray addObject:@"2000     33      3.0      7.5     9.5"];
        [self.intubationArray addObject:@"2500     36      3.0      8.0     10.0"];
        [self.intubationArray addObject:@"3000     38      3.5      9.0     11.0"];
        [self.intubationArray addObject:@"3500     40      3.5      10.0   12.0"];
        
        //picker view
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, (appDelegate.window.bounds.size.height - pickerHeight - 64), 320.0f, pickerHeight)]; // 236
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self.view addSubview:self.pickerView];
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.3)
    {
        NSLog(@"IntubationViewController iOS 3.0+ pathway");
        
        //menu table
        // self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 236.0f) style:UITableViewStyleGrouped];
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
        
        self.myTableView.rowHeight = 44.0f;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.sectionFooterHeight = 10.0f;
        self.myTableView.sectionHeaderHeight = 10.0f;
        self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.myTableView.separatorColor = [UIColor grayColor];
        self.myTableView.hidden = NO;
        self.myTableView.bounces = NO;
        self.myTableView.scrollEnabled = NO;
        
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
        {
            // rounded Switch
            self.roundedSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210.0f, 160.0f, 80.0f, 44.0f)];
            [self.roundedSwitch addTarget:self action:@selector(changeRoundUp) forControlEvents:UIControlEventValueChanged];
            
            [self.view addSubview:self.roundedSwitch];
            
            UILabel *roundingLabel = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 160.0f, 100.0f, 30.0f)];
            roundingLabel.text = @"Round up";
            roundingLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
            roundingLabel.backgroundColor = [UIColor clearColor];
            roundingLabel.shadowColor = [UIColor whiteColor];
            roundingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
            roundingLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            [self.view addSubview:roundingLabel];
        }
        
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 205.0f, 65.0f, 30.0f)];
        weight.text = @"Weight";
        weight.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        weight.backgroundColor = [UIColor clearColor];
        weight.shadowColor = [UIColor whiteColor];
        weight.shadowOffset = CGSizeMake(0.0f, 1.0f);
        weight.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:weight];
        
        UILabel *gest = [[UILabel alloc] initWithFrame:CGRectMake(83.0f, 205.0f, 65.0f, 30.0f)];
        gest.text = @"Gest";
        gest.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        gest.backgroundColor = [UIColor clearColor];
        gest.shadowColor = [UIColor whiteColor];
        gest.shadowOffset = CGSizeMake(0.0f, 1.0f);
        gest.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:gest];
        
        UILabel *ETTsize = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, 205.0f, 65.0f, 30.0f)];
        ETTsize.text = @"Size";
        ETTsize.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        ETTsize.backgroundColor = [UIColor clearColor];
        ETTsize.shadowColor = [UIColor whiteColor];
        ETTsize.shadowOffset = CGSizeMake(0.0f, 1.0f);
        ETTsize.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:ETTsize];
        
        UILabel *oral = [[UILabel alloc] initWithFrame:CGRectMake(205.0f, 205.0f, 65.0f, 30.0f)];
        oral.text = @"Oral";
        oral.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        oral.backgroundColor = [UIColor clearColor];
        oral.shadowColor = [UIColor whiteColor];
        oral.shadowOffset = CGSizeMake(0.0f, 1.0f);
        oral.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:oral];
        
        UILabel *cut = [[UILabel alloc] initWithFrame:CGRectMake(262.0f, 205.0f, 65.0f, 30.0f)];
        
        if (self.displayLengthToCutETT)
        {
            cut.text = @"Cut";
        }
        else {
            cut.text = @"Nasal";
        }
        
        cut.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        cut.backgroundColor = [UIColor clearColor];
        cut.shadowColor = [UIColor whiteColor];
        cut.shadowOffset = CGSizeMake(0.0f, 1.0f);
        cut.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.view addSubview:cut];
        
        //intubation array
        self.intubationArray = [[NSMutableArray alloc] initWithCapacity:7];
        [self.intubationArray addObject:@"500      24      2.5     6.0     8.0"];
        [self.intubationArray addObject:@"1000    27      2.5     6.5     8.5"];
        [self.intubationArray addObject:@"1500    30   2.5/3.0  7.0     9.0"];
        [self.intubationArray addObject:@"2000    33      3.0     7.5     9.5"];
        [self.intubationArray addObject:@"2500    36      3.0     8.0     10.0"];
        [self.intubationArray addObject:@"3000    38      3.5     9.0     11.0"];
        [self.intubationArray addObject:@"3500    40      3.5     10.0   12.0"];
        
        // Only three available heights 162.0, 180.0, 216.0
        
        //picker view
        // self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 236, 320, 210)];
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.frame = CGRectMake(0.0f, 236.0f, 320.0f, 180.0f);
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self.view addSubview:self.pickerView];
        
#if APP_SHADING
        //screen mask covers everything
        UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, -30.0f, 320.0f, (appDelegate.window.bounds.size.height))];
        UIImage *tableBgImage = [UIImage imageNamed:@"bgOverlay.png"];
        tableBgView.image = tableBgImage;
        tableBgView.userInteractionEnabled = NO;
        [self.view addSubview:tableBgView];
#endif
        
    }
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Intubation" withError:nil];
    
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    // NSLog(@"IntubationViewController viewWillAppear: self.weight = %@", self.weight);
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
    // set title
    if (self.selectedPatient)
    {
        if (self.selectedPatient.gestation)
        {
            self.title = [NSString stringWithFormat:@"%@/40 now %@", self.selectedPatient.gestation, [CBTimeMethods calculateCurrentGestation:self.selectedPatient]];
            
            self.suggestionBasedOn.text = @"Suggestion based on gestation";
        }
        else
        {
            self.suggestionBasedOn.text = @"Suggestion based on working weight";
            
            NSString *UKLocaleWeight;
            UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float workingWeightKGAsFloat = [UKLocaleWeight floatValue];
            
            if (workingWeightKGAsFloat < 1.0f)
            {
                int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
                
                self.title = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
            }
            else
            {
                // present weight as kilograms
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                // if using arabic locale, force to english
                if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                {
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                }
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 1;
                formatter.maximumFractionDigits = 3;
                
                self.title = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
            }
        }
    }
    else
    {
        if (self.gestation)
        {
            self.title = [NSString stringWithFormat:@"Gestation %@/40", self.gestation];
            
            self.suggestionBasedOn.text = @"";
        }
        else if (self.weight)
        {
            self.suggestionBasedOn.text = @"";
            
            NSString *UKLocaleWeight;
            UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
            UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
            
            float workingWeightKGAsFloat = [UKLocaleWeight floatValue];
            
            if (workingWeightKGAsFloat < 1.0f)
            {
                int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
                
                self.title = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
            }
            else
            {
                // present weight as kilograms
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                // if using arabic locale, force to english
                if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
                {
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                }
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 1;
                formatter.maximumFractionDigits = 3;
                
                self.title = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
            }
        }
        else 
        {
            self.title = @"Intubation";
            self.suggestionBasedOn.text = @"";
        }
    }
    
    if ([self.roundUp isEqualToString:@"1"]) 
    {
        self.roundedSwitch.on = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
    
    [self setPicker]; // select picker only once view appears
    
    [Flurry logEvent:@"Intubation: viewDidAppear"];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.myTableView = nil;
    self.swipeGestureRecognizer = nil;
    self.pickerView = nil;
    self.roundedSwitch = nil;
    self.intubationArray = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"IntubationViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
        {
            NSLog(@"IntubationViewController unloaded properties");
            
            self.myTableView = nil;
            self.swipeGestureRecognizer = nil;
        }
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        height = 44.0f;
    }
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
    {
        height = 44.0f;
    }
    else
    {
        height = 36.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"textView0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Intubation Drugs";
        
        returnCell = cell;
    }
    else if(indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"textView1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"Curosurf\u00AE";
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 0) 
    {
        IntubationDrugsViewController *newViewController = [[IntubationDrugsViewController alloc] init];
        newViewController.workingWeight = self.weight;
        
        [appDelegate.navigationController pushViewController:newViewController animated:YES];
    }
    else 
    {
        CurosurfViewController *newViewController = [[CurosurfViewController alloc] init];

        newViewController.curosurfDoseSelected = @"YES";
        NSLog(@"newViewController.curosurfDoseSelected = %@", newViewController.curosurfDoseSelected);
        
        [appDelegate.navigationController pushViewController:newViewController animated:YES];
    }
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.intubationArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.intubationArray objectAtIndex:row];
}

#pragma mark - Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.suggestionBasedOn.text = @"";
}

- (void)setPicker
{
    // check if user wants to round up
    if (self.roundedSwitch.on)
    {
        if (self.selectedPatient)
        {
            if (self.selectedPatient.gestation)
            {
                // work out on corrected gestation
                NSString *correctedGestation = [CBTimeMethods calculateCurrentGestation:self.selectedPatient];
                
                int value = [correctedGestation intValue];
                
                if (value <26)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 26) && (value < 29))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((value >= 29) && (value < 32))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((value >= 32) && (value < 35))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((value >= 35) && (value < 37))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((value >= 37) && (value < 39))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
            else if (self.selectedPatient.workingWeight)
            {
                // else work out on working weight
                NSString *UKLocaleWeight;
                UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleWeight floatValue];
                
                int weightGRAMSasInt = weightKGAsFloat * 1000;
                
                if (weightGRAMSasInt < 800)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 800) && (weightGRAMSasInt < 1300))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1300) && (weightGRAMSasInt < 1800))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1800) && (weightGRAMSasInt < 2300))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2300) && (weightGRAMSasInt < 2800))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2800) && (weightGRAMSasInt < 3300))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else if (weightGRAMSasInt >= 3300)
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
        }
        else
        {
            if (self.weight)
            {
                NSString *UKLocaleWeight;
                UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleWeight floatValue];
                
                int weightGRAMSasInt = weightKGAsFloat * 1000;
                
                if (weightGRAMSasInt < 800)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 800) && (weightGRAMSasInt < 1300))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1300) && (weightGRAMSasInt < 1800))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1800) && (weightGRAMSasInt < 2300))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2300) && (weightGRAMSasInt < 2800))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2800) && (weightGRAMSasInt < 3300))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else if (weightGRAMSasInt >= 3300)
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
            
            if (self.gestation)
            {
                int value = [self.gestation intValue];
                
                if (value <26)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 26) && (value < 29))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((value >= 29) && (value < 32))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((value >= 32) && (value < 35))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((value >= 35) && (value < 37))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((value >= 37) && (value < 39))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
        }
    }
    else 
    {
        if (self.selectedPatient)
        {
            if (self.selectedPatient.gestation)
            {
                // work out on corrected gestation
                NSString *correctedGestation = [CBTimeMethods calculateCurrentGestation:self.selectedPatient];
                
                int value = [correctedGestation intValue];
                
                if (value <24)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 24) && (value < 27))
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 27) && (value < 30))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((value >= 30) && (value < 33))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((value >= 33) && (value < 36))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((value >= 36) && (value < 38))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((value >= 38) && (value < 40))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
            else if (self.selectedPatient.workingWeight)
            {
                // else work out on working weight
                NSString *UKLocaleWeight;
                UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWeight = [self.selectedPatient.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleWeight floatValue];
                
                int weightGRAMSasInt = weightKGAsFloat * 1000;
                
                NSLog(@"Weight = %i", weightGRAMSasInt);
                
                if (weightGRAMSasInt < 500)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 500) && (weightGRAMSasInt < 1000))
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1000) && (weightGRAMSasInt < 1500))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1500) && (weightGRAMSasInt < 2000))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2000) && (weightGRAMSasInt < 2500))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2500) && (weightGRAMSasInt < 3000))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 3000) && (weightGRAMSasInt < 3500))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else if (weightGRAMSasInt >= 3500)
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
        }
        else
        {
            if (self.weight)
            {
                NSString *UKLocaleWeight;
                UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:@"," withString:@"."];
                UKLocaleWeight = [self.weight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
                
                float weightKGAsFloat = [UKLocaleWeight floatValue];
                
                int weightGRAMSasInt = weightKGAsFloat * 1000;
                
                NSLog(@"Weight = %i", weightGRAMSasInt);
                
                if (weightGRAMSasInt < 500)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 500) && (weightGRAMSasInt < 1000))
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1000) && (weightGRAMSasInt < 1500))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 1500) && (weightGRAMSasInt < 2000))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2000) && (weightGRAMSasInt < 2500))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 2500) && (weightGRAMSasInt < 3000))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((weightGRAMSasInt >= 3000) && (weightGRAMSasInt < 3500))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else if (weightGRAMSasInt >= 3500)
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
            
            if (self.gestation)
            {
                int value = [self.gestation intValue];
                
                if (value <24)
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 24) && (value < 27))
                {
                    [self.pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if ((value >= 27) && (value < 30))
                {
                    [self.pickerView selectRow:1 inComponent:0 animated:YES];
                }
                else if ((value >= 30) && (value < 33))
                {
                    [self.pickerView selectRow:2 inComponent:0 animated:YES];
                }
                else if ((value >= 33) && (value < 36))
                {
                    [self.pickerView selectRow:3 inComponent:0 animated:YES];
                }
                else if ((value >= 36) && (value < 38))
                {
                    [self.pickerView selectRow:4 inComponent:0 animated:YES];
                }
                else if ((value >= 38) && (value < 40))
                {
                    [self.pickerView selectRow:5 inComponent:0 animated:YES];
                }
                else
                {
                    [self.pickerView selectRow:6 inComponent:0 animated:YES];
                }
            }
        }
    }
}

- (void)changeRoundUp
{
    NSLog(@"self.roundedSwitch.on = %i", self.roundedSwitch.on);
    
    [self.delegate intubationViewController:self didChangeETTRoundUp:self.roundedSwitch.on];
    
    [self setPicker];
}

@end
