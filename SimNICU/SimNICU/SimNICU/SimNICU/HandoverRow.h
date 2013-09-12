//
//  HandoverRow.h
//  SimNICU
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandoverRow : NSObject

@property (nonatomic, strong) NSNumber *rowHeight;
@property (nonatomic, strong) UITableView *rowTableView;
@property (nonatomic, strong) NSString *rowText;

@end
