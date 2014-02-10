//
//  SuggestionTableViewCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 10/02/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *noSuggestions;
@property (nonatomic, strong) UILabel *suggestionNumber;
@property (nonatomic, strong) UILabel *suggestion;

@end
