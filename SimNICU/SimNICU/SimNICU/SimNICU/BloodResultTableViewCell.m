//
//  BloodResultTableViewCell.m
//  Neonatal Intensive Care
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
            
            self.HbResult = [[UILabel alloc] initWithFrame:CGRectMake(38.0f, 3.0f, 50.0f, 22.0f)];
            self.HbResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.HbResult];
            
            UILabel *WCC = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, 3.0f, 50.0f, 22.0f)];
            WCC.font = [UIFont systemFontOfSize:14.0f];
            WCC.text = NSLocalizedString(@"WCC", nil);
            [self.contentView addSubview:WCC];
            
            self.WCCResult = [[UILabel alloc] initWithFrame:CGRectMake(104.0f, 3.0f, 50.0f, 22.0f)];
            self.WCCResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.WCCResult];
            
            UILabel *Plats = [[UILabel alloc] initWithFrame:CGRectMake(136.0f, 3.0f, 50.0f, 22.0f)];
            Plats.font = [UIFont systemFontOfSize:14.0f];
            Plats.text = NSLocalizedString(@"Plats", nil);
            [self.contentView addSubview:Plats];
            
            self.PlatsResult = [[UILabel alloc] initWithFrame:CGRectMake(172.0f, 3.0f, 50.0f, 22.0f)];
            self.PlatsResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.PlatsResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 3.0f, 100.0f, 22.0f)]; // was 225.0f
            self.ResultDate.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Clotting Result"])
        {
            UILabel *PT = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 3.0f, 50.0f, 22.0f)];
            PT.font = [UIFont systemFontOfSize:14.0f];
            PT.text = NSLocalizedString(@"PT", nil);
            [self.contentView addSubview:PT];
            
            self.PTResult = [[UILabel alloc] initWithFrame:CGRectMake(38.0f, 3.0f, 50.0f, 22.0f)];
            self.PTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.PTResult];
            
            UILabel *APTT = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, 3.0f, 50.0f, 22.0f)];
            APTT.font = [UIFont systemFontOfSize:14.0f];
            APTT.text = NSLocalizedString(@"APTT", nil);
            [self.contentView addSubview:APTT];
            
            self.APTTResult = [[UILabel alloc] initWithFrame:CGRectMake(104.0f, 3.0f, 50.0f, 22.0f)];
            self.APTTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.APTTResult];
            
            UILabel *TT = [[UILabel alloc] initWithFrame:CGRectMake(136.0f, 3.0f, 50.0f, 22.0f)];
            TT.font = [UIFont systemFontOfSize:14.0f];
            TT.text = NSLocalizedString(@"TT", nil);
            [self.contentView addSubview:TT];
            
            self.TTResult = [[UILabel alloc] initWithFrame:CGRectMake(156.0f, 3.0f, 50.0f, 22.0f)];
            self.TTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.TTResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 3.0f, 100.0f, 22.0f)]; // was 225.0f
            self.ResultDate.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Fibrinogen Result"])
        {
            UILabel *fibrinogen = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 3.0f, 100.0f, 22.0f)];
            fibrinogen.font = [UIFont systemFontOfSize:14.0f];
            fibrinogen.text = NSLocalizedString(@"Fibrinogen", nil);
            [self.contentView addSubview:fibrinogen];
            
            self.FibrinogenResult = [[UILabel alloc] initWithFrame:CGRectMake(88.0f, 3.0f, 50.0f, 22.0f)];
            self.FibrinogenResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.FibrinogenResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 3.0f, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.ResultDate];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.0f];
    
    for (UIView *subview in self.subviews) {
        
        
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
            CGRect newFrame = subview.frame;
            newFrame.origin.x = 200;
            subview.frame = newFrame;
        }
        else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
            CGRect newFrame = subview.frame;
            newFrame.origin.x = 100;
            subview.frame = newFrame;
        }
        else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellReorderControl"]) {
            CGRect newFrame = subview.frame;
            newFrame.origin.x = 200;
            subview.frame = newFrame;
        }
    }
    [UIView commitAnimations];
}
 */

@end
