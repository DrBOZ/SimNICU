//
//  FluidBalanceFluidCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 0.0f

#import "FluidBalanceFluidCell.h"

@implementation FluidBalanceFluidCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        self.fluidName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 185.0f, 22.0f)];
        self.fluidName.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.fluidName];
        
        self.mlPerDay = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
        self.mlPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.mlPerDay];
        
        self.mlPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(255.0f, DEFAULT_TEXT_Y, 60.0f, 22.0f)];
        self.mlPerKgPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.mlPerKgPerDay];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (self.drawTotalLines)
    {
        UILabel *drawTotalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y - 15.0f, 50.0f, 22.0f)];
        // drawTotalLine1.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        drawTotalLine1.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
        drawTotalLine1.text = @"____";
        [self.contentView addSubview:drawTotalLine1];
    }
}

@end
