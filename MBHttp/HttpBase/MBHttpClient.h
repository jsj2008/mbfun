//
//  MBHttpClient.h
//  Wefafa
//
//  Created by su on 15/3/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "MBHttpBase.h"
#import "MBHttpCode.h"
#import "NetUtils.h"

typedef void(^RequestSuccessBlock) (NSDictionary *dict);
typedef void(^RequestFailedBlock) (NSError *error);

@interface MBHttpClient : AFHTTPRequestOperationManager

+ (MBHttpClient *)shareClient;

//当前网络状态
// NotReachable     - 没有网络连接
// ReachableViaWWAN - 移动网络(2G、3G)
// ReachableViaWiFi - WIFI网络
//- (NetworkStatus)netWorkStatus;

//get请求
- (void)mbGetRequestPath:(NSString *)path               //请求路径
              serverName:(NSString *)server             //服务名称
              methodName:(NSString *)method             //方法名
                  params:(NSDictionary *)param          //请求参数
                 success:(RequestSuccessBlock)success   // 成功回调
                  failed:(RequestFailedBlock)failed;    //失败回调

//post请求
- (void)mbPostRequestPath:(NSString *)path               //请求路径
              serverName:(NSString *)server             //服务名称
              methodName:(NSString *)method             //方法名
                  params:(NSDictionary *)param          //请求参数
                 success:(RequestSuccessBlock)success   // 成功回调
                  failed:(RequestFailedBlock)failed;    //失败回调

//不需要 token的网络请求
- (void)mbRequestWithOutTokenWithDomian:(NSString *)domain
                                   Path:(NSString *)path
                                  param:(NSDictionary *)params
                                success:(RequestSuccessBlock)success
                                 failed:(RequestFailedBlock)failed;
//获取验证码 等。。。
- (void)mbRequestWithPath:(NSString *)path
                         param:(NSDictionary *)params
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed;

@end
