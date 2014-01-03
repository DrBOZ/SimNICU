//
//  FluidTableViewCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 02/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "FluidTableViewCell.h"

@implementation FluidTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.mlPerDay = [UITextField new];
        self.mlPerDay.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.mlPerDay.clearButtonMode = UITextFieldViewModeNever;
        self.mlPerDay.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.mlPerDay.frame = CGRectMake(230.0f, 8.0f, 80.0f, 30.0f);
        self.mlPerDay.borderStyle = UITextBorderStyleRoundedRect;
        self.mlPerDay.keyboardType = UIKeyboardTypeDecimalPad;
        self.mlPerDay.textAlignment = UITextAlignmentLeft;
        self.mlPerDay.adjustsFontSizeToFitWidth = YES;
        self.mlPerDay.placeholder = [CBStringMethods localisedString:@"ml/day"];
        
        [self.contentView addSubview:self.mlPerDay];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
