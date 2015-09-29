//
//  ModelBase.m
//  mb
//
//  Created by Ryan on 15/6/15.
//  Copyright (c) 2015年 mb. All rights reserved.
//

#import "ModelBase.h"

// ----------------------------------------------------------------------------------------------------
//
// Global Setting
//
// ----------------------------------------------------------------------------------------------------
// wefafa im
NSString *DEFAULT_SERVER = @"http://101.227.185.159";
// wefafa callcenter(soa)
NSString *MBSoaServer = @"https://222.66.95.229";
NSString *MBH5URL = @"http://weixin.bonwe.com/stylist.web/fun/Detail.aspx";
NSString *SOA_SECRET = @"eaf77458-a037-42a7-b94a-fd96612f0c12";
// wefafa callcenter(soa) 这个好像没有用
NSString *MAIN_SERVICE_SOA_TOKEN_URL = @"https://10.100.28.12";
// wefafa callcenter(soa) 这个获取Token
NSString *MAIN_SERVICE_SOA_URL = @"https://222.66.95.229/CallCenter/InvokeSecurity.ashx?";
NSString *WEFAFA_PLIST_URL = @"https://www.51mb.com/apps/designer/designer.plist";
//测试环境参数：softwareCode=MB.Designer.App&evmCode=MB.Designer.UAT
NSString *SOFTWARECODE = @"MB.Designer.App";
NSString *EVMCODE = @"MB.Designer.UAT";
NSString *ALIPAYNOTIFYURL = @"http://stylistpay.51mb.com/wap/Payment/AlipayNotify.ashx";
NSString *WORDFONTURL  = @"http://img.51mb.com:5659/sources/$text_";
NSString *kHttpUrlString = @"http://www.mixme.cn/web/im/dialogCustomer"; //联系客服

NSString *kIosKey = @"eaf77458-a037-42a7-b94a-fd96612f0c12";
NSString *kInviteCodeUrl = @"http://www.funwear.com/youfan/promotion/InvitationCode.aspx?";
NSString *kShareInviteCodeUrl = @"http://www.funwear.com/youfan/promotion/InvitationCode.aspx?inviteCodeType=2";

NSString *MBFUN_CHAT_SERVER = @"222.66.95.225";
NSString *MBFUN_CHAT_PORT = @"9000";

// 测试服务，外网配置
NSString *CONFIG_URL = @"http://222.66.95.225/mbfun_server/index.php";
NSString *SERVER_URL = @"http://222.66.95.225/mbfun_server/index.php";
NSString *SHARE_URL = @"http://222.66.95.225/mbfun_web/wx/?co=%@";

//static const NSString *QQAppID=@"101056950";
NSString *QQAppID=@"1102534852";
NSString *QQAppKey=@"tnhnPadjNovBW0vq";

// 友盟
NSString *UMENG_APPKEY=@"5514bb3efd98c5ab770002bc";

// 启动视频和截图
NSString *LAUNCH_VIDEO=@"http://7xjir4.com2.z0.glb.qiniucdn.com/welcome.mp4";
NSString *LAUNCH_VIDEO_SNAP=@"http://7xjir4.com2.z0.glb.qiniucdn.com/welcome.mp4?vframe/jpg/offset/7/w/375/h/666";
NSString *LAUNCH_IMAGE=@"http://metersbonwe.qiniucdn.com/welcome.mp4?vframe/jpg/offset/7/w/375/h/666";
NSString *LAUNCH_IMAGE_JUMP_INFO=@"0";
NSString *LAUNCH_DEFAULT_PAGE=@"0";

NSString *SIGN_KEY =@"7def8c7b4f8b6cbefbdd8bc13d1441d3";
NSString *SERVER_CDN =@"http://metersbonwe.qiniucdn.com/";



// 合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
//#define  PartnerID  @"2088701263026887"
NSString *PartnerID = @"2088501752273875";
// 账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
//#define SellerID  @"banggo@banggo.com"
NSString *SellerID = @"banggo@metersbonwe.com";
// 商户（RSA）私钥
NSString *PartnerPrivKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMK3GTWHKW1xPWCVqle0WW04kH9aAI2FaXSF18KzdVJ0GvXOowksdx3A1gVF8yAziWxTMEJcTA4l3YEq5UV2+scJRWdYhkPG+ZvY2qdzGLQ2eJb+ehuJhIq4dsgYPDqLU56AYEgAOry2s1GWmtgQUERP5sWIhatfrGD+Yb64T65jAgMBAAECgYAUQ0GYVGx3OyWL+4cygU4dE5nV5uPP1mZW/eaqGErJPdPgaJSGy93JdtvOyKy4WSSf5ThMb5Zqkn4uhuw9AliuV0KGsixNauNKuv0GbwMBqCiayN3zb0Blfj9VWrOqroSmx3demeTVlYJzVaeAEhfr456Cw2tty4Ose/qXyyCGAQJBAOjAd+GQ1Xj4kCWx2ubSnWEDDp66VZh/dI2mzEWrUGQWX20XnZkWMR/TsDF4bmmo8XJnvlsRcWM05KqRQz1HMiMCQQDWKgX13sYrvnhSBg/P75RjQ0X0N23CoYLsnuaTUOZ3vixz5cqjEowaGbScIb9TLCEIpfoK1obmo+3Z7hHc6rbBAkEA3Z1NSDBAooOBtPKI7JkDkrh3djkTgTVyg+GaxIde7z3CNLx0qavQsG4+aIw0DVT4OKeBP3L3VK+rPqE7taARowJBAI3IFlgW2sU8/LT4tGEpr+gjMl2ikHSorl9uNyHSDjG54f38ZDGfZscku3Ad22b5sQjjsOyZ54crgZykQokpjkECQFPtwWI7ke++bUjPyZY3/ehQauco3qt+gDxRqxTzdIDULg0THzRADQ3AypUbVNn7aIaq+bQSiJXjh578uOKmmzs=";

// 支付宝（RSA）公钥 用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取。
NSString *AlipayPubKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7uLJTJxwvbcQ3q04UaNgpwxV+zVtpFWeb/I5U0Plde+taYd0K5UvFFn7swAa0Yflgxnnj1mZ/LlIrlil6sBWQhdJYS6yCrAy7vtUimA1QIoqtEapDyPKs51qoUQfwkqPcZAKI7lOn4ZsZ0Lwl1cebsa1Awx8IdNjLBN6UCJpqvQIDAQAB";

//我的推广码
NSString *MDTG_URL = @"http://weixin.bonwe.com/stylist.web/fun/Detail.aspx";
NSString *HTML_ORDER_SUCCESS=@"http://www.baidu.com";







//版本跟新的信息
NSString *VERSION_NAME = @"";//服务端最新版本

NSString *VERSION_CODE = @"1";//

NSString *VERSION_INFO = @"";//版本更新说明

NSString *IS_FORCE_UPDATE = @"";//是否强制更新 1 强制更新

NSString *WX_APP_ID=@"";
NSString *WX_PARNER_ID=@"";
NSString *WX_APY_SINGN_KEY=@"";
NSString *WX_BEFORE_PAY_URL=@"";//微信预支付订单url



NSArray  *SIDEBAR_ARRAY = nil;

//底部菜单数据
NSArray *MENUBOTTOM_ARRAY = nil;
//新服务url
NSString *PHP_SERVER_CONFIG_URL=@"http://222.66.95.225/mbfun_server/index.php";
NSString *U_ORDER_RETURN_OPEN=nil;

 NSString *U_SHARE_BRAND_URL=nil;//品牌跳转
 NSString *U_SHARE_TOPIC_URL=nil;//话题跳转
 NSString *U_SHARE_USER_URL=nil;//个人中心
