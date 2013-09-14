//
//  CBBarCustomTextItem.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
@class CBBarButtonTextItem;

@protocol CBBarButtonTextItemDelegate <NSObject>

@optional

- (void)CBBarButtonTextItemDidChangeTextInTextView:(UITextView *)textView;

- (void)CBBarButtonTextItemInsertString:(NSString *)insertingString intoTextView:(UITextView *)textView;

@end
 */

@interface CBBarCustomTextItem : UIBarButtonItem

- (id)initForTextView:(UITextView *)textView withButtonText:(NSString *)buttonText insertingTextViewText:(NSString *)textViewText;

@end
