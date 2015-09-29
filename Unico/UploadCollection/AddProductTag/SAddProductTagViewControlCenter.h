//
//  SAddProductTagViewControlCenter.h
//  Wefafa
//
//  Created by chen cheng on 15/8/23.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SProductTagEditeInfo.h"

#import "SUploadCollectionProductDetailViewController.h"

#import "SFilterCollectionViewController.h"


#import "SMIneAddProductViewController.h"
@class SMatchingProductListViewController;

@interface SAddProductTagViewControlCenter : NSObject


+ (SAddProductTagViewControlCenter *)shareSAddProductTagViewControlCenter;

/**
 *   返回上级页面
 */
- (void)backtoPreViewWithAnimated:(BOOL)animated;

/**
 *   返回上级页面
 */
- (void)dismissToPreViewWithAnimated:(BOOL)animated;

/**
 *   显示编辑单品快照视图
 */
- (void)showEditeProductTagViewWith:(SProductTagEditeInfo *)productTagEditeInfo animated:(BOOL)animated;


/**
 *   显示截取单品快照视图
 */
- (void)showSelectProductImageViewWithOriginalImage:(UIImage *)originalImage animated:(BOOL)animated;


/**
 *   显示截取单品快照视图(我的商品)
 */
- (void)showSelectMyGoodsProductImageViewWithOriginalImage:(UIImage *)originalImage animated:(BOOL)animated viewController:(id)object;
/**
 *   显示截取单品快照视图
 */
- (void)showSelectProductImageViewWithVideoURL:(NSURL *)videoURL animated:(BOOL)animated;


/**
 *   显示使用过的单品视图
 */
- (void)showUsedProductViewWithUserId:(NSString *)userId animated:(BOOL)animated;

/**
 *   显示选择单品照片时的系统相册
 */
- (void)showSelectProductImageAssetsPickerWithAnimated:(BOOL)animated completion:(void (^)(void))completion;


/**
 *   显示选择单品照片时的系统相册
 */
- (void)showSelectProductImageAssetsPickerWithAnimated:(BOOL)animated;

/**
 *   显示选择单品照片时的相机
 */
- (void)showSelectProductImageCameraViewWithAnimated:(BOOL)animated;

/**
 *   关闭相机视图
 */
- (void)closeCameraViewWithAnimated:(BOOL)animated;


/**
 *   显示选择单品颜色
 */
- (void)showSelectProductColorViewWithAnimated:(BOOL)animated;
/**
 *   显示选择单品颜色(单品筛选)
 */
- (void)showSelectProductColorViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController;

/**
 *   显示选择单品品牌
 */
- (void)showSelectProductBrandViewWithAnimated:(BOOL)animated;
/**
 *   显示选择单品品牌(单品筛选)
 */
- (void)showSelectProductBrandViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController;

/**
 *   显示选择单品分类
 */
- (void)showSelectProductCategoryViewWithAnimated:(BOOL)animated;
/**
 *   显示选择单品分类（单品筛选）
 */
- (void)showSelectProductCategoryViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController;
/**
 *   显示对应的单品
 */
- (void)showMatchingProductListViewWithProductDataArray:(NSArray *)productDataArray productInfo:(SProductTagEditeInfo*)info animated:(BOOL)animated;


/**
 *   显示单品详情
 */
- (void)showProductDetailViewWithProductCode:(NSString *)productCode productType:(SProductType)productType animated:(BOOL)animated;
//
- (void)showProductDetailViewWithProductCode:(NSString *)productCode productType:(SProductType)productType SProductTagEditeInfo:(SProductTagEditeInfo*)productTagEditeInfo animated:(BOOL)animated;

/**
 *   显示选择单品尺寸(单品筛选)
 */
- (void)showSelectProductSizeViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController;
@end
