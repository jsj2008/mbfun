//
//  NetUtils.h
//  FaFa
//
//  Created by mac on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUtils : NSObject

// 是否wifi
+ (BOOL) isWifiConnected;
// 是否3G
+ (BOOL) is3GConnected;
+ (BOOL) connectedToNetwork;
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSDictionary *)getIPAddresses;

@end
