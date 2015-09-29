//
//  UIViewController+RT.h
//  AiFang
//
//  Created by lh liu on 12-3-21.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BG)

- (UIViewController *)getController:(int)index;
- (void)goBackForPopView;
- (void)goBackForModalView;
//- (void)setTitle:(NSString *)title;
//- (void)setTitle:(NSString *)title animate:(BOOL)animate;

@end

@interface UIViewController (LoadingView)
- (void)hideLoadWithAnimated:(BOOL)animated;
- (void)showLoadingActivity:(BOOL)activity;
- (void)showInfo:(NSString *)info;

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font;
- (void)showInfo:(NSString *)info activity:(BOOL)activity;

//zhu
- (void)ShowHUD:(NSString *)info;
- (void)ShowHideHUD:(NSString *)info;
-(void)HideHUD;
-(void)HideHUDWithoutTime;
@end
