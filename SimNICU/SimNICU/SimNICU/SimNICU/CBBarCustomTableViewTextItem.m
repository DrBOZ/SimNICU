//
//  CBBarCustomTableViewTextItem.m
//  SimNICU
//
//  Created by Conrad Bosman on 15/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBBarCustomTableViewTextItem.h"
#import "UAExampleModalPanel.h"
#import "DictationCommands.h" // temporary array

@interface CBBarCustomTableViewTextItem()

@property (nonatomic, strong) NSArray *textViewTextArray;
@property (nonatomic, strong) UAExampleModalPanel *modalPanel;

@end

@implementation CBBarCustomTableViewTextItem

- (id)initForTextView:(UITextView *)textView withButtonText:(NSString *)buttonText insertingTextViewTextFromArray:(NSArray *)textViewTextArray
{
    self = [super initForTextView:textView withButtonText:buttonText insertingTextViewText:nil];
    
    if (self)
    {
        // set array
        self.textViewTextArray = textViewTextArray;
    }
    
    return self;
}

#pragma mark - Touch

- (void)touchDownAction:(id)sender withEvent:(UIEvent *)event
{
    if (!self.modalPanel)
    {
        self.modalPanel = [[UAExampleModalPanel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 260.0f) title:@"Custom Text" array:self.textViewTextArray];
        
        // got stuck here
        // simpler just to use other class and return a delegate
        
        
    }
}

- (void)touchUpAction:(id)sender withEvent:(UIEvent *)event
{
    // Reset faked touched down button
    [sender setImage:[UIImage imageNamed:@"blankButtonLong2@2x.png"] forState:UIControlStateNormal];
}

@end
