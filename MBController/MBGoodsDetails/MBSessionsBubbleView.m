//
//  MBSessionsBubbleView.m
//  Wefafa
//
//  Created by Jiang on 5/6/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBSessionsBubbleView.h"
#import "Utils.h"

@implementation MBSessionsBubbleView
@synthesize drawColor = _drawColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    _apicoLocation_X = self.bounds.size.width / 2;
    [self setNeedsDisplay];
}

- (void)setApicoLocation_X:(CGFloat)apicoLocation_X{
    if (_apicoLocation_X == apicoLocation_X) {
        return;
    }
    _apicoLocation_X = apicoLocation_X;
    [self setNeedsDisplay];
}

- (void)setDrawColor:(UIColor *)drawColor{
    if (drawColor == _drawColor) {
        return;
    }
    _drawColor = drawColor;
    [self setNeedsDisplay];
}

- (UIColor *)drawColor{
    if (!_drawColor) {
        _drawColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    }
    return _drawColor;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.drawColor.CGColor);
    CGContextSetFillColorWithColor(context, self.drawColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat insetValue = - 4.0;
    CGFloat oringinPoint_Y = rect.size.height;
    CGFloat oringinPoint_X = rect.size.width;
    CGFloat endPoint_X = 0;
    CGFloat endPoint_Y = 0;
    
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, _apicoLocation_X, oringinPoint_Y);
    
    CGContextAddLineToPoint(context, _apicoLocation_X + insetValue, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, endPoint_X, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, endPoint_X, endPoint_Y);
    
    CGContextAddLineToPoint(context, oringinPoint_X, endPoint_Y);
    
    CGContextAddLineToPoint(context, oringinPoint_X, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, _apicoLocation_X - insetValue, oringinPoint_Y + insetValue);
    
    CGContextAddLineToPoint(context, _apicoLocation_X, oringinPoint_Y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
