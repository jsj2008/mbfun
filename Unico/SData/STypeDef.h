//
//  STypeDef.h
//  Story
//
//  Created by Ryan on 15/4/26.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import <Foundation/Foundation.h>
// 文章的打开模式，阅读和预览模式
typedef enum{
    TopicViewTypeRead=0,  // 只读模式
    TopicViewTypePreview, // 发布前预览
    TopicViewTypeEdit // 编辑模式
} TopicViewType;

// 专题类型
typedef enum{
    TopicTypeSpecial=1,  // 编辑专题
    TopicTypeCustom     // 用户原创
} TopicType;


typedef enum{
    TopicButtonType=10001,  // 全部专题
    SpecialButtonType,     // 精选专题
    AttentionButtonType,     // 关注专题
    TopicButtonLine,
    SpecialButtonLine,
    AttentionButtonLine
} buttonType;

// profile类型
typedef enum{
    ProfileMineType=1,  //我的
    ProfileOtherType     //其他人
} ProfileType;

//关注类型
typedef enum{
    AttentEachType=1,  //互相关注
    AttentOtherType,     //关注其他人
    AttentByOtherType,  //被其他人关注
    AttentNoneType      //未关注
} AttentType;

//注册 tag类型
typedef enum{
    TagPhoneType=10001,
    TagPasswordType,
    TagVerifyCodeType,
    TagFetchVerifyCodeButtonType
} TagRegisterType;

// 画面切换类型
typedef enum{
    STransitionTypeLeftToRight =0,
    STransitionTypeRightToLeft     
} STransitionType;

//profile 列表类型
enum{
    ProfileListAttentType = 1,//关注列表
    ProfileListFansType        //粉丝列表
}SProfileControllerListType;

//性别
enum{
    GirlType = 0,  //女生
    BoyType        //男生
}SProfileSexType;

typedef enum CoverTagType {
    CoverTagTypeItem = 0,
    CoverTagTypeBrand,
    CoverTagTypePerson,
    CoverTagTypeTopic
} CoverTagType;


#pragma mark - block
typedef void(^SVoidFunc)();
typedef void(^SNetworkSucFunc)( AFHTTPRequestOperation* operation,id object);
typedef void(^SNetworkFailFunc)( AFHTTPRequestOperation* operation,NSError* error);
typedef void(^SObjectFunc)(id object);
typedef void(^SFloatFunc)(float num);
typedef void(^SCoverForkFunc)(NSString* json);
typedef void(^SDataArrayFunc)(NSArray* data);
typedef void(^SDataResponseFunc)(NSArray *data,NSError *error);
typedef void(^FailureResponseError)(NSError *error);
typedef void(^SDataBoolFunc)(BOOL flag);
typedef void(^SDataVoidFunc)();
typedef void(^SDataStringFunc)(NSString* str);
// 选择品牌
typedef void(^SDataTagSelectFunc)(NSString* tid,NSString* tname,NSString *key);
// 上传视频
typedef void(^SDataVideoFunc)(NSURL *url, NSError *error);

typedef void(^SDataFilterFunc)(NSArray *data);

@interface STypeDef : NSObject
@end
