//
//  AppViewController.h
//  SimNICU
//
//  Created by Conrad Bosman on 23/05/2012.
//  Copyright (c) 2012 SimNICU Project. All rights reserved.
//

#import "EnterWeightViewController.h"
#import <UIKit/UIKit.h>
#import "GrowthChart.h"

@interface AppViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EnterWeightViewControllerDelegate>

@property (nonatomic, strong) UIImageView *displayDismissButtonView;
@property (nonatomic, strong) UILabel *displayDetailTextLabel;
@property (nonatomic, strong) UILabel *displayBackground;
@property (nonatomic, strong) UIImageView *appImageView;
@property (nonatomic, strong) UILabel *displayTextLabel;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIView *myHeaderView;
@property (nonatomic, strong) NSString *gestation;
@property (nonatomic, strong) UIImage *appImage;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic) float *calculationWeight;

@end