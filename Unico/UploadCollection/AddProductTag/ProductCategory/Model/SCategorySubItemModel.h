//
//  SCategorySubItemModel.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterFLayout.h"

@interface SCategorySubItemModel : NSObject

//数据方面的属性
@property(strong, readwrite, nonatomic)NSURL *categorySubItemImageURL;
@property(assign, readwrite, nonatomic)CGSize categorySubItemImageSize;
@property(copy, readwrite, nonatomic)NSString *categorySubItemId;
@property(copy, readwrite, nonatomic)NSString *categorySubItemParentId;
@property(copy, readwrite, nonatomic)NSString *categorySubItemCode;
@property(copy, readwrite, nonatomic)NSString *categorySubItemName;//比如男装里面的鞋子


//布局属性 （布局属性放在Model，可以避免代码冗余）
@property(weak, readwrite, nonatomic)UICollectionView *collectionView;
@property(weak, readwrite, nonatomic)WaterFLayout *waterFLayout;
@property(assign, readonly, nonatomic)CGSize cellSize;
@property(assign, readonly, nonatomic)CGRect categorySubItemImageRect;
@property(assign, readonly, nonatomic)CGRect categorySubItemNameLabelRect;

@end
