//
//  BloodProductsTableViewCell.h
//  SimNICU
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodProductsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *bloodProduct;
@property (nonatomic, strong) UILabel *volume;
@property (nonatomic, strong) UILabel *regimen;

@end
