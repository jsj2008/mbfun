//
//  ClothingCategoryTabBar.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClothingCategoryTabBarCell.h"

/**
 *   可以滚动的衣服类别Tabbar。支持事件UIControlEventValueChanged
 */
@interface ClothingCategoryTabBar : UIControl


@property(assign, readwrite, nonatomic)int selectedIndex;

@property(strong, readwrite, nonatomic)NSArray *cells;

- (void)setCells:(NSArray *)cells;


@end
