//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"

@interface UAExampleModalPanel : UATitledModalPanel <UITableViewDataSource>
{
	UIView			*view;
	IBOutlet UIView	*viewLoadedFromXib;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, strong) NSString *whoCreatedMe;

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              array:(NSArray *)array;

- (IBAction)buttonPressed:(id)sender;

@end
