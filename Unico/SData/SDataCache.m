//
//  DataCache.m
//  StoryCam
//
//  Created by Ryan on 15/4/20.
//  Copyright (c) 2015年 Unico. All rights reserved.
//

#import "SDataCache.h"
#import "QiniuSDK.h"
#import "AFNetworking.h"
#import "XGPush.h"
#import "Hash.h"
#import "SChatSocket.h"
#import "AppDelegate.h"
#import "SHomeViewController.h"
#import "Toast.h"
#import "HttpRequest.h"
#import "JSON.h"
#import "Utils.h"
#import "NSString+help.h"

typedef void(^CompleteFunc)();

@interface SDataCache(){
    NSString *_serverUrl;
    NSString *_qiniuToken;
    int _savedIndex;
    NSArray *_sourceAry;
    NSMutableArray *_savedAry;
    
    NSString *_coverUrl;
    NSString *_coverJson;
    
    CompleteFunc _completeFunc;
}
@end

@implementation SDataCache
__strong static SDataCache *instance;
@synthesize userInfo = _userInfo;

+(SDataCache*)sharedInstance{
    if (!instance) {
        instance = [SDataCache new];
        
    }
    return instance;
}

-(void)getUploadToken:(void(^)(NSString*token) ) complete {
    if (_qiniuToken) {
        complete( _qiniuToken );
        return;
    }
    
    // get qiniu token
    
    [self quickGet:SERVER_URL parameters:@{@"m":@"Media",@"a":@"getQiniuToken"} success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // upload img to qiniu
        _qiniuToken = (NSString*)[responseObject objectForKey:@"data"];
        complete( _qiniuToken );
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

-(void)dataToLocal:(NSDictionary*)data{
    // TODO: cache in nsdefault
}

-(NSDictionary*)dataFromLocal{
    // TODO : get object from local;
    return nil;
}

//退出登录清除用户信息
- (void)clearUserInfoWhenLogout
{
    _userInfo = [NSDictionary dictionary];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CACHE_SESSION_KEY];
}

#pragma mark - 第三方登录，登录相关
-(NSDictionary*)userInfo{
    if (!_userInfo) {
        _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:CACHE_SESSION_KEY];
    }
    
    return _userInfo;
}

-(NSString*)userToken{
    return [self getKey];
}

-(NSString*)getKey{
    NSString *key = _userInfo[@"token"];
    if (!key) {
        key = @"";
    }
    return key;
}

-(void)setUserInfo:(NSDictionary *)userInfo{
    _userInfo = userInfo;
    if (userInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:CACHE_SESSION_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:CACHE_SESSION_KEY];
    }
    
}

-(void)logout{
    self.userInfo = nil;
}

-(void)loadConfig{
    return;
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:CONFIG_URL parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {
//        NSLog(@"Config Loaded : %@",responseObject[@"data"][0][@"message"]);
//        [RKDropdownAlert title:responseObject[@"data"][0][@"message"]];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        NSLog(@"Config Loaded : %@",error);
    }];
}

#pragma mark - Util functions
- (NSArray*)getArray:(NSString*)json
{
    
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSArray* info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return info;
}

- (NSString*)getJSON:(NSObject*)info
{
    
    if ([NSJSONSerialization isValidJSONObject:info]) {
        NSError* error;
        NSData* registerData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //去掉空格和换行符
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        
        NSRange range = {0,jsonString.length};
        
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        
        NSRange range2 = {0,mutStr.length};
        
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        return mutStr;
    }
    else {
        return nil;
    }
}

-(void)handlerNetworkError:(NSError*)error request:(AFHTTPRequestOperation*)operation{

    // 有处理函数
    if (_failedFunc) {
        _failedFunc(operation,error);
        
        // MARK : call one
        _failedFunc = nil;
    } else {
        if (error) {
            // TODO：请用一个和谐版本的网络失败提示。
//            NSString *info = [NSString stringWithFormat:@"网络不给力...操作失败了:%d",(int)error.code];
//            [RKDropdownAlert title:info];
        }
    }
    
    [MWKProgressIndicator dismiss];
}

-(void)get:(NSString*)m action:(NSString*)a param:(NSDictionary*)data success:(SNetworkSucFunc)suc fail:(SNetworkFailFunc)fail{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:data];
    info[@"m"] = m;
    info[@"a"] = a;
    [self quickGet:SERVER_URL parameters:info success:suc failure:fail];
}

-(void)quickGet:(NSString*)urlStr parameters:(NSDictionary*)data success:(SNetworkSucFunc)suc failure:(SNetworkFailFunc)fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
    dic[@"_platform"] = @(1); // TODO：后面define下，1表示iOS，2表示Android
    if (![dic[@"a"] isEqualToString:@"getUserProductListByCategory"]) {
          dic[@"token"] = [self getKey]; // Mark:所有都会被这边的token覆盖
    }

    // Mark:为了测试环境通过soa token封装接口。
    NSString *soa = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    if (soa) {
        dic[@"_soa"] = soa;
    }
    NSString *server_urlStr=nil;
    
    NSString *phpConfigerUrl=[NSString stringWithFormat:@"%@",PHP_SERVER_CONFIG_URL];
    NSDictionary *configerDic= (NSDictionary *)[phpConfigerUrl JSONValue];
    if ([[configerDic allKeys] containsObject:dic[@"m"]]) {
        NSString *detailUrlStr= [NSString stringWithFormat:@"%@",configerDic[dic[@"m"]]];
        NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
        NSString *noLastUrlStr=detailUrlStr;
        if ([lastStr isEqualToString:@"?"]) {
            noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
        }
        server_urlStr=[NSString stringWithFormat:@"%@",noLastUrlStr];
        NSLog(@"server-----%@",server_urlStr);
        
    }
    else
    {
        server_urlStr=SERVER_URL;
    }
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:server_urlStr parameters:dic success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        //NSLog(@"quickGet responseObject = %@", responseObject);
        
        NSString* status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status intValue] >= 0 ) {
            if(suc)suc(operation,responseObject);
        } else {
            NSDictionary *info = @{
                                   @"-100":@"参数错误",
                                   @"-110":@"内容长度不正确",
                                   @"-1000":@"SOA服务接口响应失败",
                                   @"-101":@"查无此用户",
                                   @"-102":@"验证码验证错误",
                                   @"-103":@"token错误",
                                   };
            NSLog(@"Request Error Info:%@",info[status]);
            NSLog(@"Request Url:%@",operation.request.URL);
            NSLog(@"Return Info:%@",responseObject);
            
            //增加容错处理
            NSString *errString = info[status];
            if (info[status] == nil
                || info[status] == [NSNull null])
            {
                errString = @"未知错误";
            }
            
            
            NSError *error = [NSError errorWithDomain:errString code:[status intValue] userInfo:responseObject];
            if (_failedFunc) {
                _failedFunc(operation,error);
            }
            if (fail) {
                fail(operation,error);
            } else {
                [self handlerNetworkError:error request:operation];
            }
            
            if ([status intValue] == -103 ) {
                NSLog(@"Log out user here");
//                账号登陆失效
                NSString *info = [NSString stringWithFormat:@"您的账号登陆信息已失效，请重新登陆"];
                [RKDropdownAlert title:info];
                [self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];
            }
        }
    
        _failedFunc = nil;
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        // 暂时这样处理。
        if (fail) {
            fail(operation,error);
        } else {
            [self handlerNetworkError:error request:operation];
        }
    }];
}

-(void)quickPost:(NSString*)urlStr parameters:(NSDictionary*)data success:(SNetworkSucFunc)suc failure:(SNetworkFailFunc)fail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
//    dic[@"_platform"] = @(1); // TODO：后面define下，1表示iOS，2表示Android
//    dic[@"token"] = [self getKey]; // Mark:所有都会被这边的token覆盖
    
    // Mark:为了测试环境通过soa token封装接口。
    NSString *soa = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    if (soa) {
//        dic[@"_soa"] = soa;
    }

    NSLog(@"dic－－－－》》》》》poiste---%@",dic);

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
  
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded",@"text/xml",@"text/html",@"text/plain",@"text/json", @"text/javascript",nil];//
    NSString *server_urlStr=nil;
    
    if ([urlStr isEqualToString:WX_BEFORE_PAY_URL]) {
        server_urlStr =WX_BEFORE_PAY_URL;
    }
    else
    {
        NSString *phpConfigerUrl=[NSString stringWithFormat:@"%@",PHP_SERVER_CONFIG_URL];
        NSDictionary *configerDic= (NSDictionary *)[phpConfigerUrl JSONValue];
        if ([[configerDic allKeys] containsObject:dic[@"m"]]) {
            NSString *detailUrlStr= [NSString stringWithFormat:@"%@",configerDic[dic[@"m"]]];
            NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
            NSString *noLastUrlStr=detailUrlStr;
            if ([lastStr isEqualToString:@"?"]) {
               noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            }

            server_urlStr=[NSString stringWithFormat:@"%@?m=%@&a=%@",noLastUrlStr,dic[@"m"],dic[@"a"]];
            NSLog(@"server--post---%@",server_urlStr);
        }
        else
        {
            server_urlStr=[NSString stringWithFormat:@"%@?m=%@&a=%@",SERVER_URL,dic[@"m"],dic[@"a"]];
        }
    }

    
    [manager POST:server_urlStr parameters:dic success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        NSData *dataD=responseObject;
        NSString *dataString =  [[NSString alloc]initWithData:dataD encoding:NSUTF8StringEncoding];
        
        responseObject =[dataString JSONValue];

   /*
    "nonceStr" : "wfgn0q75wb48upe6lf5yd22pb7k0rym7",
    "signType" : "MD5",
    "prePayId" : "wx2015082817554205b6825f7b0710148531",
    "timeStamp" : 1440755742,
    "appId" : "wx8c99f5d8af954939",
    "package" : "prepay_id=wx2015082817554205b6825f7b0710148531",
    "paySign" : "0C4659922B8464EF24F343966413D7E7",
    "isSuccess" : true
    */
        NSLog(@"resonesobject－－－－－%@",responseObject);
        if([[responseObject allKeys]containsObject:@"prePayId"]&&[[responseObject allKeys]containsObject:@"paySign"])
        {
            //微信支付返回
             NSString *isSuccess = [NSString stringWithFormat:@"%@",responseObject[@"isSuccess"]];
            if ([isSuccess isEqualToString:@"true"]||[isSuccess isEqualToString:@"1"]) {
                if(suc)suc(operation,responseObject);
            }
        }
        

        
        NSString* status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        if ([status intValue] >= 0 ) {
            if(suc)suc(operation,responseObject);
        } else {
            NSDictionary *info = @{
                                   @"-100":@"参数错误",
                                   @"-110":@"内容长度不正确",
                                   @"-1000":@"SOA服务接口响应失败",
                                   @"-101":@"查无此用户",
                                   @"-102":@"验证码验证错误",
                                   @"-103":@"token错误",
                                   };
            NSLog(@"Request Error Info:%@",info[status]);
            NSLog(@"Request Url:%@",operation.request.URL);
            NSLog(@"Return Info:%@",responseObject);
            
            //增加容错处理
            NSString *errString = info[status];
            if (info[status] == nil
                || info[status] == [NSNull null])
            {
                errString = @"未知错误";
            }
            
            
            NSError *error = [NSError errorWithDomain:errString code:[status intValue] userInfo:responseObject];
            if (_failedFunc) {
                _failedFunc(operation,error);
            }
            if (fail) {
                fail(operation,error);
            } else {
                [self handlerNetworkError:error request:operation];
            }
            
            if ([status intValue] == -103 ) {
                NSLog(@"Log out user here");
//                账号登陆失效
                NSString *info = [NSString stringWithFormat:@"您的账号登陆信息已失效，请重新登陆"];
                [RKDropdownAlert title:info];
                [self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];
            }
        }
        
        _failedFunc = nil;
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        // 暂时这样处理。
        if (fail) {
            fail(operation,error);
        } else {
            [self handlerNetworkError:error request:operation];
        }
    }];
}

- (void)loginFailed
{
    [[AppDelegate shareAppdelegate] logout];
}

-(void)setPushAccount:(NSString*)account{
    [XGPush setAccount:account];
    
    if (_deviceToken) {
        [XGPush registerDevice:_deviceToken successCallback:^{
            NSLog(@"XG Push Account Suc:%@",account);
        } errorCallback:^{
            NSLog(@"XG Push Account Error");
        }];
    } else {
        // register later
    }
    
}

#pragma mark - mbfun


-(void)loginAccount:(NSString*)account password:(NSString*)pwd json:(NSDictionary*)json{
    // 服务端会通过SOA重新进行账户认证 （但是原本的服务逻辑的登陆有问题，如果没有对单次登陆的session认证，非登陆用户其实也可以调用）
    // 暂时计算一个签名校验参数
    // 也可以所有请求都计算下签名
    NSString *user_id = json[@"id"];
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",account,SIGN_KEY,user_id];
    NSString *sign = [Hash md5:str];
    
    NSData *pwdData = [pwd dataUsingEncoding:NSUTF8StringEncoding];
    pwd = [pwdData base64EncodedStringWithOptions:0];
    
    NSDictionary *data = @{
                           @"m":@"User",
                           @"a":@"login",
                           @"account":account,
                           @"pwd":pwd,
                           @"json":[self getJSON:json],
                           @"sign":sign
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        NSLog(@"REQ:%@,JSON: %@",data, responseObject);
        
        NSString *status = responseObject[@"status"];
        
        if ([status intValue] < 0 ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_LOGIN_FAIL" object:nil];
        } else {
            // 登陆成功
            
            [self setPushAccount:user_id];
            
            NSString *session = responseObject[@"data"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:json];
            dic[@"token"] = session;
            self.userInfo = dic;
            
            // chat server
            // 长链接
            [SChatSocket shared].token = session;
            [SChatSocket shared].userId = user_id;
            [[SChatSocket shared] initSocket];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_LOGIN_SUC" object:nil];
            
            [self getMessageNum];
        }
        
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MBFUN_LOGIN_FAIL" object:nil];
    }];
}

// im 获取未读数
- (void)getMessageNum{
    __weak typeof(SHomeViewController*) whome = [SHomeViewController instance];
    [[SDataCache sharedInstance] get:@"Home" action:@"getHomeDeatDetails" param:@{} success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            UNREAD_ALL_NUMBER = [[object[@"data"] objectForKey:@"messCount"] intValue];
        }
        whome.messageBadge = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
//    m=Message a= getMessageDetaisV2($token)
    /*
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageDetais" param:nil success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            NSDictionary *dic = object[@"data"];
            MAIL_COUNT = [dic[@"mail_count"] intValue];
            MESS_COUNT = [dic[@"mess_count"] intValue];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
     */
    [[SDataCache sharedInstance] get:@"Message" action:@"getMessageDetaisV2" param:nil success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object[@"status"] intValue] == 1) {
            NSDictionary *dic = object[@"data"];
//            MAIL_COUNT = [dic[@"mail_count"] intValue];
//            MESS_COUNT = [dic[@"mess_count"] intValue];
            
            NSDictionary *dict = dic[@"count"];
            UNREAD_ALL_NUMBER = [dict[@"all_count"] intValue];
            COMMENT_COUNT = [dict[@"comment_count"] intValue];
            LIKE_COUNT = [dict[@"like_count"]intValue];
            MESS_COUNT = [dict[@"mess_count"] intValue];
            SYS_COUNT = [dict[@"sys_count"] intValue];
        }
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)uploadbackImgData:(NSDictionary *)info complete:(SDataStringFunc)complete
{
    [self quickGet:SERVER_URL parameters:info success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@",,上传date,,,,,JSON: %@", responseObject);
        
        if (complete) {
            complete(info[@"newBackImg"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
- (void)uploadTagData:(NSDictionary*)info complete:(SDataStringFunc)complete
{
    
    [self quickGet:SERVER_URL parameters:info success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@",,,,,,,JSON: %@", responseObject);
        
        if (complete) {
            complete(@"");
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
//获取发现页的信息
-(void)getFindHomeLayoutInfo:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getFindHomeLayoutInfo"
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

// 获取单个搭配信息
- (void)getCollocationInfo:(NSInteger)collocationId complete:(SDataArrayFunc)complete
{
    NSString *tokenStr = [self getKey];
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getCollocationDetails",
                           @"token":tokenStr,//token不需要检测
                           @"cid":@(collocationId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
       }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [Toast makeToast:kNoneInternetTitle];
        [self handlerNetworkError:error request:operation];
    }]; 
}

#pragma mark - 搭配信息拉取
//获取首页搭配列表
-(void)getCollocationList:(NSInteger)page complete:(SDataResponseFunc)complete
{
    [self userInfo];
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getCollocationList",
                           @"token":tokenStr,//token不需要检测
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        // 去掉不必要的输出，影响调试。
//        NSLog(@"获取首页搭配列表JSON: %@", responseObject);
//        if ([responseObject[@"status"]intValue] <= 0) {
//            return;
//        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}
//获取首页精选热门列表
-(void)getCollocationListHot:(NSInteger)page complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getCollocationListHot",
                           @"token":tokenStr,//token不需要检测
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
//        if ([responseObject[@"status"]intValue] <= 0) {
//            return;
//        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}
//获取首页关注列表
-(void)getCollocationListFollows:(NSInteger)page complete:(SDataResponseFunc)complete
{   
    
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getCollocationListFollows",
                           @"token":[self userToken], //token不需要检测
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
//        if ([responseObject[@"status"]intValue] <= 0) {
//            return;
//        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}

/*
//获取喜欢某个搭配的所有 造型师
 collocationId 搭配id
 page 当前页
*/
- (void)getCollocationLikeUserListWithCollocationId:(NSString *)collocationId
                                               page:(NSInteger)page
                                           complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getCollocationLikeUserList",
                           @"token":tokenStr,
                           @"cid":collocationId,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {

        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        complete(nil,error);
    }];
}
// 品牌
- (void)getBrandLikeUserListWithBrandId:(NSString *)brandId
                                               page:(NSInteger)page
                                           complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
//    NSDictionary *data = @{
//                           @"m":@"Brand",
//                           @"a":@"getBrandLikeUserList",
//                           @"token":tokenStr,
//                           @"bid":brandId,
//                           @"page":@(page)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"getBrandLikeUserList",
                           @"token":tokenStr,
                           @"brandCode":brandId,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        complete(nil,error);
    }];
}
/*
 举报
 collocationId 搭配id
 */
- (void)addMyComplaintsInfoWithCollocationId:(NSString *)collocationId
                                    complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Complaints",
                           @"a":@"addComplaintsInfo",
                           @"token":tokenStr,
                           @"tid":collocationId,
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        complete(nil,error);
    }];
}

///获得全部设计师
-(void)getAllDesignerList :(NSInteger)page complete:(SDataResponseFunc)complete{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Designer",
                           @"a":@"getAllDesignerList",
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            if (complete) {
                complete(nil,[NSError errorWithDomain:@"error" code:100 userInfo:nil]);
            }
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}
//获得明星设计师
-(void)getStarDesignerList :(NSInteger)page complete:(SDataArrayFunc)complete{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Designer",
                           @"a":@"getStarDesignerList",
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}


//获取我的搭配列表  发现
-(void)getMyCollocationList:(NSInteger)page complete:(SDataArrayFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }

    NSDictionary *data = @{
                           @"m":@"Mine",
                           @"a":@"getMyCollocationList",
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"获取我的搭配列表JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//时尚资讯
-(void)getAllFashionList:(NSInteger)page complete:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Fashion",
                           @"a":@"getAllFashionList",
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//活动列表
-(void)getActivityList:(NSInteger)page complete:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Activity",
                           @"a":@"getActivityList",
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//获取我喜欢的搭配列表(收藏列表)瀑布流
-(void)getMyLikeCollocationList:(NSInteger)page complete:(SDataArrayFunc)complete 
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
   NSDictionary *data = @{
                           @"m":@"Mine",
                           @"a":@"getMyLikeCollocationList",
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//获取别人发布的搭配列表(收藏列表)瀑布流
-(void)getOtherCollocationList:(NSString*)userIdStr page:(NSInteger)page complete:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Mine",
                           @"a":@"getOtherCollocationList",
                           @"user_id":userIdStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
//获取他人喜欢的搭配列表(收藏列表)瀑布流
-(void)getOtherLikeCollocationList:(NSString*)userIdStr page:(NSInteger)page complete:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Mine",
                           @"a":@"getOtherLikeCollocationList",
                           @"user_id":userIdStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//搭配页推荐搭配列表
-(void)getCollocationListForDetails:(NSInteger)page complete:(SDataArrayFunc)complete{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getCollocationListForDetails",
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//发现页推荐搭配列表
-(void)getCollocationListForMain:(NSInteger)page tabString:(NSString*)tabString complete:(SDataArrayFunc)complete{
    NSString *tabStr = tabString? tabString: @"";
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getCollocationListForMain",
                           @"token":tokenStr,
                           @"page":@(page),
                           @"tabstr": tabStr
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//单页推荐瀑布流搭配列表
-(void)getCollocationListForItem:(NSInteger)tid page:(NSInteger)page complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure{
    NSDictionary *data = @{
                           @"m":@"Item",
                           @"a":@"getCollocationListForItem",
                           @"tid":@(tid),
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failure(error);
        [self handlerNetworkError:error request:operation];
    }];
}

//单品页推荐搭配列表
-(void)getRelevantCollocationForItem:(NSInteger)tid  complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure
{
    NSDictionary *data = @{
                           @"m":@"Item",
                           @"a":@"getItemDetails",
                           @"tid":@(tid),
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failure(error);
        [self handlerNetworkError:error request:operation];
    }];

}


//最佳搭配列表
-(void)getBestCollocationList:(NSInteger)page tabstr:(NSString *)tabStr complete:(SDataArrayFunc)complete{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getBestCollocationList",
                           @"tabstr": tabStr,
                           @"token":tokenStr,
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

-(void)getBestCollocationBanner:(SDataArrayFunc)complete{
    NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getBestCollocationBanner"
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}


//获取推荐品牌搭配列表    类型： 0单品，1品牌，2设计师，3话题  
-(void)getCollocationListForBrand:(NSInteger)page bid:(NSString *)bid complete:(SDataArrayFunc)complete
{
//   NSDictionary *data = @{
//                           @"m":@"BrandMb",
//                           @"a":@"getCollocationListForBrand",
//                           @"page":@(page),
//                           @"bid":@(bid)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"getCollocationListForBrand",
                           @"page":@(page),
                           @"brandCode":bid
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"status"]intValue] <= 0) {
            return;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//删除一个搭配    -1 已添加喜欢
-(void)delCollocationInfo:(NSString*)token collocationId:(NSInteger)collocationId complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
  NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"delCollocationInfo",
                           @"token":tokenStr,
                           @"cid":@(collocationId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        complete(nil,error);
    }];
}

//喜欢某个搭配    -1 已添加喜欢
-(void)likeCollocation:(NSString*)collocationId complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
  NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"likeCollocation",
                           @"token":tokenStr,
                           @"cid":collocationId
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        int status = [[responseObject objectForKey:@"status"]intValue];
        if (status < 0) {
            return ;
        }
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failure (error);
        [self handlerNetworkError:error request:operation];
    }];
}

-(void)likeCollocation:(NSString*)collocationId complete:(SDataArrayFunc)complete{
    [self likeCollocation:collocationId complete:complete failure:^(NSError *error) {
        
    }];
}

//取消喜欢搭配   -1 已取消喜欢
-(void)delLikeCollocation:(NSString *)collocationId complete:(SDataArrayFunc)complete failure:(FailureResponseError)failure;
{
  NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"delLikeCollocation",
                           @"token": _userInfo[@"token"],
                           @"cid":collocationId
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        failure (error);
        [self handlerNetworkError:error request:operation];
    }];
}
-(void)delLikeCollocation:(NSString *)collocationId complete:(SDataArrayFunc)complete{
    [self delLikeCollocation:collocationId complete:complete failure:^(NSError *error) {
        
    }];
}

-(void)getCollocationLikeUserList:(NSInteger)page collocationId:(NSInteger)collocationId complete:(SDataArrayFunc)complete
{
   NSDictionary *data = @{
                           @"m":@"Collocation",
                           @"a":@"getCollocationLikeUserList",
                           @"page":@(page),
                           @"cid":@(collocationId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//获取全部品牌列表(旧) 调用原有的接口  BrandAction,getAllBrandListForShow
-(void)getAllBrandListForShow:(NSInteger)page complete:(SDataArrayFunc)complete 
{

}
//标签列表
-(void)searchTagDetailList:(NSDictionary *)param complete:(SDataResponseFunc)complete
{
    [self quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}

//获取推荐品牌列表
-(void)getRecommendBrandList:(NSInteger)page complete:(SDataArrayFunc)complete
{
//  NSDictionary *data = @{
//                           @"m":@"Brand",
//                           @"a":@"getRecommendBrandList",
//                           @"page":@(page)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"getRecommendBrandList",
                           @"page":@(page)
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//获取品牌详情
-(void)getBrandDetails:(NSString *)brandId complete:(SDataResponseFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
//  NSDictionary *data = @{
//                           @"m":@"Brand",
//                           @"a":@"getBrandDetails",
//                           @"token":tokenStr,
//                           @"bid":@(brandId)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"getBrandDetails",
                           @"token":tokenStr,
                           @"brandCode":brandId
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"],nil);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        if (complete) {
            complete(nil,error);
        }
    }];
}

//获取品牌搭配列表
-(void)getCollocationListForBrand:(NSString *)brandId page:(NSInteger)page complete:(SDataArrayFunc)complete
{
    NSString *tokenStr = @"";
    if(_userInfo[@"token"]){
        tokenStr = _userInfo[@"token"];
    }
//    NSDictionary *data = @{
//                           @"m": @"Brand",
//                           @"a": @"getCollocationListForBrand",
//                           @"token": tokenStr,
//                           @"bid": @(brandId),
//                           @"page": @(page)
//                           };
    NSDictionary *data = @{
                           @"m": @"BrandMb",
                           @"a": @"getCollocationListForBrand",
                           @"token": tokenStr,
                           @"brandCode": brandId,
                           @"page": @(page)
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//喜欢某个品牌 -1 已添加喜欢
-(void)likeBrand:(NSString*)token brandId:(NSString *)brandId complete:(SDataArrayFunc)complete
{
//   NSDictionary *data = @{
//                           @"m":@"Brand",
//                           @"a":@"likeBrand",
//                           @"token":token,
//                           @"bid":@(brandId)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"likeBrand",
                           @"token":token,
                           @"brandCode":brandId
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//取消喜欢品牌 -1 已取消喜欢
-(void)delLikeBrand:(NSString*)token brandId:(NSString *)brandId complete:(SDataArrayFunc)complete
{
//   NSDictionary *data = @{
//                           @"m":@"Brand",
//                           @"a":@"delLikeBrand",
//                           @"token":token,
//                           @"bid":@(brandId)
//                           };
    NSDictionary *data = @{
                           @"m":@"BrandMb",
                           @"a":@"delLikeBrand",
                           @"token":token,
                           @"brandCode":brandId
                           };
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

//获取话题列表
-(void)getTopicList:(NSInteger)page complete:(SDataArrayFunc)complete
{
   NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getTopicList",
                           @"page":@(page)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
//获取所有话题搭配列表
-(void)getCollocationListForTopic:(NSInteger)page topicId:(NSInteger)topicId complete:(SDataArrayFunc)complete
{
   NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getCollocationListForTopic",
                           @"page":@(page),
                           @"tid":@(topicId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
//获取精选话题搭配列表
-(void)getCollocationListForSelectTopic:(NSInteger)page topicId:(NSInteger)topicId complete:(SDataArrayFunc)complete
{
   NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getCollocationListForSelectTopic",
                           @"page":@(page),
                           @"tid":@(topicId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}
//获取话题详情
-(void)getTopicDetails:(NSInteger)topicId complete:(void (^)(NSDictionary *))complete
{
   NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getTopicDetails",
                           @"tid":@(topicId)
                           };
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];
}

// 设置昵称时候，同步新服务
-(void)setUserNickName:(NSString*)newName complete:(SDataStringFunc)complete{
    [self quickGet:SERVER_URL parameters:@{@"m":@"User",
                                           @"a":@"updateUserNickname",
                                           @"newName":newName,
                                           } success:^(AFHTTPRequestOperation *operation, id object) {
                                               complete(newName);
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               complete(nil);
                                           }];

}

// 设计界面设置用户头像
-(void)setUserImage:(UIImage *)image complete:(SDataStringFunc)complete{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(image, 1.0);
        // key = nil 用随机名字
        [upManager putData:dataTemp key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                      
                      [self quickGet:SERVER_URL parameters:@{@"m":@"User",
                                                             @"a":@"updateUserImg",
                                                             @"newImg":url,
                                                             } success:^(AFHTTPRequestOperation *operation, id object) {
                          complete(url);
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          complete(nil);
                      }];
                      
                      
                  } option:nil];
    }];
}

-(void)uploadVideo:(NSURL*)url stickerImage:(UIImage*)stickerImage contentInfo:(NSDictionary*)infoDict withData:(NSArray*)data complete:(SDataStringFunc)complete{
    
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [QNUploadManager new];
        // Todo:支持其他格式
        [upManager putFile:url.path key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
            NSLog(@"Video URL: %@", url);
            
            NSData *dataStickerTemp = UIImagePNGRepresentation(stickerImage);
            [upManager putData:dataStickerTemp key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
                // 后续增加progress update。
                if (!resp) {
                    // upload failed
                    [self handlerNetworkError:nil request:nil];
                }
                
                NSString *urlSticker = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                NSLog(@"Sticker URL: %@", urlSticker);
                NSString *userKey = [self getKey];
                
                float width = stickerImage.size.width;
                float height = stickerImage.size.height;
                
                if (width > height) {
                    width = stickerImage.size.height;
                    height = stickerImage.size.width;
                }
                
                NSString *thumbImgUrl = [NSString stringWithFormat:@"%@?vframe/jpg/offset/0/w/%d/h/%d",url,(int)width,(int)height];
                
                NSDictionary* parameters = @{
                                             @"token":userKey,
                                             @"m":@"Collocation",
                                             @"a":@"pushUserCollocation",
                                             @"token":userKey,
                                             @"media_type" : @1,// 1 for video,TODO: Define it later
                                             @"imgUrl" : thumbImgUrl,
                                             @"videoUrl":url,
                                             @"contentInfo":infoDict[@"contentInfo"],
                                             @"imgWidth" : @(width),
                                             @"imgHeight" : @(height),
                                             @"itemJson":@"",
                                             @"tagJson" : [self getJSON:data],
                                             @"tabStr":infoDict[@"tabStr"],
                                             @"stickImgUrl" : urlSticker
                                             };
                [self uploadTagData:parameters complete:complete];
                
            } option:nil];
            
        } option:nil];
    }];
}


-(void)uploadVideoToQiNiuWithURL:(NSURL*)url  videoSize:(CGSize)videoSize complete:(SDataStringFunc)complete{
    
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [QNUploadManager new];
        // Todo:支持其他格式
        [upManager putFile:url.path key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
            NSLog(@"Video URL: %@", url);
            
            if (complete != nil)
            {
                complete(url);
            }

            
        } option:nil];
    }];
}

-(void)uploadImage:(UIImage*)image stickerImage:(UIImage*)stickerImage contentInfo:(NSDictionary*)infoDict withData:(NSArray*)data complete:(SDataStringFunc)complete{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(image, 1.0);
        
        // key = nil 用随机名字
        [upManager putData:dataTemp key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (!resp) {
                          // upload failed
                          [self handlerNetworkError:nil request:nil];
                      }
                      NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                      //$token,$imgUrl,$imgWidth,$imgHeight,$contentInfo, $tagJson, $itemJson, $tabStr
                      NSLog(@"Image URL: %@", url);
                      NSString *userKey = [self getKey];
                      
                      float width = image.size.width;
                      float height = image.size.height;
                      
                      if (width > height) {
                          width = image.size.height;
                          height = image.size.width;
                      }
                      
                      ///
        
                      
                      NSLog(@"%f,%f ",width,height );
                      NSData *dataStickerTemp = UIImagePNGRepresentation(stickerImage);
                      [upManager putData:dataStickerTemp key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSString *urlSticker = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                          NSLog(@"Sticker URL: %@", urlSticker);
                          NSDictionary* parameters = @{
                                                       @"token":userKey,
                                                       @"m":@"Collocation",
                                                       @"a":@"pushUserCollocation",
                                                       @"media_type" : @0,// 0 for image,TODO: Define it later
                                                       @"imgUrl" : url,
                                                       @"videoUrl" : @"",
                                                       @"contentInfo":infoDict[@"contentInfo"],
                                                       @"imgWidth" : @(width),
                                                       @"imgHeight" : @(height),
                                                       @"itemJson":@"",
                                                       @"tagJson" : [self getJSON:data],
                                                       @"tabStr":infoDict[@"tabStr"],
                                                       @"stickImgUrl" : urlSticker
                                                       };
                          [self uploadTagData:parameters complete:complete];
                          
                      } option:nil];
                      
                  } option:nil];
        
    }];
}


-(void)uploadImageToQiNiuWithImage:(UIImage*)image complete:(SDataStringFunc)complete{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(image, 1.0);
        
        // key = nil 用随机名字
        [upManager putData:dataTemp key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      if (!resp) {
                          // upload failed
                          [self handlerNetworkError:nil request:nil];
                      }
                      NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                      
                
                      if (complete != nil)
                      {
                          complete(url);
                      }
                      
    
                      
                  } option:nil];
        
    }];
}


-(void)uploadBackImgView:(UIImage *)image stickerImage:(UIImage*)stickerImage contentUrl:(NSString*)infoUrl withData:(NSArray*)data complete:(SDataStringFunc)complete{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(image, 1.0);
        
        if(infoUrl)
        {
            NSString *userKey = [self getKey];
            NSDictionary* parameters = @{
                                         @"token":userKey,
                                         @"m":@"User",
                                         @"a":@"updateUserBackImg",
                                         @"newBackImg" :infoUrl
                                         };
            [self uploadbackImgData:parameters complete:complete];
  
        }
        else
        {
            // key = nil 用随机名字
            [upManager putData:dataTemp key:nil token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          
                          if (!resp) {
                              // upload failed
                              [self handlerNetworkError:nil request:nil];
                          }
                          
                          NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                          NSLog(@"ImageBackImgView URL: %@", url);
                          NSString *userKey = [self getKey];
                          NSDictionary* parameters = @{
                                                       @"token":userKey,
                                                       @"m":@"User",
                                                       @"a":@"updateUserBackImg",
                                                       @"newBackImg" : url
                                                       };
                          [self uploadbackImgData:parameters complete:complete];
                          
                          
                      } option:nil];
        }

        
        
    }];
}
/*
 post
 m=Product&uploadUserProduct()
 'token':用户标识
 'product_img':"商品图",
 'product_code':"商品6位码"（可无）
 'cate_id':分类id
 'cate_value':分类名称
 'color_code':色系code
 'color_value':颜色名称
 'brand_code':品牌code
 'brand_value':品牌名
 */
-(void)uploadProductImgView:(UIImage *)image stickerImage:(UIImage*)stickerImage contentUrl:(NSString*)infoUrl withData:(NSDictionary*)data complete:(SDataStringFunc)complete{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(image, 1.0);
        
        if(infoUrl)
        {
            NSString *userKey = [self getKey];
            NSDictionary* parameters = @{
                                         @"token":userKey,
                                         @"m":@"User",
                                         @"a":@"updateUserBackImg",
                                         @"newBackImg" :infoUrl
                                         };
            [self uploadbackImgData:parameters complete:complete];
        }
        else
        {
            // key = nil 用随机名字
            [upManager putData:dataTemp key:nil token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          
                          if (!resp) {
                              // upload failed
                              [self handlerNetworkError:nil request:nil];
                          }
                          
                          NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                          NSLog(@"ImageBackImgView URL: %@", url);
                          if (complete) {
                              complete(url);
                          }
                          return ;
                          
                          NSMutableDictionary *paramDicNew=[NSMutableDictionary dictionaryWithDictionary:data];
                          
                          [paramDicNew setValue:url  forKey:@"product_img"];
                          
                          [self uploadProductDetailWithDic:paramDicNew complete:complete];
                          
                      } option:nil];
        }
    }];
}
-(void)uploadProductDetailWithDic:(NSDictionary *)dic complete:(SObjectFunc)complete
{
    [self quickPost:SERVER_URL parameters:dic success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@",,上传date,,,我的商品,,JSON: %@", responseObject);
        
        if (complete) {
            complete(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [self handlerNetworkError:error request:operation];
    }];

}
// 获得贴纸和tag列表
-(void)getStickImgWithTabList:(NSString *)topicId complete:(SObjectFunc)complete{
    
    [self quickGet:SERVER_URL parameters:@{@"m":@"Collocation",
                                         @"a":@"getStickImgWithTabList",
                                         @"tid":topicId} success:^(AFHTTPRequestOperation* operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if (complete) {
            complete(responseObject[@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        // 这个函数也返回，保证逻辑贯通，通信部分后续进行重构。
        if (complete) {
            complete(nil);
        }
        
        [self handlerNetworkError:error request:operation];
    }];
}


// 获得边框图片列表
-(void)getBorderImageList:(NSString *)topicId borderHeight:(int)borderHeight complete:(SObjectFunc)complete{
    
    [self quickGet:SERVER_URL parameters:@{@"m":@"Collocation",
                                           @"a":@"getStickImgWithTabList",
                                           @"tid":topicId,
                                           @"type":@"2",
                                           @"img_height":@(borderHeight)} success:^(AFHTTPRequestOperation* operation, id responseObject) {
                                               NSLog(@"JSON: %@", responseObject);
                                               
                                               if (complete) {
                                                   complete(responseObject[@"data"]);
                                               }
                                               
                                           } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                               // 这个函数也返回，保证逻辑贯通，通信部分后续进行重构。
                                               if (complete) {
                                                   complete(nil);
                                               }
                                               
                                               [self handlerNetworkError:error request:operation];
                                           }];
}



//获取品类详情的接口
- (void) getClothingCategoryDetailsWithFid:(NSString *)fid complete:(SObjectFunc)complete failure:(FailureResponseError)failure
{
    NSDictionary *data = @{
                           @"m":@"Item",
                           @"a":@"getItemClsDetails",
                           @"fid":fid,
                           @"token":@"",
                           };
    
    //NSLog(@"SERVER_URL = %@", SERVER_URL);
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject){
        
        NSLog(@"getClothingCategoryDetailsWithFid JSON: %@", responseObject);
        
        if ([responseObject[@"status"]intValue] <= 0)
        {
            return;
        }
        if (complete)
        {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        NSLog(@"getClothingCategoryDetailsWithFid error = %@", error);
        
        failure(error);
        
        [self handlerNetworkError:error request:operation];
    }];
}

//获取品类详情头部的接口
- (void) newGetClothingCategoryDetailsWithFid:(NSString *)fid complete:(SObjectFunc)complete failure:(FailureResponseError)failure
{
    NSDictionary *data = @{
                           @"m":@"Product",
                           @"a":@"getProductCategoryList",
                           @"cid":fid,
                           @"token":@"",
                           };
    
    //NSLog(@"SERVER_URL = %@", SERVER_URL);
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject){
        
        NSLog(@"getClothingCategoryDetailsWithFid JSON: %@", responseObject);
        
        if ([responseObject[@"status"]intValue] <= 0)
        {
            return;
        }
        if (complete)
        {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        failure(error);
        
        [self handlerNetworkError:error request:operation];
    }];
}


//获取品类详情下面的单品信息
- (void) getItemListForClsWith:(NSString *)tid shortType:(SCShortType)shortType isNew:(BOOL)isNew filterDictionary:(NSDictionary *)filterDictionary page:(int)page numberOfPage:(int)numberOfPage complete:(SObjectFunc)complete failure:(FailureResponseError)failure
{
    if (filterDictionary == nil)//不带筛选的
    {
        NSDictionary *data = nil;
        if (shortType == SCShortDefault)//默认排序
        {
            data = @{
                     @"m":@"Item",
                     @"a":@"getItemListForClsV2",
                     @"tid":[Utils getSNSString:tid],
                     @"page":@(page),
                     @"num":@(numberOfPage),
                     @"orderType":@(0),
                     @"token":@"",
                     };
            
        }
        else if (shortType == SCShortAscByPrice)//升序
        {
            data = @{
                     @"m":@"Item",
                     @"a":@"getItemListForClsV2",
                     @"tid":[Utils getSNSString:tid],
                     @"page":@(page),
                     @"num":@(numberOfPage),
                     @"orderType":@(1),
                     @"token":@"",
                     };
            
        }
        else if (shortType == SCShortDescByPrice)//降序
        {
            data = @{
                     @"m":@"Item",
                     @"a":@"getItemListForClsV2",
                     @"tid":[Utils getSNSString:tid],
                     @"page":@(page),
                     @"num":@(numberOfPage),
                     @"orderType":@(2),
                     @"token":@"",
                     };
            
        }
        else//默认排序
        {
            data = @{
                     @"m":@"Item",
                     @"a":@"getItemListForClsV2",
                     @"tid":[Utils getSNSString:tid],
                     @"page":@(page),
                     @"num":@(numberOfPage),
                     @"token":@"",
                     @"orderType":@(0),
                     };
        }
        
        
        [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject){
            
            NSLog(@"getItemListForClsWith JSON: %@", responseObject);
            
            if ([responseObject[@"status"]intValue] <= 0)
            {
                return;
            }
            if (complete)
            {
                complete([responseObject objectForKey:@"data"]);
            }
            
        } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            
            failure(error);
            
            [self handlerNetworkError:error request:operation];
        }];
    }
 /*   else //需要筛选的
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"brandId":@"",
                                                                                      @"pageIndex": @(page+1),
                                                                                      @"pageSize": @(numberOfPage)}];
        if ([[filterDictionary allKeys]count]>0)
        {
            if([[filterDictionary allKeys]containsObject:@"BrandId"])
            {
                params[@"BrandId"] = filterDictionary[@"BrandId"];
            }
            if([[filterDictionary allKeys]containsObject:@"ColorId"])
            {
                params[@"ColorId"] = filterDictionary[@"ColorId"];
            }
            if([[filterDictionary allKeys]containsObject:@"PriceId"])
            {
                params[@"PriceId"] = filterDictionary[@"PriceId"];
            }
        }
        
        if (isNew)//是上新
        {
            params[@"sortInfo"] = @{@"SortField": @(0), @"Desc": @(shortType == SCShortDescByPrice)};
            
        }
        else
        {
            params[@"sortInfo"] = @{@"SortField": @(3), @"Desc": @(shortType == SCShortDescByPrice)};
        }

        [HttpRequest productPostRequestPath:nil methodName:@"ProductClsCommonSearchFilter" params:params success:^(NSDictionary *dict) {
            
            
            if ([dict[@"isSuccess"] boolValue])
            {
                NSMutableArray *array = dict[@"results"];
                
                if (complete != nil)
                {
                    complete(array);
                }
                
                // if (_pageIndex == 0)
                // {
                 //if([array count]==0)
                // {
                 
                // }
                // self.productListArray = array;
                // }
                // else
                // {
                // [self.productListArray addObjectsFromArray:array];
                // [self.contentCollectionView reloadData];
                // }
            }
            else
            {
                NSError *error = [NSError errorWithDomain:dict[@"message"] code:-1 userInfo:nil];
                
                if (failure != nil)
                {
                    failure(error);
                }
                
            }
            
        } failed:^(NSError *error) {
            
            if (failure != nil)
            {
                failure(error);
            }
        }];

    }*/
}

//获取品类详情下面的单品信息
- (void) newGetItemListForClsWithParameters:(NSDictionary*)data success:(SNetworkSucFunc)suc failure:(SNetworkFailFunc)fail
{
        
}


#pragma mark - chat
-(void)addMessageInfo:(NSString*)userId msg:(NSString*)msg complete:(SObjectFunc)complete{
    
    [self quickGet:SERVER_URL parameters:@{@"m":@"Message",
                                           @"a":@"addMessageInfo",
                                           @"toUserId":userId,
                                           @"messageInfo":msg
                                           } success:^(AFHTTPRequestOperation* operation, id responseObject) {
                                               NSLog(@"JSON: %@", responseObject);
                                               
                                               if (complete) {
                                                   complete(responseObject[@"data"]);
                                               }
                                               
                                           } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                                               [self handlerNetworkError:error request:operation];
                                           }];
}

-(void)uploadChatImage:(UIImage*)img complete:(SDataStringFunc)suc fail:(SVoidFunc)fail{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        // TODO:支持其他格式 如gif。
        NSData *dataTemp = UIImageJPEGRepresentation(img, 0.8);
        
        // key = nil 用随机名字
        [upManager putData:dataTemp key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                      if (suc) {
                          suc(url);
                      }
                      
                      if (info.error && fail) {
                          fail();
                      }
                      
                  } option:nil];
        
    }];
}

-(void)uploadChatVoice:(NSData*)voice complete:(SDataStringFunc)suc fail:(SVoidFunc)fail{
    [self getUploadToken:^(NSString *token) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        // key = nil 用随机名字
        [upManager putData:voice key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_CDN,[resp objectForKey:@"key"]];
                      if (suc) {
                          suc(url);
                      }
                      
                      if (info.error && fail) {
                          fail();
                      }
                      
                  } option:nil];
        
    }];
}


//获取创建搭配时选择话题的列表
- (void) getTagEditTopicListWithPage:(int)page numberOfPage:(int)numberOfPage complete:(SObjectFunc)complete failure:(FailureResponseError)failure
{
    NSDictionary *data = @{
                           @"m":@"Topic",
                           @"a":@"getTopicRandomList",
                           @"page":@(page),
                           @"num":@(numberOfPage),
                           };
    
    //NSLog(@"SERVER_URL = %@", SERVER_URL);
    
    [self quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject){
        
        NSLog(@"getTagEditTopicListWithPage JSON: %@", responseObject);
        
        if ([responseObject[@"status"]intValue] <= 0)
        {
            return;
        }
        if (complete)
        {
            complete([responseObject objectForKey:@"data"]);
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        
        failure(error);
        
        [self handlerNetworkError:error request:operation];
    }];
}


@end
