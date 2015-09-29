//
//  SFilterCollectionViewController.h
//  Wefafa
//
//  Created by Jiang on 5/23/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyNewModel.h"
#import "SProductTagEditeInfo.h"
@class SFilterSelectedModel;
typedef void (^ SFilterCollectionViewControllerSelected)(id sender);

@interface SFilterCollectionViewController : SBaseViewController
@property (nonatomic, copy) SFilterCollectionViewControllerSelected didSelectedEnter;
@property (nonatomic,assign) BOOL isBack;//每日新品返回
//---------------
@property (nonatomic, strong) SFilterSelectedModel *selectedIndexModel;
@property (nonatomic, strong) NSArray *pirceRangeModelArray;
//@property (nonatomic, strong) NSArray *colorModelArray;
//@property (nonatomic, strong) NSArray *brandModelArray;
@property (nonatomic, assign) BOOL isComeFromBrand;

//尺寸
@property (nonatomic, strong) NSArray *sizeAry;
//颜色
@property (nonatomic, strong) NSArray *colorAry;
//品牌
@property (nonatomic, strong) NSArray *brandAry;
//加载第一次加载的单品分类数据
@property (nonatomic, strong) NSArray *firstBcurrentCategoryAry;

//品牌model
@property (nonatomic, strong) DailyNewModel *dailyNewModel;
//关键字
@property (nonatomic, copy) NSString *keyword;


//单品分类
@property (nonatomic, strong) SProductTagEditeInfo *parameterTagEditeInfo;


//跨ui传参 单品分类
- (void)setProductCategoryWithCategoryId:(NSString *)categoryId categoryName:(NSString *)categoryName subCategoryId:(NSString *)subCategoryId subCategoryCode:(NSString *)subCategoryCode subCategoryName:(NSString *)subCategoryName;
//跨ui传参 品牌分类
- (void)setProductBrandWithBrandId:(NSString *)brandId brandCode:(NSString *)brandCode brandName:(NSString *)brandName;
//跨ui传参 颜色分类
- (void)setProductColorWithColorId:(NSString *)colorId colorCode:(NSString *)colorCode colorName:(NSString *)colorName;

//跨ui传参 尺码分类
- (void)setProductSizeWithSizeCode:(NSString *)sizeCode sizeName:(NSString *)sizeName;

-(void)InitData;

@end