//
//  CBTableViewWebViewCell.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBTableViewWebViewCell.h"

@implementation CBTableViewWebViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 190.0f)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
        self.webView.scalesPageToFit = NO;
        
        if ([self.webView respondsToSelector:@selector(scrollView)])
        {
            self.webView.scrollView.scrollEnabled = NO;
        }
        else
        {
            for (id subview in self.webView.subviews)
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).scrollEnabled = NO;
        }
        
        self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [self addSubview:self.webView];
    }
    return self;
}

- (void)loadHMTLPageWithFilename:(NSString *)filename
{
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"] isDirectory:NO];
    
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    
    [self.webView loadRequest:URLReq];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
