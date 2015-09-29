//
//  NSDictionary+StickerData.m
//  StoryCam
//
//  Created by Ryan on 15/4/5.
//  Copyright (c) 2015年 Unico. All rights reserved.
//
#import "NSDictionary+StickerData.h"
/*
 我们能利用NSJSONSerialization将JSON转换成Foundation对象，也能将Foundation对象转换成JSON，转换成JSON的对象必须具有如下属性：
 顶层对象必须是NSArray或者NSDictionary
 所有的对象必须是NSString、NSNumber、NSArray、NSDictionary、NSNull的实例
 所有NSDictionary的key必须是NSString类型
 数字对象不能是非数值或无穷
 */
// 注意，设计分辨率要除2
// iPhone 6 1334×750
#define DATA_WIDTH 750.0 / 2
#define DATA_HEIGHT 1334.0 / 2

@implementation NSDictionary (StickerData)
+ (NSDictionary*)dictionaryWithCGRect:(CGRect)rect
{
    return @{
        @"origin" : [NSDictionary dictionaryWithCGPoint:rect.origin],
        @"size" : [NSDictionary dictionaryWithCGSize:rect.size]
    };
}

// 这里作坐标转换
+ (NSDictionary*)dictionaryWithCGPoint:(CGPoint)point
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
//    float scaleY = DATA_HEIGHT / [UIScreen mainScreen].bounds.size.height;
    float scaleY = scaleX;
    return @{
        @"x" : [NSNumber numberWithFloat:point.x * scaleX],
        @"y" : [NSNumber numberWithFloat:point.y * scaleY]
    };
}

// 这里作坐标转换
+ (NSDictionary*)dictionaryWithCGSize:(CGSize)size
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
//    float scaleY = DATA_HEIGHT / [UIScreen mainScreen].bounds.size.height;
    float scaleY = scaleX;
    return @{
        @"width" : [NSNumber numberWithFloat:size.width * scaleX],
        @"height" : [NSNumber numberWithFloat:size.height * scaleY]
    };
}

// 尝试组合一个缩放的变化。
// 这里是否需要做坐标转换
+ (NSDictionary*)dictionaryWithCGAffineTransform:(CGAffineTransform)transform
{
    // ipad 暂时特殊处理，否则没法弄了
    float viewWidth = [UIScreen mainScreen].bounds.size.width;
    if (viewWidth == 768) {
        viewWidth/=2;
    }
    float scaleX = DATA_WIDTH / viewWidth;
    CGAffineTransform t1 = CGAffineTransformMakeScale(scaleX, scaleX);
    transform = CGAffineTransformConcat(transform, t1);
    return @{
        @"a" : [NSNumber numberWithFloat:transform.a * scaleX],
        @"b" : [NSNumber numberWithFloat:transform.b * scaleX],
        @"c" : [NSNumber numberWithFloat:transform.c * scaleX],
        @"d" : [NSNumber numberWithFloat:transform.d * scaleX],
        @"tx" : [NSNumber numberWithFloat:transform.tx * scaleX],
        @"ty" : [NSNumber numberWithFloat:transform.ty * scaleX]
    };
}
+ (NSDictionary*)dictionaryWithUIColor:(UIColor*)color
{
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @{
        @"red" : [NSNumber numberWithFloat:red],
        @"green" : [NSNumber numberWithFloat:green],
        @"blue" : [NSNumber numberWithFloat:blue],
        @"alpha" : [NSNumber numberWithFloat:alpha]
    };
}

// 这里作坐标转换
+ (NSDictionary*)dictionaryWithUIFont:(UIFont*)font
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
    return @{
        @"fontName" : font.fontName,
        @"pointSize" : [NSNumber numberWithFloat:font.pointSize * scaleX]
    };
}

// trans string to value
- (CGRect)CGRectValue
{
    CGPoint origin = [[self objectForKey:@"origin"] CGPointValue];
    CGSize size = [[self objectForKey:@"size"] CGSizeValue];
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

// 这里作坐标转换
- (CGPoint)CGPointValue
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
//    float scaleY = DATA_HEIGHT / [UIScreen mainScreen].bounds.size.height;
    float scaleY = scaleX;
    return CGPointMake(
        [[self objectForKey:@"x"] floatValue] / scaleX,
        [[self objectForKey:@"y"] floatValue] / scaleY);
}

// 这里作坐标转换
- (CGSize)CGSizeValue
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
//    float scaleY = DATA_HEIGHT / [UIScreen mainScreen].bounds.size.height;
    float scaleY = scaleX;
    return CGSizeMake(
        [[self objectForKey:@"width"] floatValue] / scaleX,
        [[self objectForKey:@"height"] floatValue] / scaleY);
}

// TODO：这里作坐标转换？？？
// 这里不能这样做，应该合并一个Scale的变换
- (CGAffineTransform)CGAffineTransformValue
{
    // ipad 暂时特殊处理，否则没法弄了
    float viewWidth = [UIScreen mainScreen].bounds.size.width;
    if (viewWidth == 768) {
        viewWidth/=2;
    }
    float scaleX = DATA_WIDTH / viewWidth;
    NSLog(@"%f", [UIScreen mainScreen].bounds.size.width);
    CGAffineTransform t1 = CGAffineTransformMakeScale(1/scaleX, 1/scaleX);
    CGAffineTransform t2 = CGAffineTransformMake(
                                                 [[self objectForKey:@"a"] floatValue] ,
                                                 [[self objectForKey:@"b"] floatValue] ,
                                                 [[self objectForKey:@"c"] floatValue] ,
                                                 [[self objectForKey:@"d"] floatValue] ,
                                                 [[self objectForKey:@"tx"] floatValue] ,
                                                 [[self objectForKey:@"ty"] floatValue] );
    return CGAffineTransformConcat(t2, t1);

//    return CGAffineTransformMake(
//        [[self objectForKey:@"a"] floatValue] / scaleX,
//        [[self objectForKey:@"b"] floatValue] / scaleX,
//        [[self objectForKey:@"c"] floatValue] / scaleX,
//        [[self objectForKey:@"d"] floatValue] / scaleX,
//        [[self objectForKey:@"tx"] floatValue] / scaleX,
//        [[self objectForKey:@"ty"] floatValue] / scaleX);
}

- (UIColor*)UIColorValue
{
    return [UIColor colorWithRed:
                        [[self objectForKey:@"red"] floatValue]
                           green:[[self objectForKey:@"green"] floatValue]
                            blue:[[self objectForKey:@"blue"] floatValue]
                           alpha:[[self objectForKey:@"alpha"] floatValue]];
}

// 转换
- (UIFont*)UIFontValue
{
    float scaleX = DATA_WIDTH / [UIScreen mainScreen].bounds.size.width;
    return [UIFont fontWithName:[self objectForKey:@"fontName"] size:[[self objectForKey:@"pointSize"] floatValue] / scaleX];
}

@end
