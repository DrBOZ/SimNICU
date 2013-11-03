//
//  CBTableViewRowData.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTableViewRowData : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) NSString *viewControllerToLoad;
@property (nonatomic, strong) NSNumber *detailTextFontSize;

@end
