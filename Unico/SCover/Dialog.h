//
//  Dialog.h
//  对话框
//
//  Created by 陈诚 on 14-4-28.
//  Copyright (c) 2014年 陈诚. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark - 常量

/**
 *   显示对话框的动画选项
 */
typedef NS_ENUM(NSInteger, QFShowDialogViewAnimationOptions)
{
    QFShowDialogViewAnimationNone = 0,
    QFShowDialogViewAnimationFromLeft,
    QFShowDialogViewAnimationFromTop,
    QFShowDialogViewAnimationFromRight,
    QFShowDialogViewAnimationFromBottom,
    QFShowDialogViewAnimationFromCenter,
};


/**
 *   关闭对话框的动画选项
 */
typedef NS_ENUM(NSInteger, QFCloseDialogViewViewAnimationOptions)
{
    QFCloseDialogViewAnimationNone = 0,
    QFCloseDialogViewAnimationToLeft,
    QFCloseDialogViewAnimationToTop,
    QFCloseDialogViewAnimationToRight,
    QFCloseDialogViewAnimationToBottom,
    QFCloseDialogViewAnimationToCenter,
};


#pragma mark - 公共接口

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
void showDialogView(UIView *view, BOOL modal, QFShowDialogViewAnimationOptions showDialogViewAnimationOption, void (^completion)(BOOL finished));

/**
 *   全局函数接口——关闭当前对话框
 *
 *   @param closeDialogViewViewAnimationOption——关闭当前对话框的动画选项
 *   @param completion——对话框关闭完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
void closeDialogView(QFCloseDialogViewViewAnimationOptions closeDialogViewViewAnimationOption, void (^completion)(BOOL finished));








@interface CCDialog : NSObject

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
+ (void) showDialogView:(UIView *)view modal:(BOOL)modal showDialogViewAnimationOption:(QFShowDialogViewAnimationOptions)showDialogViewAnimationOption completion:(void (^)(BOOL finished))completion;

/**
 *   关闭当前对话框
 *
 *   @param closeDialogViewViewAnimationOption——关闭当前对话框的动画选项
 *   @param completion——对话框关闭完成后需要回调的代码块,可以传nil
 *
 *   无返回值
 */
+ (void) closeDialogViewWithAnimationOptions:(QFCloseDialogViewViewAnimationOptions)closeDialogViewViewAnimationOption completion:(void (^)(BOOL finished))completion;


@end










