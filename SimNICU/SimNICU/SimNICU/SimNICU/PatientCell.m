//
//  PatientCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 20/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "PatientCell.h"

@implementation PatientCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // resize any subviews here
    // self.imageView.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    // self.imageView.bounds = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    
    self.imageView.frame = CGRectMake(0.0f, 0.0f, 20.0f, 49.0f);
    // self.imageView.bounds = CGRectMake(0.0f, -2.0f, 20.0f, 50.0f);
    
    if (self.textLabel.frame.origin.x > 10)
    {
        self.textLabel.frame = CGRectMake(25.0f, 5.0f, 175.0f, 22.0f);
        self.detailTextLabel.frame = CGRectMake(25, 28.0f, 175, 18.0f);
    }
    
    // NSLog(@"x %f", self.detailTextLabel.frame.origin.x);
    // NSLog(@"y %f", self.detailTextLabel.frame.origin.y);
    // NSLog(@"w %f", self.detailTextLabel.frame.size.width);
    // NSLog(@"h %f", self.detailTextLabel.frame.size.height);
}

@end
