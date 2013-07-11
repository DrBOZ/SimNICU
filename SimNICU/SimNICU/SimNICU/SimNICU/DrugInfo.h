//
//  DrugInfo.h
//  SimNICU
//
//  Created by Conrad Bosman on 11/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugInfo : NSObject

@property (nonatomic, strong) NSNumber *section;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSNumber *heightForRow;
@property (nonatomic, strong) NSString *htmlFile;

@end
