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
    
    UIButton *trackballButton = [[UIButton alloc] init];
    
    [trackballButton setImage:[UIImage imageNamed:@"blankButtonLong2@2x.png"] forState:UIControlStateNormal];
    [trackballButton setImage:[UIImage imageNamed:@"blankButtonLongHighlighted@2x.png"] forState:UIControlStateHighlighted];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 119.0f, 23.0f)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
    textLabel.shadowColor = [UIColor whiteColor];
    textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    textLabel.numberOfLines = 1;
    textLabel.text = buttonText;
    
    [trackballButton addSubview:textLabel];
    
    [trackballButton setFrame:CGRectMake(0.0f, 0.0f, 119.0f, 44.0f)];
    
    [trackballButton addTarget:self action:@selector(touchDownAction:withEvent:) forControlEvents:UIControlEventTouchDown];
    [trackballButton addTarget:self action:@selector(touchUpAction:withEvent:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    self = [super initWithCustomView:trackballButton];
    
    return self;
}

#pragma mark - Touch

- (void)touchDownAction:(id)sender withEvent:(UIEvent *)event
{
    // insert text into textView
    [self insertString:self.textViewText intoTextView:self.textView];
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
