//
//  WXPayClient.m
//  WechatPayDemo
//
//  Created by Alvin on 3/22/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

#import "WXPayClient.h"
#import "ASIHTTPRequest.h"
#import "Hash.h"
#import "NetUtils.h"
#import "MBShoppingGuideInterface.h"
#import "Utils.h"
#import "InetAddress.h"
#import "HttpRequest.h"
#import "ModelBase.h"
/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
//NSString * const WXAppId = @"wxd930ea5d5a258f4f";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppKey = @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K";

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
NSString * const WXPartnerKey = @"8934e7d15453e97507ef794cf7b0519d";

/**
 *  微信公众平台商户模块生成的ID
 */
NSString * const WXPartnerId = @"1900000109";

NSString *PrePayIdKey = @"prepayid";
NSString *errcodeKey = @"errcode";
NSString *errmsgKey = @"errmsg";
NSString *expiresInKey = @"expires_in";

@interface WXPayClient ()

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, copy) NSString *traceId;

@end

NSString * const HUDDismissNotification = @"HUDDismissNotification";
WXPayClient *wxPayClient=nil;

@implementation WXPayClient

#pragma mark - Public

+ (instancetype)shareInstance 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (wxPayClient==nil)
            wxPayClient = [[WXPayClient alloc] init];
    });
    return wxPayClient;
}

- (void)payProduct:(CommonEventHandler *)payProductComplete payAccountInfo:(NSDictionary *)payAccountInfo
{
    onWXPayProductEvent=payProductComplete;
    _payAccountInfo=payAccountInfo;
//    [self getAccessToken];
    [self getPrepayId:@"fucktoken"];
}

#pragma mark - 生成各种参数

- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 * 注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [Hash md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
//    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
    return [[NSString alloc] initWithFormat:@"%@&%@",_orderInfo[@"out_trade_no"],_orderInfo[@"UserId"]];
}

- (NSString *)genOutTradNo
{
    return [Hash md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genPackage
{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:@"千足金箍棒" forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    [params setObject:@"http://weixin.qq.com" forKey:@"notify_url"];
    [params setObject:[self genOutTradNo] forKey:@"out_trade_no"]; 
    [params setObject:WXPartnerId forKey:@"partner"];
    [params setObject:[InetAddress getLocalHost] forKey:@"spbill_create_ip"];
//    [params setObject:[NetUtils getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:@"1" forKey:@"total_fee"];    // 1 =＝ ¥0.01
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:WXPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[Hash md5:[package copy]] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;  
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];

    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { 
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [Hash sha1:signString];
    NSLog(@"--- Gen sign: Sha1Hash=%@, sha1=%@", result,[Hash Sha1Hash:signString]);
    return result;
}

- (NSMutableData *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr]; // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary]; 
    [params setObject:kWXAPP_ID forKey:@"appid"];
    [params setObject:WXAppKey forKey:@"appkey"];
    [params setObject:self.timeStamp forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:[self genPackage] forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData]; 
}

#pragma mark - 主体流程
//没用
- (void)getAccessToken
{
    NSString *getAccessTokenUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@", _payAccountInfo[@"apP_ID"], _payAccountInfo[@"apP_SECRET"]];
    
    NSLog(@"--- GetAccessTokenUrl: %@", getAccessTokenUrl);
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getAccessTokenUrl]];
    
    __weak WXPayClient *weakSelf = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    [self.request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData] 
                                                             options:kNilOptions 
                                                               error:&error];
        if (error) {
            [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":@"获取 AccessToken 失败"}];
            return;
        }
        NSLog(@"---Token rst %@", [weakRequest responseString]);
        
        NSString *accessToken = dict[@"access_token"];
        if (accessToken) {
            __strong WXPayClient *strongSelf = weakSelf;
            [strongSelf getPrepayId:accessToken];//预订单 token需要
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[errcodeKey], dict[errmsgKey]];
            [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":strMsg}];
        }
    }];
    
    [self.request setFailedBlock:^{
        [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":@"获取 AccessToken 失败"}];
    }];
    [self.request startAsynchronous];
}

- (void)getPrepayId:(NSString *)accessToken
{
    // WX__BEFORE_PAY_URL
    [HttpRequest postRequestPath:kMBServerNameTypeNoWXSCOrder methodName:@"WxPrePayFlowCreate" params:_orderInfo success:^(NSDictionary *dict) {
        NSLog(@"dic微信支付----------%@",dict);
        
        if ([[dict objectForKey:@"isSuccess"] integerValue]== 1)
        {
            if (dict!=nil)
            {
                self.timeStamp = [NSString stringWithFormat:@"%@",dict[@"timeStamp"]];
                NSString *prePayId = dict[@"prePayId"];
                self.traceId = [self genTraceId];
                self.nonceStr =dict[@"nonceStr"];
                
                if (prePayId)
                {
                    PayReq *request   = [[PayReq alloc] init];
                    //                    request.partnerId = [Utils getSNSInteger:_payAccountInfo[@"partneR_ID"]];
                    request.partnerId = WX_PARNER_ID;
                    
                    request.prepayId  = prePayId;
                    request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
                    request.nonceStr  = self.nonceStr;
                    request.timeStamp = [self.timeStamp longLongValue];
                    
                    // 构造参数列表=====支付需要用到
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    //                    [params setObject:_payAccountInfo[@"apP_ID"] forKey:@"appid"];
                    //                    [params setObject:_payAccountInfo[@"paY_SIGN_KEY"] forKey:@"appkey"];
                    [params setObject:WX_APP_ID forKey:@"appid"];
                    [params setObject:WX_APY_SINGN_KEY forKey:@"appkey"];
                    
                    [params setObject:[Utils getSNSString:request.nonceStr]forKey:@"noncestr"];
                    [params setObject:[Utils getSNSString: request.package] forKey:@"package"];
                    [params setObject:[Utils getSNSString: request.partnerId] forKey:@"partnerid"];
                    [params setObject:[Utils getSNSString:request.prepayId] forKey:@"prepayid"];
                    [params setObject:self.timeStamp forKey:@"timestamp"];
                    request.sign = [self genSign:params];
                    
                    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
                    [WXApi safeSendReq:request];
                } else {
                    NSString *msg = [NSString stringWithFormat:@"%@",dict[@"message"]];
                    msg=[Utils getSNSString:msg];
                    
                    if (msg.length==0) {
                        msg=@"生成预订单号失败!";
                    }
                    [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];
                }
            }
            else {
                NSString *msg = [NSString stringWithFormat:@"%@",dict[@"message"]];
                msg=[Utils getSNSString:msg];
                if (msg.length==0) {
                    msg=@"提交订单信息失败!";
                }
                [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];
            }

/*
            if (dict!=nil && dict[@"prePayModel"]!=nil)
            {
                self.timeStamp = dict[@"prePayModel"][@"timestamp"];
                self.nonceStr = dict[@"prePayModel"][@"noncestr"];
                NSString *prePayId = dict[@"prePayModel"][@"prePayId"];
                self.traceId = [self genTraceId];
                
                if (prePayId)
                {
                    PayReq *request   = [[PayReq alloc] init];
//                    request.partnerId = [Utils getSNSInteger:_payAccountInfo[@"partneR_ID"]];
                    request.partnerId = WX_PARNER_ID;

                    request.prepayId  = prePayId;
                    request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
                    request.nonceStr  = self.nonceStr;
                    request.timeStamp = [self.timeStamp longLongValue];
                    
                    // 构造参数列表=====支付需要用到
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                    [params setObject:_payAccountInfo[@"apP_ID"] forKey:@"appid"];
//                    [params setObject:_payAccountInfo[@"paY_SIGN_KEY"] forKey:@"appkey"];
                    [params setObject:WX_APP_ID forKey:@"appid"];
                    [params setObject:WX_APY_SINGN_KEY forKey:@"appkey"];
                    
                    [params setObject:request.nonceStr forKey:@"noncestr"];
                    [params setObject:request.package forKey:@"package"];
                    [params setObject:request.partnerId forKey:@"partnerid"];
                    [params setObject:request.prepayId forKey:@"prepayid"];
                    [params setObject:self.timeStamp forKey:@"timestamp"];
                    request.sign = [self genSign:params];
                    
                    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
                    [WXApi safeSendReq:request];
                } else {
                    NSString *msg = [NSString stringWithFormat:@"%@",dict[@"message"]];
                    msg=[Utils getSNSString:msg];
                    
                    if (msg.length==0) {
                        msg=@"生成预订单号失败!";
                    }
                    [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];
                }
            } else {
                NSString *msg = [NSString stringWithFormat:@"%@",dict[@"message"]];
                msg=[Utils getSNSString:msg];
                if (msg.length==0) {
                    msg=@"提交订单信息失败!";
                }
                [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];
            }
            */

        }
        else
        {
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"message"]];
              msg=[Utils getSNSString:msg];
            if (msg.length==0) {
                msg=@"提交订单信息失败!";
            }
            [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];//@"提交预订单信息失败!"
        }
    } failed:^(NSError *error) {
         NSString *msg = [NSString stringWithFormat:@"%@",error];
        [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];//@"提交预订单信息失败!"
    }];
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *resultDict=[[NSMutableDictionary alloc] initWithCapacity:10];
        NSMutableString *msg=[[NSMutableString alloc] initWithFormat:@""];
        BOOL success=[SHOPPING_GUIDE_ITF requestPostUrlName:@"WxPrePayFlowCreate" param:_orderInfo responseAll:resultDict responseMsg:msg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success)
            {
                self.timeStamp = dict[@"prePayModel"][@"timestamp"];
                self.nonceStr = dict[@"prePayModel"][@"noncestr"];
                NSString *prePayId = dict[@"prePayModel"][@"prePayId"];
                self.traceId = [self genTraceId];
                
                if (prePayId)
                {
                    PayReq *request   = [[PayReq alloc] init];
                    request.partnerId = [Utils getSNSInteger:_payAccountInfo[@"partneR_ID"]];
                    request.prepayId  = prePayId;
                    request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
                    request.nonceStr  = self.nonceStr;
                    request.timeStamp = self.timeStamp.intValue;
                    
                    // 构造参数列表=====支付需要用到
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:_payAccountInfo[@"apP_ID"] forKey:@"appid"];
                    [params setObject:_payAccountInfo[@"paY_SIGN_KEY"] forKey:@"appkey"];
                    [params setObject:request.nonceStr forKey:@"noncestr"];
                    [params setObject:request.package forKey:@"package"];
                    [params setObject:request.partnerId forKey:@"partnerid"];
                    [params setObject:request.prepayId forKey:@"prepayid"];
                    [params setObject:self.timeStamp forKey:@"timestamp"];
                    request.sign = [self genSign:params];
                    
                    // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
                    [WXApi safeSendReq:request];
                } else {
                    [self payCompleteCallback:@{@"returncode":@(NO),@"msg":@"生成预订单号失败!"}];
                }
            } else {
                [self payCompleteCallback:@{@"returncode":@(NO),@"msg":@"提交微信预订单失败!"}];
            }
            else
            {
                [self payCompleteCallback:@{@"returncode":@(NO),@"msg":msg}];//@"提交预订单信息失败!"
            }
        });
    });
     */
}

//未用
- (void)getPrepayIdold:(NSString *)accessToken
{
    //mb服务器发
    //现在时 往微信发 要改为 往美邦发
    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@", accessToken];
#ifdef DEBUG
    NSLog(@"--- GetPrepayIdUrl: %@", getPrepayIdUrl);
#endif
    NSMutableData *postData = [self getProductArgs];
    
    // 文档: 详细的订单数据放在 PostData 中,格式为 json
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [self.request addRequestHeader:@"Content-Type" value:@"application/json"];
    [self.request addRequestHeader:@"Accept" value:@"application/json"];
    [self.request setRequestMethod:@"POST"];
    [self.request setPostBody:postData];
    
    __weak WXPayClient *weakSelf = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    //生成订单
    [self.request setCompletionBlock:^{
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData] 
                                                             options:kNilOptions 
                                                               error:&error];
        
        if (error) {
            [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":@"获取 PrePayId 失败"}];
            return;
        } else {
            NSLog(@"---PrePayIdKey Rst %@", [weakRequest responseString]);
        }
        
        NSString *prePayId = dict[PrePayIdKey];
        
        if (prePayId) {
            NSLog(@"--- PrePayId: %@", prePayId);
            
            // 调起微信支付
            PayReq *request   = [[PayReq alloc] init];
            request.partnerId = WXPartnerId;
            request.prepayId  = prePayId;
            request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
            request.nonceStr  = weakSelf.nonceStr;
            request.timeStamp = [weakSelf.timeStamp longLongValue];
            
            // 构造参数列表=====支付需要用到
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:kWXAPP_ID forKey:@"appid"];
            [params setObject:WXAppKey forKey:@"appkey"];
            [params setObject:request.nonceStr forKey:@"noncestr"];
            [params setObject:request.package forKey:@"package"];
            [params setObject:request.partnerId forKey:@"partnerid"];
            [params setObject:request.prepayId forKey:@"prepayid"];
            [params setObject:weakSelf.timeStamp forKey:@"timestamp"];
            request.sign = [weakSelf genSign:params];
            
            // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
            [WXApi safeSendReq:request];
        } else {
            NSString *strMsg = [NSString stringWithFormat:@"errcode: %@, errmsg:%@", dict[errcodeKey], dict[errmsgKey]];
            [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":strMsg}];
        }
    }];
    [self.request setFailedBlock:^{
        [weakSelf payCompleteCallback:@{@"returncode":@(NO),@"msg":@"获取 PrePayId 失败"}];
    }];
    [self.request startAsynchronous];
}

#pragma mark - Alert

-(void)payCompleteCallback:(id)param
{
    if (onWXPayProductEvent)
        [onWXPayProductEvent fire:self eventData:param];
    //param   no 提示 返回 param-Dic
//    param YES   往 mb 缴费信息 支付成功  获取token  预支付  = 支付 - -支付成功(写入mb)
    [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
}

@end
