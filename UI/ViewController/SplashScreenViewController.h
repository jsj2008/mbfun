//
//  SplashScreenViewController.h
//  splash
//
//  Created by mac on 14-12-19.
//  Copyright (c) 2014年 FafaTimes. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum{
    CircleFromCenter, //从中间像四周消失
    ClearFromCenter,//从中间像左右消失
    ClearFromLeft,   //左到右
    ClearFromRight, //右到左
    ClearFromTop,   //上到下
    ClearFromBottom, //下到上
    
}TransitionDirection;

@class SplashScreenViewController;

@protocol SplashScreenViewControllerDelegate <NSObject>

@optional
- (void)splashScreenDidAppear:(SplashScreenViewController *)splashScreen;
- (void)splashScreenWillDisappear:(SplashScreenViewController *)splashScreen;
- (void)splashScreenDidDisappear:(SplashScreenViewController *)splashScreen;

@end

@interface SplashScreenViewController : UIViewController

@property (nonatomic, retain) UIImage *splashImage;
@property (nonatomic, retain) UIImage *maskImage;
@property (nonatomic, assign) id <SplashScreenViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *maskImageName;
@property (nonatomic) TransitionDirection transition;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGPoint anchor;

- (void)showInWindow:(UIWindow *)window;

@end
