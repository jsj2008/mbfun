//
//  SBrandPavilionAdView.h
//  Wefafa
//
//  Created by metesbonweios on 15/8/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBrandPavilionModel;

@interface SBrandPavilionAdView : UIView


@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SBrandPavilionModel *contentModel;

//------------
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *showPictureImageArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float showPageHeight;

- (instancetype)initWithFrame:(CGRect)frame withShowPageHeight:(float)showpageHeight;

- (void)startTimer;
- (void)initSubViews;
@end
