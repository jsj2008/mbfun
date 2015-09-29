//
//  SLeftMainView.h
//  Wefafa
//
//  Created by su on 15/6/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kLeftViewJumpType) {
    kLeftViewJumpTypeUserCenter,//个人中心
    kLeftViewJumpTypeMyWallet,//我的钱包
    kLeftViewJumpTypeMyTicket,//我的范票
    kLeftViewJumpTypeMyCollect,//我的收藏
    kLeftViewJumpTypeMyScan,//扫一扫
    kLeftViewJumpTypeMyInvite,//我的邀请码
    kLeftViewJumpTypeMyBuy,//我买到的
//    kLeftViewJumpTypeMySell,//我出售的
    kLeftViewJumpTypeKeFu,//联系客服
    kLeftViewJumpTypeSetting //设置
};

@protocol kLeftMainViewDelegate <NSObject>

- (void)kLeftMainViewSwipeDelegate;
- (void)kLeftMainViewDidSelectWithType:(kLeftViewJumpType)type;

@end

@interface SLeftMainView : UIView
@property(nonatomic,weak)id<kLeftMainViewDelegate> delegate;
- (void)showWithtarget:(id <kLeftMainViewDelegate>)delegate;
- (void)hide;
+ (SLeftMainView*)instance;
@end
