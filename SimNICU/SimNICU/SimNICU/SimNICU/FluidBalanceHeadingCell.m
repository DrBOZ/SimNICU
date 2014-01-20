//
//  FluidBalanceHeadingCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 0.0f

#import "FluidBalanceHeadingCell.h"

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
        UILabel *mlPerDay = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
        mlPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        mlPerDay.text = @"ml";
        [self.contentView addSubview:mlPerDay];
        
        UILabel *mlPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(255.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
        mlPerKgPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        mlPerKgPerDay.text = @"ml/kg";
        [self.contentView addSubview:mlPerKgPerDay];
    }
}

@end
