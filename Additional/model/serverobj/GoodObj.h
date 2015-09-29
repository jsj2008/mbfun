//
//  GoodObj.h
//  newdesigner
//
//  Created by Miaoz on 14-9-30.
//  Copyright (c) 2014年 mb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClsInfo.h"
#import "ClsPicUrl.h"
#import "ProductColorMapping.h"
@interface GoodObj : NSObject
@property(nonatomic,strong)ClsInfo *clsInfo;
@property(nonatomic,strong)ClsPicUrl *clsPicUrl;
@property(nonatomic,strong)ProductColorMapping *productColorMapping;
@property(nonatomic,strong)NSString *sourceType;//来源类型（1、商品 2、 素材）
@property(nonatomic,strong)NSString *shearPicUrl;//裁剪过后url

@property(nonatomic,strong)NSString *isFavorite;//是否喜欢
@property(nonatomic,strong)UIImage *showImage;
@property(nonatomic,strong)NSString *isReplace;
@end
