//
//  ClothingCategoryIntroductionView.h
//  Wefafa
//
//  Created by chencheng on 15/7/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   品类简介的视图类 位于最上面，由一张图片和一段文字组成
 */
@interface ClothingCategoryIntroductionView : UIView



@property(strong, readwrite, nonatomic)NSURL *introductionImageURL;
@property(strong, readwrite, nonatomic)NSString *introductionText;


@end

