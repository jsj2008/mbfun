//
//  MBShoppingGuideInterface.h
//  Wefafa
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeFaFaGet.h"

@interface MBShoppingGuideInterface : NSObject

+(MBShoppingGuideInterface *)create;

-(BOOL)requestUrl:(NSString *)url param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg;
//-(BOOL)requestSubPath:(NSString *)subPath param:(NSDictionary *)param responseList:(NSMutableDictionary *)returnDic responseMsg:(NSMutableString *)returnMsg;
//-(NSDictionary *)ASIPostJSonRequest:(NSString *)subpath; //PostParamDic:(NSDictionary *)dict;
//-(NSDictionary *)ASIPostJSonRequest:(NSString *)subpath PostParamDic:(NSDictionary *)dict;

-(BOOL)newrequestGetUrlName:(NSString *)name param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg;

-(BOOL)requestGetUrlName:(NSString *)name param:(NSDictionary *)param responseList:(NSMutableArray *)returnList responseMsg:(NSMutableString *)returnMsg;
-(BOOL)requestPostUrl:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnDict responseMsg:(NSMutableString *)returnMsg;
-(BOOL)requestPostUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnDict responseMsg:(NSMutableString *)returnMsg;

-(BOOL)requestGetUrlName:(NSString *)name param:(NSDictionary *)param responseAll:(NSMutableDictionary *)returnAll responseMsg:(NSMutableString *)returnMsg;

+(NSString *)getJsonDateInterval:(NSString *)jsondateStr;

-(BOOL)requestMBSoaToken:(NSMutableString *)returncode;
-(BOOL)requestMBSoaServer:(NSString*)name param:(NSDictionary *)param method:(NSString*)method responseAll:(NSMutableDictionary *)returnAll returnMsg:(NSMutableString *)returnMsg;
-(BOOL)requestMBSoaServer:(NSString*)name param:(NSDictionary *)param method:(NSString*)method responseObject:(NSMutableDictionary*)responseObject returnMsg:(NSMutableString *)returnMsg;
+(NSString *)getHttpMethodName:(NSString*)url paramDict:(NSMutableDictionary*)paramDict;

-(NSString *)createShareCollocationUrl:(NSString *)userid CollocationID:(NSString *)coll_id;
-(NSString *)createShareGoodsUrl:(NSString *)userid CollocationID:(NSString *)collocationid ProductClsID:(NSString *)productid designerId:(NSString *)designerid;
-(void)cancleRequest;
@end

extern NSString *SHARE_COLLOCATION_URL;
extern NSString *SHARE_PROD_URL;
extern double DEFAULT_FEE;
extern MBShoppingGuideInterface * SHOPPING_GUIDE_ITF ;

// Mark - 虽然是同步调用，但是部分地方也可以简化逻辑
// __deprecated_msg("Use `HttpRequest`");
//extern NSMutableArray *attenDesignerList;
