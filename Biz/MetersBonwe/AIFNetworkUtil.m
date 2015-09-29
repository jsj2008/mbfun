//
//  RTNetworkUtil.h
//
//  Created by yintengxiang on 14-7-01.
//  Copyright (c) 2014年 BG. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AIFNetworkUtil.h"
#import "Reachability.h"

@implementation AIFNetworkUtil

+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection)? YES : NO;
}

+ (RTNetworkType)MBNetworkAllType
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    RTNetworkType statusCode = RTNetworkNil;
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    if (subviews) {
        for (id subview in subviews) {
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
    }
    
    if (!dataNetworkItemView) {
        return statusCode;
    }
    /**
     *  flag 是用来判断网络连接的
     *  暂时不要删除注释
     */
//    SCNetworkReachabilityFlags flag = [reachability reachabilityFlags];
    if(status != kNotReachable) {
//        if ((flag & kSCNetworkReachabilityFlagsReachable) == kSCNetworkReachabilityFlagsReachable &&
//            (flag & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) {
            
            switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
                case 0:
                    //No wifi or cellular
                    statusCode = RTNetworkNil;
                    break;
                case 1:
                    //2G
                    statusCode = RTNetwork2G;
                    break;
                case 2:
                    //3G
                    statusCode = RTNetwork3G;
                    break;
                case 3:
                    //4G
                    statusCode = RTNetwork4G;
                    break;
                case 4:
                    //LTE
                    statusCode = RTNetworkLTE;
                    break;
                case 5:
                    //Wifi
                    statusCode = RTNetworkWIFI;
                    break;
                default:
                    break;
            }
        }
//    }
    
    [reachability stopNotifier];
    return statusCode;
}
+ (RTNetworkType)MBNetworkType
{
    RTNetworkType statusCode = RTNetworkNil;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            statusCode = RTNetworkNil;
            break;
        case ReachableViaWWAN:
            // 使用3G2G网络
            statusCode = RTNetwork2G3G;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            statusCode = RTNetworkWIFI;
            break;
    }
    return statusCode;
}
@end
