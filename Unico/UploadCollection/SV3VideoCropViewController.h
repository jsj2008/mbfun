//
//  SV3VideoCropViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

/**
 *   视频裁切第三版——使用iOS原生机制对长视频的进行时间轴上的裁切
 */
@interface SV3VideoCropViewController : SBaseViewController

@property(strong, readwrite, nonatomic)UIImage *image;
@property(strong, readwrite, nonatomic)AVAsset *asset;
@property(assign, readwrite, nonatomic)CGSize videoSize;

@property(strong, readwrite, nonatomic) void(^back)(void);
@property(strong, readwrite, nonatomic) void(^didFinishCropImage)(UIImage *cropImage);
@property(strong, readwrite, nonatomic) void(^didFinishCropVideo)(NSURL *cropVideoURL);

@end
