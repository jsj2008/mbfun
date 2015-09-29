//
//  OutInUserDefaults.m
//  BanggoPhone
//
//  Created by Juvid on 14-7-7.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import "OutInUserDefaults.h"

@implementation OutInUserDefaults
/********************************************************************************/

//流量设置
+(void)SetSaveByte:(BOOL)save{
    [UserDefault setBool:save forKey:@"saveByte"];
}
+(BOOL)GetSaveByte{
   return [UserDefault boolForKey:@"saveByte"];
}

+(NSString *)LoactionVersion{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return nowVersion;
}
@end
