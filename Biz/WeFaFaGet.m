//
//  WeFaFaGet.m
//  Wefafa
//
//  Created by fafa  on 13-6-28.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//  尽力重构下这个类吧
//

#import "WeFaFaGet.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "AppSetting.h"
#import "Utils.h"
#import "MainTabViewController.h"
#import "XMLDictionary.h"
#import "JSON.h"

#define JSON_URL [AppSetting getSNSFaFaDomain]
WeFaFaGet *sns;



static NSString *const SNS_COMEFROM=@"02";

static NSString *const REGISTER_JID_GET = @"/register/jid/get/";
static NSString *const REGISTER_JID_GETBYMOBILE = @"/register/jid/getbymobile/";

static NSString *const API_FILE_GET_PATH=@"/api/baseinfo/getstaffcard";

static NSString *const SNS_LOGIN_PATH=@"/interface/logincheck";
static NSString *const SNS_GETCIRCLES_PATH=@"/interface/baseinfo/getcircles";
static NSString *const SNS_GETGROUPS_PATH=@"/interface/baseinfo/getgroups";
static NSString *const SNS_GETSTAFFCARD_PATH=@"/interface/baseinfo/getstaffcard";
static NSString *const SNS_FILE_GET_PATH=@"/getfile";
static NSString *const SNS_GETIMAGE_ORG_PATH=@"/getfile/image/original";
static NSString *const SNS_GETIMAGE_MDL_PATH=@"/getfile/image/middle";
static NSString *const SNS_GETIMAGE_SML_PATH=@"/getfile/image/small";
static NSString *const SNS_FILE_UPLOAD_PATH=@"/interface/fileupload";
static NSString *const SNS_NEWCONV_TREND_PATH=@"/interface/convinfo/newconv/trend";
static NSString *const SNS_NEWCONV_ASK_PATH=@"/interface/convinfo/newconv/ask";
static NSString *const SNS_NEWCONV_TOGETHER_PATH=@"/interface/convinfo/newconv/together";
static NSString *const SNS_NEWCONV_VOTE_PATH=@"/interface/convinfo/newconv/vote";
static NSString *const SNS_GETCONV_PATH=@"/interface/convinfo/getconvs";
static NSString *const SNS_GETCONV_UNREADNUM_PATH=@"/interface/convinfo/getunreadconvnum";
static NSString *const SNS_GETCONV_ONE_PATH=@"/interface/convinfo/getoneconv";
static NSString *const SNS_GETCONV_UNREAD_PATH=@"/interface/convinfo/getunreadconv";
static NSString *const SNS_GETUSERCONVS_PATH=@"/interface/convinfo/getuserconvs";
static NSString *const SNS_CONVINFO_REPLY_PATH=@"/interface/convinfo/replyconv";
static NSString *const SNS_CONVINFO_VOTE_PATH=@"/interface/convinfo/vote";
static NSString *const SNS_CONVINFO_LIKE_PATH=@"/interface/convinfo/likeconv";
static NSString *const SNS_CONVINFO_UNLIKE_PATH=@"/interface/convinfo/unlikeconv";
static NSString *const SNS_CONVINFO_CONVLIMIT_PATH=@"/interface/convinfo/getconvlimit";
static NSString *const SNS_CONVINFO_COPY_PATH=@"/interface/convinfo/copy";
static NSString *const SNS_CONVINFO_ATTEN_PATH=@"/interface/convinfo/attenconv";
static NSString *const SNS_CONVINFO_UNATTEN_PATH=@"/interface/convinfo/unattenconv";
static NSString *const SNS_CONVINFO_TOGETHER_PATH=@"/interface/convinfo/jointogether";
static NSString *const SNS_CONVINFO_UNTOGETHER_PATH=@"/interface/convinfo/unjointogether";
static NSString *const SNS_CONVINFO_GETREPLY_PATH=@"/interface/convinfo/getreply";

static NSString *const SNS_ATTENSTAFF_PATH=@"/interface/baseinfo/attenstaff";
static NSString *const SNS_CANCELATTENSTAFF_PATH=@"/interface/baseinfo/cancelattenstaff";
static NSString *const SNS_GETATTENSTAFFS_PATH=@"/interface/baseinfo/attenstafflist";

//获取人员粉丝
static NSString *const SNS_GETATTENSTAFFS_PATHFANS=@"/interface/baseinfo/fansstafflist";


static NSString *const SNS_GETATMEUNREADNUM_PATH=@"/interface/convinfo/getatmeunreadnum";
static NSString *const SNS_GETATMECONVS_PATH=@"/interface/convinfo/getatmeconvs";

static NSString *const SNS_BULLETIN_GETUNREADNUM_PATH=@"/interface/bulletin/unreadnum";
static NSString *const SNS_BULLETIN_GETUNREAD_PATH=@"/interface/bulletin/getunread";
static NSString *const SNS_BULLETIN_GET_PATH=@"/interface/bulletin/get";
static NSString *const SNS_BULLETIN_PUSH_PATH=@"/interface/bulletin/push";

static NSString *const SNS_MESSAGE_GETUNREADNUM_PATH=@"/interface/msg/unreadnum";
static NSString *const SNS_MESSAGE_GETUNREAD_PATH=@"/interface/msg/getunread";
static NSString *const SNS_MESSAGE_GET_PATH=@"/interface/msg/get";
static NSString *const SNS_MESSAGE_PUSH_PATH=@"/interface/msg/push";

//zhuce
static NSString *const SNS_REGIST_CHECK_MAIL=@"/interface/mobileregister/checkmail";
//static NSString *const SNS_REGIST_SUBMIT=@"/interface/mobileregister/register"; //用邮箱注册
//static NSString *const SNS_REGIST_ACTIVE=@"/interface/mobileregister/active"; //用邮箱激活

static NSString *const SNS_MOBILE_REGIST_GETVAILDCODE=@"/interface/mobileregister/mobilenumreg";
static NSString *const SNS_REGIST_ACTIVE=@"/interface/mobileregister/mobilenumactive";
static NSString *const SNS_REGIST_GET_ENTERPRISE=@"/interface/mobileregister/getenterprise";
static NSString *const SNS_REGIST_GET_REGISTERINFO=@"/interface/mobileregister/getregisterinfo";

//手机绑定
static NSString *const SNS_MOBILEBIND_GETVAILDCODE=@"/interface/mobilebind/getvaildcode";
static NSString *const SNS_MOBILEBIND_SAVE=@"/interface/mobilebind/save";
static NSString *const SNS_MOBILEBIND_REMOVE=@"/interface/mobilebind/remove";
//手机绑定新接口
static NSString *const SNS_NEW_MOBILEBIND_GETVAILDCODE=@"/interface/baseinfo/getmobilevaildcode";
static NSString *const SNS_NEW_MOBILEBIND_SAVE=@"/interface/baseinfo/savemobilebind";

//找回密码
static NSString *const SNS_FORGET_PASSWD=@"/register/pwd/retrieve/3g";

//错误报告
static NSString *const SNS_ERR_REPORT=@"/api/erreport";

//根据xx获取好友信息
static NSString *const SNS_EMAILTOSTAFFS=@"/interface/emailtostaffs";
static NSString *const SNS_MOBILETOSTAFFS=@"/interface/mobiletostaffs";
static NSString *const SNS_NAMETOSTAFFS=@"/interface/nametostaffs";

//公众号
static NSString *const SNS_MICROACCOUNT_GETATTENLIST=@"/interface/microaccount/getattenlist";
static NSString *const SNS_MICROACCOUNT_GETLIST=@"/interface/microaccount/getlist";
static NSString *const SNS_MICROACCOUNT_QUERY=@"/interface/microaccount/query";
static NSString *const SNS_MICROACCOUNT_ATTEN=@"/interface/microaccount/atten";
static NSString *const SNS_MICROACCOUNT_CANCEL=@"/interface/microaccount/cancel";
static NSString *const SNS_MICROACCOUNT_INVITE=@"/interface/microaccount/invite";
static NSString *const SNS_MICROACCOUNT_AGREEINVITE=@"/interface/microaccount/agreeinvite";
static NSString *const SNS_MICROACCOUNT_REJECTINVITE=@"/interface/microaccount/rejectinvite";

////////////////////
//取得人脉推荐 pageindex ，pagesize
static NSString *const SNS_GET_RECOM_USER = @"/interface/get/recom/user";
//取得圈子推荐 pageindex ，pagesize
static NSString *const SNS_GET_RECOM_CIRCLE = @"/interface/get/recom/circle";
//申请加入圈子 参数 圈子id circleId
static NSString *const SNS_JOIN_CIRCLE = @"/interface/circle/join";
//关注人脉 参数 推荐人员loaginAccount atten_account
static NSString *const SNS_ATTEN_USER = @"/interface/user/atten";
//取得个人标签 account
static NSString *const SNS_GET_PERSONAL_TAG = @"/interface/get/usertag";
//取得圈子活动成员的前五名 circle_id
static NSString *const SNS_GET_CIRCLE_ACTIVITE_USER = @"/interface/circle/top/user";
//取得圈子成员 circleId,pagesize,pageindex
static NSString *const SNS_GET_CIRCLE_MEMBERS = @"/interface/circle/members";
//取圈子分类
static NSString *const SNS_GET_CIRCLE_CLASSES = @"/interface/circle/getcricletype";

///////////////////////
//新建圈子
static NSString *const SNS_CREATE_CIRCLE = @"/interface/circle/createcircle";
//退出圈子
static NSString *const SNS_EXIT_CIRCLE = @"/interface/circle/exitcircle";
//邀请成员加入圈子
static NSString *const SNS_CIRCLE_INVITED_MEMBERS=@"/interface/circle/invitedmemebers";
//修改圈子基本信息
static NSString *const SNS_UPDATE_CIRCLE_INFO = @"/interface/circle/modifycircle";
//修改圈子LOGO
static NSString *const SNS_UPDATE_CIRCLE_LOGO = @"/interface/circle/modifycirclelogo";
//获取圈子邀请成员
static NSString *const SNS_GET_CIRCLE_INVITED_MEMBERS = @"/interface/circle/getcircleinvitestaff";
//取圈子成员
static NSString *const SNS_GET_CIRCLE_STAFF = @"/interface/baseinfo/circlestaff";

///////////////////////
//创建群
static NSString *const SNS_CREATE_GROUP = @"/interface/group/creategroup";
//查群信息
static NSString *const SNS_GET_GROUPINFO = @"/interface/group/getinfo";
//邀请成员加入群
static NSString *const SNS_GROUP_INVITED_MEMBERS = @"/interface/group/invitedmemebers";
//退出群
static NSString *const SNS_EXIT_GROUP = @"/interface/group/exitgroup";
//修改群基本信息
static NSString *const SNS_UPDATE_GROUP_INFO = @"/interface/group/modifygroup";
//修改群LOGO
static NSString *const SNS_UPDATE_GROUP_LOGO = @"/interface/group/modifygrouplogo";
//获取群邀请成员
static NSString *const SNS_GET_GROUP_INVITED_MEMBERS = @"/interface/group/getgroupinvitestaff";

/////////////////////////
//获取企业认证用户列表，无参数
static NSString *const SNS_GET_ENO_AUTH_STAFF = @"/interface/auth/getuser";
//用户认证 参数：recver 选中人员的jid(不带resource)用 ,分割，authren 申请的附言 如：您好，我是您的同事【某某】，请您协助我完成我的身份认证！
static NSString *const SNS_USER_IDENTIFY_SEND_APPLY = @"/interface/identify/send/apply";
//企业认证 参数：fileid，上传证件成功以后得到的file_id
static NSString *const SNS_USER_IDENTIFY_ENO_AUTH = @"/interface/identify/eno/auth";
//圈子搜索
static NSString *const SNS_QUERY_CIRCLE = @"/interface/circle/get";


/////////////////////////
////获取找回密码的验证码
//static NSString *const SNS_GET_PASSWORD_VALIDCODE=@"/interface/findpwd";
//重置密码
//static NSString *const SNS_RESET_PASSWORD=@"/interface/resetpwd";

//MB获取找回密码的验证码(美邦)
static NSString *const SNS_GET_PASSWORD_VALIDCODE=@"/api/http/getcode";

//MB重置密码美邦)
static NSString *const SNS_RESET_PASSWORD=@"/api/http/findpassword";
//修改密码
static NSString *const SNS_MODIFY_PASSWORD=@"/interface/baseinfo/updatepassword";


/////////////////////////

static NSString *const SNS_GET_MEETING_INFO=@"/interface/meetingplan/getplanbygroupid";

static NSString *const SNS_UPLOAD_MY_HEAD_PHOTO=@"/interface/baseinfo/modifyavatar";
static NSString *const SNS_UPDATE_MY_INFO=@"/interface/baseinfo/modifystaffinfo";
static NSString *const SNS_GET_DEPTS=@"/interface/baseinfo/getdepts";

//sso
static NSString *const SNS_SSO_BIND = @"/api/http/sso/bind";
static NSString *const SNS_SSO_UNBIND = @"/api/http/sso/unbind";
static NSString *const SNS_SSO_GETAUTH = @"/api/http/sso/getauth";

////////////////////////////////////////////////////////////////////////
//美邦新增接口
static NSString *const SNS_SEARCH_STAFFS=@"/interface/baseinfo/searchstaffs";
//获取关注设计师
static NSString *const SNS_GET_ATTEN_DESIGNER = @"/interface/baseinfo/attenstafflist";

//微信帐号登录SNS服务器
static NSString *const SNS_WEIXIN_LOGIN = @"/api/http/thirdparty/weixinlogin";
//QQ帐号登录SNS服务器
static NSString *const SNS_QQ_LOGIN = @"/api/http/thirdparty/tencentlogin";
static NSString *const SNS_SEND_SNSSHARE = @"/interface/app/sendsharemsg";

//上传图片
static NSString *const SEND_FILE = @"/interface/sendfile";
static NSString *const RECEIVE_FILE = @"/api/getfile";

static NSString *const GET_STAFF_JID = @"/interface/get/staff/attrs";



@implementation JSonPost
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
}

- (NSString *)ASIPostJSonRequest:(NSString *)subpath PostParam:(NSDictionary *)dict
{
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@",JSON_URL,subpath];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
//     NSString *urlString = [JSON_URL stringByAppendingPathComponent:subpath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        
        [request setPostValue:value forKey:key];
    }
    
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *result;
    if (!error) {
        result = [[NSString alloc] initWithFormat:@"%@",[request responseString]];
    }
    else
    {
        NSLog(@"%@",error);
        result = @"";
    }
    
    return result;
}

- (BOOL)ASIPostJSonRequestURL:(NSString *)urlString PostParam:(NSDictionary *)dict result:(NSMutableString *)result
{
    BOOL r1=NO;
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        
        [request setPostValue:value forKey:key];
    }
    
    //    [request setDelegate:self];
    //    [request startAsynchronous];
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        r1=YES;
        [result setString:[request responseString]];
    }
    else
    {
        NSLog(@"%@",error);
        [result setString:@"0001"];
    }
    
    return r1;
}
-(NSString *)ASIPostImgJSonRequest:(NSString *)subpath PostImgParam:(NSDictionary *)dict WithPicFileName:(NSString *)picfileName;

{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",JSON_URL,subpath];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    request.delegate =self;
    request.requestMethod = @"POST";//设置请求方式
    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        
        [request setPostValue:value forKey:key];
    }
    
    [request setPostValue:@"file" forKey:@"userfile"];
    
//    [request setFile:picfileName forKey:@"filename"];
    [request buildPostBody];
    
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *result;
    if (!error) {
        result = [[NSString alloc] initWithFormat:@"%@",[request responseString]];
    }
    else
    {
        NSLog(@"%@",error);
        result = @"";
    }
    
    return result;
 
}

-(NSString *)ASIPostJSonRequest:(NSString *)subpath PostParam:(NSDictionary *)dict FileData:(NSData *)fileData FileName:(NSString *)fileName {
    
    NSString *urlString =[NSString stringWithFormat:@"%@%@",JSON_URL,subpath];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    request.delegate =self;
    request.requestMethod = @"POST";//设置请求方式
    request.timeOutSeconds=30.0f;
    
    [request addData:fileData withFileName:[NSString stringWithFormat:@"%d.png",arc4random()] andContentType:@"image/png" forKey:fileName];
    
    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        
        [request setPostValue:value forKey:key];
    }
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *result;
    if (!error) {
        result = [[NSString alloc] initWithFormat:@"%@",[request responseString]];
    }
    else
    {
        NSLog(@"%@",error);
        result = @"";
    }
    
    return result;
}

- (NSData *)ASIPostJSonRequest:(NSString *)subpath FileName:(NSString *)filename
{
    NSString *urlString =@"";
    if([filename hasPrefix:@"http://"]||[filename hasPrefix:@"https://"])
    {
        urlString = filename;
    }
    else
    {
        urlString =[NSString stringWithFormat:@"%@%@/%@",JSON_URL,subpath,filename];
    }

    NSURL *url = [NSURL URLWithString:urlString];

    ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:url];
    
    //    [request setDelegate:self];
    //    [request startAsynchronous];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSData *result;
    if (!error) {
        result = [request responseData];
    }
    else
        result = [[NSData alloc] init];
    
    return result;
}

@end

NSCondition *download_lock;

@implementation WeFaFaGet

@synthesize jid;
@synthesize password;
@synthesize shareOrLogin;

- (id)init
{
    self = [super init];
    if (self) {
        if (download_lock==nil)
            download_lock=[[NSCondition alloc] init];
        _myStaffCard=[[SNSStaffFull alloc] init];
        _myStaffCard.nick_name=[[NSString alloc] initWithFormat:@""];
        _isLogin=NO;
    }
    return self;
}


-(void) DownloadFile_Asyn:(NSString *)fileID FileExt:(NSString *)fileExt CachePath:(NSString *)cachePath imagesize:(IMAGE_SIZE)imagesize ImageCallback:(void (^)(UIImage * image))imageBlock ErrorCallback:(void (^)(void))errorBlock
{
    if ([fileID isEqualToString:@""]==YES)
    {
        return;
    }
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       [download_lock lock];
                       NSString *filepath;
                       
                       NSString *real_fileID = fileID;
                       if (imagesize != SNS_IMAGE_ORIGINAL)
                       {
                           real_fileID = [NSString stringWithFormat:@"%@_%d", fileID, imagesize];
                       }
                       
                       if ([fileExt isEqualToString:@""])
                           filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSAttachFilePath], real_fileID];
                       else
                           filepath = [NSString stringWithFormat:@"%@/%@.%@", [AppSetting getSNSAttachFilePath], real_fileID, fileExt];
                       
                       UIImage *image=nil;
                       if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
                       {
                           image = [[UIImage alloc] initWithContentsOfFile:filepath];
                       }
                       else
                       {
                           //缓存图片数据
                           NSData *filedata = [sns getImage:imagesize ImageName:fileID];
                           if (filedata!=nil)
                           {
                               [filedata writeToFile: filepath atomically: NO];
                           }
                           
                           image = [[UIImage alloc] initWithData:filedata];
                       }
                       
                       
                       //                       NSString *filename=[[URL absoluteString] lastPathComponent];
                       //                       NSString *filepath=[NSString stringWithFormat:@"%@/%@",cachePath,filename];
                       //                       UIImage *image=nil;
                       //                       if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
                       //                       {
                       //                           image = [[UIImage alloc] initWithContentsOfFile:filepath];
                       //                       }
                       //                       else
                       //                       {
                       //                           //下载缓存图片
                       //                           [WeFaFaGet getFile:attach.attach_id FileName:attach.file_name FileExt:attach.file_ext imagesize:SNS_IMAGE_SMALL];
                       //                           NSData * filedata = [[NSData alloc] initWithContentsOfURL:URL] ;
                       //                           image = [[UIImage alloc] initWithData:filedata];
                       //                           if (filedata!=nil)
                       //                               [filedata writeToFile: filepath atomically: NO];
                       //                       }
                       
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                       [download_lock unlock];
                   });
}

-(NSMutableDictionary*)getJSON:(NSString *)subpath PostParam:(NSDictionary *)dict
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:1];
    @try
    {
        NSString *rst = nil;
        
        rst = [self ASIPostJSonRequest:subpath PostParam:dict];
        if (rst.length == 0) return result;        
        [result addEntriesFromDictionary:[rst objectFromJSONString]];
        if (![SNS_RETURN_NO_LOGIN isEqualToString:result[@"returncode"]]) return result;
        
        //auto login once
        SNSStaffFull *mySelfStaffInfo=[[SNSStaffFull alloc] init];
        NSMutableArray *rosterList=[[NSMutableArray alloc] init];
        rst= [sns snsLogin:[AppSetting getUserID] Password:[AppSetting getPassword] mySelfStaffInfo:mySelfStaffInfo rosterList:rosterList];
        if (![SNS_RETURN_SUCCESS isEqualToString:rst]) return result;
        
        rst=[self ASIPostJSonRequest:subpath PostParam:dict];
        if (rst.length == 0) return result;        
        [result addEntriesFromDictionary:[rst objectFromJSONString]];        
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@, path: %@, para: %@", __FUNCTION__, [ exception name ], [ exception reason ], subpath, dict);
    }
    return result;
}

-(NSString *)getJID:(NSString *)loginaccount
{
    NSString *urlString =[NSString
                          stringWithFormat: @"%@%@%@",
                          JSON_URL,
                          ([loginaccount rangeOfString:@"@"].location != NSNotFound ? REGISTER_JID_GET : REGISTER_JID_GETBYMOBILE),
                          loginaccount];
    
    NSString *rst=[NSString stringWithFormat:@""];
    NSString *result=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    
    if (result!=nil && [result length]>1 && (NSNull *)result!=[NSNull null])
    {
        rst=[NSString stringWithFormat:@"%@",result];
    }
    return rst;
}

-(NSString *)snsLogin:(NSString *)account Password:(NSString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList
{
    NSString* result=nil;
    @try {
        NSString *portalVersion=[MainTabViewController getPortalLocalVersion];
        portalVersion=@"";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"login_account",pwd,@"password", SNS_COMEFROM,@"comefrom", @"all",@"datascope", portalVersion, @"portalversion",nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_LOGIN_PATH PostParam:dict];
        
#ifdef DEBUG
        NSLog(@"%s %@", __FUNCTION__, rst);
#endif
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSLog(@"%@",resultString);
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
//            _openid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"openid"]];
            _openid = [NSString stringWithFormat:@"%@",resultString[@"openid"]];
//            _ldap_uid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"ldap_uid"]];
            _ldap_uid = [NSString stringWithFormat:@"%@",resultString[@"ldap_uid"]];
            if ([[resultString  allKeys]containsObject:@"jid"])
            {
                self.jid=[NSString stringWithFormat:@"%@",resultString[@"jid"]];
                self.password=[NSString stringWithFormat:@"%@",resultString[@"des"]];
            }
            
            /////
            if (resultString[@"portalconfig_xml"]!=nil||resultString[@"portalconfig_version"]!=nil)//![[resultString objectForKey:@"portalconfig_version"] isEqualToString:portalVersion])
            {
                [MainTabViewController savePortalLocalVersion:[resultString objectForKey:@"portalconfig_version"]];
                
                NSData* xmlData = [resultString[@"portalconfig_xml"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *xmlDic = [NSDictionary dictionaryWithXMLData:xmlData];//[Utils filterJSONString:resultString[@"portalconfig_xml"]]];
                [MainTabViewController savePortalConfigLocalData:xmlDic];
            }
            
            if (resultString[@"info"]!=nil)
            {
                [mySelfStaffInfo setJSONValue:resultString[@"info"]];
                [_myStaffCard setJSONValue:resultString[@"info"]];
            }
            
            if (resultString[@"rosters"]!=nil)
            {
                for (NSDictionary *staffDict in resultString[@"rosters"])
                {
                    SNSStaffFull *staff = [[SNSStaffFull alloc] init];
                    [staff setJSONValue:staffDict];
                    [rosterList addObject:staff];
                }
            }
            if (resultString[@"imserver"]!=nil)
            {
                NSString *imserverStr = [NSString stringWithFormat:@"%@",resultString[@"imserver"]];
                
                NSArray *imserverArray = [imserverStr componentsSeparatedByString:@":"];
                //    rst = YES;
                if ([imserverArray objectAtIndex:0]==nil||[imserverArray objectAtIndex:1]==nil) {
                }
                else
                {
                    [AppSetting setIMServer:[imserverArray objectAtIndex:0]];
                    [AppSetting setIMServerPort:[[imserverArray objectAtIndex:1]intValue]];
                }

            }
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)getCircles:(NSMutableArray *)circles
{
    NSString* result=nil;
    @try {
        NSDictionary *dicResult = [self getJSON:SNS_GETCIRCLES_PATH PostParam:nil];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *circleArray=[dicResult objectForKey:@"circles"];
            for (NSDictionary *circle in circleArray) {
                SNSCircle *snscircle=[[SNSCircle alloc] init];
                
                [snscircle setJSONValue:circle];
                
                if ([snscircle.enterprise_no isEqualToString:@""]==NO)
                {
                    [circles insertObject:snscircle atIndex:0];
                }
                else {
                    [circles addObject:snscircle];
                }
                
            }
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//创建圈子
-(NSArray *)createCircle:(NSString *)circleName CircleDesc:(NSString *)circleDesc JoinMethod:(NSString *)joinMethod AllowCopy:(NSString *)allowCopy CircleClassid:(NSString *)circleClassId LogoPath:(NSString *)logoPath LogoPathSmall:(NSString *)logoPathSmall LogoPathBig:(NSString *)logoPathBig returnMsg:(NSMutableString *)returnMsg{
    NSArray* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              circleName,@"circle_name",
                              circleDesc,@"circle_desc",
                              joinMethod,@"join_method",
                              allowCopy,@"allow_copy",
                              circleClassId,@"circle_class_id",
                              logoPath,@"logo_path",
                              logoPathSmall,@"logo_path_small",
                              logoPathBig,@"logo_path_big", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_CREATE_CIRCLE PostParam:dict];
        
        NSString *resultCode = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([resultCode isEqualToString:SNS_RETURN_SUCCESS])
        {
            result= dicResult[@"circle"];
        }else if(dicResult[@"error"]!=nil){
            [returnMsg setString:dicResult[@"error"]];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}

-(NSDictionary *)getGroupInfo:(NSString *)groupId{
    
    NSDictionary *resultDic = [[NSDictionary alloc]init];
    NSDictionary *dicResult=[self getJSON:SNS_GET_GROUPINFO PostParam:@{@"groupId":groupId}];
    NSArray *dataArr = dicResult[@"row"];
    resultDic = dataArr[0];
    return resultDic;
}

//邀请成员加入圈子
- (NSString *)inviteCircleMember:(NSString *)circleid InvitedMemebers:(NSString *)invitedmemebers {
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              circleid,@"circle_id",
                              invitedmemebers,@"invitedmemebers", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_CIRCLE_INVITED_MEMBERS PostParam:dict];
        
        result = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}
//获取圈子分类
-(NSString *)getCircleClasses:(NSMutableArray *)circleclasss {
    NSString *result=nil;
    @try {
        NSDictionary *dicResult = [self getJSON:SNS_GET_CIRCLE_CLASSES PostParam:nil];
        
        result = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *circleClassArray=[NSArray arrayWithArray:dicResult[@"circle_types"]];
            for (NSDictionary *circleClass in circleClassArray) {
                SNSCircleClass *snscircleclass=[[SNSCircleClass alloc] init];
                
                [snscircleclass setJSONValue:circleClass];
                
                if (![snscircleclass.classify_id isEqualToString:@""])
                {
                    [circleclasss addObject:snscircleclass];
                }
            }
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}
-(NSArray *)getCircleStaff:(NSString *)circleid {
    NSArray *result=nil;
    @try {
        NSDictionary *dicResult = [self getJSON:SNS_GET_CIRCLE_STAFF PostParam:@{@"circle_id":circleid}];
        
        NSString *success = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([success isEqualToString:SNS_RETURN_SUCCESS])
        {
            result=[NSArray arrayWithArray:dicResult[@"staffs"]];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}
-(NSString *)updateCircle:(SNSCircle *)snsCircle Circle:(SNSCircle *)circle{
    NSString *result=nil;
    @try {
        NSDictionary *dicResult = [self getJSON:SNS_UPDATE_CIRCLE_INFO PostParam:@{@"circle_id":snsCircle.circle_id,
                                                                                   @"circle_name":snsCircle.circle_name,
                                                                                   @"circle_desc":snsCircle.circle_desc,
                                                                                   @"join_method":snsCircle.join_method,
                                                                                   @"allow_copy":snsCircle.allow_copy,
                                                                                   @"circle_class_id":snsCircle.circle_class_id}];
        result = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            [circle setJSONValue:dicResult[@"circle"]];
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}
//退出圈子
-(NSString *)exitCircle:(NSString *)jid Circleid:(NSString *)circleid {
    NSString *result=nil;

    @try {
        NSDictionary *dicResult = [self getJSON:SNS_EXIT_CIRCLE PostParam:@{@"fafa_jid":jid,@"circle_id":circleid}];
        
        result = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}

//创建群
-(SNSGroup *)createGroup:(NSString *)circleid GroupName:(NSString *)groupname GroupDesc:(NSString *)groupdesc JoinMethod:(NSString *)joinMethod GroupClassid:(NSString *)groupclassid GroupPhotoPath:(NSString *)groupphotopath returnMsg:(NSMutableString *)returnMsg{
    SNSGroup *result=nil;
    @try {
        NSDictionary *dicResult=[self getJSON:SNS_CREATE_GROUP PostParam:@{@"circle_id": circleid,@"group_name":groupname,@"group_desc":groupdesc,@"join_method":joinMethod,@"group_class_id":groupclassid,@"group_photo_path":groupphotopath}];
        
        NSString *success = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([success isEqualToString:SNS_RETURN_SUCCESS])
        {
            if (dicResult[@"group"]!=nil) {
                NSArray *group=dicResult[@"group"];
                result=[[SNSGroup alloc] init];
                result.group_id=[group valueForKey:@"group_id"];
                result.circle_id=[group valueForKey:@"circle_id"];
                result.group_name=[group valueForKey:@"group_name"];
                result.group_desc=[group valueForKey:@"group_desc"];
                result.group_photo_path=[group valueForKey:@"group_photo_path"];
                result.join_method=[group valueForKey:@"join_method"];
                result.create_staff=[group valueForKey:@"create_staff"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                NSDate *createDate= [dateFormatter dateFromString:[group valueForKey:@"create_date"]];
                result.create_date=createDate;
                result.fafa_groupid=[group valueForKey:@"fafa_groupid"];
            }
        }else if(dicResult[@"error"]!=nil){
            [returnMsg setString:dicResult[@"error"]];
        }
    }
    @catch (NSException *exception) {
    }
    
    return result;
}
//邀请成员加入群
-(NSString *)inviteGroupMember:(NSString *)circleid Groupid:(NSString *)groupid GroupName:(NSString *)groupname FafaGroupid:(NSString *)fafagroupid InvitedMemebers:(NSString *)invitedmemebers {
    NSString *result=nil;
    @try {
        NSDictionary *dicResult=[self getJSON:SNS_GROUP_INVITED_MEMBERS PostParam:@{@"circle_id":circleid,@"group_id":groupid,@"group_name":groupname,@"fafa_groupid":fafagroupid,@"invitedmemebers":invitedmemebers}];

        result = [NSString stringWithFormat:@"%@",dicResult[@"returncode"]];
    }
    @catch (NSException *exception) {
    }
    return result;
}
//退出群
-(NSString *)exitGroup:(NSString *)jid Circleid:(NSString *)circleid Groupid:(NSString *)groupid {
    NSString *result=nil;
    @try {
        NSDictionary *dicResult=[self getJSON:SNS_EXIT_GROUP PostParam:@{@"circle_id":circleid,@"group_id":groupid}];
        
       NSString *success = [[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if (![success isEqualToString:SNS_RETURN_SUCCESS])
        {
            result=[NSString stringWithFormat:@"%@",dicResult[@"msg"]];
        }
    }
    @catch (NSException *exception) {
    }
    return result;
}


-(NSString *)getGroupsByCircleID:(NSString *)circleid Groups:(NSMutableArray *)groups
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GETGROUPS_PATH PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *groupArray=[dicResult objectForKey:@"groups"];
            for (NSDictionary *group_dict in groupArray) {
                SNSGroup *snsgroup=[[SNSGroup alloc] init];
                snsgroup.circle_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"circle_id"]] ];
                snsgroup.group_id=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"group_id"]] ];
                snsgroup.group_name=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"group_name"]] ];
                snsgroup.group_desc=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"group_desc"]] ];
                snsgroup.group_photo_path=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"group_photo_path"]] ];
                snsgroup.join_method=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"join_method"]] ];
                snsgroup.create_staff=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"create_staff"]] ];
                snsgroup.create_date=[NSDate parse:[Utils getSNSString:group_dict[@"create_date"]] ];
                snsgroup.fafa_groupid=[[NSString alloc] initWithFormat:@"%@",[Utils getSNSString:group_dict[@"fafa_groupid"]] ];
                [groups addObject:snsgroup];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}


//circle_id	圈子编号
//group_id	群组编号，可空。非空取发给特定群组的信息，空则取发给该圈子全体人员的信息
//last_end_id	上次取得最后一条信息的ID，为空则从最新的开始取
-(NSString *)getConvsByCircleID:(NSString *)circleid Groups:(NSString *)groupid LastID:(NSString *)lastid Convs:(NSMutableArray *)convs
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id",groupid,@"group_id",lastid,@"last_end_id", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GETCONV_PATH PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *convArray=[dicResult objectForKey:@"convs"];
            for (NSDictionary *conv in convArray) {
                SNSConv *snsconv=[[SNSConv alloc] init];
                [snsconv setJSONValue:conv];
                snsconv.circle_id = circleid;
                [convs addObject:snsconv];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}
-(NSArray*)getUnreadConvs:(NSString*)circle_id group_id:(NSString*)group_id max_id:(NSString*)max_id
{
    NSString* result=nil;
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:15];
    @try
    {
        NSDictionary *para =  @{@"circle_id":circle_id, @"group_id":group_id, @"max_id":max_id};
        NSDictionary *dicResult = [self getJSON:SNS_GETCONV_UNREAD_PATH PostParam:para];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            for (NSDictionary *conv in dicResult[@"convs"]) {
                SNSConv *snsconv=[[SNSConv alloc] init];
                [snsconv setJSONValue:conv];
                snsconv.circle_id = circle_id;
                [re addObject:snsconv];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}

-(NSString *)getConvsByConvID:(NSString*)convid Conv:(SNSConv**)conv
{
    NSString *result=nil;
    @try
    {
        NSDictionary *para =  @{@"conv_id":convid};
        NSString *rst=[self ASIPostJSonRequest:SNS_GETCONV_ONE_PATH PostParam:para];
        if ([rst length]>0)
        {
            NSDictionary * dicResult = [rst objectFromJSONString];
            
            
            
            result=dicResult[@"returncode"];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[dicResult objectForKey:@"conv"];
                [*conv setJSONValue:conv_dict];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSArray*)getReplys:(NSString*)conv_id pageindex:(NSNumber*)pageindex
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:15];
    @try
    {
        NSDictionary *para =  @{@"conv_id":conv_id, @"pageindex":pageindex};
        NSString *rst=[self ASIPostJSonRequest:SNS_CONVINFO_GETREPLY_PATH PostParam:para];
        if ([rst length]>0)
        {
            NSDictionary * dicResult = [rst objectFromJSONString];
            if ([SNS_RETURN_SUCCESS isEqualToString:dicResult[@"returncode"]])
            {
                for (NSDictionary *reply in dicResult[@"replys"]) {
                    SNSReply *snsreply=[[SNSReply alloc] init];
                    [snsreply setJSONValue:reply];
                    [re addObject:snsreply];
                }
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}
//返回上传头像的url地址 适应新版本
- (NSString *)getHeadImgUrlWithImageName:(NSString *)imgName WithSize:(IMAGE_SIZE)imagesize;
{
    NSString *urlString =@"";
    NSString *sns_urlpath=SNS_GETIMAGE_ORG_PATH;
    if([imgName hasPrefix:@"http://"]||[imgName hasPrefix:@"https://"])
    {
        urlString = imgName;
    }
    else
    {
        switch (imagesize) {
            case SNS_IMAGE_ORIGINAL:
                sns_urlpath=SNS_GETIMAGE_ORG_PATH;
                break;
            case SNS_IMAGE_MIDDLE:
                sns_urlpath=SNS_GETIMAGE_MDL_PATH;
                break;
            case SNS_IMAGE_SMALL:
                sns_urlpath=SNS_GETIMAGE_SML_PATH;
                break;
                
            default:
                break;
        }
        urlString =[NSString stringWithFormat:@"%@%@/%@",JSON_URL,sns_urlpath,imgName];
    }
    return urlString;
    
}
-(NSData *)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName
{
    NSData *imgdata=nil;
    @try {
        NSString *sns_urlpath;
        switch (imagesize) {
            case SNS_IMAGE_ORIGINAL:
                sns_urlpath=SNS_GETIMAGE_ORG_PATH;
                break;
            case SNS_IMAGE_MIDDLE:
                sns_urlpath=SNS_GETIMAGE_MDL_PATH;
                break;
            case SNS_IMAGE_SMALL:
                sns_urlpath=SNS_GETIMAGE_SML_PATH;
                break;
                
            default:
                break;
        }
        NSData *rst=[self ASIPostJSonRequest:sns_urlpath FileName:imgName];
        if ([rst length]>0)
        {
            imgdata=rst;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s Exception Name: %@, Reason: %@, imgName: %@", __FUNCTION__, [ exception name ], [ exception reason ], imgName);
    }
    
    return imgdata;
}

//-(void)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName CellView:(UITableViewCell*)cellView JID:(NSString *)jid IsGrey:(BOOL)isgrey Delegate:(id)dg
//{
//    NSData *imgdata=nil;
//    @try {
//        //        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id",groupid,@"group_id",lastid,@"last_end_id", nil];
//        NSString *sns_urlpath;
//        switch (imagesize) {
//            case SNS_IMAGE_ORIGINAL:
//                sns_urlpath=SNS_GETIMAGE_ORG_PATH;
//                break;
//            case SNS_IMAGE_MIDDLE:
//                sns_urlpath=SNS_GETIMAGE_MDL_PATH;
//                break;
//            case SNS_IMAGE_SMALL:
//                sns_urlpath=SNS_GETIMAGE_SML_PATH;
//                break;
//                
//            default:
//                break;
//        }
//        NSString *str_grey=[NSString stringWithFormat:@"%d",isgrey];
//        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:cellView,@"cellview",jid,@"userjid",str_grey,@"isgrey",nil];
//        [self ASIPostJSonRequestAsyn:sns_urlpath FileName:imgName Param:dict Delegate:dg];
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//}
//
//-(NSData *)getFile:(NSString *)fileID
//{
//    NSData *imgdata=nil;
//    @try {
//        
//        NSData *rst=[self ASIPostJSonRequest:SNS_FILE_GET_PATH FileName:fileID];
//        if ([rst length]>0)
//        {
//            imgdata=rst;
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    return imgdata;
//}


//filename	文件名
//filedata	文件内容，BASE64格式
//NSString *filedata=[SNSCommObject base64Encode:filename];
//circle_id	圈子编号
//group_id	群组编号。发给该圈子全体人员的填写ALL，其它填写发给特定群组的ID。
-(NSString *)uploadFile:(NSString *)filename FileDataBase64:(NSString *)filedata CircleID:(NSString *)circleid GroupID:(NSString *)groupid FileID:(NSMutableString *)fileID
{
    NSString* result=nil;
    @try {
        if (groupid==nil || (groupid!=nil && [groupid isEqualToString:@""]))
        {
            groupid=[NSString stringWithFormat:@"ALL"];
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:filename,@"filename",filedata,@"filedata",circleid,@"circle_id",groupid,@"group_id", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_FILE_UPLOAD_PATH PostParam:dict];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            
            NSString *returncode=[resultString objectForKey:@"returncode"];
            
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                [fileID setString:[resultString objectForKey:@"file_id"]];
            }
        }
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}
//
//
//-(NSString *)getJID:(NSString *)loginaccount
//{
//    NSString *urlString =[NSString
//                          stringWithFormat: @"%@%@%@",
//                          JSON_URL,
//                          ([loginaccount rangeOfString:@"@"].location != NSNotFound ? REGISTER_JID_GET : REGISTER_JID_GETBYMOBILE),
//                          loginaccount];
//    
//    NSString *rst=[NSString stringWithFormat:@""];
//    NSString *result=[NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
//    
//    if (result!=nil && [result length]>1 && (NSNull *)result!=[NSNull null])
//    {
//        rst=[NSString stringWithFormat:@"%@",result];
//    }
//    return rst;
//}
//
////客户端用
//-(NSString *)getAPIStaffCard:(NSString *)staffid StaffCard:(SNSStaffFull **)staff_full
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffid,@"staff", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:API_FILE_GET_PATH PostParam:dict];
//        
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSDictionary *dicstaff=[resultString objectForKey:@"staff_full"];
//                //[*staff_full initWithDictionary:staff_dict];
//                SNSStaffFull *staff = *staff_full;
//                staff.login_account = [NSString stringWithFormat:@"%@", dicstaff[@"login_account"]];
//                staff.nick_name = [NSString stringWithFormat:@"%@", dicstaff[@"nick_name"]];
//                staff.photo_path = [Utils getSNSString: dicstaff[@"photo_path"]];
//                staff.photo_path_small = [Utils getSNSString: dicstaff[@"photo_path_small"]];
//                staff.photo_path_big = [Utils getSNSString: dicstaff[@"photo_path_big"]];
//                staff.dept_id = [NSString stringWithFormat:@"%@", dicstaff[@"dept_id"]];
//                staff.dept_name = [Utils getSNSString: dicstaff[@"dept_name"]];
//                staff.eno = [NSString stringWithFormat:@"%@", dicstaff[@"eno"]];
//                staff.ename = [NSString stringWithFormat:@"%@", dicstaff[@"ename"]];
//                staff.eshortname = [NSString stringWithFormat:@"%@", dicstaff[@"eshortname"]];
//                staff.self_desc = [Utils getSNSString: dicstaff[@"self_desc"]];
//                staff.duty = [Utils getSNSString:dicstaff[@"duty"]];
//                staff.birthday = [NSDate parse:[Utils getSNSString:dicstaff[@"birthday"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
//                staff.specialty = [Utils getSNSString: dicstaff[@"specialty"]];
//                staff.hobby = [Utils getSNSString:dicstaff[@"hobby"]];
//                staff.work_phone = [Utils getSNSString: dicstaff[@"work_phone"]];
//                staff.mobile = [Utils getSNSString:dicstaff[@"mobile"]];
//                staff.mobile_is_bind = [NSString stringWithFormat:@"%@", dicstaff[@"mobile_is_bind"]];
//                staff.total_point = [[NSString stringWithFormat:@"%@", dicstaff[@"total_point"]] doubleValue];
//                staff.register_date = [NSDate parse:[Utils getSNSString: dicstaff[@"register_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
//                staff.active_date = [NSDate parse:[Utils getSNSString: dicstaff[@"active_date"]] defaultvalue:[NSDate dateWithTimeIntervalSince1970:0]];
//                staff.attenstaff_num = [[NSString stringWithFormat:@"%@", dicstaff[@"attenstaff_num"]] intValue];
//                staff.fans_num = [[NSString stringWithFormat:@"%@", dicstaff[@"fans_num"]] intValue];
//                staff.publish_num = [[NSString stringWithFormat:@"%@", dicstaff[@"publish_num"]] intValue];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}

-(NSString *)getStaffCard:(NSString *)staffid StaffCard:(SNSStaffFull **)staff_full
{
    if (staffid == nil) return nil;
    
    NSString* result=nil;
    //JID 为大写
    NSMutableString *staffMutableId=[NSMutableString stringWithFormat:@"%@",staffid];
    NSArray *compareAr = [staffMutableId componentsSeparatedByString:@"@"];
    NSString *showFirst=[compareAr firstObject];
    NSString *upperCaseString = [showFirst uppercaseString];
    NSString *staffId=[NSString stringWithFormat:@"%@@%@",upperCaseString,[compareAr lastObject]];
    
    
    NSDictionary *dict = @{@"staff":staffId};
    NSDictionary *dicResult = [self getJSON:SNS_GETSTAFFCARD_PATH PostParam:dict];
    
    result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
    if ([result isEqualToString:SNS_RETURN_SUCCESS])
    {
//        NSDictionary *dicstaff = dicResult[@"staff_full"];
        
        SNSStaffFull *staff = *staff_full;
        [staff setJSONValue:dicResult[@"staff_full"]];
    }
    else
    {
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    }
    
    return result;
}
//
//-(void)getStaffCardAsyn:(NSString *)staffid Param:(id)userparam Delegate:(id)dg
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffid,@"staff", nil];
//        
//        NSDictionary *dict_para=[NSDictionary dictionaryWithObjectsAndKeys:@"GETSTAFFFULL",@"type",dg,@"delegate",userparam,@"userparam", nil];
//        [self ASIPostJSonRequestAsyn:SNS_GETSTAFFCARD_PATH PostParam:dict Param:dict_para Delegate:self];
//    }
//    @catch (NSException *exception) {
//    }
//}
////////////////////////////////////异步委托
//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    id delegate=[request.userInfo objectForKey:@"delegate"]; //回掉对象
//    SEL method=(SEL)[request.userInfo objectForKey:@"method"]; //回掉方法
//    NSArray *userparam=[request.userInfo objectForKey:@"userparam"];
//    NSString *type=[request.userInfo objectForKey:@"type"];
//    
//    
//    NSString *result=nil;
//    NSString * rst=[request responseString];
//    if ([rst length]>0)
//    {
//        NSDictionary *resultString = [rst objectFromJSONString];
//        NSString *returncode=[resultString objectForKey:@"returncode"];
//        result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS])
//        {
//            if ([type isEqualToString:@"GETSTAFFFULL"])
//            {
//                NSDictionary *staff_dict=[resultString objectForKey:@"staff_full"];
//                SNSStaffFull *staff_full=[[[SNSStaffFull alloc] initWithDictionary:staff_dict] autorelease];
//                //if ((NSNull *)logo_path_small!=[NSNull null])
//                //                NSLog(@">>>>getStaffCard nick_name=%@,ename=%@",((SNSStaffFull*)*staff_full).nick_name,((SNSStaffFull*)*staff_full).ename);
//                //参数 staff,  fillview_id
//                [delegate performSelector:method withObject:staff_full withObject:userparam];
//            }
//        }
//    }
//}

-(NSString *)setAttenStaff:(NSString *)staffID IsAtten:(BOOL)isAtten returnMsg:(NSMutableString *)returnMsg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffID,@"staff", nil];
        
        NSDictionary *dicResult = nil;
        if (isAtten==YES)
        {
            dicResult = [self getJSON:SNS_ATTENSTAFF_PATH PostParam:dict];
        }
        else
        {
            dicResult = [self getJSON:SNS_CANCELATTENSTAFF_PATH PostParam:dict];
        }
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
        }
        else [returnMsg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)getAttenStaffs:(NSString *)staffID Staffs:(NSMutableArray *)staffs
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffID,@"staff", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GETATTENSTAFFS_PATH PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *staffArray=[dicResult objectForKey:@"staffs"];
            for (NSDictionary *staff_dict in staffArray) {
                SNSStaff *snsstaff=[[SNSStaff alloc] init];
                [snsstaff setJSONValue:staff_dict];
                [staffs addObject:snsstaff];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)getAttenStaffsFans:(NSString *)staffID Staffs:(NSMutableArray *)staffs
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffID,@"staff", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GETATTENSTAFFS_PATHFANS PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *staffArray=[dicResult objectForKey:@"staffs"];
            for (NSDictionary *staff_dict in staffArray) {
                SNSStaff *snsstaff=[[SNSStaff alloc] init];
                [snsstaff setJSONValue:staff_dict];
                [staffs addObject:snsstaff];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//-(NSString *)getUserConvs:(NSString *)circleid Staff:(NSString *)staffid LastID:(NSString *)lastid Convs:(NSMutableArray *)convs
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id",staffid,@"staff",lastid,@"last_end_id", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_GETUSERCONVS_PATH PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSArray *convArray=[resultString objectForKey:@"convs"];
//                for (NSDictionary *conv in convArray) {
//                    SNSConv *snsconv=[[SNSConv alloc] initWithDictionary:conv];
//                    [convs addObject:snsconv];
//                    [snsconv release];
//                }
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
/////////////////////////////////////////////
//conv_content	动态信息
//attachs	附件编号，以逗号分隔，一般是图片或文件ID
//circle_id	圈子编号
//group_id	群组编号。给自己发的私密信息填写PRIVATE，发给该圈子全体人员的信息填写ALL，其它填写发给特定群组的ID。
-(NSString *)sendTrendConv:(NSString *)content Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv IsAsk:(BOOL)isask
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"conv_content",circleid,@"circle_id",groupid,@"group_id",attachs,@"attachs", nil];
        NSString *rst;
        if (isask)
            rst=[self ASIPostJSonRequest:SNS_NEWCONV_ASK_PATH PostParam:dict];
        else
            rst=[self ASIPostJSonRequest:SNS_NEWCONV_TREND_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                
                [*conv setJSONValue:conv_dict];
                if ((*conv).circle_id==nil)
                {
                    (*conv).circle_id=[[NSString alloc] initWithFormat:@"%@",circleid];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)sendShareConv:(NSString *)content Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv IsAsk:(BOOL)isask
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:content,@"conv_content",circleid,@"circle_id",groupid,@"group_id",attachs,@"attachs", nil];
        NSString *rst;
//        if (isask)
//            rst=[self ASIPostJSonRequest:SNS_NEWCONV_ASK_PATH PostParam:dict];
//        else
//            rst=[self ASIPostJSonRequest:SNS_NEWCONV_TREND_PATH PostParam:dict];
        rst=[self ASIPostJSonRequest:SNS_SEND_SNSSHARE PostParam:dict];
      
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                
                [*conv setJSONValue:conv_dict];
                if ((*conv).circle_id==nil)
                {
                    (*conv).circle_id=[[NSString alloc] initWithFormat:@"%@",circleid];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}
//////////////////////////////////
//title	活动标题
//will_date	活动日期
//will_dur	预计时长
//will_addr	活动地点
//together_desc	活动描述
//attachs	附件编号，以逗号分隔，一般是图片或文件ID
//circle_id	圈子编号
//group_id	群组编号。给自己发的私密信息填写PRIVATE，发给该圈子全体人员的信息填写ALL，其它填写发给特定群组的ID。
-(NSString *)sendTogetherConv:(NSString *)title StartDate:(NSString *)datestr During:(NSString *)during Address:(NSString *)addr Desc:(NSString *)desc Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",datestr,@"will_date",during,@"will_dur",addr,@"will_addr",desc,@"together_desc",circleid,@"circle_id",groupid,@"group_id",attachs,@"attachs", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_NEWCONV_TOGETHER_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                
                [*conv setJSONValue:conv_dict];
                if ((*conv).circle_id==nil)
                {
                    (*conv).circle_id=[[NSString alloc] initWithFormat:@"%@",circleid];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
    //    for (int i = 0; i < [result count]; i++)
    //    {
    //
    //        NSDictionary *di1 = [result objectAtIndex:i];
    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
    //    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

////conv_content	投票内容
////is_multi	是否可多选 0－单选、1－多选，默认0
////finishdate	结束日期
////optionvalues	选项值，以逗号分隔，若选项中有逗号，替换成全角
////attachs	附件编号，以逗号分隔，一般是图片或文件ID
////circle_id	圈子编号
////group_id	群组编号。给自己发的私密信息填写PRIVATE，发给该圈子全体人员的信息填写ALL，其它填写发给特定群组的ID。
-(NSString *)sendVoteConv:(NSString *)conv_content IsMulti:(NSString *)is_multi FinishDate:(NSString *)finishdate OptionValues:(NSString *)optionvalues Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv
{
    NSString* result=nil;
    //    NSLog(@">>> contentVoteConvs ");
    @try {
        //        NSLog(@">>>%@=%@",conv_content,@"conv_content");
        //        NSLog(@">>>%@=%@",is_multi,@"is_multi");
        //        NSLog(@">>>%@=%@",finishdate,@"finishdate");
        //        NSLog(@">>>%@=%@",optionvalues,@"optionvalues");
        //        NSLog(@">>>%@=%@",circleid,@"circle_id");
        //        NSLog(@">>>%@=%@",groupid,@"group_id");
        //        NSLog(@">>>%@=%@",attachs,@"attachs");
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_content,@"conv_content",is_multi,@"is_multi",finishdate,@"finishdate",optionvalues,@"optionvalues",circleid,@"circle_id",groupid,@"group_id",attachs,@"attachs", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_NEWCONV_VOTE_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                [*conv setJSONValue:conv_dict];
                if ((*conv).circle_id==nil)
                {
                    (*conv).circle_id=[[NSString alloc] initWithFormat:@"%@",circleid];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//conv_id	信息ID
//is_multi	是否可多选 0－单选、1－多选，默认0
//optionids	投票选项ID，单选就一个ID，多选以逗号分隔
-(NSString *)convVote:(NSString *)conv_id IsMulti:(NSString *)is_multi Optionids:(NSString *)optionids Conv:(SNSConv **)conv
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_id,@"conv_id",is_multi,@"is_multi",optionids,@"optionids", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_CONVINFO_VOTE_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            //            NSLog(@">>>resultString=\n%@",rst);
            
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                SNSVote *vote = [[SNSVote alloc] init];
                [vote setJSONValue:[conv_dict objectForKey:@"vote"]];
                //                if ((*conv).vote!=nil)
                //                    [(*conv).vote release];
                (*conv).vote=vote;
                //外部释放vote
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//conv_id	被评论/回复信息ID
//replayvalue	回复内容
//reply_to	被评论的人 login_account
//reply_to_name	被评论人的呢称
-(NSString *)convReply:(NSString *)conv_id ReplayValue:(NSString *)replayvalue ReplyTo:(NSString *)reply_to ReplyToName:(NSString *)reply_to_name Attachs:(NSString *)attachs ReturnReply:(SNSReply **)reply
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_id,@"conv_id",replayvalue,@"replayvalue",reply_to,@"reply_to",reply_to_name,@"reply_to_name",attachs,@"attachs", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_CONVINFO_REPLY_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSDictionary *reply_dict=[resultString objectForKey:@"reply"];
                [*reply setJSONValue:reply_dict];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//conv_id	信息ID
//返回：
//returncode	字符串	见返回码描述
//like_staff	字符串	称赞人
//nick_name	字符串	称赞人呢称
-(NSString *)convLike:(NSString *)conv_id LikeStaff:(NSMutableString *)like_staff NickName:(NSMutableString *)nick_name IsSetLike:(BOOL)isSetLike
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_id,@"conv_id", nil];
        NSString *rst;
        if (isSetLike)
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_LIKE_PATH PostParam:dict];
        else
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_UNLIKE_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                [like_staff appendString:[resultString objectForKey:@"like_staff"]];
                [nick_name appendString:[resultString objectForKey:@"nick_name"]];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}


//-(NSString *)getConvAllowCopy:(NSString *)circle_id AllowCopy:(int *)allow_copy
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circle_id,@"circle_id", nil];
//        NSDictionary *dicResult = [self getJSON:SNS_CONVINFO_CONVLIMIT_PATH PostParam:dict];
//        
//        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS])
//        {
//            *allow_copy = [[dicResult objectForKey:@"allow_copy"] isEqualToString:@"1"]?0:1;
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
//    
//    return result;
//}

//conv_content	转发人输入的动态信息
//circle_id	圈子编号
//group_id	转发给该圈子全体人员的信息填写ALL，其它填写发给特定群组的ID。
//copy_id	被转发信息的根信息ID
//copy_last_id	被转发信息的ID
-(NSString *)convCopy:(NSString *)conv_content CopyConvID:(NSString *)copy_id ConvID:(NSString *)copy_last_id CircleID:(NSString *)circle_id GroupID:(NSString *)group_id Conv:(SNSConv **)conv
{
    NSString* result=nil;
    @try {
        NSDictionary *dict ;
        if ([copy_last_id isEqualToString:@""])
            dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_content,@"conv_content",copy_id,@"copy_id",circle_id,@"circle_id",group_id,@"group_id", nil];
        else
            dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_content,@"conv_content",copy_id,@"copy_id",copy_last_id,@"copy_last_id",circle_id,@"circle_id",group_id,@"group_id", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_CONVINFO_COPY_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                if([[resultString allKeys]containsObject:@"conv"]&&![resultString[@"conv"]isEqual:[NSNull null]])
                {
                NSDictionary *conv_dict=[resultString objectForKey:@"conv"];
                
                *conv=[[SNSConv alloc] init];
                [*conv setJSONValue:conv_dict];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)convAtten:(NSString *)conv_id IsSetAtten:(BOOL)isSetAtten
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_id,@"conv_id", nil];
        NSString *rst;
        if (isSetAtten)
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_ATTEN_PATH PostParam:dict];
        else
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_UNATTEN_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//join_staff	字符串	退出人员
//nick_name	字符串	退出人员呢称
-(NSString *)convTogether:(NSString *)conv_id IsTogether:(BOOL)isTogether JoinStaff:(NSMutableString *)join_staff NickName:(NSMutableString *)nick_name
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:conv_id,@"conv_id", nil];
        NSString *rst;
        if (isTogether)
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_TOGETHER_PATH PostParam:dict];
        else
            rst=[self ASIPostJSonRequest:SNS_CONVINFO_UNTOGETHER_PATH PostParam:dict];
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                [join_staff appendString:[resultString objectForKey:@"join_staff"]];
                [nick_name appendString:[resultString objectForKey:@"nick_name"]];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//-(NSString *)GetBulletinUnreadNum:(int *)num
//{
//    NSString* result=nil;
//    *num=0;
//    @try {
//        NSString *rst;
//        rst=[self ASIPostJSonRequest:SNS_BULLETIN_GETUNREADNUM_PATH PostParam:nil];
//        
//        NSDictionary *resultString = [rst objectFromJSONString];
//        NSString *returncode=[resultString objectForKey:@"returncode"];
//        result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS])
//        {
//            NSString *unreadnum=[resultString objectForKey:@"unreadnum"];
//            *num=[unreadnum intValue];
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
////未用
//-(NSString *)getBulletinUnread:(NSMutableArray *)bulletins
//{
//    NSString* result=nil;
//    @try {
//        NSString *rst=[self ASIPostJSonRequest:SNS_BULLETIN_GETUNREAD_PATH PostParam:nil];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //NSLog(@">>>SNS resultString=%@", resultString);
//            
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSArray *bulletinArray=[resultString objectForKey:@"bulletins"];
//                for (NSDictionary *bulletin in bulletinArray) {
//                    SNSBulletin *snsbull=[[SNSBulletin alloc] initWithDictionary:bulletin];
//                    [bulletins addObject:snsbull];
//                    [snsbull release];
//                }
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)getBulletinByCirecleID:(NSString *)circleid Groups:(NSString *)groupid LastID:(NSString *)lastid Convs:(NSMutableArray *)bulletins
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id",groupid,@"group_id",lastid,@"last_end_id", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_BULLETIN_GET_PATH PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //            NSLog(@">>>SNS resultString=%@", resultString);
//            
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSArray *bulletinArray=[resultString objectForKey:@"bulletins"];
//                for (NSDictionary *bulletin in bulletinArray) {
//                    SNSBulletin *snsbull=[[SNSBulletin alloc] initWithDictionary:bulletin];
//                    [bulletins addObject:snsbull];
//                    [snsbull release];
//                }
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)pushBulletinByCirecleID:(NSString *)circleid Groups:(NSString *)groupid BulletinDesc:(NSString *)bulletin_desc
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circle_id",groupid,@"group_id",bulletin_desc,@"bulletin_desc", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_BULLETIN_PUSH_PATH PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //            NSLog(@">>>SNS resultString=%@", resultString);
//            
//            //            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            //            {
//            //                NSArray *bulletinArray=[resultString objectForKey:@"bulletins"];
//            //                for (NSDictionary *bulletin in bulletinArray) {
//            //                    SNSBulletin *snsbull=[[SNSBulletin alloc] initWithDictionary:bulletin];
//            //                    [bulletins addObject:snsbull];
//            //                    [snsbull release];
//            //                }
//            //            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)GetMessageUnreadNum:(int *)num
//{
//    NSString* result=nil;
//    *num=0;
//    @try {
//        NSString *rst;
//        rst=[self ASIPostJSonRequest:SNS_MESSAGE_GETUNREADNUM_PATH PostParam:nil];
//        
//        NSDictionary *resultString = [rst objectFromJSONString];
//        NSString *returncode=[resultString objectForKey:@"returncode"];
//        result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS])
//        {
//            NSString *unreadnum=[resultString objectForKey:@"unreadnum"];
//            *num=[unreadnum intValue];
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
////未用
//-(NSString *)getMessageUnread:(NSMutableArray *)messages
//{
//    NSString* result=nil;
//    @try {
//        NSString *rst=[self ASIPostJSonRequest:SNS_MESSAGE_GETUNREAD_PATH PostParam:nil];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //            NSLog(@">>>SNS resultString=%@", resultString);
//            
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSArray *messageArray=[resultString objectForKey:@"messages"];
//                for (NSDictionary *message in messageArray) {
//                    SNSMessage *snsmsg=[[SNSMessage alloc] initWithDictionary:message];
//                    [messages addObject:snsmsg];
//                    [snsmsg release];
//                }
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)getMessageByLastID:(NSString *)lastid Convs:(NSMutableArray *)messages
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lastid,@"last_end_id", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_MESSAGE_GET_PATH PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //            NSLog(@">>>SNS resultString=%@", resultString);
//            
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                NSArray *messageArray=[resultString objectForKey:@"messages"];
//                for (NSDictionary *message in messageArray) {
//                    SNSMessage *snsmsg=[[SNSMessage alloc] initWithDictionary:message];
//                    [messages addObject:snsmsg];
//                    [snsmsg release];
//                }
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)pushMessageToStaffs:(NSString *)staffs Title:(NSString *)title Content:(NSString *)content
//{
//    NSString* result=nil;
//    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:staffs,@"staffs",title,@"title",content,@"content", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_MESSAGE_PUSH_PATH PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            
//            //            NSLog(@">>>SNS resultString=%@", resultString);
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
//    //    for (int i = 0; i < [result count]; i++)
//    //    {
//    //
//    //        NSDictionary *di1 = [result objectAtIndex:i];
//    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
//    //    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//-(NSString *)GetAtMeUnreadNum:(int *)num
//{
//    NSString* result=nil;
//    *num=0;
//    @try {
//        NSString *rst;
//        rst=[self ASIPostJSonRequest:SNS_GETATMEUNREADNUM_PATH PostParam:nil];
//        
//        NSDictionary *resultString = [rst objectFromJSONString];
//        NSString *returncode=[resultString objectForKey:@"returncode"];
//        result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS])
//        {
//            NSString *unreadnum=[resultString objectForKey:@"num"];
//            *num=[unreadnum intValue];
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}

-(NSString *)getAtMeUnreadByLastID:(NSString *)lastid Convs:(NSMutableArray *)convs
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:lastid,@"last_end_id", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_GETATMECONVS_PATH PostParam:dict];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            //            NSLog(@">>>SNS resultString=%@", resultString);
            
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                NSArray *convArray=[resultString objectForKey:@"convs"];
                for (NSDictionary *conv_dict in convArray) {
                    SNSConv *snsconv=[[SNSConv alloc] init];
                    [snsconv setJSONValue:conv_dict];
                    
                    [convs addObject:snsconv];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    //    NSLog(@">>>SNS n1=%@",[[result objectAtIndex:0] class]);
    //    for (int i = 0; i < [result count]; i++)
    //    {
    //
    //        NSDictionary *di1 = [result objectAtIndex:i];
    //        NSLog(@">>>SNS %@",[di1 objectForKey:@"returncode"]);
    //    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//-(NSString *)registerCheckMail:(NSString *)email Msg:(NSMutableString *)msg IsPublicMail:(NSMutableString *)ispublic ENO:(NSMutableString *)eno EName:(NSMutableString *)ename
//{
//    NSString* result=nil;
//    @try {
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:email,@"account", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_CHECK_MAIL PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                [msg setString:[resultString objectForKey:@"msg"]];
//                [ispublic setString:[resultString objectForKey:@"is_public"]];
//                [eno setString:[resultString objectForKey:@"eno"]];
//                [ename setString:[resultString objectForKey:@"ename"]];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//
////account	注册邮箱
////is_public	是否是公共邮箱 1：公共邮箱 0：企业邮箱
////eno	企业号
////postscript	附言
//-(NSString *)registerSubmit:(NSString *)email IsPublic:(NSString *)is_public ENO:(NSString *)eno Script:(NSString *)postscript
//{
//    NSString* result=nil;
//    @try {
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:email,@"account",is_public,@"is_public",eno,@"eno",postscript,@"postscript", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_SUBMIT PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            if ([result isEqualToString:SNS_RETURN_OTHER])
//            {
//                NSString *msg=[resultString objectForKey:@"msg"];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
//
////account	注册邮箱
////nick_name	真实姓名
////eno	企业号
////active_code	激活码
////password	密码
//-(NSString *)registerActive:(NSString *)email NickName:(NSString *)nick_name ENO:(NSString *)eno ActiveCode:(NSString *)active_code Password:(NSString *)password
//{
//    NSString* result=nil;
//    @try {
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:email,@"account",nick_name,@"nick_name",eno,@"eno",active_code,@"active_code",password,@"password", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_ACTIVE PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            if ([result isEqualToString:SNS_RETURN_OTHER])
//            {
//                NSString *msg=[resultString objectForKey:@"msg"];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}

-(NSString *)registerGetEnterprise:(NSMutableArray *)enterprises EnterpriseName:(NSString *)ename
{
    NSString* result=nil;
    @try {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ename,@"ename", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_GET_ENTERPRISE PostParam:dict];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            
            NSString *returncode=[resultString objectForKey:@"returncode"];
            
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            if ([result isEqualToString:SNS_RETURN_SUCCESS])
            {
                
                //                NSLog(@">>>SNS resultString=%@", resultString);
                NSArray *enterpriseArray=[resultString objectForKey:@"enterprises"];
                for (NSDictionary *enterprise in enterpriseArray) {
                    SNSEnterprise *snsen=[[SNSEnterprise alloc] init];
                    [snsen setJSONValue:enterprise];
                    [enterprises addObject:snsen];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//
////returncode	字符串	见返回码描述
////eno	字符串	企业号
////active_code	字符串	激活码
////account	字符串	注册帐号
//-(NSString *)getRegisterInfo:(NSString *)email ENO:(NSMutableString *)eno IsApprove:(NSMutableString *)is_approve
//{
//    NSString* result=nil;
//    @try {
//        
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:email,@"account", nil];
//        
//        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_GET_REGISTERINFO PostParam:dict];
//        if ([rst length]>0)
//        {
//            NSDictionary *resultString = [rst objectFromJSONString];
//            
//            NSString *returncode=[resultString objectForKey:@"returncode"];
//            //            NSLog(@">>>>%@",resultString);
//            result=[[[NSString alloc] initWithFormat:@"%@",returncode] autorelease];
//            if ([result isEqualToString:SNS_RETURN_SUCCESS])
//            {
//                [eno setString:[resultString objectForKey:@"eno"]];
//                [is_approve setString:[resultString objectForKey:@"is_approve"]];
//            }
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    if (result==nil)
//        result=[[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR] autorelease];
//    
//    return result;
//}
//
////直接发送
////define FANFOU_SEND_PHOTO_API @"http://api.fanfou.com/photos/upload.json"
////- (IBAction)sendMessage:(id)sender {
////    // 创建Request对象
////    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:FANFOU_SEND_PHOTO_API]
////                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
////                                                        timeoutInterval:60.0];
////    // 定义boundary
////    NSString *boundary = @"----Boundary+WhateverYouLikeToPutInHere----datatata--done";
////    // 使用POST方法
////    [req setHTTPMethod:@"POST"];
////    // 设置Content-Type
////    [req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary, nil] forHTTPHeaderField:@"Content-Type"];
////
////    // 把图片变成data。
////    NSImage *theImage = [self.imageView image];
////    NSBitmapImageRep *bitmap = [[theImage representations] objectAtIndex:0];
////    NSData *imageData = [bitmap representationUsingType:NSJPEGFileType properties: nil];
////
////    // 需要POST的键值对
////    NSDictionary *values = [NSDictionary dictionaryWithObjectsAndKeys:[messageField string], @"status", imageData, @"photo", nil];
////
////    // 初始化POST Data
////    NSMutableData *d = [NSMutableData data];
////
////    // 遍历键值对，将其转换成NSData
////    for (NSString *key in [values allKeys]) {
////
////        // Append一个Boundary
////        [d appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////
////        id currentValue = [values objectForKey:key];
////
////        if( [currentValue isKindOfClass:[NSData class]] && [NSImageRep imageRepClassForData:currentValue] != nil ) {
////            // 如果是图片对象的处理方法。
////            // 设置Content-Disposition，这里设置图片对应的key的名字
////            [d appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", key]
////                           dataUsingEncoding:NSUTF8StringEncoding]];
////            // 设置图片的Content-Type
////            [d appendData:[@"Content-Type: image/png\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
////            // 设置传输编码为二进制
////            [d appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
////            // Append图片
////            [d appendData:currentValue];
////        }
////        else {
////            // 字符串值的处理方法
////            // Append一个Boundary
////            [d appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////            // 设置字符串键
////            [d appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
////            // 设置字符串值
////            [d appendData:[[NSString stringWithFormat:@"%@", currentValue] dataUsingEncoding:NSUTF8StringEncoding]];
////        }
////    }
////    // 最后Append一个Boundary
////    [d appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    // 设置数据为请求的Body
////    [req setHTTPBody:d];
////
////    // 建立一个连接，用来发送请求，并且设置delegate为self，这里主要用来处理BasicAuth
////    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:req delegate:self];
////    if (theConnection) {
////        // 处理连接成功
////    } else {
////        // 处理链接失败
////    }
////    [req release];
////}
////
////// NSURLConnection的Delegate方法，用来处理Basic Auth。
////-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
////{
////    if ([challenge previousFailureCount] == 0) {
////        NSURLCredential *newCredential;
////        newCredential = [NSURLCredential credentialWithUser:@"YOUR_USER_NAME"
////                                                   password:@"YOUR_PASSWORD"
////                                                persistence:NSURLCredentialPersistenceNone];
////        [[challenge sender] useCredential:newCredential
////               forAuthenticationChallenge:challenge];
////    } else {
////        [[challenge sender] cancelAuthenticationChallenge:challenge];
////        // 处理认证失败
////    }
////}

-(NSString *)mobileRegistGetVaildCode:(NSString*)txtmobile TipMsg:(NSMutableString *)tipmsg
{
    NSString *result=nil;
    @try
    {
        NSDictionary *para =  @{@"mobile_num": txtmobile};
        NSString *rst=[self ASIPostJSonRequest:SNS_MOBILE_REGIST_GETVAILDCODE PostParam:para];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            result=[resultString objectForKey:@"returncode"];
            if ([[resultString objectForKey:@"msg"] isKindOfClass:[NSNumber class]])
            {
                NSNumber *num=[resultString objectForKey:@"msg"];
                NSString *str=[NSString stringWithFormat:@"%0.6d",[num intValue]];
                [tipmsg setString:str];
            }
            else
            {
                [tipmsg setString:[resultString objectForKey:@"msg"]];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}

//mobile_num	待注册手机号
//mobile_pwd	手机短信密码
//eno	企业号，新建企业可以为空
//ename	企业名称
//nick_name	真实姓名
//active_code	短信激活码

- (NSString *)registerActiveWithDictionary:(NSDictionary *)dict tipMsg:(NSMutableString *)tipmsg
{
    NSString* result=nil;
    @try {
        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_ACTIVE PostParam:dict];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            
            NSString *returncode=[resultString objectForKey:@"returncode"];
            
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            [tipmsg setString:[resultString objectForKey:@"msg"]];
            
        }
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

-(NSString *)registerActive:(NSString *)mobile_num Password:(NSString *)mobile_pwd ENO:(NSString *)eno Ename:(NSString *)ename NickName:(NSString *)nick_name ActiveCode:(NSString *)active_code TipMsg:(NSMutableString *)tipmsg
{
    NSString* result=nil;
    @try {

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:mobile_num,@"mobile_num",mobile_pwd,@"mobile_pwd",eno,@"eno",ename,@"ename",nick_name,@"nick_name",active_code,@"active_code", nil];

        NSString *rst=[self ASIPostJSonRequest:SNS_REGIST_ACTIVE PostParam:dict];
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];

            NSString *returncode=[resultString objectForKey:@"returncode"];

            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            
            [tipmsg setString:[resultString objectForKey:@"msg"]];
            
        }
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];

    return result;
}

-(void)mobilebindGetVaildCode:(NSString*)txtmobile result:(NSMutableDictionary*)result
{
    if (result == nil) return;
    @try
    {
        NSDictionary *para =  @{@"txtmobile": txtmobile};
        NSString *rst=[self ASIPostJSonRequest:SNS_MOBILEBIND_GETVAILDCODE PostParam:para];
        if ([rst length]>0)
        {
            [result addEntriesFromDictionary:[rst objectFromJSONString]];
        }
    }
    @catch (NSException *exception)
    {
        [result setObject:@"0" forKey:@"success"];
        [result setObject:@"验证码获取失败" forKey:@"msg"];
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}
-(void)mobilebindSave:(NSString*)txtmobile txtvaildcode:(NSString*)txtvaildcode result:(NSMutableDictionary*)result
{
    if (result == nil) return;
    @try
    {
        NSDictionary *para =  @{@"txtmobile": txtmobile, @"txtvaildcode": txtvaildcode};
        NSString *rst=[self ASIPostJSonRequest:SNS_MOBILEBIND_SAVE PostParam:para];
        if ([rst length]>0)
        {
            [result addEntriesFromDictionary:[rst objectFromJSONString]];
        }
    }
    @catch (NSException *exception)
    {
        [result setObject:@"0" forKey:@"success"];
        [result setObject:@"绑定失败" forKey:@"msg"];
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}
-(void)mobilebindRemove:(NSString*)nilpara result:(NSMutableDictionary*)result
{
    if (result == nil) return;
    @try
    {
        NSDictionary *para =  @{};
        NSString *rst=[self ASIPostJSonRequest:SNS_MOBILEBIND_REMOVE PostParam:para];
        if ([rst length]>0)
        {
            [result addEntriesFromDictionary:[rst objectFromJSONString]];
        }
    }
    @catch (NSException *exception)
    {
        [result setObject:@"0" forKey:@"success"];
        [result setObject:@"取消绑定失败" forKey:@"msg"];
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}

-(void)mobilebindGetVaildCode_newInterface:(NSString*)txtmobile result:(NSMutableDictionary*)result
{
    if (result == nil) return;
    @try
    {
        NSDictionary *para =  @{@"txtmobile": txtmobile};
        NSString *rst=[self ASIPostJSonRequest:SNS_NEW_MOBILEBIND_GETVAILDCODE PostParam:para];
        if ([rst length]>0)
        {
            [result addEntriesFromDictionary:[rst objectFromJSONString]];
        }
    }
    @catch (NSException *exception)
    {
        [result setObject:SNS_RETURN_OTHER forKey:@"returncode"];
        [result setObject:@"验证码获取失败" forKey:@"msg"];
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}

-(void)mobilebindSave_newInterface:(NSString*)txtmobile txtvaildcode:(NSString*)txtvaildcode result:(NSMutableDictionary*)result
{
    if (result == nil) return;
    @try
    {
        NSDictionary *para =  @{@"txtmobile": txtmobile, @"txtvaildcode": txtvaildcode};
        NSString *rst=[self ASIPostJSonRequest:SNS_NEW_MOBILEBIND_SAVE PostParam:para];
        if ([rst length]>0)
        {
            [result addEntriesFromDictionary:[rst objectFromJSONString]];
        }
    }
    @catch (NSException *exception)
    {
        [result setObject:SNS_RETURN_OTHER forKey:@"returncode"];
        [result setObject:@"绑定失败" forKey:@"msg"];
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}

-(NSString*)getForgetPasswdUrl
{
    return [NSString stringWithFormat:@"%@%@",JSON_URL,SNS_FORGET_PASSWD];
}

//错误报告，一直提交至我们的服务器
-(void)errReport:(NSString*)errmsg
{
    @try
    {
        NSDictionary *para =  @{@"report_staff":[AppSetting getUserID], @"report_device":@"iPhone", @"report_content":errmsg};
        
        NSString *urlString =[NSString stringWithFormat:@"https://www.wefafa.com%@", SNS_ERR_REPORT];
        NSURL *url = [NSURL URLWithString:urlString];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        NSEnumerator * enumeratorKey = [para keyEnumerator];
        for (NSString *key in enumeratorKey) {
            NSObject *value = [para objectForKey:key];
            [request setPostValue:value forKey:key];
        }
        
        [request startSynchronous];
        
        NSError *error = [request error];
        NSString *result;
        if (!error) {
            result = [[NSString alloc] initWithFormat:@"%@",[request responseString]];
        }
        else
            result = [[NSString alloc] initWithFormat:@""];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}

+(UIImage *)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName
{
    NSString *filepath;
    if (imgName==nil || [imgName isEqualToString:@""]==YES)
    {
        return [UIImage imageNamed:DEFAULT_LOADING_HEADIMGVIEW];//@"default_head_image.png"];
    }
    
    filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSHeadImgFilePath], imgName];
    UIImage *img=nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
        //        NSData *imgdata = [[NSData alloc] initWithContentsOfFile:filepath];
        //        img = [[[UIImage alloc] initWithData:imgdata] autorelease];
        //        [imgdata release];
        img = [[UIImage alloc] initWithContentsOfFile:filepath];
    }
    else
    {
        //缓存图片数据
        NSData *imgdata = [sns getImage:SNS_IMAGE_ORIGINAL ImageName:imgName];
        if (imgdata!=nil)
        {
            [imgdata writeToFile: filepath atomically: NO];
        }
        
        img = [[UIImage alloc] initWithData:imgdata];
    }
    return img;
}

+(UIImage *)getFile:(NSString *)fileID FileName:(NSString *)fileName FileExt:(NSString *)fileExt imagesize:(IMAGE_SIZE)imagesize
{
    NSString *filepath;
    if ([fileID isEqualToString:@""]==YES)
    {
        return nil;
    }
    
    NSString *real_fileID = fileID;
    if (imagesize != SNS_IMAGE_ORIGINAL)
    {
        real_fileID = [NSString stringWithFormat:@"%@_%d", fileID, imagesize];
    }
    
    if ([fileExt isEqualToString:@""])
        filepath = [NSString stringWithFormat:@"%@/%@", [AppSetting getSNSAttachFilePath], real_fileID];
    else
        filepath = [NSString stringWithFormat:@"%@/%@.%@", [AppSetting getSNSAttachFilePath], real_fileID, fileExt];
    
    UIImage *img=nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]==YES)
    {
        img = [[UIImage alloc] initWithContentsOfFile:filepath];
    }
    else
    {
        //缓存图片数据
        NSData *filedata = [sns getImage:imagesize ImageName:fileID];
        if (filedata!=nil)
        {
            [filedata writeToFile: filepath atomically: NO];
        }
        
        img = [[UIImage alloc] initWithData:filedata];
    }
    return img;
}

//5.13	根据邮箱获取好友信息,只返回前10条
-(NSArray*)getStaffByEmail:(NSString*)email
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"email": email};
        NSDictionary *rst=[self getJSON:SNS_EMAILTOSTAFFS PostParam:para];
        if ([rst[@"staffs"] count] > 0)
        {
            [re addObjectsFromArray:rst[@"staffs"]];
        }
    }
    @catch (NSException *exception)
    {        
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}

//5.14	根据手机号获取好友信息,只返回前10条
-(NSArray*)getStaffByMobile:(NSString*)mobile
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"mobile": mobile};
        NSDictionary *rst=[self getJSON:SNS_MOBILEBIND_GETVAILDCODE PostParam:para];
        if ([rst[@"staffs"] count] > 0)
        {
            [re addObjectsFromArray:rst[@"staffs"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}

//5.15	根据姓名获取好友信息,只返回前10条
-(NSArray*)getStaffByName:(NSString*)name
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"name": name};
        NSDictionary *rst=[self getJSON:SNS_NAMETOSTAFFS PostParam:para];
        if ([rst[@"staffs"] count] > 0)
        {
            [re addObjectsFromArray:rst[@"staffs"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}

-(void)submitURL:(NSString *)fullpath
{
    NSURL *url = [NSURL URLWithString:fullpath];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"FaFaIPhone" forKey:@"_urlSource"];
    [request setPostValue:self.openid forKey:@"_wefafauid"];
    [request setPostValue:[AppSetting getUserID] forKey:@"_wefafauname"];
    [request setPostValue:@"" forKey:@"_remark"];
    
    [request setDelegate:nil];
    [request startAsynchronous];
}

- (SNSMicroAccount *)dic2SNSMicroAccount:(NSDictionary *)dicX
{
    SNSMicroAccount *ma = [[SNSMicroAccount alloc] init];
    ma.ID = [Utils getSNSString:dicX[@"id"]]; 
    ma.wm_number = [Utils getSNSString:dicX[@"number"]];
    ma.wm_name = [Utils getSNSString:dicX[@"name"]];
    ma.jid = [Utils getSNSString:dicX[@"jid"]];
    ma.im_state = [Utils getSNSString:dicX[@"im_state"]];
    ma.im_resource = [Utils getSNSString:dicX[@"im_resource"]];
    ma.im_priority = @([Utils getSNSString:dicX[@"im_priority"]].floatValue);
    ma.wm_type = [Utils getSNSString:dicX[@"type"]];
    ma.micro_use = [Utils getSNSString:dicX[@"micro_use"]];
    ma.logo_path = [Utils getSNSString:dicX[@"logo_path"]];
    ma.logo_path_big = [Utils getSNSString:dicX[@"logo_path_big"]];
    ma.logo_path_small = [Utils getSNSString:dicX[@"logo_path_small"]];
    ma.introduction = [Utils getSNSString:dicX[@"introduction"]];
    ma.eno = [Utils getSNSString:dicX[@"eno"]];
    ma.wm_limit = [Utils getSNSString:dicX[@"limit"]];
    ma.concern_approval = [Utils getSNSString:dicX[@"concern_approval"]];
    ma.wm_level = @([Utils getSNSString:dicX[@"level"]].floatValue);
    ma.fans_count = @([Utils getSNSString:dicX[@"fans_count"]].floatValue);
    ma.window_template = [Utils getSNSString:dicX[@"window_template"]];
    ma.salutatory = [Utils getSNSString:dicX[@"salutatory"]];
    ma.send_status = [Utils getSNSString:dicX[@"send_status"]];
    return ma;
}

-(NSArray*)getMyMicroaccount:(MICRO_USE_TYPE)micro_use
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"micro_use": @(micro_use)};
        NSDictionary *rst=[self getJSON:SNS_MICROACCOUNT_GETATTENLIST PostParam:para];
        
        for (NSDictionary *dicX in rst[@"list"]) { 
            [re addObject:[self dic2SNSMicroAccount:dicX]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;    
}

-(NSArray*)queryMicroaccount:(NSString*)microaccount MicroUseType:(MICRO_USE_TYPE)micro_use
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"microaccount":microaccount, @"micro_use": @(micro_use)};
        NSDictionary *rst=[self getJSON:SNS_MICROACCOUNT_QUERY PostParam:para];
        
        for (NSDictionary *dicX in rst[@"list"]) {
            [re addObject:[self dic2SNSMicroAccount:dicX]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}

-(BOOL)attenMicroaccount:(NSString*)microaccount attenList:(NSMutableArray*)attenList
{
    BOOL result=NO;
    @try
    {
        NSDictionary *para =  @{@"microaccount":microaccount};
        NSDictionary *rst=[self getJSON:SNS_MICROACCOUNT_ATTEN PostParam:para];
        result=[rst[@"returncode"] isEqualToString:SNS_RETURN_SUCCESS];
        if (result)
        {
            for (NSDictionary *dicX in rst[@"list"]) {
                [attenList addObject:[self dic2SNSMicroAccount:dicX]];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return result;
}

-(void)unattenMicroaccount:(NSString*)microaccount
{ 
    @try
    {
        NSDictionary *para =  @{@"microaccount":microaccount};
        NSDictionary *rst=[self getJSON:SNS_MICROACCOUNT_CANCEL PostParam:para];
        if (rst[@"msg"]) {}//NSLog(@"%@", rst[@"msg"]);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
}

-(NSArray*)getRecomUser:(int)pageindex PageSize:(int)pagesize
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:10];
    
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",pageindex ],@"pageindex",[[NSString alloc] initWithFormat:@"%d",pagesize ],@"pagesize", nil];
        NSDictionary *dicResult = [self getJSON:SNS_GET_RECOM_USER PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *userArr=[dicResult objectForKey:@"rows"];
            for (NSDictionary *dict in userArr) {
                SNSRecommendUser *snsuser=[[SNSRecommendUser alloc] init];
                [snsuser setJSONValue:dict];
                
                [arr addObject:snsuser];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return arr;
}

-(NSArray*)getRecomCircle:(int)pageindex PageSize:(int)pagesize CircleName:(NSString *)circlename
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:10];
    
    NSString* result=nil;
    @try {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",pageindex ],@"pageindex",[[NSString alloc] initWithFormat:@"%d",pagesize ],@"pagesize", nil];
        if (circlename.length>0)
            [dict setObject:circlename forKey: @"circlename"];
        
        NSDictionary *dicResult = [self getJSON:SNS_GET_RECOM_CIRCLE PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *userArr=[dicResult objectForKey:@"rows"];
            for (NSDictionary *dict in userArr) {
                SNSRecommendCircle *snscircle=[[SNSRecommendCircle alloc] init];
                [snscircle setJSONValue:dict];
                
                [arr addObject:snscircle];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return arr;
}

-(NSString *)joinCircle:(NSString *)circleid returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circleid,@"circleId", nil];
        NSDictionary *dicResult = [self getJSON:SNS_JOIN_CIRCLE PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
        {
            [msg setString:dicResult[@"msg"]];
        }
    }
    @catch (NSException *exception) {
    }
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    return result;
}

-(NSArray *)getPersonalTag:(NSString *)account
{
    NSMutableArray* arr=[[NSMutableArray alloc] initWithCapacity:5];
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GET_PERSONAL_TAG PostParam:dict];
        
        NSString *result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *userArr=[dicResult objectForKey:@"rows"];
            for (NSDictionary *dict in userArr) {
                SNSTagInfo *taginfo=[[SNSTagInfo alloc] init];
                [taginfo setJSONValue:dict];
                
                [arr addObject:taginfo];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    return arr;
}

-(NSString *)getCircleActivateUser:(NSString *)circle_id Staffs:(NSMutableArray *)staffs
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:circle_id,@"circle_id", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_GET_CIRCLE_ACTIVITE_USER PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *staffArray=[dicResult objectForKey:@"top"];
            for (NSDictionary *staff_dict in staffArray) {
                SNSStaff *snsstaff=[[SNSStaff alloc] init];
                [snsstaff setJSONValue:staff_dict];
                [staffs addObject:snsstaff];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}


////////////////////////////////////////////
-(NSMutableArray *)getAuthUserList:(int)pageindex PageSize:(int)pagesize
{
    NSMutableArray *staffs=[[NSMutableArray alloc] initWithCapacity:10];
    NSString* result=nil;
    @try {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(pageindex),@"pageindex",@(pagesize),@"pagesize", nil];
        NSDictionary *dicResult = [self getJSON:SNS_GET_ENO_AUTH_STAFF PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *staffArray=[dicResult objectForKey:@"rows"];
            for (NSDictionary *staff_dict in staffArray) {
                SNSEnterpriseStaff *snsstaff=[[SNSEnterpriseStaff alloc] init];
                [snsstaff setJSONValue:staff_dict];
                [staffs addObject:snsstaff];
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    return staffs;
}

-(NSString *)userIdentifyAuth:(NSString *)recver memo:(NSString *)memostr returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        //recver 选中人员的jid(不带resource)用 ,分割，authren 申请的附言
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:recver,@"recver",memostr,@"authren", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_USER_IDENTIFY_SEND_APPLY PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
            [msg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}

-(NSString *)enterpriseAuthFile:(NSString *)fileid returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:fileid,@"fileid", nil];
        
        NSDictionary *dicResult = [self getJSON:SNS_USER_IDENTIFY_ENO_AUTH PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
            [msg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}

-(NSArray*)queryCircles:(int)pageindex PageSize:(int)pagesize CircleName:(NSString *)circlename CircleClass:(NSString *)circleclass CircleID:(NSString *)circleid
{
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:20];
    
    NSString* result=nil;
    @try {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSString alloc] initWithFormat:@"%d",pageindex ],@"pageindex",[[NSString alloc] initWithFormat:@"%d",pagesize ],@"pagesize",circlename,@"circleName",circleclass,@"circleClass",circleid,@"circleId", nil];
//        if (circleclass.length>0)
//            [dict setObject:circleclass forKey:@"circleClass"];
//        if (circlename.length>0)
//            [dict setObject:circlename forKey: @"circleName"];
//        if (circleid.length>0)
//            [dict setObject:circleid forKey: @"circleId"];
        
        
        NSDictionary *dicResult = [self getJSON:SNS_QUERY_CIRCLE PostParam:dict];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            NSArray *userArr=[dicResult objectForKey:@"rows"];
            for (NSDictionary *dict in userArr) {
                SNSCircle *snscircle=[[SNSCircle alloc] init];
                [snscircle setJSONValue:dict];
                
                [arr addObject:snscircle];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return arr;
}

-(NSString *)getPasswordValidCode:(NSString *)account returnFlag:(NSMutableString *)flag returnRetrieveID:(NSMutableString *)retrieve_id returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",@"1", @"flag", nil];
//         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"mobile_num",@"1", @"flag", nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_GET_PASSWORD_VALIDCODE PostParam:dict];
        NSDictionary *dicResult = [rst objectFromJSONString];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==YES)
        {
//            [flag setString:dicResult[@"flag"]];
//            [retrieve_id setString:dicResult[@"retrieve_id"]];
            [msg setString:dicResult[@"msg"]];
        }
        else
        {
            [msg setString:dicResult[@"msg"]];
        }
    }
    @catch (NSException *exception) {
    }
    
    return result;
}
//MB忘记密码短信获取到新密码
-(NSString *)resetPassword:(NSString *)account txtvaildcode:(NSString*)txtvaildcode returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",txtvaildcode,@"code",nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_RESET_PASSWORD PostParam:dict];
        NSDictionary *dicResult = [rst objectFromJSONString];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
            [msg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}


-(NSString *)resetPassword:(NSString *)account txtvaildcode:(NSString*)txtvaildcode retrieve_id:(NSString*)retrieve_id txtnewpwd:(NSString *)txtnewpwd returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"account",txtvaildcode,@"txtvaildcode",retrieve_id,@"retrieve_id",txtnewpwd,@"txtnewpwd", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_RESET_PASSWORD PostParam:dict];
        NSDictionary *dicResult = [rst objectFromJSONString];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
            [msg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}

-(NSString *)modifyPassword:(NSString*)oldpwd newpwd:(NSString *)newpwd returnMsg:(NSMutableString *)msg
{
    NSString* result=nil;
    @try {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:oldpwd,@"txtoldpwd",newpwd,@"txtnewpwd", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_MODIFY_PASSWORD PostParam:dict];
        NSDictionary *dicResult = [rst objectFromJSONString];
        
        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
//        if ([result isEqualToString:SNS_RETURN_SUCCESS]==NO)
        [msg setString:dicResult[@"msg"]];
    }
    @catch (NSException *exception) {
    }
    
    return result;
}

-(NSDictionary *)getMeetingInfo:(NSString *)meetingid
{
    NSDictionary *result;
    @try {
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:meetingid,@"groupid", nil];
//        NSDictionary *dicResult = [self getJSON:SNS_GET_MEETING_INFO PostParam:dict];
//        
//        result=[[NSString alloc] initWithFormat:@"%@",dicResult[@"returncode"]];
        NSString *urlString =[NSString stringWithFormat:@"%@%@?groupid=%@",JSON_URL,SNS_GET_MEETING_INFO,meetingid];
        NSURL *url = [NSURL URLWithString:urlString];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {
            NSDictionary *dict1 = [[request responseString] objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            if ([dict1[@"returncode"] isEqualToString:SNS_RETURN_SUCCESS])
            {
                //NSLog(@"%@",[dict1 objectForKey:@"data"]);
                NSArray *data=[dict1 objectForKey:@"data"];
                if (data!=nil && [data count]>0) result=[dict1 objectForKey:@"data"][0];
                else result=nil;
            }
        }
        else
        {
            result=nil;
        }
    }
    @catch (NSException *exception) {
        result=nil;
    }
    
    return result;
}

-(NSString *)uploadCircleLogo:(NSString *)filedata Circleid:(NSString *)circleid Fileids:(NSMutableDictionary *)fileids
{
    NSString* result=nil;
    @try {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:filedata,@"filedata",circleid,@"circle_id", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_UPDATE_CIRCLE_LOGO PostParam:dict];
        
        NSDictionary *resultString = [rst objectFromJSONString];
        
        result=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"returncode"]];
        
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            [fileids setObject:[resultString objectForKey:@"filepath"] forKey:@"filepath"];
            [fileids setObject:[resultString objectForKey:@"filepath_big"] forKey:@"filepath_big"];
            [fileids setObject:[resultString objectForKey:@"filepath_small"] forKey:@"filepath_small"];
        }
        
    }
    @catch (NSException *exception) {
        result=nil;
    }
    return result;
}

-(NSString *)uploadGroupLogo:(NSString *)filedata Circleid:(NSString *)circleid Groupid:(NSString *)groupid Fileids:(NSMutableDictionary *)fileids
{
    NSString* result=nil;
    @try {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:filedata,@"filedata",circleid,@"circle_id",groupid,@"group_id", nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_UPDATE_GROUP_LOGO PostParam:dict];
        
        NSDictionary *resultString = [rst objectFromJSONString];
        
        result=[resultString objectForKey:@"returncode"];
        
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            [fileids setObject:[resultString objectForKey:@"filepath"] forKey:@"filepath"];
        }
    }
    @catch (NSException *exception) {
        result=nil;
    }
    return result;
}

-(NSString *)updateGroup:(SNSGroup *)saveGroup Group:(SNSGroup *)newGroup {
    NSString *result=nil;
    @try {
        NSDictionary *dicResult = [self getJSON:SNS_UPDATE_GROUP_INFO PostParam:@{@"circle_id":saveGroup.circle_id,@"group_id":saveGroup.group_id,@"group_name":saveGroup.group_name}];
        result = [NSString stringWithFormat:@"%@",dicResult[@"returncode"]];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            [newGroup setJSONValue:dicResult[@"group"]];
        }
    }
    @catch (NSException *exception) {
    }
    return result;
    //@"group_class_id":saveGroup.group_class_id,@"group_desc":saveGroup.group_desc,@"join_method":saveGroup.join_method
}

-(NSString *)uploadMyHeadPhotoWithFileData:(NSData *)photodata Fileids:(NSMutableDictionary *)fileids {
    NSString* result=nil;
    @try {
        
        NSString *rst=[self ASIPostJSonRequest:SNS_UPLOAD_MY_HEAD_PHOTO PostParam:nil FileData:photodata FileName:@"photofile"];
        
        NSDictionary *resultString = [rst objectFromJSONString];
        
        result=[NSString stringWithFormat:@"%@",resultString[@"returncode"]];
        
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            [fileids setObject:[resultString objectForKey:@"fileid"] forKey:@"fileid"];
            [fileids setObject:[resultString objectForKey:@"photo_path"] forKey:@"photo_path"];   //没有返回字段
//            [fileids setObject:[resultString objectForKey:@"photo_path_big"] forKey:@"photo_path_big"];
//            [fileids setObject:[resultString objectForKey:@"photo_path_big"] forKey:@"photo_path_small"];
//            [fileids setObject:[resultString objectForKey:@"photo_path_small"] forKey:@"photo_path_small"];       //没有返回字段
        }
    }
    @catch (NSException *exception) {
        result=nil;
    }
    return result;
}

-(NSString *)updateMyInfo:(SNSStaffFull *)snsStaffFull {
    NSString* result=nil;
    @try {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:snsStaffFull.self_desc,@"self_desc",
                              snsStaffFull.sex_id,@"sex_id",
                              snsStaffFull.nick_name,@"nick_name",
                              snsStaffFull.work_phone,@"work_phone",
                              snsStaffFull.duty,@"duty",
                              snsStaffFull.dept_id,@"dept_id",nil];
        
        NSString *rst=[self ASIPostJSonRequest:SNS_UPDATE_MY_INFO PostParam:dict];
        
        NSDictionary *resultString = [rst objectFromJSONString];
        
        result=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"returncode"]];
    }
    @catch (NSException *exception) {
        result=nil;
    }
    return result;
}

-(NSArray *)getDepts {
    NSArray* result=nil;
    @try {
        
        NSString *rst=[self ASIPostJSonRequest:SNS_GET_DEPTS PostParam:nil];
        
        NSDictionary *resultString = [rst objectFromJSONString];
        NSString *success=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"returncode"]];
        if ([success isEqualToString:SNS_RETURN_SUCCESS]) {
            result=[resultString objectForKey:@"depts"];
        }
    }
    @catch (NSException *exception) {
        result=nil;
    }
    return result;
}

-(NSDictionary*)ssoBind:(NSString*)appid openid:(NSString*)openid1 auth:(NSString*)auth
{
    NSDictionary *result=nil;
    @try {
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", SNS_SSO_BIND, openid1, appid];
        result = [self getJSON:url PostParam:@{@"auth":auth}];
    }
    @catch (NSException *exception) {
    }
    return result;
}

-(NSDictionary*)ssoUnBind:(NSString*)appid openid:(NSString*)openid1
{
    NSDictionary *result=nil;
    @try {
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", SNS_SSO_UNBIND, openid1, appid];
        result = [self getJSON:url PostParam:@{}];
    }
    @catch (NSException *exception) {
    }
    return result;
}

-(NSDictionary*)ssoGetAuth:(NSString*)appid openid:(NSString*)openid1
{
    NSDictionary *result=nil;
    @try {
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@", SNS_SSO_GETAUTH, openid1, appid];
        result = [self getJSON:url PostParam:@{@"decrypt":@"1"}];
    }
    @catch (NSException *exception) {
    }
    return result;
}

//////////////////////////////////////////////////////
//美邦接口
-(NSArray*)searchStaffs:(NSString*)value page:(int)page
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"search": value,  @"pagesize":@(40), @"page":@(page)};
        NSDictionary *rst=[self getJSON:SNS_SEARCH_STAFFS PostParam:para];
        if ([rst[@"staffs"] count] > 0)
        {
            [re addObjectsFromArray:rst[@"staffs"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}
-(NSArray*)searchDesigner:(NSString*)value page:(int)page
{
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:10];
    @try
    {
        NSDictionary *para =  @{@"search": value,  @"pagesize":@(40), @"page":@(page),@"isdesigner":@"1"};
        NSDictionary *rst=[self getJSON:SNS_SEARCH_STAFFS PostParam:para];
        if ([rst[@"staffs"] count] > 0)
        {
            [re addObjectsFromArray:rst[@"staffs"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return re;
}
-(NSString *)getAttenDesigner:(NSString*)staffid designerList:(NSMutableArray *)designerList
{
    NSString *result=nil;
    @try {
        NSDictionary *dicResult=[self getJSON:SNS_GET_ATTEN_DESIGNER PostParam:@{@"staff":staffid,@"isdesigner":@(1)}];
        
        result = dicResult[@"returncode"];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
            for (NSDictionary *staff in dicResult[@"staffs"])
            {
                SNSStaff *snsstaff=[[SNSStaff alloc] init];
                [snsstaff setJSONValue:staff];
                [designerList addObject: snsstaff];
            }
        }
    }
    @catch (NSException *exception) {
    }
    return result;
}

-(NSArray *)getAttenUserIdList:(NSMutableArray*)userIdlist
{
    NSString *result=nil;
    NSArray *array;

    @try {
        
        NSMutableString *str = [[NSMutableString alloc]init];
        for (NSString *userId in userIdlist) {
            [str appendString:userId];
            [str appendString:@","];
        }
        
        
        
        NSDictionary *param = @{@"bytype":@"ldap_uid",@"list":[str substringToIndex:([str length]-1)],@"returnattrs":@"fafa_jid"};
        NSDictionary *dicResult=[self getJSON:GET_STAFF_JID PostParam:param];
        
        result = dicResult[@"returncode"];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
          array = dicResult[@"list"];
        }
    }
    @catch (NSException *exception) {
    }
    return array;
}


//参数名	描述
//appid	应用id
//code	应用code码
//eno	企业号
//openid	普通用户的标识，对当前开发者帐号唯一
//nickname	普通用户昵称
//sex	用户性别，1为男性，2为女性
//province	省份
//city	城市
//headimgurl	用户头像
//unionid	用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
//logintype	登录来源
//00－Wefafa Web
//01－Wefafa Android
//02－Wefafa iPhone
//03－Wefafa PC
//【返回数据】
//属性名	类型	描述
//returncode	字符串	见返回码描述
//openid	字符串	用户openid
-(NSString *)snsWeiXinLogin:(NSString *)wx_openid nickname:(NSString *)nickname sex:(NSString *)sex province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl unionid:(NSString *)unionid returnJID:(NSMutableString*)jid1 returnLoginID:(NSMutableString *)loginID returnPassword:(NSMutableString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList
{
    NSString* result=nil;
    @try {
        NSString *portalVersion=[MainTabViewController getPortalLocalVersion];
        portalVersion=@"";

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              WEFAFA_APPID,@"appid",
                              @"meibang",@"code",
                              WEFAFA_ENO,@"eno",
                              wx_openid,@"openid",
                              nickname,@"nickname",
                              sex,@"sex",
                              province,@"province",
                              city,@"city",
                              headimgurl,@"headimgurl",
                              unionid,@"unionid",
                              SNS_COMEFROM,@"logintype",
                              @"all",@"datascope",
                              portalVersion, @"portalversion",
                              nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_WEIXIN_LOGIN PostParam:dict];
        
#ifdef DEBUG
        NSLog(@"SNS_WEIXIN_LOGIN=%@",[dict JSONString]);
        NSLog(@"%s %@", __FUNCTION__, rst);
#endif
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            if ([returncode isEqualToString:SNS_RETURN_SUCCESS])
            {
                self.openid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"openid"]];
                self.ldap_uid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"ldap_uid"]];
                [jid1 setString:[resultString objectForKey:@"jid"]];
                [loginID setString:[resultString objectForKey:@"login_account"]];
                [pwd setString:[resultString objectForKey:@"des"]];
                self.jid=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"jid"]];
                self.password=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"des"]];
                self.isThirdLogin=YES;
                
                /////
                if (resultString[@"portalconfig_xml"]!=nil||resultString[@"portalconfig_version"]!=nil)//![[resultString objectForKey:@"portalconfig_version"] isEqualToString:portalVersion])
                {
                    [MainTabViewController savePortalLocalVersion:[resultString objectForKey:@"portalconfig_version"]];
                    
                    NSData* xmlData = [resultString[@"portalconfig_xml"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *xmlDic = [NSDictionary dictionaryWithXMLData:xmlData];//[Utils filterJSONString:resultString[@"portalconfig_xml"]]];
                    [MainTabViewController savePortalConfigLocalData:xmlDic];
                }
                
                if (resultString[@"info"]!=nil)
                {
                    [mySelfStaffInfo setJSONValue:resultString[@"info"]];
                	[_myStaffCard setJSONValue:resultString[@"info"]];
                }
                
                if (resultString[@"rosters"]!=nil)
                {
                    for (NSDictionary *staffDict in resultString[@"rosters"])
                    {
                        SNSStaffFull *staff = [[SNSStaffFull alloc] init];
                        [staff setJSONValue:staffDict];
                        [rosterList addObject:staff];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//腾讯qq登录后请调用该接口进行登录
//【链接】
///api/http/thirdparty/tencentlogin
//【参数】
//参数名	描述
//appid	应用id
//code	应用code码
//eno	企业号
//openid	普通用户的标识，对当前开发者帐号唯一
//nickname	普通用户昵称
//gender	用户性别：男、女
//province	省份
//city	城市
//figureurl_2	用户头像
//logintype	登录来源
//00－Wefafa Web
//01－Wefafa Android
//02－Wefafa iPhone
//03－Wefafa PC
//【返回数据】
//属性名	类型	描述
//returncode	字符串	见返回码描述
//openid	字符串	用户openid
//jid	字符串	用户Jid
//注：和微信登录不同的是性别传入参数为gender且为中文，头像为figureurl_2参数。
-(NSString *)snsQQLogin:(NSString *)wx_openid nickname:(NSString *)nickname gender:(NSString *)gender province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl returnJID:(NSMutableString*)jid1 returnLoginID:(NSMutableString *)loginID returnPassword:(NSMutableString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList
{
    NSString* result=nil;
    @try {
        NSString *portalVersion=[MainTabViewController getPortalLocalVersion];
        portalVersion=@"";

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              WEFAFA_APPID,@"appid",
                              @"meibang",@"code",
                              WEFAFA_ENO,@"eno",
                              wx_openid,@"openid",
                              nickname,@"nickname",
                              gender,@"gender",
                              province,@"province",
                              city,@"city",
                              headimgurl,@"figureurl_2",
                              SNS_COMEFROM,@"logintype",
                              @"all",@"datascope",
                              portalVersion, @"portalversion",
                              nil];
        NSString *rst=[self ASIPostJSonRequest:SNS_QQ_LOGIN PostParam:dict];
        
#ifdef DEBUG
        NSLog(@"SNS_QQ_LOGIN=%@",[dict JSONString]);
        NSLog(@"%s %@", __FUNCTION__, rst);
#endif
        
        if ([rst length]>0)
        {
            NSDictionary *resultString = [rst objectFromJSONString];
            NSString *returncode=[resultString objectForKey:@"returncode"];
            result=[[NSString alloc] initWithFormat:@"%@",returncode];
            if ([returncode isEqualToString:SNS_RETURN_SUCCESS])
            {
                self.openid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"openid"]];
                self.ldap_uid=[[NSString alloc] initWithFormat:@"%@",[resultString objectForKey:@"ldap_uid"]];
                [jid1 setString:[resultString objectForKey:@"jid"]];
                [loginID setString:[resultString objectForKey:@"login_account"]];
                [pwd setString:[resultString objectForKey:@"des"]];
                self.jid=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"jid"]];
                self.password=[NSString stringWithFormat:@"%@",[resultString objectForKey:@"des"]];
                self.isThirdLogin=YES;
                
                
                /////
                if (resultString[@"portalconfig_xml"]!=nil||resultString[@"portalconfig_version"]!=nil)//![[resultString objectForKey:@"portalconfig_version"] isEqualToString:portalVersion])
                {
                    [MainTabViewController savePortalLocalVersion:[resultString objectForKey:@"portalconfig_version"]];
                    
                    NSData* xmlData = [resultString[@"portalconfig_xml"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *xmlDic = [NSDictionary dictionaryWithXMLData:xmlData];//[Utils filterJSONString:resultString[@"portalconfig_xml"]]];
                    [MainTabViewController savePortalConfigLocalData:xmlDic];
                }
                
                if (resultString[@"info"]!=nil)
                {
                    [mySelfStaffInfo setJSONValue:resultString[@"info"]];
                	[_myStaffCard setJSONValue:resultString[@"info"]];
                }
                
                if (resultString[@"rosters"]!=nil)
                {
                    for (NSDictionary *staffDict in resultString[@"rosters"])
                    {
                        SNSStaffFull *staff = [[SNSStaffFull alloc] init];
                        [staff setJSONValue:staffDict];
                        [rosterList addObject:staff];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    
    if (result==nil)
        result=[[NSString alloc] initWithFormat:@"%@",SNS_RETURN_SYSERROR];
    
    return result;
}

//totype	分享的平台类型，分享到其他网站或者平台上,暂时支持微信朋友圈\QQ空间。不指定时默认为wefafa平台。
//当openids\groupid\circleid存在时无效。
//openids	消息接收人帐号，若多个，以逗号分隔
//groupid	消息分享到指定群组的群组编号
//circleid	消息分享到指定圈子的圈子编号。朋友圈固定为9999。
//content	分享内容的描述。
//imgurl	分享的图片地址
//iosclass	打开分享内容时的iPhone模块限定类名。iPhone端的该模块需在默认启动方法中处理。
//androidclass	打开分享内容时的Android模块限定类名。Android端的该模块需在默认启动方法中处理，如onCreate中。
//bizdata	消息的实际业务标识数据。在实际处理模块时需要处理该参数并正确显示界面数据。
- (NSString *)sendShareDesigner:(NSString*)share shareList:(NSDictionary *)shareList
{
    NSString *result=nil;
    @try {
        NSDictionary *dicResult=[self getJSON:SNS_SEND_SNSSHARE PostParam:shareList];
        
        result = dicResult[@"returncode"];
        if ([result isEqualToString:SNS_RETURN_SUCCESS])
        {
//            for (NSDictionary *staff in dicResult[@"staffs"])
//            {
//                SNSStaff *snsstaff=[[SNSStaff alloc] init];
//                [snsstaff setJSONValue:staff];
//                [designerList addObject: snsstaff];
//            }
        }
    }
    @catch (NSException *exception) {
    }
    return result;
}
- (NSDictionary *)sendePic:(NSString *)requestName withValue:(NSDictionary *)postValue withFileName:(NSString *)fileName;
{
    NSDictionary *result=[NSDictionary new];
    @try {

        NSString *rst=[self ASIPostJSonRequest:SEND_FILE PostParam:postValue];

//        NSLog(@"dicResult---%@",rst);
        
        result = [rst JSONValue];
        
    }
    @catch (NSException *exception) {
    }
    return result;
}
-(NSData *)receivePicWithFileName:(NSString *)fileName withFilePathName:(NSString *)PathFileName;
{
    NSData *resultData=[[NSData alloc]init];
    @try {
        
        resultData=[self ASIPostJSonRequest:RECEIVE_FILE FileName:fileName];
        if ([resultData length]>0)
        {
           
        }
//        NSLog(@"dicResult---%@",resultData);
    }
    @catch (NSException *exception) {
    }
    return resultData;
}
@end
