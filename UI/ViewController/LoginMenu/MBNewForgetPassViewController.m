//
//  MBNewForgetPassViewController.m
//  Wefafa
//
//  Created by fafatime on 14/12/18.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBNewForgetPassViewController.h"
#import "NavigationTitleView.h"
#import "Utils.h"
#import "Toast.h"
#import "WeFaFaGet.h"
@interface MBNewForgetPassViewController ()
{
    BOOL _ifPhoneOK;
    BOOL _ifCheckCodeOK;
}
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MBNewForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //new headview
//    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
//    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [view createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:nil selectorMenu:nil];
//    view.lbTitle.text=@"找回密码";
//    [self.viewHead addSubview:view];
    
    self.showView.backgroundColor = TITLE_BG;
    retrievid=[[NSMutableString alloc] initWithFormat:@""];
    _txtPhone.keyboardType = UIKeyboardTypeNumberPad;
    _txtPhone.delegate = self;
    _txtValidCode.keyboardType = UIKeyboardTypeNumberPad;
    
    _ifCheckCodeOK = NO;
    _ifPhoneOK = NO;
    
    [_checkCodeBtn.layer setCornerRadius:4.0];
    [_nextBtn.layer setCornerRadius:4.0];
    
    if(![_defaultPhone isEqualToString:@""]){
        _txtPhone.text = _defaultPhone;
        if ([_txtPhone.text length] == 11 ) {
            [self initBtnSet];
        }
    }

    //添加点击空白区域收回键盘的手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.showView.frame));
}
-(void)initBtnSet
{
    [_checkCodeBtn setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
    _ifPhoneOK = YES;


}

//在代理中做判断，手势将不会将按钮的方法给屏蔽掉
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.view endEditing:YES];
}

- (IBAction)btnGetValidCodeClick:(id)sender{
    if (_txtPhone.text.length!=11)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入接收验证码的手机号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [_txtPhone becomeFirstResponder];
        return;
    }
    _btnGetValidCode.enabled=NO;
    [Toast makeToastActivity:@"获取验证码..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *flag=[[NSMutableString alloc] initWithFormat:@""];
        [retrievid setString:@""];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        NSString *retcode=[sns getPasswordValidCode:_txtPhone.text returnFlag:flag returnRetrieveID:retrievid returnMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            if ([retcode isEqualToString:SNS_RETURN_SUCCESS])
            {
                mobile=[[NSString alloc] initWithFormat:@"%@",_txtPhone.text];
//                [Toast makeToast:@"验证码已经发送到您的手机，\n请填入验证码重置密码！" duration:3.0 position:@"center"];
                [Toast makeToastSuccess:@"验证码已经发送到您的手机，\n请填入验证码重置密码！"];
                [_txtValidCode becomeFirstResponder];
            }
            else
            {
                [Toast makeToast:msg.length==0 ? @"获取验证码失败" : msg duration:3.0 position:@"center"];
                [_txtPhone becomeFirstResponder];
            }
            _btnGetValidCode.enabled=YES;
        });
    });    
}
- (IBAction)nextBtnClick:(id)sender {
    [_txtPhone resignFirstResponder];
    
    if (_txtPhone.text.length!=11)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入接收验证码的手机号！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [_txtPhone becomeFirstResponder];
        return;
    }

    if (_txtValidCode.text.length!=6)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入收到短信中的验证码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [_txtValidCode becomeFirstResponder];
        return;
    }
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    
    if ([sns resetPassword:_txtPhone.text txtvaildcode:_txtValidCode.text returnMsg:msg])
    {
//        [Utils alertMessage:@"请等待短信发送新的密码后登录！"];
        if(msg.length==0)
        {
            msg=[NSMutableString stringWithFormat:@"请等待短信发送新的密码后登录!"];
        }
        [Utils alertMessage:msg];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [Toast makeToast:@"获取验证码失败，请稍候重试！" duration:2.0 position:@"center"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString *phoneString = [NSMutableString stringWithString:_txtPhone.text];
    NSMutableString *validCodeString = [NSMutableString stringWithString:_txtValidCode.text];
    
    if ([string isEqualToString:@""]) {
        if (textField == _txtPhone) {
            [phoneString deleteCharactersInRange:range];
        }else if(textField == _txtValidCode){
            [validCodeString deleteCharactersInRange:range];
        }
    }
    
    if (textField==_txtPhone && [toBeString length] > 10)
    {
        _ifPhoneOK = YES;
        textField.text = [toBeString substringToIndex:11];
        [self judgeInputIfSatisfied];

        return NO;
    }
    if (textField == _txtPhone && [toBeString length]<11) {
        _ifPhoneOK = NO;
        [self judgeInputIfSatisfied];
        return YES;
    }
    
    if (textField == _txtValidCode && [toBeString length] > 5) {
        
        textField.text = [toBeString substringToIndex:6];
        _ifCheckCodeOK = YES;
        [self judgeInputIfSatisfied];
        return NO;
    }
    if (textField == _txtValidCode && [toBeString length]<6) {
        _ifCheckCodeOK = NO;
        [self judgeInputIfSatisfied];
        return YES;


    }
    return YES;
}

-(void)judgeInputIfSatisfied
{
    if (!_ifPhoneOK ||!_ifCheckCodeOK) {
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
    }
    if (!_ifPhoneOK) {
        [self.checkCodeBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
    }else if(_ifPhoneOK)
    {
        [self.checkCodeBtn setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
    }
    if (_ifCheckCodeOK&&_ifPhoneOK) {
        [self.nextBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1.0] forState:UIControlStateNormal];
        [self.nextBtn setBackgroundColor:[Utils HexColor:0xffde00 Alpha:1.0]];
    }
    
}
- (IBAction)btnBackClick:(id)sender {
    [Toast hideToastActivity];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
