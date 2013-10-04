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
#import "CBTimeMethods.h"

@interface FluidRequirementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UILabel *totalFluidsMLPERKGPERDAY;
@property (nonatomic, strong) UITableView *MLperHOURTableView;
@property (nonatomic, strong) UILabel *totalFluidsMLPERHOUR;
@property (nonatomic, strong) UILabel *totalFluidsMLPERDAY;
@property (nonatomic, strong) UISlider *totalFluidSlider;
// @property (nonatomic, strong) UITableView *additives;

@property (nonatomic, strong) UILabel *totalSodiumMMOLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalSodiumMMOLPERDAY;
@property (nonatomic, strong) UILabel *totalSodiumMMOLPERBAG;
@property (nonatomic, strong) UISlider *totalSodiumSlider;

@property (nonatomic, strong) UILabel *totalPotassiumMMOLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalPotassiumMMOLPERDAY;
@property (nonatomic, strong) UILabel *totalPotassiumMMOLPERBAG;
@property (nonatomic, strong) UISlider *totalPotassiumSlider;

@property (nonatomic, strong) UILabel *totalCalciumMMOLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalCalciumMMOLPERDAY;
@property (nonatomic, strong) UILabel *totalCalciumMMOLPERBAG;
@property (nonatomic, strong) UISlider *totalCalciumSlider;

@end

@implementation FluidRequirementsViewController
{
    float workingWeightKGAsFloat;
    double workingWeightKGAsDouble;
    double mlPerKgPerDay;
    double mlPerDay;
    double mlPerHour;
    
    double naMMOLPerKgPerDay;
    double naMMOLPerDay;
    double naMMOLPerBag;
    
    double kMMOLPerKgPerDay;
    double kMMOLPerDay;
    double kMMOLPerBag;
    
    double caMMOLPerKgPerDay;
    double caMMOLPerDay;
    double caMMOLPerBag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // default values
        mlPerKgPerDay = 60;
        
        naMMOLPerKgPerDay = 0;
        kMMOLPerKgPerDay = 0;
        caMMOLPerKgPerDay = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CBTrackers logEvent:@"Fluid Requirements"];
	
    //delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.MLperHOURTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height)) style:UITableViewStyleGrouped];
    }
    else
    {
        self.MLperHOURTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 64.0f)) style:UITableViewStyleGrouped];
    }
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
        
        // swipe gesture recognizer
        self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [self.MLperHOURTableView addGestureRecognizer:self.swipeGestureRecognizer];
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
        
        workingWeightKGAsFloat = [UKLocaleWorkingWeight floatValue];
        workingWeightKGAsDouble = [UKLocaleWorkingWeight doubleValue];
        
        if (workingWeightKGAsFloat < 1.0f)
        {
            // present weight as grams
            int workingWeightGRAMSAsInt = workingWeightKGAsFloat * 1000;
            
            self.title = [NSString stringWithFormat:@"Working weight %ig", workingWeightGRAMSAsInt];
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

    // if iOS 7 then return default slider
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        // do nothing
    }
    // if  iOS 5 or 6, then handle anisotropic slider
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
    {
        [DAAnisotropicImage startAnisotropicUpdatesWithHandler:^(UIImage *image)
         {
             [self.totalFluidSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalFluidSlider setThumbImage:image forState:UIControlStateHighlighted];
             
             [self.totalSodiumSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalSodiumSlider setThumbImage:image forState:UIControlStateHighlighted];
             
             [self.totalPotassiumSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalPotassiumSlider setThumbImage:image forState:UIControlStateHighlighted];
             
             [self.totalCalciumSlider setThumbImage:image forState:UIControlStateNormal];
             [self.totalCalciumSlider setThumbImage:image forState:UIControlStateHighlighted];
         }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
    if (self.selectedPatient)
    {
        if (self.selectedPatient.birthDate && self.selectedPatient.birthTimeSet)
        {
            // calculate exact age
            double ageInDays = [CBTimeMethods getDaysDifferenceDoubleBetween:self.selectedPatient.birthDate and:[NSDate date]];
            
            if (self.selectedPatient.gestation)
            {
                int gestation = [self.selectedPatient.gestation integerValue];
                
                if (gestation < 28)
                {
                    // extreme preterm fluids
                    if (ageInDays < 1)
                    {
                        mlPerKgPerDay = 60;
                    }
                    else if (ageInDays >= 1 && ageInDays < 2)
                    {
                        mlPerKgPerDay = 75;
                    }
                    else if (ageInDays >= 2 && ageInDays < 3)
                    {
                        mlPerKgPerDay = 80;
                    }
                    else if (ageInDays >= 3 && ageInDays < 4)
                    {
                        mlPerKgPerDay = 90;
                    }
                    else if (ageInDays >= 4)
                    {
                        mlPerKgPerDay = 120;
                    }
                }
                else
                {
                    // normal fluids
                    if (ageInDays < 1)
                    {
                        mlPerKgPerDay = 60;
                    }
                    else if (ageInDays >= 1 && ageInDays < 2)
                    {
                        mlPerKgPerDay = 70;
                    }
                    else if (ageInDays >= 2 && ageInDays < 3)
                    {
                        mlPerKgPerDay = 80;
                    }
                    else if (ageInDays >= 3 && ageInDays < 4)
                    {
                        mlPerKgPerDay = 90;
                    }
                    else if (ageInDays >= 4)
                    {
                        mlPerKgPerDay = 120;
                    }
                }
            }
        }
    }
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 15.0f;
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
                self.totalFluidsMLPERKGPERDAY.backgroundColor = [UIColor clearColor];
                self.totalFluidsMLPERKGPERDAY.textColor = [UIColor blackColor];
                [cell addSubview:self.totalFluidsMLPERKGPERDAY];
                
                // ml/hour
                self.totalFluidsMLPERHOUR = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 10.0f, 59.0f, 22.0f)];
                self.totalFluidsMLPERHOUR.font = [UIFont boldSystemFontOfSize:17.0f];
                self.totalFluidsMLPERHOUR.backgroundColor = [UIColor clearColor];
                self.totalFluidsMLPERHOUR.textAlignment = UITextAlignmentRight;
                self.totalFluidsMLPERHOUR.textColor = [UIColor blackColor];
                [cell addSubview:self.totalFluidsMLPERHOUR];
                
                UILabel *mlPerHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 10.0f, 128.0f, 22.0f)];
                mlPerHourLabel.font = [UIFont boldSystemFontOfSize:17.0f];
                mlPerHourLabel.backgroundColor = [UIColor clearColor];
                mlPerHourLabel.textAlignment = UITextAlignmentRight;
                mlPerHourLabel.textColor = [UIColor blackColor];
                mlPerHourLabel.text = @"ml/hour";
                [cell addSubview:mlPerHourLabel];
                
                // ml/day
                self.totalFluidsMLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 32.0f, 67.0f, 22.0f)];
                self.totalFluidsMLPERDAY.font = [UIFont systemFontOfSize:17.0f];
                self.totalFluidsMLPERDAY.backgroundColor = [UIColor clearColor];
                self.totalFluidsMLPERDAY.textAlignment = UITextAlignmentRight;
                self.totalFluidsMLPERDAY.textColor = [UIColor grayColor];
                [cell addSubview:self.totalFluidsMLPERDAY];
                
                UILabel *mlPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 32.0f, 128.0f, 22.0f)];
                mlPerDayLabel.font = [UIFont systemFontOfSize:17.0f];
                mlPerDayLabel.backgroundColor = [UIColor clearColor];
                mlPerDayLabel.textAlignment = UITextAlignmentRight;
                mlPerDayLabel.textColor = [UIColor grayColor];
                mlPerDayLabel.text = @"ml/day)";
                [cell addSubview:mlPerDayLabel];
                
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
                self.totalFluidSlider.value = mlPerKgPerDay;
                [self.totalFluidSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                self.totalFluidSlider.continuous = YES;
                
                // format slider appearance
                [self formatSliderAppearance:self.totalFluidSlider];
                
                [cell addSubview:self.totalFluidSlider];
                
                [self calculateInitialValuesForCellWithIdentifier:CellIdentifier];
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
                    [cell addSubview:self.totalSodiumMMOLPERKGPERDAY];

                    // will have to change this to a property to allow animation
                    UILabel *mmolPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 41.0f, 150.0f, 22.0f)];
                    mmolPerKgPerDay.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerKgPerDay.backgroundColor = [UIColor clearColor];
                    mmolPerKgPerDay.textAlignment = UITextAlignmentLeft;
                    mmolPerKgPerDay.textColor = [UIColor blackColor];
                    mmolPerKgPerDay.text = @"mmol/kg/day";
                    [cell addSubview:mmolPerKgPerDay];
                    
                    // and this one
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(167.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];
                    
                    // mmol/day
                    self.totalSodiumMMOLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 58.0f, 22.0f)];
                    self.totalSodiumMMOLPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalSodiumMMOLPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalSodiumMMOLPERDAY.textAlignment = UITextAlignmentRight;
                    self.totalSodiumMMOLPERDAY.textColor = [UIColor blackColor];
                    [cell addSubview:self.totalSodiumMMOLPERDAY];

                    UILabel *mmolPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 41.0f, 128.0f, 22.0f)];
                    mmolPerDayLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerDayLabel.backgroundColor = [UIColor clearColor];
                    mmolPerDayLabel.textAlignment = UITextAlignmentRight;
                    mmolPerDayLabel.textColor = [UIColor blackColor];
                    mmolPerDayLabel.text = @"mmol/day";
                    [cell addSubview:mmolPerDayLabel];

                    // mmol/500ml bag
                    self.totalSodiumMMOLPERBAG = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 62.0f, 68.0f, 22.0f)];
                    self.totalSodiumMMOLPERBAG.font = [UIFont systemFontOfSize:17.0f];
                    self.totalSodiumMMOLPERBAG.backgroundColor = [UIColor clearColor];
                    self.totalSodiumMMOLPERBAG.textAlignment = UITextAlignmentRight;
                    self.totalSodiumMMOLPERBAG.textColor = [UIColor grayColor];
                    [cell addSubview:self.totalSodiumMMOLPERBAG];
                    
                    UILabel *mmolPerBagLabel = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmolPerBagLabel.font = [UIFont systemFontOfSize:17.0f];
                    mmolPerBagLabel.backgroundColor = [UIColor clearColor];
                    mmolPerBagLabel.textAlignment = UITextAlignmentRight;
                    mmolPerBagLabel.textColor = [UIColor grayColor];
                    mmolPerBagLabel.text = @"mmol/500 ml)";
                    [cell addSubview:mmolPerBagLabel];
                    
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
                    self.totalSodiumSlider.value = naMMOLPerKgPerDay;
                    [self.totalSodiumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalSodiumSlider.continuous = YES;
                    
                    // format slider appearance
                    [self formatSliderAppearance:self.totalSodiumSlider];
                    
                    [cell addSubview:self.totalSodiumSlider];
                    
                    [self calculateInitialValuesForCellWithIdentifier:CellIdentifier];
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

                    self.totalPotassiumMMOLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 150.0f, 22.0f)];
                    self.totalPotassiumMMOLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalPotassiumMMOLPERKGPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalPotassiumMMOLPERKGPERDAY.textColor = [UIColor blackColor];
                    [cell addSubview:self.totalPotassiumMMOLPERKGPERDAY];
                    
                    UILabel *mmolPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 41.0f, 150.0f, 22.0f)];
                    mmolPerKgPerDay.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerKgPerDay.backgroundColor = [UIColor clearColor];
                    mmolPerKgPerDay.textAlignment = UITextAlignmentLeft;
                    mmolPerKgPerDay.textColor = [UIColor blackColor];
                    mmolPerKgPerDay.text = @"mmol/kg/day";
                    [cell addSubview:mmolPerKgPerDay];
                    
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(167.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];
                    
                    // mmol/day
                    self.totalPotassiumMMOLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 58.0f, 22.0f)];
                    self.totalPotassiumMMOLPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalPotassiumMMOLPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalPotassiumMMOLPERDAY.textAlignment = UITextAlignmentRight;
                    self.totalPotassiumMMOLPERDAY.textColor = [UIColor blackColor];
                    [cell addSubview:self.totalPotassiumMMOLPERDAY];
                    
                    UILabel *mmolPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 41.0f, 128.0f, 22.0f)];
                    mmolPerDayLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerDayLabel.backgroundColor = [UIColor clearColor];
                    mmolPerDayLabel.textAlignment = UITextAlignmentRight;
                    mmolPerDayLabel.textColor = [UIColor blackColor];
                    mmolPerDayLabel.text = @"mmol/day";
                    [cell addSubview:mmolPerDayLabel];

                    // mmol/500ml bag
                    self.totalPotassiumMMOLPERBAG = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 62.0f, 68.0f, 22.0f)];
                    self.totalPotassiumMMOLPERBAG.font = [UIFont systemFontOfSize:17.0f];
                    self.totalPotassiumMMOLPERBAG.backgroundColor = [UIColor clearColor];
                    self.totalPotassiumMMOLPERBAG.textAlignment = UITextAlignmentRight;
                    self.totalPotassiumMMOLPERBAG.textColor = [UIColor grayColor];
                    [cell addSubview:self.totalPotassiumMMOLPERBAG];
                    
                    UILabel *mmolPerBagLabel = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmolPerBagLabel.font = [UIFont systemFontOfSize:17.0f];
                    mmolPerBagLabel.backgroundColor = [UIColor clearColor];
                    mmolPerBagLabel.textAlignment = UITextAlignmentRight;
                    mmolPerBagLabel.textColor = [UIColor grayColor];
                    mmolPerBagLabel.text = @"mmol/500 ml)";
                    [cell addSubview:mmolPerBagLabel];
                    
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
                    self.totalPotassiumSlider.value = kMMOLPerKgPerDay;
                    [self.totalPotassiumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalPotassiumSlider.continuous = YES;
                    
                    // format slider appearance
                    [self formatSliderAppearance:self.totalPotassiumSlider];
                    
                    [cell addSubview:self.totalPotassiumSlider];
                    
                    [self calculateInitialValuesForCellWithIdentifier:CellIdentifier];
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

                    self.totalCalciumMMOLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, 150.0f, 22.0f)];
                    self.totalCalciumMMOLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalCalciumMMOLPERKGPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalCalciumMMOLPERKGPERDAY.textColor = [UIColor blackColor];
                    [cell addSubview:self.totalCalciumMMOLPERKGPERDAY];
                    
                    UILabel *mmolPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(58.0f, 41.0f, 150.0f, 22.0f)];
                    mmolPerKgPerDay.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerKgPerDay.backgroundColor = [UIColor clearColor];
                    mmolPerKgPerDay.textAlignment = UITextAlignmentLeft;
                    mmolPerKgPerDay.textColor = [UIColor blackColor];
                    mmolPerKgPerDay.text = @"mmol/kg/day";
                    [cell addSubview:mmolPerKgPerDay];
                    
                    UILabel *equals = [[UILabel alloc] initWithFrame:CGRectMake(167.0f, 40.0f, 10.0f, 22.0f)];
                    equals.font = [UIFont boldSystemFontOfSize:17.0f];
                    equals.backgroundColor = [UIColor clearColor];
                    equals.textColor = [UIColor blackColor];
                    equals.text = @"=";
                    [cell addSubview:equals];

                    // mmol/day
                    self.totalCalciumMMOLPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 40.0f, 58.0f, 22.0f)];
                    self.totalCalciumMMOLPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
                    self.totalCalciumMMOLPERDAY.backgroundColor = [UIColor clearColor];
                    self.totalCalciumMMOLPERDAY.textAlignment = UITextAlignmentRight;
                    self.totalCalciumMMOLPERDAY.textColor = [UIColor blackColor];
                    [cell addSubview:self.totalCalciumMMOLPERDAY];
                    
                    UILabel *mmolPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 41.0f, 128.0f, 22.0f)];
                    mmolPerDayLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                    mmolPerDayLabel.backgroundColor = [UIColor clearColor];
                    mmolPerDayLabel.textAlignment = UITextAlignmentRight;
                    mmolPerDayLabel.textColor = [UIColor blackColor];
                    mmolPerDayLabel.text = @"mmol/day";
                    [cell addSubview:mmolPerDayLabel];

                    self.totalCalciumMMOLPERBAG = [[UILabel alloc] initWithFrame:CGRectMake(125.0f, 62.0f, 68.0f, 22.0f)];
                    self.totalCalciumMMOLPERBAG.font = [UIFont systemFontOfSize:17.0f];
                    self.totalCalciumMMOLPERBAG.backgroundColor = [UIColor clearColor];
                    self.totalCalciumMMOLPERBAG.textAlignment = UITextAlignmentRight;
                    self.totalCalciumMMOLPERBAG.textColor = [UIColor grayColor];
                    [cell addSubview:self.totalCalciumMMOLPERBAG];
                    
                    UILabel *mmolPerBagLabel = [[UILabel alloc] initWithFrame:CGRectMake(145.0f, 62.0f, 155.0f, 22.0f)];
                    mmolPerBagLabel.font = [UIFont systemFontOfSize:17.0f];
                    mmolPerBagLabel.backgroundColor = [UIColor clearColor];
                    mmolPerBagLabel.textAlignment = UITextAlignmentRight;
                    mmolPerBagLabel.textColor = [UIColor grayColor];
                    mmolPerBagLabel.text = @"mmol/500 ml)";
                    [cell addSubview:mmolPerBagLabel];
                    
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
                    self.totalCalciumSlider.value = caMMOLPerKgPerDay;
                    [self.totalCalciumSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    self.totalCalciumSlider.continuous = YES;
                    
                    // format slider appearance
                    [self formatSliderAppearance:self.totalCalciumSlider];
                    
                    [cell addSubview:self.totalCalciumSlider];
                    
                    [self calculateInitialValuesForCellWithIdentifier:CellIdentifier];
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
        // handle slider
        [self incrementSlider:sender withInterval:5 withMinValue:40 andMaxValue:150];
        
        // update variable
        mlPerKgPerDay = sender.value;

        // calculate values
        [self calculateValuesWhenSliderChanged:sender];
    }
    else if ([sender isEqual:self.totalSodiumSlider])
    {
        // handle slider
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:15];
        
        // update variable
        naMMOLPerKgPerDay = sender.value;
        
        // calculate values
        [self calculateValuesWhenSliderChanged:sender];
    }
    else if ([sender isEqual:self.totalPotassiumSlider])
    {
        // handle slider
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:5];
        
        // update variable
        kMMOLPerKgPerDay = sender.value;
        
        // calculate values
        [self calculateValuesWhenSliderChanged:sender];
    }
    else if ([sender isEqual:self.totalCalciumSlider])
    {
        // handle slider
        [self incrementSlider:sender withInterval:0.5 withMinValue:0 andMaxValue:5];
        
        // update variable
        caMMOLPerKgPerDay = sender.value;
        
        // calculate values
        [self calculateValuesWhenSliderChanged:sender];
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

- (NSString *)formatResultWithDouble:(double)result maximumFractionDigits:(NSUInteger)digits
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
    formatter.maximumFractionDigits = digits;
    
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

    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        text.text = @"A weight is needed for this calculator.\n\nPlease go back and enter a weight or gestation, or select a patient.";
    }
    else
    {
        text.text = @"A weight is needed for this calculator.\n\nPlease go back and press the          \nbutton, or slide the image to the right,\nand enter a weight or gestation\nor select a patient.";
        
        UIImageView *plusButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusButton2.png"]];
        plusButton.frame = CGRectMake(270.0f, 36.0f, 40.0f, 40.0f);
        [instructions addSubview:plusButton];
    }
    
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
    
    [footerView addSubview:instructions];
    
    return footerView;
}

- (void)calculateInitialValuesForCellWithIdentifier:(NSString *)CellIdentifier
{
    if ([CellIdentifier isEqual:@"Total Fluid Volume"])
    {
        // ml/kg/day
        self.totalFluidsMLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ ml/kg/day", [self formatResultWithDouble:(double)mlPerKgPerDay maximumFractionDigits:0]];
        
        // ml/day
        mlPerDay = mlPerKgPerDay * workingWeightKGAsDouble;
        self.totalFluidsMLPERDAY.text = [NSString stringWithFormat:@"(%@", [self formatResultWithDouble:mlPerDay maximumFractionDigits:1]];
        
        // ml/hour
        mlPerHour = mlPerDay / 24;
        self.totalFluidsMLPERHOUR.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:mlPerHour maximumFractionDigits:1]];
    }
    else if ([CellIdentifier isEqual:@"Sodium"])
    {
        [self calculateSodiumCellValues];
    }
    else if ([CellIdentifier isEqual:@"Potassium"])
    {
        [self calculatePotassiumCellValues];
    }
    else if ([CellIdentifier isEqual:@"Calcium"])
    {
        [self calculateCalciumCellValues];
    }
}

- (void)calculateValuesWhenSliderChanged:(UISlider *)slider
{
    if ([slider isEqual:self.totalFluidSlider])
    {
        // ml/kg/day
        self.totalFluidsMLPERKGPERDAY.text = [NSString stringWithFormat:@"%@ ml/kg/day", [self formatResultWithDouble:(double)mlPerKgPerDay maximumFractionDigits:0]];
        
        // ml/day
        mlPerDay = mlPerKgPerDay * workingWeightKGAsDouble;
        self.totalFluidsMLPERDAY.text = [NSString stringWithFormat:@"(%@", [self formatResultWithDouble:mlPerDay maximumFractionDigits:1]];
        
        // ml/hour
        mlPerHour = mlPerDay / 24;
        self.totalFluidsMLPERHOUR.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:mlPerHour maximumFractionDigits:1]];
        
        [self calculateSodiumCellValues];
        [self calculatePotassiumCellValues];
        [self calculateCalciumCellValues];
    }
    else if ([slider isEqual:self.totalSodiumSlider])
    {
        [self calculateSodiumCellValues];
    }
    else if ([slider isEqual:self.totalPotassiumSlider])
    {
        [self calculatePotassiumCellValues];
    }
    else if ([slider isEqual:self.totalCalciumSlider])
    {
        [self calculateCalciumCellValues];
    }
}

- (void)calculateSodiumCellValues
{
    // mmol/kg/day
    self.totalSodiumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:naMMOLPerKgPerDay maximumFractionDigits:1]];
    
    // mmol/day
    naMMOLPerDay = naMMOLPerKgPerDay * workingWeightKGAsDouble;
    self.totalSodiumMMOLPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:naMMOLPerDay maximumFractionDigits:1]];
    
    // mmol/500ml
    naMMOLPerBag = (500 / mlPerDay) * naMMOLPerDay;
    self.totalSodiumMMOLPERBAG.text = [NSString stringWithFormat:@"(%@", [self formatResultWithDouble:naMMOLPerBag maximumFractionDigits:1]];
}

- (void)calculatePotassiumCellValues
{
    // mmol/kg/day
    self.totalPotassiumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:kMMOLPerKgPerDay maximumFractionDigits:1]];
    
    // mmol/day
    kMMOLPerDay = kMMOLPerKgPerDay * workingWeightKGAsDouble;
    self.totalPotassiumMMOLPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:kMMOLPerDay maximumFractionDigits:1]];
    
    // mmol/500ml
    kMMOLPerBag = (500 / mlPerDay) * kMMOLPerDay;
    self.totalPotassiumMMOLPERBAG.text = [NSString stringWithFormat:@"(%@", [self formatResultWithDouble:kMMOLPerBag maximumFractionDigits:1]];
}

- (void)calculateCalciumCellValues
{
    // mmol/kg/day
    self.totalCalciumMMOLPERKGPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:caMMOLPerKgPerDay maximumFractionDigits:1]];
    
    // mmol/day
    caMMOLPerDay = caMMOLPerKgPerDay * workingWeightKGAsDouble;
    self.totalCalciumMMOLPERDAY.text = [NSString stringWithFormat:@"%@", [self formatResultWithDouble:caMMOLPerDay maximumFractionDigits:1]];
    
    // mmol/500ml
    caMMOLPerBag = (500 / mlPerDay) * caMMOLPerDay;
    self.totalCalciumMMOLPERBAG.text = [NSString stringWithFormat:@"(%@", [self formatResultWithDouble:caMMOLPerBag maximumFractionDigits:1]];
}

#pragma mark - formatting methods

- (UISlider *)formatSliderAppearance:(UISlider *)slider
{
    // if iOS 7 then return default slider
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        
    }
    // if  iOS 5 or 6, then add anisotropic images to sliders
    else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.1)
    {
        UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
        UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
        [slider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
        [slider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
        
        UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
        [slider setThumbImage:initialImage forState:UIControlStateNormal];
        [slider setThumbImage:initialImage forState:UIControlStateHighlighted];
    }
    
    return slider;
}

@end
