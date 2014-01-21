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
#define MLPERKGPERDAY_X 260.0f

#import "FluidBalanceFluidCell.h"

@interface FluidBalanceFluidCell ()

@property (nonatomic, strong) UILabel *drawTotalLine1;
@property (nonatomic, strong) UILabel *drawTotalLine2;
@property (nonatomic, strong) UILabel *drawDoubleTotalLine1;
@property (nonatomic, strong) UILabel *drawDoubleTotalLine2;

@end

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
        
        self.mlPerKgPerDay = [[UILabel alloc] initWithFrame:CGRectMake(MLPERKGPERDAY_X, DEFAULT_TEXT_Y, 60.0f, 22.0f)];
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
        
        if (!self.drawTotalLine1)
        {
            // set length of ml/day total line
            double mlPerDay = [self.mlPerDay.text doubleValue];
            if (mlPerDay < 10) totalLine = @"__";
            if (mlPerDay < 100) totalLine = @"____";
            else totalLine = @"_______";
            
            self.drawTotalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y - 15.0f, 50.0f, 22.0f)];
            self.drawTotalLine1.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
            self.drawTotalLine1.text = totalLine;
            [self.contentView addSubview:self.drawTotalLine1];
        }
        
        if (!self.drawTotalLine2)
        {
            // set length of ml/kg/day total line
            double mlPerKgPerDay = [self.mlPerKgPerDay.text doubleValue];
            if (mlPerKgPerDay < 10) totalLine = @"__";
            if (mlPerKgPerDay < 100) totalLine = @"____";
            else totalLine = @"_______";
            
            self.drawTotalLine2 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERKGPERDAY_X, DEFAULT_TEXT_Y - 15.0f, 50.0f, 22.0f)];
            self.drawTotalLine2.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
            self.drawTotalLine2.text = totalLine;
            [self.contentView addSubview:self.drawTotalLine2];
        }
    }
    else if (self.drawDoubleTotalLines)
    {
        NSString *totalLine;
        
        if (!self.drawTotalLine1 || !self.drawDoubleTotalLine1)
        {
            // set length of ml/day total line
            double mlPerDay = [self.mlPerDay.text doubleValue];
            if (mlPerDay < 10) totalLine = @"__";
            if (mlPerDay < 100) totalLine = @"_____";
            else totalLine = @"_______";
            
            if (!self.drawTotalLine1)
            {
                self.drawTotalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y - 16.0f, 50.0f, 22.0f)];
                self.drawTotalLine1.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
                self.drawTotalLine1.text = totalLine;
                [self.contentView addSubview:self.drawTotalLine1];
            }
            
            if (!self.drawDoubleTotalLine1)
            {
                self.drawDoubleTotalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERDAY_X, DEFAULT_TEXT_Y - 14.0f, 50.0f, 22.0f)];
                // drawTotalLine1.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
                self.drawDoubleTotalLine1.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
                self.drawDoubleTotalLine1.text = totalLine;
                [self.contentView addSubview:self.drawDoubleTotalLine1];
            }
        }
        
        if (!self.drawTotalLine2 || !self.drawDoubleTotalLine2)
        {
            // set length of ml/kg/day total line
            double mlPerKgPerDay = [self.mlPerKgPerDay.text doubleValue];
            if (mlPerKgPerDay < 10) totalLine = @"__";
            if (mlPerKgPerDay < 100) totalLine = @"_____";
            else totalLine = @"_______";
            
            if (!self.drawTotalLine2)
            {
                self.drawTotalLine2 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERKGPERDAY_X, DEFAULT_TEXT_Y - 16.0f, 50.0f, 22.0f)];
                self.drawTotalLine2.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
                self.drawTotalLine2.text = totalLine;
                [self.contentView addSubview:self.drawTotalLine2];
            }
            
            if (!self.drawDoubleTotalLine2)
            {
                self.drawDoubleTotalLine2 = [[UILabel alloc] initWithFrame:CGRectMake(MLPERKGPERDAY_X, DEFAULT_TEXT_Y - 14.0f, 50.0f, 22.0f)];
                self.drawDoubleTotalLine2.font = [UIFont boldSystemFontOfSize:DEFAULT_TEXT_FONT];
                self.drawDoubleTotalLine2.text = totalLine;
                [self.contentView addSubview:self.drawDoubleTotalLine2];
            }
        }
    }
}

@end
