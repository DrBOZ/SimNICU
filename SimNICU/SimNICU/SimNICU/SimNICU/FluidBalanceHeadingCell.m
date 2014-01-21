//
//  FluidBalanceHeadingCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 0.0f

#define MLPERDAY_X 205.0f

#import "FluidBalanceHeadingCell.h"

@interface FluidBalanceHeadingCell ()

@property (nonatomic, strong) UILabel *mlPerDay;
@property (nonatomic, strong) UILabel *mlPerKgPerDay;

@end

@implementation FluidBalanceHeadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.heading = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 185.0f, 22.0f)];
        self.heading.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.heading];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if ([self.heading.text isEqualToString:@"INPUT"])
    {
        if (!self.mlPerDay)
        {
            self.mlPerDay = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            self.mlPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            self.mlPerDay.text = @"ml";
            [self.contentView addSubview:self.mlPerDay];
        }
        
        if (!self.mlPerKgPerDay)
        {
            self.mlPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(260.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            self.mlPerKgPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            self.mlPerKgPerDay.text = @"ml/kg";
            [self.contentView addSubview:self.mlPerKgPerDay];
        }
    }
    else if (!([self.heading.text isEqualToString:@"OUTPUT"] || [self.heading.text isEqualToString:@"BALANCE"]))
    {
        // must be date heading, so display working weight
        if (!self.workingWeight)
        {
            self.workingWeight = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y, 80.0f, 22.0f)];
            self.workingWeight.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.workingWeight];
        }
    }
}

@end
