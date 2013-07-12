//
//  DrugInfo.h
//  SimNICU
//
//  Created by Conrad Bosman on 11/07/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrugInfo : NSObject

// I am not even sure that I need this property as the order in the array could be the section number
// @property (nonatomic, strong) NSNumber *section;

// header title for information
@property (nonatomic, strong) NSString *header;

// heightForRow to display HTML
@property (nonatomic, strong) NSNumber *heightForRow;

// inset to differentiate left aligned text and bulleted lists
@property (nonatomic, strong) NSNumber *inset;

// HTML file containing info text
@property (nonatomic, strong) NSString *htmlFile;

@end
