//
//  UIImage+SizeColor.m
//  StoryCam
//
//  Created by Ryan on 15/4/5.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "UIImage+SizeColor.h"

@implementation UIImage (SizeColor)
+ (UIImage*)imageWithSize:(CGSize)size andColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end
