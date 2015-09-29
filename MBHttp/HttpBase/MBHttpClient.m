
//
//  MBHttpClient.m
//  Wefafa
//
//  Created by su on 15/3/20.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "MBHttpClient.h"
#import "MBHttpModel.h"
#import "Globle.h"
#import "SDataCache.h"
#import "JSONKit.h"
#import "JSON.h"
@interface MBHttpClient ()
@property(nonatomic,strong)NSMutableArray *operationArray;//网络请求操作集合
@property(nonatomic,assign)BOOL needRequestToken;//是否需要调用token请求
@end

@implementation MBHttpClient

+ (MBHttpClient *)shareClient
{
    static MBHttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[MBHttpClient alloc] initWithBaseURL:[NSURL URLWithString:MBSoaServer]];
        client.securityPolicy.allowInvalidCertificates = YES;
        [client.reachabilityManager startMonitoring];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded",@"text/xml",@"text/html",@"text/plain",@"text/json", @"text/javascript",nil];
        client.needRequestToken = YES;
        
    });
    return client;
}

- (NetworkStatus)netWorkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    // NotReachable     - 没有网络连接
    // ReachableViaWWAN - 移动网络(2G、3G)
    // ReachableViaWiFi - WIFI网络
    return [reachability currentReachabilityStatus];
}

//get请求

- (BOOL)netWorkConnect
{
    return [NetUtils connectedToNetwork]&&([NetUtils isWifiConnected]||[NetUtils is3GConnected]);
}

- (void)mbGetRequestPath:(NSString *)path               //请求路径
              serverName:(NSString *)server             //服务名称
              methodName:(NSString *)method             //方法名
                  params:(NSDictionary *)param          //请求参数
                 success:(RequestSuccessBlock)success   // 成功回调
                  failed:(RequestFailedBlock)failed    //失败回调
{
//    导致多个请求失效
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:param];
    [dic setValue:[NSString stringWithFormat:@"%@",server] forKey:@"m"];
    [dic setValue:[NSString stringWithFormat:@"%@",method] forKey:@"a"];
    param = dic;
    if (![self netWorkConnect]) {
        NSError *error = [NSError errorWithDomain:@"无网络" code:MBHttpErrorTypeNotReachableNet userInfo:nil];
        failed(error);
        return;
    }
    if (!path || [path length] == 0) {
        path = kUrlPath;
    }
    //不需要token
 
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    if (!token) {
        MBHttpModel *model = [self combineRequestWithPath:path server:server method:method params:param success:success failed:failed type:@"GET"];
        [self requestAccessToken:model];
        return;
    }

    BOOL isOld=NO;
    
    if (isOld) {
        NSDictionary *dict = [self configParamDictWithServer:server method:method param:param type:@"GET" token:token];
        [HttpRequest printObject:dict isReq:YES];

        [self POST:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
                [HttpRequest printObject:responseObject isReq:NO];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"MBHttpClient----------%@----方法－－%@-------%@",operation.responseString,method,path );
            NSString *str = operation.responseString;
            str = [str stringByReplacingOccurrencesOfString:@"MBSOA-CallCenter-Error:" withString:@""];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            if ([data length] > 0) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if ([json objectForKey:@"errcode"]) {
                    if ([[json objectForKey:@"errcode"] integerValue] == MBHttpErrorTypeInvalidToken) {
                        MBHttpModel *model = [self combineRequestWithPath:path server:server method:method params:param success:success failed:failed type:@"GET"];
                        [self requestAccessToken:model];
                    }else{
                        NSInteger code  =[[json objectForKey:@"errcode"] integerValue];
                        NSError *respError = [NSError errorWithDomain:[json objectForKey:@"errmsg"] code:code userInfo:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failed(respError);
                        });
                    }
                }
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed(error);
                });
            }
            
        }];
        return;
    }

    
    
    NSArray* arr = [dic allKeys];//post  二维数组转json上传deng
    for(NSString* str in arr)
    {
        if([[dic objectForKey:str] isKindOfClass:[NSArray class]])
        {
            //                NSArray *array =(NSArray *)[dic objectForKey:str];
            //                NSLog(@"array－－－－%@",array);
            //                NSString *jsonStr = [array JSONString];
            NSString *jsonStr=[NSString arrayAnddictoJSONDataStr:[dic objectForKey:str]];
            //                NSLog(@"jsonssssssss-----%@",jsonStr);
            
            [dic setValue:jsonStr forKey:str];
        }
        if ([[dic objectForKey:str] isKindOfClass:[NSDictionary class]]) {
            NSString *jsonSSS=[NSString arrayAnddictoJSONDataStr:[dic objectForKey:str]];
            [dic setValue:jsonSSS forKey:str];
        }
        
    }
    
    //保持类型一致
//    param  = [dic copy];
    
    
    [[SDataCache sharedInstance] quickGet:SERVER_URL parameters:dic  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(responseObject);
            [HttpRequest printObject:responseObject isReq:NO];

        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSString *str = operation.responseString;
        str = [str stringByReplacingOccurrencesOfString:@"MBSOA-CallCenter-Error:" withString:@""];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        if ([data length] > 0) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if ([json objectForKey:@"errcode"]) {

                NSInteger code  =[[json objectForKey:@"errcode"] integerValue];
                NSError *respError = [NSError errorWithDomain:[json objectForKey:@"errmsg"] code:code userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed(respError);
                });
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }

    }];
    
}


//post请求
- (void)mbPostRequestPath:(NSString *)path               //请求路径
               serverName:(NSString *)server             //服务名称
               methodName:(NSString *)method             //方法名
                   params:(NSDictionary *)param          //请求参数
                  success:(RequestSuccessBlock)success   // 成功回调
                   failed:(RequestFailedBlock)failed    //失败回调
{
    if (![self netWorkConnect]) {
        NSError *error = [NSError errorWithDomain:@"无网络" code:MBHttpErrorTypeNotReachableNet userInfo:nil];
        failed(error);
        return;
    }
    if (!path || [path length] == 0) {
        path = kUrlPath;
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    if (!token || [token isEqualToString:@"(null)"]) {
        MBHttpModel *model = [self combineRequestWithPath:path server:server method:method params:param success:success failed:failed type:@"POST"];
        [self requestAccessToken:model];
        return;
    }
    
    BOOL isOld=NO;
    NSArray *oldArray =@[@"UserUpdateProfile"];
    if ([oldArray containsObject:method]) {
        isOld=YES;
    }
    if (isOld) {
        NSDictionary *dict = [self configParamDictWithServer:server method:method param:param type:@"POST" token:token];
        [HttpRequest printObject:dict isReq:YES];
        [self POST:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HttpRequest printObject:responseObject isReq:NO];
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"MBHttpClient----------%@",operation.responseString);
            NSString *str = operation.responseString;
            str = [str stringByReplacingOccurrencesOfString:@"MBSOA-CallCenter-Error:" withString:@""];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            if ([data length] > 0) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if ([json objectForKey:@"errcode"]) {
                    if ([[json objectForKey:@"errcode"] integerValue] == MBHttpErrorTypeInvalidToken) {
                        MBHttpModel *model = [self combineRequestWithPath:path server:server method:method params:param success:success failed:failed type:@"POST"];
                        [self requestAccessToken:model];
                    }else{
                        NSInteger code  =[[json objectForKey:@"errcode"] integerValue];
                        NSError *respError = [NSError errorWithDomain:[json objectForKey:@"errmsg"] code:code userInfo:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failed(respError);
                        });
                    }
                }
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed(error);
                });
            }
        }];
    
        return;
    }
    else
    {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:param];
        NSString *requestUrl=SERVER_URL;
         
        //WxPrePayFlowCreate 直接用url
        if(![method isEqualToString:@"WxPrePayFlowCreate"]) {
            
            [dic setValue:[NSString stringWithFormat:@"%@",server] forKey:@"m"];
            [dic setValue:[NSString stringWithFormat:@"%@",method] forKey:@"a"];
            
        }
        else
        {
            requestUrl = WX_BEFORE_PAY_URL;
        }
        


        
        NSArray* arr = [dic allKeys];//post  二维数组转json上传deng
        for(NSString* str in arr)
        {
            if([[dic objectForKey:str] isKindOfClass:[NSArray class]])
            {
//                NSArray *array =(NSArray *)[dic objectForKey:str];
//                NSLog(@"array－－－－%@",array);
//                NSString *jsonStr = [array JSONString];
            NSString *jsonStr=[NSString arrayAnddictoJSONDataStr:[dic objectForKey:str]];
//                NSLog(@"jsonssssssss-----%@",jsonStr);
                
                [dic setValue:jsonStr forKey:str];
            }
            if ([[dic objectForKey:str] isKindOfClass:[NSDictionary class]]) {
                NSString *jsonSSS=[NSString arrayAnddictoJSONDataStr:[dic objectForKey:str]];
                [dic setValue:jsonSSS forKey:str];
            }
    
        }
        //保持类型一致
        param  = [dic copy];
        
        
        
        [[SDataCache sharedInstance] quickPost:requestUrl parameters:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
                [HttpRequest printObject:responseObject isReq:NO];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSString *str = operation.responseString;
            str = [str stringByReplacingOccurrencesOfString:@"MBSOA-CallCenter-Error:" withString:@""];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            if ([data length] > 0) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if ([json objectForKey:@"errcode"]) {
                    
                    NSInteger code  =[[json objectForKey:@"errcode"] integerValue];
                    NSError *respError = [NSError errorWithDomain:[json objectForKey:@"errmsg"] code:code userInfo:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failed(respError);
                    });
                }
                else
                {
                    if ([json objectForKey:@"info"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failed([json objectForKey:@"info"]);
                        });
                    }
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        failed(error);
//                    });
                }
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed(error);
                });
            }
            
        }];
 
    }
    
    
}

- (NSString *)configPostBodyWithDict:(NSDictionary *)dict
{
    NSString *bodyStr = @"";
    for(NSString *key in dict.allKeys){
        bodyStr = [bodyStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dict objectForKey:key]]];
    }
    if ([bodyStr length] > 0) {
        bodyStr = [bodyStr substringToIndex:[bodyStr length] - 1];
    }
    return bodyStr;
}

//不需要 token的网络请求
- (void)mbRequestWithOutTokenWithDomian:(NSString *)domain
                                   Path:(NSString *)path
                                  param:(NSDictionary *)params
                                success:(RequestSuccessBlock)success
                                 failed:(RequestFailedBlock)failed
{
    NSLog(@"不走吧啊  啊     ");
    
    if (![self netWorkConnect]) {
        NSError *error = [NSError errorWithDomain:@"无网络" code:MBHttpErrorTypeNotReachableNet userInfo:nil];
        failed(error);
        return;
    }
    
    if (!domain || [domain length] == 0) {
        domain = DEFAULT_SERVER;
        if (![domain hasPrefix:@"http"]) {
            domain = [@"http://" stringByAppendingString:domain];
        }
    }
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:domain]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:5.0];
    NSString *bodyStr = [self configPostBodyWithDict:params];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dict);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            failed(error);
        });
    }
}

- (void)mbRequestWithPath:(NSString *)path
                         param:(NSDictionary *)params
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed
{
    if (![self netWorkConnect] || [path length] == 0) {
        NSError *error = [NSError errorWithDomain:@"无网络" code:MBHttpErrorTypeNotReachableNet userInfo:nil];
        failed(error);
        return;
    }
       NSString *domain = DEFAULT_SERVER;
    if (![domain hasPrefix:@"http"]) {
        domain = [@"http://" stringByAppendingString:domain];
    }
    domain = [domain stringByAppendingString:path];
    
    NSURL *url = [NSURL URLWithString:domain];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:5.0];
    NSString *bodyStr = [self configPostBodyWithDict:params];
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dict);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            failed(error);
        });
    }
}

- (void)addRequestModel:(MBHttpModel *)model
{
    [_operationArray addObject:model];
}

//token 过期 或者 没有token时，请求token
- (void)requestAccessToken:(MBHttpModel *)httpModel
{
    if (!_operationArray) {
        _operationArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if ([NSThread currentThread].isMainThread) {
        [_operationArray addObject:httpModel];
    }else{
        [self performSelectorOnMainThread:@selector(addRequestModel:) withObject:httpModel waitUntilDone:YES];
    }
    
    if (_needRequestToken) {
        _needRequestToken = NO;
        
        NSDictionary *param = @{@"AppId": @"ios-zxs",@"Secret":SOA_SECRET};
        [self POST:kTokenPath parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *token = [responseObject objectForKey:@"access_token"];
                if ([token length] > 0) {
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"AccessToken"];
                    for(MBHttpModel *model in _operationArray){
                        NSDictionary *dict = [self configParamDictWithServer:model.serverName method:model.methodName param:model.params type:model.requestType token:token];;
                        [self POST:model.path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            model.successBlock(responseObject);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            model.failedBlock(error);
                        }];
                        
                    }
                }else{
                    _needRequestToken = YES;
                    NSError *error = [NSError errorWithDomain:operation.responseString code:0 userInfo:nil];
                    for(MBHttpModel *model in _operationArray){
                        model.failedBlock(error);
                    }
                }
                [_operationArray removeAllObjects];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _needRequestToken = YES;
            
            for(MBHttpModel *model in _operationArray){
                model.failedBlock(error);
            }
            [_operationArray removeAllObjects];
        }];
    }
    
}

- (MBHttpModel *)combineRequestWithPath:(NSString *)path
                                 server:(NSString *)server
                                 method:(NSString *)method
                                 params:(NSDictionary *)param
                                success:(RequestSuccessBlock)success
                                 failed:(RequestFailedBlock)failed
                                   type:(NSString *)type
{
    MBHttpModel *model = [[MBHttpModel alloc] init];
    model.path = path;
    model.requestType = type;
    model.serverName = server;
    model.methodName = method;
    model.params = param;
    model.successBlock = success;
    model.failedBlock = failed;
    return model;
}

-(NSString *)dictionaryConvertedToStringWithdic:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str2;
}

//请求参数 合并 整理
- (NSDictionary *)configParamDictWithServer:(NSString *)server
                                     method:(NSString *)method
                                      param:(NSDictionary *)param
                                       type:(NSString *)type
                                      token:(NSString *)token
{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (token && [token length] > 0) {
        [paramDict setObject:token forKey:@"AccessToken"];
    }
    if (server && [server length] > 0) {
        [paramDict setObject:server forKey:@"ServiceName"];
    }
    if (method && [method length] > 0) {
        if ([type isEqualToString:@"GET"]) {
            [paramDict setObject:[NSString stringWithFormat:@"GET:%@",method] forKey:@"MethodName"];
        }else{
            [paramDict setObject:method forKey:@"MethodName"];
        }
    }
    
    if (param) {
        [paramDict setObject:[self dictionaryConvertedToStringWithdic:param] forKey:@"Message"];
    }
    NSString *device = [[NSUserDefaults standardUserDefaults] objectForKey:@"Esb-ClientInfo"];
    if (!device || [device length] == 0) {
        device = [[Globle shareInstance] getDeviceModelNameAndSystemVersion];
    }
    [paramDict setObject:device forKey:@"Esb-ClientInfo"];
    
    return paramDict;
}

@end
