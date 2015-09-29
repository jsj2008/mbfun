//
//  SUploadColllocationControlCenter.h
//  Wefafa
//
//  Created by chencheng on 15/8/14.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

@class SAddProductTagViewController;

/**
 *   创建搭配的控制中心类——该类为单例模式
 */
@interface SUploadColllocationControlCenter : NSObject

+ (SUploadColllocationControlCenter *)shareSUploadColllocationControlCenter;


@property(weak, readonly, nonatomic)SAddProductTagViewController *addProductTagViewController;


#pragma mark - 跳转控制接口

/**
 *   退出创建搭配
 */
- (void)exitUploadColllocationWithAnimated:(BOOL)animated;

/**
 *   返回上级页面
 */
- (void)backtoPreViewWithAnimated:(BOOL)animated;

/**
 *   返回上级页面
 */;
- (void)dismissToPreViewWithAnimated:(BOOL)animated;

/**
 *   显示创建搭配的首页——选择系统相册里面的照片或视频
 */
- (void)showUploadColllocationHomeViewWithAnimated:(BOOL)animated;

/**
 *   显示创建搭配的首页:方案2——选择系统相册里面的照片或视频
 */
- (void)showUploadColllocationHomeView2WithAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 *   显示照片裁剪视图
 */
- (void)showCropViewWithImage:(UIImage *)image animated:(BOOL)animated;

/**
 *   显示创建搭配的视频裁剪视图
 */
- (void)showCropViewWithVideoURL:(NSURL *)videoURL videoDuration:(float)videoDuration animated:(BOOL)animated;

/**
 *   显示创建搭配的视频裁剪视图
 */
- (void)showV3VideoCropViewWithAsset:(AVAsset *)avAsset videoSize:(CGSize)videoSize animated:(BOOL)animated;

/**
 *   显示添加单品标签视图
 */
- (void)showAddProductTagViewWithImage:(UIImage *)image animated:(BOOL)animated;

/**
 *   显示添加单品标签视图
 */
- (void)showAddProductTagViewWithVideoURL:(NSURL *)videoURL animated:(BOOL)animated;

/**
 *   显示发布搭配视图
 */
- (void)showPublishViewWithProductArray:(NSArray*)array productImage:(UIImage*)image productVideo:(NSURL*)video animated:(BOOL)animated;


@end
