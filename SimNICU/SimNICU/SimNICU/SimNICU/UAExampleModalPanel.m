//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UAExampleModalPanel.h"
#import "CBTableViewRowData.h"
#import "CustomText.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation UAExampleModalPanel
{
    NSArray *tableRows;
}

@synthesize viewLoadedFromXib;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title array:(NSArray *)array forTextView:(UITextView *)textView
{
	if ((self = [super initWithFrame:frame]))
    {
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
        
        // set title
		self.headerLabel.text = title;
		self.headerLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
        // Height of the title view. Default = 40.0f
        self.titleBarHeight = 30.0f;
        
        // Margin between edge of panel and the content area.
        // Default = {20.0, 20.0, 20.0, 20.0}
        // {top, left, bottom, right}
        self.padding = UIEdgeInsetsMake(5.0f, 15.0f, 7.0f, 10.0f);
        
        // set array
        tableRows = array;
        
        // set textView
        self.textView = textView;
        
        // set bounce off
        self.shouldBounce = NO;
		
		UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.rowHeight = 30.0f;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        view = tableView;
        
		[self.contentView addSubview:view];
	}	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[view setFrame:self.contentView.bounds];
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tableRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"UAModalPanelCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([self.whoCreatedMe isEqualToString:@"CustomButton"])
    {
        // Custom Text
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        CustomText *customText = tableRows[indexPath.row];
        
        cell.textLabel.text = customText.customTextReferenceName;
    }
    else
    {
        // Dictation commands
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CBTableViewRowData *rowData = tableRows[indexPath.row];
        
        cell.textLabel.text = rowData.text;
        cell.detailTextLabel.text = rowData.detailText;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:[rowData.detailTextFontSize floatValue]];
    }
    
	return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // obtain relevant text
    CustomText *customText = tableRows[indexPath.row];
    
    // copy relevant text into clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = customText.customText;

    // tell delegate to paste into textView
    [self.delegate CBModalPanelUserDidSelectCustomTextToPaste:self inTextView:self.textView];
}

#pragma mark - Actions

- (IBAction)buttonPressed:(id)sender {
	// The button was pressed. Lets do something with it.
	
	// Maybe the delegate wants something to do with it...
	if ([delegate respondsToSelector:@selector(superAwesomeButtonPressed:)]) {
		[delegate performSelector:@selector(superAwesomeButtonPressed:) withObject:sender];
	
	// Or perhaps someone is listening for notifications 
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SuperAwesomeButtonPressed" object:sender];
	}
		
	NSLog(@"Super Awesome Button pressed!");
}

@end
