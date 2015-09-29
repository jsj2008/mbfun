//
//  SMatchingProductListViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

#import "SProductTagEditeInfo.h"

/**
 *   根据用户选择的单品分类、品牌、颜色信息匹配出对应的单品
 */
@interface SMatchingProductListViewController : SBaseViewController

@property(strong, readwrite, nonatomic)NSArray *matchingProductDataArray;

@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishPickingProduct)(SProductTagEditeInfo *productTagEditeInfo);

//商品
@property(strong, readwrite, nonatomic) void(^didFinishMinePickingProduct)(SProductTagEditeInfo *productTagEditeInfo);

@property(strong, readonly, nonatomic)SProductTagEditeInfo *selectedRroductTagEditeInfo;

///需要传值
@property(strong, nonatomic)SProductTagEditeInfo *productTagEditeInfo;

@end
