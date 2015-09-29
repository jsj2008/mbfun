//
//  WeiXinUtils.h
//  Wefafa
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "CommonEventHandler.h"
#define kWXAPP_ID @"wx8c99f5d8af954939"
#define kWXAPP_SECRET @"fe00fa458d0793bd25ca528f5b3729d7"

@interface WeiXinUtils : NSObject
{
    NSString *WXAccess_Token;
    NSString *WXRefresh_Token;
    
    CommonEventHandler *onWXGetUserInfoEvent;
}

@property (retain,nonatomic) NSString *WXOpenID;
@property (retain,nonatomic) NSString *WXLogin_Code;

-(void)sendAuthRequest:(CommonEventHandler *)getUserInfoComplete; //wx认证
-(void)getWXAuthAccessToken;//AppDelegate 调用

@end

extern WeiXinUtils *wxUtils;
