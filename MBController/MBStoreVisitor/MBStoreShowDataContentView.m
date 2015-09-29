//
//  MBStoreShowDataContentView.m
//  Wefafa
//
//  Created by Jiang on 5/5/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBStoreShowDataContentView.h"
#import "Utils.h"

@interface MBStoreShowDataContentView ()
{
    CGFloat _height;
    CGFloat _point_Y;
}

@end

@implementation MBStoreShowDataContentView

- (void)awakeFromNib{
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
}

- (void)drawRectWithStartPoint_Y:(CGFloat)point_Y height:(CGFloat)height{
    _height = height;
    _point_Y = point_Y;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    UIColor *color = [Utils HexColor:0xe2e2e2 Alpha:0.7];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    for (int i = 0; i <= 10; i ++) {
        CGContextMoveToPoint(context, 0, i * _height + _point_Y - 5);
        CGContextAddLineToPoint(context, rect.size.width, i * _height + _point_Y - 5);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
