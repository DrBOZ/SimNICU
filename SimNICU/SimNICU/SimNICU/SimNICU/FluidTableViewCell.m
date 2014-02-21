//
//  FluidTableViewCell.m
//  Neonatal Intensive Care
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
        // set cell selection style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // setup fluid type/name textfield
        self.fluidName = [UITextField new];
        self.fluidName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.fluidName.autocorrectionType = UITextAutocorrectionTypeNo;
        self.fluidName.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.fluidName.frame = CGRectMake(14.0f, 0.0f, 200.0f, 30.0f);
        self.fluidName.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.fluidName.keyboardType = UIKeyboardTypeAlphabet;
        self.fluidName.textAlignment = UITextAlignmentLeft;
        self.fluidName.borderStyle = UITextBorderStyleNone;
        self.fluidName.font = [UIFont systemFontOfSize:19.0f];
        self.fluidName.adjustsFontSizeToFitWidth = YES;
        self.fluidName.returnKeyType = UIReturnKeyDone;
        
        [self.contentView addSubview:self.fluidName];
        
        self.mlPerKgPerDay = [UILabel new];
        self.mlPerKgPerDay.frame = CGRectMake(14.0f, 18.0f, 150.0f, 30.0f);
        self.mlPerKgPerDay.font = [UIFont systemFontOfSize:12.0f];
        
        [self.contentView addSubview:self.mlPerKgPerDay];
        
        // setup ml/day textfield
        self.mlPerDay = [UITextField new];
        self.mlPerDay.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.mlPerDay.placeholder = [CBStringMethods localisedString:@"ml/day"];
        self.mlPerDay.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.mlPerDay.frame = CGRectMake(230.0f, 8.0f, 80.0f, 30.0f);
        self.mlPerDay.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.mlPerDay.borderStyle = UITextBorderStyleRoundedRect;
        self.mlPerDay.keyboardType = UIKeyboardTypeDecimalPad;
        self.mlPerDay.textAlignment = UITextAlignmentLeft;
        self.mlPerDay.adjustsFontSizeToFitWidth = YES;
        
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
