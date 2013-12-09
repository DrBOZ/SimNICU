//
//  AddBloodResultModel.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/12/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddBloodResultModel : NSObject

+ (NSArray *)getArrayForTableViewInBloodResultOrder:(NSString *)bloodResultOrder;

@end
