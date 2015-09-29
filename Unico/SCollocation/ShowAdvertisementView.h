//
//  ShowAdvertisementView.h
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDiscoveryFlexibleModel;

@interface ShowAdvertisementView : UIView

@property (nonatomic, strong) NSArray *contentModelArray;
@property (nonatomic, assign) UIViewController *target;
@property (nonatomic, strong) SDiscoveryFlexibleModel *contentModel;

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
