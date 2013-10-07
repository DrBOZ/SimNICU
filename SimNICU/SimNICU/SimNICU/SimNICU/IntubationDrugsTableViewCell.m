//
//  IntubationDrugsTableViewCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 04/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "IntubationDrugsTableViewCell.h"

@implementation IntubationDrugsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.drug = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 7.0f, 108.0f, 21.0f)];
        self.drug.font = [UIFont boldSystemFontOfSize:18.0f];
        self.drug.adjustsFontSizeToFitWidth = YES;
        self.drug.textColor = [UIColor blackColor];
        self.drug.backgroundColor = [UIColor clearColor];
        
        self.dose = [[UILabel alloc] initWithFrame:CGRectMake(154.0f, 7.0f, 152.0f, 21.0f)];
        self.dose.font = [UIFont boldSystemFontOfSize:17.0f];
        self.dose.adjustsFontSizeToFitWidth = YES;
        self.dose.backgroundColor = [UIColor clearColor];
        
        self.subLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 27.0f, 248.0f, 21.0f)];
        self.subLabel2.textColor = [UIColor lightGrayColor];
        self.subLabel2.font = [UIFont systemFontOfSize:14.0f];
        self.subLabel2.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.drug];
        [self addSubview:self.dose];
        [self addSubview:self.subLabel2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
