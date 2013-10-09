//
//  VitKTableViewCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "VitKTableViewCell.h"

@implementation VitKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.weight = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 13.0f, 182.0f, 22.0f)];
        [CBFonts textFormattingForLabel:self.weight withTextStyle:UIFontTextStyleBody minFontSize:18.0f];
        self.weight.textColor = [UIColor blackColor];
        
        self.vitK = [[UILabel alloc] initWithFrame:CGRectMake(42.0f, 35.0f, 228.0f, 50.0f)];
        [CBFonts textFormattingForLabel:self.vitK withTextStyle:UIFontTextStyleFootnote minFontSize:17.0f];
        self.vitK.textColor = [UIColor lightGrayColor];
        
        // long debate regarding the fonts for this App
        // acknowledge the need for consistent fonts throughout the App
        
        // originals...
        // self.weight.font = [UIFont boldSystemFontOfSize:18.0f];
        // self.vitK.font = [UIFont systemFontOfSize:17.0f];
        
        [self addSubview:self.weight];
        [self addSubview:self.vitK];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
