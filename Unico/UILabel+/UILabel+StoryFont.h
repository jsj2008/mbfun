//
//  UILabel+StoryFont.h
//  Story
//
//  Created by Ryan on 15/4/27.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  注意：
//  这里是对类扩展的写法，作为OC的特性，使用很方便
//  可以减少很多工具静态方法。

#import <UIKit/UIKit.h>

@interface UILabel (StoryFont)
- (void)story_appFont;
- (void)story_appFont:(float)pointSize;

+ (UIFont*)story_appFont:(float)pointSize;
@end
