//
//  AddFluidCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 03/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "AddFluidCell.h"

@implementation AddFluidCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
