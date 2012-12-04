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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end