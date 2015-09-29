//
//  STagView.h
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   标签风格选项
 */
typedef NS_ENUM(NSInteger, STagViewStyle)
{
    STagViewStyleNone = 0,//不带任何图标
    STagViewStyleAdd, //带"+"图标
    STagViewStyleClose, //带关闭图标
    STagViewStyleCart, //带购物车图标
};

/**
 *   标签视图
 */
@interface STagView : UIView

@property(copy, readwrite, nonatomic) NSString *title;

@property(assign, readwrite, nonatomic) BOOL flip;//是否翻转，默认指向左边  兼容老版

@property(assign, readwrite, nonatomic) CGPoint toPoint;

@property(assign, readwrite, nonatomic) CoverTagType tagType;

@property(assign, readwrite, nonatomic) STagViewStyle tagStyle;

@property(strong, readwrite, nonatomic) void (^addTagBlock)(CGPoint point);
@property(strong, readwrite, nonatomic) void (^closeTagBlock)(void);
@property(strong, readwrite, nonatomic) void (^cartTagBlock)(void);


@end
