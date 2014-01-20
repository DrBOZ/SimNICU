//
//  FluidBalanceFluidCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 0.0f

#define MLPERDAY_X 205.0f

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
        
        self.mlPerDay = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
        self.mlPerDay.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.mlPerDay];
        
        self.mlPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(260.0f, DEFAULT_TEXT_Y, 60.0f, 22.0f)];
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
        NSString *totalLine;
        
        NSLog(@"total = %@", self.mlPerDay.text);
        
        // set length of total line
        double mlPerDay = [self.mlPerDay.text doubleValue];
        if (mlPerDay < 10) totalLine = @"__";
        if (mlPerDay < 100) totalLine = @"____";
        else totalLine = @"_______";
        
        UILabel *drawTotalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y - 15.0f, 50.0f, 22.0f)];
        // drawTotalLine1.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        drawTotalLine1.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
        drawTotalLine1.text = totalLine;
        [self.contentView addSubview:drawTotalLine1];
    }
}

@end
