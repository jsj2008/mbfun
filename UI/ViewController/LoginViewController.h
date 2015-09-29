//
//  LoginViewController.h
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.

// TODO:
// 不要再显示第三方自动生成的账号了，体验不好
// 不要有生成随机密码的感觉，一方面本身不安全，另外体验不好
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeFaFaGet.h"
#import "AppDelegate.h"

@interface LoginViewController : SBaseViewController /*UIViewController*/<UITableViewDataSource, UITableViewDelegate,ASIHTTPRequestDelegate,UITabBarControllerDelegate,NSXMLParserDelegate,UIGestureRecognizerDelegate>
{
    NSArray *sections; //title, cells, title, cells,...
    
    NSMutableArray *accountArray;
    BOOL isShowList;
    
    
    NSDictionary *detailDic;//大模块数据

    NSDictionary *transDic;//每一个大模块下小模块
    
    ASIHTTPRequest *tabbarImgViewRequest;
    ASIHTTPRequest *detailModelRequest;
    NSMutableArray*parserObjects;
    NSMutableDictionary*dataDict;
    NSString*m_strCurrentElement;
    NSMutableString*tempString;
    NSMutableDictionary *menuitemDict;
    ASIHTTPRequest *zipUrlrequest;
    NSString *saveFilePath;//下载的保存文件路径
    NSString *upzipFilePath;//解压文件夹的路径
    NSString *colorStr;//头部的颜色
    
    ASIHTTPRequest *configUrlRequest;
    BOOL isThirdPartLogin;
    //QQ登录
//    TencentOAuth* _tencentOAuth;
}
@property (strong, nonatomic) IBOutlet UIView *homeview;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIView *viewHead;
@property (weak, nonatomic) IBOutlet UIView *thirdLoginView;

//@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewLoginMenu;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tvLogin;
@property (strong, nonatomic) IBOutlet UITableViewCell *accountTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *passwdTableViewCell;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIImageView *otherLeftLine;
@property (weak, nonatomic) IBOutlet UIImageView *otherRightLine;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgChecked;
@property (weak, nonatomic) IBOutlet UIImageView *passWordSeperLine;
@property (weak, nonatomic) IBOutlet UIImageView *loginUserSeperLine;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBTN;
@property (weak, nonatomic) IBOutlet UIButton *quickRegisterBTN;
@property (weak, nonatomic) IBOutlet UILabel *otherLoginWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinaLabel;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic,retain)NSString *dataString;
@property (nonatomic,retain)NSString *tabbarDataString;
@property (nonatomic,retain)NSString *detailModelDataString;
@property (nonatomic ,retain)IBOutlet UIButton *btnfogest;
@property (nonatomic , retain)IBOutlet UIButton *zhuceBtn;
//可定制
@property (weak, nonatomic) IBOutlet UIImageView *loginUserIcon;
@property (weak, nonatomic) IBOutlet UIImageView *loginPWDIcon;

@property (weak, nonatomic) IBOutlet UIImageView *loginLogoImage;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtLoginUserID;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtLoginPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnShowList;
//


- (IBAction)btnViewLoginMenu_OnClick:(id)sender;
- (IBAction)btnShowList:(id)sender;
- (IBAction)btnRememberClick:(id)sender;
- (IBAction)txtField_OnBeginEdit:(id)sender;
- (IBAction)btnLoginClick:(id)sender;
- (IBAction)textFieldDidEnd_Next:(id)sender;
- (IBAction)textLoginIDEditingEnd:(id)sender;
- (IBAction)txtLoginIDEditingChanged:(id)sender;
- (IBAction)btnQQZoneClick:(id)sender;
- (IBAction)btnWeiXinClick:(id)sender;
- (IBAction)btnGetPasswordClick:(id)sender;
- (IBAction)btnMBRegisterClick:(id)sender;

-(void)rememberPassword;



extern LoginViewController *g_loginViewController;

@end
