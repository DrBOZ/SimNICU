//
//  SuggestionTableViewCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/02/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 4.0f

#import "SuggestionTableViewCell.h"

@implementation SuggestionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.noSuggestions = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 300.0f - 15.0f, 22.0f)];
        self.noSuggestions.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.noSuggestions];
        
        self.suggestionNumber = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 20.0f, 22.0f)];
        self.suggestionNumber.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
        [self.contentView addSubview:self.suggestionNumber];
        
        self.suggestion = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 3.0f, 300.0f - 35.0f, 22.0f)];
        self.suggestion.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.suggestion];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
