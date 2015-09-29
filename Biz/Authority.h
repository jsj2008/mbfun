//
//  Authority.h
//  Wefafa
//
//  Created by mac on 13-10-15.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CIRCLE_TYPE
{
    CIRCLE_TYPE_USER=9999,
    CIRCLE_TYPE_WE_SQUARE=10000
}CIRCLE_TYPE;

typedef enum AUTHORITY_FUNCTION
{
    //<10000
    AUTHORITY_FUNCTION_PUBLISH_WE,//We广场_发动态 o
    AUTHORITY_FUNCTION_TREND_VIEW_WE,//We广场_查看动态 o
    AUTHORITY_FUNCTION_TREND_WE,//We广场_评论回复动态 o
    AUTHORITY_FUNCTION_RECOMM_ATTEN,//人脉圈子-关注人脉及企业 o
    AUTHORITY_FUNCTION_RECOMM_TREND_VIEW,//人脉圈子-动态查看 o
    AUTHORITY_FUNCTION_RECOMM_CROUP_CREATE,//人脉圈子_创建群组
    AUTHORITY_FUNCTION_RECOMM_TREND_PUBLISH,//人脉圈子_发表动态 o
    AUTHORITY_FUNCTION_RECOMM_TREND_INVITE,//人脉圈子_邀请好友
    AUTHORITY_FUNCTION_ENTERP_GROUP_CREATE,//企业圈子_创建群组 
    AUTHORITY_FUNCTION_ENTERP_TREND_PUBLISH,//企业圈子_发动态 o
    AUTHORITY_FUNCTION_ENTERP_CIRCLE_VIEW,//企业圈子_查看动态 o
    AUTHORITY_FUNCTION_ENTERP_REPLY,//企业圈子_评论回复动态 o
    AUTHORITY_FUNCTION_ENTERP_MANAGER,//企业管理
    AUTHORITY_FUNCTION_MEETING_CREATE,//创建会议
    AUTHORITY_FUNCTION_CIRCLE_CREATE,//外部圈子_创建
    AUTHORITY_FUNCTION_CIRCLE_JOIN,//外部圈子_加入 o
    AUTHORITY_FUNCTION_GROUP_CREATE,//外部圈子_子_创建群组
    AUTHORITY_FUNCTION_CIRCLE_TREND_PUBLISH,//外部圈子_发动态 o
    AUTHORITY_FUNCTION_CIRCLE_SEARCH,//外部圈子_查找 o
    AUTHORITY_FUNCTION_CIRCLE_TREND_VIEW,//外部圈子_查看动态 o
    AUTHORITY_FUNCTION_CIRCLE_REPLY,//外部圈子_评论回复动态 o
    AUTHORITY_FUNCTION_OFFICIAL_RELEASE,//官方发布
    AUTHORITY_FUNCTION_OFFICIAL_RELEASE_VIEW,//官方发布_查看
    AUTHORITY_FUNCTION_APPCENTER,//应用中心
    AUTHORITY_FUNCTION_DOC_WE,//文档管理_We广场
    AUTHORITY_FUNCTION_DOC_RECOMMED,//文档管理_人脉圈子
    AUTHORITY_FUNCTION_DOC_ENTERPRISE,//文档管理_企业圈子
    AUTHORITY_FUNCTION_DOC,//文档管理_外部圈子
    AUTHORITY_FUNCTION_GROUP_SEARCH,//查找群组 o
    AUTHORITY_FUNCTION_ORG_VIEW,//查看组织机构
    AUTHORITY_FUNCTION_FRIEND_ADD,//添加好友 o
    AUTHORITY_FUNCTION_FRIEND_INVITE,//邀请好友
}AUTHORITY_FUNCTION;

typedef enum AUTHORITY_LEVEL
{
    //>10000
    AUTHORITY_FUNCTION_LEVEL_V=10000,// V用户所在企业已通过企业身份认证
    AUTHORITY_FUNCTION_LEVEL_J,// J用户未通过企业内部的身份认证
    AUTHORITY_FUNCTION_LEVEL_N,// N用户所在企业还未通过企业身份认证
    AUTHORITY_FUNCTION_LEVEL_S // S用户企业为付费企业
}AUTHORITY_LEVEL;

////We广场_发动态
//public static final String ROLE_PUBLISH_WE = "PUBLISH_WE";
////We广场_查看动态
//public static final String ROLE_TREND_VIEW_WE = "TREND_VIEW_WE";
////We广场_评论回复动态
//public static final String ROLE_TREND_WE = "TREND_WE";
////人脉圈子-关注人脉及企业
//public static final String ROLE_RE_TREND_ATTEN = "RE_TREND_ATTEN";
////人脉圈子-动态查看
//public static final String ROLE_RE_TREND_VIEW = "RE_TREND_VIEW";
////人脉圈子_创建群组
//public static final String ROLE_CROUP_C_RE = "CROUP_C_RE";
////人脉圈子_发表动态
//public static final String ROLE_RE_TREND_PUBLISH = "RE_TREND_PUBLISH";
////人脉圈子_邀请好友
//public static final String ROLE_RE_TREND_INVITE = "RE_TREND_INVITE";
////企业圈子_创建群组
//public static final String ROLE_GROUP_C_EN = "GROUP_C_EN";
////企业圈子_发动态
//public static final String ROLE_PUBLISH_EN = "PUBLISH_EN";
////企业圈子_查看动态
//public static final String ROLE_EN_CIRCLE_VIEW = "EN_CIRCLE_VIEW";
////企业圈子_评论回复动态
//public static final String ROLE_EN_TREND = "EN_TREND";
////企业管理
//public static final String ROLE_MANAGER_EN = "MANAGER_EN";
////创建会议
//public static final String ROLE_MEETING_C = "MEETING_C";
////外部圈子_创建
//public static final String ROLE_CIRCLE_C = "CIRCLE_C";
////外部圈子_加入
//public static final String ROLE_CIRCLE_JOIN_C = "CIRCLE_JOIN_C";
////外部圈子_子_创建群组
//public static final String ROLE_GROUP_C = "GROUP_C";
////外部圈子_发动态
//public static final String ROLE_CIRCLE_PUBLISH_TREND = "CIRCLE_PUBLISH_TREND";
////外部圈子_查找
//public static final String ROLE_CIRCLE_S = "CIRCLE_S";
////外部圈子_查看动态
//public static final String ROLE_CIRCLE_VIEW_TREND = "CIRCLE_VIEW_TREND";
////外部圈子_评论回复动态
//public static final String ROLE_CIRCLE_REPLY_TREND = "CIRCLE_REPLY_TREND";
////官方发布
//public static final String ROLE_OFFICIAL_RELEASE = "OFFICIAL_RELEASE";
////官方发布_查看
//public static final String ROLE_OFFICIAL_RELEASE_VIEW = "OFFICIAL_RELEASE_VIEW";
////应用中心
//public static final String ROLE_APPCENTER = "APPCENTER";
////文档管理_We广场
//public static final String ROLE_DOC_10000 = "DOC_10000";
////文档管理_人脉圈子
//public static final String ROLE_DOC_9999 = "DOC_9999";
////文档管理_企业圈子
//public static final String ROLE_DOC_EN = "DOC_EN";
////文档管理_外部圈子
//public static final String ROLE_DOC = "DOC";
////查找群组
//public static final String ROLE_GROUP_S = "GROUP_S";
////查看组织机构
//public static final String ROLE_ORG_VIEW = "ORG_VIEW";
////添加好友
//public static final String ROLE_ROSTER_ADD = "ROSTER_ADD";
////邀请好友
//public static final String ROLE_ROSTER_INVITE = "ROSTER_INVITE";
//// V用户所在企业已通过企业身份认证
//public static final String TYPE_AUTHLEVEL_V = "V";
//// J用户未通过企业内部的身份认证
//public static final String TYPE_AUTHLEVEL_J = "J";
//// N用户所在企业还未通过企业身份认证
//public static final String TYPE_AUTHLEVEL_N = "N";
//// S用户企业为付费企业
//public static final String TYPE_AUTHLEVEL_S = "S";

#define AUTHORITY_FUNCTION_ERROR -1

@interface Authority : NSObject

+(int)functionCode:(NSString *)fun_str;
+(BOOL)permission:(int)fm;
+(void)tipNoAccess;
+(NSString *)userAuthorityLevel;
@end
