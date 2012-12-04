//
//  ResusViewTableViewCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "ResusViewTableViewCell.h"

@implementation ResusViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
- (UILabel *)drug
{
    if (!_drug)
    {
        _drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 259.0f, 22.0f)];
        _drug.font = [UIFont boldSystemFontOfSize:17.0f];
        _drug.adjustsFontSizeToFitWidth = YES;
        _drug.textColor = [UIColor blackColor];
        _drug.backgroundColor = [UIColor clearColor];
    }
    
    return _drug;
}
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

/*
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 [cell setBackgroundColor:[UIColor whiteColor]];
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
 drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 259.0f, 22.0f)];
 drug.font = [UIFont boldSystemFontOfSize:17.0f];
 drug.adjustsFontSizeToFitWidth = YES;
 drug.textColor = [UIColor blackColor];
 drug.backgroundColor = [UIColor clearColor];
 dose = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 57.0f, 188.0f, 21.0f)];
 dose.font = [UIFont boldSystemFontOfSize:17.0f];
 dose.backgroundColor = [UIColor clearColor];
 equals = [[UILabel alloc] initWithFrame:CGRectMake(24.0f, 56.0f, 37.0f, 21.0f)];
 equals.textColor = [UIColor lightGrayColor];
 equals.backgroundColor = [UIColor clearColor];
 equals.textAlignment = UITextAlignmentRight;
 equals.text = @"=";
 equals.hidden = YES;
 subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 28.0f, 259.0f, 26.0f)];
 subLabel2.textColor = [UIColor lightGrayColor];
 subLabel2.font = [UIFont systemFontOfSize:14.0f];
 subLabel2.backgroundColor = [UIColor clearColor];
 subLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 76.0f, 230.0f, 21.0f)];
 subLabel3.textColor = [UIColor lightGrayColor];
 subLabel3.backgroundColor = [UIColor clearColor];
 subLabel3.adjustsFontSizeToFitWidth = YES;
 subLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(69.0f, 96.0f, 230.0f, 21.0f)];
 subLabel4.textColor = [UIColor lightGrayColor];
 subLabel4.backgroundColor = [UIColor clearColor];
 subLabel4.adjustsFontSizeToFitWidth = YES;
 
 [cell addSubview:drug];
 [cell addSubview:dose];
 [cell addSubview:equals];
 [cell addSubview:subLabel2];
 [cell addSubview:subLabel3];
 [cell addSubview:subLabel4];
 
 */