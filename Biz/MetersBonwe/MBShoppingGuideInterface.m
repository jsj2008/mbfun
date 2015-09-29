//
//  MBShoppingGuideInterface.m
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.


//  TODO : 这里绝对都是垃圾代码，后续全部清理，尼玛
//

#import "MBShoppingGuideInterface.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "JSON.h"
#import "Utils.h"
#import "Reachability.h"
#import "Toast.h"
#import "ModelBase.h"
#import "SDataCache.h"

NSString *MBShoppingGuideServer=@"http://10.100.20.180:8016";

NSString *ShoppingCartFilter=@"http://10.100.20.180:8018/ShoppingCartFilter?format=json";
NSString *CommentFilter=@"http://10.100.20.180:8018/CommentFilter?format=json";
//评论创建接口
NSString *CommentCreate = @"http://10.100.20.180:8018/CommentCreate?format=json";
NSString *WxCollocationStatisticsFilter=@"http://10.100.20.180:8016/WxCollocationStatisticsFilter?format=json";
//搭配主信息查询接口
NSString *CollocationFilter=@"http://10.100.20.180:8016/CollocationFilter?format=json";
//分类接口
NSString *WxCollocationTagFilter = @"http://10.100.20.180:8016/WxCollocationTagFilter?format=json";
//分类对应搭配接口
NSString *WxCollocationTagMappingFilter = @"http://10.100.20.180:8016/WxCollocationTagMappingFilter?format=json";
//浏览记录创建接口
NSString *WxCollocationBrowserCreate=@"http://10.100.20.180:8016/WxCollocationBrowserCreate?format=json";
//订单创建接口
NSString *OrderCreate=@"http://10.100.20.180:8018/OrderCreate?format=json";
//喜欢查询接口
NSString *FavoriteCollocationFilter=@"http://10.100.20.180:8018/FavoriteCollocationFilter?format=json";
//喜欢创建接口
NSString *FavoriteCreate=@"http://10.100.20.180:8018/FavoriteCreate?format=json";
//喜欢删除接口
NSString *FavoriteDelete=@"http://10.100.20.180:8018/FavoriteDelete?format=json";
//喜欢查询
NSString *FavoriteFilter=@"http://10.100.20.180:8018/FavoriteFilter?format=json";
//搭配详细 接口
NSString *CollocationDetailFilter = @"http://10.100.20.180:8016/CollocationDetailFilter?format=json";//&id=623
NSString *WxSellerAccountByAccountFilter = @"http://10.100.20.180:8016/WxSellerAccountByAccountFilter?format=json";
//收货人查询接口
NSString *ReceiverFilter=@"http://10.100.20.180:8018/ReceiverFilter?format=json";
NSString *ReceiverCreate = @"http://10.100.20.180:8018/ReceiverCreate?format=json";
NSString *ReceiverUpdate = @"http://10.100.20.180:8018/ReceiverUpdate?format=json";
NSString *ReceiverDelete=@"http://10.100.20.180:8018/ReceiverDelete?format=json";
//订单查询接口
NSString *MyOrderFilter = @"http://10.100.20.180:8018/OrderFilter?format=json";
//订单取消
NSString *MyOrderCancleFilter =@"http://10.100.20.180:8018/OrderCancel?format=json";
//订单评论
NSString *MyCommentCreate =@"http://10.100.20.180:8018/CommentCreate?format=json";
//确认收货
NSString *MyOrderConfirm=@"http://10.100.20.180:8018/OrderConfirm?format=json";
//申请退款
NSString *MyOrderRefund=@"http://10.100.20.180:8018/OrderRefund?format=json";
//申请退货
NSString *MyOrderReturn=@"http://10.100.20.180:8018/OrderReturn?format=json";
//WX预支付订单生成
NSString *WxPrePayFlowCreate = @"http://10.100.20.180:8018/WxPrePayFlowCreate?format=json";
//支付
NSString *OrderPaid = @"http://10.100.20.180:8018/OrderPaid?format=json";

//////////////////////////
MBShoppingGuideInterface *SHOPPING_GUIDE_ITF=nil;

NSString *SHARE_COLLOCATION_URL=nil;
NSString *SHARE_PROD_URL=nil;
double DEFAULT_FEE = 0.0;

//NSMutableArray *attenDesignerList=nil;

//////////////////////////
@implementation MBShoppingGuideInterface

+(MBShoppingGuideInterface *)create
{
    //https://10.100.20.214/CallCenter/OAuth/AccessToken.ashx?AppId=<<AppId>>&Secret=<<Secret>>

    return SHOPPING_GUIDE_ITF==nil?(SHOPPING_GUIDE_ITF=[[MBShoppingGuideInterface alloc] init]):SHOPPING_GUIDE_ITF;
}


-(BOOL)requestMBSoaToken:(NSMutableString *)returncode
{
    NSString *url=[NSString stringWithFormat:@"%@/CallCenter/OAuth/AccessToken.ashx",MBSoaServer];
    //参数拼接
    NSDictionary *param =@{@"AppId":SOA_APP_KEY,@"Secret":SOA_SECRET};
    BOOL success=NO;
    @try
    {
        NSString *rst=[self ASIPostJSonRequestUrl:url PostParam:param];
//        NSString *rst=[self tokenPostJSonRequestUrl:url PostParam:param];

//        NSString *rst=[self ASIGetJSonRequestUrl:url GetParam:param Method:@"GET"];
        if ([rst length]>0)
        {
            NSLog(@">>>>>>>>>>>>requestMBSoaToken=%@>>>>>>>>>",rst);
            NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
            if (range.location!=NSNotFound)
            {
                rst=[rst substringFromIndex:range.location+range.length+1 ];
            }
            NSDictionary * dicResult = [rst objectFromJSONString];
            if (dicResult[@"access_token"]!=nil)
            {
                [[NSUserDefaults standardUserDefaults] setObject:dicResult[@"access_token"] forKey:@"AccessToken"];
                if (returncode!=nil)
                    [returncode setString:dicResult[@"access_token"]];
                success=YES;
                NSLog(@">>>>>>>>>>>>new Token=%@>>>>>>>>>",dicResult[@"access_token"]);
            }
            else if (dicResult[@"errcode"]!=nil)
            {
                if (returncode!=nil)
                    [returncode setString:[Utils getSNSInteger:dicResult[@"errcode"]]];
            }
            else
                if (returncode!=nil)
                    [returncode setString:@"-2"];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    return success;
}

-(NSString*)getMapping:(NSString *)name
{
    NSString *serviceName=@"";
    NSString *tmp;
    
    NSError *error;
    NSString *resourceName =[[NSBundle mainBundle] pathForResource:@"MBServiceMapping" ofType:@"txt"];
    NSString *txt=[NSString stringWithContentsOfFile:resourceName encoding:NSUTF8StringEncoding error:nil];
    if (error) {
        NSLog(@"读取文件出错：%@", error);
        return nil;
    }

    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [txt componentsSeparatedByString:@"\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    
    // 读取<>里的内容
    while(tmp = [nse nextObject]) {
        NSRange srange=[tmp rangeOfString:@"["];
        NSRange erange=[tmp rangeOfString:@"]"];
        if (srange.location!=NSNotFound && erange.location!=NSNotFound) {
            serviceName=[[NSString alloc] initWithFormat:@"%@",[tmp substringWithRange:NSMakeRange(srange.location+1, erange.location-srange.location-1)] ];
        }
        else
        {
            if ([tmp isEqualToString:name])
            {
                return serviceName;
            }
        }
    }
    return @"";
}

-(NSString *)dictionaryConvertedToStringWithdic:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str2;
}
//废弃  只在 检查更新 about用过一次 已注释
-(BOOL)requestMBSoaServer:(NSString*)name param:(NSDictionary *)param method:(NSString*)method responseObject:(id)responseObject returnMsg:(NSMutableString *)returnMsg
{
    __block BOOL success=YES;
    __block id responseObjectBlack;
    __block NSMutableString *returnMsgStr= [[NSMutableString alloc]init];
    
    //调不通的老接口
    NSArray * oldArray=@[@"ProductClsCommonSearchFilter",@"ProductFilter",@"ProductClsFilter",@"PlatFormDisAmount"];
    if ([oldArray containsObject:name])
    {
        NSString *token=[[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"] ];
        
        NSString *urlstr = [NSString stringWithFormat:@"%@/CallCenter/InvokeSecurity.ashx",MBSoaServer];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:token forKey:@"AccessToken"];
        [dict setObject:[self getMapping:name] forKey:@"ServiceName"];
        if ([[method uppercaseString] isEqualToString:@"GET"])
        {
            [dict setObject:[[NSString alloc] initWithFormat:@"GET:%@",name] forKey:@"MethodName"];
        }
        else
        {
            [dict setObject:name forKey:@"MethodName"];
        }
        if (param != nil) {
            [dict setObject:[self dictionaryConvertedToStringWithdic:param] forKey:@"Message"];
        }
        
        BOOL success=NO;
        @try
        {
            for (int i=0;i<3;i++)
            {
                NSString *rst=[self ASIPostJSonRequestSecureUrl:urlstr PostParam:dict];
                if ([rst length]>0)
                {
                    NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
                    if (range.location!=NSNotFound)
                    {
                        NSLog(@"MBSOA Error(%@):%@, para=%@",name,rst,dict);
                        rst=[rst substringFromIndex:range.location+range.length ];
                        NSLog(@"MBSOA Error2:%@",rst);
                    }
                    
                    NSMutableDictionary * dicResult=nil;
                    id obj=[rst objectFromJSONString];
                    if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        dicResult = obj;
                        if (dicResult!=nil)
                        {
                            if (dicResult[@"isSuccess"]!=nil)
                            {
                                if ([dicResult[@"isSuccess"] boolValue]==YES)
                                    success=YES;
                                else
                                {
                                    NSLog(@"mbsoa error: %@: %@",name,rst);
                                }
                                if (dicResult[@"message"]!=nil)
                                    [returnMsg setString:dicResult[@"message"]];
                            }
                            else if (dicResult[@"errcode"]!=nil)
                            {
                                NSMutableString *result=[[NSMutableString alloc] initWithCapacity:32];
                                if ([SHOPPING_GUIDE_ITF requestMBSoaToken:result])
                                {
                                    continue;
                                }
                            }
                        }
                    }
                    
                    if (obj!=nil)
                    {
                        success=YES;
                        [responseObject addEntriesFromDictionary:[[NSMutableDictionary alloc] initWithObjectsAndKeys:obj,@"result", nil]];
                        break;
                    }
                }
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
        }
        return success;
 
    }
    else
    {
        __block BOOL  isFinish;
        NSCondition *cond = [[NSCondition alloc] init];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:param];
        [dict setObject:[self getMapping:name] forKey:@"m"];
        if ([[method uppercaseString] isEqualToString:@"GET"])
        {
            [dict setObject:name forKey:@"a"];
        }
        else
        {
            [dict setObject:name forKey:@"MethodName"];
            [dict setObject:name forKey:@"a"];
        }
        param = dict;
        
        [[SDataCache sharedInstance ] quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
            
            NSLog(@"JSON:sssssss,,********all**ss %@", object);
            NSString *rst = [NSString stringWithFormat:@"%@",object];
            if ([rst length]>0)
            {
                NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
                if (range.location!=NSNotFound)
                {
                    NSLog(@"MBSOA Error(%@):%@, para=%@",name,rst,dict);
                    rst=[rst substringFromIndex:range.location+range.length ];
                    NSLog(@"MBSOA Error2:%@",rst);
                }
                
                NSMutableDictionary * dicResult=nil;
                id obj=[rst objectFromJSONString];
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    dicResult = obj;
                    if (dicResult!=nil)
                    {
                        if (dicResult[@"isSuccess"]!=nil)
                        {
                            if ([dicResult[@"isSuccess"] boolValue]==YES)
                            {
                                success = YES;
                            }
                            else
                            {
                                NSLog(@"mbsoa error: %@: %@",name,rst);
                                success=NO;
                            }
                            if (dicResult[@"message"]!=nil)
                            {
                                //                            [returnMsg setString:dicResult[@"message"]];
                                [returnMsgStr setString: dicResult[@"message"]];
                                
                            }
                        }
                        
                    }
                    
                }
                else if ([obj isKindOfClass:[NSDictionary class]])
                {
                    success=YES;
                    dicResult=[[NSMutableDictionary alloc] initWithObjectsAndKeys:obj,@"result", nil];
                }
                [cond lock];
                [responseObjectBlack addEntriesFromDictionary:dicResult];
                isFinish = YES;
                [cond signal];
                
                [cond unlock];
//                [responseObjectBlack addEntriesFromDictionary:dicResult];
            }
            
            if ([object[@"status"]intValue] <= 0) {
                success = NO;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"JSON:a*********aaaa %@", error);
            success = NO;
            [cond lock];
            isFinish=YES;
            [cond signal];
            [cond unlock];
        }];
        
        [cond lock];
        while (!isFinish)
        {
            [cond wait];
        }
        [cond unlock];
        
        NSArray *keys=[responseObjectBlack allKeys];
        for(id key in keys)
        {
            id value=[responseObjectBlack objectForKey:key];
            id copyValue;
            copyValue=[value copy];
            [responseObject setObject:copyValue forKey:key];
        }
        NSLog(@"returnall----%@",responseObject);
        //    returnAll = [returnAllBlock mutableCopy];
        returnMsg= returnMsgStr;
        if ([[responseObject allKeys]count]>0) {
            success=YES;
        }
//
//        responseObject = responseObjectBlack;
//        returnMsg = returnMsgStr;
        return success;
 
    }
    
   
}

-(BOOL)requestMBSoaServer:(NSString*)name param:(NSDictionary *)param method:(NSString*)method responseAll:(NSMutableDictionary *)returnAll returnMsg:(NSMutableString *)returnMsg
{
    __block BOOL success=YES;
    __block NSMutableDictionary *returnAllBlock=[[NSMutableDictionary alloc]init];
    __block NSMutableString *returnMsgStr = [[NSMutableString alloc]init];
    __block BOOL  isFinish=NO;
    
    BOOL isOld=NO;//[oldArray containsObject:name]
    
    if (isOld) {
        BOOL success=NO;
        @try
        {
            for (int i=0;i<3;i++)
            {
                //创建参数
                NSString *token=[[NSString alloc] initWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"] ];
                
                NSString *urlstr = [NSString stringWithFormat:@"%@/CallCenter/InvokeSecurity.ashx",MBSoaServer];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:token forKey:@"AccessToken"];
                [dict setObject:[self getMapping:name] forKey:@"ServiceName"];
                if ([[method uppercaseString] isEqualToString:@"GET"])
                {
                    [dict setObject:[[NSString alloc] initWithFormat:@"GET:%@",name] forKey:@"MethodName"];
                }
                else
                {
                    [dict setObject:name forKey:@"MethodName"];
                }
                if (param != nil) {
                    [dict setObject:[self dictionaryConvertedToStringWithdic:param] forKey:@"Message"];
                }
                
                //请求url
                NSString *rst=[self ASIPostJSonRequestSecureUrl:urlstr PostParam:dict];
                if ([rst length]>0)
                {
                    NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
                    if (range.location!=NSNotFound)
                    {
                        NSLog(@"MBSOA Error(%@):%@, para=%@",name,rst,dict);
                        rst=[rst substringFromIndex:range.location+range.length ];
                        NSLog(@"MBSOA Error2:%@",rst);
                    }
                    
                    NSMutableDictionary * dicResult=nil;
                    id obj=[rst objectFromJSONString];
                    if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        dicResult = obj;
                        if (dicResult!=nil)
                        {
                            if (dicResult[@"isSuccess"]!=nil)
                            {
                                if ([dicResult[@"isSuccess"] boolValue]==YES)
                                    success=YES;
                                else
                                {
                                    NSLog(@"mbsoa error: %@: %@",name,rst);
                                }
                                if (dicResult[@"message"]!=nil)
                                    [returnMsg setString:dicResult[@"message"]];
                            }
                            else if (dicResult[@"errcode"]!=nil)
                            {
                                NSMutableString *result=[[NSMutableString alloc] initWithCapacity:32];
                                if ([SHOPPING_GUIDE_ITF requestMBSoaToken:result])
                                {
                                    continue;
                                }
                            }
                        }
                    }
                    else if ([obj isKindOfClass:[NSDictionary class]])
                    {
                        success=YES;
                        dicResult=[[NSMutableDictionary alloc] initWithObjectsAndKeys:obj,@"result", nil];
                    }
                    else continue;
                    
                    [returnAll addEntriesFromDictionary:dicResult];
                    break;
                }
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
        }
        return success;
  
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:param];
        [dict setObject:[self getMapping:name] forKey:@"m"];

        NSString *wxsc_Str=[self getMapping:name];
        NSArray *wscArray=[wxsc_Str componentsSeparatedByString:@"_"];
        
        
        NSString *NOWxscStr=[NSString stringWithFormat:@"%@",[wscArray lastObject]];
        
        if ([name isEqualToString:@"ProductFilter"]) {
            
            [dict setObject:NOWxscStr forKey:@"m"];
        }
        if ([NOWxscStr isEqualToString:@"Product"]) {
            [dict setObject:NOWxscStr forKey:@"m"];
        }
        if ([NOWxscStr isEqualToString:@"Order"]) {
            [dict setObject:NOWxscStr forKey:@"m"];
        }
        if ([[method uppercaseString] isEqualToString:@"GET"])
        {
            [dict setObject:name forKey:@"a"];
         
        }
        else
        {
            
            [dict setObject:name forKey:@"a"];
        }
 
        

//        [dict setObject:name forKey:@"MethodName"];
        param = dict;
        NSLog(@"dict －－传入的字典－－－－－%@",dict);
        
        NSCondition *cond = [[NSCondition alloc] init];
        
        if ([method isEqualToString:@"POST"]) {
            
            [[SDataCache sharedInstance] quickPost:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
                
                NSLog(@"JSON:sssssss,,**********ss %@", object);
                NSString *rst = [NSString stringWithFormat:@"%@",object];
                if ([rst length]>0)
                {
                    NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
                    if (range.location!=NSNotFound)
                    {
                        NSLog(@"MBSOA Error(%@):%@, para=%@",name,rst,dict);
                        rst=[rst substringFromIndex:range.location+range.length ];
                        NSLog(@"MBSOA Error2:%@",rst);
                    }
                    
                    NSMutableDictionary * dicResult=nil;
                    //            id obj=[rst objectFromJSONString];
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        dicResult = object;
                        if (dicResult!=nil)
                        {
                            if (dicResult[@"isSuccess"]!=nil)
                            {
                                if ([dicResult[@"isSuccess"] boolValue]==YES)
                                {
                                    success = YES;
                                }
                                else
                                {
                                    NSLog(@"mbsoa error: %@: %@",name,rst);
                                    success=NO;
                                }
                                if (dicResult[@"message"]!=nil)
                                {
                                    [returnMsgStr setString:dicResult[@"message"]];
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    else if ([object isKindOfClass:[NSDictionary class]])
                    {
                        success=YES;
                        dicResult=[[NSMutableDictionary alloc] initWithObjectsAndKeys:object,@"results", nil];
                    }
                    
                    [cond lock];
                    [returnAllBlock addEntriesFromDictionary:dicResult];
                    isFinish = YES;
                    [cond signal];
                    
                    [cond unlock];
                    
                }
                
                if ([object[@"status"]intValue] <= 0) {
                    success = NO;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"JSON:a*****shibai****aaaa %@", error);
                success = NO;
                [cond lock];
                isFinish=YES;
                [cond signal];
                [cond unlock];
            }];

        }
        else
        {
            [[SDataCache sharedInstance ] quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
                
                NSLog(@"JSON:sssssss,,**********ss %@", object);
                NSString *rst = [NSString stringWithFormat:@"%@",object];
                if ([rst length]>0)
                {
                    NSRange range=[rst rangeOfString:@"MBSOA-CallCenter-Error:"];
                    if (range.location!=NSNotFound)
                    {
                        NSLog(@"MBSOA Error(%@):%@, para=%@",name,rst,dict);
                        rst=[rst substringFromIndex:range.location+range.length ];
                        NSLog(@"MBSOA Error2:%@",rst);
                    }
                    
                    NSMutableDictionary * dicResult=nil;
                    //            id obj=[rst objectFromJSONString];
                    if ([object isKindOfClass:[NSDictionary class]])
                    {
                        dicResult = object;
                        if (dicResult!=nil)
                        {
                            if (dicResult[@"isSuccess"]!=nil)
                            {
                                if ([dicResult[@"isSuccess"] boolValue]==YES)
                                {
                                    success = YES;
                                }
                                else
                                {
                                    NSLog(@"mbsoa error: %@: %@",name,rst);
                                    success=NO;
                                }
                                if (dicResult[@"message"]!=nil)
                                {
                                    [returnMsgStr setString:dicResult[@"message"]];
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    else if ([object isKindOfClass:[NSDictionary class]])
                    {
                        success=YES;
                        dicResult=[[NSMutableDictionary alloc] initWithObjectsAndKeys:object,@"results", nil];
                    }
                    
                    [cond lock];
                    [returnAllBlock addEntriesFromDictionary:dicResult];
                    isFinish = YES;
                    [cond signal];
                    
                    [cond unlock];
                    
                }
                
                if ([object[@"status"]intValue] <= 0) {
                    success = NO;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"JSON:a*****shibai****aaaa %@", error);
                success = NO;
                [cond lock];
                isFinish=YES;
                [cond signal];
                [cond unlock];
            }];
        }

        [cond lock];
        while (!isFinish)
        {
            [cond wait];
        }
        [cond unlock];
        
        NSArray *keys=[returnAllBlock allKeys];
        for(id key in keys)
        {
            id value=[returnAllBlock objectForKey:key];
            id copyValue;
            copyValue=[value copy];
            [returnAll setObject:copyValue forKey:key];
        }
      
        [returnMsg setString:returnMsgStr];
        
        if ([[returnAll allKeys]count]>0) {
            NSString *isSuccess = [NSString stringWithFormat:@"%@",returnAll[@"isSuccess"]];
            
            if ([isSuccess isEqualToString:@"1"]) {
             success=YES;
            }
            else
            {
               success=NO;
            }
            
        }

        return success;
   
    }
}

/*
 - (void)configRequestHeader
 {
 NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
 [self.requestSerializer setValue:idfv forHTTPHeaderField:@"MBSOA-IdentificationCode"];
 
 if (sns.ldap_uid) {
 [self.requestSerializer setValue:sns.ldap_uid forHTTPHeaderField:@"MBSOA-UserId"];
 }
 NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
 [self.requestSerializer setValue:version forHTTPHeaderField:@"MBSOA-Version"];
 }
 */
//ssl忽略证书post
- (NSString *)ASIPostJSonRequestSecureUrl:(NSString *)urlString PostParam:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:idfv value:@"MBSOA-IdentificationCode"];
    [request addRequestHeader:@"1.2.2015" value:@"MBSOA-Version"];
    if ([sns.ldap_uid length] > 0) {
        [request addRequestHeader:sns.ldap_uid value:@"MBSOA-UserId"];
    }
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    // We have to turn off validation for these tests, as the server has a self-signed certificate
	[request setValidatesSecureCertificate:NO];
    
//	// Now, let's grab the certificate (included in the resources of the test app)
//	SecIdentityRef identity = NULL;
//	SecTrustRef trust = NULL;
//	NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
//	[ClientCertificateTests extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data];
//    
//	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://clientcertificate.allseeing-i.com:8080/ASIHTTPRequest/tests/first"]];
//    
//	// In this case, we have no need to add extra certificates, just the one inside the indentity will be used
//	[request setClientCertificateIdentity:identity];
//	[request setValidatesSecureCertificate:NO];
    /////////////////////////////////////////////
    [request startSynchronous];
 
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

//+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
//{
//	OSStatus securityError = errSecSuccess;
//    
//	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(id)kSecImportExportPassphrase];
//    
//	CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
//	securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
//    
//	if (securityError == 0) {
//		CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
//		const void *tempIdentity = NULL;
//		tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
//		*outIdentity = (SecIdentityRef)tempIdentity;
//		const void *tempTrust = NULL;
//		tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
//		*outTrust = (SecTrustRef)tempTrust;
//	} else {
//		NSLog(@"Failed with error code %d",(int)securityError);
//		return NO;
//	}
//	return YES;
//}

/////////////////////////////////////////////
//不用 参数再头部
- (NSString *)ASIPostJSonRequestUrl:(NSString *)urlString headPostParam:(NSDictionary *)dict
{
    NSString * encodingUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodingUrlString];
    
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    request.requestMethod=@"Post";
    request.timeOutSeconds=30;
    
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

- (NSString *)tokenPostJSonRequestUrl:(NSString *)urlString PostParam:(NSDictionary *)dict
{
    NSError *error;
    
    NSString *paramStr = @"";
    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        NSMutableString *requestparam=[[NSMutableString alloc] initWithFormat:@""];
        [requestparam appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        
        paramStr = [NSString stringWithFormat:@"%@&%@",paramStr,requestparam];
    }
    paramStr = [paramStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; encoding=utf-8"];
//    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    [request startSynchronous];
    
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

//参数再body
- (NSString *)ASIPostJSonRequestUrl:(NSString *)urlString PostParam:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey];
    if ([version length] > 0) {
        [request addRequestHeader:@"MBSOA-Version" value:version];
    }
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
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

- (NSString *)ASIGetJSonRequestUrl:(NSString *)urlString GetParam:(NSDictionary *)dict Method:(NSString *)methodStr
{

    NSEnumerator * enumeratorKey = [dict keyEnumerator];//把keyEnumerator替换为objectEnumerator即可得到value值（1）
    for (NSString *key in enumeratorKey) {
        NSObject *value = [dict objectForKey:key];
        NSMutableString *requestparam=[[NSMutableString alloc] initWithFormat:@""];
        [requestparam appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        if ([urlString rangeOfString:@"?"].location==NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"%@?%@",urlString,requestparam];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"%@&%@",urlString,requestparam];
        }
    }
    
    NSString * encodingUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodingUrlString];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    request.requestMethod=methodStr;
    request.timeOutSeconds=30;
    
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    [request setResponseEncoding:NSUTF8StringEncoding];
    
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

///////////////////////////////////////
//1
-(BOOL)requestUrl:(NSString *)url param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg
{
    BOOL retcode=NO;
    @try
    {
        NSMutableDictionary *paramDict=[[NSMutableDictionary alloc] init];
        NSString *methodName=[MBShoppingGuideInterface getHttpMethodName:url paramDict:paramDict];
        [paramDict addEntriesFromDictionary:param];
        retcode=[self requestGetUrlName:methodName param:paramDict responseList:returnList responseMsg:returnMsg];

//        NSString *rst=[self ASIGetJSonRequestUrl:url GetParam:param Method:@"GET"];
//        if ([rst length]>0)
//        {
//            NSDictionary * dicResult = [rst objectFromJSONString];
//            retcode=[dicResult[@"isSuccess"] boolValue];
//            if ( retcode )
//            {
//                [returnList addObjectsFromArray:[dicResult objectForKey:@"results"]];
//            }
//            
//            if (dicResult[@"message"]!=nil)
//                [returnMsg setString:dicResult[@"message"]];
//        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;
}

-(NSString *)getMBShoppingUrl:(NSString *)name
{
    return name;
}
-(BOOL)reachRequestStatus
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

-(BOOL)newrequestGetUrlName:(NSString *)name param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg;
{
    //    return [self requestUrl:[self getMBShoppingUrl:name] param:param responseList:returnList responseMsg:returnMsg];
    BOOL requestStatus=[self reachRequestStatus];
    if (requestStatus==NO)
    {
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [Utils alertMessage:@"网络连接失败,请检查网络设置"];
            [Toast makeToast:@"网络连接失败,请检查网络设置" duration:1.0f position:@"center"];
        });
        
        return NO;
    }
    
    BOOL retcode=NO;
    @try
    {
        NSMutableDictionary *returnAll=[[NSMutableDictionary alloc] initWithCapacity:5];
        //        NSMutableString *returnMsg=[[NSMutableString alloc] init];
        retcode=[SHOPPING_GUIDE_ITF requestMBSoaServer:name param:param method:@"GET" responseAll:returnAll returnMsg:returnMsg];
        NSLog(@"returnall RETURCODEorder----%@--------%d",returnAll,retcode);
        
        if (retcode)
        {
            [returnList addObjectsFromArray:[returnAll objectForKey:@"results"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;
  
}
//4
-(BOOL)requestGetUrlName:(NSString *)name param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg
{
//    return [self requestUrl:[self getMBShoppingUrl:name] param:param responseList:returnList responseMsg:returnMsg];
    BOOL requestStatus=[self reachRequestStatus];
    if (requestStatus==NO)
    {
//
        dispatch_async(dispatch_get_main_queue(), ^{
//            [Utils alertMessage:@"网络连接失败,请检查网络设置"];
            [Toast makeToast:@"网络连接失败,请检查网络设置" duration:1.0f position:@"center"];
        });
       
        return NO;
    }
    
    BOOL retcode=NO;
    @try
    {
        NSMutableDictionary *returnAll=[[NSMutableDictionary alloc] initWithCapacity:5];
        //        NSMutableString *returnMsg=[[NSMutableString alloc] init];
        retcode=[SHOPPING_GUIDE_ITF requestMBSoaServer:name param:param method:@"GET" responseAll:returnAll returnMsg:returnMsg];
        NSLog(@"returnall RETURCODE-----%@--------%d",returnAll,retcode);
        
        if (retcode)
        {
            [returnList addObjectsFromArray:[returnAll objectForKey:@"results"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;
}

//返回查询获取的所有json数据。
-(BOOL)requestGetUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnAll responseMsg:(NSMutableString *)returnMsg
{
//    NSString *url=[self getMBShoppingUrl:name];
    BOOL requestStatus=[self reachRequestStatus];
    if (requestStatus==NO)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [Utils alertMessage:@"网络连接失败,请检查网络设置"];
            [Toast makeToast:@"网络连接失败,请检查网络设置" duration:1.0f position:@"center"];
        });
//
        return NO;
    }
    BOOL retcode=NO;
    @try
    {

//        NSMutableDictionary *returnAll=[[NSMutableDictionary alloc] initWithCapacity:5];
//        NSMutableString *returnMsg=[[NSMutableString alloc] init];
        retcode=[SHOPPING_GUIDE_ITF requestMBSoaServer:name param:param method:@"GET" responseAll:returnAll returnMsg:returnMsg];
        NSLog(@"returnass／／／／／／／／－－－－%@",returnAll);
        
//        NSString *rst=[self ASIGetJSonRequestUrl:url GetParam:param Method:@"GET"];
//        if ([rst length]>0)
//        {
//            NSDictionary * dicResult = [rst objectFromJSONString];
//            retcode=[dicResult[@"isSuccess"] boolValue];
//            if ( retcode )
//            {
//                [returnAll addEntriesFromDictionary:dicResult];
//            }
//            
//            if (dicResult[@"message"]!=nil)
//                [returnMsg setString:dicResult[@"message"]];
//        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;

}

//5
-(BOOL)requestPostUrl:(NSString *)url param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnDict responseMsg:(NSMutableString *)returnMsg
{
    BOOL requestStatus=[self reachRequestStatus];
    if (requestStatus==NO)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [Utils alertMessage:@"网络连接失败,请检查网络设置"];
            [Toast makeToast:@"网络连接失败,请检查网络设置" duration:1.0f position:@"center"];
        });
//
        return NO;
    }
    BOOL retcode=NO;
    @try
    {
        NSMutableDictionary *paramDict=[[NSMutableDictionary alloc] init];
        NSString *method=[MBShoppingGuideInterface getHttpMethodName:url paramDict:paramDict];
        [paramDict addEntriesFromDictionary:param];
        retcode=[self requestPostUrlName:method param:paramDict responseAll:returnDict responseMsg:returnMsg];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;
}

-(BOOL)requestPostUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnDict responseMsg:(NSMutableString *)returnMsg
{
//    return [self requestPostUrl:[self getMBShoppingUrl:name] param:param responseList:returnList responseMsg:returnMsg];
    BOOL requestStatus=[self reachRequestStatus];
    if (requestStatus==NO)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Toast makeToast:@"网络连接失败,请检查网络设置" duration:1.0f position:@"center"];
        });
//
        return NO;
    }
    BOOL retcode=NO;
    @try
    {
        NSMutableDictionary *returnAll=[[NSMutableDictionary alloc] initWithCapacity:5];
        //        NSMutableString *returnMsg=[[NSMutableString alloc] init];
/*        if ([name isEqualToString:@"ReceiverCreate"]) {
            param = @{@"address" : @"luohe",
                      @"city" : @"北京",
                      @"country" : @"中国",
                      @"county" : @"东城区",
                      @"creatE_USER" : @"wave",
                      @"isdefault" : @"1",
                      @"mobileno" : @"15270917917",
                      @"name" : @"wave",
                      @"phoneno" : @"15270917917",
                      @"posT_CODE" : @"462000",
                      @"province" : @"北京市",
                      @"userId" : @"8d2a9f55-1f98-4fa7-913c-e203f0855076",};
        }*/
        retcode=[SHOPPING_GUIDE_ITF requestMBSoaServer:name param:param method:@"POST" responseAll:returnAll returnMsg:returnMsg];
//        -(BOOL)requestPostUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnDict responseMsg:(NSMutableString *)returnMsg
  
        
        if (retcode)
        {
            [returnDict addEntriesFromDictionary:returnAll];
        }
        if ([[returnAll allKeys]containsObject:@"message"]) {
             [returnDict addEntriesFromDictionary:returnAll];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s Exception Name: %@, Reason: %@\r\n", __FUNCTION__, [ exception name ], [ exception reason ]);
    }
    
    return retcode;
}

+(NSString *)getJsonDateInterval:(NSString *)jsondateStr
{
    NSArray *arr1=[jsondateStr componentsSeparatedByString:@"("];
    if (arr1.count<2) return @"";
    NSArray *arr2=[[arr1 lastObject] componentsSeparatedByString:@"-"];
    if (arr2.count<2)
        arr2=[[arr1 lastObject] componentsSeparatedByString:@"+"];
    if (arr2.count<2) return @"";
    return [arr2 firstObject];
}

+(NSString *)getHttpMethodName:(NSString*)url paramDict:(NSMutableDictionary*)paramDict
{
    NSArray *s_url =[url componentsSeparatedByString:@"/"];
    BOOL isURL=NO;
    NSString *methodName=nil;
    if (s_url.count>1) //是否URL
    {
        NSString *https=[s_url[0] lowercaseString];
        if ([https isEqualToString:@"http:"] || [https isEqualToString:@"https:"])
        {
            isURL=YES;
            NSString *m1=[s_url lastObject];
            NSArray *s_method =[m1 componentsSeparatedByString:@"?"];
            if (s_method.count>1)
            {
                methodName=[[NSString alloc] initWithFormat:@"%@",s_method[0]];
                
                //create param
                NSArray *s_param =[s_method[1] componentsSeparatedByString:@"&"];
                for (int i=0;i<s_param.count;i++)
                {
                    NSArray *paramArr =[s_param[i] componentsSeparatedByString:@"="];
                    if ([[paramArr[1] lowercaseString] isEqualToString:@"format"])
                        continue;
                    [paramDict setObject:paramArr[1] forKey:paramArr[0]];
                }
            }
            else
            {
                methodName=[[NSString alloc] initWithFormat:@"%@",m1];
            }
        }
    }
    return methodName;
}


//一、商品分享 http://10.100.20.28:8016/BSParamFilter?code=SHARE_PROD_URL
//
//A、获取分享地址 如http://weixin.bonwe.com/stylist.web/Product/Detail.aspx?D_ID={0}&COLL_ID={1}&PROD_CLS_ID={2}
//B、参数说明 ：
//D_ID 造型师ID
//COLL_ID 搭配ID
//PROD_CLS_ID 为商品款的ID
//
//二、搭配分享 http://10.100.20.28:8016/BSParamFilter?Code=COLLOCATION_URL
//
//A、获取分享地址 如http://weixin.bonwe.com/stylist.web/Collocation/Detail.aspx?cid={0}
//B、参数说明 cid 为搭配ID
-(NSString *)createShareCollocationUrl:(NSString *)userid CollocationID:(NSString *)coll_id
{
    NSString *str1=[SHARE_COLLOCATION_URL stringByReplacingOccurrencesOfString:@"{0}" withString:coll_id];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"{1}" withString:userid];
    return str2;
}

-(NSString *)createShareGoodsUrl:(NSString *)userid CollocationID:(NSString *)collocationid ProductClsID:(NSString *)productid designerId:(NSString *)designerid
{
    NSString *str1=[SHARE_PROD_URL stringByReplacingOccurrencesOfString:@"{0}" withString:designerid];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"{1}" withString:collocationid];
    NSString *str3=[str2 stringByReplacingOccurrencesOfString:@"{2}" withString:productid];
    NSString *str4=[str3 stringByReplacingOccurrencesOfString:@"{3}" withString:userid];
    return str4;
}
-(void)cancleRequest
{
    SHOPPING_GUIDE_ITF = nil;
    [MBShoppingGuideInterface create];
}
@end
