//
//  BloodResultTableViewCell.m
//  SimNICU
//
//  Created by Conrad Bosman on 08/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "BloodResultTableViewCell.h"

@implementation BloodResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([reuseIdentifier isEqualToString:@"FBC Result"])
        {
            UILabel *Hb = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 3.0f, 50.0f, 22.0f)];
            Hb.font = [UIFont systemFontOfSize:14.0f];
            Hb.text = NSLocalizedString(@"Hb", nil);
            [self.contentView addSubview:Hb];
            
            UILabel *tempHbResult = [[UILabel alloc] initWithFrame:CGRectMake(38.0f, 3.0f, 50.0f, 22.0f)];
            tempHbResult.font = [UIFont systemFontOfSize:14.0f];
            tempHbResult.text = @"126";
            [self.contentView addSubview:tempHbResult];
            
            UILabel *WCC = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, 3.0f, 50.0f, 22.0f)];
            WCC.font = [UIFont systemFontOfSize:14.0f];
            WCC.text = NSLocalizedString(@"WCC", nil);
            [self.contentView addSubview:WCC];
            
            UILabel *tempWCCResult = [[UILabel alloc] initWithFrame:CGRectMake(104.0f, 3.0f, 50.0f, 22.0f)];
            tempWCCResult.font = [UIFont systemFontOfSize:14.0f];
            tempWCCResult.text = @"17.4";
            [self.contentView addSubview:tempWCCResult];
            
            UILabel *Plats = [[UILabel alloc] initWithFrame:CGRectMake(136.0f, 3.0f, 50.0f, 22.0f)];
            Plats.font = [UIFont systemFontOfSize:14.0f];
            Plats.text = NSLocalizedString(@"Plats", nil);
            [self.contentView addSubview:Plats];
            
            UILabel *tempPlatsResult = [[UILabel alloc] initWithFrame:CGRectMake(172.0f, 3.0f, 50.0f, 22.0f)];
            tempPlatsResult.font = [UIFont systemFontOfSize:14.0f];
            tempPlatsResult.text = @"415";
            [self.contentView addSubview:tempPlatsResult];
            
            UILabel *TempDate = [[UILabel alloc] initWithFrame:CGRectMake(225.0f, 3.0f, 100.0f, 22.0f)];
            TempDate.font = [UIFont systemFontOfSize:14.0f];
            TempDate.text = @"(08/12 07:15)";
            [self.contentView addSubview:TempDate];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

@end
