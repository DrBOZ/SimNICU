//
//  CBWebView.m
//  Neonatal Intensive Care
//
//  Created by Conrad Bosman on 06/10/2013.
//  Copyright (c) 2013 Conrad Bosman. All rights reserved.
//

#import "CBWebView.h"

@implementation CBWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.scalesPageToFit = NO;
        
        if ([self respondsToSelector:@selector(scrollView)])
        {
            self.scrollView.scrollEnabled = NO;
        }
        else
        {
            for (id subview in self.subviews)
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).scrollEnabled = NO;
        }
        
        self.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return self;
}

- (void)loadHMTLPageWithFilename:(NSString *)filename
{
    NSURL *htmlURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"] isDirectory:NO];
    
    NSURLRequest *URLReq = [NSURLRequest requestWithURL:htmlURL];
    
    [self loadRequest:URLReq];
}

@end
