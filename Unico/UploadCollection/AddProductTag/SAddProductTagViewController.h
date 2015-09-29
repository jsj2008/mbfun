//
//  SAddProductTagViewController.h
//  Wefafa
//
//  Created by chen cheng on 15/8/16.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SBaseViewController.h"

#import "SProductTagEditeInfo.h"



/**
 *   添加单品标签页面
 */
@interface SAddProductTagViewController : SBaseViewController

@property(strong, readwrite, nonatomic)UIImage *image;

@property(strong, readwrite, nonatomic)NSURL *videoURL;

///视频截图
@property(strong,readonly,nonatomic)UIImage *videoImage;

@property(strong, readwrite, nonatomic) void(^back)(void);


@property(strong, readwrite, nonatomic) void(^didFinishProductTag)(NSArray *productTagEditeInfoArray,CGSize imgSize);

///视频截图
@property(strong,readonly,nonatomic) UIImage *firstImage;

- (void)addProductTagWithInfo:(SProductTagEditeInfo *)productTagEditeInfo;
- (void)updateProductTagWithInfo:(SProductTagEditeInfo *)productTagEditeInfo;

@end
