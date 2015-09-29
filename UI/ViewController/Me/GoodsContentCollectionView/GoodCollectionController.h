//
//  GoodCollectionController.h
//  Wefafa
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

/**
 购物袋弹出视图
 */
#import <UIKit/UIKit.h>
#import "MyShoppingTrollyGoodsTableViewCell.h"

typedef void(^myBlock)(NSDictionary *dict);

@protocol GoodCollectionControllerDelegate;


@interface GoodCollectionController : UIViewController

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, assign) BOOL shrinksParentView;

@property (nonatomic, copy) void (^changeBtnState)(void);   // 用于弹出视图隐藏式改变箭头方向

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) id<GoodCollectionControllerDelegate> delegate;
@property (nonatomic, copy) myBlock block;  // 定义block用于传值
@property (nonatomic,copy)NSString *oldColorStr;//购物袋老的颜色
@property (nonatomic,copy)NSString *oldSizeStr;//购物袋老的尺码

- (id)initWithParameter:(id)parameter;
- (id)initWithParameter:(id)parameter
            productCode:(NSString *)productCode
           promotion_ID:(NSString *)promotion_ID;
- (id)initWithProductCode:(NSString *)productCode isProductDetail:(BOOL)isProductDetail;

- (void) showInView:(UIView*)view;
- (void)requestAndShowInView:(UIView *)view;
- (void) hide;

@end


@protocol GoodCollectionControllerDelegate <NSObject>

- (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC
                      doneClicked:(UIButton *)doneBtn;

/**
 *	@简要 成功购买商品
 *	@参数 goodCollectionVC
 *
 *  @返回 nil
 */
@optional
- (void)goodsCollectionController:(GoodCollectionController *)goodCollectionVC
                    isBuySuccesss:(BOOL)isBuy;
@end
