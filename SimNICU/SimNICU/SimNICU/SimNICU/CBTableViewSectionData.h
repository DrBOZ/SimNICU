//
//  CBTableViewHeadingData.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTableViewSectionData : NSObject

@property (nonatomic, strong) NSString *titleForHeader;
@property (nonatomic, strong) NSMutableArray *rowData;

@end
