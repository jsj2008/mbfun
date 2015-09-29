//
//  NewRegisterViewController.m
//  Wefafa
//
//  Created by fafatime on 14/12/10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "FileReaderViewController.h"
#import "NavigationTitleView.h"
#import "LoginViewController.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "Toast.h"
#import "MobClick.h"

@interface NewRegisterViewController ()
{
    BOOL _ifRollUp;
    
    BOOL _ifPhoneNumOK;
    BOOL _ifNickNameOK;
    BOOL _ifPasswordOK;
    BOOL _ifSMessageOK;
    
    BOOL _ifCountingOver;
    NSString * _firstInputPassWord;
    BOOL       _ifFirstInput;
    BOOL fiveLength;
    

}

@end

@implementation NewRegisterViewController

@synthesize registScrollView = _registScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtMobile.delegate = self;
    _txtMobile.keyboardType = UIKeyboardTypeNumberPad;
    _txtValidCode.keyboardType = UIKeyboardTypeNumberPad;
    _txtPassword.delegate = self;
    _txtPassword.secureTextEntry = YES;
//    _txtPassword.keyboardType = UIKeyboardTypeNumberPad;
//    _txtPassword.clearsOnBeginEditing =NO; //再次编辑就清空
//    _txtPassword.clearsOnBeginEditing=NO;
    

    _txtValidCode.delegate = self;
    _txtUserName.delegate =self;

    
    [self BoolDataInit];
    [self setAgreeImage];
    _lbAgree.userInteractionEnabled = YES;  //必须为YES才能响应事件
    UITapGestureRecognizer *singleAgreeTouch=[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(lbAgreeClicked:)];
    [_lbAgree addGestureRecognizer:singleAgreeTouch];
    
    RegistFlagFileName=@"RegistState.flag";

    [self hexColorSet];
    
    //添加点击空白区域收回键盘的手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.delegate = self;
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [Toast hideToastActivity];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
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

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

-(void)BoolDataInit
{
    isAgree=YES;
    isEntry = NO;
    _ifRollUp = NO;
    _ifPhoneNumOK = NO;
    _ifNickNameOK = NO;
    _ifPasswordOK = NO;
    _ifSMessageOK = NO;
    
    _ifFirstInput = YES;
    _ifCountingOver = YES;
}

 -(void)hexColorSet
{
    [self.registerBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
    [self.declareLeftLabel setTextColor:[Utils HexColor:0x919191 Alpha:1.0]];
    [self.declareRightLabel setTextColor:[Utils HexColor:0x333333 Alpha:1.0]];

    _btnRegist.layer.cornerRadius = 3;
    _btnRegist.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 3;
    _registerBtn.layer.masksToBounds = YES;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    [_btnRegist setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];

//    _txtPassword.clearsOnBeginEditing = NO;

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
    _ifRollUp = NO;
    [self.view endEditing:YES];
}

//手机号
- (IBAction)txtDidEndOnExit:(id)sender{
    
}
- (IBAction)nickNameDidEndOnExit:(id)sender {
}

#pragma make  textfieldDelegate
- (IBAction)txtPassDidEndOnExit:(id)sender{
}
- (IBAction)txtEnameEditDidBegin:(id)sender{
}

//手机号码验证
- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符  15 15342 1111
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL)validateUserName:(NSString *)userName
{
    //只含有汉字、数字、字母
//    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    //    1-18位 不能全部为数字 不能全部为字母 必须包含字母和数字
//    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
       NSString *regex =   @"^[0-9A-Za-z\u4e00-\u9fa5]{1,18}+$";

    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneTest evaluateWithObject:userName];
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
//获取验证码
- (IBAction)btnRegistClick:(id)sender{
    
    if(isAgree==NO)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"请先同意注册协议"]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    

    BOOL isMatch;
    isMatch = [self validateMobile:_txtMobile.text];
    if (!isMatch) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"请输入正确的手机号！\n您将收到验证码短信。"]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    _sendValidCodeTime=[NSDate date];
//    _getValidCodeTimes = [self passwordValidCodeTimes];
    

    [self getValidCode:_txtMobile.text];

}

-(void)timeToRepeat
{
    NSDate *now=[NSDate date];
    NSTimeInterval time=[now timeIntervalSinceDate:_sendValidCodeTime];
    int waittime=60;
    if (_getValidCodeTimes>=3)
    {
//        [_btnRegist setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
//        [_btnRegist setTitle:@"每天最多获取三次" forState:UIControlStateNormal];
//        [_btnRegist.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        _btnRegist.userInteractionEnabled=NO;
//        _ifCountingOver = YES;
        [_btnRegist setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
        
        [_btnRegist.titleLabel setFont:[UIFont systemFontOfSize:12]];
        if ((waittime -(int)time)>0) {
               [_btnRegist setTitle:[NSString stringWithFormat:@"%d秒后再次获取",waittime-(int)time] forState:UIControlStateNormal];
               _ifCountingOver = NO;
            
            [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timeToRepeat) userInfo:nil repeats:NO];
        }
        else
        {
            _ifCountingOver = YES;
            [_btnRegist setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
            [_btnRegist setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
    
        _btnRegist.userInteractionEnabled=NO;
     
 
    }
    else if (time<waittime ) //60S*2
    {
        [_btnRegist setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];

        [_btnRegist.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_btnRegist setTitle:[NSString stringWithFormat:@"%d秒后再次获取",waittime-(int)time] forState:UIControlStateNormal];
        _btnRegist.userInteractionEnabled=NO;
        _ifCountingOver = NO;

        [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timeToRepeat) userInfo:nil repeats:NO];
    }
    else
    {
        [_btnRegist setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
        [_btnRegist setTitle:@"获取验证码" forState:UIControlStateNormal];
        _btnRegist.userInteractionEnabled=YES;
        _ifCountingOver = YES;

    }
}

-(int)passwordValidCodeTimes
{
    //读取获取密码次数
    int getPasswordTimes=1;
    NSMutableArray *dataarr=[self readFileData:RegistFlagFileName];
    if ([dataarr count]>0)
    {
        NSDictionary *d1=[dataarr objectAtIndex:0];
        NSNumber *getPasswordTimesStr=[d1 objectForKey:@"GetPasswordTimes"];
        if (getPasswordTimesStr!=nil)
        {
            NSDate *getDate=[d1 objectForKey:@"SendValidCodeTime"];
            getPasswordTimes=[getPasswordTimesStr intValue];
            if ([[getDate toString:@"yyyy-MM-dd"] isEqualToString:[[NSDate date] toString:@"yyyy-MM-dd"]])
            {
                getPasswordTimes++;
            }
        }
    }
    return getPasswordTimes;
}
-(BOOL) saveFileData:(NSMutableArray *)data saveFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}
-(NSString *) dataFilePath:(NSString *)filepath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:filepath];
}
-(NSMutableArray *)readFileData:(NSString *)fileName
{
    NSMutableArray *dataArray;
    NSString *recentContactsPath= [self dataFilePath:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:recentContactsPath])
    {
        dataArray = [[NSMutableArray alloc] initWithContentsOfFile:recentContactsPath];
    }
    else
    {
        dataArray = [[NSMutableArray alloc] init];
    }
    return dataArray;
}
-(void)getValidCode:(NSString *)validcode
{
//    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RegisterValidCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *flag=[[NSMutableString alloc] initWithFormat:@""];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        NSString *rst=[sns getPasswordValidCode:validcode returnFlag:flag returnRetrieveID:nil returnMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rst isEqualToString:SNS_RETURN_SUCCESS]==NO)
            {
                if (msg.length>0)
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:msg forKey:@"RegisterValidCode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableArray *dataarr=[self readFileData:RegistFlagFileName];
                NSDictionary *dictOld=dataarr.count>0?[dataarr objectAtIndex:0]:nil;
                NSString *accountOld=[dictOld objectForKey:@"account"];
                
                
                [AppSetting setRegistState:@"1"];
                [AppSetting save];
                
                [Toast makeToast:msg];
                  [self timeToRepeat];
                return ;
                //读取获取密码次数
                int getPasswordTimes=[self passwordValidCodeTimes];
                
                if ([accountOld isEqualToString:_txtMobile.text]==NO)
                {
                    getPasswordTimes=1;//账号是否改变
                }
                
                //写注册信息
                NSDate *currdate=[NSDate date];
                NSMutableArray *data=[[NSMutableArray alloc] init];
                NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_txtMobile.text,@"account",currdate,@"SendValidCodeTime",[NSNumber numberWithInt:getPasswordTimes],@"GetPasswordTimes", nil];
                [data addObject:dict];
                [self saveFileData:data saveFileName:RegistFlagFileName];
              

            }
        });
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField==_txtUserName)
    {
        

        if ([toBeString length] > 16) {
            textField.text = [toBeString substringToIndex:16];
            _ifNickNameOK = YES;
            [self judgeCanCommit];

            return NO;
        }
         if([toBeString length]>0)
        {
            _ifNickNameOK = YES;
            
            [self judgeCanCommit];
            return YES;


        
        }
        if ([toBeString length] == 0) {
            _ifNickNameOK = NO;
            [self judgeCanCommit];
            return YES;


        }
        if ([string isEqualToString:@"\n"]) {
            _ifRollUp = NO;
            [self judgeCanCommit];
            [textField resignFirstResponder];
            return NO;
        }
        
    }
    
    if (textField==_txtMobile)
    {
        
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            _ifPhoneNumOK = YES;
            [self judgeCanCommit];

            return NO;
        }
         if([toBeString length] == 11)
        {
            _ifPhoneNumOK = YES;
            
            [self judgeCanCommit];
            return YES;


            
        }
        if ([toBeString length]< 11) {
            _ifPhoneNumOK = NO;
            [self judgeCanCommit];
            return YES;



        }
        if ([string isEqualToString:@"\n"]) {
            _ifRollUp = NO;
            [self judgeCanCommit];
            
            [textField resignFirstResponder];
            return NO;
        }

    }

    if (textField==_txtPassword)
    {
        //判断输入5个字符后再次输入会变化的bug
        if([textField.text length]<5)
        {
            fiveLength=NO;
        }
        
        if (fiveLength&& string.length!=0) {
            _ifPasswordOK = NO;
            [self judgeCanCommit];
            
            return YES;
        }
        if(!_ifFirstInput && [string  isEqualToString:@""])
        {
            _ifPasswordOK = NO;
            _ifFirstInput = YES;
            [self judgeCanCommit];
            
            return YES;
        }
        
        if ([toBeString length] > 12) {
            textField.text = [toBeString substringToIndex:12];
            _ifPasswordOK = YES;
            [self judgeCanCommit];

            return NO;
        }
         if([toBeString length]>5 && [toBeString length]<13)
        {
            _ifPasswordOK = YES;
            [self judgeCanCommit];

            return YES;
            
        }
        if ([toBeString length]<6) {
            _ifPasswordOK = NO;
            [self judgeCanCommit];
            
            return YES;
        }

        
        if ([string isEqualToString:@"\n"]) {
            _ifRollUp = NO;
            [self judgeCanCommit];
            
            [textField resignFirstResponder];
            return NO;
        }
        
    }
 
    if (textField==_txtValidCode )
    {
        if ([toBeString length] > 6) {
            textField.text = [toBeString substringToIndex:6];
            _ifSMessageOK = YES;
            [self judgeCanCommit];

            return NO;
        }
         if([toBeString length] == 6 )
        {
            _ifSMessageOK = YES;
            [self judgeCanCommit];
            return YES;

            
        }
        
        else
        {
            _ifSMessageOK = NO;
            [self judgeCanCommit];
            return YES;


        }

        if ([string isEqualToString:@"\n"]) {
            _ifRollUp = NO;
            [self judgeCanCommit];
            
            [textField resignFirstResponder];
            return NO;
        }
        
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
      return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField == _txtPassword) && (_ifFirstInput == NO) && ([_firstInputPassWord isEqualToString: textField.text])) {
//        if ( [_firstInputPassWord length]>0 ) {
//            _ifFirstInput = YES;
//        }f
//        else{
//            _firstInputPassWord = textField.text;
//            _ifFirstInput = YES;
//        }
                   _ifFirstInput = NO;

      
        
    }
    if(textField == _txtPassword)
    {
        if([textField.text length]>4)
        {
            fiveLength =YES;
            
        }
        else
        {
            fiveLength=NO;
        }
    }
        

    _ifRollUp = YES;
    
    [self pageRollUp:textField.tag];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _txtPassword) {
        if ( [textField.text length]>0 ) {
            _ifFirstInput = NO;
            _firstInputPassWord = textField.text;

        }
        else{
            _ifFirstInput = YES;
        }
        
    }
    if (!_ifRollUp) {
        [self pageRollDown:textField.tag];

    }

}

-(void)judgeCanCommit
{
    if (_ifPhoneNumOK && _ifCountingOver) {
        [_btnRegist setBackgroundColor:[Utils HexColor:0x333333 Alpha:1.0]];
    }
    else
    {
        [_btnRegist setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];

    }
    if (_ifNickNameOK && _ifPasswordOK && _ifPhoneNumOK && _ifSMessageOK ) {
        [_registerBtn setBackgroundColor:[Utils HexColor:0xffde32 Alpha:1.0]];
        [_registerBtn setTitleColor:[Utils HexColor:0x333333 Alpha:1.0f ] forState:UIControlStateNormal];
    }
    else{
        [_registerBtn setBackgroundColor:[Utils HexColor:0xe2e2e2 Alpha:1.0]];
        [_registerBtn setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    }
}
-(void)pageRollUp:(NSInteger)index
{
    CGFloat rollDegree = 44;
    
    [UIView animateWithDuration:0.001 animations:^{
        
        [_registScrollView setContentSize:CGSizeMake(0, UI_SCREEN_HEIGHT-64+rollDegree*index)];
        
        [_registScrollView setContentOffset:CGPointMake(0, rollDegree*index) animated:NO];

    }];
    
    
}
-(void)pageRollDown:(NSInteger)index
{
    CGFloat rollDegree = 44;
    [UIView animateWithDuration:0.001 animations:^{
        [_registScrollView setContentSize:CGSizeMake(0, UI_SCREEN_HEIGHT-49-rollDegree*index)];
//        [_registScrollView setContentOffset:CGPointMake(0, -20) animated:NO];

    }];
}
-(void)lbAgreeClicked:(id)sender
{
    isAgree=!isAgree;
    [self setAgreeImage];
}
-(void)setAgreeImage
{
    if (isAgree)
        _imgAgree.image=[UIImage imageNamed:@"checked@3x.png"];
    else
        _imgAgree.image=[UIImage imageNamed:@"unchecked@3x.png"];
    
//    _btnRegist.enabled=isAgree;
}

-(NSUInteger) unicodeLengthOfString: (NSString *) text {
    
    NSUInteger asciiLength = 0;

    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

- (void)alertWithTitle:(NSString *)title
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:title
                                                   delegate:nil
                                          cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnRegistLoginClick:(id)sender {
    if(isAgree==NO)
    {
        [self alertWithTitle:@"请先同意注册协议"];
        return;
    }

    BOOL isMatch;
    isMatch = [self validateMobile:_txtMobile.text];
    if (!isMatch) {
        [Toast hideToastActivity];
        
        [self alertWithTitle:@"请输入正确的手机号！\n您将收到验证码短信。"];
        return;
    }
    NSInteger msgLength = [self unicodeLengthOfString:_txtUserName.text];
    if (msgLength>8) {
        [Toast hideToastActivity];
        [self alertWithTitle:@"请输入小于八位的昵称！"];
        return;
    }
    
    if ([_txtUserName.text length] == 0) {
        [self alertWithTitle:@"请输入昵称"];
        return;
    }
    //判断是否有昵称
    if (![self validateUserName:_txtUserName.text]) {
        [Toast hideToastActivity];
        
        [self alertWithTitle:@"昵称只能由中文、字母或数字组成"];
        return;
    }

    if ([_txtPassword.text isEqualToString:@"<null>"]||_txtPassword.text==nil||[[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[_txtPassword.text isEqualToString:@"(null)"]||[_txtPassword.text length]<6)
    {
        [Toast hideToastActivity];
        
        [self alertWithTitle:@"请设置大于六位的密码！"];
        return;
    }

    if ([_txtValidCode.text length]<=0||[_txtValidCode.text length]>6)
    {
        [Toast hideToastActivity];
        
        [self alertWithTitle:@"请输入正确的激活码！"];
        return;
    }
    BOOL isPassWordMatch ;
    isPassWordMatch= [self validatePassWord:_txtPassword.text];
    
    if (!isPassWordMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"密码请输入6-12位的数字或字母组合"]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self login];
    
}

-(void)login {
    NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
    
    [Toast makeToastActivity:@"请稍候..." hasMusk:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *rst=[sns registerActive:_txtMobile.text Password:_txtPassword.text ENO:@"" Ename:@"美特斯邦威" NickName:_txtUserName.text ActiveCode:_txtValidCode.text TipMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([rst isEqualToString:SNS_RETURN_SUCCESS])
            {
                [Toast hideToastActivity];
                //友盟统计注册事件
                [MobClick event:@"registerID"];
                
                //写注册标志
                [AppSetting setRegistState:@"0"];
                [AppSetting save];
                
                //删文件
                NSError *error = [[NSError alloc] init];
                if ([[NSFileManager defaultManager] fileExistsAtPath:RegistFlagFileName])
                    [[NSFileManager defaultManager] removeItemAtPath:RegistFlagFileName error:&error];
                
                //填loginviewcontroller帐号、密码
                g_loginViewController.txtLoginUserID.text=[[NSString alloc] initWithFormat:@"%@",_txtMobile.text];
                g_loginViewController.txtLoginPassword.text=[[NSString alloc] initWithFormat:@"%@",_txtPassword.text];
                
                //自动登录
                [g_loginViewController rememberPassword];
                [g_loginViewController btnLoginClick:nil];
            }
            else
            {
                [Toast hideToastActivity];
//                [Toast makeToast:msg.length==0?@"注册失败！":msg duration:1.0 position:@"center"];
                [Utils alertMessage:msg.length==0?@"注册失败！":msg];
            }
        });
    });

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

- (IBAction)entryBtnClick:(id)sender {
    isEntry=!isEntry;
    if (isEntry){
        _entryImg.image=[UIImage imageNamed:@"ico_seecode@3x.png"];
        _txtPassword.secureTextEntry = NO;
    }
    else{
        _entryImg.image=[UIImage imageNamed:@"ico_unseecode@3x.png"];
        _txtPassword.secureTextEntry = YES;
    }
}

- (IBAction)btnServeProtocolClick:(id)sender {
    FileReaderViewController *readerVC=[[FileReaderViewController alloc] initWithNibName:@"FileReaderViewController" bundle:nil];
    readerVC.fileName=@"服务条款";
    [self.navigationController pushViewController:readerVC animated:YES];

}
@end
