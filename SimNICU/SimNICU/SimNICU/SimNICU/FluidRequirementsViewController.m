//
//  FluidRequirementsViewController.m
//  SimNICU
//
//  Created by Conrad Bosman on 17/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "FluidRequirementsViewController.h"
#import "DAAnisotropicImage.h"

@interface FluidRequirementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *totalFluidsMLPERKGPERDAY;
@property (nonatomic, strong) UITableView *MLperHOURTableView;
@property (nonatomic, strong) UISlider *totalPotassiumSlider;
@property (nonatomic, strong) UILabel *totalFluidsMLPERHOUR;
@property (nonatomic, strong) UILabel *totalFluidsMLPERDAY;
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
        self.workingWeight = @"2.95";
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = nil;
    
    if (section == 0)
    {
        rows = 1;
    }
    else
    {
        rows = 3;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    
    if (section == 0)
    {
        header = @"Total Fluid Volume";
    }
    else
    {
        header = @"Additives";
    }
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
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
            
            UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(159.0f, 10.0f, 10.0f, 22.0f)];
            equals.font = [UIFont boldSystemFontOfSize:17.0f];
            equals.backgroundColor = [UIColor clearColor];
            equals.textColor = [UIColor blackColor];
            equals.text = @"=";
            [cell addSubview:equals];
            
            UILabel *forty = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 56.0f, 30.0f, 22.0f)];
            forty.font = [UIFont systemFontOfSize:12.0f];
            forty.textColor = [UIColor grayColor];
            forty.text = @"40";
            [cell addSubview:forty];
            
            UILabel *sixty = [[UILabel alloc] initWithFrame:CGRectMake(73.0f, 56.0f, 30.0f, 22.0f)];
            sixty.font = [UIFont systemFontOfSize:12.0f];
            sixty.textColor = [UIColor grayColor];
            sixty.text = @"60";
            [cell addSubview:sixty];
            
            UILabel *eighty = [[UILabel alloc] initWithFrame:CGRectMake(119.0f, 56.0f, 30.0f, 22.0f)];
            eighty.font = [UIFont systemFontOfSize:12.0f];
            eighty.textColor = [UIColor grayColor];
            eighty.text = @"80";
            [cell addSubview:eighty];
            
            UILabel *ninety = [[UILabel alloc] initWithFrame:CGRectMake(142.0f, 56.0f, 30.0f, 22.0f)];
            ninety.font = [UIFont systemFontOfSize:12.0f];
            ninety.textColor = [UIColor grayColor];
            ninety.text = @"90";
            [cell addSubview:ninety];
            
            UILabel *oneHundred = [[UILabel alloc] initWithFrame:CGRectMake(161.0f, 56.0f, 30.0f, 22.0f)];
            oneHundred.font = [UIFont systemFontOfSize:12.0f];
            oneHundred.textColor = [UIColor grayColor];
            oneHundred.text = @"100";
            [cell addSubview:oneHundred];
            
            UILabel *oneTwenty = [[UILabel alloc] initWithFrame:CGRectMake(207.0f, 56.0f, 30.0f, 22.0f)];
            oneTwenty.font = [UIFont systemFontOfSize:12.0f];
            oneTwenty.textColor = [UIColor grayColor];
            oneTwenty.text = @"120";
            [cell addSubview:oneTwenty];
            
            UILabel *oneFifty = [[UILabel alloc] initWithFrame:CGRectMake(274.0f, 56.0f, 30.0f, 22.0f)];
            oneFifty.font = [UIFont systemFontOfSize:12.0f];
            oneFifty.textColor = [UIColor grayColor];
            oneFifty.text = @"150";
            [cell addSubview:oneFifty];
            
            // setup labels
            self.totalFluidsMLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 144.0f, 22.0f)];
            self.totalFluidsMLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
            self.totalFluidsMLPERKGPERDAY.textColor = [UIColor blackColor];
            self.totalFluidsMLPERKGPERDAY.backgroundColor = [UIColor clearColor];
            self.totalFluidsMLPERKGPERDAY.text = @"60 ml/kg/day";
            [cell addSubview:self.totalFluidsMLPERKGPERDAY];
            
            self.totalFluidsMLPERHOUR = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 10.0f, 100.0f, 22.0f)];
            self.totalFluidsMLPERHOUR.font = [UIFont boldSystemFontOfSize:17.0f];
            self.totalFluidsMLPERHOUR.textColor = [UIColor blackColor];
            self.totalFluidsMLPERHOUR.text = @"3.4 ml/hour";
            [cell addSubview:self.totalFluidsMLPERHOUR];
            
            self.totalFluidsMLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 32.0f, 100.0f, 22.0f)];
            // self.totalFluidsMLPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
            self.totalFluidsMLPERDAY.font = [UIFont systemFontOfSize:17.0f];
            self.totalFluidsMLPERDAY.textColor = [UIColor grayColor];
            self.totalFluidsMLPERDAY.text = @"(120 ml/day)";
            [cell addSubview:self.totalFluidsMLPERDAY];
            
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
                
                UILabel *mmol = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 140.0f, 22.0f)];
                mmol.font = [UIFont boldSystemFontOfSize:17.0f];
                mmol.backgroundColor = [UIColor clearColor];
                mmol.textAlignment = UITextAlignmentRight;
                mmol.textColor = [UIColor blackColor];
                mmol.text = @"7.5 mmol/day";
                [cell addSubview:mmol];
                
                mmol = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                mmol.font = [UIFont systemFontOfSize:17.0f];
                mmol.backgroundColor = [UIColor clearColor];
                mmol.textAlignment = UITextAlignmentRight;
                mmol.textColor = [UIColor grayColor];
                mmol.text = @"(12.5 mmol/500 ml)";
                [cell addSubview:mmol];
                
                self.totalPotassiumSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
                self.totalPotassiumSlider.minimumValue = 40.0f;
                self.totalPotassiumSlider.maximumValue = 150.0f;
                self.totalPotassiumSlider.value = 60.0f;
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
                
                UILabel *mmol = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 140.0f, 22.0f)];
                mmol.font = [UIFont boldSystemFontOfSize:17.0f];
                mmol.backgroundColor = [UIColor clearColor];
                mmol.textAlignment = UITextAlignmentRight;
                mmol.textColor = [UIColor blackColor];
                mmol.text = @"3.75 mmol/day";
                [cell addSubview:mmol];
                
                mmol = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                mmol.font = [UIFont systemFontOfSize:17.0f];
                mmol.backgroundColor = [UIColor clearColor];
                mmol.textAlignment = UITextAlignmentRight;
                mmol.textColor = [UIColor grayColor];
                mmol.text = @"(10 mmol/500 ml)";
                [cell addSubview:mmol];
                
                self.totalPotassiumSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 280.0f, 40.0f)];
                self.totalPotassiumSlider.minimumValue = 40.0f;
                self.totalPotassiumSlider.maximumValue = 150.0f;
                self.totalPotassiumSlider.value = 60.0f;
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
        int interval = 5;
        
        for (int i = 40; i <= 150; i = i + interval)
        {
            if(sender.value > i && sender.value < i + interval)
            {
                if(sender.value - i < i + interval - sender.value)
                {
                    sender.value = i;
                }
                else
                {
                    sender.value = i + interval;
                }
                
                break;
            }
        }
        
        int totalFluids = sender.value;

        self.totalFluidsMLPERKGPERDAY.text = [NSString stringWithFormat:@"%i ml/kg/day", totalFluids];
        
        // ml/day
        
        // ml/hour
    }
    else if ([sender isEqual:self.totalSodiumSlider])
    {
        double interval = 0.5;
        
        for (double i = 0; i <= 15; i = i + interval)
        {
            if(sender.value > i && sender.value < i + interval)
            {
                if(sender.value - i < i + interval - sender.value)
                {
                    sender.value = i;
                }
                else
                {
                    sender.value = i + interval;
                }
                
                break;
            }
        }
        
        double totalSodium = sender.value;
        
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
        
        self.totalSodiumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ mmol/kg/day", [formatter stringFromNumber:[NSNumber numberWithDouble:totalSodium]]];
    }
}

@end
