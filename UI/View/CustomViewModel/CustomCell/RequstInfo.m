//
//  RequstInfo.m
//  One
//
//  Created by fafatime on 14-3-24.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "RequstInfo.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
@implementation RequstInfo
@synthesize scrollViewImgViewURL;
@synthesize tabbarImgViewURL;
@synthesize dataString;
@synthesize tabbarDataString;
@synthesize detailModelDataString;
static RequstInfo *request = nil;
+(id)getSignalInstance
{
    NSLock *lock = [[NSLock alloc]init];
    [lock lock];
    if (request ==nil)
    {
        request = [[RequstInfo alloc]init];
        request.scrollViewImgViewURL = ScrollViewImgViewURL;
        request.tabbarImgViewURL = TabbarImgViewURL;
        
    }
    [lock unlock];
//    [lock release];
    
    return request;
}
+(BOOL) isNetWork
{
    BOOL isExistenceNetWork = NO;
    Reachability *reache=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reache currentReachabilityStatus])
    {
        case NotReachable:
            isExistenceNetWork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetWork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetWork = YES;
            break;
        default:
            break;
    }
    return isExistenceNetWork;
}
-(void)requestScrollViewImgView
{
    scrollViewImgViewRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:request.scrollViewImgViewURL]];
    scrollViewImgViewRequest.delegate=self;
    [scrollViewImgViewRequest startAsynchronous];
    
}
-(void)requesttabbarImgView
{
    tabbarImgViewRequest =[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:request.tabbarImgViewURL]];
    tabbarImgViewRequest.delegate=self;
    [tabbarImgViewRequest startAsynchronous];
    
}
-(void)requestDetailModel
{
//    ASIHTTPRequest *

//    [detailModel release];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    //缓存文件夹 //缓存图片,内容.
//    NSString *docS= [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
//    NSString *path1 = [docS stringByAppendingPathComponent:@"scrollViewImgView"];
//    NSString *path2 = [docS stringByAppendingPathComponent:@"tabbarViewImgView"];
//    
//    //判断文件夹是否存在 不存在就创建
//    BOOL isDic= NO;
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:path1 isDirectory:&isDic];
//    BOOL existed1 = [fileManager fileExistsAtPath:path2 isDirectory:&isDic];
//    //scrollingview图片缓存
//    if(!(isDic && existed))
//    {
//        [fileManager createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    //tabbar图片 缓存文件
//    if (!(isDic && existed1))
//    {
//        [fileManager createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    if ([request isEqual:scrollViewImgViewRequest])
    {
        NSString *tempString=[request responseString];
        
//        id temp = [tempString  JSONValue];
        self.dataString = tempString;
        [self requesttabbarImgView];
    }
    if ([request isEqual:tabbarImgViewRequest])
    {
        NSString *tempString = [request responseString];
        self.tabbarDataString = tempString;
//        NSLog(@"-tabbar-%@",self.tabbarDataString);
//        [self requestDetailModel];
        
    }
    if ([request isEqual:detailModel])
    {
        NSString *tempString = [request responseString];
        self.detailModelDataString = tempString;
//        NSLog(@"self====%@",self.detailModelDataString);
    }
    
}
@end
