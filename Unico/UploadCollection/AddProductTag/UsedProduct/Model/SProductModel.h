//
//  SProductModel.h
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterFLayout.h"

@interface SProductModel : NSObject


//数据方面的属性
@property(copy, readwrite, nonatomic)NSString *productId;
@property(copy, readwrite, nonatomic)NSString *ID;
@property(copy, readwrite, nonatomic)NSString *productCode;
@property(strong, readwrite, nonatomic)NSURL *productImageURL;
@property(assign, readwrite, nonatomic)CGSize productImageSize;
@property(assign, readwrite, nonatomic)float price;
@property(copy, readwrite, nonatomic)NSString *title;


//布局属性 （布局属性放在Model，可以避免代码冗余）
@property(weak, readwrite, nonatomic)WaterFLayout *waterFLayout;
@property(assign, readonly, nonatomic)CGSize cellSize;
@property(assign, readonly, nonatomic)CGRect productImageRect;
@property(assign, readonly, nonatomic)CGRect priceLabelRect;
@property(assign, readonly, nonatomic)CGRect titleLabelRect;


@end
