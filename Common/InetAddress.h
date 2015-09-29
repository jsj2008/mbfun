//
//  InetAddress.h
//  selector
//
//  Created by mac on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InetAddress : NSObject

+ (NSString *)getLocalHost;
+ (NSString *)getByName:(NSString *)name;
+(struct sockaddr_in)ipstr2sockaddr_in:(const char*)ipstr port:(int)port;
+(NSArray*)resolveHost:(NSString*)hostorip port:(uint16_t)port;
+(NSData*)getIPv4Address:(NSString*)hostorip port:(uint16_t)port;

@end
