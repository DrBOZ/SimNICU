//
//  AgeResultsCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 19/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "AgeResultsCell.h"

@implementation AgeResultsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.ageTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 10.0f, 200.0f, 30.0f)];
        self.ageTextLabel.textAlignment = UITextAlignmentLeft;
        self.ageTextLabel.backgroundColor = [UIColor clearColor];
        self.ageTextLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [CBFonts textFormattingForLabel:self.ageTextLabel withTextStyle:UIFontTextStyleBody minFontSize:14.0f];
        
        [self addSubview:self.ageTextLabel];
        
        // they are the opposite way round, because I initially started with age in words at the top
        // but they moved the UITableViewCell textLabel to the top and they collided
        //
        self.label5 = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 10.0f, 200.0f, 30.0f)];
        self.label4 = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 20.0f, 200.0f, 30.0f)];
        self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 40.0f, 200.0f, 30.0f)];
        self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 60.0f, 200.0f, 30.0f)];
        self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 280.0f, 30.0f)];
        
        self.label1.textAlignment = UITextAlignmentRight;
        self.label2.textAlignment = UITextAlignmentRight;
        self.label3.textAlignment = UITextAlignmentRight;
        self.label4.textAlignment = UITextAlignmentRight;
        self.label5.textAlignment = UITextAlignmentRight;
        
        self.label1.backgroundColor = [UIColor clearColor];
        self.label2.backgroundColor = [UIColor clearColor];
        self.label3.backgroundColor = [UIColor clearColor];
        self.label4.backgroundColor = [UIColor clearColor];
        self.label5.backgroundColor = [UIColor clearColor];
        
        self.label1.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        self.label2.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        self.label3.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        self.label4.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        self.label5.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
        
        self.label1.adjustsFontSizeToFitWidth = YES;
        self.label2.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:self.label1];
        [self addSubview:self.label2];
        [self addSubview:self.label3];
        [self addSubview:self.label4];
        [self addSubview:self.label5];
        
        self.detailTextLabel.hidden = YES;
        
        if (style == UITableViewCellStyleSubtitle)
        {
            self.label1.font = [UIFont boldSystemFontOfSize:17.0f];
            self.label2.font = [UIFont boldSystemFontOfSize:17.0f];
            self.label3.font = [UIFont boldSystemFontOfSize:17.0f];
            self.label4.font = [UIFont boldSystemFontOfSize:17.0f];
            self.label5.font = [UIFont boldSystemFontOfSize:17.0f];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
