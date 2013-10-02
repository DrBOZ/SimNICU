//
//  APGAR15ViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 29/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "APGAR15ViewController.h"
#import "SVSegmentedControl.h"
#import "APGARVCFormats.h"
#import "AppDelegate.h"

@interface APGAR15ViewController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UISegmentedControl *respiratoryEffort;
@property (nonatomic, strong) UISegmentedControl *heartRate;
@property (nonatomic, strong) UISegmentedControl *reflexes;
@property (nonatomic, strong) UISegmentedControl *colour;
@property (nonatomic, strong) UISegmentedControl *tone;

@end

@implementation APGAR15ViewController
{
    BOOL liteVersionAlertShown;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"15 minutes";
        
        //delegate
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //tableView
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            // hack
            UITableView *colourMatch = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 64.0f)];
            [self.view addSubview:colourMatch];
            
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
        }
        else
        {
            self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
        }
        self.myTableView.rowHeight = 44.0f;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
        {
            self.myTableView.sectionFooterHeight = 4.0f;
        }
        else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 3.0)
        {
            self.myTableView.sectionFooterHeight = 5.0f;
        }
        self.myTableView.sectionHeaderHeight = 10.0f;
        self.myTableView.scrollEnabled = NO;
        self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.myTableView.separatorColor = [UIColor clearColor];
        [self.view addSubview:self.myTableView];
        
        // add TableView background
        [CBDisplayMethods setBackgroundForTableView:self.myTableView];
    }
    
    // swipe gesture recognizer
    self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.myTableView addGestureRecognizer:self.swipeGestureRecognizer];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.swipeGestureRecognizer = nil;
    self.scoreRespiratoryEffort = nil;
    self.respiratoryEffort = nil;
    self.scoreHeartRate = nil;
    self.scoreReflexes = nil;
    self.scoreColour = nil;
    self.heartRate = nil;
    self.scoreTone = nil;
    self.reflexes = nil;
    self.colour = nil;
    self.tone = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float header;
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        // 4 inch Retina
        
        header = 35.0f;
        
        if (section == 0)
        {
            header = 40.0f;
        }
    }
    else
    {
        // 3.5 inch Retina
        
        header = 17.0f;
        
        if (section == 0)
        {
            header = 25.0f;
        }
    }
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (section == 4)
    {
        footer = @"APGAR Score";
    }
    
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    // delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (section == 0) 
    {
        // Create Custom headerView 'Colour"
        UIView *headerView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 300.0f, 30.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Colour";
            
            [headerView addSubview:headerLabel];
            
            // Create label to display value for 'Colour'
            self.scoreColour = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 15.0f, 10.0f, 30.0f)];
            [APGARVCFormats formatLabel:self.scoreColour];
        }
        else
        {
            // 3.5 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 300.0f, 30.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Colour";
            
            [headerView addSubview:headerLabel];
            
            // Create label to display value for 'Colour'
            self.scoreColour = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 0.0f, 10.0f, 30.0f)];
            [APGARVCFormats formatLabel:self.scoreColour];
        }
        
        if (self.patient.APGAR15minColour) 
        {
            self.scoreColour.text = self.patient.APGAR15minColour;
        }
        
        [headerView addSubview:self.scoreColour];
        
        view = headerView;
    }
    else if (section == 1) 
    {
        UIView *headerView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Heart Rate";
            
            [headerView addSubview:headerLabel];
            
            self.scoreHeartRate = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 15.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreHeartRate];
        }
        else
        {
            // 3.5 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Heart Rate";
            
            [headerView addSubview:headerLabel];
            
            self.scoreHeartRate = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 0.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreHeartRate];
        }
         
        if (self.patient.APGAR15minHeartRate) 
        {
            self.scoreHeartRate.text = self.patient.APGAR15minHeartRate;
        }
        
        [headerView addSubview:self.scoreHeartRate];
        
        view = headerView;
    }
    else if (section == 2) 
    {
        UIView *headerView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 17.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 300.0f, 17.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Respiratory Effort";
            
            [headerView addSubview:headerLabel];
            
            self.scoreRespiratoryEffort = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 15.0f, 10.0f, 17.0f)];
            [APGARVCFormats formatLabel:self.scoreRespiratoryEffort];
        }
        else
        {
            // 3.5 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 17.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 300.0f, 17.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Respiratory Effort";
            
            [headerView addSubview:headerLabel];
            
            self.scoreRespiratoryEffort = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 0.0f, 10.0f, 17.0f)];
            [APGARVCFormats formatLabel:self.scoreRespiratoryEffort];
        }
        
        if (self.patient.APGAR15minRespiratoryEffort) 
        {
            self.scoreRespiratoryEffort.text = self.patient.APGAR15minRespiratoryEffort;
        }
        
        [headerView addSubview:self.scoreRespiratoryEffort];
        
        view = headerView;
    }
    else if (section == 3) 
    {
        UIView *headerView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Tone";
            
            [headerView addSubview:headerLabel];
            
            self.scoreTone = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 15.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreTone];
        }
        else
        {
            // 3.5 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Tone";
            
            [headerView addSubview:headerLabel];
            
            self.scoreTone = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 0.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreTone];
        }
         
        if (self.patient.APGAR15minTone) 
        {
            self.scoreTone.text = self.patient.APGAR15minTone;
        }
        
        [headerView addSubview:self.scoreTone];
        
        view = headerView;
    }
    else if (section == 4) 
    {
        UIView *headerView;
        
        if (appDelegate.window.bounds.size.height == 568)
        {
            // 4 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 15.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Reflexes";
            
            [headerView addSubview:headerLabel];
            
            self.scoreReflexes = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 15.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreReflexes];
        }
        else
        {
            // 3.5 inch Retina
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 15.0f)];
            
            UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 300.0f, 15.0f)];
            [APGARVCFormats formatLabel:headerLabel];
            headerLabel.text = @"Reflexes";
            
            [headerView addSubview:headerLabel];
            
            self.scoreReflexes = [[UILabel alloc] initWithFrame:CGRectMake(290.0f, 0.0f, 10.0f, 15.0f)];
            [APGARVCFormats formatLabel:self.scoreReflexes];
        }
         
        if (self.patient.APGAR15minReflexes) 
        {
            self.scoreReflexes.text = self.patient.APGAR15minReflexes;
        }
        
        [headerView addSubview:self.scoreReflexes];
        
        view = headerView;
    }
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.section == 0) 
    {
        self.colour = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"White", @"Blue", @"Pink", nil]];
        self.colour.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
        
        self.colour.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        if (self.patient)
        {
            if (!(self.patient.APGAR15minColour == NULL)) 
            {
                self.colour.selectedSegmentIndex = [self.patient.APGAR15minColour intValue];
            }
        }
        
        [self.colour addTarget:self 
                        action:@selector(selectColour) 
              forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = self.colour;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1)
    {
        self.heartRate = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"0", @"< 100", @"> 100", nil]];
        self.heartRate.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
        
        self.heartRate.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        if (self.patient)
        {
            if (!(self.patient.APGAR15minHeartRate == NULL)) 
            {
                self.heartRate.selectedSegmentIndex = [self.patient.APGAR15minHeartRate intValue];
            }
        }
        
        [self.heartRate addTarget:self 
                           action:@selector(selectHeartRate) 
                 forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = self.heartRate;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 2) // Respiratory Effort
    {
        self.respiratoryEffort = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Apnoea", nil), @"Gasp", @"Regular", nil]];
        self.respiratoryEffort.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
        
        self.respiratoryEffort.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        if (self.patient)
        {
            if (!(self.patient.APGAR15minRespiratoryEffort == NULL)) 
            {
                self.respiratoryEffort.selectedSegmentIndex = [self.patient.APGAR15minRespiratoryEffort intValue];
            }
        }
        
        [self.respiratoryEffort addTarget:self 
                                   action:@selector(selectRespiratoryEffort) 
                         forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = self.respiratoryEffort;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 3) // Tone
    {
        self.tone = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Flaccid", @"Limp", @"Good", nil]];
        self.tone.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
        
        self.tone.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        if (self.patient)
        {
            if (!(self.patient.APGAR15minTone == NULL)) 
            {
                self.tone.selectedSegmentIndex = [self.patient.APGAR15minTone intValue];
            }
        }
        
        [self.tone addTarget:self 
                      action:@selector(selectTone) 
            forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = self.tone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 4) // Reflexes
    {
        self.reflexes = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Nil", @"Grimace", @"Cry", nil]];
        self.reflexes.frame = CGRectMake(0.0f, 0.0f, 300.0f, 44.0f);
        
        self.reflexes.segmentedControlStyle = UISegmentedControlStyleBordered;
        
        if (self.patient)
        {
            if (!(self.patient.APGAR15minReflexes == NULL)) 
            {
                self.reflexes.selectedSegmentIndex = [self.patient.APGAR15minReflexes intValue];
                self.scoreReflexes.text = [NSString stringWithFormat:@"%i", self.reflexes.selectedSegmentIndex];
                [self calculateAndDisplayTotalAPGARScore];
            }
        }
        
        [self.reflexes addTarget:self 
                          action:@selector(selectReflexes) 
                forControlEvents:UIControlEventValueChanged];
        
        cell.accessoryView = self.reflexes;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

# pragma mark - private methods

- (void)selectColour
{
    
#ifdef LITE_VERSION
    
    if (!liteVersionAlertShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only 1 and 5 minute APGARs are enabled in the Lite version."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
        liteVersionAlertShown = YES;
    }
    
    self.colour.selectedSegmentIndex = -1;
    
#else
    
    self.scoreColour.text = [NSString stringWithFormat:@"%i", self.colour.selectedSegmentIndex];
    [self calculateAndDisplayTotalAPGARScore];
    
#endif
    
}

- (void)selectHeartRate
{
#ifdef LITE_VERSION
    
    if (!liteVersionAlertShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only 1 and 5 minute APGARs are enabled in the Lite version."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
        liteVersionAlertShown = YES;
    }
    
    self.heartRate.selectedSegmentIndex = -1;
    
#else
    
    self.scoreHeartRate.text = [NSString stringWithFormat:@"%i", self.heartRate.selectedSegmentIndex];
    [self calculateAndDisplayTotalAPGARScore];
    
#endif

}

- (void)selectRespiratoryEffort
{
    
#ifdef LITE_VERSION
    
    if (!liteVersionAlertShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only 1 and 5 minute APGARs are enabled in the Lite version."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
        liteVersionAlertShown = YES;
    }
    
    self.respiratoryEffort.selectedSegmentIndex = -1;
    
#else
    
    self.scoreRespiratoryEffort.text = [NSString stringWithFormat:@"%i", self.respiratoryEffort.selectedSegmentIndex];
    [self calculateAndDisplayTotalAPGARScore];
    
#endif
    
}

- (void)selectTone
{
    
#ifdef LITE_VERSION
    
    if (!liteVersionAlertShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only 1 and 5 minute APGARs are enabled in the Lite version."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
        liteVersionAlertShown = YES;
    }
    
    self.tone.selectedSegmentIndex = -1;
    
#else
    
    self.scoreTone.text = [NSString stringWithFormat:@"%i", self.tone.selectedSegmentIndex];
    [self calculateAndDisplayTotalAPGARScore];
    
#endif
    
}

- (void)selectReflexes
{
    
#ifdef LITE_VERSION
    
    if (!liteVersionAlertShown)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"SimNICU Lite Version"
                                  message:@"Only 1 and 5 minute APGARs are enabled in the Lite version."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
        
        liteVersionAlertShown = YES;
    }
    
    self.reflexes.selectedSegmentIndex = -1;
    
#else
    
    self.scoreReflexes.text = [NSString stringWithFormat:@"%i", self.reflexes.selectedSegmentIndex];
    [self calculateAndDisplayTotalAPGARScore];
    
#endif
    
}

- (void)calculateAndDisplayTotalAPGARScore
{
    int total;
    
    total = (self.colour.selectedSegmentIndex + self.heartRate.selectedSegmentIndex + self.respiratoryEffort.selectedSegmentIndex + self.tone.selectedSegmentIndex + self.reflexes.selectedSegmentIndex);
    
    self.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
    
    if (!(self.colour.selectedSegmentIndex == -1) && !(self.heartRate.selectedSegmentIndex == -1) && !(self.respiratoryEffort.selectedSegmentIndex == -1) && !(self.tone.selectedSegmentIndex == -1) && !(self.reflexes.selectedSegmentIndex == -1))
    {
        NSString *icon;
        
        icon = [NSString stringWithFormat:@"APGAR%i.png", total];
        
        self.tabBarItem.image = [UIImage imageNamed:icon];
        
        if (total < 6)
        {
            // self.tabBarItem.badgeValue = @"*";
            
            // set this for 10 minutes to prompt cooling question
        }
        
        // enable save
        self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

@end
