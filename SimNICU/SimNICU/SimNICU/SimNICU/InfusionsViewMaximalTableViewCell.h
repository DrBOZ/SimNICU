//
//  InfusionsViewMaximalTableViewCell.h
//  SimNICU
//
//  Created by Conrad Bosman on 04/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "SVSegmentedControl.h"
#import <UIKit/UIKit.h>

@interface InfusionsViewMaximalTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *drugName;
@property (nonatomic, strong) UILabel *drugDose;
@property (nonatomic, strong) UILabel *drugStrength;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *diluent;
@property (nonatomic, strong) UILabel *drugDose2Label;
@property (nonatomic, strong) UILabel *drugRangeLabel;
@property (nonatomic, strong) SVSegmentedControl *drugStrengthSegmentedControl;

@end
