//
//  ClothingCategoryHeaderContentView.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClothingCategoryIntroductionView.h"
#import "ClothingCategoryTabBar.h"
#import "CCButton.h"
#import "SButtonTabBar.h"

@interface ClothingCategoryHeaderContentView : UIView


@property(strong, readonly, nonatomic)ClothingCategoryIntroductionView *clothingCategoryIntroductionView;
@property(strong, readonly, nonatomic)ClothingCategoryTabBar *clothingCategoryTabBar;
@property(strong, readonly, nonatomic)SButtonTabBar *buttonTabBar;
@property(strong, readwrite, nonatomic)CCButton *filterButton;
@property(strong, readonly, nonatomic)UIView *titleView;

@end

