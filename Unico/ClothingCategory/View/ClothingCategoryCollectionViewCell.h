//
//  ClothingCategoryCollectionViewCell.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClothingCategoryCollectionViewCell : UICollectionViewCell


@property(strong, readwrite, nonatomic)NSURL *clothingImageURL;
@property(strong, readwrite, nonatomic)NSURL *tagImageURL;

@property(strong, readwrite, nonatomic)NSString *clothingTitle;
@property(assign, readwrite, nonatomic)float originalPrice;
@property(assign, readwrite, nonatomic)float salesPrice;



//布局方面的属性
@property(assign, readwrite, nonatomic)CGRect clothingImageRect;
@property(strong, readwrite, nonatomic)UIFont *titleFont;
@property(assign, readwrite, nonatomic)CGRect titleRect;

@property(strong, readwrite, nonatomic)UIFont *salesPriceFont;
@property(assign, readwrite, nonatomic)CGRect salesPriceRect;

@property(strong, readwrite, nonatomic)UIFont *originalPriceFont;
@property(assign, readwrite, nonatomic)CGRect originalPriceRect;

@property(assign, readwrite, nonatomic)float originalPriceDeleteLineWidth;


@end

