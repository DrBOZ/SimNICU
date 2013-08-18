//
//  FluidRequirementsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 17/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "FluidRequirementsViewController.h"
#import "DAAnisotropicImage.h"
#import "UnderlineLabel.h"

@interface FluidRequirementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *totalFluidsMLPERKGPERDAY;
@property (nonatomic, strong) UITableView *MLperHOURTableView;
@property (nonatomic, strong) UISlider *totalPotassiumSlider;
@property (nonatomic, strong) UILabel *totalFluidsMLPERHOUR;
@property (nonatomic, strong) UILabel *totalFluidsMLPERDAY;
@property (nonatomic, strong) UISlider *totalCalciumSlider;
@property (nonatomic, strong) UISlider *totalSodiumSlider;
@property (nonatomic, strong) UISlider *totalFluidSlider;
@property (nonatomic, strong) UITableView *additives;


@property (nonatomic, strong) UILabel *totalSodiumMMOLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalPotassiumMMOLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalCalciumMMOLPERKGPERDAY;

@end

@implementation FluidRequirementsViewController

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
    
    self.MLperHOURTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    self.MLperHOURTableView.separatorColor = [UIColor grayColor];
    self.MLperHOURTableView.sectionFooterHeight = 15.0f;
    self.MLperHOURTableView.scrollEnabled = YES;
    self.MLperHOURTableView.dataSource = self;
    self.MLperHOURTableView.rowHeight = 50.0f;
    self.MLperHOURTableView.delegate = self;
    self.MLperHOURTableView.bounces = YES;
    [self.view addSubview:self.MLperHOURTableView];
    
    [CBDisplayMethods setBackgroundForTableView:self.MLperHOURTableView];
    
    if (!self.workingWeight)
    {
        self.MLperHOURTableView.tableFooterView = [self setupFooterView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.workingWeight)
    {
        // goes through the entire string and replaces any commas with full stops in case
        // user is using a european locale
        NSString *UKLocaleWorkingWeight;
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:@"," withString:@"."];
        UKLocaleWorkingWeight = [self.workingWeight stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] withString:@"."];
        
        float workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            // present weight as grams
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
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 3;
            
            self.title = [NSString stringWithFormat:@"Working weight %@ kg", [formatter stringFromNumber:[NSNumber numberWithFloat:workingWeightKGAsFloat]]];
        }
    }
    else
    {
        self.title = @"Weight not entered";
    }
    
    // check if using iOS 5.0 or more, and if yes than handle anisotropic slider
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        [DAAnisotropicImage startAnisotropicUpdatesWithHandler:^(UIImage *image)
         {
             [self.totalFluidSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalFluidSlider setThumbImage:image forState:UIControlStateHighlighted];
             
             [self.totalSodiumSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalSodiumSlider setThumbImage:image forState:UIControlStateHighlighted];
             
             [self.totalPotassiumSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalPotassiumSlider setThumbImage:image forState:UIControlStateHighlighted];
         }];
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
    if (self.workingWeight)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    if (self.workingWeight)
    {
        if (section == 0)
        {
            rows = 1;
        }
        else
        {
            rows = 3;
        }
    }
    else
    {
        rows = 0;
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 110.0f;
    }
    else
    {
        return 140.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float footer = 15.0f;
    
    /*
    if (!self.workingWeight)
    {
        footer = 500.0f;
    }
     */
    
    return footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (self.workingWeight)
    {
        if (section == 0)
        {
            header = @"Total Fluid Volume";
        }
        else
        {
            header = @"Additives";
        }
    }
    
    return header;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = nil;
    
    if (!self.workingWeight)
    {
#warning adapt for iPhone 4S
        // iPhone 5
        footer = @"\n\n\n\n\n\n\n\nA weight is need for this calculator.\n\nPlease go back and press the    button or slide the image to the right, and enter a weight or gestation, or select a patient.\n\nThank you.";
    }
    
    return footer;
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if (self.workingWeight)
    {
        NSString *CellIdentifier;
        
        if (indexPath.section == 0)
        {
            CellIdentifier = @"Total Fluid Volume";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                
                // setup labels
                // ml/kg/day
                self.totalFluidsMLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 144.0f, 22.0f)];
                self.totalFluidsMLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                self.totalFluidsMLPERKGPERDAY.textColor = [UIColor blackColor];
                self.totalFluidsMLPERKGPERDAY.backgroundColor = [UIColor clearColor];
                self.totalFluidsMLPERKGPERDAY.text = @"60 ml/kg/day";
                [cell addSubview:self.totalFluidsMLPERKGPERDAY];
                
                // ml/kg/hour
                self.totalFluidsMLPERHOUR = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 100.0f, 22.0f)];
                self.totalFluidsMLPERHOUR.font = [UIFont boldSystemFontOfSize:17.0f];
                self.totalFluidsMLPERHOUR.textColor = [UIColor blackColor];
                self.totalFluidsMLPERHOUR.text = @"3.4 ml/hour";
                [cell addSubview:self.totalFluidsMLPERHOUR];
                
                // ml/kg/day
                self.totalFluidsMLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 32.0f, 100.0f, 22.0f)];
                // self.totalFluidsMLPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                self.totalFluidsMLPERDAY.font = [UIFont systemFontOfSize:17.0f];
                self.totalFluidsMLPERDAY.textColor = [UIColor grayColor];
                self.totalFluidsMLPERDAY.text = @"(120 ml/day)";
                [cell addSubview:self.totalFluidsMLPERDAY];
                
                // equals sign
                UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(159.0f, 10.0f, 10.0f, 22.0f)];
                equals.font = [UIFont boldSystemFontOfSize:17.0f];
                equals.backgroundColor = [UIColor clearColor];
                equals.textColor = [UIColor blackColor];
                equals.text = @"=";
                [cell addSubview:equals];
                
                // setup slider labels
                // '40'
                UILabel *forty = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 56.0f, 30.0f, 22.0f)];
                forty.font = [UIFont systemFontOfSize:12.0f];
                forty.textColor = [UIColor grayColor];
                forty.text = @"40";
                [cell addSubview:forty];
                
                // '60'
                UILabel *sixty = [[UILabel alloc] initWithFrame:CGRectMake(73.0f, 56.0f, 30.0f, 22.0f)];
                sixty.font = [UIFont systemFontOfSize:12.0f];
                sixty.textColor = [UIColor grayColor];
                sixty.text = @"60";
                [cell addSubview:sixty];
                
                // '80'
                UILabel *eighty = [[UILabel alloc] initWithFrame:CGRectMake(119.0f, 56.0f, 30.0f, 22.0f)];
                eighty.font = [UIFont systemFontOfSize:12.0f];
                eighty.textColor = [UIColor grayColor];
                eighty.text = @"80";
                [cell addSubview:eighty];
                
                // '90'
                UILabel *ninety = [[UILabel alloc] initWithFrame:CGRectMake(142.0f, 56.0f, 30.0f, 22.0f)];
                ninety.font = [UIFont systemFontOfSize:12.0f];
                ninety.textColor = [UIColor grayColor];
                ninety.text = @"90";
                [cell addSubview:ninety];
                
                // '100'
                UILabel *oneHundred = [[UILabel alloc] initWithFrame:CGRectMake(161.0f, 56.0f, 30.0f, 22.0f)];
                oneHundred.font = [UIFont systemFontOfSize:12.0f];
                oneHundred.textColor = [UIColor grayColor];
                oneHundred.text = @"100";
                [cell addSubview:oneHundred];
                
                // '120'
                UILabel *oneTwenty = [[UILabel alloc] initWithFrame:CGRectMake(207.0f, 56.0f, 30.0f, 22.0f)];
                oneTwenty.font = [UIFont systemFontOfSize:12.0f];
                oneTwenty.textColor = [UIColor grayColor];
                oneTwenty.text = @"120";
                [cell addSubview:oneTwenty];
                
                // '150'
                UILabel *oneFifty = [[UILabel alloc] initWithFrame:CGRectMake(274.0f, 56.0f, 30.0f, 22.0f)];
                oneFifty.font = [UIFont systemFontOfSize:12.0f];
                oneFifty.textColor = [UIColor grayColor];
                oneFifty.text = @"150";
                [cell addSubview:oneFifty];
                
                // setup slider for total fluids
                self.totalFluidSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 280.0f, 40.0f)];
                self.totalFluidSlider.minimumValue = 40.0f;
                self.totalFluidSlider.maximumValue = 150.0f;
                self.totalFluidSlider.value = 60.0f;
                [self.totalFluidSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                self.totalFluidSlider.continuous = YES;
                
                // if accelerometer add anisotropic images to sliders
                if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
                {
                    UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                    UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                    [self.totalFluidSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
                    [self.totalFluidSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
                    
                    UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
                    [self.totalFluidSlider setThumbImage:initialImage forState:UIControlStateNormal];
                    [self.totalFluidSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
                }
                
                [cell addSubview:self.totalFluidSlider];
            }
            
            cell.textLabel.text = @"";
            
            returnCell = cell;
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                CellIdentifier = @"Sodium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *sodium = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 300.0f, 22.0f)];
                    sodium.font = [UIFont boldSystemFontOfSize:17.0f];
                    sodium.backgroundColor = [UIColor clearColor];
                    sodium.textColor = [UIColor blackColor];
                    sodium.text = @"Sodium chloride 30%";
                    [cell addSubview:sodium];
                    
                    self.totalSodiumMMOLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 150.0f, 22.0f)];
                    self.totalSodiumMMOLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalSodiumMMOLPERKGPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalSodiumMMOLPERKGPERDAY.textColor = [UIColor blackColor];
                    self.totalSodiumMMOLPERKGPERDAY.text = @"3 mmol/kg/day";
                    [cell addSubview:self.totalSodiumMMOLPERKGPERDAY];
                    
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(159.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];
                    
                    UILabel *mmol = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 140.0f, 22.0f)];
                    mmol.font = [UIFont boldSystemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor blackColor];
                    mmol.text = @"10 mmol/day";
                    [cell addSubview:mmol];
                    
                    mmol = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmol.font = [UIFont systemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor grayColor];
                    mmol.text = @"(17.5 mmol/500 ml)";
                    [cell addSubview:mmol];
                    
                    // setup slider labels
                    // '0'
                    UILabel *zero = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, 86.0f, 30.0f, 22.0f)];
                    zero.font = [UIFont systemFontOfSize:12.0f];
                    zero.textColor = [UIColor grayColor];
                    zero.text = @"0";
                    [cell addSubview:zero];
                    
                    // '15'
                    UILabel *fifteen = [[UILabel alloc] initWithFrame:CGRectMake(278.0f, 86.0f, 30.0f, 22.0f)];
                    fifteen.font = [UIFont systemFontOfSize:12.0f];
                    fifteen.textColor = [UIColor grayColor];
                    fifteen.text = @"15";
                    [cell addSubview:fifteen];
                    
                    // setup slider for Sodium
                    self.totalSodiumSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
                    self.totalSodiumSlider.minimumValue = 0.0f;
                    self.totalSodiumSlider.maximumValue = 15.0f;
                    self.totalSodiumSlider.value = 3.0f;
                    [self.totalSodiumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalSodiumSlider.continuous = YES;
                    
                    // if accelerometer add anisotropic images to sliders
                    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
                    {
                        UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        
                        [self.totalSodiumSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
                        [self.totalSodiumSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
                        
                        UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
                        [self.totalSodiumSlider setThumbImage:initialImage forState:UIControlStateNormal];
                        [self.totalSodiumSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
                    }
                    
                    [cell addSubview:self.totalSodiumSlider];
                }
                
                cell.textLabel.text = @"";
                
                returnCell = cell;
            }
            else if (indexPath.row == 1)
            {
                CellIdentifier = @"Potassium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *potassium = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 300.0f, 22.0f)];
                    potassium.font = [UIFont boldSystemFontOfSize:17.0f];
                    potassium.backgroundColor = [UIColor clearColor];
                    potassium.textColor = [UIColor blackColor];
                    potassium.text = @"Potassium chloride 15%";
                    [cell addSubview:potassium];
#warning change required
                    UILabel *misc = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 150.0f, 22.0f)];
                    misc.font = [UIFont boldSystemFontOfSize:17.0f];
                    misc.backgroundColor = [UIColor clearColor];
                    misc.textColor = [UIColor blackColor];
                    misc.text = @"2 mmol/kg/day";
                    [cell addSubview:misc];
                    
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(159.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];
#warning change required
                    UILabel *mmol = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 140.0f, 22.0f)];
                    mmol.font = [UIFont boldSystemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor blackColor];
                    mmol.text = @"7.5 mmol/day";
                    [cell addSubview:mmol];
#warning change required
                    mmol = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmol.font = [UIFont systemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor grayColor];
                    mmol.text = @"(12.5 mmol/500 ml)";
                    [cell addSubview:mmol];
                    
                    // setup slider labels
                    // '0'
                    UILabel *zero = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, 86.0f, 30.0f, 22.0f)];
                    zero.font = [UIFont systemFontOfSize:12.0f];
                    zero.textColor = [UIColor grayColor];
                    zero.text = @"0";
                    [cell addSubview:zero];
                    
                    // '5'
                    UILabel *five = [[UILabel alloc] initWithFrame:CGRectMake(282.0f, 86.0f, 30.0f, 22.0f)];
                    five.font = [UIFont systemFontOfSize:12.0f];
                    five.textColor = [UIColor grayColor];
                    five.text = @"5";
                    [cell addSubview:five];
                    
                    self.totalPotassiumSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
                    self.totalPotassiumSlider.minimumValue = 0.0f;
                    self.totalPotassiumSlider.maximumValue = 5.0f;
                    self.totalPotassiumSlider.value = 2.0f;
                    [self.totalPotassiumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalPotassiumSlider.continuous = YES;
                    
                    // if accelerometer add anisotropic images to sliders
                    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
                    {
                        UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        
                        [self.totalPotassiumSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
                        [self.totalPotassiumSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
                        
                        UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
                        [self.totalPotassiumSlider setThumbImage:initialImage forState:UIControlStateNormal];
                        [self.totalPotassiumSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
                    }
                    
                    [cell addSubview:self.totalPotassiumSlider];
                }
                
                cell.textLabel.text = @"";
                
                returnCell = cell;
            }
            else if (indexPath.row == 2)
            {
                CellIdentifier = @"Calcium";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if(!cell)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                    
                    UILabel *potassium = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 300.0f, 22.0f)];
                    potassium.font = [UIFont boldSystemFontOfSize:17.0f];
                    potassium.backgroundColor = [UIColor clearColor];
                    potassium.textColor = [UIColor blackColor];
                    potassium.text = @"Calcium";
                    [cell addSubview:potassium];
#warning change required
                    UILabel *misc = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 150.0f, 22.0f)];
                    misc.font = [UIFont boldSystemFontOfSize:17.0f];
                    misc.backgroundColor = [UIColor clearColor];
                    misc.textColor = [UIColor blackColor];
                    misc.text = @"1 mmol/kg/day";
                    [cell addSubview:misc];
                    
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(159.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];
#warning change required
                    UILabel *mmol = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 140.0f, 22.0f)];
                    mmol.font = [UIFont boldSystemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor blackColor];
                    mmol.text = @"3.75 mmol/day";
                    [cell addSubview:mmol];
#warning change required
                    mmol = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmol.font = [UIFont systemFontOfSize:17.0f];
                    mmol.backgroundColor = [UIColor clearColor];
                    mmol.textAlignment = UITextAlignmentRight;
                    mmol.textColor = [UIColor grayColor];
                    mmol.text = @"(10 mmol/500 ml)";
                    [cell addSubview:mmol];
                    
                    // setup slider labels
                    // '0'
                    UILabel *zero = [[UILabel alloc] initWithFrame:CGRectMake(31.0f, 86.0f, 30.0f, 22.0f)];
                    zero.font = [UIFont systemFontOfSize:12.0f];
                    zero.textColor = [UIColor grayColor];
                    zero.text = @"0";
                    [cell addSubview:zero];
                    
                    // '5'
                    UILabel *five = [[UILabel alloc] initWithFrame:CGRectMake(282.0f, 86.0f, 30.0f, 22.0f)];
                    five.font = [UIFont systemFontOfSize:12.0f];
                    five.textColor = [UIColor grayColor];
                    five.text = @"5";
                    [cell addSubview:five];
                    
                    self.totalCalciumSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
                    self.totalCalciumSlider.minimumValue = 0.0f;
                    self.totalCalciumSlider.maximumValue = 5.0f;
                    self.totalCalciumSlider.value = 1.0f;
                    [self.totalCalciumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalCalciumSlider.continuous = YES;
                    
                    // if accelerometer add anisotropic images to sliders
                    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
                    {
                        UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
                        
                        [self.totalCalciumSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
                        [self.totalCalciumSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
                        
                        UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
                        [self.totalCalciumSlider setThumbImage:initialImage forState:UIControlStateNormal];
                        [self.totalCalciumSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
                    }
                    
                    [cell addSubview:self.totalCalciumSlider];
                }
                
                cell.textLabel.text = @"";
                
                returnCell = cell;
            }
        }
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)sliderValueChanged:(UISlider *)sender
{
    if ([sender isEqual:self.totalFluidSlider])
    {
        [self incrementSlider:sender withInterval:5 withMinValue:40 andMaxValue:150];
        
        int totalFluids = sender.value;

        self.totalFluidsMLPERKGPERDAY.text = [NSString stringWithFormat:@"%i ml/kg/day", totalFluids];
        
        // ml/day
        
        // ml/hour
    }
    else if ([sender isEqual:self.totalSodiumSlider])
    {
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:15];
        
        double totalSodium = sender.value;
        
        NSString *formattedTotalSodium = [self formatResultWithDouble:(double)totalSodium];
        
        self.totalSodiumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ mmol/kg/day", formattedTotalSodium];
    }
    else if ([sender isEqual:self.totalPotassiumSlider])
    {
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:5];
        
        double totalPotassium = sender.value;
        
        NSString *formattedTotalPotassium = [self formatResultWithDouble:totalPotassium];
        
        self.totalPotassiumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ mmol/kg/day", formattedTotalPotassium];
    }
    else if ([sender isEqual:self.totalCalciumSlider])
    {
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:5];
        
        double totalCalcium = sender.value;
        
        NSString *formattedTotalCalcium = [self formatResultWithDouble:totalCalcium];
        
        self.totalCalciumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ mmol/kg/day", formattedTotalCalcium];
    }
}

- (void)incrementSlider:(UISlider *)slider withInterval:(double)interval withMinValue:(double)minValue andMaxValue:(double)maxValue
{
    for (double i = minValue; i <= maxValue; i = i + interval)
    {
        if (slider.value > i && slider.value < i + interval)
        {
            if (slider.value - i < i + interval - slider.value)
            {
                slider.value = i;
            }
            else
            {
                slider.value = i + interval;
            }
            
            break;
        }
    }
}

- (NSString *)formatResultWithDouble:(double)result
{
    NSString *formattedResult;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    // if locale has an arabic decimal separator then use english
    if([[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator] isEqualToString:@"٫"])
    {
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    }
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 1;
    
    formattedResult = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
     
    return formattedResult;
}

- (UIView *)setupFooterView
{
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    float height = 50.0f;
    
    if (appDelegate.window.bounds.size.height == 568)
    {
        height = 110.0f; // 4 inch Retina
    }
    else
    {
        height = 70.0f; // 3.5 inch Retina
    }
    
    // Instructions, as no working weight entered...
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 300.0f)];
    
    UIView *instructions = [[UIView alloc] initWithFrame:CGRectMake(0.0f, height, 0.0f, 200.0f)];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 150.0f)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = UITextAlignmentCenter;
    text.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    text.shadowColor = [UIColor whiteColor];
    text.shadowOffset = CGSizeMake(0.0f, 1.0f);
    text.numberOfLines = 0;
    text.font = [UIFont boldSystemFontOfSize:15.0f];
    text.text = @"A weight is needed for this calculator.\n\nPlease go back and press the          \nbutton, or slide the image to the right,\nand enter a weight or gestation\nor select a patient.";
    [instructions addSubview:text];
    
    UnderlineLabel *thankYou = [[UnderlineLabel alloc] initWithFrame:CGRectMake(0.0f, 136.0f, 320.0f, 44.0f)];
    thankYou.backgroundColor = [UIColor clearColor];
    thankYou.textAlignment = UITextAlignmentCenter;
    thankYou.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    thankYou.shadowColor = [UIColor whiteColor];
    thankYou.shadowOffset = CGSizeMake(0.0f, 1.0f);
    thankYou.numberOfLines = 1;
    thankYou.start = 122.0f;
    thankYou.end = 197.0f;
    thankYou.font = [UIFont boldSystemFontOfSize:15.0f];
    thankYou.text = @"Thank you.";
    [instructions addSubview:thankYou];
    
    UIImageView *plusButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusButton2.png"]];
    plusButton.frame = CGRectMake(270.0f, 36.0f, 40.0f, 40.0f);
    [instructions addSubview:plusButton];
    
    [footerView addSubview:instructions];
    
    return footerView;
}

@end
