//
//  SCategorySubItemCell.h
//  Wefafa
//
//  Created by chencheng on 15/8/24.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCategorySubItemCell : UICollectionViewCell

//数据方面的属性
@property(strong, readwrite, nonatomic)NSURL *categorySubItemImageURL;
@property(copy, readwrite, nonatomic)NSString *categorySubItemName;//比如男装里面的鞋子


//布局属性 （布局属性放在Model，可以避免代码冗余）
@property(assign, readwrite, nonatomic)CGRect categorySubItemImageRect;
@property(assign, readwrite, nonatomic)CGRect categorySubItemNameLabelRect;

@end
