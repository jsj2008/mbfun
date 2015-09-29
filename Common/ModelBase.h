//
//  ModelBase.h
//  Wefafa
//
//  Created by fafatime on 14-5-27.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

//启用XML配置界面，（不需要配置界面时，直接注释掉XML_VIEWCONTROLLER宏）
#define XML_VIEWCONTROLLER 1

//企业编号(微信、qq登录使用)
#define WEFAFA_ENO @"100001"
#define WEFAFA_APPID @"2c18d819e29f37160fa4f1b80d389413"

//更新包识别码
#define UPDATE_APK_RES_ID      @"0"
//是否允许注册
#define LOGINALLOWREGISTER     @"0"
//是否允许修改密码
#define LOGINALLOWCHPWD        @"0"
//是否允许设置服务器
#define LOGINALLOWSET          @"0"
//关于信息
#define APP_ABOUT_NAME         @"关于有范"
//客服电话
#define CUSTO_SERVICE_PHONE    @"400-8219988"
//版权信息
#define COPYRIGHT          @"Copyright © 2011-2014 Metersbonwe. All Rights Reserved"

//服务条款
#define SERVICE_RULESCONTENT    @"..."
//隐私声明
#define STATEMENT_CONTENT       @"..."
//注册协议
#define TXT_MOBILEREG_PROTOCOL_TEXT   @"..."
//默认内部好友分组
#define TXT_FRIEND_HOME          @"内部联系人"
//默认外部好友分组
#define TXT_FRIEND_PARTNER       @"外部联系人"
//登录背景色
#define LOGIN_BG [Utils HexColor:0xf0f0f0 Alpha:1.0]
//登录输入框背景色
#define LOGIN_MID_BG [Utils HexColor:0xffffff Alpha:1.0]
//登录账号密码提示文字颜色
#define LOGIN_MID_TEXTCOLOR [Utils HexColor:0x999999 Alpha:1.0]
//登陆按钮字体颜色
#define LOGIN_BUTTON_TEXTCOLOR [Utils HexColor:0xffffff Alpha:1.0]
//登陆按钮背景颜色
#define LOGIN_BUTTON_COLOR [Utils HexColor:0x000000 Alpha:1.0]
//登录按钮名称
#define LOGIN_BUTTON_TEXT @"登录"
//登陆设置字体颜色
#define LOGIN_SETTING_TEXTCOLOR [Utils HexColor:0xffffff Alpha:1.0]
//登录是否记住密码
#define NEED_REMEMBER_PASSWORD
//主界面顶部背景颜色
#define TITLE_BG [Utils HexColor:0xfcfcfc Alpha:1.0]
//主界面顶部背景颜色
#define NAVI_BACKGROUNDCOLOR [Utils HexColor:0x000000 Alpha:1.0]
//主界面顶部背景颜色
#define TITLE_TEXTCOLOR [Utils HexColor:0xfcfcfc Alpha:1.0]//[Utils HexColor:0x000000 Alpha:1.0]
//主界面底部工具条颜色
#define TOOLBAR_ICON_COLOR [Utils HexColor:0xDF5F24 Alpha:1.0]
//底部导航条背景色
#define MAIN_NAVBG [Utils HexColor:0x464646 Alpha:1.0]
//底部菜单项默认背景色
#define MAIN_NAVNORMALBG [Utils HexColor:0x464646 Alpha:1.0]
//底部菜单项选中背景色
#define MAIN_NAVACTIVEGB [Utils HexColor:0x0081cc Alpha:1.0]
//聊天对话页面背景色
#define CHAT_MSGBG [Utils HexColor:0xf8f8f8 Alpha:1.0]
//搭配界面背景色[Utils HexColor:0xffffff Alpha:1.0]
#define COLLOCATION_TABLE_BG [UIColor whiteColor]
//搭配界面单元格分割线[Utils HexColor:0xafaca5 Alpha:1.0]
#define COLLOCATION_TABLE_LINE [UIColor whiteColor]
#define DEFAULT_LOADING_IMAGE @"pic_loading@3x.png"
#define DEFAULT_LOADING_BIGLOADING @"pic_loading@3x.png"
#define DEFAULT_LOADING_MEDIUM @"pic_loading@3x.png"
#define DEFAULT_LOADING_SMALL @"pic_loading@3x.png"
#define DEFAULT_LOADING_HEADIMGVIEW @"Unico/default_header_image@2x.png"
#define DEFAULT_APPLICATION_ICON @"Icon.png"
#define DEFAULT_LOADING_ADMIN_HEADIMGVIEW @"Unico/default_header_image@2x.png"

#define DEFAULT_FRIEND_HEAD_ICON @"ico_addfriends@3x.png"
#define DEFAULT_GROUP_HEAD_ICON @"ico_groupfriendsnews@3x.png"
#define DEFAULT_MESSAGE_HEAD_ICON @"ico_newmessage@3x.png"

#define TABLEVIEW_BACKGROUND_COLOR [UIColor colorWithRed:243.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]

#define ORANGECOLORCUSTOM [Utils HexColor:0xf46c56 Alpha:1.0]
#define REQUESTPAGESIZE 14;

#define RCODEVIDEOTIME 12;// 视频
#define RCODEAUDIOTIME 30;//音频30

#define SOA_APP_KEY @"ios-zxs"

// cache key
#define CACHE_SESSION_KEY @"CACHE_SESSION_KEY"

#define kNoneInternetTitle @"没有网络，臣妾做不到＞﹏＜"
#define kHomeNoneInternetTitle @"米有网哦，下拉看看呢。 ( ´ ▽ ` )ﾉ"

// ----------------------------------------------------------------------------------------------------
//
// Global Setting
//
// ----------------------------------------------------------------------------------------------------

// wefafa im
extern NSString *DEFAULT_SERVER;
// wefafa callcenter(soa)
extern NSString *MBSoaServer;
extern NSString *MBH5URL;
extern NSString *SOA_SECRET;
// wefafa callcenter(soa) 这个好像没有用
extern NSString *MAIN_SERVICE_SOA_TOKEN_URL;
// wefafa callcenter(soa) 这个获取Token
extern NSString *MAIN_SERVICE_SOA_URL;
extern NSString *WEFAFA_PLIST_URL;
//测试环境参数：softwareCode=MB.Designer.App&evmCode=MB.Designer.UAT
extern NSString *SOFTWARECODE;
extern NSString *EVMCODE;
extern NSString *ALIPAYNOTIFYURL;
extern NSString *WORDFONTURL;
extern NSString *kHttpUrlString; //联系客服

extern NSString *kIosKey;
extern NSString *kInviteCodeUrl;
extern NSString *kShareInviteCodeUrl;

extern NSString *MBFUN_CHAT_SERVER;
extern NSString *MBFUN_CHAT_PORT;

// 测试服务，外网配置
extern NSString *CONFIG_URL;
extern NSString *SERVER_URL;
extern NSString *SHARE_URL;

// QQ的配置
extern NSString *QQAppID;
extern NSString *QQAppKey;

// 友盟//友盟统计key
extern NSString *UMENG_APPKEY;

// 启动视频
extern NSString *LAUNCH_VIDEO;
extern NSString *LAUNCH_VIDEO_SNAP;
extern NSString *LAUNCH_IMAGE;
extern NSString *LAUNCH_IMAGE_JUMP_INFO;
// 启动后默认到哪个界面
extern NSString *LAUNCH_DEFAULT_PAGE;

extern NSString *SIGN_KEY;
extern NSString *SERVER_CDN;


// 支付宝
extern NSString *PartnerID;
// 账户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
extern NSString *SellerID;
// 商户（RSA）私钥
extern NSString *PartnerPrivKey;
// 支付宝（RSA）公钥 用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取。
extern NSString *AlipayPubKey;
//我的推广码
extern NSString *MDTG_URL;
extern NSString *HTML_ORDER_SUCCESS;




//版本跟新的信息
extern NSString *VERSION_NAME;//服务端最新版本

extern NSString *VERSION_CODE;//

extern NSString *VERSION_INFO;//版本更新说明

extern NSString *IS_FORCE_UPDATE;//是否强制更新 1 强制更新

//微信支付三参数
extern NSString *WX_APP_ID;
extern NSString *WX_PARNER_ID;
extern NSString *WX_APY_SINGN_KEY;
extern NSString *WX_BEFORE_PAY_URL;


//侧边栏数据
extern NSArray  *SIDEBAR_ARRAY;

//底部菜单数据
extern NSArray  *MENUBOTTOM_ARRAY;
//新服务url
extern NSString *PHP_SERVER_CONFIG_URL;
//控制退换货按钮开关  是否开启所有退换货流程  0 只能申请  1所有流程
extern NSString *U_ORDER_RETURN_OPEN;


extern NSString *U_SHARE_BRAND_URL;//品牌跳转
extern NSString *U_SHARE_TOPIC_URL;//话题跳转
extern NSString *U_SHARE_USER_URL;//个人中心
