//
//  ClothingCategoryTabBarCell.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   滚动的tabbar里面的Cell
 */
@interface ClothingCategoryTabBarCell : UIView

@property(copy, readwrite, nonatomic)NSString *clothingCategoryId;

@property(strong, readwrite, nonatomic)NSURL *categoryImageURL;
@property(copy, readwrite, nonatomic)NSString *categoryName;

@property(copy, readwrite, nonatomic)NSString *tid;


@property(assign, readwrite, nonatomic)BOOL selected;

@end

