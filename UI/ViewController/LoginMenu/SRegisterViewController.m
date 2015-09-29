//
//  SRegisterViewController.m
//  Wefafa
//
//  Created by su on 15/6/10.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SRegisterViewController.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "MobClick.h"
#import "AppSetting.h"
#import "FileReaderViewController.h"
#import "LoginViewController.h"
#import "HttpRequest.h"
#import "MBToastHud.h"

@interface SRegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UITableView *registerTable;
    UITextField *phoneTextField;
    UITextField *nickNameTextField;
    UITextField *passwordTextField;
    UITextField *verifyCodeTextField;
    UITextField *inviteTextField;
    
    UIButton *requestCodeBtn;
    UIButton *submitBtn;
    NSTimer *_timer;
    NSInteger timeNum;
    BOOL stopInPut;
}

@end

@implementation SRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    registerTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [registerTable setDataSource:self];
    [registerTable setDelegate:self];
    [registerTable setTableFooterView:[self configTableFootView]];
    [self.view addSubview:registerTable];
    
    stopInPut = NO;
    timeNum = 60;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap)];
    [registerTable addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH/2, 25)];
    [label setTextColor:COLOR_C6];
    [label setFont:FONT_t6];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setText:@"注册即视为同意"];
    [self.view addSubview:label];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *btnStr = @"有范服务协议";
    CGSize size = [btnStr sizeWithAttributes:[NSDictionary dictionaryWithObject:FONT_t6 forKey:NSFontAttributeName]];
    [agreeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT - 50, size.width, 25)];
    [agreeBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    [agreeBtn setTitle:btnStr forState:UIControlStateNormal];
    [agreeBtn.titleLabel setFont:FONT_t6];
    [agreeBtn addTarget:self action:@selector(showAgreeConditions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (UIView *)configTableFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80)];
//    [footView setBackgroundColor:[Utils HexColor:0XF2F2F2 Alpha:1.0]];

    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [submitBtn setTitle:@"注册" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [submitBtn setEnabled:NO];
    [submitBtn.layer setCornerRadius:5.0];
    [submitBtn.layer setBorderColor:[UIColor clearColor].CGColor];
    [submitBtn.layer setBorderWidth:1.0];
    [submitBtn setFrame:CGRectMake(10, 20, UI_SCREEN_WIDTH - 20, 44)];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submitBtn];
    return footView;
}

- (void)setupNavbar {
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"快速注册";
}

#pragma mark uibutton click method

- (void)onBack:(id)sender
{
    [Toast hideToastActivity];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 按钮点击事件
//获取验证码
- (void)requestVerifyCode
{
    if (phoneTextField.text.length!=11||![[SUtilityTool shared] validateMobile:phoneTextField.text])
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
    [HttpRequest requestInviteCodeWithPhone:phoneTextField.text from:@"1" success:^(NSDictionary *dict) {
              NSString *message = [dict objectForKey:@"msg"];
        if ([[dict allKeys] containsObject:@"returncode"]) {
            [Toast hideToastActivity];
            NSString *returncode = [NSString stringWithFormat:@"%@",dict[@"returncode"]];
            if ([returncode isEqualToString:@"0000"]) {
                [MBToastHud show:message image:[UIImage imageNamed:@"Unico/success"] spin:NO hide:YES Interaction:NO];
            }
            else
            {
              [MBToastHud show:message image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
            }
        }
       
  
//      [MBToastHud show:message image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
//        [Toast makeToast:message mask:YES];
    } failed:^(NSError *error) {
        [Toast hideToastActivity];
//        [Toast makeToast:@"获取验证码失败"];
        [MBToastHud show:@"获取验证码失败" image:[UIImage imageNamed:@"Unico/fail"] spin:NO hide:YES Interaction:NO];
    }];
}

//倒计时
- (void)timerCountDown
{
    if (timeNum > 1) {
        if (requestCodeBtn.isEnabled) {
            [requestCodeBtn setEnabled:NO];
            [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        }
        NSString *title = [NSString stringWithFormat:@"%d秒后重新发送",(int)timeNum];
        [requestCodeBtn setTitle:title forState:UIControlStateDisabled];
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

//服务协议
- (void)showAgreeConditions
{
    FileReaderViewController *readerVC=[[FileReaderViewController alloc] initWithNibName:@"FileReaderViewController" bundle:nil];
    readerVC.fileName=@"服务条款";
    [self.navigationController pushViewController:readerVC animated:YES];
}

- (BOOL)validateUserName:(NSString *)userName
{
    //只含有汉字、数字、字母
    //    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    //    1-18位 不能全部为数字 不能全部为字母 必须包含字母和数字
    //    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isOk = [phoneTest evaluateWithObject:userName];
    return isOk;
}
- (BOOL)validatePassWord:(NSString *)passWord
{
    //只含有汉字、数字、字母
    //    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    //    1-18位 不能全部为数字 不能全部为字母 必须包含字母和数字
    //    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSString *regex =   @"^[0-9A-Za-z]{6,12}+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:passWord];
}

//提交
- (void)submitClick
{
    if (![[SUtilityTool shared] validateMobile:phoneTextField.text]) {
        [Utils alertMessage:@"请输入正确的手机号！您将收到验证码短信"];
        return;
    }
    NSString *nickName = [nickNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([nickName length] == 0) {
        [Utils alertMessage:@"请输入昵称！"];
        return;
    }
    if (![self validateUserName:nickName] || [self convertToInt:nickName] > 21) {
        [Utils alertMessage:@"昵称只能输入1-20个字符，仅限字母，中文和数字"];
        return;
    }
    if ([passwordTextField.text length] == 0) {
        [Utils alertMessage:@"请输入密码"];
        return;
    }
    NSRange range = [passwordTextField.text rangeOfString:@" "];
    if (range.length) {
        [Utils alertMessage:@"密码只能由6-12位数字或字母组成"];
        return;
    }
    
    NSString *verifyCode = [verifyCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([verifyCode length] == 0) {
        [Utils alertMessage:@"请输入验证码"];
        return;
    }
    if ([verifyCode length] != 6) {
        [Utils alertMessage:@"请输入正确的验证码"];
        return;
    }
    [Toast makeToastActivity:@"注册中..." hasMusk:YES];
    [self login];
}

-(void)login {
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneTextField.text,@"mobile_num",
                          passwordTextField.text,@"mobile_pwd",
                          @"",@"eno",
                          @"美特斯邦威",@"ename",
                          nickNameTextField.text,@"nick_name",
                          verifyCodeTextField.text,@"active_code",
                          nil];
    if ([inviteTextField.text length] > 0) {
        [dict setObject:inviteTextField.text forKey:@"invitation_code"];
    }
    
    NSString *rst = [sns registerActiveWithDictionary:dict tipMsg:msg];
    
    if ([rst isEqualToString:SNS_RETURN_SUCCESS])
    {
        [Toast hideToastActivity];
//        [Toast makeToast:@"注册成功！"];
        [Toast makeToastSuccess:@"注册成功!"];
        
        //友盟统计注册事件
        [MobClick event:@"registerID"];
        
        //写注册标志
        [AppSetting setRegistState:@"0"];
        [AppSetting save];
        
        //填loginviewcontroller帐号、密码
        g_loginViewController.txtLoginUserID.text=[[NSString alloc] initWithFormat:@"%@",phoneTextField.text];
        g_loginViewController.txtLoginPassword.text=[[NSString alloc] initWithFormat:@"%@",passwordTextField.text];
        
        //自动登录
        [g_loginViewController rememberPassword];
        [g_loginViewController btnLoginClick:nil];
    }
    else
    {
        [Toast hideToastActivity];
        [Utils alertMessage:msg.length==0?@"注册失败！":msg];
    }
}

#pragma mark uitableview datasource delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (void)configTextFieldWithRow:(NSInteger)row textField:(UITextField *)field
{
    NSString *placeHold = @"";
    switch (row) {
        case 0:
        {
            phoneTextField = field;
            phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            placeHold = @"手机号码";
        }
            break;
        case 1:
        {
            nickNameTextField = field;
            placeHold = @"昵称";
        }
            break;
        case 2:
        {
            passwordTextField = field;
            field.secureTextEntry = YES;
            passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
            placeHold = @"设置密码";
        }
            break;
        case 3:
        {
            verifyCodeTextField = field;
            verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
            placeHold = @"验证码";
        }
            break;
    
        default:
            break;
    }
    [field setPlaceholder:placeHold];
}

- (void)addRegisterButtonInView:(UIView *)view
{
    if (requestCodeBtn) {
        return;
    }
    requestCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
    [requestCodeBtn addTarget:self action:@selector(requestVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [requestCodeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH - 160, 0, 160, 50)];
    [requestCodeBtn setEnabled:NO];
    [requestCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [requestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [view addSubview:requestCodeBtn];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RegistCell = @"RegistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RegistCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RegistCell];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, UI_SCREEN_WIDTH-30, 50)];
        [textField setDelegate:self];
        [textField setTag:100];
        [textField setTextColor:COLOR_C6];
        [textField setFont:FONT_t3];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:textField];
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:100];
    if (indexPath.section == 0) {
        [self configTextFieldWithRow:indexPath.row textField:textField];
        if (indexPath.row == 3) {
            [self addRegisterButtonInView:cell.contentView];
        }
    }else{
        inviteTextField = textField;
        [inviteTextField setPlaceholder:@"好友邀请码"];
        inviteTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}

#pragma mark uitextfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view.superview setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:241.0/255.0 alpha:1]];
    
    if ([textField isEqual:verifyCodeTextField] || [textField isEqual:inviteTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setTransform:CGAffineTransformMakeTranslation(0, -85)];
        }];
    }
}

-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength+1;
    
}

- (void)judgeSubmitButtonStatus
{
    int length = [self convertToInt:nickNameTextField.text];
    if ([phoneTextField.text length] == 11 && length > 1 && [passwordTextField.text length] > 5 && [passwordTextField.text length] < 13 && [verifyCodeTextField.text length] == 6) {
        if (!submitBtn.isEnabled) {
            [submitBtn setEnabled:YES];
            [submitBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
        }
    }else{
        if (submitBtn.isEnabled) {
            [submitBtn setEnabled:NO];
            [submitBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==phoneTextField && [toBeString length] > 10)
    {
        if ([toBeString length] > 10) {
            textField.text = [toBeString substringToIndex:11];
            if (!requestCodeBtn.isEnabled) {
                if (!_timer ) {
                    [requestCodeBtn setEnabled:YES];
                    [requestCodeBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
                }
                if ([verifyCodeTextField.text length] >= 6) {
                    if (!submitBtn.isEnabled) {
                        [submitBtn setEnabled:YES];
                        [submitBtn setBackgroundColor:[Utils HexColor:0X333333 Alpha:1.0]];
                    }
                }
            }
            return NO;
        }
        if ([toBeString length] < 11) {
            if (requestCodeBtn.isEnabled) {
                [requestCodeBtn setEnabled:NO];
                [requestCodeBtn setBackgroundColor:[Utils HexColor:0XE2E2E2 Alpha:1.0]];
            }
            return YES;        }
    }
    if (textField == nickNameTextField && stopInPut) {
        return NO;
    }
    if (textField == verifyCodeTextField && [toBeString length] > 6) {
        return NO;
    }
    if (textField == passwordTextField && [toBeString length] > 12) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self judgeSubmitButtonStatus];
    if (textField != nickNameTextField) {
        return;
    }
    NSInteger length = [self convertToInt:textField.text];
    if (length > 20) {
        stopInPut = YES;
    }else{
        stopInPut = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)touchTap
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
