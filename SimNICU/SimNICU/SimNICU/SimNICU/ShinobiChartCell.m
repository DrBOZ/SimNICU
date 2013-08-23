//
//  ShinobiChartCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "ShinobiChartCell.h"

@implementation ShinobiChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *testing = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 200.0f, 22.0f)];
        testing.backgroundColor = [UIColor purpleColor];
        [self addSubview:testing];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
