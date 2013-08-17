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

@property (nonatomic, strong) UISlider *totalPotassiumSlider;
@property (nonatomic, strong) UISlider *totalSodiumSlider;
@property (nonatomic, strong) UISlider *totalFluidSlider;
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) UILabel *totalFluidsMLPERKGPERDAY;
@property (nonatomic, strong) UILabel *totalFluidsMLPERDAY;
@property (nonatomic, strong) UILabel *totalFluidsMLPERHOUR;

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
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, (appDelegate.window.bounds.size.height - 20.0f - 44.0f)) style:UITableViewStyleGrouped];
    
    self.myTableView.separatorColor = [UIColor grayColor];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = 50.0f;
    self.myTableView.bounces = YES;
    self.myTableView.scrollEnabled = YES;
    [self.view addSubview:self.myTableView];
    
    // add TableView background
    [CBDisplayMethods setBackgroundForTableView:self.myTableView];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 50.0f;
    
    if (indexPath.section == 0)
    {
        height = 110.0f;
    }
    else if (indexPath.section == 1)
    {
        height = 220.0f;
    }
    
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = nil;
    
    if (section == 0)
    {
        header = @"Total Fluid Volume";
    }
    else if (section == 1)
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
        }
        
        cell.textLabel.text = @"";
        
        // setup labels
        self.totalFluidsMLPERKGPERDAY = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 144.0f, 22.0f)];
        self.totalFluidsMLPERKGPERDAY.font = [UIFont boldSystemFontOfSize:17.0f];
        self.totalFluidsMLPERKGPERDAY.adjustsFontSizeToFitWidth = YES;
        self.totalFluidsMLPERKGPERDAY.textColor = [UIColor blackColor];
        self.totalFluidsMLPERKGPERDAY.backgroundColor = [UIColor clearColor];
        self.totalFluidsMLPERKGPERDAY.text = @"60 ml/kg/day";
        [cell addSubview:self.totalFluidsMLPERKGPERDAY];
        
        UILabel *equals1 = [[UILabel alloc] initWithFrame:CGRectMake(155.0f, 10.0f, 10.0f, 22.0f)];
        equals1.font = [UIFont boldSystemFontOfSize:17.0f];
        equals1.backgroundColor = [UIColor clearColor];
        equals1.textColor = [UIColor blackColor];
        equals1.text = @"=";
        [cell addSubview:equals1];
        
        UILabel *equals2 = [[UILabel alloc] initWithFrame:CGRectMake(155.0f, 30.0f, 10.0f, 22.0f)];
        equals2.font = [UIFont boldSystemFontOfSize:17.0f];
        equals2.backgroundColor = [UIColor clearColor];
        equals2.textColor = [UIColor blackColor];
        equals2.text = @"=";
        [cell addSubview:equals2];
        
        // setup slider for total fluids
        self.totalFluidSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 280.0f, 40.0f)];
        self.totalFluidSlider.minimumValue = 40.0f;
        self.totalFluidSlider.maximumValue = 150.0f;
        self.totalFluidSlider.value = 60.0f;
        [self.totalFluidSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.totalFluidSlider.continuous = YES;
        
        // if accelerometer add anisotropic image
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
        
        returnCell = cell;
    }
    else
    {
        CellIdentifier = @"Cell Identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        cell.textLabel.text = @"";
        
        returnCell = cell;
    }
    
    return returnCell;
}

#pragma mark - UITableView delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = indexPath;
    
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sliderValueChanged:(UISlider *)sender
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
    
    self.totalFluidsMLPERKGPERDAY.text = @"60 ml/kg/day";
    self.totalFluidsMLPERKGPERDAY.text = [NSString stringWithFormat:@"%i ml/kg/day", totalFluids];
}

@end
