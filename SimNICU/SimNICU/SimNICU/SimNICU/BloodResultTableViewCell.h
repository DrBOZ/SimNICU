//
//  BloodResultTableViewCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 08/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodResultTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *HbResult;
@property (nonatomic, strong) UILabel *WCCResult;
@property (nonatomic, strong) UILabel *PlatsResult;

@property (nonatomic, strong) UILabel *PTResult;
@property (nonatomic, strong) UILabel *APTTResult;
@property (nonatomic, strong) UILabel *TTResult;

@property (nonatomic, strong) UILabel *FibrinogenResult;

@property (nonatomic, strong) UILabel *NaResult;
@property (nonatomic, strong) UILabel *KResult;
@property (nonatomic, strong) UILabel *UreaResult;
@property (nonatomic, strong) UILabel *CreatinineResult;

@property (nonatomic, strong) UILabel *CRPResult;

@property (nonatomic, strong) UILabel *AlkPhosResult;
@property (nonatomic, strong) UILabel *ALTResult;
@property (nonatomic, strong) UILabel *SBRResult;
@property (nonatomic, strong) UILabel *GammaGTResult;
@property (nonatomic, strong) UILabel *ALBResult;

@property (nonatomic, strong) UILabel *DirectBiliResult;

@property (nonatomic, strong) UILabel *CaResult;
@property (nonatomic, strong) UILabel *CaAdjResult;

@property (nonatomic, strong) UILabel *MgResult;

@property (nonatomic, strong) UILabel *AmmoniaResult;

@property (nonatomic, strong) UILabel *ResultDate;

@end
