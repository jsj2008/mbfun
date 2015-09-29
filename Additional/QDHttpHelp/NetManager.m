

//
//  NetManager.m

#import "NetManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation NSMutableDictionary (Post)

-(void)setNoNullObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey withDefault:(id)defaultValue
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }else if(defaultValue)
    {
        [self setObject:defaultValue forKey:aKey];
    }else
    {
        [self setObject:@"" forKey:aKey];
    }
}

@end
static NetManager *_manager;

@implementation NetManager

#pragma mark - 获取单例
+ (NetManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetManager alloc] init];
    });
    
    return _manager;
}
#pragma mark - 字符串UTF-8编码
+ (NSString*) getEncodingWithUTF8 : (NSString*) str
{
    NSString *tempStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return tempStr;
}
#pragma mark - get络请求入口
- (void)sendRequestWithUrlString :(NSString*)urlString
                           success:(void (^)(id responseDic))success
                           failure:(void(^)(id errorString))failure
{

    
    urlString = [[self class] getEncodingWithUTF8:urlString];
     ASIHTTPRequest *brequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [brequest setUseCookiePersistence:NO];
    [brequest setTimeOutSeconds:5];
    [brequest startAsynchronous];
    __weak typeof(brequest) request = brequest;
    [brequest setCompletionBlock:^{
    

        
        NSLog(@"completion : %@" , request.responseString);
        NSError *error;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
        if (responseDic == nil) {
            success([error localizedDescription]);
            return;
        }
        [request clearDelegatesAndCancel];

        if (responseDic == nil) {
            NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"网络连接出错",NSLocalizedDescriptionKey, nil];
            NSError *customError=[NSError errorWithDomain:@"DuiDuiLa" code:500 userInfo:userInfo];
            failure(customError);
            
        }else {
            NSLog(@"responseDic : %@" , responseDic);
            int status=[[responseDic objectForKey:@"success"] intValue];
            if (status == 1) {
                //请求成功
                
                success(responseDic);
                
            }
            else
            {
                //请求失败
                NSString *resultString=[responseDic objectForKey:@"msg"];
                
                failure(resultString);
            }
        }

    }];
    [request setFailedBlock:^{
        
        [request clearDelegatesAndCancel];
        NSString *errorMsg = @"网络连接失败";
        failure(errorMsg);
    }];
}

#pragma mark - post请求入口
- (void)postRequestWithUrlString:(NSString*)urlString
                     postParamDic:(NSDictionary*)postParamDic
                          success:(void (^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    if (_progress) {
//        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//        [[MMProgressHUD sharedHUD]setOverlayMode:MMProgressHUDWindowOverlayModeNone];
//        [MMProgressHUD showWithTitle:nil status:@"加载中..."];
    }

    urlString = [[self class] getEncodingWithUTF8:urlString];
    ASIFormDataRequest *brequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    brequest.shouldAttemptPersistentConnection = NO;
    [brequest setUseCookiePersistence:NO];
    for (NSString *keyString in [postParamDic allKeys])
    {
        [brequest setPostValue:[postParamDic objectForKey:keyString] forKey:keyString];
    }
    
    [brequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"sysVersion"];
    [brequest setPostValue:@"ios" forKey:@"sysType"];
    [brequest setPostValue:@"5" forKey:@"pidTag"];

    [brequest setTimeOutSeconds:5];
    
    NSLog(@"\nURL==%@",brequest.url);
    NSLog(@"\nPostParams : %@",postParamDic);
    [brequest startAsynchronous];
    
     __weak typeof(brequest) request = brequest;
    [brequest setCompletionBlock:^{
        
        NSLog(@"Completion : %@" , request.responseString);
        
        NSError *error;
        
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];

        [request clearDelegatesAndCancel];
        
        if (responseDic == nil)
        {
            NSString *errorMsg = @"数据解析失败";

            failure(errorMsg);
            return;
        }
        else
        {

                //请求成功  防null
                success([self processNull:responseDic]);

        }
    }];
    [request setFailedBlock:^{
        
        [request clearDelegatesAndCancel];
        
        NSString *errorMsg = @"网络连接失败";
        
        failure(errorMsg);
    }];

}

- (id)processNull:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (id key in [(NSDictionary*)obj allKeys]) {
            [dict setObject:[self processNull:[obj objectForKey:key]] forKey:key];
        }
        NSDictionary *returnDict = [NSDictionary dictionaryWithDictionary:dict];

        return returnDict;
    }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (id o in (NSArray*)obj) {
            [array addObject:[self processNull:o]];
        }
        NSArray *returnArray = [NSArray arrayWithArray:array];
        
        return returnArray;
    }else if([obj isKindOfClass:[NSNull class]]){
        return @"";
    }
    return obj;
}

@end
