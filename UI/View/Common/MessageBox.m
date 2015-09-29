//
//  MessageBox.m
//  Wefafa
//
//  Created by fafa  on 13-10-16.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "MessageBox.h"
#import "AppDelegate.h"



#define MESSAGEBOX_TAG 32542

@implementation MessageBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
- (void)innerInit
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *bgimage = [UIImage imageNamed:@"alert-window.png"];
    bgimage = [bgimage stretchableImageWithLeftCapWidth:0 topCapHeight:38];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imgV.image = bgimage;
    imgV.alpha=0.95;
    [self insertSubview:imgV atIndex:0];
    
    float y = 0;
    _lblTitle = [[UILabel alloc] initWithFrame:(CGRectMake(0, y, self.frame.size.width, 33))];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.font = [UIFont boldSystemFontOfSize:16];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lblTitle];
    y += _lblTitle.frame.size.height;
    
    _lblMessage = [[UILabel alloc] initWithFrame:(CGRectMake(15, y, self.frame.size.width-15*2, 60))];
    _lblMessage.backgroundColor = [UIColor clearColor];
    _lblMessage.font = [UIFont systemFontOfSize:16];
    _lblMessage.textColor = [UIColor whiteColor];
    _lblMessage.numberOfLines=4;
    _lblMessage.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_lblMessage];
    y += _lblMessage.frame.size.height;

    UIImage *imagebtn = [UIImage imageNamed:@"action-black-button.png"];
    imagebtn = [imagebtn stretchableImageWithLeftCapWidth:(int)(imagebtn.size.width+1)>>1 topCapHeight:0];
    
    _btnOK = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _btnOK.frame = CGRectMake((self.frame.size.width/2-MESSAGEBOX_BUTTON_W)/2, y+(MESSAGEBOX_BUTTON_ROW_H-MESSAGEBOX_BUTTON_H)/2, MESSAGEBOX_BUTTON_W, MESSAGEBOX_BUTTON_H);
    [_btnOK setTitle:@"确定" forState:(UIControlStateNormal)];
    _btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_btnOK setBackgroundImage:imagebtn forState:UIControlStateNormal];
    _btnOK.backgroundColor = [UIColor clearColor];
    [_btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnOK setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnOK addTarget:self action:@selector(btnOK_OnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _btnOK.alpha=0.95;
    [self addSubview:_btnOK];
    
    _btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _btnCancel.frame = CGRectMake(self.frame.size.width/2+_btnOK.frame.origin.x, _btnOK.frame.origin.y, MESSAGEBOX_BUTTON_W, MESSAGEBOX_BUTTON_H);
    [_btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    _btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_btnCancel setBackgroundImage:imagebtn forState:UIControlStateNormal];
    _btnCancel.backgroundColor = [UIColor clearColor];
    [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCancel setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(btnCancel_OnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _btnCancel.alpha=0.95;
    [self addSubview:_btnCancel];
}

- (void)dealloc
{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction)btnOK_OnClick:(id)sender {
    _btnCallback(0);
    [[self superview] removeFromSuperview];
}

- (IBAction)btnCancel_OnClick:(id)sender {
    _btnCallback(1);
    [[self superview] removeFromSuperview];
}

+ (void)showDialogWithTitle:(NSString*)title withMessage:(NSString*)message withCallBack:(MessageBoxCallBack)cb
{
    return [self showDialogWithTitle:title withMessage:message withButtonTitle1:nil withButtonTitle2:nil withCallBack:cb];
}

+ (void)showDialogWithTitle:(NSString*)title withMessage:(NSString*)message withButtonTitle1:(NSString*)btnTitle1 withButtonTitle2:(NSString*)btnTitle2 withCallBack:(MessageBoxCallBack)cb
{
    float dialog_w = 270, dialog_h = 140;
    UIWindow *win = UIApplication.sharedApplication.keyWindow;
    CGRect screenRect=[win bounds];
    int x=(screenRect.size.width-dialog_w)/2;
    int y=(screenRect.size.height-dialog_h)/2;
    
    MessageBox *mb = [[MessageBox alloc] initWithFrame:CGRectMake(x,y,dialog_w,dialog_h)];
    mb.lblTitle.text = title;
    mb.lblMessage.text = message;
    if (btnTitle1.length > 0) [mb.btnOK setTitle:btnTitle1 forState:(UIControlStateNormal)];
    if (btnTitle2.length > 0) [mb.btnCancel setTitle:btnTitle2 forState:(UIControlStateNormal)];
    mb.btnCallback = cb;
    
    UIView *v = [[UIView alloc] initWithFrame:win.frame];
    v.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    v.tag = MESSAGEBOX_TAG;
    [v addSubview:mb];
    [win addSubview:v];
    
    [AppDelegate.rootViewController.topViewController.view endEditing:YES];
}


+ (void)closeDialog
{
    UIWindow *win = UIApplication.sharedApplication.keyWindow;
    UIView *v = [win viewWithTag:MESSAGEBOX_TAG];
    [v removeFromSuperview];
}

@end
