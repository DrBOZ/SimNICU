//
//  CBDisplayMethods.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 23/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBDisplayMethods : NSObject

+ (void)setBackgroundForTableView:(UITableView *)myTableView;
+ (void)updateBackgroundForTableView:(UITableView *)myTableView;
+ (void)setSecondaryBackgroundForTableView:(UITableView *)myTableView;

@end
