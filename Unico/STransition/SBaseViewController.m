//
//  SBaseViewController.m
//  StoryCam
//
//  Created by Ryan on 15/4/23.
//  Copyright (c) 2015年 Unico. All rights reserved.
//
#import "SBaseViewController.h"
#import "LLCameraViewController.h"
#import "CLImageEditor.h"
#import "CoverEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Utility.h"
#import "DoImagePickerController.h"
#import "CoverViewController.h"
#import "TalkingData.h"
#import "Utils.h"
@interface SBaseViewController () <UINavigationControllerDelegate,LLCameraControllerDelegate,CoverEditControllerDelegate>

@end

@implementation SBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    self.animator = [CBStoreHouseTransitionAnimator new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TalkingData trackPageBegin:NSStringFromClass([self class])];
    self.navigationController.delegate = self;
    self.interactiveTransition = [CBStoreHouseTransitionInteractiveTransition new];
    [self.interactiveTransition attachToViewController:self];
}
//
//- (void)dealloc {
//    if (self.navigationController.delegate == self){
//        self.navigationController.delegate = nil;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//        backItem.title = @"";
//        self.navigationItem.backBarButtonItem = backItem;
//    }
//    
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [TalkingData trackPageEnd:NSStringFromClass([self class])];
    if (self.navigationController.delegate == self){
        self.navigationController.delegate = nil;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"";
        self.navigationItem.backBarButtonItem = backItem;
    }
}

- (void)backButtonPressed:(id)sender
{
    //we don't need interactive transition for back button
    self.interactiveTransition = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareContent:(NSDictionary *)params{
    
}

#pragma mark - Navigation Controller Delegate

// 推入一个vc
-(void)pushController:(SBaseViewController*)vc animated:(BOOL)animated{
    [self.navigationController pushViewController:vc animated:animated];
}

// 返回root vc，目前是SMainController
- (void)popToRootAnimated:(BOOL)animated{
    self.interactiveTransition = nil;
    [self.navigationController popToRootViewControllerAnimated:animated];
}

// 
- (void)popAnimated:(BOOL)animated{
    // 进入和退出最好统一是否使用animate，否则容易出问题。
    self.interactiveTransition = nil;
    
    if (self.parentViewController.childViewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:animated];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupNavbar{
    self.navigationController.navigationBar.tintColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.translucent = YES;

    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}



- (UIImage*)snapshot:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    // 下面那个会让view交互丢失。
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 根据UI Image裁剪，不能简单的判断不透明，因为装饰物可能超出区域。
    return image;
}

// 是否隐藏顶部状态栏
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
