//
//  FluidTableViewCell.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 02/01/2014.
//  Copyright (c) 2014 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FluidTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *fluidName;
@property (nonatomic, strong) UILabel *mlPerKgPerDay;
@property (nonatomic, strong) UITextField *mlPerDay;

@end
