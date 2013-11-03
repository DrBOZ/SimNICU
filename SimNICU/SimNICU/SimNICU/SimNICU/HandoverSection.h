//
//  HandoverSection.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 24/08/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandoverSection : NSObject

@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic, strong) NSString *sectionEditable;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSMutableArray *customText;
// @property (nonatomic) UIImage *image;

@end
