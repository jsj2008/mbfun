//
//  SEditeProductTagViewController.h
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"
#import "SAddProductTagViewControlCenter.h"
#import "SProductTagEditeInfo.h"

/**
 *   编辑单品标签视图控制器
 */
@interface SEditeProductTagViewController : SBaseViewController
//单品截图(备用)
@property(strong, readwrite, nonatomic)UIImage *productImageBei;
@property(strong, readwrite, nonatomic)UIImage *productImage;//单品截图
@property(strong, readwrite, nonatomic)UIImage *originalImage;//如果是给图片创建标签的话就是原图

@property(strong, readwrite, nonatomic)NSURL *videoURL;//如果是给视频创建标签的话就是视频

@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishEdit)(SProductTagEditeInfo *productTagEditeInfo);

@property(strong, readonly, nonatomic)SProductTagEditeInfo *productTagEditeInfo;

///单品ID
@property(copy, readwrite, nonatomic) NSString *productId;
///单品code,根据code来判断是否为真实商品
@property(copy, readwrite, nonatomic) NSString *productCode;
///是否是从使用过的单品页面返回的
@property(assign,nonatomic)BOOL isBackUsed;

- (void)setTagIndex:(int)tagIndex;

- (void)setTagViewToPoint:(CGPoint)toPoint;

//- (void)setTagViewCenter:(CGPoint)center;

- (void)setTagViewFlip:(BOOL)flip;

- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName;

- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;

- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName;

@end
