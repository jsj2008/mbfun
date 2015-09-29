//
//  NSString+help.h
//  Crius
//
//  Created by Miaozlc on 13-10-28.
//  Copyright (c) 2013年 Miaozlc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64.h"
@interface NSString (help)
// 將字典或者數組轉化爲JSON串

+(NSString *)arrayAnddictoJSONDataStr:(id)theData;
+(NSString *)stringByJson:(NSDictionary *)datadic;
+ (id )dictionaryWithJsonString:(NSString *)jsonString ;
//十六进制转换为字符串
+ (NSString *)stringFromHexString:(NSString *)hexString;
@end
