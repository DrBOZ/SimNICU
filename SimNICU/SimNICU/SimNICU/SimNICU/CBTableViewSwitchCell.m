//
//  CBTableViewSwitchCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 19/02/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import "CBTableViewSwitchCell.h"

@implementation CBTableViewSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 20.0f, 20.0f)];
        
        // iOS 7 specifics
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
        {
            self.toggleSwitch.onTintColor = [UIColor redColor];
        }
        
        self.accessoryView = self.toggleSwitch;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
