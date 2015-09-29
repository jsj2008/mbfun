//
//  WeiXinUtils.m
//  Wefafa
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "WeiXinUtils.h"
#import "JSONKit.h"

WeiXinUtils *wxUtils=nil;

@implementation WeiXinUtils

///////////////////
//登录微信，第一步：获取code。 chengyb
-(void)sendAuthRequest:(CommonEventHandler *)getUserInfoComplete
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1230919827395123";
    onWXGetUserInfoEvent=getUserInfoComplete;
    [WXApi sendReq:req];
}

//登录微信，第二步：获取token。 chengyb
-(void)getWXAuthAccessToken
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,_WXLogin_Code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                WXAccess_Token = [dic objectForKey:@"access_token"];
                WXRefresh_Token = [dic objectForKey:@"refresh_token"];
                _WXOpenID = [dic objectForKey:@"openid"];
                if (WXAccess_Token.length>0 && onWXGetUserInfoEvent)
                {
                    [self getWXUserInfo]; // 调用第三部
                }
                //一小时刷新一次
                [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(refreshWXAuthAccessToken) userInfo:nil repeats:NO];
            }
            else
            {
                if (onWXGetUserInfoEvent)
                    [onWXGetUserInfoEvent fire:self eventData:@"微信登录失败！"];
            }
        });
    });
}

//登录微信，刷新token。 chengyb
-(void)refreshWXAuthAccessToken
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&refresh_token=%@&grant_type=refresh_token",kWXAPP_ID,WXRefresh_Token];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                WXAccess_Token = [dic objectForKey:@"access_token"];
                WXRefresh_Token = [dic objectForKey:@"refresh_token"];
//                _WXOpenID = [dic objectForKey:@"openid"];
                
            }
            //一小时刷新一次
            [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(refreshWXAuthAccessToken) userInfo:nil repeats:NO];
        });
    });
}

//登录微信，第三步：获取userinfo. chengyb
-(void)getWXUserInfo
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",WXAccess_Token,_WXOpenID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 openid	普通用户的标识，对当前开发者帐号唯一
                 nickname	普通用户昵称
                 sex	普通用户性别，1为男性，2为女性
                 province	普通用户个人资料填写的省份
                 city	普通用户个人资料填写的城市
                 country	国家，如中国为CN
                 headimgurl	用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空
                 privilege	用户特权信息，json数组，如微信沃卡用户为（chinaunicom）
                 unionid	用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                
//                WXUserName = [dic objectForKey:@"nickname"];
//                WXHeadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"微信帐号" message:WXUserName delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(20,20,60,60)];
//                imageview.image=WXHeadImage;
//                [alert addSubview:imageview];
//                [alert show];
                
                
                //callback login userinfo
                [onWXGetUserInfoEvent fire:self eventData:dic];
            }
            else
            {
                [onWXGetUserInfoEvent fire:self eventData:@"微信登录失败！！"];
            }
        });
        
    });
}

@end
