//
//  MBBannerView.h
//  Wefafa
//
//  Created by su on 15/4/1.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBBrandViewController.h"

typedef void (^RefreshBlock)(void);
@interface MBBannerView : UIView
@property(nonatomic,copy)RefreshBlock refreshBolck;
@property(nonatomic,strong)NSArray *bannerArray;
- (instancetype)initWithBannerArray:(NSArray *)array yPoint:(CGFloat)yPoint;
//- (void)animationCoverView:(BOOL)animation removeCover:(BOOL)remove;
@end
