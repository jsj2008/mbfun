//
//  UIImage+BGExtraMethod
//  AIFCore
//
//  Created by yintengxiang on 14-1-27.
//  Copyright (c) 2014年 Anjuke Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BGExtraMethod)

/*
 * 按照Rect截取Image里一块生成新的image
 */
- (UIImage *)getSubImage:(CGRect)rect;

/*
 * 按照size缩小
 */
- (UIImage *)scaleToSize:(CGSize)size;

/*
 * 按照VGA缩小
 */
- (UIImage *)scaleToVGA;

/*
 * 获取图片内存大小
 */
- (size_t)imageBytesSize;

/*
 * 反转成向上方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;


/*
 * 按照size缩小
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/*
 * 获取bundle中的图片
 */
+ (UIImage *)imageNamedForBundle:(NSString *)name;

@end
