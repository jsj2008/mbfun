//
//  ForgetPassViewController.m
//  Wefafa
//
//  Created by su on 15/6/4.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "Utils.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "HttpRequest.h"
#import "LoginViewController.h"
#import "MBToastHud.h"
#import "SHomeViewController.h"

@interface ForgetPassViewController ()<UITextFieldDelegate>{
    UITextField *phoneTextField;
    UITextField *verifyTextField;
    UIButton *requestCodeBtn;
    UIButton *submitBtn;
    NSTimer *_timer;
    NSInteger timeNum;
}
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [contentView setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];
    [self.view addSubview:contentView];
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 100)];
    [inputView setBackgroundColor:[UIColor whiteColor]];
    [inputView.layer setCornerRadius:0];
    [inputView.layer setBorderColor:[Utils HexColor:0XE2E2E2 Alpha:1.0].CGColor];
    [inputView.layer setBorderWidth:1.0];
    [contentView addSubview:inputView];
    
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, UI_SCREEN_WIDTH - 30, 49.5)];
    [phoneTextField setDelegate:self];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneTextField setTextColor:[Utils HexColor:0X333333 Alpha:1.0]];
    [phoneTextField setPlaceholder:@"手机号码"];
    [inputView addSubview:phoneTextField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, UI_SCREEN_WIDTH - 15, 0.5)];
    [line setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [inputView addSubview:line];
    
    verifyTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 50, UI_SCREEN_WIDTH - 160, 50)];
    [verifyTextField setDelegate:self];
    verifyTextField.keyboardType = UIKeyboardTypeNumberPad;
    [verifyTextField setTextColor:[Utils HexColor:0X333333 Alpha:1.0]];
    [verifyTextField setPlaceholder:@"验证码"];
    [inputView addSubview:verifyTextField];
    
    
    requestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [requestCodeBtn addTarget:self action:@selector(requestVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [requestCodeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 160, 50, 160, 50)];
    [requestCodeBtn setEnabled:NO];
    [requestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [requestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [inputView addSubview:requestCodeBtn];
    
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [submitBtn setEnabled:NO];
    [submitBtn.layer setCornerRadius:5.0];
    [submitBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [submitBtn.layer setBorderWidth:1.0];
    [submitBtn setFrame:CGRectMake(10, 150, UI_SCREEN_WIDTH - 20, 44)];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    
    timeNum = 60;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
   
    self.title = @"找回密码";
    UIButton *btnBack=[[UIButton alloc]init];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.frame=CGRectMake(0, 0, 60, 44);
    [btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    btnBack.imageEdgeInsets=UIEdgeInsetsMake(0, -20, 0, 0);
    
    [btnBack setImage:[UIImage imageNamed:@"Unico/icon_back"] forState:UIControlStateNormal];
    
    [btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
    
}

- (void)onBack:(UIButton*)sender {
    [Toast hideToastActivity];
    
    [self popAnimated:YES];
}

- (void)timerCountDown
{
    if (timeNum > 1) {
        if (requestCodeBtn.isEnabled) {
            [requestCodeBtn setEnabled:NO];
            [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        }
        [requestCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新发送",(long)timeNum] forState:UIControlStateDisabled];
        timeNum --;
    }else{
        [_timer invalidate];
        _timer = nil;
        [requestCodeBtn setEnabled:YES];
        [requestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [requestCodeBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
        timeNum = 60;
    }
}
//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark 按钮点击事件
//获取验证码
- (void)requestVerifyCode
{
    if (phoneTextField.text.length!=11||![self validateMobile:phoneTextField.text])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入接收验证码的手机号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [phoneTextField becomeFirstResponder];
        return;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    [Toast makeToastActivity:@"获取验证码..." hasMusk:YES];
    [HttpRequest requestInviteCodeWithPhone:phoneTextField.text from:@"2" success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        NSString *message = [dict objectForKey:@"msg"];
       [MBToastHud show:message image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
//        [Toast makeToast:@"获取验证码失败" mask:YES];
//        [Toast makeToast:@"获取验证码失败"];
           [MBToastHud show:@"获取验证码失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
    }];
}
//提交
- (void)submitClick
{
    
    [phoneTextField resignFirstResponder];
    [verifyTextField resignFirstResponder];
    if (phoneTextField.text.length!=11)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入接收验证码的手机号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
      
        [alert show];
        return;
    }
    
    if (verifyTextField.text.length!=6)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入收到短信中的验证码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
          alert.tag=100;
        [alert show];
        return;
    }
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    NSString *resultStr =[sns resetPassword:phoneTextField.text txtvaildcode:verifyTextField.text returnMsg:msg];
    
    if ([resultStr isEqualToString:@"0000"])
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoginAccount" object:self userInfo:@{@"loginAccount":phoneTextField.text}];
        
        if(msg.length==0)
        {
            msg=[NSMutableString stringWithFormat:@"请等待短信发送新的密码后登录!"];
        }
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=1000;
        
        [alertView show];
        
        
        return;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if(msg.length==0)
        {
            msg=[NSMutableString stringWithFormat:@"获取验证码失败!"];
        }
          [Utils alertMessage:msg];
    }
}

#pragma mark delegate

-(void)judgeInputCodeStatus
{
    if (requestCodeBtn.isEnabled) {
        [requestCodeBtn setEnabled:NO];
        [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    }
    
    if (submitBtn.isEnabled) {
        [submitBtn setEnabled:NO];
        [submitBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==phoneTextField && [toBeString length] > 10)
    {
        textField.text = [toBeString substringToIndex:11];
        if (!requestCodeBtn.isEnabled) {
            if (!_timer ) {
                [requestCodeBtn setEnabled:YES];
                [requestCodeBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
            }
            if ([verifyTextField.text length] >= 6) {
                if (!submitBtn.isEnabled) {
                    [submitBtn setEnabled:YES];
                    [submitBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
                }
            }
        }
        return NO;
    }
    if (textField == phoneTextField && [toBeString length]<11) {
        [self judgeInputCodeStatus];
        return YES;
    }
    
    if (textField == verifyTextField && [toBeString length] > 5) {
        
        textField.text = [toBeString substringToIndex:6];
        if (!submitBtn.isEnabled) {
            [submitBtn setEnabled:YES];
            [submitBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
        }
        return NO;
    }
    if (textField == verifyTextField && [toBeString length]<6) {
        if (submitBtn.isEnabled) {
            [submitBtn setEnabled:NO];
            [submitBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        }
        return YES;
        
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneTextField resignFirstResponder];
    [verifyTextField resignFirstResponder];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000) {
        
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        
        [[AppDelegate App] logout];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[SHomeViewController instance] setSelectedIndex:0];
        [BaseViewController pushLoginViewController];

//        LoginViewController *loginVC=[LoginViewController new];
//        [[AppDelegate rootViewController] pushViewController:loginVC animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:NO];

    }
}
@end
