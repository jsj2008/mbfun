//
//  OutInUserDefaults.h
//  BanggoPhone
//
//  Created by Juvid on 14-7-7.
//  Copyright (c) 2014年 BG. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>
#define UserDefault [NSUserDefaults standardUserDefaults]//配置文件

@interface OutInUserDefaults : NSObject
 

//流量设置
+(void)SetSaveByte:(BOOL)save;
+(BOOL)GetSaveByte;
+(NSString *)LoactionVersion;
@end
