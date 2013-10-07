//
//  BloodProductsTableViewCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BloodProductsTableViewCell.h"

@implementation BloodProductsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell
        self.backgroundColor = [UIColor whiteColor];
        
        // setup labels
        self.bloodProduct = [UILabel new];
        
        self.bloodProduct.adjustsFontSizeToFitWidth = YES;
        
        self.volume = [UILabel new];
        
        self.volume.textAlignment = UITextAlignmentRight;
        
        self.regimen = [UILabel new];
        
        self.regimen.adjustsFontSizeToFitWidth = YES;
        
        // iOS version differences
        CGFloat adjustment = 0.0f;
        
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) adjustment = -5.0f;
        
        self.bloodProduct.frame = CGRectMake(20.0f + adjustment, 9.0f, 177.0f, 21.0f);
        self.volume.frame = CGRectMake(200.0f + adjustment, 9.0f, 80.0f, 21.0f);
        self.regimen.frame = CGRectMake(20.0f + adjustment, 33.0f, 237.0f, 21.0f);
        
        [self addSubview:self.bloodProduct];
        [self addSubview:self.volume];
        [self addSubview:self.regimen];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
