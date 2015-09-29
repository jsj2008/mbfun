//
//  LayoutDecorationCollectionReusableView.m
//  Designer
//
//  Created by Jiang on 1/19/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "LayoutDecorationCollectionReusableView.h"

@implementation LayoutDecorationCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.zPosition = 1;
        UIColor *lineColor = [UIColor colorWithWhite:0.2 alpha:0.2];
        CGRect rect = CGRectMake(frame.size.width/2, 0, 1, frame.size.height);
        CALayer *verticalLineLayer = [CALayer layer];
        verticalLineLayer.frame = rect;
        verticalLineLayer.backgroundColor = lineColor.CGColor;
        [self.layer addSublayer:verticalLineLayer];
        
        rect.size = CGSizeMake(frame.size.width, 1);
        for (int i = 1; i < frame.size.height/180.0; i++) {
            CALayer *layer = [CALayer layer];
            rect.origin = CGPointMake(0, i *180.0);
            layer.frame = rect;
            layer.backgroundColor = lineColor.CGColor;
            [self.layer addSublayer:layer];
        }
    }
    return self;
}


@end
