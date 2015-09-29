//
//  NSDictionary+StickerData.h
//  StoryCam
//
//  Created by Ryan on 15/4/5.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  有系统API，这里可以调整成兼容安卓的数据结构。
//  可以在这里统一处理分辨率相关的转换处理，
//  我们可以用统一1136x640的分辨率。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSDictionary (StickerData)
+ (NSDictionary*)dictionaryWithCGRect:(CGRect)rect;
+ (NSDictionary*)dictionaryWithCGPoint:(CGPoint)point;
+ (NSDictionary*)dictionaryWithCGSize:(CGSize)size;
+ (NSDictionary*)dictionaryWithCGAffineTransform:(CGAffineTransform)transform;
+ (NSDictionary*)dictionaryWithUIColor:(UIColor*)color;
+ (NSDictionary*)dictionaryWithUIFont:(UIFont*)font;
// trans
- (CGRect)CGRectValue;
- (CGPoint)CGPointValue;
- (CGSize)CGSizeValue;
- (CGAffineTransform)CGAffineTransformValue;
- (UIColor*)UIColorValue;
- (UIFont*)UIFontValue;
@end
