//
//  RTNoDataView.h
//  RTUIStyle
//
//  Created by yintengxiang on 13-5-27.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, RTMessageType) {
    RTMessageTypeNoData = 0 , //无数据提示
    RTMessageTypeCarNoData = 1, //购物车无数据
    RTMessageTypeHomeListNodata = 2, //商品无数据
    RTMessageTypeOrderNodata = 3, //订单无数据
    RTMessageTypePackNodata = 4, //红包无数据
    RTMessageTypeDiscountNodata = 5, //打折券无数据
    RTMessageTypeFavNodata = 6, //收藏无数据
    RTMessageTypeSearchNodata = 7, //搜索无数据
    RTMessageTypeAddressNodata = 8, //地址无数据
    RTMessageTypeCommentNodata = 9, //评论无数据
    RTMessageTypePointNodata = 10 , //积分无数据
    RTMessageTypeNoNetwork = 11 //网络加载失败
};

@interface RTResultMessageView : UIView

@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;

- (void)showInView:(UIView *)view type:(RTMessageType)type target:(id)target action:(SEL)action;
- (void)showInView:(UIView *)view type:(RTMessageType)type target:(id)target action:(SEL)action withMsg:(NSString*)sMsg;
- (void)showInView:(UIView *)view title:(NSString *)title image:(UIImage *)image subTitle:(NSString *)subTitle target:(id)target action:(SEL)action;

- (void)dismiss;
- (void)dismissAnimation:(BOOL)animation;

- (NSString *)messageForType:(RTMessageType)type;
- (UIImage *)imageForType:(RTMessageType)type;


@end
