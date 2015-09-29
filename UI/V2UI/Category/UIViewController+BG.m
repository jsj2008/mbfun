//
//  UIViewController+RT.m
//  AiFang
//
//  Created by lh liu on 12-3-21.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import "UIViewController+BG.h"
#import "UIView+BGFrame.h"
//#import "MBProgressHUD.h"

#define UIEDGEINSETS_ACTIVITY UIEdgeInsetsMake(0,0,0,0)
#define CGSIZE_ACTIVITY CGSizeMake(20,20)
#define CGSIZE_TITLE CGSizeMake(100,20)
#define AUTO_SIZE YES


@implementation UIViewController (BG)

- (UIViewController *)getController:(int)index{
    NSArray *navArray = [self.navigationController viewControllers];
    NSInteger i = MAX(0, [navArray count]-1+index);
    i = MIN(i, [navArray count]-1);
    return [navArray objectAtIndex:i];
}


- (void)goBackForPopView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goBackForModalView{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)setTitle:(NSString *)title{
//    [self setTitle:title animate:NO];
//}
//
//- (void)setTitle:(NSString *)title animate:(BOOL)animate{
//    self.navigationItem.title = title;
//}


@end

@implementation UIViewController (LoadingView)
/***********************  zhu   ***********************/
/*-(MBProgressHUD *)HUD{
    static MBProgressHUD *HUD=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
    });
    [HUD show:YES];
    [self.view addSubview:HUD];
    return HUD;
}*/
- (void)ShowHUD:(NSString *)info{
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = info;
}
- (void)ShowHideHUD:(NSString *)info{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = info;
    hud.mode=MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}
-(void)HideHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:NO];
    [hud removeFromSuperview];
  
}
-(void)HideHUDWithoutTime{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:NO];
    [hud hide:YES afterDelay:0];
}
/**************************************************/

- (void)hideLoadWithAnimated:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showLoadingActivity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
}

- (void)showInfo:(NSString *)info{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = info;
    
    [hud hide:YES afterDelay:2];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    [self.view addSubview:hud];
    
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:icon];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = info;
    hud.labelFont = font;
//    [hud show:YES];
    if (autoHide) {
        [hud hide:YES afterDelay:1.5];
    }
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide {
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:0];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide{
    [self showInfo:info image:nil autoHidden:autoHide];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset{
    [self showInfo:info image:nil autoHidden:autoHide interval:1.5 yOffset:yOffset];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds {
    [self showInfo:info image:Nil autoHidden:autoHide interval:seconds];
}

- (void)showInfo:(NSString *)info activity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = [NSString stringWithFormat:@"%@",info];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:hud];
    
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:icon];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = info;
    if (yOffset != 0) {
        hud.yOffset = yOffset;
    }

    [hud show:YES];
    if (autoHide) {
        [hud hide:YES afterDelay:(seconds > 0 ? seconds : 1.5)];
    }
}


@end
