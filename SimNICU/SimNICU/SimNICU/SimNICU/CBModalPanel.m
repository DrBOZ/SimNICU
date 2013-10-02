//
//  CBModalPanel.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 21/09/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "HandoverSectionCustomText.h"
#import "CBTableViewRowData.h"
#import "CBStringMethods.h"
#import "CBModalPanel.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation CBModalPanel
{
    NSArray *tableRows;
}

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
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorColor = [UIColor clearColor];
        tableView.rowHeight = 30.0f;
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
	
    // iOS 7 specifics
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        CGRect rect = CGRectMake(self.contentView.bounds.origin.x, self.contentView.bounds.origin.y - 64.0f, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        
        [view setFrame:rect];
    }
    else
    {
        [view setFrame:self.contentView.bounds];
    }
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [tableRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
            
            // iOS 7 specifics
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                cell.backgroundColor = [UIColor clearColor];
            }
        }
        
        HandoverSectionCustomText *customText = tableRows[indexPath.row];
        
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
            
            // iOS 7 specifics
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
            {
                cell.backgroundColor = [UIColor clearColor];
            }
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
    
    // setup clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // obtain relevant text
    HandoverSectionCustomText *customText = tableRows[indexPath.row];
    
    // check for special text
    
#pragma mark [current date]
    if ([customText.customText isEqualToString:@"[current date]"])
    {
        // paste formatted date
        pasteboard.string = [CBStringMethods dayAndMonthInParenthesesForDate:[NSDate date] andLocale:[NSLocale currentLocale]];
    }
    else
    {
        // copy text into clipboard
        pasteboard.string = customText.customText;
    }
    
    // tell delegate to paste into textView
    [self.delegate CBModalPanelUserDidSelectCustomTextToPaste:self inTextView:self.textView];
}

@end
