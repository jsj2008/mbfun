//
//  SPublishViewController.h
//  Wefafa
//
//  Created by chencheng on 15/8/25.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

@interface SPublishViewController : SBaseViewController

@property(strong, readwrite, nonatomic) void(^back)(void);
///传过来的字典数组
@property(nonatomic,strong) NSArray *productArray;
///搭配图片(或视频第一帧图像)
@property(nonatomic,strong) UIImage *ProductImage;
///图片URL，该URL为从七牛服务器获取
@property(nonatomic,strong) NSString *ProductImageUrl;
///搭配视频
@property(nonatomic,strong) NSURL *videoURL;

@property(nonatomic,assign)CGSize ImgSize;

@end
