//
//  Dialog.m
//  对话框
//
//  Created by 陈诚 on 14-8-27.
//  Copyright (c) 2014年 陈诚. All rights reserved.
//

#import "Dialog.h"

/**
 *   将对话框显示在另一个window之上
 */
static UIWindow *g_alertWindow = nil;


#pragma mark - 对话框放视图控制器

/**
 *   对话框放视图控制器的声明——将对话框放在一个视图控制器中进行管理
 */
@interface DialogViewController : UIViewController
{
    UIView *_dialogView;
    BOOL    _modal;
}

@property(assign, readwrite, nonatomic) BOOL modal;

- (void)setDialogView:(UIView *)dialogView;

@end


/**
 *   对话框放视图控制器的实现
 */
@implementation DialogViewController




#pragma mark - 响应者接口

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_modal)
    {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];

    if ( !CGRectContainsPoint(_dialogView.frame, touchPoint))
    {
        //关闭对话框
        closeDialogView(QFCloseDialogViewAnimationNone, ^(BOOL finished) {
            
        });
    }
}

#pragma mark - 视图控制器接口

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat  mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat  mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
        ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
         _dialogView.center = CGPointMake(mainScreenHeight/2.0, mainScreenWidth/2.0);
    }
    else
    {
        _dialogView.center = CGPointMake(mainScreenWidth/2.0, mainScreenHeight/2.0);
    }
}

#pragma mark - 视图控制器的公共接口

- (void)setDialogView:(UIView *)dialogView
{
    _dialogView = dialogView;
    
    
    CGFloat  mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat  mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation == UIDeviceOrientationLandscapeLeft
        ||
        orientation == UIDeviceOrientationLandscapeRight)
    {
        _dialogView.center = CGPointMake(mainScreenHeight/2.0, mainScreenWidth/2.0);
    }
    else
    {
        _dialogView.center = CGPointMake(mainScreenWidth/2.0, mainScreenHeight/2.0);
    }

    [self.view addSubview:dialogView];
}

@end





#pragma mark - 对外全局函数的实现

/**
 *   全局函数接口——可以将任何视图以对话框的形式显示
 *
 *   @param view——以对话框形式呈现的视图
 *   @param modal——是否以模态的形式显示对话框
 *   @param showDialogViewAnimationOption——对话框显示的动画选项
 *   @param completion——对话框显示完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
void showDialogView(UIView *view, BOOL modal, QFShowDialogViewAnimationOptions showDialogViewAnimationOption, void (^completion)(BOOL finished))
{
    if (g_alertWindow == nil)
    {
        g_alertWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        g_alertWindow.windowLevel = UIWindowLevelAlert;
        
        g_alertWindow.backgroundColor = [UIColor clearColor];
        
        [g_alertWindow makeKeyAndVisible];
    }
    
    DialogViewController *dialogViewController = [[DialogViewController alloc] init];
    
    dialogViewController.modal = modal;
    
    g_alertWindow.rootViewController = dialogViewController;
    
    [dialogViewController setDialogView:view];
    
    NSTimeInterval duration = 0.5;
    
    if (showDialogViewAnimationOption == QFShowDialogViewAnimationNone)
    {
        
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    else if (showDialogViewAnimationOption ==QFShowDialogViewAnimationFromLeft)
    {
        view.layer.transform = CATransform3DTranslate(view.layer.transform, -g_alertWindow.bounds.size.width, 0, 0);
        duration = 0.5;
    }
    else if (showDialogViewAnimationOption ==QFShowDialogViewAnimationFromTop)
    {
        view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, -g_alertWindow.bounds.size.height, 0);
        duration = 0.5;
    }
    else if (showDialogViewAnimationOption ==QFShowDialogViewAnimationFromRight)
    {
        view.layer.transform = CATransform3DTranslate(view.layer.transform, g_alertWindow.bounds.size.width, 0, 0);
        duration = 0.5;
    }
    else if (showDialogViewAnimationOption ==QFShowDialogViewAnimationFromBottom)
    {
        view.layer.transform = CATransform3DTranslate(view.layer.transform, 0, g_alertWindow.bounds.size.height, 0);
        duration = 0.5;
    }
    else if (showDialogViewAnimationOption ==QFShowDialogViewAnimationFromCenter)
    {
        view.layer.transform = CATransform3DScale(view.layer.transform, 0.001, 0.001, 1);
        duration = 0.15;
    }
    
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     
     view.layer.transform = CATransform3DIdentity;
     
     } completion:^(BOOL finished) {
     
        if (completion != nil)
        {
            completion(YES);
        }
     }];

}

/**
 *   全局函数接口——关闭当前对话框
 *
 *   @param closeDialogViewViewAnimationOption——关闭当前对话框的动画选项
 *   @param completion——对话框关闭完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
void closeDialogView(QFCloseDialogViewViewAnimationOptions closeDialogViewViewAnimationOption, void (^completion)(BOOL finished))
{
    CATransform3D  transform;
    
    NSTimeInterval duration = 0.5;
    
    if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationNone)
    {
        if (g_alertWindow != nil)
        {
            g_alertWindow = nil;
        }
        
        if (completion != nil)
        {
            completion(YES);
        }
        return;
    }
    else if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationToLeft)
    {
        transform = CATransform3DTranslate(g_alertWindow.rootViewController.view.layer.transform, -g_alertWindow.frame.size.width, 0, 0);
        duration = 0.5;
    }
    else if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationToTop)
    {
        transform = CATransform3DTranslate(g_alertWindow.rootViewController.view.layer.transform, 0, -g_alertWindow.frame.size.height, 0);
        duration = 0.5;
    }
    else if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationToRight)
    {
        transform = CATransform3DTranslate(g_alertWindow.rootViewController.view.layer.transform, g_alertWindow.frame.size.width, 0, 0);
        duration = 0.5;
    }
    else if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationToBottom)
    {
        transform = CATransform3DTranslate(g_alertWindow.rootViewController.view.layer.transform, 0,g_alertWindow.frame.size.height, 0);
        duration = 0.5;
    }
    else if (closeDialogViewViewAnimationOption == QFCloseDialogViewAnimationToCenter)
    {
        transform = CATransform3DScale(g_alertWindow.rootViewController.view.layer.transform, 0.001, 0.001, 1);
        duration = 0.15;
    }

    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     
     g_alertWindow.rootViewController.view.layer.transform = transform;
     
     } completion:^(BOOL finished) {
     
        if (g_alertWindow != nil)
        {
            g_alertWindow = nil;
        }

        if (completion != nil)
        {
            completion(YES);
        }
     
     }];
}


@implementation CCDialog

/**
 *   可以将任何视图以对话框的形式显示
 *
 *   @param view——以对话框形式呈现的视图
 *   @param modal——是否以模态的形式显示对话框
 *   @param showDialogViewAnimationOption——对话框显示的动画选项
 *   @param completion——对话框显示完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
+ (void) showDialogView:(UIView *)view modal:(BOOL)modal showDialogViewAnimationOption:(QFShowDialogViewAnimationOptions)showDialogViewAnimationOption completion:(void (^)(BOOL finished))completion
{
    showDialogView(view, modal, showDialogViewAnimationOption, completion);
}


/**
 *   关闭当前对话框
 *
 *   @param closeDialogViewViewAnimationOption——关闭当前对话框的动画选项
 *   @param completion——对话框关闭完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
+ (void) closeDialogViewWithAnimationOptions:(QFCloseDialogViewViewAnimationOptions)closeDialogViewViewAnimationOption completion:(void (^)(BOOL finished))completion
{
    closeDialogView(closeDialogViewViewAnimationOption, completion);
}



@end


