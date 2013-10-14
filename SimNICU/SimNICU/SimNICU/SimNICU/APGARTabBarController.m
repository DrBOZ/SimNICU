//
//  APGARTabBarController.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/07/2012.
//  Copyright (c) 2012 SimNICU. All rights reserved.
//

#import "EnterWeightViewController.h"
#import "APGARTabBarController.h"
#import "APGAR10ViewController.h"
#import "APGAR15ViewController.h"
#import "APGAR20ViewController.h"
#import "APGAR1ViewController.h"
#import "APGAR5ViewController.h"
#import "ZUUIRevealController.h"
#import "AppDelegate.h"

@interface APGARTabBarController ()

@property (nonatomic, strong) APGAR20ViewController *APGAR20minController;
@property (nonatomic, strong) APGAR15ViewController *APGAR15minController;
@property (nonatomic, strong) APGAR10ViewController *APGAR10minController;
@property (nonatomic, strong) APGAR5ViewController *APGAR5minController;
@property (nonatomic, strong) APGAR1ViewController *APGAR1minController;

@end

@implementation APGARTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"APGAR";
        
        NSLog(@"self.selectedPatient.APGAR1minColour = %@", self.selectedPatient.APGAR1minColour);
        
        // create APGARViewControllers
        APGAR1ViewController *newAPGAR1ViewController = [[APGAR1ViewController alloc] init];
        APGAR5ViewController *newAPGAR5ViewController = [[APGAR5ViewController alloc] init];
        APGAR10ViewController *newAPGAR10ViewController = [[APGAR10ViewController alloc] init];
        APGAR15ViewController *newAPGAR15ViewController = [[APGAR15ViewController alloc] init];
        APGAR20ViewController *newAPGAR20ViewController = [[APGAR20ViewController alloc] init];
        
        self.viewControllers = @[newAPGAR1ViewController, newAPGAR5ViewController, newAPGAR10ViewController, newAPGAR15ViewController, newAPGAR20ViewController];
        
        // setup 'save' button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAPGAR)];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        self.APGAR1minController = [self.viewControllers objectAtIndex:0];
        self.APGAR5minController = [self.viewControllers objectAtIndex:1];
        self.APGAR10minController = [self.viewControllers objectAtIndex:2];
        self.APGAR15minController = [self.viewControllers objectAtIndex:3];
        self.APGAR20minController = [self.viewControllers objectAtIndex:4];
        
        self.APGAR1minController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.APGAR5minController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.APGAR10minController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.APGAR15minController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
        self.APGAR20minController.tabBarItem.image = [UIImage imageNamed:@"clock.png"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CBTrackers logEvent:@"APGAR"];
}

- (void)viewWillAppear:(BOOL)animated
{
    // check if a patient is selected
    if (self.selectedPatient)
    {
        self.APGAR1minController.patient = self.selectedPatient;
        self.APGAR5minController.patient = self.selectedPatient;
        self.APGAR10minController.patient = self.selectedPatient;
        self.APGAR15minController.patient = self.selectedPatient;
        self.APGAR20minController.patient = self.selectedPatient;
        
        if (self.selectedPatient.APGAR1minColour && self.selectedPatient.APGAR1minHeartRate && self.selectedPatient.APGAR1minRespiratoryEffort && self.selectedPatient.APGAR1minTone && self.selectedPatient.APGAR1minReflexes)
        {
            int total;
            
            total = ([self.selectedPatient.APGAR1minColour intValue] + [self.selectedPatient.APGAR1minHeartRate intValue] + [self.selectedPatient.APGAR1minRespiratoryEffort intValue] + [self.selectedPatient.APGAR1minTone intValue] + [self.selectedPatient.APGAR1minReflexes intValue]);
            
            self.APGAR1minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR1minController.totalAPGARScore];
            self.APGAR1minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.selectedPatient.APGAR5minColour && self.selectedPatient.APGAR5minHeartRate && self.selectedPatient.APGAR5minRespiratoryEffort && self.selectedPatient.APGAR5minTone && self.selectedPatient.APGAR5minReflexes)
        {
            int total;
            
            total = ([self.selectedPatient.APGAR5minColour intValue] + [self.selectedPatient.APGAR5minHeartRate intValue] + [self.selectedPatient.APGAR5minRespiratoryEffort intValue] + [self.selectedPatient.APGAR5minTone intValue] + [self.selectedPatient.APGAR5minReflexes intValue]);
            
            self.APGAR5minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR5minController.totalAPGARScore];
            self.APGAR5minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.selectedPatient.APGAR10minColour && self.selectedPatient.APGAR10minHeartRate && self.selectedPatient.APGAR10minRespiratoryEffort && self.selectedPatient.APGAR10minTone && self.selectedPatient.APGAR10minReflexes)
        {
            int total;
            
            total = ([self.selectedPatient.APGAR10minColour intValue] + [self.selectedPatient.APGAR10minHeartRate intValue] + [self.selectedPatient.APGAR10minRespiratoryEffort intValue] + [self.selectedPatient.APGAR10minTone intValue] + [self.selectedPatient.APGAR10minReflexes intValue]);
            
            self.APGAR10minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR10minController.totalAPGARScore];
            self.APGAR10minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.selectedPatient.APGAR15minColour && self.selectedPatient.APGAR15minHeartRate && self.selectedPatient.APGAR15minRespiratoryEffort && self.selectedPatient.APGAR15minTone && self.selectedPatient.APGAR15minReflexes)
        {
            int total;
            
            total = ([self.selectedPatient.APGAR15minColour intValue] + [self.selectedPatient.APGAR15minHeartRate intValue] + [self.selectedPatient.APGAR15minRespiratoryEffort intValue] + [self.selectedPatient.APGAR15minTone intValue] + [self.selectedPatient.APGAR15minReflexes intValue]);
            
            self.APGAR15minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR15minController.totalAPGARScore];
            self.APGAR15minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.selectedPatient.APGAR20minColour && self.selectedPatient.APGAR20minHeartRate && self.selectedPatient.APGAR20minRespiratoryEffort && self.selectedPatient.APGAR20minTone && self.selectedPatient.APGAR20minReflexes)
        {
            int total;
            
            total = ([self.selectedPatient.APGAR20minColour intValue] + [self.selectedPatient.APGAR20minHeartRate intValue] + [self.selectedPatient.APGAR20minRespiratoryEffort intValue] + [self.selectedPatient.APGAR20minTone intValue] + [self.selectedPatient.APGAR20minReflexes intValue]);
            
            self.APGAR20minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR20minController.totalAPGARScore];
            self.APGAR20minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
    }
    else if (self.tempPatient)
    {
        self.APGAR1minController.patient = self.tempPatient;
        self.APGAR5minController.patient = self.tempPatient;
        self.APGAR10minController.patient = self.tempPatient;
        self.APGAR15minController.patient = self.tempPatient;
        self.APGAR20minController.patient = self.tempPatient;
        
        if (self.tempPatient.APGAR1minColour && self.tempPatient.APGAR1minHeartRate && self.tempPatient.APGAR1minRespiratoryEffort && self.tempPatient.APGAR1minTone && self.tempPatient.APGAR1minReflexes)
        {
            int total;
            
            total = ([self.tempPatient.APGAR1minColour intValue] + [self.tempPatient.APGAR1minHeartRate intValue] + [self.tempPatient.APGAR1minRespiratoryEffort intValue] + [self.tempPatient.APGAR1minTone intValue] + [self.tempPatient.APGAR1minReflexes intValue]);
            
            self.APGAR1minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR1minController.totalAPGARScore];
            self.APGAR1minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.tempPatient.APGAR5minColour && self.tempPatient.APGAR5minHeartRate && self.tempPatient.APGAR5minRespiratoryEffort && self.tempPatient.APGAR5minTone && self.tempPatient.APGAR5minReflexes)
        {
            int total;
            
            total = ([self.tempPatient.APGAR5minColour intValue] + [self.tempPatient.APGAR5minHeartRate intValue] + [self.tempPatient.APGAR5minRespiratoryEffort intValue] + [self.tempPatient.APGAR5minTone intValue] + [self.tempPatient.APGAR5minReflexes intValue]);
            
            self.APGAR5minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR5minController.totalAPGARScore];
            self.APGAR5minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.tempPatient.APGAR10minColour && self.tempPatient.APGAR10minHeartRate && self.tempPatient.APGAR10minRespiratoryEffort && self.tempPatient.APGAR10minTone && self.tempPatient.APGAR10minReflexes)
        {
            int total;
            
            total = ([self.tempPatient.APGAR10minColour intValue] + [self.tempPatient.APGAR10minHeartRate intValue] + [self.tempPatient.APGAR10minRespiratoryEffort intValue] + [self.tempPatient.APGAR10minTone intValue] + [self.tempPatient.APGAR10minReflexes intValue]);
            
            self.APGAR10minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR10minController.totalAPGARScore];
            self.APGAR10minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.tempPatient.APGAR15minColour && self.tempPatient.APGAR15minHeartRate && self.tempPatient.APGAR15minRespiratoryEffort && self.tempPatient.APGAR15minTone && self.tempPatient.APGAR15minReflexes)
        {
            int total;
            
            total = ([self.tempPatient.APGAR15minColour intValue] + [self.tempPatient.APGAR15minHeartRate intValue] + [self.tempPatient.APGAR15minRespiratoryEffort intValue] + [self.tempPatient.APGAR15minTone intValue] + [self.tempPatient.APGAR15minReflexes intValue]);
            
            self.APGAR15minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR15minController.totalAPGARScore];
            self.APGAR15minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
        if (self.tempPatient.APGAR20minColour && self.tempPatient.APGAR20minHeartRate && self.tempPatient.APGAR20minRespiratoryEffort && self.tempPatient.APGAR20minTone && self.tempPatient.APGAR20minReflexes)
        {
            int total;
            
            total = ([self.tempPatient.APGAR20minColour intValue] + [self.tempPatient.APGAR20minHeartRate intValue] + [self.tempPatient.APGAR20minRespiratoryEffort intValue] + [self.tempPatient.APGAR20minTone intValue] + [self.tempPatient.APGAR20minReflexes intValue]);
            
            self.APGAR20minController.totalAPGARScore = [NSString stringWithFormat:@"%i",total];
            
            NSString *icon;
            icon = [NSString stringWithFormat:@"APGAR%@.png", self.APGAR20minController.totalAPGARScore];
            self.APGAR20minController.tabBarItem.image = [UIImage imageNamed:icon];
        }
    }
}

- (void)viewDidUnload
{
    NSLog(@"APGARTabBarController viewDidUnload: unloaded properties");
    
    [super viewDidUnload];
    
    self.APGAR1minController = nil;
    self.APGAR5minController = nil;
    self.APGAR10minController = nil;
    self.APGAR15minController = nil;
    self.APGAR20minController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"APGARTabBarController didReceiveMemoryWarning");
    
    if ([self isViewLoaded] && self.view.window == nil)
    {
        NSLog(@"APGARTabBarController unloaded properties");
        
        self.APGAR1minController = nil;
        self.APGAR5minController = nil;
        self.APGAR10minController = nil;
        self.APGAR15minController = nil;
        self.APGAR20minController = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)saveAPGAR
{
    // check to see if there is tempPatient data first
    if (self.tempPatient)
    {
        [self assignAPGARValuesForPatient:self.tempPatient];
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"APGAR scores saved"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        // update saved patient data also
        [self.delegate2 APGARTabBarController:self updateAPGARValuesForTheNewPatient:self.tempPatient];
    }
    // if not check if there is a selected Patient
    else if (self.selectedPatient)
    {
        // save APGARS
        [self assignAPGARValuesForPatient:self.selectedPatient];
        
        // alert message
        if (self.selectedPatient.firstname && self.selectedPatient.lastname)
        {
            NSString *alertString = [NSString stringWithFormat:@"%@ %@", self.selectedPatient.firstname, self.selectedPatient.lastname];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:alertString
                                      message:@"APGAR scores saved"
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if (self.selectedPatient.lastname && !self.selectedPatient.firstname)
        {
            NSString *alertString = [NSString stringWithFormat:@"Baby %@", self.selectedPatient.lastname];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:alertString
                                      message:@"APGAR scores saved"
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if (self.selectedPatient.firstname && !self.selectedPatient.lastname)
        {
            NSString *alertString = [NSString stringWithFormat:@"Baby %@", self.selectedPatient.firstname];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:alertString
                                      message:@"APGAR scores saved"
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else // create new patient and create tempPatient data
    {
        // create new patient
        Patient *newPatient = [[Patient alloc] init];
        
        [self assignAPGARValuesForPatient:newPatient];
        
        // create new patient in patientList
        [self.delegate2 APGARTabBarController:self didFinishEnteringAPGARValuesForANewPatient:newPatient];
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"APGAR scores saved"
                                  message:@"New patient created in Patient List"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
        // create a temporary patient
        self.tempPatient = [[Patient alloc] init];
        
        // save APGARS
        [self assignAPGARValuesForPatient:self.tempPatient];
        
        // delegate method
        [self.delegateAppVC APGARTabBarController:self didFinishEnteringAPGARValuesForANewPatient:self.tempPatient];
    }
}

- (void)assignAPGARValuesForPatient:(Patient *)patient
{
    // the conditional statements here are to prevent uninitialised VC data overwriting existing patient data
    //
    if (self.APGAR1minController.scoreColour.text) patient.APGAR1minColour = self.APGAR1minController.scoreColour.text;
    if (self.APGAR1minController.scoreHeartRate.text) patient.APGAR1minHeartRate = self.APGAR1minController.scoreHeartRate.text;
    if (self.APGAR1minController.scoreRespiratoryEffort.text) patient.APGAR1minRespiratoryEffort = self.APGAR1minController.scoreRespiratoryEffort.text;
    if (self.APGAR1minController.scoreTone.text) patient.APGAR1minTone = self.APGAR1minController.scoreTone.text;
    if (self.APGAR1minController.scoreReflexes.text) patient.APGAR1minReflexes = self.APGAR1minController.scoreReflexes.text;
    
    if (self.APGAR5minController.scoreColour.text) patient.APGAR5minColour = self.APGAR5minController.scoreColour.text;
    if (self.APGAR5minController.scoreHeartRate.text) patient.APGAR5minHeartRate = self.APGAR5minController.scoreHeartRate.text;
    if (self.APGAR5minController.scoreRespiratoryEffort.text) patient.APGAR5minRespiratoryEffort = self.APGAR5minController.scoreRespiratoryEffort.text;
    if (self.APGAR5minController.scoreTone.text) patient.APGAR5minTone = self.APGAR5minController.scoreTone.text;
    if (self.APGAR5minController.scoreReflexes.text) patient.APGAR5minReflexes = self.APGAR5minController.scoreReflexes.text;
    
    if (self.APGAR10minController.scoreColour.text) patient.APGAR10minColour = self.APGAR10minController.scoreColour.text;
    if (self.APGAR10minController.scoreHeartRate.text) patient.APGAR10minHeartRate = self.APGAR10minController.scoreHeartRate.text;
    if (self.APGAR10minController.scoreRespiratoryEffort.text) patient.APGAR10minRespiratoryEffort = self.APGAR10minController.scoreRespiratoryEffort.text;
    if (self.APGAR10minController.scoreTone.text) patient.APGAR10minTone = self.APGAR10minController.scoreTone.text;
    if (self.APGAR10minController.scoreReflexes.text) patient.APGAR10minReflexes = self.APGAR10minController.scoreReflexes.text;
    
    if (self.APGAR15minController.scoreColour.text) patient.APGAR15minColour = self.APGAR15minController.scoreColour.text;
    if (self.APGAR15minController.scoreHeartRate.text) patient.APGAR15minHeartRate = self.APGAR15minController.scoreHeartRate.text;
    if (self.APGAR15minController.scoreRespiratoryEffort.text) patient.APGAR15minRespiratoryEffort = self.APGAR15minController.scoreRespiratoryEffort.text;
    if (self.APGAR15minController.scoreTone.text) patient.APGAR15minTone = self.APGAR15minController.scoreTone.text;
    if (self.APGAR15minController.scoreReflexes.text) patient.APGAR15minReflexes = self.APGAR15minController.scoreReflexes.text;
    
    if (self.APGAR20minController.scoreColour.text) patient.APGAR20minColour = self.APGAR20minController.scoreColour.text;
    if (self.APGAR20minController.scoreHeartRate.text) patient.APGAR20minHeartRate = self.APGAR20minController.scoreHeartRate.text;
    if (self.APGAR20minController.scoreRespiratoryEffort.text) patient.APGAR20minRespiratoryEffort = self.APGAR20minController.scoreRespiratoryEffort.text;
    if (self.APGAR20minController.scoreTone.text) patient.APGAR20minTone = self.APGAR20minController.scoreTone.text;
    if (self.APGAR20minController.scoreReflexes.text) patient.APGAR20minReflexes = self.APGAR20minController.scoreReflexes.text;
}

@end
