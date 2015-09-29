//
//  Hash.h
//  FaFa
//
//  Created by mac on 12-9-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hash : NSObject

#define CHUNK_SIZE 8192

+(NSString *)Sha1Hash:(NSString *)source;
+(NSString*)fileMD5:(NSString*)path;
+(NSString*)dataMD5:(NSData*)data;
+(NSString*)dataMD5:(Byte*)data Length:(int)len;
+ (NSString *)md5:(NSString *)input;
+ (NSString *)sha1:(NSString *)input;

@end
