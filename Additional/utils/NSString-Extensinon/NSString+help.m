//
//  NSString+help.m
//  Crius
//
//  Created by Miaozlc on 13-10-28.
//  Copyright (c) 2013年 Miaozlc. All rights reserved.
//

#import "NSString+help.h"

@implementation NSString (help)

+(NSString *)stringByJson:(NSDictionary *)datadic{
    NSData *loginData =[NSData data];
    if ([NSJSONSerialization isValidJSONObject:datadic]) {
        NSError *error;
        loginData = [NSJSONSerialization dataWithJSONObject:datadic
                                                    options:NSJSONWritingPrettyPrinted error:&error];
        //NSJSONReadingMutableLeaves
        //            NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:orderData
        //                                                            encoding:NSUTF8StringEncoding]);
        
    }
    
    NSString *str=[[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding] ;
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *lastStr=[strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return lastStr;

}


// 將字典或者數組轉化爲JSON串

+(NSString *)arrayAnddictoJSONDataStr:(id)theData{
    
    NSError *error = nil;
    NSString *lastStr=nil;
    NSString *strUrl=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                        
                                                       options:NSJSONWritingPrettyPrinted
                        
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *str=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ;
        strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        lastStr=[strUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        return lastStr;
       
        
    }else{
        
        return nil;
        
    }
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (id )dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//十六进制转换为字符串
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        
        myBuffer[i / 2] = (char)anInt;
    }
    
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}

@end
