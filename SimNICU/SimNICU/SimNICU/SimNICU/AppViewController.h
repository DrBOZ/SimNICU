//
//  AppViewController.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "EnterWeightViewController.h"
#import <UIKit/UIKit.h>
#import "GrowthChart.h"
#import "AppDelegate.h"
#import "Patient.h"

@interface AppViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EnterWeightViewControllerDelegate, BannerViewContainer, APGARTabBarControllerDelegate>

@property (nonatomic, strong) Patient *tempPatient;
@property (nonatomic, strong) NSString *gestation;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic) float *calculationWeight;

@end