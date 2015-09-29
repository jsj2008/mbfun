//
//  SBaseViewController.h
//  StoryCam
//
//  Created by Ryan on 15/4/23.
//  Copyright (c) 2015年 Unico. All rights reserved.
//
//  作为一个统一的基类，可以统一实现一些动画特效。
//

#import <UIKit/UIKit.h>
#import "CBStoreHouseTransition.h"

@interface SBaseViewController : UIViewController
@property (nonatomic, strong) CBStoreHouseTransitionAnimator *animator;
@property (nonatomic, strong) CBStoreHouseTransitionInteractiveTransition *interactiveTransition;
@property (nonatomic) BOOL animatedBack;

-(void)pushController:(SBaseViewController*)vc animated:(BOOL)animated;
-(void)popToRootAnimated:(BOOL)animated;
-(void)popAnimated:(BOOL)animated;

-(void)setupNavbar;

- (UIImage*)snapshot:(UIView*)view;
@end
