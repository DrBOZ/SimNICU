//
//  HaematologyViewController.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HaematologyViewController.h"

@interface HaematologyViewController ()

@end

@implementation HaematologyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [CBTrackers logEvent:@"Haematology Data Entry"];
    
    self.title = NSLocalizedString(@"Add Result", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        self.view.tintColor = [UIColor redColor];
    }
    
    // Result date and time
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 300.0f, 200.0f)];
    [self.view addSubview:datePicker];
    
    UILabel *HbLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 300.0f, 50.0f, 22.0f)];
    HbLabel.text = NSLocalizedString(@"Hb", nil);
    [self.view addSubview:HbLabel];
    
    UITextField *HbTextField = [[UITextField alloc] initWithFrame:CGRectMake(50.0f, 300.0f, 70.0f, 22.0f)];
    HbTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    HbTextField.placeholder = NSLocalizedString(@"kilograms", nil);
    HbTextField.clearButtonMode = UITextFieldViewModeAlways;
    HbTextField.borderStyle = UITextBorderStyleRoundedRect;
    HbTextField.keyboardType = UIKeyboardTypeDecimalPad;
    HbTextField.textAlignment = UITextAlignmentLeft;
    // HbTextField.delegate = self;
    [self.view addSubview:HbTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark

- (void)done
{
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:5];
    
    /*
     // Maternal blood group
     NSString *resultsMaternalBloodGroup = nil;
     
     if (self.maternalBloodGroup.selectedSegmentIndex == 0)
     {
     resultsMaternalBloodGroup = @"AB";
     }
     else if (self.maternalBloodGroup.selectedSegmentIndex == 1)
     {
     resultsMaternalBloodGroup = @"A";
     }
     else if (self.maternalBloodGroup.selectedSegmentIndex == 2)
     {
     resultsMaternalBloodGroup = @"B";
     }
     else if (self.maternalBloodGroup.selectedSegmentIndex == 3)
     {
     resultsMaternalBloodGroup = @"O";
     }
     else
     {
     resultsMaternalBloodGroup = @"?";
     }
     
     [results addObject:resultsMaternalBloodGroup];
     
     // Maternal Rhesus D status
     NSString *resultsMaternalRhesus = nil;
     
     if (self.maternalRhesus.selectedSegmentIndex == 0)
     {
     resultsMaternalRhesus = @"Neg";
     }
     else if (self.maternalRhesus.selectedSegmentIndex == 1)
     {
     resultsMaternalRhesus = @"Pos";
     }
     else
     {
     resultsMaternalRhesus = @"?";
     }
     
     [results addObject:resultsMaternalRhesus];
     
     // Maternal antibodies
     NSString *resultsMaternalAntibodies = nil;
     
     if (self.maternalAntibodies.selectedSegmentIndex == 0)
     {
     resultsMaternalAntibodies = @" - no antibodies";
     }
     else if (self.maternalAntibodies.selectedSegmentIndex == 1)
     {
     resultsMaternalAntibodies = @" - antibodies present";
     }
     else
     {
     resultsMaternalAntibodies = @"?";
     }
     
     [results addObject:resultsMaternalAntibodies];
     
     // Baby blood group
     NSString *resultsBabyBloodGroup = nil;
     
     if (self.babyBloodGroup.selectedSegmentIndex == 0)
     {
     resultsBabyBloodGroup = @"AB";
     }
     else if (self.babyBloodGroup.selectedSegmentIndex == 1)
     {
     resultsBabyBloodGroup = @"A";
     }
     else if (self.babyBloodGroup.selectedSegmentIndex == 2)
     {
     resultsBabyBloodGroup = @"B";
     }
     else if (self.babyBloodGroup.selectedSegmentIndex == 3)
     {
     resultsBabyBloodGroup = @"O";
     }
     else
     {
     resultsBabyBloodGroup = @"?";
     }
     
     [results addObject:resultsBabyBloodGroup];
     
     // Baby Rhesus D status
     NSString *resultsBabyRhesus = nil;
     
     if (self.babyRhesus.selectedSegmentIndex == 0)
     {
     resultsBabyRhesus = @"Neg";
     }
     else if (self.babyRhesus.selectedSegmentIndex == 1)
     {
     resultsBabyRhesus = @"Pos";
     }
     else
     {
     resultsBabyRhesus = @"?";
     }
     
     [results addObject:resultsBabyRhesus];
     
     // Direct Coombs Test
     NSString *resultsDCT = nil;
     
     if (self.dct.selectedSegmentIndex == 0)
     {
     resultsDCT = @"negative";
     }
     else if (self.dct.selectedSegmentIndex == 1)
     {
     resultsDCT = @"positive";
     }
     else
     {
     resultsDCT = @"?";
     }
     
     [results addObject:resultsDCT];
     */
    
    [self.delegate haematologyViewControllerDidFinish:self withResults:results];
}

- (void)cancel
{
    [self.delegate haematologyViewControllerDidCancel:self];
}

@end
