//
//  MessageBox.h
//  Wefafa
//
//  Created by fafa  on 13-10-16.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MESSAGEBOX_BUTTON_W 55
#define MESSAGEBOX_BUTTON_H 30
#define MESSAGEBOX_BUTTON_ROW_H 33

typedef void(^MessageBoxCallBack)(int clickButtonIndex);

@interface MessageBox : UIView

@property (retain, nonatomic) UILabel *lblTitle;
@property (retain, nonatomic) UILabel *lblMessage;
@property (retain, nonatomic) UIButton *btnOK;
@property (retain, nonatomic) UIButton *btnCancel;
@property (copy, nonatomic) MessageBoxCallBack btnCallback;

+ (void)showDialogWithTitle:(NSString*)title withMessage:(NSString*)message withCallBack:(MessageBoxCallBack)cb;
+ (void)showDialogWithTitle:(NSString*)title withMessage:(NSString*)message withButtonTitle1:(NSString*)btnTitle1 withButtonTitle2:(NSString*)btnTitle2 withCallBack:(MessageBoxCallBack)cb;
+ (void)closeDialog;

@end
