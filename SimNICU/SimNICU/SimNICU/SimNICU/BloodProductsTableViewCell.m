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
        self.bloodProduct = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 9.0f, 177.0f, 21.0f)];
        [CBFonts textFormattingForLabel:self.bloodProduct];
        self.bloodProduct.adjustsFontSizeToFitWidth = YES;
        
        self.volume = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 9.0f, 80.0f, 21.0f)];
        [CBFonts textFormattingForLabel:self.volume];
        self.volume.textAlignment = UITextAlignmentRight;
        
        self.regimen = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 33.0f, 237.0f, 21.0f)];
        [CBFonts detailTextFormattingForLabel:self.regimen];
        self.regimen.adjustsFontSizeToFitWidth = YES;
        
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
