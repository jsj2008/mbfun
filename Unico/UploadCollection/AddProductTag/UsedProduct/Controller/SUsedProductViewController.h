//
//  SUsedProductViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

#import "SAddProductTagViewControlCenter.h"

#import "SProductTagEditeInfo.h"

/**
 *   使用过单品的视图控制器
 */
@interface SUsedProductViewController : SBaseViewController

@property(copy, readwrite, nonatomic)NSString *userId;

@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishPickingProduct)(SProductTagEditeInfo *productTagEditeInfo);

@property(strong, readonly, nonatomic)SProductTagEditeInfo *selectedRroductTagEditeInfo;



@end
