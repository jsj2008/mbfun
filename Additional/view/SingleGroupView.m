//
//  SingleGroupView.m
//  Wefafa
//
//  Created by Miaoz on 14/12/9.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "SingleGroupView.h"
#import "GlobelImpl.h"

@implementation SingleGroupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.backgroundColor = [UIColor clearColor];
        //        self.opaque = YES;
        
         self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    //    CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextAddArc(context, headerCenterWidth, headerCenterHeight, headerRadius, radians(-(90 + headerClipHalfAngle)), radians(-90 + headerClipHalfAngle), 1);
    //    CGContextAddLineToPoint(context, 150, 150);
    //     CGPoint cPoint = CGContextGetPathCurrentPoint(context);
    CGContextAddArcToPoint(context,
                           headerCenterWidth,
                           headerCenterHeight - (headerRadius * sin(radians(90 - headerClipHalfAngle)) - headerRadius * sin(radians(headerClipHalfAngle)) * tan(radians(headerClipHalfAngle))),
                           headerCenterWidth - headerRadius * sin(radians(headerClipHalfAngle)),
                           headerCenterHeight - headerRadius * sin(radians(90 - headerClipHalfAngle)),
                           headerRadius);
    
    CGContextClosePath(context);
    CGContextClip(context);
    
    UIImage *image2=_image;
    [image2 drawAtPoint:CGPointMake(0, 0)];
    
}


@end
