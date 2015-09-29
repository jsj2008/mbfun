//
//  ClothingCategoryViewModel.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterFLayout.h"

@interface ClothingCategoryViewModel : NSObject

@property(strong, readwrite, nonatomic)NSURL *introductionImageURL;
@property(copy, readwrite, nonatomic)NSString *introductionText;
@property(strong, readwrite, nonatomic)NSArray *categoryTabBarCellsArray;
@property(strong, readwrite, nonatomic)NSMutableArray *categoryCollectionViewCellModelArray;

@end


@interface CollectionViewCellModel : NSObject

//数据属性
@property(copy, readwrite, nonatomic)NSString *productId;
@property(strong, readwrite, nonatomic)NSURL *clothingImageURL;
@property(strong, readwrite, nonatomic)NSURL *tagImageURL;
@property(assign, readwrite, nonatomic)CGSize clothingImageSize;
@property(copy, readwrite, nonatomic)NSString *clothingTitle;
@property(assign, readwrite, nonatomic)float originalPrice;
@property(assign, readwrite, nonatomic)float salesPrice;
@property(assign, readwrite, nonatomic)BOOL promotions;


//布局属性 （布局属性放在Model，可以避免代码冗余）
@property(weak, readwrite, nonatomic)WaterFLayout *waterFLayout;
@property(assign, readonly, nonatomic)CGRect clothingImageRect;
@property(strong, readwrite, nonatomic)UIFont *titleFont;
@property(assign, readonly, nonatomic)CGRect titleRect;

@property(strong, readwrite, nonatomic)UIFont *salesPriceFont;
@property(assign, readonly, nonatomic)CGRect salesPriceRect;

@property(strong, readwrite, nonatomic)UIFont *originalPriceFont;
@property(assign, readonly, nonatomic)CGRect originalPriceRect;
@property(assign, readonly, nonatomic)float originalPriceDeleteLineWidth;

@property(assign, readonly, nonatomic)CGSize cellSize;

@end