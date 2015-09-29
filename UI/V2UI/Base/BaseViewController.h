//
//  BaseViewController.h
//  BanggoPhone
//
//  Created by issuser on 14-6-23.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+BG.h"
#import "DetectionSystem.h"

#define BV_Exception_Format @"在%@的子类中必须override:%@方法"
//#import "MBCurrentControl.h"
@interface BaseViewController : UIViewController
- (void)setLeftButton:(NSString*)buttonTitle titleImage:(NSString *)TitleImage action:(SEL)action;
- (void)setRightButton:(NSString*)buttonTitle action:(SEL)action;
//- (void)getBackButton;

//zhu
//有导航栏按钮 必须重写事件
-(void)RightReturn:(UIButton *)sender;
//导航栏左边按钮 可重写事件
-(void)LeftReturn:(UIButton *)sender;
//导航栏按钮统一方法
-(void)SetLeftButton:(NSString *)title Image:(NSString *)image;
-(void)SetRightButton:(NSString *)title Image:(NSString *)image;

-(void)presentWithNavigationController:(UIViewController*)controller;


+(BOOL)pushLoginViewController;
+(BOOL)presentLoginViewController:(UIViewController *)delegate;


@end
