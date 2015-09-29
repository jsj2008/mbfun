//
//  MBSideViewController.h
//  BanggoPhone
//
//  Created by admin on 14-6-23.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBSlideModel) {
    MBSlideModelNoSlide = 0 ,
    MBSlideModelRight ,
    MBSlideModelLeft,
    MBSlideModelRightAndLeft,
    
};


typedef void(^RootViewMoveBlock)(UIView *rootView,CGRect orginFrame,CGFloat xoffset);


@interface MBSideViewController : UIViewController


@property (assign ,nonatomic) MBSlideModel  sliderModel ;
@property (assign,nonatomic) BOOL needSwipeShowMenu;//是否开启手势滑动出菜单

@property (retain,nonatomic) UIViewController *rootViewController;
@property (retain,nonatomic) UIViewController *leftViewController NS_AVAILABLE_IOS(5_0);
@property (strong,nonatomic) UIViewController *rightViewController NS_AVAILABLE_IOS(5_0);

@property (assign,nonatomic) CGFloat leftViewShowWidth;//左侧栏的展示大小
@property (assign,nonatomic) CGFloat rightViewShowWidth;//右侧栏的展示大小

@property (assign,nonatomic) NSTimeInterval animationDuration;//动画时长
@property (assign,nonatomic) BOOL showBoundsShadow;//是否显示边框阴影
@property (nonatomic, strong) UIView * overLayView ;//遮罩层
@property (copy,nonatomic) RootViewMoveBlock rootViewMoveBlock;//可在此block中重做动画效果
- (void)setRootViewMoveBlock:(RootViewMoveBlock)rootViewMoveBlock;

- (void)showLeftViewController:(BOOL)animated;//展示左边栏
- (void)showRightViewController:(BOOL)animated;//展示右边栏
- (void)hideSideViewController:(BOOL)animated;//恢复正常位置

@end
