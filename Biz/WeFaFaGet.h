//
//  WeFaFaGet.h
//  Wefafa
//
//  Created by fafa  on 13-6-28.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNSDataClass.h"

#define SNS_RETURN_SUCCESS @"0000"   //成功
#define SNS_RETURN_NO_LOGIN @"0001"   //未登录
#define SNS_RETURN_ACCERROR @"0002"   //用户名或密码错误
#define SNS_RETURN_NOPERMIT @"0003"   //无权限，比如无权删除、无权浏览
#define SNS_RETURN_OTHER @"0004"   //其他错误
#define SNS_RETURN_REQUEST_CIRCLE_FIVE @"0006"   //申请圈子数超过5个
#define SNS_RETURN_SYSERROR @"9999"   //系统错误

typedef enum
{
    SNS_IMAGE_ORIGINAL = 0,
    SNS_IMAGE_MIDDLE,
    SNS_IMAGE_SMALL,
    SNS_IMAGE_Size //4.20新加
}IMAGE_SIZE;

typedef enum
{
    MICRO_USE_PUSHMSG, // 推送消息 公众号
    MICRO_USE_PROXY,  //1 业务代理 微应用
}MICRO_USE_TYPE;

@interface JSonPost : NSObject
{
}

- (BOOL)ASIPostJSonRequestURL:(NSString *)urlString PostParam:(NSDictionary *)dict result:(NSMutableString *)result;
- (NSString *)ASIPostJSonRequest:(NSString *)subpath PostParam:(NSDictionary *)dict;

@end

@interface WeFaFaGet : JSonPost

@property (nonatomic) BOOL isLogin;
@property (nonatomic,retain) SNSStaffFull *myStaffCard;

@property (nonatomic,retain) NSString *openid;
@property (nonatomic,retain) NSString *ldap_uid; //login UserId

@property (nonatomic,retain) NSString *jid;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,assign) BOOL isThirdLogin;

@property (nonatomic,assign) BOOL shareOrLogin;//判断是否是第三方登陆还是分享 yes share no login



-(NSString *)getJID:(NSString *)loginaccount;

//会员信息
@property (nonatomic) int userLevel;
@property (nonatomic,retain) NSString *gender;
@property (nonatomic,retain) NSString *isActive;

//登录
//-(NSString *)snsLogin:(NSString *)account Password:(NSString *)pwd;
-(NSString *)snsLogin:(NSString *)account Password:(NSString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList;

//获取圈子
-(NSString *)getCircles:(NSMutableArray *)circles;

//创建圈子
-(NSArray *)createCircle:(NSString *)circleName CircleDesc:(NSString *)circleDesc JoinMethod:(NSString *)joinMethod AllowCopy:(NSString *)allowCopy CircleClassid:(NSString *)circleClassId LogoPath:(NSString *)logoPath LogoPathSmall:(NSString *)logoPathSmall LogoPathBig:(NSString *)logoPathBig returnMsg:(NSMutableString *)returnMsg;
//获取群组信息
-(NSDictionary *)getGroupInfo:(NSString *)groupId;
//邀请成员关注圈子
-(NSString *)inviteCircleMember:(NSString *)circleid InvitedMemebers:(NSString *)invitedmemebers;
//退出圈子
-(NSString *)exitCircle:(NSString *)jid Circleid:(NSString *)circleid;
//获取圈子分类数据集合
-(NSString *)getCircleClasses:(NSMutableArray *)circleclasss;
//取圈子人员
-(NSArray *)getCircleStaff:(NSString *)circleid;

-(NSString *)updateCircle:(SNSCircle *)snsCircle Circle:(SNSCircle *)circle;

//创建群
-(SNSGroup *)createGroup:(NSString *)circleid GroupName:(NSString *)groupname GroupDesc:(NSString *)groupdesc JoinMethod:(NSString *)joinMethod GroupClassid:(NSString *)groupclassid GroupPhotoPath:(NSString *)groupphotopath returnMsg:(NSMutableString *)returnMsg;
//邀请成员加入群
-(NSString *)inviteGroupMember:(NSString *)circleid Groupid:(NSString *)groupid GroupName:(NSString *)groupname FafaGroupid:(NSString *)fafagroupid InvitedMemebers:(NSString *)invitedmemebers;
//退出群
-(NSString *)exitGroup:(NSString *)jid Circleid:(NSString *)circleid Groupid:(NSString *)groupid;

//获取群
-(NSString *)getGroupsByCircleID:(NSString *)circleid Groups:(NSMutableArray *)groups;
//获取会话
-(NSString *)getConvsByCircleID:(NSString *)circleid Groups:(NSString *)groupid LastID:(NSString *)lastid Convs:(NSMutableArray *)convs;
-(NSArray*)getUnreadConvs:(NSString*)circle_id group_id:(NSString*)group_id max_id:(NSString*)max_id;
-(NSString *)getConvsByConvID:(NSString*)convid Conv:(SNSConv**)conv;
-(NSArray*)getReplys:(NSString*)conv_id pageindex:(NSNumber*)pageindex;
//
-(NSData *)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName;
//-(void)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName CellView:(UITableViewCell*)cellView JID:(NSString *)jid IsGrey:(BOOL)isgrey Delegate:(id)dg;
//-(NSData *)getFile:(NSString *)fileID;
-(NSString *)uploadFile:(NSString *)filename FileDataBase64:(NSString *)filedata CircleID:(NSString *)circleid GroupID:(NSString *)groupid FileID:(NSMutableString *)fileID;
-(NSString *)getStaffCard:(NSString *)staffid StaffCard:(SNSStaffFull **)staff_full;
//设置关注
-(NSString *)setAttenStaff:(NSString *)staffID IsAtten:(BOOL)isAtten returnMsg:(NSMutableString *)returnMsg;
//获取关注者
-(NSString *)getAttenStaffs:(NSString *)staffID Staffs:(NSMutableArray *)staffs;

//获取粉丝
-(NSString *)getAttenStaffsFans:(NSString *)staffID Staffs:(NSMutableArray *)staffs;


////获取主页用户的会话
//-(NSString *)getUserConvs:(NSString *)circleid Staff:(NSString *)staffid LastID:(NSString *)lastid Convs:(NSMutableArray *)convs;
//发动态/提问
-(NSString *)sendTrendConv:(NSString *)content Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv IsAsk:(BOOL)isask;
//动态分享
-(NSString *)sendShareConv:(NSString *)content Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv IsAsk:(BOOL)isask;
//发活动
-(NSString *)sendTogetherConv:(NSString *)title StartDate:(NSString *)datestr During:(NSString *)during Address:(NSString *)addr Desc:(NSString *)desc Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv;
//发投票
-(NSString *)sendVoteConv:(NSString *)conv_content IsMulti:(NSString *)is_multi FinishDate:(NSString *)finishdate OptionValues:(NSString *)optionvalues Attachs:(NSString *)attachs CircleID:(NSString *)circleid GroupID:(NSString *)groupid Conv:(SNSConv **)conv;
////投票
-(NSString *)convVote:(NSString *)conv_id IsMulti:(NSString *)is_multi Optionids:(NSString *)optionids Conv:(SNSConv **)conv;
////回复
-(NSString *)convReply:(NSString *)conv_id ReplayValue:(NSString *)replayvalue ReplyTo:(NSString *)reply_to ReplyToName:(NSString *)reply_to_name Attachs:(NSString *)attachs ReturnReply:(SNSReply **)reply;
//赞,isSetLike:1赞，0取消赞
-(NSString *)convLike:(NSString *)conv_id LikeStaff:(NSMutableString *)like_staff NickName:(NSMutableString *)nick_name IsSetLike:(BOOL)isSetLike;
//获取转发权限
//-(NSString *)getConvAllowCopy:(NSString *)circle_id AllowCopy:(int *)allow_copy;
//转发
-(NSString *)convCopy:(NSString *)conv_content CopyConvID:(NSString *)copy_id ConvID:(NSString *)copy_last_id CircleID:(NSString *)circle_id GroupID:(NSString *)group_id Conv:(SNSConv **)conv;
//收藏,isSetLike:1收藏，0取消收藏
-(NSString *)convAtten:(NSString *)conv_id IsSetAtten:(BOOL)isSetAtten;
//参加活动, isTogether:1参加，0退出
-(NSString *)convTogether:(NSString *)conv_id IsTogether:(BOOL)isTogether JoinStaff:(NSMutableString *)join_staff NickName:(NSMutableString *)nick_name;
////未读公告数
//-(NSString *)GetBulletinUnreadNum:(int *)num;
////未读公告
//-(NSString *)getBulletinUnread:(NSMutableArray *)bulletins;
////读15tiao公告数
//-(NSString *)getBulletinByCirecleID:(NSString *)circleid Groups:(NSString *)groupid LastID:(NSString *)lastid Convs:(NSMutableArray *)bulletins;
////发布公告数
//-(NSString *)pushBulletinByCirecleID:(NSString *)circleid Groups:(NSString *)groupid BulletinDesc:(NSString *)bulletin_desc;
////未读消息数
//-(NSString *)GetMessageUnreadNum:(int *)num;
////未读消息
//-(NSString *)getMessageUnread:(NSMutableArray *)messages;
////读15tiao消息
//-(NSString *)getMessageByLastID:(NSString *)lastid Convs:(NSMutableArray *)messages;
////发消息（staffs：消息接收人帐号，若多个，以逗号分隔）
//-(NSString *)pushMessageToStaffs:(NSString *)staffs Title:(NSString *)title Content:(NSString *)content;
////提到自己数
//-(NSString *)GetAtMeUnreadNum:(int *)num;
//取得15条提到我的信息
-(NSString *)getAtMeUnreadByLastID:(NSString *)lastid Convs:(NSMutableArray *)convs;

//-(NSString *)registerCheckMail:(NSString *)email Msg:(NSMutableString *)msg IsPublicMail:(NSMutableString *)ispublic ENO:(NSMutableString *)eno EName:(NSMutableString *)ename;
//-(NSString *)registerSubmit:(NSString *)email IsPublic:(NSString *)is_public ENO:(NSString *)eno Script:(NSString *)postscript;
//-(NSString *)registerActive:(NSString *)email NickName:(NSString *)nick_name ENO:(NSString *)eno ActiveCode:(NSString *)active_code Password:(NSString *)password;
-(NSString *)registerGetEnterprise:(NSMutableArray *)enterprises EnterpriseName:(NSString *)ename;
//-(NSString *)getRegisterInfo:(NSString *)email ENO:(NSMutableString *)eno IsApprove:(NSMutableString *)is_approve;
//-(void)getStaffCardAsyn:(NSString *)staffid Param:(id)userparam Delegate:(id)asyn_delegate;
-(NSString *)mobileRegistGetVaildCode:(NSString*)txtmobile TipMsg:(NSMutableString *)tipmsg;
- (NSString *)registerActiveWithDictionary:(NSDictionary *)dict tipMsg:(NSMutableString *)tipmsg;
-(NSString *)registerActive:(NSString *)mobile_num Password:(NSString *)mobile_pwd ENO:(NSString *)eno Ename:(NSString *)ename NickName:(NSString *)nick_name ActiveCode:(NSString *)active_code TipMsg:(NSMutableString *)tipmsg;

-(void)mobilebindGetVaildCode:(NSString*)txtmobile result:(NSMutableDictionary*)result;
-(void)mobilebindSave:(NSString*)txtmobile txtvaildcode:(NSString*)txtvaildcode result:(NSMutableDictionary*)result;
-(void)mobilebindRemove:(NSString*)nilpara result:(NSMutableDictionary*)result;
-(void)mobilebindGetVaildCode_newInterface:(NSString*)txtmobile result:(NSMutableDictionary*)result;
-(void)mobilebindSave_newInterface:(NSString*)txtmobile txtvaildcode:(NSString*)txtvaildcode result:(NSMutableDictionary*)result;

-(NSString*)getForgetPasswdUrl;

-(void)errReport:(NSString*)errmsg;

+(UIImage *)getImage:(IMAGE_SIZE)imagesize ImageName:(NSString *)imgName;
+(UIImage *)getFile:(NSString *)fileID FileName:(NSString *)fileName FileExt:(NSString *)fileExt imagesize:(IMAGE_SIZE)imagesize;

-(void) DownloadFile_Asyn:(NSString *)fileID FileExt:(NSString *)fileExt CachePath:(NSString *)cachePath imagesize:(IMAGE_SIZE)imagesize ImageCallback:(void (^)(UIImage * image))imageBlock ErrorCallback:(void (^)(void))errorBlock;

//5.13	根据邮箱获取好友信息,只返回前10条
-(NSArray*)getStaffByEmail:(NSString*)email;
//5.14	根据手机号获取好友信息,只返回前10条
-(NSArray*)getStaffByMobile:(NSString*)mobile;
//5.15	根据姓名获取好友信息,只返回前10条
-(NSArray*)getStaffByName:(NSString*)name;

-(void)submitURL:(NSString *)fullpath;

-(NSArray*)getMyMicroaccount:(MICRO_USE_TYPE)micro_use;
-(NSArray*)queryMicroaccount:(NSString*)microaccount MicroUseType:(MICRO_USE_TYPE)micro_use;
-(BOOL)attenMicroaccount:(NSString*)microaccount attenList:(NSMutableArray*)attenList;
-(void)unattenMicroaccount:(NSString*)microaccount;

-(NSArray*)getRecomUser:(int)pageindex PageSize:(int)pagesize;
-(NSArray*)getRecomCircle:(int)pageindex PageSize:(int)pagesize CircleName:(NSString *)circlename;
-(NSString *)joinCircle:(NSString *)circleid returnMsg:(NSMutableString *)msg;
-(NSString *)getCircleActivateUser:(NSString *)circle_id Staffs:(NSMutableArray *)staffs;
-(NSArray *)getPersonalTag:(NSString *)account;
-(NSMutableArray *)getAuthUserList:(int)pageindex PageSize:(int)pagesize;
-(NSString *)userIdentifyAuth:(NSString *)recver memo:(NSString *)memostr returnMsg:(NSMutableString *)msg;
-(NSString *)enterpriseAuthFile:(NSString *)fileid returnMsg:(NSMutableString *)msg;
-(NSArray*)queryCircles:(int)pageindex PageSize:(int)pagesize CircleName:(NSString *)circlename CircleClass:(NSString *)circleclass CircleID:(NSString *)circleid;
-(NSString *)getPasswordValidCode:(NSString *)account returnFlag:(NSMutableString *)flag returnRetrieveID:(NSMutableString *)retrieve_id returnMsg:(NSMutableString *)msg;
//MB忘记密码短信获取到新密码
-(NSString *)resetPassword:(NSString *)account txtvaildcode:(NSString*)txtvaildcode returnMsg:(NSMutableString *)msg;
-(NSString *)resetPassword:(NSString *)account txtvaildcode:(NSString*)txtvaildcode retrieve_id:(NSString*)retrieve_id txtnewpwd:(NSString *)txtnewpwd returnMsg:(NSMutableString *)msg;
-(NSString *)modifyPassword:(NSString*)oldpwd newpwd:(NSString *)newpwd returnMsg:(NSMutableString *)msg;
-(NSDictionary *)getMeetingInfo:(NSString *)meetingid;

-(NSString *)uploadCircleLogo:(NSString *)filedata Circleid:(NSString *)circleid Fileids:(NSMutableDictionary *)fileids;

-(NSString *)uploadGroupLogo:(NSString *)filedata Circleid:(NSString *)circleid Groupid:(NSString *)groupid Fileids:(NSMutableDictionary *)fileids;
-(NSString *)updateGroup:(SNSGroup *)saveGroup Group:(SNSGroup *)newGroup;

-(NSString *)uploadMyHeadPhotoWithFileData:(NSData *)photodata Fileids:(NSMutableDictionary *)fileids;
-(NSString *)updateMyInfo:(SNSStaffFull *)snsStaffFull;
-(NSArray *)getDepts;

-(NSDictionary*)ssoBind:(NSString*)appid openid:(NSString*)openid auth:(NSString*)auth;
-(NSDictionary*)ssoUnBind:(NSString*)appid openid:(NSString*)openid;
-(NSDictionary*)ssoGetAuth:(NSString*)appid openid:(NSString*)openid;

-(NSArray*)searchStaffs:(NSString*)value page:(int)page;
-(NSArray*)searchDesigner:(NSString*)value page:(int)page;
-(NSString *)getAttenDesigner:(NSString*)staffid designerList:(NSMutableArray *)designerList;
//分享
-(NSString *)sendShareDesigner:(NSString*)share shareList:(NSDictionary *)shareList;
-(NSString *)snsWeiXinLogin:(NSString *)wx_openid nickname:(NSString *)nickname sex:(NSString *)sex province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl unionid:(NSString *)unionid returnJID:(NSMutableString*)jid returnLoginID:(NSString *)loginID returnPassword:(NSMutableString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList;
-(NSString *)snsQQLogin:(NSString *)wx_openid nickname:(NSString *)nickname gender:(NSString *)gender province:(NSString *)province city:(NSString *)city headimgurl:(NSString *)headimgurl returnJID:(NSMutableString*)jid returnLoginID:(NSMutableString *)loginID returnPassword:(NSMutableString *)pwd mySelfStaffInfo:(SNSStaffFull *)mySelfStaffInfo rosterList:(NSMutableArray *)rosterList;
//新的上传图片方式
- (NSDictionary *)sendePic:(NSString *)requestName withValue:(NSDictionary *)postValue withFileName:(NSString *)fileName;
//接收图片
-(NSData *)receivePicWithFileName:(NSString *)fileName withFilePathName:(NSString *)PathFileName;;
-(NSArray *)getAttenUserIdList:(NSMutableArray*)userIdlist;
//适应新版本图片url。
- (NSString *)getHeadImgUrlWithImageName:(NSString *)imgName WithSize:(IMAGE_SIZE)imagesize;
@end

extern WeFaFaGet *sns;