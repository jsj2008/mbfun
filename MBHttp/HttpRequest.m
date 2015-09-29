 //
//  HttpRequest.m
//  InSquare
//
//  Created by ming on 14-6-10.
//  Copyright (c) 2014年 com.cwvs. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "Globle.h"
#import "Utils.h"
#import "MBShoppingGuideInterface.h"
#import "SDataCache.h"

#import <CommonCrypto/CommonDigest.h>
#define WXSC__Product    @"WXSC_Product"
#define WXSC_Collocation @"WXSC_Collocation"
#define WXSC_Order    @"WXSC_Order"
#define WXSC_Account  @"WXSC_Account"
//#define WXSC_Promotion @"WXSC_Promotion"
#define WXSC_Promotion @"Promotion"

@implementation HttpRequest
//+(AFHTTPRequestOperationManager*)sessionmanager{
//    static AFHTTPRequestOperationManager* manager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [AFHTTPRequestOperationManager manager];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES; //还是必须设成YES
//        manager.securityPolicy = securityPolicy;
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/x-www-form-urlencoded",@"text/xml",@"text/html",@"text/plain",@"text/json", @"text/javascript",nil];
//
//        ;
//        
//    });
//    return manager;
//}
//WXSC_Seller
+ (NSString *)convertServernameWithType:(MBServerNameType)type
{
    NSString *serverName = @"";
    switch (type) {
        case kMBServerNameTypeCollocation:
            serverName = @"Collocation";//WXSC_
            break;
        case kMBServerNameTypeProduct:
            serverName = @"WXSC_Product";
            break;
        case kMBServerNameTypeOrder:
//            serverName = @"WXSC_Order";
            serverName = @"Order";
            break;
        case kMBServerNameTypeAccout:
            serverName = @"WXSC_Account";
            break;
        case kMBServerNameTypeUpgrade:
            serverName = @"VCL_Upgrade";
            break;
        case kMBServerNameTypePromotion:
//            serverName = @"WXSC_Promotion";
             serverName = @"Promotion";
            break;
        case kMBServerNameTypeStatistics:
            serverName = @"WXSC_Statistics";
            break;
        case kMBServerNameTypeNoWXSCProduct:
            serverName =@"Product";
            break;
        case kMBServerNameTypeNoWXSCOrder:
            serverName =@"Order";
            break;
        case kMBServerNameTypeCart:
            serverName =@"Cart";
            break;
        case kMBServerNameTypeUser:
            serverName=@"User";
            break;
        default:
            break;
    }
    return serverName;
}


+ (void)getRequestPath:(MBServerNameType)serverType
            methodName:(NSString *)method
                params:(NSDictionary *)param
               success:(RequestSuccessBlock)success
                failed:(RequestFailedBlock)failed
{
    NSString *serverName = [self convertServernameWithType:serverType];
    if ([serverName length] == 0) {
        return;
    }
    [[MBHttpClient shareClient] mbGetRequestPath:nil serverName:serverName methodName:method params:param success:success failed:failed];
}


+ (void)postRequestPath:(MBServerNameType)serverType
             methodName:(NSString *)method
                 params:(NSDictionary *)param
                success:(RequestSuccessBlock)success
                 failed:(RequestFailedBlock)failed
{
    NSString *serverName = [self convertServernameWithType:serverType];
    if ([serverName length] == 0) {
        return;
    }
    [[MBHttpClient shareClient] mbPostRequestPath:nil serverName:serverName methodName:method params:param success:success failed:failed];
}

//不需要 token的网络请求 获取token im好友列表等
+ (void)requestWithOutTokenWithDomian:(NSString *)domain
                                 Path:(NSString *)path
                                param:(NSDictionary *)params
                              success:(RequestSuccessBlock)success
                               failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbRequestWithOutTokenWithDomian:domain Path:path param:params success:success failed:failed];
}

/*
 @param from 请求来源：1. 注册；2. 找回密码
 */
+ (void)requestInviteCodeWithPhone:(NSString *)phoneNum
                              from:(NSString *)from
                           success:(RequestSuccessBlock)success
                            failed:(RequestFailedBlock)failed
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:phoneNum,@"account",from,@"from", nil];
    [[MBHttpClient shareClient] mbRequestWithPath:@"/api/http/getcode" param:dict success:success failed:failed];
//    [[MBHttpClient shareClient] mbRequestWithOutTokenWithDomian:nil Path:@"/api/http/getcode" param:dict success:success failed:failed];
}

+ (void)mbLoginRequestWithType:(MBLoginType)type
                       account:(NSString *)account
                      password:(NSString *)password
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed
{
    if (type == kMBLoginTypeWeiXin) {
        
    }else if (type == kMBLoginTypeQQ){
        
    }else{
        NSLog(@"这是废弃接口吧");
        
        //        NSString *portalVersion=[MainTabViewController getPortalLocalVersion];
        NSString *portalVersion=@"";
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:account,@"login_account",password,@"password", @"02",@"comefrom", @"all",@"datascope", portalVersion, @"portalversion",nil];
        
        NSString *urlString =[NSString stringWithFormat:@"%@%@",DEFAULT_SERVER,@"/interface/logincheck"];
        [[MBHttpClient shareClient] mbRequestWithOutTokenWithDomian:nil Path:urlString param:dict success:^(NSDictionary *dict) {
            NSString *code = [dict objectForKey:@"returncode"];
            if ([code isEqualToString:@"0000"]) {
                success(dict);
            }else{
                NSError *error = [NSError errorWithDomain:@"用户名或者密码错误" code:[code integerValue] userInfo:nil];
                failed(error);
            }
            
        } failed:^(NSError *error) {
            failed(error);
        }];
    }
}

/*
 //promotion的网络请求
 //servername   VCL_Upgrade
 */

+ (void)promotionGetRequestPath:(NSString *)path
                     methodName:(NSString *)method
                         params:(NSDictionary *)param
                        success:(RequestSuccessBlock)success
                         failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Promotion" methodName:method params:param success:success failed:failed];
    
}


+ (void)promotionPostRequestPath:(NSString *)path
                      methodName:(NSString *)method
                          params:(NSDictionary *)param
                         success:(RequestSuccessBlock)success
                          failed:(RequestFailedBlock)failed
{
    if([method isEqualToString:@"receiveVouchersForCheck"])
    {
          [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Vouchers" methodName:method params:param success:success failed:failed];
    }
    else
    {
         [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Promotion" methodName:method params:param success:success failed:failed];
    }

}


/*饭票
 //Vouchers的网络请求
 //servername   VCL_Upgrade
 */

+ (void)vouchersGetRequestPath:(NSString *)path
                     methodName:(NSString *)method
                         params:(NSDictionary *)param
                        success:(RequestSuccessBlock)success
                         failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Vouchers" methodName:method params:param success:success failed:failed];
    
}


+ (void)vouchersPostRequestPath:(NSString *)path
                      methodName:(NSString *)method
                          params:(NSDictionary *)param
                         success:(RequestSuccessBlock)success
                          failed:(RequestFailedBlock)failed
{
        [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Vouchers" methodName:method params:param success:success failed:failed];
}


+ (void)collocationGetRequestPath:(NSString *)path
                       methodName:(NSString *)method
                           params:(NSDictionary *)param
                          success:(RequestSuccessBlock)success
                           failed:(RequestFailedBlock)failed
{
    //WXSC_
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Collocation" methodName:method params:param success:success failed:failed];
}


+ (void)collocationPostRequestPath:(NSString *)path
                        methodName:(NSString *)method
                            params:(NSDictionary *)param
                           success:(RequestSuccessBlock)success
                            failed:(RequestFailedBlock)failed
{//WXSC_
    [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Collocation" methodName:method params:param success:success failed:failed];
}

+ (void)productGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed
{
//    if(path.length==0)
//    {
//         [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"WXSC_Product" methodName:method params:param success:success failed:failed];
//    }
//    else
//    {
          [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Product" methodName:method params:param success:success failed:failed];
//    }

}


+ (void)productPostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed
{
    if (path.length==0) {
          [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Product" methodName:method params:param success:success failed:failed];
    }
    else
    {
        [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Product" methodName:method params:param success:success failed:failed];
    }

}

+ (void)orderGetRequestPath:(NSString *)path
                 methodName:(NSString *)method
                     params:(NSDictionary *)param
                    success:(RequestSuccessBlock)success
                     failed:(RequestFailedBlock)failed
{
    if ([method isEqualToString:@"ShoppingCartStaticFilter"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
        
        [dic setValue:param[@"UserId"] forKey:@"userId"];
        [dic removeObjectForKey:@"UserId"];
        param = [dic copy];
        [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Cart" methodName:method params:param success:^(NSDictionary *dict) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
            if ([dictionary[@"total"] intValue] == 0) {
                dictionary[@"total"] = @1;
            }
            if ([dict[@"isSuccess"] intValue] == 0) {
                dictionary[@"results"] = @[@{@"count": @0}];
            }
            success(dictionary);
        } failed:failed];
    }
    else
    {
     [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Order" methodName:method params:param success:success failed:failed];
    }
    
}


+ (void)orderPostRequestPath:(NSString *)path
                  methodName:(NSString *)method
                      params:(NSDictionary *)param
                     success:(RequestSuccessBlock)success
                      failed:(RequestFailedBlock)failed
{
    if([[NSString stringWithFormat:@"%@",path] isEqualToString:@"Cart"])
    {
        path=nil;
        [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Cart" methodName:method params:param success:success failed:failed];
 
    }
    else
    {
        [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"Order" methodName:method params:param success:success failed:failed];
    }
}
+ (void)LogisticsGetRequestPath:(NSString *)path
                     methodName:(NSString *)method
                         params:(NSDictionary *)param
                        success:(RequestSuccessBlock)success
                         failed:(RequestFailedBlock)failed {
    
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"Order" methodName:method params:param success:success failed:failed];
}
+ (void)accountGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"WXSC_Account" methodName:method params:param success:success failed:failed];
}


+ (void)accountPostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"WXSC_Account" methodName:method params:param success:success failed:failed];
}

+ (void)upgradeGetRequestPath:(NSString *)path
                   methodName:(NSString *)method
                       params:(NSDictionary *)param
                      success:(RequestSuccessBlock)success
                       failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbGetRequestPath:path serverName:@"VCL_Upgrade" methodName:method params:param success:success failed:failed];
}


+ (void)upgradePostRequestPath:(NSString *)path
                    methodName:(NSString *)method
                        params:(NSDictionary *)param
                       success:(RequestSuccessBlock)success
                        failed:(RequestFailedBlock)failed
{
    [[MBHttpClient shareClient] mbPostRequestPath:path serverName:@"VCL_Upgrade" methodName:method params:param success:success failed:failed];
}

+(void)printObject:(NSDictionary*)dic isReq:(BOOL)isReq{
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
       
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         NSString *str1 = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//        NSLog(@"printObject-----%@",dic);
        if (isReq) {
             NSLog(@"request-----%@",str1);
        }else{
          NSLog(@"respone-----%@",str1);
        }
       
        
    }
}

-(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSLog(@"seconds=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}
//将NSDate类型的时间转换为NSInteger类型,从1970/1/1开始
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSLog(@"interval=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}
#pragma mark- 图片缓存
//add by miao  11.25

-(NSString *)fileNameHash:(NSString *)filename
{
    return [[NSString alloc] initWithFormat:@"%@.%@",[Hash dataMD5:[filename dataUsingEncoding:NSUTF8StringEncoding]],[filename pathExtension]];
}


-(void)downloadImageUrl:(NSString *)imageUrl  defaultImageName:(NSString *)defaultImageName WithImageView:(UIImageView *)imageView
{
    _localImageFilePath = [NSString stringWithFormat:@"%@/%@",[AppSetting getMBCacheFilePath], [self fileNameHash:imageUrl]];
    
    //    [[NSFileManager defaultManager] removeItemAtPath:localImageFilePath error:nil];
    if (imageUrl.length>0) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:_localImageFilePath])
        {
            NSURL *url=[NSURL URLWithString:imageUrl];
            //实例化ASIHTTPRequest
            ASIHTTPRequest *_httpRequest=[ASIHTTPRequest requestWithURL:url];
            
            //本次请求参数
            _httpRequest.userInfo=[[NSMutableDictionary alloc] init];
            [_httpRequest.userInfo setValue:imageView forKey:@"imageView"];
            [_httpRequest.userInfo setValue:_localImageFilePath forKey:@"localFilePath"];
            
            [_httpRequest setDelegate:self];
            //开始异步下载
            [_httpRequest startAsynchronous];
            
            if (defaultImageName.length>0)
                imageView.image =  [UIImage imageNamed:defaultImageName];
        }
        else
        {
            imageView.image = [UIImage imageWithContentsOfFile:_localImageFilePath];
        }
    }
    else
    {
        if (defaultImageName.length>0)
            imageView.image = [UIImage imageNamed:defaultImageName];
    }
    

}

#pragma mark ---异步下载完成
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSError *error=[request error];
    if (error) {
        return;
    }
    if ([request responseStatusCode]/100!=2 )
        return;
    
    //创建图片,图片来源于ASIHTTPRequest对象（NSSData类型）
    NSString *filenamepath=request.userInfo[@"localFilePath"];
    NSData *filedata=[request responseData];
    if (filedata.length<20) return;
    
    [filedata writeToFile:filenamepath atomically:NO];
    
    //param:cellView,imageView,rownum
    UIImageView *imgView=request.userInfo[@"imageView"];
//    if ([_localImageFilePath isEqualToString: filenamepath])
//    {
        //        imgView.contentMode = UIViewContentModeScaleAspectFit;
        //        imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        //        imgView.backgroundColor=[UIColor whiteColor];//SNS_BACKGROUND_SILVERCOLOR;
        imgView.image=[UIImage imageWithData:filedata];
//    }
    
}


#pragma mark -- Http 上传图片传文件
-(void)upLoadImage:(NSString *)imgInfo
          filePath:(NSString *)filePath
           success:(RequestSucessBlock) success
              fail:(RequestFailBlock)fail
{
    //传二进制
    //    NSMutableArray *imageAry1=[[NSMutableArray alloc]init];
    //    Byte *testByte1 = (Byte *)[data bytes];
    //    for(int i=0;i<[data length];i++)
    //    {
    //        [imageAry1 addObject:[NSNumber numberWithInt:testByte1[i]]];
    //    }
    //接口地址
    NSString *urlstr=[NSString stringWithFormat:@"%@/%@",MAIN_SERVICE_URL16,@"upload"];
    NSURL* imageURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:urlstr]];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"text/html",@"application/json",nil];
    
    [manager POST:urlstr parameters:@{@"kind":imgInfo,@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:imageURL name:@"file" error:nil];
//        [formData app]
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error.description);
        
    }];
    
    
}


#pragma mark --- HTTP GET
+(void)startHTTPRequestWithMethod:(NSString *)method
                            param:(NSDictionary*)param
                          success:(RequestSucessBlock)finishBlock
                             fail:(RequestFailBlock)failBlock{
//    NSString *urlstr=[NSString stringWithFormat:@"%@/%@",MAIN_SERVICE_URL,method];
    

    [[MBHttpClient shareClient] GET:method
                    parameters:param
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [HttpRequest printObject:responseObject isReq:NO];
                           finishBlock(responseObject);

    }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failBlock(error.description);


    }];
}

#pragma mark --- HTTP GET  -- token
+(void)startHTTPRequestWithMethod:(NSString *)method
                            istoken:(BOOL)istoken
                            param:(NSDictionary*)param
                          success:(RequestSucessBlock)finishBlock
                             fail:(RequestFailBlock)failBlock{

    //    //重组请求参数
    NSMutableDictionary *getdic =[NSMutableDictionary dictionaryWithDictionary:param];
    //    [postdic setObject:@"1.0" forKey:@"version"];
    if (istoken) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
        [getdic setObject:accessToken?accessToken:@"" forKey:@"AccessToken"];
    }
    [[MBHttpClient shareClient] GET:method
                    parameters:getdic
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           [HttpRequest printObject:responseObject isReq:NO];
                           finishBlock(responseObject);
                   
                       }
                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           failBlock(error.description);

                           
                       }];
}

#pragma mark --- HTTP POST


#pragma mark --- HTTP POST
+(void)startPostRequestWithMethod:(NSString *)method                //接口方法名
                          istoken:(BOOL)istoken                     //是否有token
                          isToast:(BOOL)isToast
                            param:(NSDictionary*)param              //请求参数
                          success:(RequestSucessBlock)finishBlock   //请求成功
                             fail:(RequestFailBlock)failBlock{      //请求失败
    
    if(![self reachRequestNetworkStatus])
    {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utils alertMessage:@"网络连接失败,请检查网络设置"];
        });
        
        return;
    }
    
    if (isToast) {
        [Toast makeToastActivity:@"正在加载数据..." hasMusk:NO];//正在加载...
    }
   
//    //重组请求参数
    NSMutableDictionary *postdic =[NSMutableDictionary dictionaryWithDictionary:param];
//    [postdic setObject:@"1.0" forKey:@"version"];
    if (istoken) {
        NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
        [postdic setObject:accessToken?accessToken:@"" forKey:@"AccessToken"];
        NSString *clientInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"Esb-ClientInfo"];
        [postdic setObject:clientInfo?clientInfo:@"" forKey:@"Esb-ClientInfo"];
    }
    //打印参数
    NSLog(@"\n=====接口:%@",postdic);
    [HttpRequest printObject:postdic isReq:YES];
   
    ///／／／／／／ 新.net
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:param];
//    [dic setValue:[NSString stringWithFormat:@"%@",server] forKey:@"m"];
    [dic setValue:[NSString stringWithFormat:@"%@",method] forKey:@"a"];

    param = dic;
    [[SDataCache sharedInstance] quickPost:SERVER_URL parameters:param  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HttpRequest printObject:responseObject isReq:NO];
            [Toast hideToastActivity];
            finishBlock(responseObject);
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
//                    failed(respError);
                         failBlock(respError.description);
                });
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
//                failed(error);
                       failBlock(error.description);
            });
        }
        
    }];


    
    
    
    
    
    // 新接口
    
    
    
    
    
    
    
    return;
    
// self sessionmanager
    [[MBHttpClient shareClient] POST:method
                     parameters:postdic
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [HttpRequest printObject:responseObject isReq:NO];
                            
                            [Toast hideToastActivity];
                            finishBlock(responseObject);
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             NSLog ( @"operation: %@" , operation. responseString );
                            NSLog(@"请求出错：%@",error.description);
                             [Toast hideToastActivity];
                            failBlock(error.description);
                        
                            
                            //token 失效
                            NSRange foundObj =[operation.responseString rangeOfString:@"40004" options:NSCaseInsensitiveSearch];
                            
                            NSRange foundObj2 =[operation.responseString rangeOfString:@"40003" options:NSCaseInsensitiveSearch];
                            if(foundObj.length>0 || foundObj2.length >0) {
                                [[HttpRequest shareRequst] httpRequestGetSOAaccessTokenWithdic:nil success:^(id obj) {
                                    NSString *access_token =  [obj objectForKey:@"access_token"];
                                    [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"AccessToken"];
                                    
                                } fail:^(NSString *errorMsg) {
                                    NSLog(@"%@",errorMsg);
                                }];
                            } else {
                                
                                 NSRange foundObj3 =[operation.responseString rangeOfString:@"49999" options:NSCaseInsensitiveSearch];
                                if (foundObj3.length>0) {
                                    [Toast makeToast:[NSString stringWithFormat:@"服务器请求超时"]];
                                }else{
                                    NSString *returnStr= [Utils getSNSString:operation.responseString];
                                    if(returnStr.length > 0)
                                    {
                                        [Toast makeToast:[NSString stringWithFormat:@"%@",operation. responseString]];
                                    }
                                }
                            }

                        }];
    
    
}


//请求类
+(HttpRequest *)shareRequst
{
    static HttpRequest* request;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        request = [[HttpRequest alloc] init];
    });
    return request;
}
+ (NetworkStatus)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    // NotReachable     - 没有网络连接
    // ReachableViaWWAN - 移动网络(2G、3G)
    // ReachableViaWiFi - WIFI网络
    return [reachability currentReachabilityStatus];
}

+(BOOL)reachRequestNetworkStatus
{
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status = [hostReach currentReachabilityStatus];
    if (status == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark--字典转换成string
-(NSString *)dictionaryConvertedToStringWithdic:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"/r/n"withString:@""];
    
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"/n"withString:@""];
    
    NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"/t"withString:@""];
    
    NSLog(@"responseString = %@",str5);
    return str5;
}

#pragma mark--YYAnimationIndicator
+(YYAnimationIndicator *)addYYAnimationIndicator{
    YYAnimationIndicator *__YYAnimationIndicator;
    if ([[AppDelegate shareAppdelegate].window viewWithTag:10000]== nil) {
        __YYAnimationIndicator= [[YYAnimationIndicator alloc]initWithFrame:CGRectMake([AppDelegate shareAppdelegate].window.frame.size.width/2-40,     [AppDelegate shareAppdelegate].window.frame.size.height/2-40, 80, 80)];
        __YYAnimationIndicator.tag = 10000;
        __YYAnimationIndicator.hidden = YES;
        [__YYAnimationIndicator setLoadText:@"正在加载..."];
        [[AppDelegate shareAppdelegate].window addSubview:__YYAnimationIndicator];
    }
    
    [[AppDelegate shareAppdelegate].window bringSubviewToFront:[[AppDelegate shareAppdelegate].window viewWithTag:10000]];
    
    return (YYAnimationIndicator *)[[AppDelegate shareAppdelegate].window viewWithTag:10000];
}
#pragma mark -----------接口请求--------------
#pragma mark -- 1.搭配主信息创建
-(void)httpRequestPostCollocationCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail
{
    /*
       NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationCreate",MAIN_SERVICE_URL16];
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:NO
                                      param:postdic
                                    success:success
                                       fail:fail];
    */
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [postDicdic setObject:@"CollocationCreate" forKey:@"MethodName"];
    if (postdic != nil) {
         [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
   
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];

}

#pragma mark -- 2.商品类别请求
-(void)httpRequestGetProductCategoryFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail
{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/ProductCategoryFilter?format=json",MAIN_SERVICE_URL15];
 [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ProductCategoryFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
    
}
#pragma mark -- 3.根据分类id请求商品  废弃
-(void)httpRequestGetProductCategoryClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail
{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/ProductCategoryClsFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ProductCategoryClsFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
    
}

#pragma mark -- 4.请求所有模板 old
-(void)httpRequestGetWxCollocationTemplateFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail
{//http://10.100.20.180:8016/WxCollocationTemplateFilter?format=json
    /*
     NSString *urlstr=[NSString 		stringWithFormat:@"%@/WxCollocationTemplateFilter?format=json",MAIN_SERVICE_URL16];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WxCollocationTemplateFilter" forKey:@"MethodName"];
    if (getdic != nil) {
         [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
   
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
    

}
#pragma mark -- 5.根据id请求点击草稿信息
-(void)httpRequestGetCollocationEditFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
//http://10.100.20.180:8016/CollocationEditFilter/?format=json&id=316
    /*
       NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationEditFilter?format=json",MAIN_SERVICE_URL16];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:CollocationEditFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES  isToast:YES param:getDicdic success:success fail:fail];

}
#pragma mark -- 6.搭配主信息查询（我的界面搭配接口及草稿箱查询接口）
-(void)httpRequestGetCollocationFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail//&status=1
{//http://10.100.20.180:8016/CollocationFilter?format=json
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationFilter?format=json",MAIN_SERVICE_URL16];
//    NSString *urlstr = [NSString stringWithFormat:@"CollocationFilter?format=json"];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
    */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WxCollocationSetFilter" forKey:@"MethodName"];
    if (getdic != nil) {
           [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
 
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES
                                      param:getDicdic success:success fail:fail];
}
#pragma mark -- 7.搭配信息删除接口
-(void)httpRequestPostCollocationDeleteWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
//http://10.100.20.180:8016/CollocationDelete
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationDelete",MAIN_SERVICE_URL16];
    [HttpRequest startPostRequestWithMethod:urlstr istoken:NO param:postdic success:success fail:fail ];
     */
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [postDicdic setObject:@"CollocationDelete" forKey:@"MethodName"];
    if (postdic != nil)
    {
         [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
   
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];

}
#pragma mark -- 8.搭配自身主题信息查询接口
-(void)httpRequestGetWxCollocationShowTopicFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
//http://10.100.20.180:8016/WxCollocationShowTopicFilter?format=json
    /*
        NSString *urlstr=[NSString 		stringWithFormat:@"%@/WxCollocationShowTopicFilter?format=json",MAIN_SERVICE_URL16];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WxCollocationShowTopicFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 9.搭配信息保存到草稿箱接口//搭配保存在草稿箱，未发布的时候，不会推送到精选中。
-(void)httpRequestPostCollocationDraftCreate:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationDraftCreate",MAIN_SERVICE_URL16];
    [HttpRequest startPostRequestWithMethod:urlstr istoken:NO param:postdic success:success fail:fail];
     */
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [postDicdic setObject:@"CollocationDraftCreate" forKey:@"MethodName"];
    if (postdic != nil) {
          [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
  
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
}
#pragma mark -- 10.搭配风格信息查询接口
-(void)httpRequestGetWxCollocationShowTagFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
        NSString *urlstr=[NSString 		stringWithFormat:@"%@/WxCollocationShowTagFilter?format=json",MAIN_SERVICE_URL16];
     [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WxCollocationShowTagFilter" forKey:@"MethodName"];
    if (getdic != nil) {
         [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
   
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
    
}
#pragma mark -- 11.搭配系统模板信息查询接口
-(void)httpRequestGetCollocationSystemModuleFilter:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/CollocationSystemModuleFilter?format=json",MAIN_SERVICE_URL16];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
//GET:CollocationSystemModuleFilter
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];//
    [getDicdic setObject:@"GET:CollocationModuleFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];

}
#pragma mark -- 12.商品颜色查询接口调用
-(void)httpRequestGetBaseColorFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/BaseColorFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:BaseColorFilter" forKey:@"MethodName"];
    if (getdic != nil) {
         [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
   
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];

}
#pragma mark -- 13.素材上传 不修改
-(void)httpRequestPostWXPicMaterialCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/WXPicMaterialCreate",MAIN_SERVICE_URL16];
   [HttpRequest startPostRequestWithMethod:urlstr istoken:NO param:postdic success:success fail:fail];
     */
    
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [postDicdic setObject:@"WXPicMaterialCreate" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
    
}
#pragma mark -- 14.查询素材
-(void)httpRequestGetWXPicMaterialFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
/*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/WXPicMaterialFilter?format=json",MAIN_SERVICE_URL16];
   [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
 */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WXPicMaterialFilter" forKey:@"MethodName"];
    if (getdic != nil) {
         [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
   
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 15.品牌查询
-(void)httpRequestGetBrandFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/BrandFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:BrandFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 16.商品搜索
-(void)httpRequestGetProductClsSearchFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 	  stringWithFormat:@"%@/ProductClsSearchFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ProductClsSearchFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 17.价格区间查询接口
-(void)httpRequestGetBasePriceFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 	  stringWithFormat:@"%@/BasePriceFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:BasePriceFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];

}
#pragma mark -- 18.商品品分类二级分类查询接口 （一二级同事全部获得分类）
-(void)httpRequestGetProductCategorySubItemFilterWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success ail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 	  stringWithFormat:@"%@/ProductCategorySubItemFilter?format=json",MAIN_SERVICE_URL15];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ProductCategorySubItemFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 19.SOA获取AppId=<<AppId>>&Secret=<<Secret>>
-(void)httpRequestGetSOAaccessTokenWithdic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/CallCenter/OAuth/AccessToken.ashx",MAIN_SERVICE_SOA_TOKEN_URL];
    //参数拼接
    NSMutableDictionary *getdicdic =[NSMutableDictionary dictionaryWithDictionary:getdic];
    [getdicdic setObject:SOA_APP_KEY forKey:@"AppId"];
    [getdicdic setObject:SOA_SECRET forKey:@"Secret"];
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:NO isToast:YES param:getdicdic success:success fail:fail];
//       [HttpRequest startHTTPRequestWithMethod:urlstr param:getdicdic success:success fail:fail];
}

#pragma mark -- 20.(商品)喜欢创建
-(void)httpRequestPostFavoriteCreateWithdic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
  /*
     NSString *urlstr=[NSString 		stringWithFormat:@"%@/FavoriteCreate",MAIN_SERVICE_URL18];
     [HttpRequest startPostRequestWithMethod:urlstr
     istoken:NO
     param:postdic
     success:success
     fail:fail];
    */
   
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Order forKey:@"ServiceName"];
    [postDicdic setObject:@"FavoriteCreate" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
    
}

#pragma mark -- 21.(商品)喜欢删除及取消喜欢 IDS	List<int>	ID 集合	传入IDS=1，2 逗号隔开
-(void)httpRequestPostFavoriteDeleteWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/FavoriteDelete",MAIN_SERVICE_URL18];
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:NO
                                      param:postdic
                                    success:success
                                       fail:fail];
    */
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Order forKey:@"ServiceName"];
    [postDicdic setObject:@"FavoriteDelete" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];

}

#pragma mark -- 36.(商品)判断是否喜欢
-(void)httpRequestGetJugeFavoriteFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Order forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:FavoriteFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}

#pragma mark -- 37.(商品)获取喜欢列表
-(void)httpRequestGetFavoriteProductClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Order forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:FavoriteProductClsFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}



#pragma mark -- 22.剪切图查询接口
-(void)httpRequestGetWXPicShearFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    /*
    NSString *urlstr=[NSString 		stringWithFormat:@"%@/WXPicShearFilter?format=json",MAIN_SERVICE_URL16];
    [HttpRequest startHTTPRequestWithMethod:urlstr param:getdic success:success fail:fail];
     */
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WXPicShearFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}

#pragma mark -- 23.(商品)相似商品  id是商品款ID
-(void)httpRequestGetProductClsFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{


    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ProductClsFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];

}
#pragma mark -- 24.左右滑动随机搭配接口
-(void)httpRequestGetWxCollocationRandomFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{

    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:WxCollocationRandomFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}
#pragma mark -- 25.获取文字信息的接口
-(void)httpRequestGetTextFontInfoFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:TextFontInfoFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}

#pragma mark -- 26.购物车统计查询
-(void)httpRequestGetShoppingCartStaticFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Order forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:ShoppingCartStaticFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:NO param:getDicdic success:success fail:fail];

}

#pragma mark -- 27.查询门店导购信息

-(void)httpRequestGetSCSIGNRECORDFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Account forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:SCSIGNRECORDFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}


#pragma mark -- 28.门店基础信息查询
-(void)httpRequestGetOrgBasicInfoFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{

    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:OrgBasicInfoFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
    
}



#pragma mark -- 29.记录滑酷信息创建记录滑酷信息
-(void)httpRequestPostWXSlideCoolInfoCreateWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    /*
     NSString *urlstr=[NSString 		stringWithFormat:@"%@/FavoriteCreate",MAIN_SERVICE_URL18];
     [HttpRequest startPostRequestWithMethod:urlstr
     istoken:NO
     param:postdic
     success:success
     fail:fail];
     */
    
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [postDicdic setObject:@"WXSlideCoolInfoCreate" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
    
}

#pragma mark -- 30.通过用户商品信息计算运费
-(void)httpRequestPostPromotionFeeCalcWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Promotion forKey:@"ServiceName"];
    [postDicdic setObject:@"PromotionFeeCalc" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];

}
#pragma mark -- 31.通过用户商品信息计算优惠金额
-(void)httpRequestPostPromotionDisCalcWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC_Promotion forKey:@"ServiceName"];
    [postDicdic setObject:@"PromotionDisCalc" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
    
}
#pragma mark -- 32.门店信息取最低优惠价格
-(void)httpRequestPostBatchProductPriceFilterWithDic:(NSMutableDictionary *)postdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *postDicdic = [NSMutableDictionary new];
    [postDicdic setObject:WXSC__Product forKey:@"ServiceName"];
    [postDicdic setObject:@"BatchProductPriceFilter" forKey:@"MethodName"];
    if (postdic != nil) {
        [postDicdic setObject:[self dictionaryConvertedToStringWithdic:postdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:postDicdic
                                    success:success
                                       fail:fail];
    
}

#pragma mark --33.服务万能获取接口get

-(void)httpRequestGetBSParamFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:BSParamFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:NO param:getDicdic success:success fail:fail];
}
#pragma mark -- 34.	系统模板分类查询（供app使用）
-(void)httpRequestGetCollocationModuleCategoryUserFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
  
    //soa get
    NSString *urlstr=[NSString 		stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:CollocationModuleCategoryUserFilter" forKey:@"MethodName"];
    if (getdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
  [HttpRequest startPostRequestWithMethod:urlstr  istoken:YES isToast:YES param:getDicdic success:success fail:fail];
}

#pragma mark -35.系统模板查询单个模板详细信息（根据模板id）
-(void)httpRequestGetCollocationModuleEditFilterWithDic:(NSMutableDictionary *)getdic success:(RequestSucessBlock)success fail:(RequestFailBlock)fail{
    // soa post
    NSString *urlstr = [NSString stringWithFormat:MAIN_SERVICE_SOA_URL];
    NSMutableDictionary *getDicdic = [NSMutableDictionary new];
    [getDicdic setObject:WXSC_Collocation forKey:@"ServiceName"];
    [getDicdic setObject:@"GET:CollocationModuleEditFilter" forKey:@"MethodName"];
    if (getDicdic != nil) {
        [getDicdic setObject:[self dictionaryConvertedToStringWithdic:getdic] forKey:@"Message"];
    }
    
    
    [HttpRequest startPostRequestWithMethod:urlstr
                                    istoken:YES
                                    isToast:YES
                                      param:getDicdic
                                    success:success
                                       fail:fail];
}
/*
-(void)testrequestsuccess:(RequestSucessBlock)success fail:(RequestFailBlock)fail{

//    NSString *urlstr=[NSString 		stringWithFormat:@"http://capapi.xwf-id.com:80/capwebsite/api/v1/account/verifyOtp?"];
//    
//    [HttpRequest startHTTPRequestWithMethod:urlstr param:@{@"access_token":@"123123",@"taskId":@"1",@"username":@"1",@"password":@"1",@"otpvalue":@"1"} success:success fail:fail];
    
     NSString *urlstr=[NSString 		stringWithFormat:@"http://capapi.xwf-id.com:80/capwebsite//api/v1/account/login?"];
    [HttpRequest startPostRequestWithMethod:urlstr  istoken:NO param:@{
        @"memberId": @"",
        @"terminalId": @"",
        @"sessionId": @"",
        @"loginFrom": @"",
        @"ip": @""
    } success:success fail:fail];
}

- (NSString*)stringByURLEncodingStringParameter:(NSString *)str
{
    // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
    // some characters that should be escaped in URL parameters, like / and ?;
    // we'll use CFURL to force the encoding of those
    //
    // We'll explicitly leave spaces unescaped now, and replace them with +'s
    //
    // Reference: <a href="%5C%22http://www.ietf.org/rfc/rfc3986.txt%5C%22" target="\"_blank\"" onclick='\"return' checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
    
    NSString *resultStr = str;
    
    CFStringRef originalString = (__bridge CFStringRef) resultStr;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

*/
@end
