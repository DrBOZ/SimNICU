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
@property (nonatomic, strong) UILabel *ResultDate;

@end
