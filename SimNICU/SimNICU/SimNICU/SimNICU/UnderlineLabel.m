//
//  UnderlineLabel.m
//  SimNICU
//
//  Created by Conrad Bosman on 01/12/2012.
//  Copyright (c) 2012 Conrad Bosman. All rights reserved.
//

#import "UnderlineLabel.h"

@implementation UnderlineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.298039, 0.337255, 0.423529, 1.0f);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, self.start, self.bounds.size.height - 12);
    CGContextAddLineToPoint(ctx, self.end, self.bounds.size.height - 12);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
    
    /*
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.298039, 0.337255, 0.423529, 1.0f);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextMoveToPoint(ctx, 70.0f, self.bounds.size.height - 12);
    CGContextAddLineToPoint(ctx, 251.0f, self.bounds.size.height - 12);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];
     */
}

@end
