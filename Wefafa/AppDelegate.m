
//
//  AppDelegate.m
//  Wefafa
//
//  Created by fafa  on 13-6-21.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "LoginViewController.h"
#import "AppSetting.h"
#import "Toast.h"
#import "WeFaFaGet.h"
#import "ASIHTTPRequest.h"
#import "SQLiteOper.h"
//#import "FAFAUdpClient.h"
#include <execinfo.h>
#import "Utils.h"

#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "Base.h"
#import "WeiXinUtils.h"
#import "WXPayClient.h"
#import "JSONKit.h"
#import "SinaWeiboClient.h"
#import "Globle.h"
#import "MBShoppingGuideInterface.h"
//#import "NoDataView.h"
//#import "XMPPFriend.h"
//#import "HomeViewController.h"
//#import "LeftViewController.h"
//#import "RightViewController.h"
//#import "LaunchScreenView.h"

#import "SMainViewController.h"
#import "SHomeViewController.h"
#import "SDiscoveryViewController.h"
#import "STabbarNavigationBarController.h"

#import "MobClick.h"
#import "SDataCache.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "SUtilityTool.h"
#import "SChatSocket.h"
#import "TalkingData.h"
#import "MBHttpClient.h"
#import <AdSupport/AdSupport.h>
//#import "SVideoWelcomeController.h"
#define _IPHONE80_ 80000
#import "SChatSystemListModel.h"
//***onlytextwhy.branch**//

// --.----------------------------------------------------------------------
//
// 环境定义，放到这里来，避免编译太慢。
// 现在放到了 不同target的pch中，避免做不同环境，需要修改Define
// 各个target，使用不同的bundle id。
//
// ------------------------------------------------------------------------
//#define _DEVELOPER_VER_  //开发环境
//#define _TEST_VER_ //测试环境

// ------------------------------------------v------------------------------
// 开发环境
// ------------------------------------------------------------------------
#ifdef _DEVELOPER_VER_

#define CONFIG_SERVER_URL @"http://10.8.34.19/mbfun_config_server/index.php?m=Config&a=getNewServerConfig&type=1"

// ------------------------------------------------------------------------
// 测试环境
// ------------------------------------------------------------------------
#elif defined _TEST_VER_

#define CONFIG_SERVER_URL @"http://10.100.28.2/mbfun_config_server/index.php?m=Config&a=getNewServerConfig&type=1"

// ------------------------------------------------------------------------
// 正式环境
// ------------------------------------------------------------------------

#else //正式环境
// 三网IP，后续绑定一下域名最好。
// mbfun.funwear.com
#define CONFIG_SERVER_URL @"http://mbfun.funwear.com/mbfun_config_server/index.php?m=Config&a=getNewServerConfig&type=1"

#endif

NSDictionary *_userInfo;

//是否正在录制视频
BOOL g_isVideoRecording=NO;

//QQ登录
TencentOAuth *_tencentOAuth=nil;


static NSString *UPDATE_WEFAFA_PLIST_URL=@"";

@implementation AppDelegate

//@synthesize dataString;

@synthesize managedObjectModel=_managedObjectModel;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
+(AppDelegate *)shareAppdelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

////////////////////////////////////////////////////////////////////////////
#pragma mark static method

+(AppDelegate *)App{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+(UINavigationController*)rootViewController
{
    return (UINavigationController*)[[[self App]window]rootViewController];
    //    UITabBarController *tabVC = (UITabBarController*)[[[self App] window] rootViewController];
    //    return (UINavigationController*)tabVC.selectedViewController;
}

+ (NSArray *)backtrace{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

// TODO:log相关的，可以去除
static void SignalHandler(int signal){
    //只记录最开始的三个
    static int SignalHandlerCount = 0;
    if (SignalHandlerCount < 3) SignalHandlerCount++;
    else return;
    
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; // 将调用栈拼成输出日志的字符串
    NSArray *arrBackrace = [AppDelegate backtrace];
    
    for ( NSString* item in arrBackrace )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    NSString *errmsg = [NSString stringWithFormat:@"[Uncaught Signal]\r\nSignal: %d\r\n[callStackSymbols]\r\n%@", signal, strSymbols];
    //    [strSymbols release];
    
    [Utils appendLog2File:errmsg];
}
static void handleRootException( NSException* exception ){
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; // 将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    NSString *errmsg = [NSString stringWithFormat:@"[Uncaught Exception]\r\nName: %@, Reason: %@\r\n[callStackSymbols]\r\n%@", name, reason, strSymbols];
    //    [strSymbols release];
    
    [Utils appendLog2File:errmsg];
}

#pragma mark UMENG method
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) BATCH channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

////////////////////////////////////////////////////////////////////////////
#pragma mark Application method
// 程序启动入口
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //为了避免新版和老版数据不兼容，新版本第一次运行时清空老版的缓存
    [AppSetting clearOldVersionCacheDataOnlyOnceInTheNewVersion];
    
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];//[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // TODO: 检查应用程序更新，并提示
    
    IS_IOS5_LATER = [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
    
    _appEnterBackground=NO;
    
    
    NSSetUncaughtExceptionHandler( handleRootException );
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    
    launchImageView = [UIImageView new];
    launchImageView.frame = self.window.bounds;
    launchImageView.contentMode = UIViewContentModeCenter;
    launchImageView.image = [UIImage imageNamed:@"Default-568h"];
    [self.window addSubview:launchImageView];
    
    [TalkingData sessionStarted:@"57ACC73DD380D01B489EC428768DB40F" withChannelId:@""];
    // show default launch image
    
    [self requestServerConfig:launchOptions];
    
    //    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    //    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    _userInfo = remoteNotification;
    
    return YES;
}

- (void)initApp:(NSDictionary*)launchOptions {
    [launchImageView removeFromSuperview];
    
    //创建
    [MBShoppingGuideInterface create];
    ////////////////
    //创建微信工具类
    wxUtils = [[WeiXinUtils alloc] init];
    wxPayClient = [[WXPayClient alloc] init];
    
    //向微信注册
    [WXApi registerApp:(NSString *)kWXAPP_ID withDescription:@"有范"];
    
    ////////////////
    //QQLoginAuth
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:(NSString*)QQAppID andDelegate:self];
    ////////////////
    _tencentOAuth.sessionDelegate = self;
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaAppKey];
    
    [AppSetting load:@""];
    NSMutableArray *arrHisLoginAcc = [AppSetting getHisLoginAccount];
    if (arrHisLoginAcc.count > 0) [AppSetting load:arrHisLoginAcc[0]];
    
    // TODO:第三方架构比较混乱的sns框架，后续修改掉。
    sns = [WeFaFaGet new];
    sns.shareOrLogin=NO;
    
    g_sqlite = [SQLiteOper new];
    [g_sqlite open:sns.jid];
    
    //    g_fafaUdpClient = [FAFAUdpClient new];
    //    xmppFriend = [XMPPFriend new];
    
    //    _xmppConnectDelegate = [XmppConnectDelegate new];
    //    [[_xmppConnectDelegate xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    // nav2
    //    RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    //    rootViewController.subViewController = [SHomeViewController new];
    
    UIViewController *rootVC = [SHomeViewController new];
    STabbarNavigationBarController *rootNav = [[STabbarNavigationBarController alloc]initWithRootViewController:rootVC];
    
    // 判断自动登录
    bool isManualConn = (![AppSetting getAutoLogin] );
    
    // 暂时都自动登录试试
    if (isManualConn) {
        self.window.rootViewController = rootNav;
        
        // 暂时必须登录，方便调试。
        //        if ([BaseViewController pushLoginViewController]) {
        //
        //        }
    } else {
        // 此处自动登录
        sns.isLogin = YES;
        SNSStaffFull *mySelfStaffInfo=[[SNSStaffFull alloc] init];
        NSMutableArray *rosterList=[[NSMutableArray alloc] init];
        
        BOOL isThirdLogin=[[DEFAULTS objectForKey:@"isThirdLogin"] boolValue];
        
        NSString *loginPlatform = [DEFAULTS objectForKey:@"loginPlatform"];
        NSDictionary *dict = [DEFAULTS objectForKey:@"loginPlatformInfo"];
        
        sns.isThirdLogin = isThirdLogin;
        
        self.window.rootViewController = rootNav;
        
        NSString *userId = [AppSetting getUserID];
        NSString *userPass = [AppSetting getPassword];
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *st;
        
        if ([loginPlatform isEqualToString:@"wx"]) {
            //微信登录IM服务器（自动注册）
            NSMutableString *jid=[[NSMutableString alloc] initWithCapacity:64];
            NSMutableString *loginid=[[NSMutableString alloc] initWithCapacity:64];
            NSMutableString *password=[[NSMutableString alloc] initWithCapacity:64];
            st=[sns snsWeiXinLogin:dict[@"unionid"] nickname:dict[@"nickname"] sex:dict[@"sex"] province:dict[@"province"] city:dict[@"city"] headimgurl:dict[@"headimgurl"] unionid:dict[@"unionid"] returnJID:jid returnLoginID:loginid returnPassword:password mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        } else if([loginPlatform isEqualToString:@"qq"]){
            // TODO: QQ自动登录还有点问题
            //QQ登录IM服务器（自动注册）
            NSMutableString *jid=[[NSMutableString alloc] initWithCapacity:64];
            NSMutableString *loginid=[[NSMutableString alloc] initWithCapacity:64];
            NSMutableString *password=[[NSMutableString alloc] initWithCapacity:64];
            st=[sns snsQQLogin:dict[@"openid"] nickname:dict[@"nickname"] gender:dict[@"gender"] province:dict[@"province"] city:dict[@"city"] headimgurl:dict[@"figureurl_qq_2"] returnJID:jid returnLoginID:loginid returnPassword:password mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        } else {
            st= [sns snsLogin:userId Password:userPass mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        }
        
        [g_sqlite open:sns.jid];//md00000255@fafacn.com sns.jid
        if ([g_sqlite isOpened]) {
            [sqlite insertStaff:mySelfStaffInfo];
            for (int i=0; i<rosterList.count;i++) {
                [sqlite insertStaff:rosterList[i]];
                
            }
        }
        
        if (![st isEqualToString:SNS_RETURN_SUCCESS]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self logout];
    
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    [[_xmppConnectDelegate xmppRosterStorage] loadLocalRoster];
                sns.isLogin = YES;
                //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_loginComplete" object:nil];
                
                // 登录完成
                /*
                 $ary['user_id'] = $jsonAry['id'];
                 $ary['nick_name'] = $jsonAry['nickName'];
                 $ary['head_img'] = $jsonAry['headPortrait'];
                 $ary['phone'] = $jsonAry['phoneNumber'];
                 */
                
                NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"currentversion－－－%@",currentVersion);

                
                NSDictionary *json = @{
                                       @"id":mySelfStaffInfo.ldap_uid,
                                       @"nickName":mySelfStaffInfo.nick_name,
                                       @"headPortrait":mySelfStaffInfo.photo_path_big,
                                       @"phoneNumber":mySelfStaffInfo.mobile,
                                       @"versionName":currentVersion
                                       };
                [[SDataCache sharedInstance] loginAccount:[AppSetting getUserID] password:[AppSetting getPassword] json:json];
            });
        }
        //        });
        
        //        self.window.rootViewController = rootViewController;
    }
    
    // 添加开头动画
    // [self startAnimation];
    // 友盟的方法本身是异步执行，所以不需要再异步调用
//    [self umengTrack];
    
    ///-----------------------------
    //信鸽
    ///-----------------------------
    [self registerPushService:launchOptions];
    
    // 只启动APNs. 小米推送
//    [MiPushSDK registerMiPush:self];
    
    NSString *messageId=[launchOptions objectForKey:@"_id_"];
    if(messageId!=nil)
    {
        [MiPushSDK openAppNotify:messageId];
        
    }
    
    // 判断是否第一次启动
    if (![DEFAULTS boolForKey:FIRSTSTARTAPP]){
        [SUTIL showIntro:YES];
        [DEFAULTS setBool:YES forKey:FIRSTSTARTAPP];
        [DEFAULTS synchronize];
    }else {
        [SUTIL showIntro:NO];
    }
    
    [self handlePushInfo:launchOptions];
    [self addUserSourceData];
}

- (void)requestServerConfig:(NSDictionary*)launchOptions
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *adId =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [manager GET:CONFIG_SERVER_URL parameters:@{@"idfa":adId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CONFIG_SERVER_URL: %@",responseObject);
        
        [self setRemoteConfig:responseObject[@"data"][@"config"]];
        
        [AppSetting showAppUpdateAlertView];
        
        [self initApp:launchOptions];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"CONFIG_SERVER_URL Fail: %@",error);
        
        NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"REMOTE_SERVER_CONFIG"];
        [self setRemoteConfig:info];
        
        
        [self initApp:launchOptions];
    }];
    
}



#pragma mark Global Setting
// ----------------------------------------------------------------------------------------------------
//
// Global Setting
//
// ----------------------------------------------------------------------------------------------------

- (void)setRemoteConfig:(NSDictionary*)info{
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:@"REMOTE_SERVER_CONFIG"];
    
    if (info.count < 10) return;
    // TODO: 完成后，打开下面的return；
    //    return;
    
    DEFAULT_SERVER = info[@"DEFAULT_SERVER"];
    // wefafa callcenter(soa)
    MBSoaServer = info[@"MBSoaServer"];
    MBH5URL = info[@"MBH5URL"];
    SOA_SECRET = info[@"SOA_SECRET"];
    // wefafa callcenter(soa) 这个好像没有用
    MAIN_SERVICE_SOA_TOKEN_URL = info[@"MAIN_SERVICE_SOA_TOKEN_URL"];
    // wefafa callcenter(soa) 这个获取Token
    MAIN_SERVICE_SOA_URL = info[@"MAIN_SERVICE_SOA_URL"];
    WEFAFA_PLIST_URL = info[@"WEFAFA_PLIST_URL"];
    //测试环境参数：softwareCode=MB.Designer.App&evmCode=MB.Designer.UAT
    SOFTWARECODE = info[@"SOFTWARECODE"];
    EVMCODE = info[@"EVMCODE"];
    ALIPAYNOTIFYURL = info[@"ALIPAYNOTIFYURL"];
    WORDFONTURL  = info[@"WORDFONTURL"];
    kHttpUrlString = info[@"kHttpUrlString"]; //联系客服
    
    kIosKey = info[@"kIosKey"];
    kInviteCodeUrl = info[@"kInviteCodeUrl"];
    kShareInviteCodeUrl = info[@"kShareInviteCodeUrl"];
    
    MBFUN_CHAT_SERVER = info[@"MBFUN_CHAT_SERVER"];
    MBFUN_CHAT_PORT = info[@"MBFUN_CHAT_PORT"];
    
    // 测试服务，外网配置
    CONFIG_URL = info[@"CONFIG_URL"];
    SERVER_URL = info[@"PHP_SERVER"];//SERVER_URL//PHP_SERVER
    
    PHP_SERVER_CONFIG_URL = info[@"PHP_SERVER_CONFIG_URLS"];
    
    
    SHARE_URL = info[@"SHARE_URL"];
    
    QQAppID=info[@"QQAppID"];
    QQAppKey=info[@"QQAppKey"];
    
    UMENG_APPKEY=info[@"UMENG_APPKEY"];
    
    // 首次启动视频和截图
    LAUNCH_VIDEO=info[@"LAUNCH_VIDEO"];
    // 首次启动加载视频前显示的视频截图
    LAUNCH_VIDEO_SNAP=info[@"LAUNCH_VIDEO_SNAP"];
    // 平时启动活动海报
    LAUNCH_IMAGE=info[@"LAUNCH_IMAGE"];
    
    LAUNCH_IMAGE_JUMP_INFO=info[@"LAUNCH_IMAGE_JUMP_INFO"];
    
    LAUNCH_DEFAULT_PAGE=info[@"LAUNCH_DEFAULT_PAGE"];
    
    SIGN_KEY = info[@"SIGN_KEY"];
    SERVER_CDN = info[@"SERVER_CDN"];
    
    PartnerID = info[@"PartnerID"];
    SellerID = info[@"SellerID"];
    PartnerPrivKey = info[@"PartnerPrivKey"];
    AlipayPubKey = info[@"AlipayPubKey"];
    HTML_ORDER_SUCCESS=info[@"HTML_ORDER_SUCCESS"];
    
    U_SHARE_BRAND_URL=info[@"U_SHARE_BRAND_URL"];//品牌分享
    U_SHARE_TOPIC_URL=info[@"U_SHARE_TOPIC_URL"];//话题分享
    U_SHARE_USER_URL=info[@"U_SHARE_USER_URL"];//个人中心
    SHARE_PROD_URL = info[@"PRODUCT_SHARE_URL"];//单品详情分线
    
    

    
    U_ORDER_RETURN_OPEN = [NSString stringWithFormat:@"%@",info[@"U_ORDER_RETURN_OPEN"]];
    
    
    // 地推的页面
    if (info[@"MDTG_URL"]) MDTG_URL = info[@"MDTG_URL"];
    
    
    VERSION_NAME = info[@"VERSION_NAME"];
    VERSION_CODE = info[@"VERSION_CODE"];
    VERSION_INFO = info[@"VERSION_INFO"];
    IS_FORCE_UPDATE = info[@"IS_FORCE_UPDATE"];
    //微信支付
    WX_APP_ID =  [NSString stringWithFormat:@"%@",info[@"WX_APP_ID"]];
    WX_PARNER_ID =  [NSString stringWithFormat:@"%@",info[@"WX_PARNER_ID"]];
    WX_APY_SINGN_KEY =  [NSString stringWithFormat:@"%@",info[@"WX_APY_SINGN_KEY"]];
    WX_BEFORE_PAY_URL =[NSString stringWithFormat:@"%@",info[@"WX_BEFORE_PAY_URL"]];
    if([[info allKeys] containsObject:@"SIDEBAR"])
    {
        if([info[@"SIDEBAR"] isKindOfClass:[NSArray class]])
        {
            //侧边栏数据
            SIDEBAR_ARRAY = [NSArray arrayWithArray:info[@"SIDEBAR"]];
        }
    }
    
    if([[info allKeys] containsObject:@"APP_LAYOUT"])
    {
       MENUBOTTOM_ARRAY = [NSArray arrayWithObject:info[@"APP_LAYOUT"]];
        if([MENUBOTTOM_ARRAY count]==1){
            if([MENUBOTTOM_ARRAY[0] count]<5){
                MENUBOTTOM_ARRAY=nil;
            }
        }
    }
}
// ----------------------------------------------------------------------------------------------------
//
// Global Setting
//
// ----------------------------------------------------------------------------------------------------


// 处理启动参数
-(void)handlePushInfo:(NSDictionary*)launchOptions{
    NSLog(@"Push Info: \n %@",launchOptions);
    if( launchOptions && launchOptions[@"mess_id"]){
        NSLog(@"new message");
        // TODO: add message item
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_CHAT_MESSAGE" object:nil userInfo:launchOptions];
        
        //        [RKDropdownAlert title:@"新消息通知"];
    }
}

// 注册推送，目前用信鸽，后续可以用个推（基于数据中立隐蔽性考虑）
-(void)registerPushService:(NSDictionary *)launchOptions{
    ///-----------------------------
    //信鸽
    ///-----------------------------
    // 下面是信鸽注册 注意要替换id和appKey
    // 目前这个是物语的
    [XGPush startApp:2200122402 appKey:@"IN13DC9MI43D"];
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void) {
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerXGPush];
            }
            else{
                [self registerXGPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerXGPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void) {
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void) {
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

-(void)showSplashView{
    //splash
    UIView *splashView=[[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,UI_SCREEN_HEIGHT)];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];  //放到最顶层;
    
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:splashView.frame];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        imgBg.image=[UIImage imageNamed:@"Default-568h@2x.png"];
        
    }
    else
    {
        imgBg.image=[UIImage imageNamed:@"Default.png"];
    }
    
    [splashView addSubview:imgBg];
    
    [self performSelector:@selector(removeSplashView:) withObject:splashView afterDelay:1.0];
}

- (void)removeSplashView:(UIView *)splashView{
    [splashView removeFromSuperview];
    splashView = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // TODO:
    // App从后台到前台时候，黏贴板检测，判断邀请码 ，自动关注和领取红包等。
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _appEnterBackground=YES;

    NSUserDefaults *dateCache= [NSUserDefaults standardUserDefaults];
    NSDate *date = [NSDate date];
    NSLog(@"date－－－－－－%@",date);
    
    [dateCache setObject:date forKey:@"date"];
    [dateCache synchronize];
    
    if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
    {
        [application setKeepAliveTimeout:600 handler:^{
            
            NSLog(@"KeepAliveHandler");
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _appEnterBackground=NO;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    NSUserDefaults *dateCache= [NSUserDefaults standardUserDefaults];
    NSDate *value = [dateCache objectForKey:@"date"];
    BOOL  ismorethan;
    ismorethan = [self compareCurrentTime:value];
    if (ismorethan) {
        [self application:application didFinishLaunchingWithOptions:nil];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    if (devToken.length==0) {
        NSLog(@">>>>>>>error devToken length=0");
        return;
    }
    const Byte *devTokenBytes = [devToken bytes];
    NSMutableString *devTokenstr = [[NSMutableString alloc] initWithCapacity:64];
    for (int i=0; i<devToken.length; i++) {
        [devTokenstr appendFormat:@"%02X", devTokenBytes[i]];
    }
    // for old im
    self.devTokenStr = devTokenstr;
    
    // for new
    [SDataCache sharedInstance].deviceToken = devToken;
    
    void (^successBlock)(void) = ^(void) {
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",devTokenstr);
    };
    
    void (^errorBlock)(void) = ^(void) {
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [XGPush registerDevice:devToken successCallback:successBlock errorCallback:errorBlock];
    //小米
    // 注册APNS成功, 注册deviceToken
    NSLog(@"token－－－%@",devToken);
    
    [MiPushSDK bindDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error in registration. Error: %@",err];
    NSLog(@"注册错误%@",str);
}
#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    //小米数据推过来后的处理
    NSLog(@"data--sss--%@",data);
    NSLog(@"SELECTOR----%@",selector);
    // 设置别名
    [MiPushSDK setAlias:@"wwp"];
    
    //    [vMain printLog:[NSString stringWithFormat:@"succ(%@): %@", [self getOperateType:selector], data]];
    //
    if ([selector isEqualToString:@"registerMiPush:"]) {
        //        [vMain setRunState:YES];
    }else if ([selector isEqualToString:@"bindDeviceToken:"]) {
 
    }
    else
    {
        //跳转
        [self jumpToViewControllerWithDic:data];
    }
    
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    NSString *str = [NSString stringWithFormat: @"Error in registration. Error: %d",error];
    NSLog(@"小米%@",str);
}

//////////////
#pragma mark WeixinDelegate

-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    //    WXSuccess           = 0,
    //    WXErrCodeCommon     = -1,
    //    WXErrCodeUserCancel = -2,
    //    WXErrCodeSentFail   = -3,
    //    WXErrCodeAuthDeny   = -4,
    //    WXErrCodeUnsupport  = -5,
    
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        //登录微信，第一步：获取code 响应
        //ERR_OK = 0(用户同意)
        //ERR_AUTH_DENIED = -4（用户拒绝授权）
        //ERR_USER_CANCEL = -2（用户取消）
        if (resp.errCode==0)
        {
            SendAuthResp * r1=(SendAuthResp *)resp;
            wxUtils.WXLogin_Code=[[NSString alloc] initWithFormat:@"%@",r1.code];
            [wxUtils getWXAuthAccessToken]; // 调用第二部
        }
        else
        {
            [Toast hideToastActivity];
            NSString *msgstr=nil;
            if (resp.errCode==-2) msgstr=[NSString stringWithFormat:@"您取消了微信授权!"];
            else if (resp.errCode==-4) msgstr=[NSString stringWithFormat:@"您拒绝了微信授权!"];
            else msgstr=[NSString stringWithFormat:@"微信帐号登录失败!"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgstr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([resp isKindOfClass:[PayResp class]])//
    {
        if (resp.errCode==0) {
            //刷新订单信息
            NSDictionary *postDic=@{@"tag":@[@"0",@"1",@"2"]};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
            //订单详情需要
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderSuccess" object:nil userInfo:postDic];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil userInfo:postDic];
            
            [wxPayClient payCompleteCallback:@{@"returncode":@(YES),@"msg":@"微信支付成功!"}];
            
            
        }
        else
        {
            [Toast hideToastActivity];
            NSString *msgstr=nil;
            if (resp.errCode==-2) msgstr=[NSString stringWithFormat:@"您取消了微信支付!"];
            else if (resp.errCode==-4) msgstr=[NSString stringWithFormat:@"您拒绝了微信支付!"];
            else msgstr=[NSString stringWithFormat:@"微信支付失败!"];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msgstr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            [wxPayClient payCompleteCallback:@{@"returncode":@(NO),@"msg":msgstr}];
        }
    }
    
    if (resp.errCode == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareback" object:nil];//jsWEB分享返回调用js函数
    }else if (resp.errCode == -2) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@2];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@1];
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *str=[url absoluteString];
    if ([str hasPrefix:@"tencent"]) {
        // no  是第三方登陆 yes 是分享
        if(sns.shareOrLogin==NO)
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            sns.shareOrLogin=NO;
            
            return  [[Globle shareInstance] handleResponseQQZoneWithurl:url];
        }
    }
    else if ([str hasPrefix:@"wb"])
    {
        
        //wb2045436852://response?id=3DCA58DC-1062-4AEE-9C30-728099A58FB6&sdkversion=2.5
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([str hasPrefix:@"wx"])
    {
        //wx8c99f5d8af954939://platformId=wechat
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return [self parse:url application:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString *pt = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([sourceApplication isEqualToString:@"com.tencent.mqq"])
    {
        if(sns.shareOrLogin==NO)
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            return  [[Globle shareInstance] handleResponseQQZoneWithurl:url];
        }
        
        
        //tencent1102534852://response_from_qq?source_scheme=mqqapi&source=qq&error=-4&error_description=dGhlIHVzZXIgZ2l2ZSB1cCB0aGUgY3VycmVudCBvcGVyYXRpb24=&version=1
        
    }else if([pt rangeOfString:[NSString stringWithFormat:@"%@",QQAppID]].length == QQAppID.length){//解决网页wap分享的时候QQ回调问题
        
        if(sns.shareOrLogin==NO)
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            return  [[Globle shareInstance] handleResponseQQZoneWithurl:url];
        }
    }
    else if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        //wb2045436852://response?id=3DCA58DC-1062-4AEE-9C30-728099A58FB6&sdkversion=2.5
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        //wx8c99f5d8af954939://platformId=wechat
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {
        return [self parse:url application:application];
    }
    
    if ([[url scheme] isEqualToString:@"metersbonwejumpyoufan"]) {
        //web参数
        NSString *param = [url query];
        if (!IS_STRING(param)) {
            return NO;
        }
        //转换格式
        //        NSDictionary *dic = [SUTIL getObject:param];
        //        if (dic.count == 0) {
        //            return NO;
        //        }
        NSMutableDictionary *dic = [NSMutableDictionary new];
        NSArray *strAry =[param componentsSeparatedByString:@"&"];
        for (NSString * subStr in strAry) {
            NSArray *str = [subStr componentsSeparatedByString:@"="];
            if ([strAry indexOfObject:subStr] == 0) {
                dic[@"jump_type"] = str[1];
            }else {
                dic[@"tid"] = str[1];
            }
        }
        
        NSDictionary *dictionary = @{ @"is_h5" : @"0",//[dic objectForKey:@"is_h5"],
                                      @"url" : @"",//[dic objectForKey:@"url"],
                                      @"name" : @"",//[dic objectForKey:@"message"],
                                      @"show_type" : [dic objectForKey:@"jump_type"],
                                      @"tid" : [dic objectForKey:@"tid"] };
        [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
        return YES;
    }
    
    return [self parse:url application:application];
}

#pragma mark QQDelegate 腾讯QQ相关回调，后续可以整合
// QQLogin
-(void)qqLogin:(CommonEventHandler *)eventHandle{
    qqCallbackEvent=eventHandle;
    NSMutableArray *tencentPermissions = [[NSMutableArray alloc] initWithObjects:
                                          kOPEN_PERMISSION_GET_USER_INFO,
                                          kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                          kOPEN_PERMISSION_ADD_SHARE,
                                          nil];
    [_tencentOAuth authorize:tencentPermissions inSafari:NO];
}
/**
 * Called when the user successfully logged in.
 */
- (void)addShareResponse:(APIResponse *)response{
    NSLog(@",l,,,-----%@",response);
    if(response.retCode == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareback" object:nil];//jsWEB分享返回调用js函数
    }else if(response.retCode == 2){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@2];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@1];
    }
}

- (void)responseDidReceived:(APIResponse *)response forMessage:(NSString *)message{
    
}

- (void)isOnlineResponse:(NSDictionary *)response{
    
}

- (void)tencentDidLogin {
    // 登录成功
    [Toast hideToastActivity];
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
#ifdef DEBUG
        NSLog(@"tencentOAuth.accessToken=%@",_tencentOAuth.accessToken);
#endif
        if(![_tencentOAuth getUserInfo]){
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"api调用失败" message:@"可能授权已过期，请重新获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [alert show];
        }
    }
    else
    {
        [Utils alertMessage: @"登录不成功(没有获取accesstoken)!"];
    }
}
/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    [Toast hideToastActivity];
    if (cancelled){
        //		[Utils alertMessage: @"用户取消登录!"];
    }
    else {
        [Utils alertMessage: @"登录失败!"];
    }
}

/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork{
    [Toast hideToastActivity];
    [Utils alertMessage: @"无网络连接，请设置网络!"];
}

/**
 * Called when the logout.
 */
-(void)tencentDidLogout{
    [Toast hideToastActivity];
    [Utils alertMessage: @"退出登录成功，请重新登录!"];
}
/**
 * Called when the get_user_info has response.
 */
- (void)getUserInfoResponse:(APIResponse*) response {
    [Toast hideToastActivity];
    if (response.retCode == URLREQUEST_SUCCEED){
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:response.jsonResponse];
        [dict setObject:[[NSString alloc] initWithFormat:@"%@",_tencentOAuth.openId] forKey:@"openid"];
        [dict setObject:WEFAFA_APPID forKey:@"appid"];
        [dict setObject:@"meibang" forKey:@"code"];
        [dict setObject:WEFAFA_ENO forKey:@"eno"];
        [dict setObject:@"02" forKey:@"logintype"];
#ifdef DEBUG
        NSLog(@"QQ用户信息:%@",[dict JSONString]);
#endif
        [qqCallbackEvent fire:self eventData:dict];
    } else {
        [qqCallbackEvent fire:self eventData:[NSString stringWithFormat:@"获取QQ用户信息失败,%@",response.errorMsg]];
    }
}

#pragma mark - weibo delegate
//sina weibo
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"weibohuidiaorequest---%@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if(response.statusCode == 0){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@0];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareback" object:nil];//jsWEB分享返回调用js函数
    }else if(response.statusCode == -1){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@2];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"shareCountAdd" object:@1];
    }
}

// TODO: 这里还处理了一次显示。
// FIXED : 干掉重复的创建。
-(void)logout {
    g_isVideoRecording=NO;
    sns.isLogin=NO;
    [AppSetting setAutoLogin:false];
    [AppSetting save];
    
    [[SChatSocket shared] logout];
    [[SDataCache sharedInstance] logout];
    //    [g_sqlite close];
    sns.ldap_uid=@"";
    sns.myStaffCard= [[SNSStaffFull alloc]init];
    [DEFAULTS removeObjectForKey:@"isThirdLogin"];
    [DEFAULTS removeObjectForKey:@"loginPlatform"];
    [DEFAULTS removeObjectForKey:@"loginPlatformInfo"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BOOKID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FITTINGROOMGOODS"];
    //因为有一些xmpp上的delegate可能是挂在主线程上，并且所有delegate都是异步调用，为了等待关闭及相关delegate的调用完成，将新界面的生成及原界面的释放排队至主线程后面去
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti_loginOut" object:nil];
    });
}

+(id)getTabViewControllerObject:(NSString *)className {
    return nil;
}

//托管对象
-(NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    //    NSURL* modelURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"momd"];
    //    _managedObjectModel=[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _managedObjectModel=[NSManagedObjectModel mergedModelFromBundles:nil] ;
    return _managedObjectModel;
}
//托管对象上下文
-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext!=nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator=[self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

//持久化存储协调器
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator!=nil) {
        return _persistentStoreCoordinator;
    }
    //    NSURL* storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreaDataExample.CDBStore"];
    //    NSFileManager* fileManager=[NSFileManager defaultManager];
    //    if(![fileManager fileExistsAtPath:[storeURL path]])
    //    {
    //        NSURL* defaultStoreURL=[[NSBundle mainBundle] URLForResource:@"CoreDataExample" withExtension:@"CDBStore"];
    //        if (defaultStoreURL) {
    //            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
    //        }
    //    }
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL* storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"newdesiger.sqlite"]];
    NSLog(@"path is %@",storeURL);
    NSError* error=nil;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

#pragma 支付宝支付相关
- (BOOL)parse:(NSURL *)url application:(UIApplication *)application {
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             //                                             NSString *resultStr = resultDic[@"result"];
                                             
                                             NSLog(@"reslut = %@",resultDic);
                                             if (resultDic)
                                             {
                                                 //                AliSDKDemo[19493:1011959] reslut = {
                                                 //                    memo = "";
                                                 //                    result = "";
                                                 //                    resultStatus = 6001;
                                                 //                }
                                                 NSString *resultStatusStr =[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]] ;
                                                 
                                                 switch (resultStatusStr.intValue)
                                                 {
                                                     case 9000:{
                                                         /*
                                                          *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
                                                          */
                                                         //交易成功
                                                         //            NSString* key = AlipayPubKey;//  @"签约帐户后获取到的支付宝公钥";
                                                         //                id<DataVerifier> verifier;
                                                         //                verifier = CreateRSADataVerifier(key);
                                                         //                if ([verifier verifyString:result.resultString withSign:result.signString])
                                                         //                {
                                                         //验证签名成功，交易结果无篡改
                                                         NSDictionary *postDic=@{@"tag":@[@"0",@"1",@"2"]};
                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"refeshData" object:nil userInfo:postDic];
                                                         //订单详情需要
                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"orderSuccess" object:nil userInfo:postDic];
                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"requestData" object:nil userInfo:postDic];
                                                         
                                                         
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYALICOMPLETE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //                }
                                                     }
                                                         break;
                                                     case 8000:
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //支付宝返回原因 正在处理中
                                                         [Toast makeToast:[resultDic objectForKey:@"result"]];
                                                         
                                                         
                                                         break;
                                                     case 4000:
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //支付宝返回原因 订单支付失败
                                                         [Toast makeToast:[resultDic objectForKey:@"result"]];
                                                         
                                                         
                                                         break;
                                                     case 6001:
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //支付宝返回原因 用户中途取消
                                                         [Toast makeToast:@"亲,中途取消"];
                                                         
                                                         
                                                         break;
                                                     case 6002:
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //支付宝返回原因 网络连接出错
                                                         [Toast makeToast:[resultDic objectForKey:@"result"]];
                                                         
                                                         
                                                         break;
                                                     default:
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":resultDic}];
                                                         //交易失败
                                                         [Toast makeToast:@"亲,交易未成功"];
                                                         
                                                         break;
                                                 }
                                                 
                                             }
                                             else
                                             {
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_PAYFAILURE object:nil userInfo:@{@"AlixPayResult":@"亲,交易未成功"}];
                                                 //失败
                                                 [Toast makeToast:@"亲,交易未成功"];
                                             }
                                             
                                         }];
        
    }
    
    return YES;
}

- (void)tapViewActionRemove:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.5 animations:^{
        tap.view.alpha = 0;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //[AppSetting closeThirdLoginAccount];
    if ([alertView.title isEqualToString:@"版本更新"])
    {
        if (buttonIndex==0) {
            NSString *downloadurl = [[NSString alloc] initWithFormat:@"itms-services://?action=download-manifest&url=%@",UPDATE_WEFAFA_PLIST_URL.length>0?UPDATE_WEFAFA_PLIST_URL:WEFAFA_PLIST_URL];
            NSURL *url  = [NSURL URLWithString:downloadurl];
            [[UIApplication sharedApplication] openURL:url];
            exit(0);
        }
    }
}


# pragma mark 信鸽

- (void)registerXGPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction* acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory* inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[ acceptAction ] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[ acceptAction ] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet* categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings* mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerXGPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    [XGPush delLocalNotification:notification];
    
    NSLog(@"__FUNCTION__ ---- %@", @"didReceiveLocalNotification");
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
}

//按钮点击事件回调
- (void)application:(UIApplication*)application handleActionWithIdentifier:(NSString*)identifier forRemoteNotification:(NSDictionary*)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
    
    if (_userInfo.count != 0) {
        NSLog(@"remoteNotification.count");
        UITabBarController *tabVC = (UITabBarController*)self.window.rootViewController;
        
        NSDictionary *bannerDic = [[_userInfo objectForKey:@"aps"] objectForKey:@"banner"];
        ///
        if ([[bannerDic allKeys] count]==0) {
            return;
        }
        ///
        
        SChatSystemListModel *model = [[SChatSystemListModel alloc]initWithDic:bannerDic];
        NSDictionary *dictionary = @{ @"is_h5" : model.SChatSystemListBannerInfo.is_h5,
                                      @"url" : model.SChatSystemListBannerInfo.url,
                                      @"name" : model.message,
                                      @"show_type" : model.SChatSystemListBannerInfo.type,
                                      @"tid" : model.SChatSystemListBannerInfo.tid };
        
        [[SUtilityTool shared] jumpControllerWithContent:dictionary target:[self getCurrentVC]];
    }
}

#endif

//处理收到的消息推送
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //  Tells the delegate that the running app received a remote notification.
    // 启动中，或者收到推送后，从后台切换到前台，都会进入这里。
    // 可以处理一些预设的参数
    NSLog(@"Receive remote notification : %@", userInfo);
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
    
    
    UNREAD_ALL_NUMBER++;
    [[NSNotificationCenter defaultCenter] postNotificationName:MBFUN_REMOTE object:nil];
    // 用户信鸽的统计
    [XGPush handleReceiveNotification:userInfo];
    
    // 统一处理推送
    [self handlePushInfo:userInfo];
    /*
     $custom = array(
     'head_img' => $userInfo['head_img'],
     'user_id' => $userId,
     'mess_id' => $newId,
     'message' => $messageInfo,
     'type' => 17,
     'jump' => array(
     'jump_id' => "0",
     "jump_type" => 17,
     "is_h5" => "0",
     "url" => "0",
     "tid" => $newId
     )
     );
     */
    
    /*
     {
     aps =     {
     
     alert = "\U65b0\U7684\U5546\U54c1\U5df2\U4e0a\U67b6!";
     sound = default;
     };
     xg =     {
     
     bid = 0;
     ts = 1438919871;
     };
     }
     */
    /*
     {
     aps =     {
     alert = "\U62bd\U5956\U5427";
     };
     jump =     {
     "is_h5" = 1;
     "jump_id" = 66;
     "jump_type" = 6;
     name = "\U6d4b\U8bd5\U62bd\U5956";
     share = 0;
     tid = 0;
     url = "http://stylistpay.51mb.com/wap2_0/promotion/GetAward.html";
     };
     type = 0;
     xg =     {
     bid = 0;
     ts = 1438930159;
     };
     }
     */
    
    /*
     //数据 格式啊
     NSDictionary *dic = [[userInfo objectForKey:@"aps"] objectForKey:@"custom"];
     NSString *is_H5=nil;
     NSString *url=nil;
     NSString *name=nil;
     NSString *show_type=nil;
     NSString *tid=nil;
     //以前的
     if ([[dic allKeys] containsObject:@"type"]) {
     
     NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
     if(![type isEqualToString:@"0"])//如果不为0 不跳转
     {
     return;
     }
     is_H5=[NSString stringWithFormat:@"%@",dic[@"is_h5"]];
     url=[NSString stringWithFormat:@"%@",dic[@"url"]];
     
     if ([[dic allKeys] containsObject:@"message"]) {
     
     name=[NSString stringWithFormat:@"%@",dic[@"message"]];
     }
     else
     {
     name=[NSString stringWithFormat:@"%@",dic[@"name"]];
     }
     show_type=[NSString stringWithFormat:@"%@",dic[@"jump_type"]];
     tid=[NSString stringWithFormat:@"%@",dic[@"tid"]];
     }
     else
     {//新的
     //如果type 不存在 则不跳转－1 不跳转  0 跳转.17 消息   18 通知
     if ([[userInfo allKeys] containsObject:@"type"]) {
     
     NSString *type = [NSString stringWithFormat:@"%@",userInfo[@"type"]];
     switch ([type integerValue]) {
     case -1://不跳转
     {
     return;
     }
     break;
     case 0:
     {
     //跳转
     }break;
     case 17:
     {
     //跳转消息
     }break;
     case 18:
     {
     //跳转通知
     }break;
     default:
     {
     }
     break;
     }
     
     if ([[userInfo allKeys] containsObject:@"jump"]) {
     dic= userInfo[@"jump"];
     is_H5=[NSString stringWithFormat:@"%@",dic[@"is_h5"]];
     url=[NSString stringWithFormat:@"%@",dic[@"url"]];
     name=[NSString stringWithFormat:@"%@",dic[@"name"]];
     if ([[dic allKeys] containsObject:@"message"])
     {
     name=[NSString stringWithFormat:@"%@",dic[@"message"]];
     }
     show_type=[NSString stringWithFormat:@"%@",dic[@"jump_type"]];
     tid=[NSString stringWithFormat:@"%@",dic[@"tid"]];
     
     }
     else
     {
     return;
     
     }
     }
     else
     {
     //如果type没有 则不跳转
     return;
     }
     }
     
     NSDictionary *dictionary = @{ @"is_h5" : [Utils getSNSInteger:is_H5],
     @"url" : [Utils getSNSString:url],
     @"name" : [Utils getSNSString:name],
     @"show_type" : [Utils getSNSInteger:show_type],
     @"tid" : [Utils getSNSString:tid]
     };
     
     [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
     */
    [self jumpToViewControllerWithDic:userInfo];
}
/*
{
    aps =     {
        alert = dasdasdasdasd;
    };
    jump =     {
        "is_h5" = 0;
        "jump_id" = 439;
        "jump_type" = 4;
        name = "\U560e\U560e\U560e\U6447\U6eda\U660e\U661f\U4eec\U7231\U7684\U978b";
        share = 0;
        tid = "";
        url = 0;
    };
    type = 0;
    xg =     {
        bid = 0;
        ts = 1442844372;
    };
}
*/
-(void) jumpToViewControllerWithDic:(NSDictionary *)userInfoDic
{
//    //数据 格式啊
//    NSDictionary *dic = [[userInfoDic objectForKey:@"aps"] objectForKey:@"custom"];
//    NSString *is_H5=nil;
//    NSString *url=nil;
//    NSString *name=nil;
//    NSString *show_type=nil;
//    NSString *tid=nil;
///*
//    //以前的
//    if ([[dic allKeys] containsObject:@"type"]) {
//        
//        NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
//        if(![type isEqualToString:@"0"])//如果不为0 不跳转
//        {
//            return;
//        }
//        is_H5=[NSString stringWithFormat:@"%@",dic[@"is_h5"]];
//        url=[NSString stringWithFormat:@"%@",dic[@"url"]];
//        
//        if ([[dic allKeys] containsObject:@"message"]) {
//            
//            name=[NSString stringWithFormat:@"%@",dic[@"message"]];
//        }
//        else
//        {
//            name=[NSString stringWithFormat:@"%@",dic[@"name"]];
//        }
//        show_type=[NSString stringWithFormat:@"%@",dic[@"jump_type"]];
//        tid=[NSString stringWithFormat:@"%@",dic[@"tid"]];
//    }
//    else
//    {//新的
//        //如果type 不存在 则不跳转－1 不跳转  0 跳转.17 消息   18 通知
//        if ([[userInfoDic allKeys] containsObject:@"type"]) {
//            
//            NSString *type = [NSString stringWithFormat:@"%@",userInfoDic[@"type"]];
//            switch ([type integerValue]) {
//                case -1://不跳转
//                {
//                    return;
//                }
//                    break;
//                case 0:
//                {
//                    //跳转
//                }break;
//                case 17:
//                {
//                    //跳转消息
//                }break;
//                case 18:
//                {
//                    //跳转通知
//                }break;
//                default:
//                {
//                }
//                    break;
//            }
//            
//            if ([[userInfoDic allKeys] containsObject:@"jump"]) {
//                dic= userInfoDic[@"jump"];
//                is_H5=[NSString stringWithFormat:@"%@",dic[@"is_h5"]];
//                url=[NSString stringWithFormat:@"%@",dic[@"url"]];
//                name=[NSString stringWithFormat:@"%@",dic[@"name"]];
//                if ([[dic allKeys] containsObject:@"message"])
//                {
//                    name=[NSString stringWithFormat:@"%@",dic[@"message"]];
//                }
//                show_type=[NSString stringWithFormat:@"%@",dic[@"jump_type"]];
//                tid=[NSString stringWithFormat:@"%@",dic[@"tid"]];
//                
//            }
//            else
//            {
//                return;
//                
//            }
//        }
//        else
//        {
//            //如果type没有 则不跳转
//            return;
//        }
//    }
//    
//    NSDictionary *dictionary = @{ @"is_h5" : [Utils getSNSInteger:is_H5],
//                                  @"url" : [Utils getSNSString:url],
//                                  @"name" : [Utils getSNSString:name],
//                                  @"show_type" : [Utils getSNSInteger:show_type],
//                                  @"tid" : [Utils getSNSString:tid]
//                                  };
//    
//    [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
//    */
//    
//    if ([[dic allKeys] containsObject:@"show_type"]) {
//        //如果type 不存在 则不跳转－1 不跳转  0 跳转.17 消息   18 通知
//        if ([[dic objectForKey:@"type"] intValue] == -1) {
//            //不跳转
//            return;
//        }else if ([[dic objectForKey:@"type"] intValue] == 0){
//            //跳转页面
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [dic objectForKey:@"is_H5"];
//            }
//            if ([dic objectForKey:@"url"] != NULL) {
//                url = [dic objectForKey:@"url"];
//            }
//            if ([dic objectForKey:@"name"] != NULL) {
//                name = [dic objectForKey:@"name"];
//            }
//            if ([dic objectForKey:@"show_type"] != NULL) {
//                show_type = [dic objectForKey:@"show_type"];
//            }
//            if ([dic objectForKey:@"tid"] != NULL) {
//                tid = [dic objectForKey:@"tid"];
//            }
//        }else if ([[dic objectForKey:@"type"] intValue] == 17){
//            //消息
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [dic objectForKey:@"is_H5"];
//            }
//            if ([dic objectForKey:@"url"] != NULL) {
//                url = [dic objectForKey:@"url"];
//            }
//            if ([dic objectForKey:@"name"] != NULL) {
//                name = [dic objectForKey:@"name"];
//            }
//            if ([dic objectForKey:@"show_type"] != NULL) {
//                show_type = [dic objectForKey:@"show_type"];
//            }
//            if ([dic objectForKey:@"tid"] != NULL) {
//                tid = [dic objectForKey:@"tid"];
//            }
//        }else if ([[dic objectForKey:@"type"] intValue] == 18){
//            //通知
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [dic objectForKey:@"is_H5"];
//            }
//            if ([dic objectForKey:@"url"] != NULL) {
//                url = [dic objectForKey:@"url"];
//            }
//            if ([dic objectForKey:@"name"] != NULL) {
//                name = [dic objectForKey:@"name"];
//            }
//            if ([dic objectForKey:@"show_type"] != NULL) {
//                show_type = [dic objectForKey:@"show_type"];
//            }
//            if ([dic objectForKey:@"tid"] != NULL) {
//                tid = [dic objectForKey:@"tid"];
//            }
//        }
//
//    }else {
//        //如果type 不存在 则不跳转－1 不跳转  0 跳转.17 消息   18 通知
//        if ([[userInfoDic objectForKey:@"type"] intValue] == -1) {
//            //不跳转
//            return;
//        }else if ([[userInfoDic objectForKey:@"type"] intValue] == 0){
//            //跳转
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [userInfoDic objectForKey:@"is_H5"];
//            }
//            if ([userInfoDic objectForKey:@"url"] != NULL) {
//                url = [userInfoDic objectForKey:@"url"];
//            }
//            if ([userInfoDic objectForKey:@"name"] != NULL) {
//                name = [userInfoDic objectForKey:@"name"];
//            }
//            if ([userInfoDic objectForKey:@"show_type"] != NULL) {
//                show_type = [userInfoDic objectForKey:@"show_type"];
//            }
//            if ([userInfoDic objectForKey:@"tid"] != NULL) {
//                tid = [userInfoDic objectForKey:@"tid"];
//            }
//        }else if ([[dic objectForKey:@"type"] intValue] == 17){
//            //消息
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [userInfoDic objectForKey:@"is_H5"];
//            }
//            if ([userInfoDic objectForKey:@"url"] != NULL) {
//                url = [userInfoDic objectForKey:@"url"];
//            }
//            if ([userInfoDic objectForKey:@"name"] != NULL) {
//                name = [userInfoDic objectForKey:@"name"];
//            }
//            if ([userInfoDic objectForKey:@"show_type"] != NULL) {
//                show_type = [userInfoDic objectForKey:@"show_type"];
//            }
//            if ([userInfoDic objectForKey:@"tid"] != NULL) {
//                tid = [userInfoDic objectForKey:@"tid"];
//            }
//        }else if ([[dic objectForKey:@"type"] intValue] == 18){
//            //通知
//            if ([dic objectForKey:@"is_H5"] != NULL) {
//                is_H5 = [userInfoDic objectForKey:@"is_H5"];
//            }
//            if ([userInfoDic objectForKey:@"url"] != NULL) {
//                url = [userInfoDic objectForKey:@"url"];
//            }
//            if ([userInfoDic objectForKey:@"name"] != NULL) {
//                name = [userInfoDic objectForKey:@"name"];
//            }
//            if ([userInfoDic objectForKey:@"show_type"] != NULL) {
//                show_type = [userInfoDic objectForKey:@"show_type"];
//            }
//            if ([userInfoDic objectForKey:@"tid"] != NULL) {
//                tid = [userInfoDic objectForKey:@"tid"];
//            }
//        }
//
//    }
//    NSDictionary *dictionary = @{ @"is_h5" : [Utils getSNSInteger:is_H5],
//                                  @"url" : [Utils getSNSString:url],
//                                  @"name" : [Utils getSNSString:name],
//                                  @"show_type" : [Utils getSNSInteger:show_type],
//                                  @"tid" : [Utils getSNSString:tid]
//                                  };
//    [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
    
    
    NSString *is_h5 = nil;
    NSString *url = nil;
    NSString *name = nil;
    NSString *show_type = nil;
    NSString *tid = nil;
    NSDictionary *dictionary = [NSDictionary new];
    if ([userInfoDic objectForKey:@"jump"] != NULL) {
        dictionary = [userInfoDic objectForKey:@"jump"];
        //取数据
        if ([dictionary objectForKey:@"is_h5"] != NULL) {
            is_h5 = [dictionary objectForKey:@"is_h5"];
        }
        if ([dictionary objectForKey:@"url"] != NULL) {
            url = [dictionary objectForKey:@"url"];
        }
        if ([dictionary objectForKey:@"name"] != NULL) {
            name = [dictionary objectForKey:@"name"];
        }
        if ([dictionary objectForKey:@"jump_type"] != NULL) {   //没有show_type 只有jump_type
            show_type = [dictionary objectForKey:@"jump_type"];
        }
        if ([dictionary objectForKey:@"tid"] != NULL) {
            tid = [dictionary objectForKey:@"tid"];
        }
        if (is_h5 && url && name && show_type && tid) {
            //组装字典 并且不能有nil数据引发崩溃
            dictionary = @{
                           @"is_h5" : is_h5,
                           @"url" : url,
                           @"name" : name,
                           @"show_type" : show_type,
                           @"tid" : tid,
                           };
        }
    }

    [[SUtilityTool shared] jumpControllerWithContent:dictionary target:self];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma 谁都不要删除  add by miao 6.9

-(void)addUserSourceData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (SHARE_COLLOCATION_URL==nil||SHARE_COLLOCATION_URL.length==0)
        {
//            SHARE_PROD_URL=@"";
//            SHARE_COLLOCATION_URL=@"";
            //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSMutableArray *listurl=[[NSMutableArray alloc] initWithCapacity:10];
            //            NSMutableString *msg = [[NSMutableString alloc]init];
            
            //        分享接口说明
            //    http://10.100.20.28:8016/BSParamFilter   查询参数为Code, 返回信息为 Code，paraM_VALUE
            //        参数 Code =COLLOCATION_URL   paraM_VALUE结果值为为搭配分享的地址
            //        参数 Code = SHARE_PROD_URL  paraM_VALUE结果值为商品分享地址
            //        参数 Code = DEFAULT_FEE  paraM_VALUE结果值为 运费
            
            
            // shopping  全部替换为httpRequest
//            [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"BSParamFilter" params:@{@"code":@"SHARE_PROD_URL"} success:^(NSDictionary *dict) {
//                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
//                {
//                    id data = [dict objectForKey:@"results"];
//                    
//                    if ([data isKindOfClass:[NSArray class]])
//                    {
//                        NSDictionary *dic2 = data[0];
//                        SHARE_PROD_URL=[[NSString alloc] initWithFormat:@"%@",dic2[@"paraM_VALUE"] ];
//                    }
//                }
//            } failed:^(NSError *error) {
//                
//            }];
//            [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"BSParamFilter" params:@{@"code":@"COLLOCATION_URL"} success:^(NSDictionary *dict) {
//                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
//                {
//                    id data = [dict objectForKey:@"results"];
//                    
//                    if ([data isKindOfClass:[NSArray class]])
//                    {
//                        NSDictionary *dic2 = data[0];
//                        SHARE_COLLOCATION_URL=[[NSString alloc] initWithFormat:@"%@",dic2[@"paraM_VALUE"] ];
//                    }
//                }
//            } failed:^(NSError *error) {
//                
//            }];
            [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"BSParamFilter" params:@{@"code":@"Default_fee"} success:^(NSDictionary *dict) {
                if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
                {
                    id data = [dict objectForKey:@"results"];
                    
                    if ([data isKindOfClass:[NSArray class]])
                    {
                        NSDictionary *dic2 = data[0];
                        NSString *param_Value = [[NSString alloc] initWithFormat:@"%@",dic2[@"paraM_VALUE"]];
                        DEFAULT_FEE= [param_Value doubleValue];
                        
                    }
                }
            } failed:^(NSError *error) {
                
            }];
            
        }
        //请求收货地址
        [HttpRequest getRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"RegionFilter" params:@{@"type":@"2"} success:^(NSDictionary *dict) {
//            [self writeToFile:dict];
           [self performSelectorInBackground:@selector(writeToFile:) withObject:dict];
            
            
        } failed:^(NSError *error) {
        }];
        
        //12.4 add by miao Filter筛选相关
        [[TMCache sharedCache] removeObjectForKey:focusMemoryFilterDic];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        [Globle shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
        [Globle shareInstance].globleHeight = screenRect.size.height-20;  //屏幕高度（无顶栏）
        [Globle shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（有顶栏）
    });
    
    //获取设备号和系统版本
    [[NSUserDefaults standardUserDefaults] setObject:[[Globle shareInstance] getDeviceModelNameAndSystemVersion] forKey:@"Esb-ClientInfo"];
}
-(void)writeToFile:(NSDictionary *)dict
{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSMutableDictionary *areaDic = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath]mutableCopy];
    NSString *isSuccess = [NSString stringWithFormat:@"%@",dict[@"isSuccess"]];
    NSMutableArray *requestList=[[NSMutableArray alloc]init];
    NSMutableArray *oneArray=[[NSMutableArray alloc]init];//省
    NSMutableArray *twoArray = [[NSMutableArray alloc]init];//市
    NSMutableArray *threearray = [[NSMutableArray alloc]init];//区
    
    NSMutableDictionary *quDic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *shengDic = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *waiDic = [[NSMutableDictionary alloc]init];//最外面一层
    
    if ([isSuccess isEqualToString:@"1"]) {
        requestList = [NSMutableArray arrayWithArray:dict[@"results"]];
        //        id  统一加1了
        //省
        for ( int k=0; k<[requestList count]; k++) {
            NSString *parenT_ID=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
            if([parenT_ID isEqualToString:@"2"])
            {
                [oneArray addObject:requestList[k]];
            }
        }
        //市
        for ( int k =0; k<[requestList count]; k++) {
            NSString *parenT_ID=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
            if([parenT_ID isEqualToString:@"3"])
            {
                [twoArray addObject:requestList[k]];
            }
        }
        //区
        for ( int k =0; k<[requestList count]; k++) {
            NSString *regioN_LEVEL=[NSString stringWithFormat:@"%@",requestList[k][@"regioN_LEVEL"]];
            if([regioN_LEVEL isEqualToString:@"4"])
            {
                [threearray addObject:requestList[k]];
            }
        }
        //分别取出省市区  然欧  区根市相匹配
        /*
         "七台河市" =     (
         "新兴区",
         "桃山区",
         "茄子河区",
         "其它区县",
         "勃利县"
         );
         "万宁市" =     (
         "万宁市"
         );
         "三亚市" =     (
         "三亚市",
         "吉阳区",
         "崖州区",
         "天涯区",
         "海棠区"
         );
         
         */
        for(int k=0;k<[twoArray count];k++)
        {
            NSString *shiID=[NSString stringWithFormat:@"%@",twoArray[k][@"id"]];
            NSMutableArray *quArray=[[NSMutableArray alloc]init];
            
            for (int m=0; m<[threearray count];m++) {
                
                NSString *quID=[NSString stringWithFormat:@"%@",threearray[m][@"parenT_ID"]];
                if ([shiID isEqualToString:quID]) {
                    [quArray addObject:threearray[m][@"name"]];
                }
            }
            [quDic setObject:quArray forKey:[NSString stringWithFormat:@"%@",twoArray[k][@"name"]]];
        }
        //            NSLog(@"QUDIC--区根县匹配-%@",quDic);
        /*
         "云南省" =     {
         0 = "昆明市";
         1 = "曲靖市";
         10 = "保山市";
         11 = "德宏傣族景颇族自治州";
         12 = "丽江市";
         13 = "怒江傈僳族自治州";
         14 = "迪庆藏族自治州";
         15 = "临沧市";
         16 = "其它地区";
         17 = "蒙自市";
         2 = "玉溪市";
         3 = "昭通市";
         4 = "楚雄彝族自治州";
         5 = "红河哈尼族彝族自治州";
         6 = "文山壮族苗族自治州";
         7 = "普洱市";
         8 = "西双版纳傣族自治州";
         9 = "大理白族自治州";
         };
         "北京" =     {
         0 = "北京市";
         };
         "宁夏回族自治区" =     {
         0 = "银川市";
         1 = "石嘴山市";
         2 = "中卫市";
         3 = "吴忠市";
         4 = "固原市";
         5 = "其它地区";
         };
         
         */
        for(int k=0;k<[oneArray count];k++)
        {
            NSString *shiID=[NSString stringWithFormat:@"%@",oneArray[k][@"id"]];
            NSMutableArray *quArray=[[NSMutableArray alloc]init];
            
            for (int m=0; m<[twoArray count];m++) {
                
                NSString *quID=[NSString stringWithFormat:@"%@",twoArray[m][@"parenT_ID"]];
                if ([shiID isEqualToString:quID]) {
                    [quArray addObject:twoArray[m][@"name"]];
                }
            }
            
            
            NSMutableDictionary *keyDic=[[NSMutableDictionary alloc]init];
            
            for ( int j=0; j<[quArray count]; j++) {
                
                NSString *key = [NSString stringWithFormat:@"%d",j];
                NSString *keyName=[NSString stringWithFormat:@"%@",quArray[j]];// 市的名字
                NSArray *jutishiArray =quDic[keyName];
                NSDictionary * kDic = @{keyName:jutishiArray};
                [keyDic setObject:kDic forKey:key];
            }
            
            [shengDic setObject:keyDic forKey:[NSString stringWithFormat:@"%@",oneArray[k][@"name"]]];
            
            //            NSLog(@" -省根市匹配-%@",quArray);
            
        }
        //            NSLog(@"QUDIC--省根市匹配-%@",shengDic);
        
        /*
         ...waitDic...{
         0 = "北京";
         1 = "天津";
         10 = "浙江省";
         11 = "安徽省";
         12 = "福建省";
         13 = "江西省";
         14 = "山东省";
         */
        for (int j=0;j<[oneArray count];j++)
        {
            NSString *shiID=[NSString stringWithFormat:@"%@",oneArray[j][@"id"]];
            int showID=[shiID intValue]-2;
            [waiDic setObject:oneArray[j][@"name"] forKey:[NSString stringWithFormat:@"%d",showID]];
        }
        for (int k=0; k<[[waiDic allKeys] count]; k++) {
            NSString *key = [NSString stringWithFormat:@"%d",k];
            NSString *keyName=[NSString stringWithFormat:@"%@",waiDic[key]];//最外一层的value
            NSDictionary *jutishiDic = shengDic[keyName];
            NSDictionary * kDic = @{keyName:jutishiDic};
            
            [waiDic setObject:kDic forKey:key];
            
        }
        ///****************
        /* waiDic
         10 =     {
         "浙江省" =         {
         0 = "杭州市";
         1 = "宁波市";
         10 = "丽水市";
         11 = "其它地区";
         2 = "温州市";
         3 = "嘉兴市";
         4 = "湖州市";
         5 = "绍兴市";
         6 = "金华市";
         7 = "衢州市";
         8 = "舟山市";
         9 = "台州市";
         };
         };*/
        //            NSLog(@"wai整理后的 －－－－－%@－－-----",waiDic);
        areaDic = [waiDic copy];
        [areaDic writeToFile:plistPath atomically:YES];
        
    }

}
-(BOOL) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    
    NSString *result;
    BOOL isMoreThanThree;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
        isMoreThanThree=NO;
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
        isMoreThanThree=NO;
    }
    else if((temp = temp/60) <24){
        if (temp>2) {
            isMoreThanThree=YES;
        }
        else
        {
            isMoreThanThree=NO;
        }
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
        isMoreThanThree=YES;
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
        isMoreThanThree=YES;
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
        isMoreThanThree=YES;
    }
    //    return  result;
    return isMoreThanThree;
}

@end
