//
//  CBBarCustomTextItem.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CBBarCustomTextItem;

@protocol CBBarButtonTextItemDelegate <NSObject>

@optional

- (void)CBBarButtonTextItem:(CBBarCustomTextItem *)sender wasPressedInTextView:(UITextView *)textView;

- (void)CBBarButtonTextItemDidChangeTextInTextView:(UITextView *)textView;

- (void)CBBarButtonTextItemInsertString:(NSString *)insertingString intoTextView:(UITextView *)textView;

@end

// Should rename this class to CBBarCustomButtonItem!

@interface CBBarCustomTextItem : UIBarButtonItem

@property (nonatomic, unsafe_unretained) id <CBBarButtonTextItemDelegate> delegate;
@property (nonatomic, strong) NSString *buttonText;

- (id)initForTextView:(UITextView *)textView withButtonText:(NSString *)buttonText insertingTextViewText:(NSString *)textViewText;

@end
