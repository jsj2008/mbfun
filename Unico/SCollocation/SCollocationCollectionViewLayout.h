//
//  SCollocationCollectionViewLayout.h
//  Wefafa
//
//  Created by unico on 15/5/14.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCollocationCollectionViewLayout : UICollectionViewFlowLayout
// 总列数
@property (nonatomic, assign) NSInteger columnCount;
// 商品数据数组
@property (nonatomic, strong) NSArray *goodsList;
@property (nonatomic) NSInteger headerViewHeight;
// 设置item左边距的距离/默认为零/需要左边对齐不设置会导致整体偏移
@property (nonatomic, assign) NSInteger marginToLetf;

@property (nonatomic, assign) BOOL isNotCalculate;

@end
