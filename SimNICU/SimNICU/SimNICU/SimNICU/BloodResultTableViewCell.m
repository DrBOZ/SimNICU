//
//  BloodResultTableViewCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#define DEFAULT_TEXT_FONT 13.0f
#define DEFAULT_TEXT_Y 4.0f

#import "BloodResultTableViewCell.h"

@implementation BloodResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([reuseIdentifier isEqualToString:@"FBC Result"])
        {
            UILabel *Hb = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 20.0f, 22.0f)];
            Hb.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            Hb.text = NSLocalizedString(@"Hb", nil);
            [self.contentView addSubview:Hb];
            
            self.HbResult = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 3.0f, 50.0f, 22.0f)];
            self.HbResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.HbResult];
            
            UILabel *WCC = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, DEFAULT_TEXT_Y, 36.0f, 22.0f)];
            WCC.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            WCC.text = NSLocalizedString(@"WCC", nil);
            [self.contentView addSubview:WCC];
            
            self.WCCResult = [[UILabel alloc] initWithFrame:CGRectMake(102.0f, 3.0f, 50.0f, 22.0f)];
            self.WCCResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.WCCResult];
            
            UILabel *Plats = [[UILabel alloc] initWithFrame:CGRectMake(136.0f, DEFAULT_TEXT_Y, 34.0f, 22.0f)];
            Plats.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            Plats.text = NSLocalizedString(@"Plats", nil);
            Plats.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:Plats];
            
            self.PlatsResult = [[UILabel alloc] initWithFrame:CGRectMake(170.0f, 3.0f, 30.0f, 22.0f)];
            self.PlatsResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.PlatsResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)]; // was 225.0f
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Clotting Result"])
        {
            UILabel *PT = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            PT.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            PT.text = NSLocalizedString(@"PT", nil);
            [self.contentView addSubview:PT];
            
            self.PTResult = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 3.0f, 50.0f, 22.0f)];
            self.PTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.PTResult];
            
            UILabel *APTT = [[UILabel alloc] initWithFrame:CGRectMake(66.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            APTT.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            APTT.text = NSLocalizedString(@"APTT", nil);
            [self.contentView addSubview:APTT];
            
            self.APTTResult = [[UILabel alloc] initWithFrame:CGRectMake(104.0f, 3.0f, 50.0f, 22.0f)];
            self.APTTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.APTTResult];
            
            UILabel *TT = [[UILabel alloc] initWithFrame:CGRectMake(136.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            TT.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            TT.text = NSLocalizedString(@"TT", nil);
            [self.contentView addSubview:TT];
            
            self.TTResult = [[UILabel alloc] initWithFrame:CGRectMake(156.0f, 3.0f, 50.0f, 22.0f)];
            self.TTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.TTResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)]; // was 225.0f
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Fibrinogen Result"])
        {
            UILabel *fibrinogen = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            fibrinogen.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            fibrinogen.text = NSLocalizedString(@"Fibrinogen", nil);
            [self.contentView addSubview:fibrinogen];
            
            self.FibrinogenResult = [[UILabel alloc] initWithFrame:CGRectMake(84.0f, 3.0f, 50.0f, 22.0f)];
            self.FibrinogenResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.FibrinogenResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"U&Es Result"])
        {
            UILabel *sodium = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            sodium.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            sodium.text = NSLocalizedString(@"Na", nil);
            [self.contentView addSubview:sodium];
            
            self.NaResult = [[UILabel alloc] initWithFrame:CGRectMake(33.0f, 3.0f, 50.0f, 22.0f)];
            self.NaResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.NaResult];
            
            UILabel *potassium = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            potassium.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            potassium.text = NSLocalizedString(@"K", nil);
            [self.contentView addSubview:potassium];
            
            self.KResult = [[UILabel alloc] initWithFrame:CGRectMake(72.0f, 3.0f, 50.0f, 22.0f)];
            self.KResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.KResult];
            
            UILabel *urea = [[UILabel alloc] initWithFrame:CGRectMake(94.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            urea.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            urea.text = NSLocalizedString(@"Urea", nil);
            [self.contentView addSubview:urea];
            
            self.UreaResult = [[UILabel alloc] initWithFrame:CGRectMake(126.0f, 3.0f, 50.0f, 22.0f)];
            self.UreaResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.UreaResult];
            
            UILabel *creatinine = [[UILabel alloc] initWithFrame:CGRectMake(156.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            creatinine.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            creatinine.text = NSLocalizedString(@"Cr", nil);
            [self.contentView addSubview:creatinine];
            
            self.CreatinineResult = [[UILabel alloc] initWithFrame:CGRectMake(173.0f, 3.0f, 50.0f, 22.0f)];
            self.CreatinineResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.CreatinineResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"CRP Result"])
        {
            UILabel *crp = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            crp.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            crp.text = NSLocalizedString(@"CRP", nil);
            [self.contentView addSubview:crp];
            
            self.CRPResult = [[UILabel alloc] initWithFrame:CGRectMake(46.0f, 3.0f, 50.0f, 22.0f)];
            self.CRPResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.CRPResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"LFT Result"])
        {
            UILabel *alkPhos = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            alkPhos.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT - 1.0f];
            alkPhos.text = NSLocalizedString(@"ALP", nil);
            [self.contentView addSubview:alkPhos];
            
            self.AlkPhosResult = [[UILabel alloc] initWithFrame:CGRectMake(41.0f, 3.0f, 50.0f, 22.0f)];
            self.AlkPhosResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.AlkPhosResult];
            
            UILabel *alt = [[UILabel alloc] initWithFrame:CGRectMake(68.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            alt.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT - 1.0f];
            alt.text = NSLocalizedString(@"ALT", nil);
            [self.contentView addSubview:alt];
            
            self.ALTResult = [[UILabel alloc] initWithFrame:CGRectMake(91.0f, 3.0f, 50.0f, 22.0f)];
            self.ALTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.ALTResult];
            
            UILabel *gammaGT = [[UILabel alloc] initWithFrame:CGRectMake(110.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            gammaGT.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT - 1.0f];
            gammaGT.text = NSLocalizedString(@"\u03B3GT", nil);
            [self.contentView addSubview:gammaGT];
            
            self.GammaGTResult = [[UILabel alloc] initWithFrame:CGRectMake(135.0f, 3.0f, 50.0f, 22.0f)];
            self.GammaGTResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.GammaGTResult];
            
            UILabel *albumin = [[UILabel alloc] initWithFrame:CGRectMake(154.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            albumin.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT - 1.0f];
            albumin.text = NSLocalizedString(@"ALB", nil);
            [self.contentView addSubview:albumin];

            self.ALBResult = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 3.0f, 50.0f, 22.0f)];
            self.ALBResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.ALBResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Conjugated Bilirubin Result"])
        {
            UILabel *directBili = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            directBili.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            directBili.text = NSLocalizedString(@"Direct bilirubin", nil);
            [self.contentView addSubview:directBili];
            
            self.DirectBiliResult = [[UILabel alloc] initWithFrame:CGRectMake(106.0f, 3.0f, 50.0f, 22.0f)];
            self.DirectBiliResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.DirectBiliResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Bone Profile Result"])
        {
            UILabel *calcium = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            calcium.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            calcium.text = NSLocalizedString(@"Ca/adj", nil);
            [self.contentView addSubview:calcium];
            
            self.CaResult = [[UILabel alloc] initWithFrame:CGRectMake(59.0f, 3.0f, 50.0f, 22.0f)];
            self.CaResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.CaResult];
            
            UILabel *dividor = [[UILabel alloc] initWithFrame:CGRectMake(89.0f, DEFAULT_TEXT_Y, 50.0f, 22.0f)];
            dividor.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            dividor.text = NSLocalizedString(@"/", nil);
            [self.contentView addSubview:dividor];
            
            self.CaAdjResult = [[UILabel alloc] initWithFrame:CGRectMake(96.0f, 3.0f, 50.0f, 22.0f)];
            self.CaAdjResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.CaAdjResult];
            
            UILabel *phosphate = [[UILabel alloc] initWithFrame:CGRectMake(128.0f, DEFAULT_TEXT_Y, 60.0f, 22.0f)];
            phosphate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            phosphate.text = NSLocalizedString(@"Phos", nil);
            [self.contentView addSubview:phosphate];
            
            self.PhosphateResult = [[UILabel alloc] initWithFrame:CGRectMake(160.0f, 3.0f, 50.0f, 22.0f)];
            self.PhosphateResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.PhosphateResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Magnesium Result"])
        {
            UILabel *Mg = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            Mg.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            Mg.text = NSLocalizedString(@"Mg", nil);
            [self.contentView addSubview:Mg];
            
            self.MgResult = [[UILabel alloc] initWithFrame:CGRectMake(38.0f, 3.0f, 50.0f, 22.0f)];
            self.MgResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.MgResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
        else if ([reuseIdentifier isEqualToString:@"Ammonia Result"])
        {
            UILabel *ammonia = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            ammonia.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            ammonia.text = NSLocalizedString(@"Ammonia", nil);
            [self.contentView addSubview:ammonia];
            
            self.AmmoniaResult = [[UILabel alloc] initWithFrame:CGRectMake(78.0f, 3.0f, 50.0f, 22.0f)];
            self.AmmoniaResult.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.AmmoniaResult];
            
            self.ResultDate = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, DEFAULT_TEXT_Y, 100.0f, 22.0f)];
            self.ResultDate.font = [UIFont systemFontOfSize:DEFAULT_TEXT_FONT];
            [self.contentView addSubview:self.ResultDate];
        }
    }
    
    // set disclosure indicator
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
