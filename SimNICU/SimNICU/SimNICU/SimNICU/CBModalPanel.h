//
//  CBModalPanel.h
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 21/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "UATitledModalPanel.h"

@class CBModalPanel;

@protocol CBModalPanelDelegate <NSObject>

@optional

- (void)CBModalPanelUserDidSelectCustomTextToPaste:(CBModalPanel *)modalPanel inTextView:(UITextView *)textView;

@end

@interface CBModalPanel : UATitledModalPanel <UITableViewDataSource, UITableViewDelegate>
{
	UIView *view;
}

@property (nonatomic, unsafe_unretained) id <CBModalPanelDelegate> delegate;
@property (nonatomic, strong) NSString *whoCreatedMe;
@property (nonatomic, strong) UITextView *textView;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              array:(NSArray *)array
        forTextView:(UITextView *)textView;

@end
