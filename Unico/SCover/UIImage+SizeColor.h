//
//  UIImage+SizeColor.h
//  StoryCam
//
//  Created by Ryan on 15/4/5.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UIImage (SizeColor)

// 纯色图片
+ (UIImage*)imageWithSize:(CGSize)size andColor:(UIColor*)color;
@end
