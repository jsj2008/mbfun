//
//  MBChangeUserNameViewController.m
//  Wefafa
//
//  Created by fafatime on 14-11-14.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MBChangeUserNameViewController.h"
#import "AppDelegate.h"
#import "WeFaFaGet.h"
#import "Utils.h"

#import "Toast.h"
#import "NavigationTitleView.h"
#import "SQLiteOper.h"
#import "NetUtils.h"
#import "AppSetting.h"
#import "MBShoppingGuideInterface.h"
#import "SDataCache.h"
#import "HttpRequest.h"

@interface MBChangeUserNameViewController ()

{
    dispatch_queue_t homeXmppStreamQueue;
    UITextField *_changNameTextF;
}
//@property (retain, nonatomic) XMPPStream *xmppStream;
//@property (retain, nonatomic) XMPPRoster *xmppRoster;
@end

@implementation MBChangeUserNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    self.title=@"修改昵称";
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

- (void)onCart:(UIButton*)sender {
    
}

- (void)onShare:(UIButton*)sender {
    
}

- (void)bestSelect:(UIButton*)sender {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavbar];
//    CGRect headrect=CGRectMake(0,0,self.viewHead.frame.size.width,self.viewHead.frame.size.height);
//    NavigationTitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
//    [titleView createTitleView:headrect delegate:self selectorBack:@selector(btnBackClick:) selectorOk:@selector(btnSaveClick:) selectorMenu:nil];
//    titleView.lbTitle.text=@"修改昵称";
//    [titleView.btnOk setTitle:@"保存" forState:UIControlStateNormal];
//    [self.viewHead addSubview:titleView];
    self.view.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
//    homeXmppStreamQueue = dispatch_queue_create("homeXmppStreamQueue", NULL);
//    XMPPStream *xmppStream = [[AppDelegate xmppConnectDelegate] xmppStream];
//    [xmppStream addDelegate:self delegateQueue:homeXmppStreamQueue];
//    XMPPRoster *xmppRoster = [[AppDelegate xmppConnectDelegate] xmppRoster];
//    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    myUser = [XMPPUserSqliteStorageObject userForJIDFromCache:AppDelegate.xmppConnectDelegate.xmppStream.myJID.bare];
//    self.xmppStream = [[AppDelegate xmppConnectDelegate] xmppStream];
//    XMPPRosterSqliteStorage *xmppRosterSqliteStorageX = [[AppDelegate xmppConnectDelegate] xmppRosterStorage];
//    myUser = [xmppRosterSqliteStorageX myUserForXMPPStream:self.xmppStream];

    [self configSubViewWithYPoint:self.viewHead.frame.size.height + 15];
}

- (void)configSubViewWithYPoint:(CGFloat)yPoint
{
//    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, yPoint, SCREEN_WIDTH, 44)];
//    [aView setBackgroundColor:[UIColor whiteColor]];
//    [aView.layer setBorderColor:[UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1.0].CGColor];
//    [aView.layer setBorderWidth:0.5];
    _changNameTextF = [[UITextField alloc] initWithFrame:CGRectMake(0, yPoint + 0.5, SCREEN_WIDTH, 43)];
   
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    
    _changNameTextF.leftView = paddingView;
    
    _changNameTextF.leftViewMode = UITextFieldViewModeAlways;
    [_changNameTextF setBackgroundColor:[UIColor whiteColor]];
    [_changNameTextF setFont:[UIFont systemFontOfSize:14.0f]];
    [_changNameTextF setPlaceholder:@"请输入昵称"];
    [self.view addSubview:_changNameTextF];
//    [self.view addSubview:aView];
    [_changNameTextF becomeFirstResponder];
    [_changNameTextF setText:_currentName];
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(10, _changNameTextF.bottom + 30, UI_SCREEN_WIDTH - 20, 44);
    btnSend.layer.cornerRadius = 5;
    [btnSend setTitle:@"保存" forState:UIControlStateNormal];
    btnSend .backgroundColor = [UIColor blackColor];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:btnSend];
    [btnSend addTarget:self action:@selector(btnSaveClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)netConnectError:(NSString *)msg
{
    UIAlertView *alert=nil;
    if (msg!=NULL && msg.length>0) {
        [Toast hideToastActivity];
        alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    }
    else alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法连接服务器，请稍后重试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [alert setTag:10000];
    [alert show];
}

- (void)btnSaveClick:(id)sender {
    if ([_changNameTextF.text isEqualToString:@"<null>"]||_changNameTextF.text==nil||[[_changNameTextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[_changNameTextF.text isEqualToString:@"(null)"]) {
       UIAlertView  *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写用户名！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        int msgLength = (int)[self convertToInt:_changNameTextF.text];
        if (msgLength>21) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入小于二十位的昵称！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        BOOL isMatch2;
        isMatch2 = [self validateUserName:_changNameTextF.text];
        if (!isMatch2) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"昵称只能由中文、字母或数字组成"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }

//
//         myUser.staffFull.nick_name= _changNameTextF.text;
        
        if ([NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected])) {
            [Toast hideToastActivity];
            [Toast makeToastActivity:@"保存中，请稍等..." hasMusk:YES];
            
            // 新服务
            // 临时，另一个服务， 设置nickname
            [[SDataCache sharedInstance] setUserNickName:_changNameTextF.text complete:^(NSString *str) {
                if (str) {
                    NSLog(@"Change Nickname URL:%@",str);
                    
//                    [Toast hideToastActivity];
                    
//                    myUser.staffFull.nick_name= _changNameTextF.text;
//                    sns.myStaffCard.nick_name = _changNameTextF.text;
//                    [sqlite updateStaff:myUser.staffFull];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
//                    
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeNickName" object:@{@"newNick" : _changNameTextF.text}];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changename" object:nil];
//                    
//                    if(self.preViewController!=nil && [self.preViewController class]==[MBSelfInfoViewController class]) {
//                        [_preViewController performSelector:@selector(creatUserInfo)];
//                    }
//                    [self.navigationController popViewControllerAnimated:YES];
//                    

                    
                    
                } else {
                    NSLog(@"Change Nickname  Field");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self netConnectError:@"保存失败，请稍后重试！"];
//                        [Toast hideToastActivity];
//                    });
                }
                //
            }];
            
      
                NSArray *userClaims=@[@{@"claimType":@"MB.MasterOfDesigner.NickName",@"claimValue":_changNameTextF.text}];
                
                NSDictionary *valueDic=@{@"UserId":sns.ldap_uid,@"issuer":@"MB.MasterOfDesigner",@"userClaims":userClaims};
             [HttpRequest postRequestPath:kMBServerNameTypeAccout methodName:@"UserUpdateProfile" params:valueDic success:^(NSDictionary *dict) {
                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Toast hideToastActivity];

                        sns.myStaffCard.nick_name = _changNameTextF.text;
                        [sqlite updateStaff:sns.myStaffCard];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeNickName" object:@{@"newNick" : _changNameTextF.text}];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changename" object:nil];
                        
              
                        [self.navigationController popViewControllerAnimated:YES];
                        

                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                        message = [Utils getSNSString:message];
                        if (message.length==0) {
                            message=@"保存失败，请稍后重试!";
                            
                        }
                        [self netConnectError:message];
                        [Toast hideToastActivity];
                    });
                }
            } failed:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self netConnectError:@"保存失败,请稍候重试!"];
                    [Toast hideToastActivity];
                });
                
            }];
            
            
     /*
                [SHOPPING_GUIDE_ITF requestPostUrlName:@"UserUpdateProfile" param:valueDic responseAll:areaReturnDic responseMsg:areaRequestStr];
                NSLog(@"。。%@。。%@",areaReturnDic,areaRequestStr);
                NSString *isSuccess=[NSString stringWithFormat:@"%@",areaReturnDic[@"isSuccess"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([isSuccess isEqualToString:@"1"])
                    {
                        [Toast hideToastActivity];
                        
                        myUser.staffFull.nick_name= _changNameTextF.text;
                        sns.myStaffCard.nick_name = _changNameTextF.text;
                        [sqlite updateStaff:myUser.staffFull];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeHeadImgView" object:nil];
                        
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeNickName" object:@{@"newNick" : _changNameTextF.text}];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changename" object:nil];
                        
                        if(self.preViewController!=nil && [self.preViewController class]==[MBSelfInfoViewController class]) {
                            [_preViewController performSelector:@selector(creatUserInfo)];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    else
                    {
                        [Toast hideToastActivity];
                        if ([areaRequestStr length] == 0) {
                            if([[areaReturnDic allKeys]containsObject:@"message"])
                            {
                                NSString *messageStr=areaReturnDic[@"message"];
                                if (messageStr.length!=0) {
                                    [areaRequestStr setString:messageStr];
                                }
                            }
                            else
                            {
                            [areaRequestStr setString:@"保存失败，请稍后重试！"];
                            }
                        }
                        [self netConnectError:areaRequestStr];
                    }
                });
                
            });
        */

        }else [self netConnectError:nil];
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
//-(NSUInteger) unicodeLengthOfString: (NSString *) text {
//    NSUInteger asciiLength = 0;
//    
//    for (NSUInteger i = 0; i < text.length; i++) {
//        
//        
//        unichar uc = [text characterAtIndex: i];
//        
//        asciiLength += isascii(uc) ? 1 : 2;
//    }
//    
//    NSUInteger unicodeLength = asciiLength / 2;
//    
//    if(asciiLength % 2) {
//        unicodeLength++;
//    }
//    
//    return unicodeLength;
//}
- (BOOL)validateUserName:(NSString *)userName
{
//    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    
    //只含有汉字、数字、字母
    NSString *phoneRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";//^[a-zA-Z0-9_\u4e00-\u9fa5]+$ 可加下划线位置不限
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:userName];
}
- (void)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{

    OBJC_RELEASE(sections);
}

@end
