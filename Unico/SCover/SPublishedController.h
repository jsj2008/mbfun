//
//  SPublishedController.h
//  StoryCam
//
//  Created by Ryan on 15/4/22.
//  Copyright (c) 2015年 Unico. All rights reserved.
//  发布前填写信息。TODO：后面改下名字。
//

#import <UIKit/UIKit.h>

@class STagEditController;
@class CoverEditViewController;

@interface SPublishedController : SBaseViewController
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *stickerImage;
@property (nonatomic) STagEditController *editVC;



@end
