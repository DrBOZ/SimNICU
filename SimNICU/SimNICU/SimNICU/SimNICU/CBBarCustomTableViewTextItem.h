//
//  CBBarCustomTableViewTextItem.h
//  SimNICU
//
//  Created by Conrad Bosman on 15/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBarCustomTextItem.h"

@interface CBBarCustomTableViewTextItem : CBBarCustomTextItem

- (id)initForTextView:(UITextView *)textView withButtonText:(NSString *)buttonText insertingTextViewTextFromArray:(NSArray *)textViewTextArray;

@end
