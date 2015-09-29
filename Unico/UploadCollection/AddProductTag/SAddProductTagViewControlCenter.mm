//
//  SAddProductTagViewControlCenter.m
//  Wefafa
//
//  Created by chen cheng on 15/8/23.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SAddProductTagViewControlCenter.h"

#import "SEditeProductTagViewController.h"
#import "SSelectProductImageViewController.h"
#import "UzysAssetsPickerController.h"
#import "SCRecorderViewController.h"
#import "SUsedProductViewController.h"
#import "AppDelegate.h"
#import "SUtilityTool.h"

#import "SSelectProductColorViewController.h"
#import "SSelectProductBrandViewController.h"
#import "SSelectProductCategoryViewController.h"

#import "SMatchingProductListViewController.h"
#import "SUploadCollectionProductDetailViewController.h"

#import "SUploadColllocationControlCenter.h"

#import "SAddProductTagViewController.h"

#import "SSelectProductSizeViewController.h"
static UIWindow *g_cameraStartSlideWindow = nil;

static SAddProductTagViewControlCenter *g_addProductTagViewControlCenter = nil;

@interface SAddProductTagViewControlCenter()<UzysAssetsPickerControllerDelegate, SCRecorderViewControllerDelegate>
{
    //添加标签时的控制跳转中心
    __weak SEditeProductTagViewController *_editeProductTagViewController;// 编辑单品标签
    
    
    
    __weak SSelectProductImageViewController *_selectProductImageViewController;// 选择单品图片
    __weak UzysAssetsPickerController *_selectProductImageAssetsPickerController;//选择单品图片时的系统相册
    __weak SCRecorderViewController *_selectProductImageCameraViewController;//选择单品图片时的相机
    
    __weak SUsedProductViewController *_usedProductViewController;//使用过的单品
    
    __weak SSelectProductColorViewController *_selectProductColorViewController;//选择单品颜色
    __weak SSelectProductBrandViewController *_selectProductBrandViewController;//选择单品品牌
    
    __weak SSelectProductCategoryViewController *_selectProductCategoryViewController;//选择单品分类
    
    __weak SMatchingProductListViewController *_matchingProductListViewController;//对应的单品
    
    __weak SUploadCollectionProductDetailViewController *_productDetailViewController;//单品详情
    __weak SSelectProductSizeViewController *_selectProductSizeViewController;//选择单品尺寸
    
}

@end

@implementation SAddProductTagViewControlCenter

+ (void)initialize
{
    if (g_addProductTagViewControlCenter == nil)
    {
        g_addProductTagViewControlCenter = [[SAddProductTagViewControlCenter alloc] init];
    }
}

+ (SAddProductTagViewControlCenter *)shareSAddProductTagViewControlCenter
{
    return g_addProductTagViewControlCenter;
}


/**
 *   返回上级页面
 */
- (void)backtoPreViewWithAnimated:(BOOL)animated
{
    [[AppDelegate rootViewController] popViewControllerAnimated:animated];
}

/**
 *   返回上级页面
 */
- (void)dismissToPreViewWithAnimated:(BOOL)animated
{
    UIViewController *topViewController = [AppDelegate rootViewController].topViewController;
    
    if (animated)
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
        
        [[AppDelegate shareAppdelegate].window addSubview:topViewController.view];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            topViewController.view.layer.transform = CATransform3DMakeTranslation(0, UI_SCREEN_HEIGHT, 0);
            
        } completion:^(BOOL finished) {
            [topViewController.view removeFromSuperview];
        }];
    }
    else
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    }
}



/**
 *   显示编辑单品快照视图
 */
- (void)showEditeProductTagViewWith:(SProductTagEditeInfo *)productTagEditeInfo animated:(BOOL)animated
{
    [SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController.view.userInteractionEnabled = NO;//反之单击两次
    
    
    SEditeProductTagViewController *editeProductTagViewController = nil;
    
    if (_editeProductTagViewController == nil)
    {
        editeProductTagViewController = [[SEditeProductTagViewController alloc] init];
        
        _editeProductTagViewController = editeProductTagViewController;
    }
    
    _editeProductTagViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] dismissToPreViewWithAnimated:YES];
    };
    
    _editeProductTagViewController.didFinishEdit = ^(SProductTagEditeInfo *productTagEditeInfo){
        
        if (productTagEditeInfo.tagIndex < 0)//新增标签
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController addProductTagWithInfo:productTagEditeInfo];
        }
        else//被重新编辑的标签
        {
            [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController updateProductTagWithInfo:productTagEditeInfo];
        }
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] dismissToPreViewWithAnimated:YES];
    };
    
    _editeProductTagViewController.productCode=productTagEditeInfo.productCode;
    [_editeProductTagViewController setTagIndex:productTagEditeInfo.tagIndex];//标志是否为新增标签
    _editeProductTagViewController.originalImage = productTagEditeInfo.productOriginImage;
    _editeProductTagViewController.videoURL = productTagEditeInfo.productOriginVideoURL;
    _editeProductTagViewController.productImage = productTagEditeInfo.productImage;
    _editeProductTagViewController.productId=productTagEditeInfo.productId;
    if (productTagEditeInfo.productOriginImageBei) {
        _editeProductTagViewController.productImageBei=productTagEditeInfo.productOriginImageBei;
    }
    
    [_editeProductTagViewController setTagViewToPoint:productTagEditeInfo.tagViewToPoint];
    
    [_editeProductTagViewController setTagViewFlip:productTagEditeInfo.tagViewFlip];
    
    if ([productTagEditeInfo.productSubCategoryId length] > 0)
    {
        [_editeProductTagViewController setProductCategoryWithCategoryId:productTagEditeInfo.productCategoryId categoryName:productTagEditeInfo.productCategoryName subCategoryId:productTagEditeInfo.productSubCategoryId subCategoryCode:productTagEditeInfo.productSubCategoryCode subCategoryName:productTagEditeInfo.productSubCategoryName];
    }
    
    if ([productTagEditeInfo.productBrandName length] > 0||[productTagEditeInfo.productBrandCode length] > 0)
    {
        [_editeProductTagViewController setProductBrandWithBrandId:productTagEditeInfo.productBrandId brandCode:productTagEditeInfo.productBrandCode brandName:productTagEditeInfo.productBrandName];
    }
    
    if ([productTagEditeInfo.productColorName length] > 0)
    {
        [_editeProductTagViewController setProductColorWithColorId:productTagEditeInfo.productColorId colorCode:productTagEditeInfo.productColorCode colorName:productTagEditeInfo.productColorName];
    }
    
    SEditeProductTagViewController *strongEditeProductTagViewController = _editeProductTagViewController;
    
    if (animated)
    {
        CATransform3D backupTransform = strongEditeProductTagViewController.view.layer.transform;
        
        strongEditeProductTagViewController.view.layer.transform = CATransform3DMakeTranslation(0, UI_SCREEN_HEIGHT, 0);
        
        [[AppDelegate shareAppdelegate].window addSubview:strongEditeProductTagViewController.view];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            strongEditeProductTagViewController.view.layer.transform = backupTransform;
            
        } completion:^(BOOL finished) {
            
            [strongEditeProductTagViewController.view removeFromSuperview];
            [[AppDelegate rootViewController] pushViewController:strongEditeProductTagViewController animated:NO];
            [SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController.view.userInteractionEnabled = YES;
        }];
        
    }
    else
    {
        [[AppDelegate rootViewController] pushViewController:strongEditeProductTagViewController animated:NO];
        
        [SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController.view.userInteractionEnabled = YES;
    }
}


/**
 *   显示截取单品快照视图
 */
- (void)showSelectProductImageViewWithOriginalImage:(UIImage *)originalImage animated:(BOOL)animated
{
    SSelectProductImageViewController *selectProductImageViewController = nil;
    
    if (_selectProductImageViewController == nil)
    {
        selectProductImageViewController = [[SSelectProductImageViewController alloc] init];
        _selectProductImageViewController = selectProductImageViewController;
    }
    _selectProductImageViewController.originalImage = originalImage;
    
    
    _selectProductImageViewController.back = ^(){
    
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    _selectProductImageViewController.didFinishPickingImage = ^(UIImage *originalImage, UIImage *productImage){
        
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
//        _editeProductTagViewController.productId=@"";
        
        _editeProductTagViewController.productTagEditeInfo.productImageUrl=@"";
        _editeProductTagViewController.originalImage = originalImage;
        _editeProductTagViewController.productImage = productImage;
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductImageViewController animated:animated];
}



/**
 *   显示截取单品快照视图(我的商品)
 */
- (void)showSelectMyGoodsProductImageViewWithOriginalImage:(UIImage *)originalImage animated:(BOOL)animated viewController:(id)object
{
    SMIneAddProductViewController *_mineAddProductViewController=(SMIneAddProductViewController *)object;
    SSelectProductImageViewController *selectProductImageViewController = nil;
    
    if (_selectProductImageViewController == nil)
    {
        selectProductImageViewController = [[SSelectProductImageViewController alloc] init];
        _selectProductImageViewController = selectProductImageViewController;
    }
    _selectProductImageViewController.originalImage = originalImage;
    
    
    _selectProductImageViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    _selectProductImageViewController.didFinishPickingImage = ^(UIImage *originalImage, UIImage *productImage){
        _mineAddProductViewController.productTagEditeInfo.productImageUrl=@"";
        _mineAddProductViewController.originalImage = originalImage;
        _mineAddProductViewController.productImage = productImage;
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductImageViewController animated:animated];
}



/**
 *   显示截取单品快照视图
 */
- (void)showSelectProductImageViewWithVideoURL:(NSURL *)videoURL animated:(BOOL)animated
{
    SSelectProductImageViewController *selectProductImageViewController = nil;
    
    if (_selectProductImageViewController == nil)
    {
        selectProductImageViewController = [[SSelectProductImageViewController alloc] init];
        _selectProductImageViewController = selectProductImageViewController;
    }
    _selectProductImageViewController.videoURL = videoURL;
    
    
    _selectProductImageViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };

    
    _selectProductImageViewController.didFinishPickingImage = ^(UIImage *originalImage, UIImage *productImage){
        
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
        _editeProductTagViewController.originalImage = originalImage;
        _editeProductTagViewController.productImage = productImage;
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductImageViewController animated:animated];
}

/**
 *   显示使用过的单品视图
 */
- (void)showUsedProductViewWithUserId:(NSString *)userId animated:(BOOL)animated
{
    SUsedProductViewController *usedProductViewController;
    if (_usedProductViewController == nil)
    {
        usedProductViewController = [[SUsedProductViewController alloc] init];
        _usedProductViewController = usedProductViewController;
    }
    
    _usedProductViewController.userId = userId;
    
    _usedProductViewController.back = ^(){
    
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _usedProductViewController.didFinishPickingProduct = ^(SProductTagEditeInfo *productTagEditeInfo){
        
//        ///此处传ID
//        if (productTagEditeInfo.productCode.length<1) {
//            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showProductDetailViewWithProductCode:productTagEditeInfo.productId productType:SProductTypeUsedProduct animated:YES];
//        }
//        else
//        {
//            //真实商品，传CODE
//            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showProductDetailViewWithProductCode:productTagEditeInfo.productCode productType:SProductTypeUsedMatchingProduct animated:YES];
//        }
        _editeProductTagViewController.productCode=productTagEditeInfo.productCode;
        _editeProductTagViewController.originalImage = productTagEditeInfo.productOriginImage;
        _editeProductTagViewController.videoURL = productTagEditeInfo.productOriginVideoURL;
        _editeProductTagViewController.productImage = productTagEditeInfo.productImage;
        _editeProductTagViewController.productId=productTagEditeInfo.productId;
        
        [_editeProductTagViewController setProductColorWithColorId:productTagEditeInfo.productColorId colorCode:productTagEditeInfo.productColorCode colorName:productTagEditeInfo.productColorName];
        [_editeProductTagViewController setProductBrandWithBrandId:productTagEditeInfo.productBrandId brandCode:productTagEditeInfo.productBrandCode brandName:productTagEditeInfo.productBrandName];
        [_editeProductTagViewController setProductCategoryWithCategoryId:productTagEditeInfo.productCategoryId categoryName:productTagEditeInfo.productCategoryName subCategoryId:productTagEditeInfo.productSubCategoryId subCategoryCode:productTagEditeInfo.productSubCategoryCode subCategoryName:productTagEditeInfo.productSubCategoryName];
        _editeProductTagViewController.isBackUsed=YES;
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_usedProductViewController animated:animated];
}

/**
 *   显示选择单品照片时的系统相册
 */
- (void)showSelectProductImageAssetsPickerWithAnimated:(BOOL)animated
{
    [self showSelectProductImageAssetsPickerWithAnimated:animated completion:nil];
}

/**
 *   显示选择单品照片时的系统相册
 */
- (void)showSelectProductImageAssetsPickerWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UzysAssetsPickerController *assetsPickerController = nil;
    
    if (_selectProductImageAssetsPickerController == nil)
    {
        assetsPickerController = [[UzysAssetsPickerController alloc] init];
        
        assetsPickerController.delegate = (id<UzysAssetsPickerControllerDelegate>)self;
        
        assetsPickerController.maximumNumberOfSelectionMedia = 1;
        assetsPickerController.showCameraCell = YES;
        
        assetsPickerController.assetsFilter = [ALAssetsFilter allPhotos];
        
        _selectProductImageAssetsPickerController = assetsPickerController;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].statusBarHidden = NO;
    });
    
    [[AppDelegate rootViewController] presentViewController:_selectProductImageAssetsPickerController animated:animated completion:^{
        
        if (completion != nil)
        {
            completion();
        }
    }];
}

/**
 *   显示选择单品照片时的相机
 */
- (void)showSelectProductImageCameraViewWithAnimated:(BOOL)animated
{
    [self showSelectProductImageCameraViewWithAnimated:animated completionSection1:nil completionSection2:nil];
}


/**
 *   显示选择单品照片时的相机
 */
- (void)showSelectProductImageCameraViewWithAnimated:(BOOL)animated completionSection1:(void (^)(void))completionSection1 completionSection2:(void (^)(void))completionSection2
{
    SCRecorderViewController *cameraViewController = nil;
    
    if (_selectProductImageCameraViewController == nil)
    {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"SCamera" bundle:nil];
        cameraViewController = [secondStoryBoard instantiateViewControllerWithIdentifier:@"SCameraStoryBoardID"];
        cameraViewController.recorderStyle = RecorderViewOnlyPhotoStyle;
        cameraViewController.delegate = self;
        cameraViewController.animatedBack = YES;
        [cameraViewController setHidesBottomBarWhenPushed:YES];
        _selectProductImageCameraViewController = cameraViewController;
    }
    
    SCRecorderViewController *strongSelectProductImageCameraViewController = _selectProductImageCameraViewController;
    
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = [AppDelegate rootViewController].view.frame;
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
            
            
            
        } completion:^(BOOL finished) {
            
            if (completionSection1 != nil)
            {
                completionSection1();
            }
            
            [[AppDelegate rootViewController] pushViewController:strongSelectProductImageCameraViewController animated:NO];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
                
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                
                g_cameraStartSlideWindow = nil;
                
                if (completionSection2 != nil)
                {
                    completionSection2();
                }
            }];
            
        }];
    }
}


/**
 *   关闭相机视图
 */
- (void)closeCameraViewWithAnimated:(BOOL)animated
{
    
    
    if (animated)
    {
        UIImageView *upView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_up"]];
        UIImageView *downView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unico/camera_start_slide_down"]];
        
        if (g_cameraStartSlideWindow == nil)
        {
            g_cameraStartSlideWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        }
        g_cameraStartSlideWindow.windowLevel = UIWindowLevelAlert;
        g_cameraStartSlideWindow.backgroundColor = [UIColor clearColor];
        [g_cameraStartSlideWindow makeKeyAndVisible];
        
        [g_cameraStartSlideWindow addSubview:upView];
        [g_cameraStartSlideWindow addSubview:downView];
        
        upView.frame = downView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        
        [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
        [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
        
        
        
        // 关闭动画
        [UIView animateWithDuration:0.3 animations:^{
            [upView setOrigin:CGPointMake(0, 0)];
            [downView setOrigin:CGPointMake(0, 0)];
        } completion:^(BOOL finished) {
            
            [[AppDelegate rootViewController] popViewControllerAnimated:NO];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [upView setOrigin:CGPointMake(0, -upView.frame.size.height/2)];
                [downView setOrigin:CGPointMake(0, downView.frame.size.height/2+100)];
            } completion:^(BOOL finished) {
                [upView removeFromSuperview];
                [downView removeFromSuperview];
                g_cameraStartSlideWindow = nil;
            }];
        }];
    }
    else
    {
        [[AppDelegate rootViewController] popViewControllerAnimated:NO];
    }
}

/**
 *   显示选择单品颜色(单品筛选)
 */
- (void)showSelectProductColorViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController
{
    SSelectProductColorViewController *selectProductColorViewController = nil;
    
    if (_selectProductColorViewController == nil)
    {
        selectProductColorViewController = [[SSelectProductColorViewController alloc] init];
        
        _selectProductColorViewController = selectProductColorViewController;
    }
    if(!filterCollectionViewController.colorAry){
        filterCollectionViewController.colorAry=[[NSArray alloc] init];
    }
    selectProductColorViewController.colorAry=filterCollectionViewController.colorAry;
    _selectProductColorViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductColorViewController.didFinishColor = ^(NSString *colorId, NSString *colorCode, NSString *colorName){
        
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
    
        [filterCollectionViewController setProductColorWithColorId:colorId colorCode:colorCode colorName:colorName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductColorViewController animated:animated];
}





/**
 *   显示选择单品颜色
 */
- (void)showSelectProductColorViewWithAnimated:(BOOL)animated
{
    SSelectProductColorViewController *selectProductColorViewController = nil;
    
    if (_selectProductColorViewController == nil)
    {
        selectProductColorViewController = [[SSelectProductColorViewController alloc] init];
        
        _selectProductColorViewController = selectProductColorViewController;
    }
    
    _selectProductColorViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductColorViewController.didFinishColor = ^(NSString *colorId, NSString *colorCode, NSString *colorName){
        
        if (_editeProductTagViewController.productTagEditeInfo.productCode.length>0) {
            _editeProductTagViewController.productImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.originalImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.productTagEditeInfo.productImageUrl=@"";
            _editeProductTagViewController.productId=@"";
        }
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
        
        [_editeProductTagViewController setProductColorWithColorId:colorId colorCode:colorCode colorName:colorName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductColorViewController animated:animated];
}


/**
 *   显示选择单品品牌
 */
- (void)showSelectProductBrandViewWithAnimated:(BOOL)animated 
{
    SSelectProductBrandViewController *selectProductBrandViewController = nil;
    
    if (_selectProductBrandViewController == nil)
    {
        selectProductBrandViewController = [[SSelectProductBrandViewController alloc] init];
        
        _selectProductBrandViewController = selectProductBrandViewController;
    }
    
    _selectProductBrandViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductBrandViewController.didFinishBrand = ^(NSString *brandId,NSString *brandCode,NSString *brandName){
        
        if (_editeProductTagViewController.productTagEditeInfo.productCode.length>0) {
            _editeProductTagViewController.productImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.originalImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.productTagEditeInfo.productImageUrl=@"";
            _editeProductTagViewController.productId=@"";
        }
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
        
        [_editeProductTagViewController setProductBrandWithBrandId:brandId brandCode:brandCode brandName:brandName];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductBrandViewController animated:animated];
}

/**
 *   显示选择单品品牌(单品筛选)
 */
- (void)showSelectProductBrandViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController

{
    SSelectProductBrandViewController *selectProductBrandViewController = nil;
    
    if (_selectProductBrandViewController == nil)
    {
        selectProductBrandViewController = [[SSelectProductBrandViewController alloc] init];
        
        _selectProductBrandViewController = selectProductBrandViewController;
    }
    selectProductBrandViewController.brandAry=filterCollectionViewController.brandAry;
    _selectProductBrandViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductBrandViewController.didFinishBrand = ^(NSString *brandId,NSString *brandCode,NSString *brandName){
        
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        
        [filterCollectionViewController setProductBrandWithBrandId:brandId brandCode:brandCode brandName:brandName];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_selectProductBrandViewController animated:animated];
}

/**
 *   显示选择单品分类
 */
- (void)showSelectProductCategoryViewWithAnimated:(BOOL)animated
{
    SSelectProductCategoryViewController *selectProductCategoryViewController = nil;
    
    if (_selectProductBrandViewController == nil)
    {
        selectProductCategoryViewController = [[SSelectProductCategoryViewController alloc] init];
        
        _selectProductCategoryViewController = selectProductCategoryViewController;
    }
    
    _selectProductCategoryViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductCategoryViewController.didFinishCategory = ^(NSString *productCategoryId, NSString *productCategoryName, NSString *productSubCategoryId, NSString *subCategoryCode, NSString *productSubCategoryName){
        
        if (_editeProductTagViewController.productTagEditeInfo.productCode.length>0) {
            _editeProductTagViewController.productImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.originalImage=_editeProductTagViewController.productImageBei;
            _editeProductTagViewController.productTagEditeInfo.productImageUrl=@"";
            _editeProductTagViewController.productId=@"";
        }
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
//        if (!_editeProductTagViewController.productCode) {
//            _editeProductTagViewController.productId=@"";
//        }
        [_editeProductTagViewController setProductCategoryWithCategoryId:productCategoryId categoryName:productCategoryName subCategoryId:productSubCategoryId subCategoryCode:subCategoryCode subCategoryName:productSubCategoryName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductCategoryViewController animated:animated];
}
/**
 *   显示选择单品分类（单品筛选）
 */
- (void)showSelectProductCategoryViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController
{
    SSelectProductCategoryViewController *selectProductCategoryViewController = nil;
    
    if (_selectProductBrandViewController == nil)
    {
        selectProductCategoryViewController = [[SSelectProductCategoryViewController alloc] init];
        
        _selectProductCategoryViewController = selectProductCategoryViewController;
    }
    selectProductCategoryViewController.bcurrentCategoryAry=filterCollectionViewController.firstBcurrentCategoryAry;
    _selectProductCategoryViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductCategoryViewController.didFinishCategory = ^(NSString *productCategoryId, NSString *productCategoryName, NSString *productSubCategoryId, NSString *subCategoryCode, NSString *productSubCategoryName){
        
//        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
//        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        _editeProductTagViewController.productCode=@"";
        
        [filterCollectionViewController setProductCategoryWithCategoryId:productCategoryId categoryName:productCategoryName subCategoryId:productSubCategoryId subCategoryCode:subCategoryCode subCategoryName:productSubCategoryName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductCategoryViewController animated:animated];
}

/**
 *   显示对应的单品
 */
- (void)showMatchingProductListViewWithProductDataArray:(NSArray *)productDataArray productInfo:(SProductTagEditeInfo*)info animated:(BOOL)animated
{
    SMatchingProductListViewController *matchingProductListViewController = nil;
    
    if (_matchingProductListViewController == nil)
    {
        matchingProductListViewController = [[SMatchingProductListViewController alloc] init];
        _matchingProductListViewController = matchingProductListViewController;
    }
    
    _matchingProductListViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    
    _matchingProductListViewController.matchingProductDataArray = productDataArray;
    if (info) {
        _matchingProductListViewController.productTagEditeInfo=info;
    }
    
    _matchingProductListViewController.didFinishPickingProduct = ^(SProductTagEditeInfo *productTagEditeInfo){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showProductDetailViewWithProductCode:productTagEditeInfo.productCode productType:SProductTypeMatchingProduct animated:YES];
    };
    
    
    [[AppDelegate rootViewController] pushViewController:_matchingProductListViewController animated:animated];
}

/**
 *   显示单品详情
 */
- (void)showProductDetailViewWithProductCode:(NSString *)productCode productType:(SProductType)productType animated:(BOOL)animated
{
    SUploadCollectionProductDetailViewController *productDetailViewController = nil;
    
    if (_productDetailViewController == nil)
    {
        productDetailViewController = [[SUploadCollectionProductDetailViewController alloc] init];
        _productDetailViewController = productDetailViewController;
    }
    
    _productDetailViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _productDetailViewController.didFinish = ^(){
        
        SProductTagEditeInfo *productTagEditeInfo = nil;
        
        if (_productDetailViewController.productType != SProductTypeMatchingProduct)
        {
            productTagEditeInfo = _usedProductViewController.selectedRroductTagEditeInfo;
        }
        else
        {
            productTagEditeInfo = _matchingProductListViewController.selectedRroductTagEditeInfo;
            
        }
        
        if (productTagEditeInfo != nil)
        {
            _editeProductTagViewController.productId=productTagEditeInfo.productId;
            _editeProductTagViewController.productTagEditeInfo.productId = productTagEditeInfo.productId;
            _editeProductTagViewController.productTagEditeInfo.productCode = productTagEditeInfo.productCode;
            _editeProductTagViewController.productTagEditeInfo.productImage = productTagEditeInfo.productImage;
            _editeProductTagViewController.productTagEditeInfo.productOriginImage = productTagEditeInfo.productOriginImage;
            
            _editeProductTagViewController.productTagEditeInfo.productCategoryId = productTagEditeInfo.productCategoryId;
            _editeProductTagViewController.productTagEditeInfo.productCategoryName = productTagEditeInfo.productCategoryName;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryId = productTagEditeInfo.productSubCategoryId;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryCode = productTagEditeInfo.productSubCategoryCode;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryName = productTagEditeInfo.productSubCategoryName;
            
            
            _editeProductTagViewController.productTagEditeInfo.productBrandId = productTagEditeInfo.productBrandId;
            _editeProductTagViewController.productTagEditeInfo.productBrandCode = productTagEditeInfo.productBrandCode;
            _editeProductTagViewController.productTagEditeInfo.productBrandName = productTagEditeInfo.productBrandName;
            
            _editeProductTagViewController.productTagEditeInfo.productColorId = productTagEditeInfo.productColorId;
            _editeProductTagViewController.productTagEditeInfo.productColorCode = productTagEditeInfo.productColorCode;
            _editeProductTagViewController.productTagEditeInfo.productColorName = productTagEditeInfo.productColorName;
            
            
            if (_editeProductTagViewController.productTagEditeInfo.tagIndex < 0)//新增标签
            {
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController addProductTagWithInfo:_editeProductTagViewController.productTagEditeInfo];
            }
            else//被重新编辑的标签
            {
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController updateProductTagWithInfo:_editeProductTagViewController.productTagEditeInfo];
            }
            
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:NO];
        }
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:NO];
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] dismissToPreViewWithAnimated:YES];
    };
    
    _productDetailViewController.productCode = productCode;
    _productDetailViewController.productType = productType;
    if (_productDetailViewController.productType == SProductTypeMatchingProduct) {
        _productDetailViewController.sproductInfo=_matchingProductListViewController.selectedRroductTagEditeInfo;
    }
    [[AppDelegate rootViewController] pushViewController:_productDetailViewController animated:animated];
    
}

- (void)showProductDetailViewWithProductCode:(NSString *)productCode productType:(SProductType)productType SProductTagEditeInfo:(SProductTagEditeInfo*)productTagEditeInfo animated:(BOOL)animated{
    SUploadCollectionProductDetailViewController *productDetailViewController = nil;
    
    if (_productDetailViewController == nil)
    {
        productDetailViewController = [[SUploadCollectionProductDetailViewController alloc] init];
        _productDetailViewController = productDetailViewController;
    }
    
    _productDetailViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _productDetailViewController.didFinishWithInfo=^(SProductTagEditeInfo *SProductTagEditeInfo){
        [self backtoPreViewWithAnimated:NO];
        UIViewController *topViewController = [AppDelegate rootViewController].topViewController;
        if([topViewController isKindOfClass:[SMatchingProductListViewController class]]){
            SMatchingProductListViewController *matchingProductListViewController=(SMatchingProductListViewController *)topViewController;
            matchingProductListViewController.didFinishMinePickingProduct(SProductTagEditeInfo);
        }
    };
    
    _productDetailViewController.didFinish = ^(){
        
        SProductTagEditeInfo *productTagEditeInfo = nil;
        
        if (_productDetailViewController.productType != SProductTypeMatchingProduct)
        {
            productTagEditeInfo = _usedProductViewController.selectedRroductTagEditeInfo;
        }
        else
        {
            productTagEditeInfo = productTagEditeInfo;//_matchingProductListViewController.selectedRroductTagEditeInfo;
            
        }
        
        if (productTagEditeInfo != nil)
        {
            _editeProductTagViewController.productTagEditeInfo.productId = productTagEditeInfo.productId;
            _editeProductTagViewController.productTagEditeInfo.productCode = productTagEditeInfo.productCode;
            _editeProductTagViewController.productTagEditeInfo.productImage = productTagEditeInfo.productImage;
            _editeProductTagViewController.productTagEditeInfo.productOriginImage = productTagEditeInfo.productOriginImage;
            
            _editeProductTagViewController.productTagEditeInfo.productCategoryId = productTagEditeInfo.productCategoryId;
            _editeProductTagViewController.productTagEditeInfo.productCategoryName = productTagEditeInfo.productCategoryName;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryId = productTagEditeInfo.productSubCategoryId;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryCode = productTagEditeInfo.productSubCategoryCode;
            _editeProductTagViewController.productTagEditeInfo.productSubCategoryName = productTagEditeInfo.productSubCategoryName;
            
            
            _editeProductTagViewController.productTagEditeInfo.productBrandId = productTagEditeInfo.productBrandId;
            _editeProductTagViewController.productTagEditeInfo.productBrandCode = productTagEditeInfo.productBrandCode;
            _editeProductTagViewController.productTagEditeInfo.productBrandName = productTagEditeInfo.productBrandName;
            
            _editeProductTagViewController.productTagEditeInfo.productColorId = productTagEditeInfo.productColorId;
            _editeProductTagViewController.productTagEditeInfo.productColorCode = productTagEditeInfo.productColorCode;
            _editeProductTagViewController.productTagEditeInfo.productColorName = productTagEditeInfo.productColorName;
            
            
            if (_editeProductTagViewController.productTagEditeInfo.tagIndex < 0)//新增标签
            {
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController addProductTagWithInfo:_editeProductTagViewController.productTagEditeInfo];
            }
            else//被重新编辑的标签
            {
                [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter].addProductTagViewController updateProductTagWithInfo:_editeProductTagViewController.productTagEditeInfo];
            }
            
            [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:NO];
        }
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:NO];
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] dismissToPreViewWithAnimated:YES];
        [self backtoPreViewWithAnimated:YES];
    };
    
    _productDetailViewController.productCode = productCode;
    _productDetailViewController.productType = productType;
    if (_productDetailViewController.productType == SProductTypeMatchingProduct) {
        _productDetailViewController.sproductInfo=productTagEditeInfo;//_matchingProductListViewController.selectedRroductTagEditeInfo;
    }
    [[AppDelegate rootViewController] pushViewController:_productDetailViewController animated:animated];
    
}

/**
 *   显示选择单品尺寸(单品筛选)
 */
- (void)showSelectProductSizeViewWithAnimated:(BOOL)animated FilterCollectionViewController:(SFilterCollectionViewController *)filterCollectionViewController
{
    SSelectProductSizeViewController *selectProductSizeViewController = nil;
    
    if (_selectProductSizeViewController == nil)
    {
        selectProductSizeViewController = [[SSelectProductSizeViewController alloc] init];
        
        _selectProductSizeViewController = selectProductSizeViewController;
    }
    selectProductSizeViewController.sizeAry=filterCollectionViewController.sizeAry;
    _selectProductSizeViewController.back = ^(){
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    _selectProductSizeViewController.didFinishColor = ^(NSString *sizeCode, NSString *siezeName){
        
        //        _editeProductTagViewController.productTagEditeInfo.productId = @"";//赋值为空，表明不再为服务器上存在的单品
        //        _editeProductTagViewController.productTagEditeInfo.productCode = @"";//赋值为空，表明不再为服务器上存在的单品
        
        [filterCollectionViewController setProductSizeWithSizeCode:sizeCode sizeName:siezeName];
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] backtoPreViewWithAnimated:YES];
    };
    
    [[AppDelegate rootViewController] pushViewController:_selectProductSizeViewController animated:animated];
}


#pragma mark - UzysAssetsPickerControllerDelegate接口


- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [UIApplication sharedApplication].statusBarHidden = YES;
}


- (void)uzysAssetsPickerControllerDidPickingCamera:(UzysAssetsPickerController *)picker
{
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageCameraViewWithAnimated:YES completionSection1:^{
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
        }];
        
    } completionSection2:^{
        
    }];
        
    
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([assets count] == 0)
    {
        return;
    }
    else if ([assets count] == 1) //单选模式
    {
        ALAsset *asset = assets[0];
        
        NSString *assetTypeString = [asset valueForProperty:ALAssetPropertyType];
        
        if([assetTypeString isEqualToString:ALAssetTypePhoto]) //图片
        {
            ALAssetRepresentation *defaultRepresentation = asset.defaultRepresentation;
            UIImage *pickingImage = nil;
            
            if (defaultRepresentation.fullScreenImage != NULL)//优先使用全屏图像
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
            }
            else if (defaultRepresentation.fullResolutionImage != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:defaultRepresentation.fullResolutionImage
                                                   scale:defaultRepresentation.scale
                                             orientation:(UIImageOrientation)defaultRepresentation.orientation];
            }
            else if ([asset aspectRatioThumbnail] != NULL)
            {
                pickingImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            }
            _selectProductImageViewController.originalImage = pickingImage;
            
            [UIApplication sharedApplication].statusBarHidden = YES;
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
                
            }];
        }
        else if ([assetTypeString isEqualToString:ALAssetTypeVideo])//视频
        {
        }
    }
}

#pragma mark - SCRecorderViewControllerDelegate接口

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureImage:(UIImage *)image
{
    _selectProductImageViewController.originalImage = image;
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] dismissToPreViewWithAnimated:YES];
}

- (void)recorderViewController:(SCRecorderViewController *)recorderViewController didFinishCaptureVideo:(NSURL *)videoURL
{
    
}

- (void)recorderViewControllerDidPickingSystemPhoto:(SCRecorderViewController *)recorderViewController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] showSelectProductImageAssetsPickerWithAnimated:YES completion:^{
        
        [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] closeCameraViewWithAnimated:NO];
    }];
}

- (void)recorderViewControllerDidCancel:(SCRecorderViewController *)recorderViewController
{
    [[SAddProductTagViewControlCenter shareSAddProductTagViewControlCenter] closeCameraViewWithAnimated:YES];
}


@end
