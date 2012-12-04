//
//  InfusionsBackgroundViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 15/08/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "InfusionsViewController.h"
#import "DAAnisotropicImage.h"
#import "SVSegmentedControl.h"
#import "AppDelegate.h"

@interface InfusionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSString *morphineStrength;
@property (nonatomic, strong) NSString *morphineStrengthDose;
@property (nonatomic, strong) UILabel *morphineStrengthLabel;
@property (nonatomic, strong) UILabel *morphineDoseLabel;
@property (nonatomic, strong) UILabel *morphineDose2Label;
@property (nonatomic, strong) UILabel *morphineRangeLabel;

@property (nonatomic, strong) NSString *dopamineStrength;
@property (nonatomic, strong) NSString *dopamineStrengthDose;
@property (nonatomic, strong) UILabel *dopamineStrengthLabel;
@property (nonatomic, strong) UILabel *dopamineDoseLabel;
@property (nonatomic, strong) UILabel *dopamineDose2Label;
@property (nonatomic, strong) UILabel *dopamineRangeLabel;

@property (nonatomic, strong) NSString *dobutamineStrength;
@property (nonatomic, strong) NSString *dobutamineStrengthDose;
@property (nonatomic, strong) UILabel *dobutamineStrengthLabel;
@property (nonatomic, strong) UILabel *dobutamineDoseLabel;
@property (nonatomic, strong) UILabel *dobutamineDose2Label;
@property (nonatomic, strong) UILabel *dobutamineRangeLabel;

@property (nonatomic, strong) NSString *adrenalineStrength;
@property (nonatomic, strong) NSString *adrenalineStrengthDose;
@property (nonatomic, strong) UILabel *adrenalineStrengthLabel;
@property (nonatomic, strong) UILabel *adrenalineDoseLabel;
@property (nonatomic, strong) UILabel *adrenalineDose2Label;
@property (nonatomic, strong) UILabel *adrenalineRangeLabel;

@property (nonatomic, strong) NSString *insulinStrength;
@property (nonatomic, strong) NSString *insulinStrengthDose;
@property (nonatomic, strong) UILabel *insulinStrengthLabel;
@property (nonatomic, strong) UILabel *insulinDoseLabel;
@property (nonatomic, strong) UILabel *insulinDose2Label;
@property (nonatomic, strong) UILabel *insulinRangeLabel;

@property (nonatomic, strong) NSString *atracuriumStrength;
@property (nonatomic, strong) NSString *atracuriumStrengthDose;
@property (nonatomic, strong) UILabel *atracuriumStrengthLabel;
@property (nonatomic, strong) UILabel *atracuriumDoseLabel;
@property (nonatomic, strong) UILabel *atracuriumDose2Label;
@property (nonatomic, strong) UILabel *atracuriumRangeLabel;

@property (nonatomic, strong) NSString *midazolamStrength;
@property (nonatomic, strong) NSString *midazolamStrengthDose;
@property (nonatomic, strong) UILabel *midazolamStrengthLabel;
@property (nonatomic, strong) UILabel *midazolamDoseLabel;
@property (nonatomic, strong) UILabel *midazolamDose2Label;
@property (nonatomic, strong) UILabel *midazolamRangeLabel;

@property (nonatomic, strong) UILabel *prostinDose3Label;

@property (nonatomic, strong) UISlider *anisotropicSlider;
@property (nonatomic, strong) UISlider *normalSlider;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;
- (void)standardSegmentedControlChangedValue:(UISegmentedControl*)segmentedControl;
- (void)sliderValueChanged:(id)sender;

@end

@implementation InfusionsViewController
{
    BOOL adrenalineConcentrationHighWarningGiven;
    BOOL dobutamineConcentrationHighWarningGiven;
    BOOL dopamineConcentrationHighWarningGiven;
    BOOL morphineConcentrationHighWarningGiven;
    NSString *heparinDiluent;
    NSString *lidocaineStrength;
    NSString *lidocaineStrengthDose;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.workingWeight)
    {
        float workingWeightKGAsFloat = [self.workingWeight floatValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            self.title = [NSString stringWithFormat:@"Working weight %i g", workingWeightGRAMSAsInt];
        }
        else  // present weight as kilograms
        {
            NSString *tempString = [NSString stringWithFormat:@"%.2f", workingWeightKGAsFloat];
            
            if ([[tempString substringFromIndex:[tempString length] - 1] isEqualToString:@"0"])
            {
                if ([[tempString substringFromIndex:[tempString length] - 2] isEqualToString:@"00"])
                {
                    self.title = [NSString stringWithFormat:@"Working weight %.0f kg", workingWeightKGAsFloat];
                }
                else {
                    self.title = [NSString stringWithFormat:@"Working weight %.1f kg", workingWeightKGAsFloat];
                }
            }
            else
            {
                self.title = [NSString stringWithFormat:@"Working weight %.2f kg", workingWeightKGAsFloat];
            }
        }
        
        self.adrenalineStrength = @"Single";
        self.adrenalineStrengthDose = @"3 mg/kg";
        self.atracuriumStrength = @"Single";
        self.atracuriumStrengthDose = @"60 mg/kg";
        self.insulinStrength = @"Single";
        self.insulinStrengthDose = @"10 units/kg";
        self.midazolamStrength = @"Single";
        self.midazolamStrengthDose = @"10 mg/kg";
        
        if (workingWeightKGAsFloat < 0.75f)
        {
            self.morphineStrength = @"Quad";
            self.morphineStrengthDose = @"4 mg/kg";
            self.dopamineStrength = @"Quad";
            self.dopamineStrengthDose = @"120 mg/kg"; // reconsider this
            self.dobutamineStrength = @"Quad";
            self.dobutamineStrengthDose = @"120 mg/kg";
            
            if (workingWeightKGAsFloat < 0.417f)
            {
                self.atracuriumStrength = @"Double";
                self.atracuriumStrengthDose = @"120 mg/kg";
            }
        }
        else if (workingWeightKGAsFloat >= 0.75f && workingWeightKGAsFloat < 1.5f)
        {
            self.morphineStrength = @"Double";
            self.morphineStrengthDose = @"2 mg/kg";
            self.dopamineStrength = @"Double";
            self.dopamineStrengthDose = @"60 mg/kg";
            self.dobutamineStrength = @"Double";
            self.dobutamineStrengthDose = @"60 mg/kg";
        }
        else if (workingWeightKGAsFloat >= 1.5f)
        {
            self.morphineStrength = @"Single";
            self.morphineStrengthDose = @"1 mg/kg";
            self.dopamineStrength = @"Single";
            self.dopamineStrengthDose = @"30 mg/kg";
            self.dobutamineStrength = @"Single";
            self.dobutamineStrengthDose = @"30 mg/kg";
        }
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            heparinDiluent = @"0.45% Sodium Chloride";
        }
        else
        {
            heparinDiluent = @"0.9% Sodium Chloride";
        }
        
        if (workingWeightKGAsFloat < 2.0f)
        {
            lidocaineStrength = @"Double";
            lidocaineStrengthDose = @"200 mg/kg";
        }
        else if (workingWeightKGAsFloat >= 2.0f)
        {
            lidocaineStrength = @"Single";
            lidocaineStrengthDose = @"100 mg/kg";
        }
    }
    else
    {
        self.title = @"Weight not entered";
    }
    
    // check if using iOS 5.0 or more
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        [DAAnisotropicImage startAnisotropicUpdatesWithHandler:^(UIImage *image)
         {
             [self.anisotropicSlider setThumbImage:image forState:UIControlStateNormal];
             [self.anisotropicSlider setThumbImage:image forState:UIControlStateHighlighted];
         }];
    }
    else
    {
        // normal slider
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64)) style:UITableViewStyleGrouped];
    self.myTableView.rowHeight = 44.0f;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.sectionFooterHeight = 10.0f;
    self.myTableView.sectionHeaderHeight = 10.0f;
    self.myTableView.separatorColor = [UIColor grayColor];
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

- (void)viewDidUnload
{
    self.workingWeight = nil;
    self.myTableView = nil;
    
    self.morphineStrength = nil;
    self.morphineStrengthDose = nil;
    self.morphineStrengthLabel = nil;
    self.morphineDoseLabel = nil;
    self.morphineDose2Label = nil;
    self.morphineRangeLabel = nil;
    self.dopamineStrength = nil;         // need to complete this
    self.dopamineStrengthDose = nil;
    self.dobutamineStrength = nil;
    self.dobutamineStrengthDose = nil;
    self.adrenalineStrength = nil;
    self.adrenalineStrengthDose = nil;
    self.atracuriumStrength = nil;
    self.atracuriumStrengthDose = nil;
    self.insulinStrength = nil;
    self.insulinStrengthDose = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"InfusionsViewController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"InfusionsViewController unloaded properties");
        
        self.workingWeight = nil;
        self.myTableView = nil;
        
        self.morphineStrength = nil;
        self.morphineStrengthDose = nil;
        self.morphineStrengthLabel = nil;
        self.morphineDoseLabel = nil;
        self.morphineDose2Label = nil;
        self.morphineRangeLabel = nil;
        self.dopamineStrength = nil;
        self.dopamineStrengthDose = nil;
        self.dobutamineStrength = nil;
        self.dobutamineStrengthDose = nil;
        self.adrenalineStrength = nil;
        self.adrenalineStrengthDose = nil;
        self.atracuriumStrength = nil;
        self.atracuriumStrengthDose = nil;
        self.insulinStrength = nil;
        self.insulinStrengthDose = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
#if GOOGLE_ANALYTICS
    
    [[GANTracker sharedTracker] trackPageview:@"Infusions" withError:nil];
    
#endif
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sections;
    
    if (self.workingWeight) 
    {
        sections = 10;
    }
    else 
    {
        sections = 7;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 1;
    
    if (!self.workingWeight) 
    {
        switch (section) 
        {
            case 1: // inotropes
                rows = 3;
                break;
                
            default:
                break;
        }
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 66;
    
    if (self.workingWeight) 
    {
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 8 || indexPath.section == 9)
        {
            height = 180.0f;
        }
        else if (indexPath.section == 4) 
        {
            height = 115.0f;
        }
        else 
        {
            height = 130.0f;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (self.workingWeight) 
    {
        switch (section) 
        {
            case 0:
                header = @"Sedation / Analgesia";
                break;
                
            case 1:
                header = @"Inotropes";
                break;
                
            case 4:
                header = @"Hepsal";
                break;
                
            case 5:
                header = NSLocalizedString(@"Hyperglycaemia", nil);
                break;
                
            case 6:
                header = @"Muscle relaxants";
                break;
                
            case 7:
                header = @"Seizures";
                break;
                
            case 9:
                header = @"Prostin";
                break;
                
            default:
                break;
        }
    }
    else 
    {
        switch (section) 
        {
            case 0:
                header = @"Sedation / Analgesia";
                break;
                
            case 1:
                header = @"Inotropes";
                break;
                
            case 2:
                header = @"Hepsal";
                break;
                
            case 3:
                header = NSLocalizedString(@"Hyperglycaemia", nil);
                break;
                
            case 4:
                header = @"Muscle relaxants";
                break;
                
            case 5:
                header = @"Seizures";
                break;
                
            case 6:
                header = @"Prostin";
                
            default:
                break;
        }
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 44.0f;
    
    if (self.workingWeight) 
    {
        if (section == 0)
        {
            height = 66.0f;
        }
        else if (section == 2 || section == 3 || section == 8) 
        {
            height = 0;
        }
    }
    else 
    {
        if (section == 0) 
        {
            height = 66.0f;
        }
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    /*
     if (section == 1)
     {
     if (([self.dopamineStrength isEqualToString:@"Double"] && [self.dobutamineStrength isEqualToString:@"Double"]) || ([self.dopamineStrength isEqualToString:@"Quad"] && [self.dobutamineStrength isEqualToString:@"Quad"]))
     {
     returnString = @"If using both Dopamine and Dobutamine, consider prescribing both in the same syringe to maximise parenteral nutrition volume";
     }
     }
     */
    
    if (self.workingWeight)
    {
        if (section == 9)
        {
            footer = [NSString stringWithFormat:@"Beware of %@ at doses above\n10 nanograms/kg/min", NSLocalizedString(@"apnoea", nil)];
        }
    }
    /*
     else 
     {
     if (section == 6)
     {
     footer = @"0.9% NaCl = 0.9% Sodium Chloride\n0.45% NaCL = 0.45% Sodium Chloride\n5%D = 5% Dextrose\n10%D = 10% Dextrose";
     }
     }
     */
    
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float footer = 0;
    
    /*
     if (section == 1)
     {
     if (([self.dopamineStrength isEqualToString:@"Double"] && [self.dobutamineStrength isEqualToString:@"Double"]) || ([self.dopamineStrength isEqualToString:@"Quad"] && [self.dobutamineStrength isEqualToString:@"Quad"]))
     {
     footer = 100;
     }
     }
     */
    if (self.workingWeight) 
    {
        if (section == 9)
        {
            footer = 100.0f;
        }
    }
    else 
    {
        if (section == 6)
        {
            footer = 100.0f;
        }
    }
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (self.workingWeight)
    {
        if (indexPath.section == 0)
        {
            static NSString *CellIdentifier = @"Morphine";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                [cell setBackgroundColor:[UIColor whiteColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.morphineDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.morphineDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.morphineDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.morphineDoseLabel.minimumFontSize = 12;
                self.morphineDoseLabel.backgroundColor = [UIColor clearColor];
                self.morphineDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.morphineStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.morphineStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.morphineStrengthLabel.textColor = [UIColor lightGrayColor];
                self.morphineStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.morphineStrengthLabel.minimumFontSize = 10;
                self.morphineStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.morphineDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.morphineDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.morphineDose2Label.textColor = [UIColor lightGrayColor];
                self.morphineDose2Label.backgroundColor = [UIColor clearColor];
                
                self.morphineRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                self.morphineRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.morphineRangeLabel.textColor = [UIColor lightGrayColor];
                self.morphineRangeLabel.backgroundColor = [UIColor clearColor];
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
                {
                    SVSegmentedControl *morphineStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", @"quad", nil]];
                    [morphineStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                    morphineStrength.crossFadeLabelsOnDrag = YES;
                    morphineStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                    morphineStrength.tag = 0;
                    
                    if ([self.morphineStrength isEqualToString:@"Single"])
                    {
                        morphineStrength.selectedIndex = 0;
                    }
                    else if ([self.morphineStrength isEqualToString:@"Double"])
                    {
                        morphineStrength.selectedIndex = 1;
                    }
                    else if ([self.morphineStrength isEqualToString:@"Quad"])
                    {
                        morphineStrength.selectedIndex = 2;
                    }
                    
                    morphineStrength.center = CGPointMake(160, 150);
                    
                    [cell addSubview:morphineStrength];
                }
                else 
                {
                    UISegmentedControl *morphineStrength = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"single", @"double", @"quad", nil]];
                    morphineStrength.frame = CGRectMake(0.0f, 0.0f, 240.0f, 30.0f);
                    morphineStrength.segmentedControlStyle = UISegmentedControlStyleBordered;
                    [morphineStrength addTarget:self action:@selector(standardSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                    morphineStrength.tag = 0;
                    
                    if ([self.morphineStrength isEqualToString:@"Single"])
                    {
                        morphineStrength.selectedSegmentIndex = 0;
                    }
                    else if ([self.morphineStrength isEqualToString:@"Double"])
                    {
                        morphineStrength.selectedSegmentIndex = 1;
                    }
                    else if ([self.morphineStrength isEqualToString:@"Quad"])
                    {
                        morphineStrength.selectedSegmentIndex = 2;
                    }
                    
                    morphineStrength.center = CGPointMake(160, 150);
                    
                    [cell addSubview:morphineStrength];
                }
            
                [cell addSubview:drug];
                [cell addSubview:self.morphineDoseLabel];
                [cell addSubview:self.morphineStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.morphineDose2Label];
                [cell addSubview:self.morphineRangeLabel];
                
                drug.text = @"MORPHINE";
                
                self.morphineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.morphineStrength, self.morphineStrengthDose];
                
                if ([self.morphineStrength isEqualToString:@"Double"] || [self.morphineStrength isEqualToString:@"Quad"]) 
                {
                    self.morphineStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float morphineDoseMilligrams;
                
                if ([self.morphineStrength isEqualToString:@"Single"])
                {
                    morphineDoseMilligrams = workingWeightKGasFloat;
                    self.morphineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/hr";
                    self.morphineRangeLabel.text = @"Range 0.25 - 2 ml/hr";
                }
                else if ([self.morphineStrength isEqualToString:@"Double"]) {
                    morphineDoseMilligrams = workingWeightKGasFloat * 2.0f;
                    self.morphineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/hr";
                    self.morphineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
                }
                else if ([self.morphineStrength isEqualToString:@"Quad"])
                {
                    morphineDoseMilligrams = workingWeightKGasFloat * 4.0f;
                    self.morphineDose2Label.text = @"1 ml/hr = 80 micrograms/kg/hr";
                    self.morphineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.morphineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:morphineDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"10% Dextrose (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 1)
        {
            static NSString *CellIdentifier = @"Dopamine";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.dopamineDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.dopamineDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.dopamineDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.dopamineDoseLabel.minimumFontSize = 12;
                self.dopamineDoseLabel.backgroundColor = [UIColor clearColor];
                self.dopamineDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.dopamineStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (20), 257, 20)];
                self.dopamineStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.dopamineStrengthLabel.textColor = [UIColor lightGrayColor];
                self.dopamineStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.dopamineStrengthLabel.minimumFontSize = 10;
                self.dopamineStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, (40), 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, (62), 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.dopamineDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, (83), 276, 20)];
                self.dopamineDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.dopamineDose2Label.textColor = [UIColor lightGrayColor];
                self.dopamineDose2Label.backgroundColor = [UIColor clearColor];
                
                self.dopamineRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (102), 276, 20)];
                self.dopamineRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.dopamineRangeLabel.textColor = [UIColor lightGrayColor];
                self.dopamineRangeLabel.backgroundColor = [UIColor clearColor];
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0)
                {
                    SVSegmentedControl *dopamineStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", @"quad", nil]];
                    [dopamineStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                    dopamineStrength.crossFadeLabelsOnDrag = YES;
                    dopamineStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                    dopamineStrength.tag = 1;
                    
                    if ([self.dopamineStrength isEqualToString:@"Single"])
                    {
                        dopamineStrength.selectedIndex = 0;
                    }
                    else if ([self.dopamineStrength isEqualToString:@"Double"])
                    {
                        dopamineStrength.selectedIndex = 1;
                    }
                    else if ([self.dopamineStrength isEqualToString:@"Quad"])
                    {
                        dopamineStrength.selectedIndex = 2;
                    }
                    
                    dopamineStrength.center = CGPointMake(160, 150);
                    
                    [cell addSubview:dopamineStrength];
                }
                else 
                {
                    UISegmentedControl *dopamineStrength = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"single", @"double", @"quad", nil]];
                    dopamineStrength.frame = CGRectMake(0.0f, 0.0f, 240.0f, 30.0f);
                    dopamineStrength.segmentedControlStyle = UISegmentedControlStyleBordered;
                    [dopamineStrength addTarget:self action:@selector(standardSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                    dopamineStrength.tag = 1;
                    
                    if ([self.dopamineStrength isEqualToString:@"Single"]) 
                    {
                        dopamineStrength.selectedSegmentIndex = 0;
                    }
                    else if ([self.dopamineStrength isEqualToString:@"Double"])
                    {
                        dopamineStrength.selectedSegmentIndex = 1;
                    }
                    else if ([self.dopamineStrength isEqualToString:@"Quad"])
                    {
                        dopamineStrength.selectedSegmentIndex = 2;
                    }
                    
                    dopamineStrength.center = CGPointMake(160, 150);
                    
                    [cell addSubview:dopamineStrength];
                }
                
                [cell addSubview:drug];
                [cell addSubview:self.dopamineDoseLabel];
                [cell addSubview:self.dopamineStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.dopamineDose2Label];
                [cell addSubview:self.dopamineRangeLabel];
                
                drug.text = @"DOPAMINE";
                
                self.dopamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dopamineStrength, self.dopamineStrengthDose];
                
                if ([self.dopamineStrength isEqualToString:@"Double"] || [self.dopamineStrength isEqualToString:@"Quad"]) 
                {
                    self.dopamineStrengthLabel.textColor = [UIColor redColor];
                }
                else 
                {
                    self.dopamineStrengthLabel.textColor = [UIColor blackColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float dopamineDoseMilligrams;
                
                if ([self.dopamineStrength isEqualToString:@"Single"])
                {
                    dopamineDoseMilligrams = workingWeightKGasFloat * 30.0f;
                    self.dopamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
                    self.dopamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
                }
                else if ([self.dopamineStrength isEqualToString:@"Double"]) 
                {
                    dopamineDoseMilligrams = workingWeightKGasFloat * 60.0f;
                    self.dopamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
                    self.dopamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
                }
                else if ([self.dopamineStrength isEqualToString:@"Quad"])
                {
                    dopamineDoseMilligrams = workingWeightKGasFloat * 120.0f;
                    self.dopamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
                    self.dopamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.dopamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dopamineDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"10% Dextrose (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 2)
        {
            static NSString *CellIdentifier = @"Dobutamine";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.dobutamineDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.dobutamineDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.dobutamineDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.dobutamineDoseLabel.minimumFontSize = 12;
                self.dobutamineDoseLabel.backgroundColor = [UIColor clearColor];
                self.dobutamineDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.dobutamineStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.dobutamineStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.dobutamineStrengthLabel.textColor = [UIColor lightGrayColor];
                self.dobutamineStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.dobutamineStrengthLabel.minimumFontSize = 10;
                self.dobutamineStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.dobutamineDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.dobutamineDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.dobutamineDose2Label.textColor = [UIColor lightGrayColor];
                self.dobutamineDose2Label.backgroundColor = [UIColor clearColor];
                
                self.dobutamineRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                self.dobutamineRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.dobutamineRangeLabel.textColor = [UIColor lightGrayColor];
                self.dobutamineRangeLabel.backgroundColor = [UIColor clearColor];
                
                SVSegmentedControl *dobutamineStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", @"quad", nil]];
                [dobutamineStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                
                dobutamineStrength.crossFadeLabelsOnDrag = YES;
                dobutamineStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                dobutamineStrength.tag = 2;
                
                if ([self.dobutamineStrength isEqualToString:@"Single"]) 
                {
                    dobutamineStrength.selectedIndex = 0;
                }
                else if ([self.dobutamineStrength isEqualToString:@"Double"])
                {
                    dobutamineStrength.selectedIndex = 1;
                }
                else if ([self.dobutamineStrength isEqualToString:@"Quad"])
                {
                    dobutamineStrength.selectedIndex = 2;
                }
                
                dobutamineStrength.center = CGPointMake(160, 150);
                
                [cell addSubview:drug];
                [cell addSubview:self.dobutamineDoseLabel];
                [cell addSubview:self.dobutamineStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.dobutamineDose2Label];
                [cell addSubview:self.dobutamineRangeLabel];
                [cell addSubview:dobutamineStrength];
                
                drug.text = @"DOBUTAMINE";
                
                self.dobutamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dobutamineStrength, self.dobutamineStrengthDose];
                
                if ([self.dobutamineStrength isEqualToString:@"Double"] || [self.dobutamineStrength isEqualToString:@"Quad"]) 
                {
                    self.dobutamineStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float dobutamineDoseMilligrams;
                
                if ([self.dobutamineStrength isEqualToString:@"Single"])
                {
                    dobutamineDoseMilligrams = workingWeightKGasFloat * 30;
                    self.dobutamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
                    self.dobutamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
                }
                else if ([self.dobutamineStrength isEqualToString:@"Double"]) {
                    dobutamineDoseMilligrams = workingWeightKGasFloat * 60;
                    self.dobutamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
                    self.dobutamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
                }
                else if ([self.dobutamineStrength isEqualToString:@"Quad"])
                {
                    dobutamineDoseMilligrams = workingWeightKGasFloat * 120;
                    self.dobutamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
                    self.dobutamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.dobutamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dobutamineDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"10% Dextrose (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 3)
        {
            static NSString *CellIdentifier = @"Adrenaline";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.adrenalineDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.adrenalineDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.adrenalineDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.adrenalineDoseLabel.minimumFontSize = 12;
                self.adrenalineDoseLabel.backgroundColor = [UIColor clearColor];
                self.adrenalineDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.adrenalineStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.adrenalineStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.adrenalineStrengthLabel.textColor = [UIColor lightGrayColor];
                self.adrenalineStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.adrenalineStrengthLabel.minimumFontSize = 10;
                self.adrenalineStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.adrenalineDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.adrenalineDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.adrenalineDose2Label.textColor = [UIColor lightGrayColor];
                self.adrenalineDose2Label.backgroundColor = [UIColor clearColor];
                
                self.adrenalineRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                self.adrenalineRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.adrenalineRangeLabel.textColor = [UIColor lightGrayColor];
                self.adrenalineRangeLabel.backgroundColor = [UIColor clearColor];
                
                SVSegmentedControl *adrenalineStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", nil]];
                [adrenalineStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                
                adrenalineStrength.crossFadeLabelsOnDrag = YES;
                adrenalineStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                adrenalineStrength.tag = 3;
                
                if ([self.adrenalineStrength isEqualToString:@"Single"]) 
                {
                    adrenalineStrength.selectedIndex = 0;
                }
                else if ([self.adrenalineStrength isEqualToString:@"Double"])
                {
                    adrenalineStrength.selectedIndex = 1;
                }
                
                adrenalineStrength.center = CGPointMake(160, 150);
                
                [cell addSubview:drug];
                [cell addSubview:self.adrenalineDoseLabel];
                [cell addSubview:self.adrenalineStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.adrenalineDose2Label];
                [cell addSubview:self.adrenalineRangeLabel];
                [cell addSubview:adrenalineStrength];
                
                drug.text = NSLocalizedString(@"ADRENALINE", nil);
                
                self.adrenalineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.adrenalineStrength, self.adrenalineStrengthDose];
                
                if ([self.adrenalineStrength isEqualToString:@"Single"])
                {
                    self.adrenalineStrengthLabel.textColor = [UIColor blackColor];
                }
                else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
                {
                    self.adrenalineStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float adrenalineDoseMilligrams;
                
                if ([self.adrenalineStrength isEqualToString:@"Single"])
                {
                    adrenalineDoseMilligrams = workingWeightKGasFloat * 3;
                    self.adrenalineDose2Label.text = @"1 ml/hr = 1 micrograms/kg/min";
                    self.adrenalineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
                }
                else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
                {
                    adrenalineDoseMilligrams = workingWeightKGasFloat * 6;
                    self.adrenalineDose2Label.text = @"1 ml/hr = 2 micrograms/kg/min";
                    self.adrenalineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                
                if (adrenalineDoseMilligrams <= 1) 
                {
                    formatter.maximumFractionDigits = 2;
                }
                else if (adrenalineDoseMilligrams > 1 && adrenalineDoseMilligrams <= 3)
                {
                    formatter.maximumFractionDigits = 2;
                    // round to nearest 0.05
                    // adrenalineDoseMilligrams = roundf(adrenalineDoseMilligrams * 20.0f)/20.0f;
                }
                else if (adrenalineDoseMilligrams > 3)
                {
                    formatter.maximumFractionDigits = 2;
                }
                
                self.adrenalineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:adrenalineDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"5% Dextrose (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 4)
        {
            static NSString *CellIdentifier = @"Hepsal";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                dose.font = [UIFont boldSystemFontOfSize:17.0];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.minimumFontSize = 12;
                dose.backgroundColor = [UIColor clearColor];
                dose.textAlignment = UITextAlignmentRight;
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 257, 20)]; // 40
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 47, 257, 20)]; // 62
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                UILabel *dose2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 68, 276, 20)]; // 83
                dose2.font = [UIFont systemFontOfSize:15.0];
                dose2.textColor = [UIColor lightGrayColor];
                dose2.backgroundColor = [UIColor clearColor];
                
                UILabel *range = [[UILabel alloc] initWithFrame:CGRectMake(20, 87, 276, 20)]; // 102
                range.font = [UIFont systemFontOfSize:15.0];
                range.textColor = [UIColor lightGrayColor];
                range.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:dose2];
                [cell addSubview:range];
                
                drug.text = @"HEPARIN";
                
                dose.text = @"50 Units";
                text.text = @"in";
                // diluent.text = @"0.9% Sodium Chloride (to 50 ml)";
                diluent.text = [NSString stringWithFormat:@"%@ (to 50 ml)", heparinDiluent];
                dose2.text = @"1 ml/hr = 1 Unit/hr";
                range.text = @"Range 0.5 - 1 ml/hr";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 5)
        {
            static NSString *CellIdentifier = @"Insulin";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.insulinDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.insulinDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.insulinDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.insulinDoseLabel.minimumFontSize = 12;
                self.insulinDoseLabel.backgroundColor = [UIColor clearColor];
                self.insulinDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.insulinStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.insulinStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.insulinStrengthLabel.textColor = [UIColor lightGrayColor];
                self.insulinStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.insulinStrengthLabel.minimumFontSize = 10;
                self.insulinStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.insulinDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.insulinDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.insulinDose2Label.textColor = [UIColor lightGrayColor];
                self.insulinDose2Label.backgroundColor = [UIColor clearColor];
                
                self.insulinRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                self.insulinRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.insulinRangeLabel.textColor = [UIColor lightGrayColor];
                self.insulinRangeLabel.backgroundColor = [UIColor clearColor];
                
                SVSegmentedControl *insulinStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", nil]];
                [insulinStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                
                insulinStrength.crossFadeLabelsOnDrag = YES;
                insulinStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                insulinStrength.tag = 5;
                
                if ([self.insulinStrength isEqualToString:@"Single"]) 
                {
                    insulinStrength.selectedIndex = 0;
                }
                else if ([self.insulinStrength isEqualToString:@"Double"])
                {
                    insulinStrength.selectedIndex = 1;
                }
                
                insulinStrength.center = CGPointMake(160, 150);
                
                [cell addSubview:drug];
                [cell addSubview:self.insulinDoseLabel];
                [cell addSubview:self.insulinStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.insulinDose2Label];
                [cell addSubview:self.insulinRangeLabel];
                [cell addSubview:insulinStrength];
                
                drug.text = @"INSULIN";
                
                self.insulinStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.insulinStrength, self.insulinStrengthDose];
                
                if ([self.insulinStrength isEqualToString:@"Double"] || [self.insulinStrength isEqualToString:@"Quad"]) 
                {
                    self.insulinStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float insulinDoseUnits;
                
                if ([self.insulinStrength isEqualToString:@"Single"])
                {
                    insulinDoseUnits = workingWeightKGasFloat * 10;
                    self.insulinDose2Label.text = @"1 ml/hr = 0.2 units/kg/hr";
                    self.insulinRangeLabel.text = @"Start at 0.25 - 0.5 ml/hr";
                }
                else if ([self.insulinStrength isEqualToString:@"Double"]) {
                    insulinDoseUnits = workingWeightKGasFloat * 20;
                    self.insulinDose2Label.text = @"1 ml/hr = 0.4 units/kg/hr";
                    self.insulinRangeLabel.text = @"Start at 0.12 - 0.25 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.insulinDoseLabel.text = [NSString stringWithFormat:@"%@ Units", [formatter stringFromNumber:[NSNumber numberWithFloat:insulinDoseUnits]]];
                
                text.text = @"in";
                diluent.text = @"0.9% Sodium Chloride (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 6)
        {
            static NSString *CellIdentifier = @"Atracurium";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.atracuriumDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.atracuriumDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.atracuriumDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.atracuriumDoseLabel.minimumFontSize = 12;
                self.atracuriumDoseLabel.backgroundColor = [UIColor clearColor];
                self.atracuriumDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.atracuriumStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.atracuriumStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.atracuriumStrengthLabel.textColor = [UIColor lightGrayColor];
                self.atracuriumStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.atracuriumStrengthLabel.minimumFontSize = 10;
                self.atracuriumStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.atracuriumDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.atracuriumDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.atracuriumDose2Label.textColor = [UIColor lightGrayColor];
                self.atracuriumDose2Label.backgroundColor = [UIColor clearColor];
                
                self.atracuriumRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                self.atracuriumRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.atracuriumRangeLabel.textColor = [UIColor lightGrayColor];
                self.atracuriumRangeLabel.backgroundColor = [UIColor clearColor];
                
                SVSegmentedControl *atracuriumStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", nil]];
                [atracuriumStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                
                atracuriumStrength.crossFadeLabelsOnDrag = YES;
                atracuriumStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                atracuriumStrength.tag = 6;
                
                if ([self.atracuriumStrength isEqualToString:@"Single"]) 
                {
                    atracuriumStrength.selectedIndex = 0;
                }
                else if ([self.atracuriumStrength isEqualToString:@"Double"])
                {
                    atracuriumStrength.selectedIndex = 1;
                }
                
                atracuriumStrength.center = CGPointMake(160, 150);
                
                [cell addSubview:drug];
                [cell addSubview:self.atracuriumDoseLabel];
                [cell addSubview:self.atracuriumStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.atracuriumDose2Label];
                [cell addSubview:self.atracuriumRangeLabel];
                [cell addSubview:atracuriumStrength];
                
                drug.text = @"ATRACURIUM";
                
                self.atracuriumStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.atracuriumStrength, self.atracuriumStrengthDose];
                
                if ([self.atracuriumStrength isEqualToString:@"Single"])
                {
                    self.atracuriumStrengthLabel.textColor = [UIColor blackColor];
                }
                else if ([self.atracuriumStrength isEqualToString:@"Double"] || [self.atracuriumStrength isEqualToString:@"Quad"]) 
                {
                    self.atracuriumStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float atracuriumDoseMilligrams;
                
                if ([self.atracuriumStrength isEqualToString:@"Single"])
                {
                    atracuriumDoseMilligrams = workingWeightKGasFloat * 60;
                    self.atracuriumDose2Label.text = @"1 ml/hr = 1.2 mg/kg/hr";
                    self.atracuriumRangeLabel.text = @"Range 0.25 - 1 ml/hr";
                }
                else if ([self.atracuriumStrength isEqualToString:@"Double"]) {
                    atracuriumDoseMilligrams = workingWeightKGasFloat * 120;
                    self.atracuriumDose2Label.text = @"1 ml/hr = 2.4 mg/kg/hr";
                    self.atracuriumRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.atracuriumDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:atracuriumDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"0.9% Sodium Chloride (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 7)
        {
            static NSString *CellIdentifier = @"Lidocaine";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                dose.font = [UIFont boldSystemFontOfSize:17.0];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.minimumFontSize = 12;
                dose.backgroundColor = [UIColor clearColor];
                dose.textAlignment = UITextAlignmentRight;
                
                UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                strength.font = [UIFont systemFontOfSize:15];
                strength.textColor = [UIColor lightGrayColor];
                strength.adjustsFontSizeToFitWidth = YES;
                strength.minimumFontSize = 10;
                strength.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                UILabel *dose2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                dose2.font = [UIFont systemFontOfSize:15.0];
                dose2.textColor = [UIColor lightGrayColor];
                dose2.backgroundColor = [UIColor clearColor];
                
                UILabel *range = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 276, 20)];
                range.font = [UIFont systemFontOfSize:15.0];
                range.textColor = [UIColor lightGrayColor];
                range.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:strength];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:dose2];
                [cell addSubview:range];
                
                drug.text = @"LIDOCAINE";
                
                strength.text = [NSString stringWithFormat:@"%@ strength (%@)", lidocaineStrength, lidocaineStrengthDose];
                
                if ([lidocaineStrength isEqualToString:@"Single"])
                {
                    strength.textColor = [UIColor blackColor];
                }
                else if ([lidocaineStrength isEqualToString:@"Double"]) 
                {
                    strength.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float lidocaineDoseMilligrams;
                
                if ([lidocaineStrength isEqualToString:@"Single"])
                {
                    lidocaineDoseMilligrams = workingWeightKGasFloat * 100;
                    dose2.text = @"1 ml/hr = 2 mg/kg/hr";
                    range.text = @"Range 1 - 3 ml/hr";
                }
                else if ([lidocaineStrength isEqualToString:@"Double"]) 
                {
                    lidocaineDoseMilligrams = workingWeightKGasFloat * 200;
                    dose2.text = @"1 ml/hr = 4 mg/kg/hr";
                    range.text = @"Range 0.5 - 1.5 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                
                if (lidocaineDoseMilligrams <= 1) 
                {
                    formatter.maximumFractionDigits = 2;
                }
                else if (lidocaineDoseMilligrams > 1 && lidocaineDoseMilligrams <= 3)
                {
                    formatter.maximumFractionDigits = 2;
                    // round to nearest 0.05
                    // lidocaineDoseMilligrams = roundf(lidocaineDoseMilligrams * 20.0f)/20.0f;
                }
                else if (lidocaineDoseMilligrams > 3)
                {
                    formatter.maximumFractionDigits = 1;
                }
                
                dose.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:lidocaineDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"5% Dextrose (to 50 ml)";
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 8)
        {
            static NSString *CellIdentifier = @"Midazolam";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                self.midazolamDoseLabel = [[UILabel alloc] initWithFrame:CGRectMake(172, 2, 124, 22)];
                self.midazolamDoseLabel.font = [UIFont boldSystemFontOfSize:17.0];
                self.midazolamDoseLabel.adjustsFontSizeToFitWidth = YES;
                self.midazolamDoseLabel.minimumFontSize = 12;
                self.midazolamDoseLabel.backgroundColor = [UIColor clearColor];
                self.midazolamDoseLabel.textAlignment = UITextAlignmentRight;
                
                self.midazolamStrengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 257, 20)];
                self.midazolamStrengthLabel.font = [UIFont systemFontOfSize:15];
                self.midazolamStrengthLabel.textColor = [UIColor lightGrayColor];
                self.midazolamStrengthLabel.adjustsFontSizeToFitWidth = YES;
                self.midazolamStrengthLabel.minimumFontSize = 10;
                self.midazolamStrengthLabel.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 257, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 257, 20)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                self.midazolamDose2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 276, 20)];
                self.midazolamDose2Label.font = [UIFont systemFontOfSize:15.0];
                self.midazolamDose2Label.textColor = [UIColor lightGrayColor];
                self.midazolamDose2Label.backgroundColor = [UIColor clearColor];
                
                self.midazolamRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 102.0f, 276.0f, 20.0f)];
                self.midazolamRangeLabel.font = [UIFont systemFontOfSize:15.0];
                self.midazolamRangeLabel.textColor = [UIColor lightGrayColor];
                self.midazolamRangeLabel.backgroundColor = [UIColor clearColor];
                
                SVSegmentedControl *midazolamStrength = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"single", @"double", nil]];
                [midazolamStrength addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
                
                midazolamStrength.crossFadeLabelsOnDrag = YES;
                midazolamStrength.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
                midazolamStrength.tag = 8;
                
                if ([self.morphineStrength isEqualToString:@"Single"]) 
                {
                    midazolamStrength.selectedIndex = 0;
                }
                else if ([self.morphineStrength isEqualToString:@"Double"])
                {
                    midazolamStrength.selectedIndex = 1;
                }
                
                midazolamStrength.center = CGPointMake(160, 150);
                
                [cell addSubview:drug];
                [cell addSubview:self.midazolamDoseLabel];
                [cell addSubview:self.midazolamStrengthLabel];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:self.midazolamDose2Label];
                [cell addSubview:self.midazolamRangeLabel];
                [cell addSubview:midazolamStrength];
                
                drug.text = @"MIDAZOLAM";
                
                self.midazolamStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.midazolamStrength, self.midazolamStrengthDose];
                
                if ([self.midazolamStrength isEqualToString:@"Double"]) 
                {
                    self.midazolamStrengthLabel.textColor = [UIColor redColor];
                }
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                float midazolamDoseMilligrams;
                
                if ([self.midazolamStrength isEqualToString:@"Single"])
                {
                    midazolamDoseMilligrams = workingWeightKGasFloat * 10;
                    self.midazolamDose2Label.text = @"1 ml/hr = 200 micrograms/kg/hr";
                    self.midazolamRangeLabel.text = @"Range 0.3 - 1.5 ml/hr";
                }
                else if ([self.midazolamStrength isEqualToString:@"Double"]) {
                    midazolamDoseMilligrams = workingWeightKGasFloat * 20;
                    self.midazolamDose2Label.text = @"1 ml/hr = 400 micrograms/kg/hr";
                    self.midazolamRangeLabel.text = @"Range 0.15 - 0.75 ml/hr";
                }
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 2;
                
                self.midazolamDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:midazolamDoseMilligrams]]];
                
                text.text = @"in";
                diluent.text = @"10% Dextrose (to 50 ml)";
                
            }
            
            returnCell = cell;
        }
        else if (indexPath.section == 9)
        {
            static NSString *CellIdentifier = @"Prostin";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 2.0f, 144.0f, 22.0f)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *dose = [[UILabel alloc] initWithFrame:CGRectMake(172.0f, 2.0f, 124.0f, 22.0f)];
                dose.font = [UIFont boldSystemFontOfSize:17.0];
                dose.adjustsFontSizeToFitWidth = YES;
                dose.minimumFontSize = 12;
                dose.backgroundColor = [UIColor clearColor];
                dose.textAlignment = UITextAlignmentRight;
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 25.0f, 257.0f, 20.0f)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                UILabel *diluent = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 47.0f, 257.0f, 20.0f)];
                diluent.font = [UIFont boldSystemFontOfSize:17.0f];
                diluent.textColor = [UIColor blackColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                diluent.minimumFontSize = 10.0f;
                diluent.backgroundColor = [UIColor clearColor];
                diluent.adjustsFontSizeToFitWidth = YES;
                
                UILabel *dose2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 68.0f, 276.0f, 20.0f)];
                dose2.font = [UIFont systemFontOfSize:15.0f];
                dose2.textColor = [UIColor lightGrayColor];
                dose2.backgroundColor = [UIColor clearColor];
                dose2.adjustsFontSizeToFitWidth = YES;
                
                UILabel *range = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 87.0f, 276.0f, 20.0f)];
                range.font = [UIFont systemFontOfSize:15.0f];
                range.textColor = [UIColor lightGrayColor];
                range.backgroundColor = [UIColor clearColor];
                
                self.prostinDose3Label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 106.0f, 276.0f, 20.0f)];
                self.prostinDose3Label.font = [UIFont boldSystemFontOfSize:15.0f];
                self.prostinDose3Label.textColor = [UIColor blackColor];
                self.prostinDose3Label.backgroundColor = [UIColor clearColor];
                self.prostinDose3Label.adjustsFontSizeToFitWidth = YES;
                
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
                {
                    
                     self.anisotropicSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 140.0f, 280.0f, 40.0f)];
                     self.anisotropicSlider.minimumValue = 1.0f;
                     self.anisotropicSlider.maximumValue = 50.0f;
                     self.anisotropicSlider.value = 1.0f;
                     [self.anisotropicSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                     self.anisotropicSlider.continuous = YES;
                     
                     UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                     UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                     [self.anisotropicSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
                     [self.anisotropicSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
                     
                     UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
                     [self.anisotropicSlider setThumbImage:initialImage forState:UIControlStateNormal];
                     [self.anisotropicSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
                     
                     [cell addSubview:self.anisotropicSlider];
                
                }
                else 
                {
                    self.normalSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 140.0f, 280.0f, 40.0f)];
                    self.normalSlider.minimumValue = 1.0f;
                    self.normalSlider.maximumValue = 50.0f;
                    self.normalSlider.value = 1.0f;
                    [self.normalSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.normalSlider.continuous = YES;
                    
                    [cell addSubview:self.normalSlider];
                }
                
                [cell addSubview:drug];
                [cell addSubview:dose];
                [cell addSubview:text];
                [cell addSubview:diluent];
                [cell addSubview:dose2];
                [cell addSubview:range];
                [cell addSubview:self.prostinDose3Label];
                
                drug.text = @"DINOPROSTONE";
                
                float workingWeightKGasFloat = [self.workingWeight floatValue];
                
                // ie 1 ml/hr = x nanograms/kg/min at above weight
                float prostinDoseNanogramsPerKgPerMinuteAtOneMlPerHour = (1.0f / (0.06f * workingWeightKGasFloat));
                
                NSNumberFormatter *formatter1 = [[NSNumberFormatter alloc] init];
                formatter1.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter1.numberStyle = NSNumberFormatterDecimalStyle;
                formatter1.minimumFractionDigits = 0;
                formatter1.maximumFractionDigits = 1;
                
                dose2.text = [NSString stringWithFormat:@"1 ml/hr = %@ nanograms/kg/min", [formatter1 stringFromNumber:[NSNumber numberWithFloat:prostinDoseNanogramsPerKgPerMinuteAtOneMlPerHour]]];
                
                // next slider values
                float prostinDoseNanogramsPerKilogramPerMinute = roundf(self.anisotropicSlider.value);
                
                float prostinRate = (0.06f * workingWeightKGasFloat * prostinDoseNanogramsPerKilogramPerMinute);
                
                NSNumberFormatter *formatter2 = [[NSNumberFormatter alloc] init];
                formatter2.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter2.numberStyle = NSNumberFormatterDecimalStyle;
                formatter2.minimumFractionDigits = 0;
                formatter2.maximumFractionDigits = 2;
                
                NSString *prostingRateAsRoundedString = [formatter2 stringFromNumber:[NSNumber numberWithFloat:prostinRate]];
                
                self.prostinDose3Label.text = [NSString stringWithFormat:@"%.0f nanograms/kg/min = %@ ml/hr", prostinDoseNanogramsPerKilogramPerMinute, prostingRateAsRoundedString]; 
                
                dose.text = @"50 micrograms";
                text.text = @"in";
                diluent.text = @"5% Dextrose (to 50 ml)";
                range.text = @"Range 5 - 50 nanograms/kg/min";
            }
            
            returnCell = cell;
        }
    }
    else 
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) 
            {
                static NSString *CellIdentifier = @"Morphine";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Morphine", nil);
                    strength.text = @"1 mg/kg in 50 ml 10% Dextrose";
                    text.text = @"1 ml/hr = 20 micrograms/kg/hour";
                }
                
                returnCell = cell;
            }
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0) 
            {
                static NSString *CellIdentifier = @"Dopamine";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Dopamine", nil);
                    strength.text = @"30 mg/kg in 50 ml 10% Dextrose";
                    text.text = @"1 ml/hr = 10 micrograms/kg/minute";
                }
                
                returnCell = cell;
            }
            else if (indexPath.row == 1) 
            {
                static NSString *CellIdentifier = @"Dobutamine";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Dobutamine", nil);
                    strength.text = @"30 mg/kg in 50 ml 10% Dextrose";
                    text.text = @"1 ml/hr = 10 micrograms/kg/minute";
                }
                
                returnCell = cell;
            }
            else if (indexPath.row == 2)
            {
                static NSString *CellIdentifier = @"Adrenaline";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Adrenaline", nil);
                    strength.text = @"3 mg/kg in 50 ml 5% Dextrose";
                    text.text = @"1 ml/hr = 1 microgram/kg/minute";
                }
                
                returnCell = cell;
            }
        }
        if (indexPath.section == 2)
        {
            if (indexPath.row == 0) 
            {
                static NSString *CellIdentifier = @"Hepsal";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Heparin", nil);
                    strength.text = @"50 Units in 50 mls 0.9% Sodium Chloride";
                    text.text = @"0.5 - 1 ml/hr";
                }
                
                returnCell = cell;
            }
        }
        if (indexPath.section == 3)
        {
            static NSString *CellIdentifier = @"Insulin";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                strength.font = [UIFont systemFontOfSize:15];
                strength.textColor = [UIColor lightGrayColor];
                strength.adjustsFontSizeToFitWidth = YES;
                strength.minimumFontSize = 10;
                strength.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:strength];
                [cell addSubview:text];
                
                drug.text = NSLocalizedString(@"Insulin", nil);
                strength.text = @"10 Units/kg in 50 ml 0.9% Sodium Chloride";
                text.text = @"1 ml/hr = 0.2 Units/kg/hour";
            }
            
            returnCell = cell;
        }
        if (indexPath.section == 4)
        {
            if (indexPath.row == 0) 
            {
                static NSString *CellIdentifier = @"Atracurium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Atracurium", nil);
                    strength.text = @"60 mg/kg in 50 ml 0.9% Sodium Chloride";
                    text.text = @"1 ml/hr = 1.2 mg/kg/hour";
                }
                
                returnCell = cell;
            }
            else if (indexPath.row == 1)
            {
                static NSString *CellIdentifier = @"Pancuronium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Pancuronium", nil);
                    strength.text = @"";
                    text.text = @"";
                }
                
                returnCell = cell;
            }
            else if (indexPath.row == 2)
            {
                static NSString *CellIdentifier = @"Rocuronium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Rocuronium", nil);
                }
                
                returnCell = cell;
            }
            else if (indexPath.row == 3)
            {
                static NSString *CellIdentifier = @"Vecuronium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Vecuronium", nil);
                }
                
                returnCell = cell;
            }
        }
        if (indexPath.section == 5)
        {
            if (indexPath.row == 0)
            {
                static NSString *CellIdentifier = @"Midazolam";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                    drug.font = [UIFont boldSystemFontOfSize:17.0];
                    drug.adjustsFontSizeToFitWidth = YES;
                    drug.textColor = [UIColor blackColor];
                    drug.backgroundColor = [UIColor clearColor];
                    
                    UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                    strength.font = [UIFont systemFontOfSize:15];
                    strength.textColor = [UIColor lightGrayColor];
                    strength.adjustsFontSizeToFitWidth = YES;
                    strength.minimumFontSize = 10;
                    strength.backgroundColor = [UIColor clearColor];
                    
                    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                    text.font = [UIFont systemFontOfSize:15.0];
                    text.textColor = [UIColor lightGrayColor];
                    text.adjustsFontSizeToFitWidth = YES;
                    text.minimumFontSize = 10.0;
                    text.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:drug];
                    [cell addSubview:strength];
                    [cell addSubview:text];
                    
                    drug.text = NSLocalizedString(@"Midazolam", nil);
                    strength.text = @"10 mg/kg in 50 ml of 10% Dextrose";
                    text.text = @"1 ml/hr = 200 micrograms/kg/hour";
                }
                
                returnCell = cell;
            }
        }
        if (indexPath.section == 6)
        {
            static NSString *CellIdentifier = @"Prostin";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                UILabel *drug = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 144, 22)];
                drug.font = [UIFont boldSystemFontOfSize:17.0];
                drug.adjustsFontSizeToFitWidth = YES;
                drug.textColor = [UIColor blackColor];
                drug.backgroundColor = [UIColor clearColor];
                
                UILabel *strength = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, CELL_WIDTH_FOR_TEXT, 20)];
                strength.font = [UIFont systemFontOfSize:15];
                strength.textColor = [UIColor lightGrayColor];
                strength.adjustsFontSizeToFitWidth = YES;
                strength.minimumFontSize = 10;
                strength.backgroundColor = [UIColor clearColor];
                
                UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, CELL_WIDTH_FOR_TEXT, 20)];
                text.font = [UIFont systemFontOfSize:15.0];
                text.textColor = [UIColor lightGrayColor];
                text.adjustsFontSizeToFitWidth = YES;
                text.minimumFontSize = 10.0;
                text.backgroundColor = [UIColor clearColor];
                
                [cell addSubview:drug];
                [cell addSubview:strength];
                [cell addSubview:text];
                
                drug.text = NSLocalizedString(@"Dinoprostone", nil);
                strength.text = @"50 micrograms in 50 mls 5% Dextrose";
                text.text = @"ml/hr = 0.06 x kg x dose (nanograms/kg/minute)";
            }
            
            returnCell = cell;
        }
    }
    
    return returnCell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = nil;
    
    /*
     if (self.workingWeight)
     {
     if (indexPath.section == 0)
     {
     path = indexPath;
     }
     }
     else 
     {
     if (indexPath.section == 0)
     {
     path = indexPath;
     }
     }
     */
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)standardSegmentedControlChangedValue:(UISegmentedControl*)segmentedControl 
{
    if (segmentedControl.tag == 0)      // morphine
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.morphineStrength = @"Single";
                self.morphineStrengthDose = @"1 mg/kg";
                break;
                
            case 1:
                self.morphineStrength = @"Double";
                self.morphineStrengthDose = @"2 mg/kg";
                break;
                
            case 2:
                self.morphineStrength = @"Quad";
                self.morphineStrengthDose = @"4 mg/kg";
                break;
                
            default:
                break;
        }
        
        self.morphineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.morphineStrength, self.morphineStrengthDose];
        
        if ([self.morphineStrength isEqualToString:@"Double"] || [self.morphineStrength isEqualToString:@"Quad"]) 
        {
            self.morphineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.morphineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float morphineDoseMilligrams;
        
        if ([self.morphineStrength isEqualToString:@"Single"])
        {
            morphineDoseMilligrams = workingWeightKGasFloat;
            self.morphineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.25 - 2 ml/hr";
        }
        else if ([self.morphineStrength isEqualToString:@"Double"]) 
        {
            morphineDoseMilligrams = workingWeightKGasFloat * 2;
            self.morphineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((morphineDoseMilligrams / 50) > 0.4) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(morphineDoseMilligrams / 50)]]];
                
                if (!morphineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n0.4 mg/ml.\n(although higher concentrations have been used)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    morphineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.4 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.morphineStrength isEqualToString:@"Quad"])
        {
            morphineDoseMilligrams = workingWeightKGasFloat * 4;
            self.morphineDose2Label.text = @"1 ml/hr = 80 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((morphineDoseMilligrams / 50) > 0.4) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(morphineDoseMilligrams / 50)]]];
                
                if (!morphineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n0.4 mg/ml.\n(although higher concentrations have been used)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    morphineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.4 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.morphineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:morphineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 1) // dopamine
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.dopamineStrength = @"Single";
                self.dopamineStrengthDose = @"30 mg/kg";
                break;
                
            case 1:
                self.dopamineStrength = @"Double";
                self.dopamineStrengthDose = @"60 mg/kg";
                
                break;
                
            case 2:
                self.dopamineStrength = @"Quad";
                self.dopamineStrengthDose = @"120 mg/kg";
                
                break;
                
            default:
                break;
        }
        
        self.dopamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dopamineStrength, self.dopamineStrengthDose];
        
        if ([self.dopamineStrength isEqualToString:@"Double"] || [self.dopamineStrength isEqualToString:@"Quad"]) 
        {
            self.dopamineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.dopamineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float dopamineDoseMilligrams;
        
        if ([self.dopamineStrength isEqualToString:@"Single"])
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 30.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
        }
        else if ([self.dopamineStrength isEqualToString:@"Double"]) 
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 60.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((dopamineDoseMilligrams / 50) > 3.2) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dopamineDoseMilligrams / 50)]]];
                
                if (!dopamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n3.2 mg/ml.\n(Can be used more concentrated in fluid restricted patients and always via a central line)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dopamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 3.2 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.dopamineStrength isEqualToString:@"Quad"])
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 120.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((dopamineDoseMilligrams / 50) > 3.2) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dopamineDoseMilligrams / 50)]]];
                
                if (!dopamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n3.2 mg/ml.\n(Can be used more concentrated in fluid restricted patients and always via a central line)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dopamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!"
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 3.2 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.dopamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dopamineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 2) // dobutamine
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.dobutamineStrength = @"Single";
                self.dobutamineStrengthDose = @"30mg/kg";
                break;
                
            case 1:
                self.dobutamineStrength = @"Double";
                self.dobutamineStrengthDose = @"60mg/kg";
                break;
                
            case 2:
                self.dobutamineStrength = @"Quad";
                self.dobutamineStrengthDose = @"120mg/kg";
                break;
                
            default:
                break;
        }
        
        self.dobutamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dobutamineStrength, self.dobutamineStrengthDose];
        
        if ([self.dobutamineStrength isEqualToString:@"Double"] || [self.dobutamineStrength isEqualToString:@"Quad"]) 
        {
            self.dobutamineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.dobutamineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float dobutamineDoseMilligrams;
        
        if ([self.dobutamineStrength isEqualToString:@"Single"])
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 30;
            self.dobutamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
        }
        else if ([self.dobutamineStrength isEqualToString:@"Double"]) 
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 60;
            self.dobutamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((dobutamineDoseMilligrams / 50) > 5) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dobutamineDoseMilligrams / 50)]]];
                
                if (!dobutamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n5.0 mg/ml.\n(Concentrations up to 10 mg/ml have been used centrally)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dobutamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.dobutamineStrength isEqualToString:@"Quad"])
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 120;
            self.dobutamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((dobutamineDoseMilligrams / 50) > 5) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dobutamineDoseMilligrams / 50)]]];
                
                if (!dobutamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n5.0 mg/ml.\n(Concentrations up to 10 mg/ml have been used centrally)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dobutamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.dobutamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dobutamineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 3) // adrenaline
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.adrenalineStrength = @"Single";
                self.adrenalineStrengthDose = @"3 mg/kg";
                break;
                
            case 1:
                self.adrenalineStrength = @"Double";
                self.adrenalineStrengthDose = @"6 mg/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.adrenalineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.adrenalineStrength, self.adrenalineStrengthDose];
            
            if ([self.adrenalineStrength isEqualToString:@"Single"])
            {
                self.adrenalineStrengthLabel.textColor = [UIColor blackColor];
            }
            else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
            {
                self.adrenalineStrengthLabel.textColor = [UIColor redColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float adrenalineDoseMilligrams;
            
            if ([self.adrenalineStrength isEqualToString:@"Single"])
            {
                adrenalineDoseMilligrams = workingWeightKGasFloat * 3;
                self.adrenalineDose2Label.text = @"1 ml/hr = 1 micrograms/kg/min";
                self.adrenalineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            }
            else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
            {
                adrenalineDoseMilligrams = workingWeightKGasFloat * 6;
                self.adrenalineDose2Label.text = @"1 ml/hr = 2 micrograms/kg/min";
                self.adrenalineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                
                if ((adrenalineDoseMilligrams / 50) > 0.32) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:(adrenalineDoseMilligrams / 50)]]];
                    
                    if (!adrenalineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:[NSString stringWithFormat:@"%@ - CAUTION!", NSLocalizedString(@"ADRENALINE", nil)]
                                                  message:@"Final concentration exceeds\n0.32 mg/ml.\n(Can be used more concentrated, or even neat, in fluid restricted patients and always via a central line)"
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        adrenalineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:[NSString stringWithFormat:@"%@ - CAUTION!", NSLocalizedString(@"ADRENALINE", nil)] 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.32 mg/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.adrenalineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:adrenalineDoseMilligrams]]];
        }
    }
    else if (segmentedControl.tag == 5) // insulin
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.insulinStrength = @"Single";
                self.insulinStrengthDose = @"10 units/kg";
                break;
                
            case 1:
                self.insulinStrength = @"Double";
                self.insulinStrengthDose = @"20 units/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.insulinStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.insulinStrength, self.insulinStrengthDose];
            
            if ([self.insulinStrength isEqualToString:@"Double"] || [self.insulinStrength isEqualToString:@"Quad"]) 
            {
                self.insulinStrengthLabel.textColor = [UIColor redColor];
            }
            else 
            {
                self.insulinStrengthLabel.textColor = [UIColor blackColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float insulinDoseUnits;
            
            if ([self.insulinStrength isEqualToString:@"Single"])
            {
                insulinDoseUnits = workingWeightKGasFloat * 10;
                self.insulinDose2Label.text = @"1 ml/hr = 0.2 units/kg/hr";
                self.insulinRangeLabel.text = @"Start at 0.25 - 0.5 ml/hr";
            }
            else if ([self.insulinStrength isEqualToString:@"Double"]) {
                insulinDoseUnits = workingWeightKGasFloat * 20;
                self.insulinDose2Label.text = @"1 ml/hr = 0.4 units/kg/hr";
                self.insulinRangeLabel.text = @"Start at 0.12 - 0.25 ml/hr";
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.insulinDoseLabel.text = [NSString stringWithFormat:@"%@ Units", [formatter stringFromNumber:[NSNumber numberWithFloat:insulinDoseUnits]]];
        }
    }
    else if (segmentedControl.tag == 6) // atracurium
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.atracuriumStrength = @"Single";
                self.atracuriumStrengthDose = @"60 mg/kg";
                break;
                
            case 1:
                self.atracuriumStrength = @"Double";
                self.atracuriumStrengthDose = @"120 mg/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.atracuriumStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.atracuriumStrength, self.atracuriumStrengthDose];
            
            if ([self.atracuriumStrength isEqualToString:@"Single"])
            {
                self.atracuriumStrengthLabel.textColor = [UIColor blackColor];
            }
            else if ([self.atracuriumStrength isEqualToString:@"Double"]) 
            {
                self.atracuriumStrengthLabel.textColor = [UIColor redColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float atracuriumDoseMilligrams;
            
            if ([self.atracuriumStrength isEqualToString:@"Single"])
            {
                atracuriumDoseMilligrams = workingWeightKGasFloat * 60;
                self.atracuriumDose2Label.text = @"1 ml/hr = 1.2 mg/kg/hr";
                self.atracuriumRangeLabel.text = @"Range 0.25 - 1 ml/hr";
                
                if ((atracuriumDoseMilligrams / 50) < 0.5) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(atracuriumDoseMilligrams / 50)]]];
                    
                    if (!dobutamineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:@"Final concentration below\n500 micrograms/ml."
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        dobutamineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(< 500 micrograms/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            else if ([self.atracuriumStrength isEqualToString:@"Double"]) {
                atracuriumDoseMilligrams = workingWeightKGasFloat * 120;
                self.atracuriumDose2Label.text = @"1 ml/hr = 2.4 mg/kg/hr";
                self.atracuriumRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                
                if ((atracuriumDoseMilligrams / 50) > 5) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(atracuriumDoseMilligrams / 50)]]];
                    
                    if (!dobutamineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:@"Final concentration exceeds\n5.0 mg/ml."
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        dobutamineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.atracuriumDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:atracuriumDoseMilligrams]]];
        }
    }
    else if (segmentedControl.tag == 8) // midazolam
    {
        switch (segmentedControl.selectedSegmentIndex)
        {
            case 0:
                self.midazolamStrength = @"Single";
                self.midazolamStrengthDose = @"10 mg/kg";
                break;
                
            case 1:
                self.midazolamStrength = @"Double";
                self.midazolamStrengthDose = @"20 mg/kg";
                break;
                
            default:
                break;
        }
        
        self.midazolamStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.midazolamStrength, self.midazolamStrengthDose];
        
        if ([self.midazolamStrength isEqualToString:@"Double"]) 
        {
            self.midazolamStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.midazolamStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float midazolamDoseMilligrams;
        
        if ([self.midazolamStrength isEqualToString:@"Single"])
        {
            midazolamDoseMilligrams = workingWeightKGasFloat * 10.0f;
            self.midazolamDose2Label.text = @"1 ml/hr = 200 micrograms/kg/hr";
            self.midazolamRangeLabel.text = @"Range 0.3 - 1.5 ml/hr";
        }
        else if ([self.midazolamStrength isEqualToString:@"Double"]) {
            midazolamDoseMilligrams = workingWeightKGasFloat * 20.0f;
            self.midazolamDose2Label.text = @"1 ml/hr = 400 micrograms/kg/hr";
            self.midazolamRangeLabel.text = @"Range 0.15 - 0.75 ml/hr";
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.midazolamDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:midazolamDoseMilligrams]]];
    }
}

#pragma mark - SPSegmentedControl

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl 
{
    if (segmentedControl.tag == 0)      // morphine
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.morphineStrength = @"Single";
                self.morphineStrengthDose = @"1 mg/kg";
                break;
                
            case 1:
                self.morphineStrength = @"Double";
                self.morphineStrengthDose = @"2 mg/kg";
                break;
                
            case 2:
                self.morphineStrength = @"Quad";
                self.morphineStrengthDose = @"4 mg/kg";
                break;
                
            default:
                break;
        }
        
        self.morphineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.morphineStrength, self.morphineStrengthDose];
        
        if ([self.morphineStrength isEqualToString:@"Double"] || [self.morphineStrength isEqualToString:@"Quad"]) 
        {
            self.morphineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.morphineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float morphineDoseMilligrams;
        
        if ([self.morphineStrength isEqualToString:@"Single"])
        {
            morphineDoseMilligrams = workingWeightKGasFloat;
            self.morphineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.25 - 2 ml/hr";
        }
        else if ([self.morphineStrength isEqualToString:@"Double"]) 
        {
            morphineDoseMilligrams = workingWeightKGasFloat * 2;
            self.morphineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((morphineDoseMilligrams / 50) > 0.4) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(morphineDoseMilligrams / 50)]]];
                
                if (!morphineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n0.4 mg/ml.\n(although higher concentrations have been used)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    morphineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.4 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.morphineStrength isEqualToString:@"Quad"])
        {
            morphineDoseMilligrams = workingWeightKGasFloat * 4;
            self.morphineDose2Label.text = @"1 ml/hr = 80 micrograms/kg/hr";
            self.morphineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((morphineDoseMilligrams / 50) > 0.4) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(morphineDoseMilligrams / 50)]]];
                
                if (!morphineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n0.4 mg/ml.\n(although higher concentrations have been used)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    morphineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"MORPHINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.4 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.morphineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:morphineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 1) // dopamine
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.dopamineStrength = @"Single";
                self.dopamineStrengthDose = @"30 mg/kg";
                break;
                
            case 1:
                self.dopamineStrength = @"Double";
                self.dopamineStrengthDose = @"60 mg/kg";
                
                break;
                
            case 2:
                self.dopamineStrength = @"Quad";
                self.dopamineStrengthDose = @"120 mg/kg";
                
                break;
                
            default:
                break;
        }
        
        self.dopamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dopamineStrength, self.dopamineStrengthDose];
        
        if ([self.dopamineStrength isEqualToString:@"Double"] || [self.dopamineStrength isEqualToString:@"Quad"]) 
        {
            self.dopamineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.dopamineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float dopamineDoseMilligrams;
        
        if ([self.dopamineStrength isEqualToString:@"Single"])
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 30.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
        }
        else if ([self.dopamineStrength isEqualToString:@"Double"]) 
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 60.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((dopamineDoseMilligrams / 50) > 3.2) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dopamineDoseMilligrams / 50)]]];
                
                if (!dopamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n3.2 mg/ml.\n(Can be used more concentrated in fluid restricted patients and always via a central line)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dopamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!"
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 3.2 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.dopamineStrength isEqualToString:@"Quad"])
        {
            dopamineDoseMilligrams = workingWeightKGasFloat * 120.0f;
            self.dopamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
            self.dopamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((dopamineDoseMilligrams / 50) > 3.2) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dopamineDoseMilligrams / 50)]]];
                
                if (!dopamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n3.2 mg/ml.\n(Can be used more concentrated in fluid restricted patients and always via a central line)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dopamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOPAMINE - CAUTION!"
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 3.2 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.dopamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dopamineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 2) // dobutamine
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.dobutamineStrength = @"Single";
                self.dobutamineStrengthDose = @"30mg/kg";
                break;
                
            case 1:
                self.dobutamineStrength = @"Double";
                self.dobutamineStrengthDose = @"60mg/kg";
                break;
                
            case 2:
                self.dobutamineStrength = @"Quad";
                self.dobutamineStrengthDose = @"120mg/kg";
                break;
                
            default:
                break;
        }
        
        self.dobutamineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.dobutamineStrength, self.dobutamineStrengthDose];
        
        if ([self.dobutamineStrength isEqualToString:@"Double"] || [self.dobutamineStrength isEqualToString:@"Quad"]) 
        {
            self.dobutamineStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.dobutamineStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float dobutamineDoseMilligrams;
        
        if ([self.dobutamineStrength isEqualToString:@"Single"])
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 30;
            self.dobutamineDose2Label.text = @"1 ml/hr = 10 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.2 - 2 ml/hr";
        }
        else if ([self.dobutamineStrength isEqualToString:@"Double"]) 
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 60;
            self.dobutamineDose2Label.text = @"1 ml/hr = 20 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            
            if ((dobutamineDoseMilligrams / 50) > 5) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dobutamineDoseMilligrams / 50)]]];
                
                if (!dobutamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n5.0 mg/ml.\n(Concentrations up to 10 mg/ml have been used centrally)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dobutamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        else if ([self.dobutamineStrength isEqualToString:@"Quad"])
        {
            dobutamineDoseMilligrams = workingWeightKGasFloat * 120;
            self.dobutamineDose2Label.text = @"1 ml/hr = 40 micrograms/kg/min";
            self.dobutamineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
            
            if ((dobutamineDoseMilligrams / 50) > 5) 
            {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                formatter.minimumFractionDigits = 0;
                formatter.maximumFractionDigits = 1;
                
                NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(dobutamineDoseMilligrams / 50)]]];
                
                if (!dobutamineConcentrationHighWarningGiven)
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:@"Final concentration exceeds\n5.0 mg/ml.\n(Concentrations up to 10 mg/ml have been used centrally)"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    dobutamineConcentrationHighWarningGiven = YES;
                }
                else 
                {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                              message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.dobutamineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:dobutamineDoseMilligrams]]];
    }
    else if (segmentedControl.tag == 3) // adrenaline
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.adrenalineStrength = @"Single";
                self.adrenalineStrengthDose = @"3 mg/kg";
                break;
                
            case 1:
                self.adrenalineStrength = @"Double";
                self.adrenalineStrengthDose = @"6 mg/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.adrenalineStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.adrenalineStrength, self.adrenalineStrengthDose];
            
            if ([self.adrenalineStrength isEqualToString:@"Single"])
            {
                self.adrenalineStrengthLabel.textColor = [UIColor blackColor];
            }
            else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
            {
                self.adrenalineStrengthLabel.textColor = [UIColor redColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float adrenalineDoseMilligrams;
            
            if ([self.adrenalineStrength isEqualToString:@"Single"])
            {
                adrenalineDoseMilligrams = workingWeightKGasFloat * 3;
                self.adrenalineDose2Label.text = @"1 ml/hr = 1 micrograms/kg/min";
                self.adrenalineRangeLabel.text = @"Range 0.1 - 1 ml/hr";
            }
            else if ([self.adrenalineStrength isEqualToString:@"Double"]) 
            {
                adrenalineDoseMilligrams = workingWeightKGasFloat * 6;
                self.adrenalineDose2Label.text = @"1 ml/hr = 2 micrograms/kg/min";
                self.adrenalineRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                
                if ((adrenalineDoseMilligrams / 50) > 0.32) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:(adrenalineDoseMilligrams / 50)]]];
                    
                    if (!adrenalineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:[NSString stringWithFormat:@"%@ - CAUTION!", NSLocalizedString(@"ADRENALINE", nil)] 
                                                  message:@"Final concentration exceeds\n0.32 mg/ml.\n(Can be used more concentrated, or even neat, in fluid restricted patients and always via a central line)"
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        adrenalineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:[NSString stringWithFormat:@"%@ - CAUTION!", NSLocalizedString(@"ADRENALINE", nil)] 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 0.32 mg/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.adrenalineDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:adrenalineDoseMilligrams]]];
        }
    }
    else if (segmentedControl.tag == 5) // insulin
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.insulinStrength = @"Single";
                self.insulinStrengthDose = @"10 units/kg";
                break;
                
            case 1:
                self.insulinStrength = @"Double";
                self.insulinStrengthDose = @"20 units/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.insulinStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.insulinStrength, self.insulinStrengthDose];
            
            if ([self.insulinStrength isEqualToString:@"Double"] || [self.insulinStrength isEqualToString:@"Quad"]) 
            {
                self.insulinStrengthLabel.textColor = [UIColor redColor];
            }
            else 
            {
                self.insulinStrengthLabel.textColor = [UIColor blackColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float insulinDoseUnits;
            
            if ([self.insulinStrength isEqualToString:@"Single"])
            {
                insulinDoseUnits = workingWeightKGasFloat * 10;
                self.insulinDose2Label.text = @"1 ml/hr = 0.2 units/kg/hr";
                self.insulinRangeLabel.text = @"Start at 0.25 - 0.5 ml/hr";
            }
            else if ([self.insulinStrength isEqualToString:@"Double"]) {
                insulinDoseUnits = workingWeightKGasFloat * 20;
                self.insulinDose2Label.text = @"1 ml/hr = 0.4 units/kg/hr";
                self.insulinRangeLabel.text = @"Start at 0.12 - 0.25 ml/hr";
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.insulinDoseLabel.text = [NSString stringWithFormat:@"%@ Units", [formatter stringFromNumber:[NSNumber numberWithFloat:insulinDoseUnits]]];
        }
    }
    else if (segmentedControl.tag == 6) // atracurium
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.atracuriumStrength = @"Single";
                self.atracuriumStrengthDose = @"60 mg/kg";
                break;
                
            case 1:
                self.atracuriumStrength = @"Double";
                self.atracuriumStrengthDose = @"120 mg/kg";
                break;
                
            default:
                break;
        }
        
        if (self.workingWeight) 
        {
            self.atracuriumStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.atracuriumStrength, self.atracuriumStrengthDose];
            
            if ([self.atracuriumStrength isEqualToString:@"Single"])
            {
                self.atracuriumStrengthLabel.textColor = [UIColor blackColor];
            }
            else if ([self.atracuriumStrength isEqualToString:@"Double"]) 
            {
                self.atracuriumStrengthLabel.textColor = [UIColor redColor];
            }
            
            float workingWeightKGasFloat = [self.workingWeight floatValue];
            
            float atracuriumDoseMilligrams;
            
            if ([self.atracuriumStrength isEqualToString:@"Single"])
            {
                atracuriumDoseMilligrams = workingWeightKGasFloat * 60;
                self.atracuriumDose2Label.text = @"1 ml/hr = 1.2 mg/kg/hr";
                self.atracuriumRangeLabel.text = @"Range 0.25 - 1 ml/hr";
                
                if ((atracuriumDoseMilligrams / 50) < 0.5) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(atracuriumDoseMilligrams / 50)]]];
                    
                    if (!dobutamineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:@"Final concentration below\n500 micrograms/ml."
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        dobutamineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(< 500 micrograms/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            else if ([self.atracuriumStrength isEqualToString:@"Double"]) {
                atracuriumDoseMilligrams = workingWeightKGasFloat * 120;
                self.atracuriumDose2Label.text = @"1 ml/hr = 2.4 mg/kg/hr";
                self.atracuriumRangeLabel.text = @"Range 0.1 - 0.5 ml/hr";
                
                if ((atracuriumDoseMilligrams / 50) > 5) 
                {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    formatter.minimumFractionDigits = 0;
                    formatter.maximumFractionDigits = 2;
                    
                    NSString *tempString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:(atracuriumDoseMilligrams / 50)]]];
                    
                    if (!dobutamineConcentrationHighWarningGiven)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:@"Final concentration exceeds\n5.0 mg/ml."
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                        dobutamineConcentrationHighWarningGiven = YES;
                    }
                    else 
                    {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"DOBUTAMINE - CAUTION!" 
                                                  message:[NSString stringWithFormat:@"Final concentration %@ mg/ml.\n(> 5.0 mg/ml)", tempString]
                                                  delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }
            }
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.roundingMode = NSNumberFormatterRoundHalfEven;
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 2;
            
            self.atracuriumDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:atracuriumDoseMilligrams]]];
        }
    }
    else if (segmentedControl.tag == 8) // midazolam
    {
        switch (segmentedControl.selectedIndex)
        {
            case 0:
                self.midazolamStrength = @"Single";
                self.midazolamStrengthDose = @"10 mg/kg";
                break;
                
            case 1:
                self.midazolamStrength = @"Double";
                self.midazolamStrengthDose = @"20 mg/kg";
                break;
                
            default:
                break;
        }
        
        self.midazolamStrengthLabel.text = [NSString stringWithFormat:@"%@ strength (%@)", self.midazolamStrength, self.midazolamStrengthDose];
        
        if ([self.midazolamStrength isEqualToString:@"Double"]) 
        {
            self.midazolamStrengthLabel.textColor = [UIColor redColor];
        }
        else 
        {
            self.midazolamStrengthLabel.textColor = [UIColor blackColor];
        }
        
        float workingWeightKGasFloat = [self.workingWeight floatValue];
        
        float midazolamDoseMilligrams;
        
        if ([self.midazolamStrength isEqualToString:@"Single"])
        {
            midazolamDoseMilligrams = workingWeightKGasFloat * 10.0f;
            self.midazolamDose2Label.text = @"1 ml/hr = 200 micrograms/kg/hr";
            self.midazolamRangeLabel.text = @"Range 0.3 - 1.5 ml/hr";
        }
        else if ([self.midazolamStrength isEqualToString:@"Double"]) {
            midazolamDoseMilligrams = workingWeightKGasFloat * 20.0f;
            self.midazolamDose2Label.text = @"1 ml/hr = 400 micrograms/kg/hr";
            self.midazolamRangeLabel.text = @"Range 0.15 - 0.75 ml/hr";
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundHalfEven;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 2;
        
        self.midazolamDoseLabel.text = [NSString stringWithFormat:@"%@ mg", [formatter stringFromNumber:[NSNumber numberWithFloat:midazolamDoseMilligrams]]];
    }
}

- (void)sliderValueChanged:(UISlider *)sender
{
    float workingWeightKGasFloat = [self.workingWeight floatValue];
    
    float prostinDoseNanogramsPerKilogramPerMinute = roundf(sender.value);
    
    float prostinRate = (0.06f * workingWeightKGasFloat * prostinDoseNanogramsPerKilogramPerMinute);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    
    NSString *prostingRateAsRoundedString = [formatter stringFromNumber:[NSNumber numberWithFloat:prostinRate]];
    
    self.prostinDose3Label.text = [NSString stringWithFormat:@"%.0f nanograms/kg/min = %@ ml/hr", prostinDoseNanogramsPerKilogramPerMinute, prostingRateAsRoundedString]; 
}

@end