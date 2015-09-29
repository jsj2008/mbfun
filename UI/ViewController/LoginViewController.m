//
//  LoginViewController.m
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//
//  登陆逻辑需要重构一下。
//

#import "LoginViewController.h"
#import "AppSetting.h"
#import "Utils.h"
#import "Toast.h"
#import "NetUtils.h"
#import "AppDelegate.h"
#import "WeFaFaGet.h"
#import "SQLiteOper.h"
#import "LoadWebViewController.h"
#import "KxMenu.h"
#import "ZipArchive.h"
#import "Base.h"
#import "XMLDictionary.h"
#import "JSONKit.h"
#import "NavigationTitleView.h"
#import "WeiXinUtils.h"
#import "CommMBBusiness.h"
//#import "NewRegisterViewController.h"
#import "SRegisterViewController.h"
//#import "MBNewForgetPassViewController.h"
#import "Utils.h"
#import "SDataCache.h"
#import "ForgetPassViewController.h"

#import "HttpRequest.h"
#import "SHomeViewController.h"
#define kScale (UI_SCREEN_WIDTH/ 375)


static NSString *kCheckBoxUnselected=@"login_unchecked.png";
static NSString *kCheckBoxSelected=@"login_checked.png";

static int loginview_starty=0;

LoginViewController *g_loginViewController;

@interface LoginViewController (){
    // 第三方登陆时候不在文本框显示信息，避免用户体验不好，追加变量保存。
    NSString *_username;
    NSString *_password;
}


@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@end

@implementation LoginViewController
@synthesize dataString;
@synthesize tabbarDataString;

#define DARK_TEXT_COLOR [Utils HexColor:0x333333 Alpha:1.0]

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sections = nil;
        accountArray = [NSMutableArray array]; // [AppSetting getHisLoginAccount]; 
        isShowList = NO;
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated{
    [Toast hideToastActivity];
    
    _txtLoginUserID.text = @"";
    _txtLoginPassword.text = @"";
}

- (void)viewDidLoad{
    [super viewDidLoad];

    
    //背景颜色
    [_tvLogin setBackgroundColor: [UIColor whiteColor]];
    _tvLogin.scrollEnabled = NO;
    [_accountTableViewCell setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.1]];
    [_passwdTableViewCell setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.1]];

    [_loginBtn setTitle:LOGIN_BUTTON_TEXT forState:UIControlStateNormal];
    [_loginBtn setTitleColor:LOGIN_BUTTON_TEXTCOLOR forState:UIControlStateNormal];
    
    //账号密码 输入字体颜色
    _txtLoginPassword.textColor = [UIColor lightGrayColor];//LOGIN_MID_TEXTCOLOR;
    _txtLoginUserID.textColor = [UIColor lightGrayColor];//LOGIN_MID_TEXTCOLOR;
    //KVC
    [_txtLoginUserID setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_txtLoginPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //登录设置按钮颜色
    _loginSetBtn.titleLabel.textColor = LOGIN_SETTING_TEXTCOLOR;
    
    _btnfogest.hidden=YES;
    _zhuceBtn.hidden=YES;
    _loginSetBtn.hidden=YES;
    [_loginSetBtn setTitle:@"登录设置" forState:UIControlStateNormal];
    
    // 这里应该可以简化
    [self setBtnStatus];
    
    g_loginViewController = self;
    sections = @[@"_login", @[_accountTableViewCell, _passwdTableViewCell]];
    
    [self loadViewData];
    [self hideComboBox];
    
    _tvLogin.userInteractionEnabled = YES;  //必须为YES才能响应事件
    
    [Utils sendLogFile];

    _txtLoginUserID.keyboardType = UIKeyboardTypeEmailAddress;
    
    //添加点击空白区域收回键盘的手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    //键盘弹起视图上移
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(viewUp)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(viewDown)
                                                name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginAccount:) name:@"changeLoginAccount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logInSuccess) name:@"MBFUN_LOGIN_SUC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"MBFUN_LOGIN_FAIL" object:nil];
    
    
    [self subViewsHexColorSet];
    
    [self initSubViews];
}
-(void)changeLoginAccount:(NSNotification *)sender
{
    NSDictionary *senderDic=[sender userInfo];
    NSString *loginAccount = senderDic[@"loginAccount"];
    _txtLoginPassword.text = @"";
    _txtLoginUserID.text = loginAccount;
    
}
// 这里是一些硬编码的设置，应该可以简化
- (void)setBtnStatus {
    if([LOGINALLOWREGISTER isEqual:@"1"])
    {
        _zhuceBtn.hidden=NO;
    }
    if ([LOGINALLOWCHPWD isEqual:@"1"])
    {
        _btnfogest.hidden=NO;
    }
    if ([LOGINALLOWSET isEqual:@"1"])
    {
        _loginSetBtn.hidden=NO;
    }
    if ([LOGINALLOWREGISTER isEqual:@"1"] && [LOGINALLOWCHPWD isEqual:@"0"])
    {
        _zhuceBtn.frame=CGRectOffset(_zhuceBtn.frame, 55, 0);
        _loginSetBtn.frame=CGRectOffset(_loginSetBtn.frame, 55, 0);
    }
    if ([LOGINALLOWREGISTER isEqual:@"0"] && [LOGINALLOWCHPWD isEqual:@"1"])
    {
        _btnfogest.frame=CGRectOffset(_btnfogest.frame, -55, 0);
        _loginSetBtn.frame=CGRectOffset(_loginSetBtn.frame, -55, 0);
    }
}

- (void)initSubViews{
    CGFloat margen = ((375 - 30) * 2 * kScale) / 3;
    UIButton *qqBtn = [[UIButton alloc]initWithFrame:CGRectMake(margen, self.otherLeftLine.bottom + 51 * kScale, 50, 80)];//CGRectMake(100 * kScale, UI_SCREEN_HEIGHT - 180 * kScale - 64 , 50 * kScale, 80 * kScale)];
    [qqBtn setImage:[UIImage imageNamed:@"Unico/qq_login_btn"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(btnQQZoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [qqBtn setTag:111];
    [self.thirdLoginView addSubview:qqBtn];
    UIButton *weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - margen - qqBtn.width, qqBtn.top, qqBtn.width, qqBtn.height)];//CGRectMake(UI_SCREEN_WIDTH - 100 * kScale - 50, UI_SCREEN_HEIGHT - 180 * kScale - 64, 50 * kScale, 80 * kScale)];
    [weixinBtn setImage:[UIImage imageNamed:@"Unico/weixin_login_btn"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(btnWeiXinClick:) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn setTag:222];
    [self.thirdLoginView addSubview:weixinBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavbar];
    _txtLoginPassword.text = @"";
    if ([_txtLoginUserID.text length] > 11) {
        _txtLoginUserID.text = @"";
    }
    UIButton *qqBtn = (UIButton *)[self.thirdLoginView viewWithTag:111];
    UIButton *weixinBtn = (UIButton *)[self.thirdLoginView viewWithTag:222];
    if ([WXApi isWXAppInstalled]) {
        [weixinBtn setHidden:NO];
    }else{
        [weixinBtn setHidden:YES];//YES];
    }
    
    if ([TencentOAuth iphoneQQInstalled]) {
        [qqBtn setHidden:NO];
    }else{
        [qqBtn setHidden:YES];//YES];
    }
}

- (void)LeftReturn:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)subViewsHexColorSet{
    [self.loginUserSeperLine setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
    [self.passWordSeperLine setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
    [self.loginBtn setBackgroundColor:[Utils HexColor:0x3b3b3b Alpha:1.0]];
    [self.loginBtn setTitleColor:[Utils HexColor:0xffffff Alpha:1.] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.quickRegisterBTN setTitleColor:[Utils HexColor:0x919191 Alpha:1.0] forState:UIControlStateNormal];
    [self.forgetPasswordBTN setTitleColor:[Utils HexColor:0x919191 Alpha:1.0] forState:UIControlStateNormal];
    [self.otherLoginWayLabel setTextColor:DARK_TEXT_COLOR];
    [self.qqLabel setTextColor:DARK_TEXT_COLOR];
    [self.weixinLabel setTextColor:DARK_TEXT_COLOR];
    [self.sinaLabel setTextColor:DARK_TEXT_COLOR];
    [self.otherLeftLine setBackgroundColor:DARK_TEXT_COLOR];
    [self.otherRightLine setBackgroundColor:DARK_TEXT_COLOR];
    [self.txtLoginUserID setTextColor:[Utils HexColor:0x333333 Alpha:1.0]];
    [self.txtLoginUserID setValue:[Utils HexColor:0x919191 Alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtLoginPassword setTextColor:[Utils HexColor:0x333333 Alpha:1.0]];
    [self.txtLoginPassword setValue:[Utils HexColor:0x919191 Alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    self.loginBtn.layer.cornerRadius = 6;
    self.loginBtn.layer.masksToBounds = YES;
}

-(void)clearUserPassInfo{
    _txtLoginPassword.text = @"";
    _txtLoginUserID.text = @"";
    [AppSetting setPassword:@"" Jid:sns.jid PassDes:sns.password];
    [AppSetting setUserID:@""];
    [AppSetting setRememberPasswd:NO];
    [_tvLogin reloadData];
}

-(void)viewUp{
    if (loginview_starty<90) return;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.center=CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2-105);
    }];
}

-(void)viewDown{
    if (loginview_starty<90) return;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+10);
    }];
}

//在代理中做判断，手势将不会将按钮的方法给屏蔽掉
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.view endEditing:YES];
}

- (void)viewDidUnload {
    OBJC_RELEASE(sections);
    
    [self setTvLogin:nil];
    [self setAccountTableViewCell:nil];
    [self setPasswdTableViewCell:nil];
    [self setViewBottom:nil];
    [self setTxtLoginUserID:nil];
    [self setTxtLoginPassword:nil];
    [self setImgChecked:nil];
    [self setBtnShowList:nil];
    [self setBtnLogin:nil];
    [super viewDidUnload];
}

- (void)dealloc{
    OBJC_RELEASE(sections);
    OBJC_RELEASE(accountArray);
}

// --------------------------------------------------------------------------------------------------------------------------------
#pragma mark - handle ui in tableview (应该不是很必要）
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sections count] / 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headername = [sections objectAtIndex:section*2+0];
    if ([headername characterAtIndex:0] == '_') return nil;
    return headername;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tablesection = [sections objectAtIndex:section*2+1];
    
    NSInteger re = [tablesection count];
    if (isShowList) re += accountArray.count;
    
    return re;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tablesection = [sections objectAtIndex:[indexPath section]*2+1];
    UITableViewCell *cellX = nil;
    
    if (!isShowList || indexPath.row == 0 || indexPath.row == [tablesection count]+accountArray.count-1)
        cellX = [tablesection objectAtIndex:indexPath.row==0?0:1];
    
    NSString *AIdentifier = cellX == nil ? @"hisaccountTableViewCell" : [cellX reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AIdentifier];
    if (cell == nil) {
        if (cellX)
        {
            cell = cellX;
        }
        else
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HisAccountTableViewCell" owner:self options:nil] lastObject];
            UIButton *btnX = (UIButton*)[cell.contentView viewWithTag:1002];
            btnX.tag = indexPath.row;
            [btnX addTarget:self action:@selector(btnDeleteAccount:)forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if (cellX == nil)
    {
        NSString *accountX = accountArray[indexPath.row-1];
        [(UILabel*)[cell.contentView viewWithTag:1000] setText:[_txtLoginUserID.text isEqualToString:accountX]?@"√":@""];
        [(UILabel*)[cell.contentView viewWithTag:1001] setText:accountX];
        [cell.contentView setTag:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //展开列表被选择
    if (isShowList&&[accountArray count]>0&&indexPath.row>0&&indexPath.row<accountArray.count+2-1)
    {
        NSInteger idx=indexPath.row-1;
    
        //设置value
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _txtLoginUserID.text = [NSString stringWithFormat:@"%@",[accountArray objectAtIndex:idx]];
        [self refreshSettingData:_txtLoginUserID.text];
        //收起
        [self inclusiveList];
        [_txtLoginPassword becomeFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _viewBottom.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _viewBottom;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 59;
    }
    
    return 44;
}

// --------------------------------------------------------------------------------------------------------------------------------
#pragma mark - 登陆按钮点击
- (IBAction)btnViewLoginMenu_OnClick:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    NSArray *menuItems=@[
                         [KxMenuItem menuItem:@"登录设置"
                                        image:[UIImage imageNamed:@"login_settings.png"]
                                       target:self
                                       action:@selector(btnLoginSet_OnClick:)],
                         [KxMenuItem menuItem:@"用户注册"
                                        image:[UIImage imageNamed:@"login_register.png"]
                                       target:self
                                       action:@selector(btnRegisterClick:)],
                         [KxMenuItem menuItem:@"找回密码"
                                        image:[UIImage imageNamed:@"login_findpass.png"]
                                       target:self
                                       action:@selector(btnGetPasswordClick:)]
                         ];
    
    [KxMenu setIconSize:CGSizeMake(25,25)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
    [KxMenu showMenuInView:self.view
                  fromRect:_btnMenu.frame
                 menuItems:menuItems];
}

// 忘记密码
- (IBAction)btnGetPasswordClick:(id)sender {
    ForgetPassViewController *forgetPassvc = [[ForgetPassViewController alloc] init];
    [self.navigationController pushViewController:forgetPassvc animated:YES];
}

// 注册
- (IBAction)btnMBRegisterClick:(id)sender {
    [self btnRegisterClick:nil];
}

- (IBAction)btnShowList:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    [_txtLoginUserID becomeFirstResponder];

    if ([accountArray count]>0) {

        if (isShowList==NO)
        {
            isShowList=YES;

            NSMutableArray *arCells=[NSMutableArray array];
            for(int i=0;i<[accountArray count];i++)
            {
                [arCells addObject:[NSIndexPath indexPathForRow:i+1 inSection:0]];
            }
            [_tvLogin insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationTop];
            [_btnShowList setImage:[UIImage imageNamed:@"icon_arrowup.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self inclusiveList];
        }
    }
}

- (IBAction)btnRememberClick:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    [self didEndMenu:nil];
    
    [AppSetting setRememberPasswd:![AppSetting getRememberPasswd]];
    if ([AppSetting getRememberPasswd])
        [_imgChecked setImage:[UIImage imageNamed:kCheckBoxSelected]];
    else
        [_imgChecked setImage:[UIImage imageNamed:kCheckBoxUnselected]];
}

- (void)rememberPassword{
    [AppSetting setRememberPasswd:YES];
    [_imgChecked setImage:[UIImage imageNamed:kCheckBoxSelected]];
}

- (IBAction)txtField_OnBeginEdit:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    [self didEndMenu:nil];
    if (sender == _txtLoginPassword)
    {
        [self inclusiveList];
    }
}

- (IBAction)btnLoginClick:(id)sender {
    isThirdPartLogin=NO;
    sns.isThirdLogin=NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isThirdLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loginIM];
}


#pragma mark - 登陆IM？这里理论上应该可以清理？

//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile
{
    //    //手机号以13， 15，18开头，八个 \d 数字字符
    //    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    return [phoneTest evaluateWithObject:mobile];
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
    
}

-(void)loginIM{
    //[AppSetting closeThirdLoginAccount];
    [self didEndMenu:nil];
    
    // 变量命名改一改
    NSString *userId = _username?_username:_txtLoginUserID.text;
    NSString *pwd = _password?_password:_txtLoginPassword.text;
    
    if ([userId length] == 0 && [pwd length] == 0) {
        [self alertLoginErrorWithString:@"请输入账号和密码后再登录"];
        [Toast hideToastActivity];
        return;
    }
    if ([userId length] == 0) {
        [self alertLoginErrorWithString:@"请输入账号后再登录"];
        [Toast hideToastActivity];
        return;
    }
    if (![self validateMobile:userId] && !sns.isThirdLogin) {
        [self alertLoginErrorWithString:@"请输入正确账号"];
        [Toast hideToastActivity];
        return;
    }
    if ([pwd length] == 0) {
        [self alertLoginErrorWithString:@"请输入密码后再登录"];
        [Toast hideToastActivity];
        return;
    }
     [Toast hideToastActivity];
    [Toast makeToastActivity:@"正在连接..." hasMusk:YES];
    
    // 注意清空
    _username = nil;
    _password = nil;
    if(sns.isThirdLogin)
    {
        [AppSetting setUserID:sns.myStaffCard.login_account];
    }
    else
    {
        [AppSetting setUserID: userId];
        
    }
//    [AppSetting setUserID:id1];
    [AppSetting setPassword:pwd];
    [self rememberPassword];
    
    if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])){
        [NSThread detachNewThreadSelector:@selector(loginThread) toTarget:self withObject:nil];
    }
    else{
        [self netConnectError:nil];
    }

    return;
    if ([pwd length]>0) {
        if ([userId length]>0) {
            [Toast makeToastActivity:@"正在连接..." hasMusk:YES];
            
            // 注意清空
            _username = nil;
            _password = nil;
            if(sns.isThirdLogin)
            {
               [AppSetting setUserID:sns.myStaffCard.login_account];
            }
            else
            {
                [AppSetting setUserID: userId];
                
            }
            [AppSetting setPassword:pwd];
            [self rememberPassword];
            
            if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected]))
                [NSThread detachNewThreadSelector:@selector(loginThread) toTarget:self withObject:nil];
            else
                [self netConnectError:nil];
            
        }
        else {
            [Toast hideToastActivity];
            [self alertLoginError];

            [_txtLoginUserID becomeFirstResponder];
        }
        
    } else {
        if ([userId length]<=0) {
            [self alertLoginError];

            [_txtLoginUserID becomeFirstResponder];
        }
        else {
            [self alertLoginError];

            [_txtLoginPassword becomeFirstResponder];
        }
    }
}


// TODO: 需要使用新的登陆流程，请联调接口
// 目前先屏蔽第三方登陆测试。
// 明天核对 LoginWithRegisterExternal  和  UserAuthentiction 接口
//
-(void)newLogin{
    
}

-(void)newLoginThird:(NSDictionary*)info{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
    dic[@"ProviderLoginKey"] = [AppSetting getUserID];
    dic[@"LoginProviderName"] = @"weixin.qq.com";

    [HttpRequest accountGetRequestPath:nil methodName:@"LoginWithRegisterExternal" params:dic success:^(NSDictionary *dict) {
        NSLog(@"Login Result : %@",dict);
    } failed:^(NSError *error) {
        
    }];
}

- (void)alertLoginErrorWithString:(NSString *)string
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
}

- (void) alertLoginError{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"登录账号或密码错误,请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
}

- (IBAction)textFieldDidEnd_Next:(id)sender {
    [self btnLoginClick:nil];
}

NSString *oldtxtLoginUserID = nil;
- (IBAction)textLoginIDEditingEnd:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    if ([oldtxtLoginUserID isEqualToString:_txtLoginUserID.text]) return;
    oldtxtLoginUserID=_txtLoginUserID.text;
    //    [[AppDelegate App].viewController refreshSettingData:txtLoginUserID.text];
    [self refreshSettingData:_txtLoginUserID.text];
}

- (IBAction)txtLoginIDEditingChanged:(id)sender {
    //[AppSetting closeThirdLoginAccount];
    if ([_txtLoginUserID.text isEqualToString:[AppSetting getUserID]]==NO)
    {
//        _txtLoginPassword.text=@"";
        [_imgChecked setImage:[UIImage imageNamed:kCheckBoxUnselected]];
    }
}

#pragma mark - QQ登陆

- (void)btnQQZoneClick:(id)sender {
    _username = _password = nil;
    sns.shareOrLogin=NO;
    isThirdPartLogin = YES;
    [Toast makeToast:@"使用QQ空间登录..." duration:1 position:@"center"];
    CommonEventHandler *completeEvent=[CommonEventHandler instance:self selector:@selector(GetQQUserInfoCompleteEvent:eventData:)];
    [[AppDelegate App]qqLogin:completeEvent];
}

- (void)GetQQUserInfoCompleteEvent:(id)sender eventData:(id)eventData
{
    [Toast hideToastActivity];
    //出错显示提示
    if ([eventData isKindOfClass:[NSString class]])
    {
        [Toast hideToastActivity];
        [Utils alertMessage:eventData];
        return;
    }
    
    NSDictionary *dict=eventData;
    
    //QQ登录IM服务器（自动注册）
    NSMutableString *jid=[[NSMutableString alloc] initWithCapacity:64];
    NSMutableString *loginid=[[NSMutableString alloc] initWithCapacity:64];
    NSMutableString *password=[[NSMutableString alloc] initWithCapacity:64];
    //{"city":"成都","yellow_vip_level":"0","vip":"0","figureurl_qq_2":"http://q.qlogo.cn/qqapp/1102534852/D07201BB218BE5BD0C0BB21A465F7B1E/100","is_yellow_year_vip":"0","province":"四川","ret":0,"figureurl":"http://qzapp.qlogo.cn/qzapp/1102534852/D07201BB218BE5BD0C0BB21A465F7B1E/30","is_yellow_vip":"0","level":"0","gender":"男","figureurl_1":"http://qzapp.qlogo.cn/qzapp/1102534852/D07201BB218BE5BD0C0BB21A465F7B1E/50","figureurl_qq_1":"http://q.qlogo.cn/qqapp/1102534852/D07201BB218BE5BD0C0BB21A465F7B1E/40","figureurl_2":"http://qzapp.qlogo.cn/qzapp/1102534852/D07201BB218BE5BD0C0BB21A465F7B1E/100","msg":"","nickname":"彩色☆酸葡萄","is_lost":0}
    
    NSString *msg=[[NSString alloc] initWithFormat:@"QQ用户%@登录中...",dict[@"nickname"]];
    [Toast makeToastActivity:msg hasMusk:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SNSStaffFull *mySelfStaffInfo=[[SNSStaffFull alloc] init];
        NSMutableArray *rosterList=[[NSMutableArray alloc] init];
        NSString * rst=[sns snsQQLogin:dict[@"openid"] nickname:dict[@"nickname"] gender:dict[@"gender"] province:dict[@"province"] city:dict[@"city"] headimgurl:dict[@"figureurl_qq_2"] returnJID:jid returnLoginID:loginid returnPassword:password mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rst isEqualToString:SNS_RETURN_SUCCESS]) {

                [g_sqlite open:sns.jid];
                if ([g_sqlite isOpened])
                {
                    [sqlite insertStaff:mySelfStaffInfo];
                    for (int i=0; i<rosterList.count;i++) {
                        [sqlite insertStaff:rosterList[i]];
                    }
                }
                
                _username = [NSString stringWithFormat:@"%@",loginid];
                _password = [NSString stringWithFormat:@"%@",password];
                _txtLoginUserID.text = @"";
                _txtLoginPassword.text = @"";
                isThirdPartLogin = NO; //为啥是no呢
//                isThirdPartLogin=YES;
                sns.isThirdLogin=YES;

                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isThirdLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:@"qq" forKey:@"loginPlatform"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"loginPlatformInfo"];
                [NSUserDefaults standardUserDefaults];
                
                [self loginIM];

            }
            else
            {
                [Toast hideToastActivity];
                [Utils alertMessage:@"QQ用户登录失败！"];
            }
        });
    });
}

#pragma mark - 微信登陆

//////////////////////////
- (IBAction)btnWeiXinClick:(id)sender {
    _username = _password = nil;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        [Toast makeToast:@"使用微信登录..." duration:1 position:@"center"];
        CommonEventHandler *completeEvent=[CommonEventHandler instance:self selector:@selector(GetWXUserInfoCompleteEvent:eventData:)];
        [wxUtils sendAuthRequest:completeEvent];
    } else {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"安装微信" message:@"请安装新版微信后，再尝试登录！" delegate:self cancelButtonTitle:@"安装" otherButtonTitles:@"取消", nil];
        alertView.tag=100;
        [alertView show];
    }
}

// TODO:清理下代码，并且微信登录会密码错误。QQ也会。。。。
// TODO:添加微博的第三方登陆（后续改用ShareSDK可以考虑）
- (void)GetWXUserInfoCompleteEvent:(id)sender eventData:(id)eventData
{
    //出错显示提示
    if ([eventData isKindOfClass:[NSString class]])
    {
        [Toast hideToastActivity];
        [Utils alertMessage:eventData];
        return;
    }
    
    NSDictionary *dict=eventData;
    //微信登录IM服务器（自动注册）
    NSMutableString *jid=[[NSMutableString alloc] initWithCapacity:64];
    NSMutableString *loginid=[[NSMutableString alloc] initWithCapacity:64];
    NSMutableString *password=[[NSMutableString alloc] initWithCapacity:64];
    //{"unionid":"oueRHt0rZI7r1mZZKNMf49Itoh1M","logintype":"02","city":"Chengdu","openid":"ooQItuLiKn37XHLefmCo4x7Lk6xE","code":"meibang","headimgurl":"http://wx.qlogo.cn/mmopen/jSpxAtXaOdwegb06s7O45Q46ib5CkWwsf3NuWy02lPk7xrqSoXzObKyEaP9MpdRbdOUSLNWOBicggKspWibicTYcYoGvw6e5X6Sia/0","eno":"meibang","appid":"meibang","sex":1,"province":"Sichuan","nickname":"程宇冰"}

    NSString *msg=[[NSString alloc] initWithFormat:@"微信用户%@登录...",dict[@"nickname"]];
    [Toast hideToastActivity];
    [Toast makeToastActivity:msg hasMusk:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        SNSStaffFull *mySelfStaffInfo=[[SNSStaffFull alloc] init];
        NSMutableArray *rosterList=[[NSMutableArray alloc] init];
        //wxUtils.WXOpenID  换为第一个dict[@"unionid"]
        NSString * rst=[sns snsWeiXinLogin:dict[@"unionid"] nickname:dict[@"nickname"] sex:dict[@"sex"] province:dict[@"province"] city:dict[@"city"] headimgurl:dict[@"headimgurl"] unionid:dict[@"unionid"] returnJID:jid returnLoginID:loginid returnPassword:password mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rst isEqualToString:SNS_RETURN_SUCCESS]) {
                [g_sqlite open:sns.jid];   
                if ([g_sqlite isOpened])
                {
                    [sqlite insertStaff:mySelfStaffInfo];
                    for (int i=0; i<rosterList.count;i++) {
                        [sqlite insertStaff:rosterList[i]];
                    }
                }
                
                _username = [NSString stringWithFormat:@"%@",loginid];
                _password = [NSString stringWithFormat:@"%@",password];
                _txtLoginUserID.text = @"";
                _txtLoginPassword.text = @"";
               
                isThirdPartLogin=NO;  //为啥是no呢 改为yes// 改为yes 会有重号问题，LXJ --- IM登陆的还是以前的im

                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isThirdLogin"];
                [[NSUserDefaults standardUserDefaults] setObject:@"wx" forKey:@"loginPlatform"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"loginPlatformInfo"];
                [NSUserDefaults standardUserDefaults];
                sns.isThirdLogin=YES;
                [self loginIM];
//                [self newLoginThird:dict]; // test new login
            }
            else
            {
                [Toast hideToastActivity];
                [Utils alertMessage:@"微信用户登录失败！"];
            }
        });
    });
}


- (IBAction)btnRegisterClick:(id)sender {

//    NewRegisterViewController *newRegister = [[NewRegisterViewController alloc]initWithNibName:@"NewRegisterViewController" bundle:nil];
    SRegisterViewController *newRegister = [[SRegisterViewController alloc] init];
    [self.navigationController pushViewController:newRegister animated:YES];

}
-(void)loginGetToken
{
    // wefafa sns 登录成功
    // TODO: 梳理登录逻辑。
    // 登录成功？
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginIn" object:nil];
    //
    /*
     "active_date" = "2015/6/9 18:08:15";
     "attenstaff_num" = 0;
     "dept_id" = 100001;
     duty = "\U9020\U578b\U5e08";
     eno = 100001;
     "fans_num" = 6;
     jid = "MD00031149@fafacn.com";
     "last_login_date" = "2015/7/28 15:04:18";
     "ldap_uid" = "99c23812-4814-466e-b9ad-054b1c2262ef";
     "login_account" = MD00031149;
     mobile = 15153421111;
     "nick_name" = ceshihuanjing92897w;
     openid = "99c23812-4814-466e-b9ad-054b1c2262ef";
     "photo_path" = "http://10.100.22.213/sources/designer/Head/MD00031149/1079ab72-e636-4bee-ae0b-6726c853ae64--A120x120.png";
     "photo_path_big" = "http://10.100.22.213/sources/designer/Head/MD00031149/1079ab72-e636-4bee-ae0b-6726c853ae64--A120x120.png";
     "photo_path_small" = "http://10.100.22.213/sources/designer/Head/MD00031149/1079ab72-e636-4bee-ae0b-6726c853ae64--A120x120.png";
     "publish_num" = 0;
     "register_date" = "2015/6/9 18:08:15";
     "self_desc" = 123;
     "sex_id" = "\U5973";
     "user_vip_type" = 0;
     "work_phone" = "";
    */
    //
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"currentversion－－－%@",currentVersion);
    NSDictionary *json = @{
                           @"id":sns.myStaffCard.ldap_uid,
                           @"nickName":sns.myStaffCard.nick_name,
                           @"headPortrait":sns.myStaffCard.photo_path_big,
                           @"phoneNumber":sns.myStaffCard.mobile,
                           @"head_v_type":sns.myStaffCard.user_vip_type,
                           @"register_date":[NSString stringWithFormat:@"%@",sns.myStaffCard.register_date],
                           @"active_date":[NSString stringWithFormat:@"%@",sns.myStaffCard.active_date],
                           @"attenstaff_num":[NSNumber numberWithInt:sns.myStaffCard.attenstaff_num],
                           @"dept_id":sns.myStaffCard.dept_id,
                           @"duty":sns.myStaffCard.duty,
                           @"eno":sns.myStaffCard.eno,
                           @"fans_num":[NSNumber numberWithInt:sns.myStaffCard.fans_num],
                           @"jid":sns.myStaffCard.jid,
                           @"last_login_date":[NSString stringWithFormat:@"%@",sns.myStaffCard.last_login_date],
                           @"ldap_uid":sns.ldap_uid,
                           @"login_account":sns.myStaffCard.login_account,
                           @"mobile":sns.myStaffCard.mobile,
                           @"openid":sns.myStaffCard.openid,
                           @"photo_path":sns.myStaffCard.photo_path,
                           @"photo_path_big":sns.myStaffCard.photo_path_big,
                           @"photo_path_small":sns.myStaffCard.photo_path_small,
                           @"publish_num":[NSNumber numberWithInt:sns.myStaffCard.publish_num],
                           @"self_desc":sns.myStaffCard.self_desc,
                           @"user_vip_type":sns.myStaffCard.user_vip_type,
                           @"work_phone":sns.myStaffCard.work_phone,
                           @"versionName":currentVersion,
                           };

    [[SDataCache sharedInstance] loginAccount:[AppSetting getUserID] password:[AppSetting getPassword] json:json];
    
}

#pragma mark - 子线程处理登陆？ 理论上可以优化？
-(void)loginThread{
    @autoreleasepool {
        if (sns.isThirdLogin) {
//            [[[[AppDelegate App] xmppConnectDelegate] xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
//            if (![[[AppDelegate App] xmppConnectDelegate] connect])
//            {
//                [Toast hideToastActivity];
//                [self performSelectorOnMainThread: @selector(netConnectError:) withObject: @"连接服务器失败,请您稍候再试！" waitUntilDone: NO];
//            }
            [self loginGetToken];
            
//            [self  logInSuccess];
        
            
        } else {
            
            SNSStaffFull *mySelfStaffInfo=[[SNSStaffFull alloc] init];
            NSMutableArray *rosterList=[[NSMutableArray alloc] init];
            NSString *st= [sns snsLogin:[AppSetting getUserID] Password:[AppSetting getPassword] mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
            
            if (![st isEqual:SNS_RETURN_SUCCESS]) {
                [self performSelectorOnMainThread: @selector(netConnectError:) withObject: @"请检查输入的账号和密码是否正确" waitUntilDone: NO];
            } else {
                // wefafa sns 登录成功
                // TODO: 梳理登录逻辑。
                // 登录成功？
//                NSDictionary *json = @{
//                                       @"id":mySelfStaffInfo.ldap_uid,
//                                       @"nickName":mySelfStaffInfo.nick_name,
//                                       @"headPortrait":mySelfStaffInfo.photo_path_big,
//                                       @"phoneNumber":mySelfStaffInfo.mobile
//                                       };
//                [[SDataCache sharedInstance] loginAccount:[AppSetting getUserID] password:[AppSetting getPassword] json:json];
                [self loginGetToken];
                
                [g_sqlite open:sns.jid];
                if ([g_sqlite isOpened])
                {
                    [sqlite insertStaff:mySelfStaffInfo];
                    for (int i=0; i<rosterList.count;i++) {
                        [sqlite insertStaff:rosterList[i]];
                    }
                }
                [AppSetting setPassword:_txtLoginPassword.text Jid:sns.jid PassDes:sns.password];
//                [self performSelectorOnMainThread: @selector(logInSuccess) withObject:nil waitUntilDone: NO];
            }
        }
    }
}

- (void)loginFailed
{
    [Toast hideToastActivity];
//    [Toast makeToast:@"登录失败，请稍候重试"];
}

- (void)logInSuccess
{
    [Toast hideToastActivity];
    NSString *userid = [AppSetting getUserID];
    [AppSetting add:userid];
    [AppSetting setAutoLogin:true];
    [AppSetting save];
    
    [AppSetting createPersonalFileDir];
    sns.isLogin=YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_loginComplete" object:nil];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self popToRootAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)hideToast
{
    
}
-(BOOL)getLoginServer
{
    BOOL rst=NO;
    
    NSString *result=[sns ASIPostJSonRequest:@"/register/getimserver" PostParam:nil];
    if (result==nil) {
        return NO;
    }
    NSDictionary * getres = [self dictionaryWithJsonString:result];
    NSArray *imserverArray = [[getres objectForKey:@"imserver"] componentsSeparatedByString:@":"];
    if (imserverArray==nil) {
        return NO;
    }
    //    rst = YES;
    if ([imserverArray objectAtIndex:0]==nil||[imserverArray objectAtIndex:1]==nil) {
        return NO;
    }
    [AppSetting setIMServer:[imserverArray objectAtIndex:0]];
    [AppSetting setIMServerPort:[[imserverArray objectAtIndex:1]intValue]];
    rst = YES;
    return rst;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(void)netConnectError:(NSString *)msg
{
    UIAlertView *alert=nil;
    if (msg.length>0)
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    else
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert show];
#if ! __has_feature(objc_arc)
    [alert release];
#endif
    
    [Toast hideToastActivity];
    [_txtLoginPassword becomeFirstResponder];
}

-(void)didEndMenu:(id)sender
{
    //[_viewLoginMenu setHidden:YES];
}

-(void) inclusiveList{
    if (isShowList==NO)
        return;
    
    isShowList=NO;
    
    NSMutableArray *arCells=[NSMutableArray array];
    for (int i=1; i<accountArray.count+2-1; i++)
    {
        [arCells addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_tvLogin deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
    
    [_btnShowList setImage:[UIImage imageNamed:@"icon_arrowdown.png"] forState:UIControlStateNormal];
}

-(void)loadViewData{
    self.txtLoginUserID.text=[AppSetting getUserID];
    if ([AppSetting getRememberPasswd])
    {
#ifdef NEED_REMEMBER_PASSWORD
        //取消记住密码关闭此段代码块
//        self.txtLoginPassword.text=[AppSetting getPassword];
//        [_imgChecked setImage:[UIImage imageNamed:kCheckBoxSelected]];
#endif
    }
    else
    {
        self.txtLoginPassword.text=@"";
        [_imgChecked setImage:[UIImage imageNamed:kCheckBoxUnselected]];
    }
}

-(void)hideComboBox{
    isShowList=NO;
}

-(void) onTimerFocus{
    if ([_txtLoginUserID.text length]>0)
    {
        [_txtLoginPassword becomeFirstResponder];
    }
    else
    {
        [_txtLoginUserID becomeFirstResponder];
    }
}

-(void)btnDeleteAccount:(id)sender{
    UIButton *btn=(UIButton *)sender;
    NSString *jid=[NSString stringWithFormat:@"%@",[accountArray objectAtIndex:btn.superview.tag-1]];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除帐号" message:[NSString stringWithFormat:@"即将删除此帐号的所有记录文件：\n%@\n是否继续删除？",jid] delegate:self cancelButtonTitle:@"删除" otherButtonTitles:nil];
    [alert setTag:btn.superview.tag];
    [alert addButtonWithTitle:@"取消"];
    [alert show];
#if ! __has_feature(objc_arc)
    [alert release];
#endif
}

//didDismissWithButtonIndex有bug，影响界面，产生异常
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //[AppSetting closeThirdLoginAccount];
    if ([alertView.title isEqualToString:@"删除帐号"])
    {
        if (buttonIndex==0) {
            int num = (int)alertView.tag;
            NSString *jid=[NSString stringWithFormat:@"%@",[accountArray objectAtIndex:num-1]];
            [accountArray removeObjectAtIndex:num-1];
            
            NSMutableArray *arCells=[NSMutableArray array];
            [arCells addObject:[NSIndexPath indexPathForRow:num inSection:0]];
            [_tvLogin deleteRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationBottom];
            
            [Utils delUserAccount:jid];
            //            [[AppDelegate App].viewController deleteLoginAccList:num-1];
            
            if ([_txtLoginUserID.text isEqualToString:jid])
            {
                _txtLoginUserID.text=@"";
                _txtLoginPassword.text=@"";
                //            RememberPasswd=NO;
                [_imgChecked setImage:[UIImage imageNamed:kCheckBoxUnselected]];
                
                [AppSetting load:@""];
            }
            [_tvLogin reloadData];
        }
    }
    else if ([alertView.title isEqualToString:@"安装微信"])
    {
        if (buttonIndex==0)
        {
            NSString *urlstr=[WXApi getWXAppInstallUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
        }
    }
}

-(void)refreshSettingData:(NSString*)ALoginAccount{
    [AppSetting load:ALoginAccount];
    [self loadViewData];
}

- (void)sendPushToken{

}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark xmppStreamDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
//{
//    [[[[AppDelegate App] xmppConnectDelegate] xmppStream] removeDelegate:self];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Toast hideToastActivity];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"网络连接超时，请稍后重试"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    });
//}



- (void)setupNavbar {
    [super setupNavbar];

    
    [self.navigationController setNavigationBarHidden:NO
     ];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"账号登录" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempView addSubview:tempBtn];
    // default40@2x.
    
    self.navigationItem.titleView = tempView;
    
}

-(void)onBack:(id)sender{
    [self popAnimated:YES];
  
    
}

@end
