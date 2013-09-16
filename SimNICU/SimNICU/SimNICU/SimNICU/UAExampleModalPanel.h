//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"

@class UAExampleModalPanel;

@protocol CBModalPanelDelegate <NSObject>

@optional

- (void)CBModalPanelUserDidSelectCustomTextToPaste:(UAExampleModalPanel *)modalPanel inTextView:(UITextView *)textView;

@end

@interface UAExampleModalPanel : UATitledModalPanel <UITableViewDataSource, UITableViewDelegate>
{
	UIView			*view;
	IBOutlet UIView	*viewLoadedFromXib;
}

@property (nonatomic, unsafe_unretained) id <CBModalPanelDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, strong) NSString *whoCreatedMe;
@property (nonatomic, strong) UITextView *textView;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              array:(NSArray *)array
        forTextView:(UITextView *)textView;

- (IBAction)buttonPressed:(id)sender;

@end
