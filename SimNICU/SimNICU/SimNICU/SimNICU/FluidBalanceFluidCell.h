//
//  FluidBalanceFluidCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 20/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FluidBalanceFluidCell : UITableViewCell

@property (nonatomic, strong) UILabel *fluidName;
@property (nonatomic, strong) UILabel *mlPerDay;
@property (nonatomic, strong) UILabel *mlPerKgPerDay;
@property (nonatomic) BOOL drawTotalLines;
@property (nonatomic) BOOL drawDoubleTotalLines;

@end
