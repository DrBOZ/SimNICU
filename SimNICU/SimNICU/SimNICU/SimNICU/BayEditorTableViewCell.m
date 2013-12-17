//
//  BayEditorTableViewCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 05/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BayEditorTableViewCell.h"

@implementation BayEditorTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textField = [[UITextField alloc] init];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.frame = CGRectMake(10.0f, 5.0f, 220.0f, 33.0f);
        self.textField.font = [UIFont systemFontOfSize:17.0f];
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:self.textField];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
