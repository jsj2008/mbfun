//
//  SV2CropViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/14.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"


/**
 *   新版裁剪视图控制器——对图片与视频进行真实裁剪、而非截屏
 */
@interface SV2CropViewController : SBaseViewController


@property(strong, readwrite, nonatomic)UIImage *image;
@property(strong, readwrite, nonatomic)NSURL *videoURL;
@property(assign, readwrite, nonatomic)float videoDuration;


@property(strong, readwrite, nonatomic) void(^back)(void);
@property(strong, readwrite, nonatomic) void(^didFinishCropImage)(UIImage *cropImage);
@property(strong, readwrite, nonatomic) void(^didFinishCropVideo)(NSURL *cropVideoURL);

@end
