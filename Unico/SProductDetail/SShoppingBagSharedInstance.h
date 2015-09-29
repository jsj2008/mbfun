//
//  SShoppingBagSharedInstance.h
//  PHMUIView
//
//  Created by PHM on 9/23/15.
//  Copyright (c) 2015 haoming pei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SShoppingBagSharedInstanceDelegate;
@interface SShoppingBagSharedInstance : UIControl
@property (nonatomic, strong) UIButton *badgeButton;        //购物袋
@property (nonatomic, strong) UILabel *badgeLabel;          //显示购物袋数量
@property (nonatomic, assign) NSInteger badgeNumber;        //购物袋数量
@property (nonatomic, weak) id<SShoppingBagSharedInstanceDelegate> delegate;

+ (instancetype)sharedInstance;                             //创建购物袋单例
- (void)requestCarCount;                                    //获取购物袋数量信息
@end

@protocol SShoppingBagSharedInstanceDelegate <NSObject>
@optional
/**
 *	@简要 点击购物袋所触发的事件
 *	@参数 shoppingBag : self
 *
 *  @返回 nil
 */
- (void)returnShoppingBag:(SShoppingBagSharedInstance *)shoppingBag;

@end