//
//  SSelectProductImageViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/17.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

/**
 *   截取单品快照的视图控制器
 */
@interface SSelectProductImageViewController : SBaseViewController

@property(strong, readwrite, nonatomic)UIImage *originalImage;//原图

@property(strong, readwrite, nonatomic)NSURL *videoURL;


@property(strong, readwrite, nonatomic) void(^back)(void);

@property(strong, readwrite, nonatomic) void(^didFinishPickingImage)(UIImage *originalImage, UIImage *productImage);//如果是视频的话  第一个参数传nil


@end
