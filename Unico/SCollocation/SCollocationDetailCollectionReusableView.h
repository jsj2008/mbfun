//
//  SCollocationDetailCollectionReusableView.h
//  Wefafa
//
//  Created by unico_0 on 7/24/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCollocationDetailModel;

typedef enum : NSUInteger {
    collocationCellNone = 0,
    collocationCellShowImage,//轮播图 1
    collocationCellDescription,//描述内容 2
    collocationCellShowTag,//跳转展示标签 3
    collocationCellProductList,//单品列表 4
    collocationCellDesigner,//造型师 5
    collocationCellCommitments,//有饭承诺 6
    collocationCellJump,//喜欢评论 7
    collocationCellBrandTag, //所用品牌 8
    collocationCellModaInfo, //模特资料 9
    collocationCellLine = 999,
} SCollocationDetailCellType;

@interface SCollocationDetailCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) SCollocationDetailModel *contentModel;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) NSArray *contentTypeArray;

@end
