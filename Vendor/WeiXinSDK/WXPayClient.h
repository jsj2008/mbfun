//
//  WXPayClient.h
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiXinUtils.h"
#import "CommonEventHandler.h"

/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
//NSString * const WXAppId = @"wxd930ea5d5a258f4f";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
extern NSString * const WXAppKey;

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
//NSString * const WXAppSecret = @"db426a9829e4b49a0dcac7b4162da6b6";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
extern NSString * const WXPartnerKey;

/**
 *  微信公众平台商户模块生成的ID
 */
extern NSString * const WXPartnerId;


////////////////////////////////

extern NSString * const HUDDismissNotification;

@interface WXPayClient : NSObject
{
    CommonEventHandler *onWXPayProductEvent;
}
+ (instancetype)shareInstance;

- (void)payProduct:(CommonEventHandler *)payProductComplete payAccountInfo:(NSDictionary *)payAccountInfo;
-(void)payCompleteCallback:(id)param;

//apP_ID	String
//apP_SECRET	String
//paY_SIGN_KEY	String
//partneT_NAME	String
//partneT_KEY	String
@property (nonatomic,strong) NSDictionary *payAccountInfo;
@property (nonatomic,strong) NSMutableDictionary *orderInfo;

@end

extern WXPayClient *wxPayClient;
