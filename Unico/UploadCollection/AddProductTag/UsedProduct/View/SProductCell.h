//
//  SProductCell.h
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SProductCell : UICollectionViewCell

//数据方面的属性
@property(strong, readwrite, nonatomic)NSURL *productImageURL;
@property(strong, readonly, nonatomic)UIImage *productImage;
@property(assign, readwrite, nonatomic)float price;
@property(copy, readwrite, nonatomic)NSString *title;


//布局方面的属性
@property(assign, readwrite, nonatomic)CGRect productImageRect;
@property(assign, readwrite, nonatomic)CGRect priceLabelRect;
@property(assign, readwrite, nonatomic)CGRect titleLabelRect;

@end
