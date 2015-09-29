//
//  SClothingCategoryViewController.h
//  Wefafa
//
//  Created by chencheng on 15/7/28.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseDetailViewController.h"


/**
 *   品类详情视图控制器的声明：指的是衣服品种类别，比如长裙，由发现页面进入该页面
 */
@interface SClothingCategoryViewController : SBaseViewController

@property(copy, readwrite, nonatomic)NSString *clothingCategoryId;//获取头部视图的id

@property(copy, readwrite, nonatomic)NSString *defaultId;//默认选择 ——获取下面商品数据的Id

@property(copy, readwrite, nonatomic)NSString *defaultTitle;//默认标题

@property (nonatomic, assign, getter=isHiddenHeaderImage) BOOL hiddenHeaderImage;

@end
