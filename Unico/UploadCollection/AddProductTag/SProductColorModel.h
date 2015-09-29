//
//  SProductColorModel.h
//  Wefafa
//
//  Created by shenpu on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaterFLayout.h"

@interface SProductColorModel : NSObject

//数据方面的属性
@property(strong, readwrite, nonatomic)NSURL *productColorURL;
@property(assign, readwrite, nonatomic)CGSize productColorSize;
@property(copy, readwrite, nonatomic)NSString *colorName;
@property(copy, readwrite, nonatomic)NSString *colorId;
@property(copy, readwrite, nonatomic)NSString *colorCode;
@property(copy, readwrite, nonatomic)NSString *colorValue;
@property(assign,nonatomic)BOOL isSelected;

//布局属性 （布局属性放在Model，可以避免代码冗余）
@property(weak, readwrite, nonatomic)WaterFLayout *waterFLayout;
@property(assign, readonly, nonatomic)CGSize cellSize;
@property(assign, readonly, nonatomic)CGRect productColorRect;
@property(assign, readonly, nonatomic)CGRect colorLabelRect;
@property(assign, readonly, nonatomic)CGRect titleLabelRect;

@end
