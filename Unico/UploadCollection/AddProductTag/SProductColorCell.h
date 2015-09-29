//
//  SProductColorCell.h
//  Wefafa
//
//  Created by shenpu on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SProductColorCell : UICollectionViewCell
//数据方面的属性
@property(strong, readwrite, nonatomic)NSURL *productColorURL;
@property(copy, readwrite, nonatomic)NSString *colorValue;
@property(copy, readwrite, nonatomic)NSString *colorName;
@property(assign,nonatomic)BOOL isSelected;

//布局方面的属性
@property(assign, readwrite, nonatomic)CGRect productColorRect;
@property(assign, readwrite, nonatomic)CGRect titleLabelRect;
@end
