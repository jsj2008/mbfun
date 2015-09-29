//
//  NewRegisterViewController.h
//  Wefafa
//
//  Created by fafatime on 14/12/10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRegisterViewController : SBaseViewController/*UIViewController*/<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    BOOL isAgree;
    NSString *RegistFlagFileName;
    int viewload_times;
    
    BOOL isEntry;
    
}
@property (weak, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (assign, nonatomic) int getValidCodeTimes;
@property (strong, nonatomic) NSDate *sendValidCodeTime;

@property (weak, nonatomic) IBOutlet UIScrollView *registScrollView;

//手机号
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
- (IBAction)txtDidEndOnExit:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

//密码
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)txtPassDidEndOnExit:(id)sender;
- (IBAction)txtEnameEditDidBegin:(id)sender;

//验证码
@property (strong, nonatomic) IBOutlet UITextField *txtValidCode;


//获取验证码
- (IBAction)btnRegistClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRegist;


@property (strong, nonatomic) IBOutlet UILabel *lbAgree;
@property (strong, nonatomic) IBOutlet UIImageView *imgAgree;

//注册
- (IBAction)btnRegistLoginClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *entryImg;
@property (weak, nonatomic) IBOutlet UILabel *declareLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *declareRightLabel;

- (IBAction)entryBtnClick:(id)sender;
- (IBAction)btnServeProtocolClick:(id)sender;

@end
