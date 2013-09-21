//
//  CBBarCustomTextItem.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 14/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBBarCustomTextItem.h"

@interface CBBarCustomTextItem()

@property (nonatomic, retain) UITextView * textView;
@property (nonatomic, strong) NSString *textViewText;

@end

@implementation CBBarCustomTextItem

- (id)initForTextView:(UITextView *)textView withButtonText:(NSString *)buttonText insertingTextViewText:(NSString *)textViewText;
{
    self.textView = textView;
    self.textViewText = textViewText;
    
    UIButton *customButton = [[UIButton alloc] init];
    
    [customButton setImage:[UIImage imageNamed:@"blankButtonLong2@2x.png"] forState:UIControlStateNormal];
    [customButton setImage:[UIImage imageNamed:@"blankButtonLongHighlighted@2x.png"] forState:UIControlStateHighlighted];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 119.0f, 23.0f)];
    buttonLabel.backgroundColor = [UIColor clearColor];
    buttonLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    buttonLabel.textAlignment = UITextAlignmentCenter;
    buttonLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    buttonLabel.shadowColor = [UIColor whiteColor];
    buttonLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    buttonLabel.numberOfLines = 1;
    buttonLabel.text = buttonText;
    
    self.buttonText = buttonText;  // allows me to identify buttonItem later
    
    [customButton addSubview:buttonLabel];
    
    [customButton setFrame:CGRectMake(0.0f, 0.0f, 119.0f, 44.0f)];
    
    [customButton addTarget:self action:@selector(touchDownAction:withEvent:) forControlEvents:UIControlEventTouchDown];
    [customButton addTarget:self action:@selector(touchUpAction:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    self = [super initWithCustomView:customButton];
    
    return self;
}

#pragma mark - Touch

- (void)touchDownAction:(id)sender withEvent:(UIEvent *)event
{
    // old code
    // insert text into textView
    // [self insertString:self.textViewText intoTextView:self.textView];
    
    // inform delegate
    if (self.delegate)
    {
        [self.delegate CBBarButtonTextItem:self wasPressedInTextView:self.textView];
    }
}

- (void)touchUpAction:(id)sender withEvent:(UIEvent *)event
{
    // Reset faked touched down button
    [sender setImage:[UIImage imageNamed:@"blankButtonLong2@2x.png"] forState:UIControlStateNormal];
}

#pragma mark - methods

- (void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView
{
    /*
    
     Useful text that just did not work correctly in this case
     [did not fire textDidChange]
     
    NSRange range = textView.selectedRange;
    
    NSString *firstHalfString = [textView.text substringToIndex:range.location];
    NSString *secondHalfString = [textView.text substringFromIndex: range.location];
    
    // textView.scrollEnabled = NO;
    
    textView.text = [NSString stringWithFormat: @"%@%@%@",
                     firstHalfString,
                     insertingString,
                     secondHalfString];
    
    range.location += [insertingString length];
    textView.selectedRange = range;
    // textView.scrollEnabled = YES;
     */
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = insertingString;
    
    [textView paste:nil];
}

@end
