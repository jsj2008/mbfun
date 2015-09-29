//
//  SWaterLikeButton.m
//  Wefafa
//
//  Created by unico_0 on 6/30/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SWaterLikeButton.h"

@implementation SWaterLikeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = [super imageRectForContentRect:contentRect];
    rect.origin.y = 9;
    rect.origin.x += 3;
    rect.size = CGSizeMake(12, 12);
    return rect;
}

@end
