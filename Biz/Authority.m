//
//  Authority.m
//  Wefafa
//
//  Created by mac on 13-10-15.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import "Authority.h"
#import "SQLiteOper.h"

@implementation Authority

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+(NSArray *)getAuthorityArray
{
    NSArray *authorityArray=
    @[@"PUBLISH_WE",@"TREND_VIEW_WE",@"TREND_WE",@"RE_TREND_ATTEN",
      @"RE_TREND_VIEW",@"CROUP_C_RE",@"RE_TREND_PUBLISH",@"RE_TREND_INVITE",
      @"GROUP_C_EN",@"PUBLISH_EN",@"EN_CIRCLE_VIEW",@"EN_TREND",
      @"MANAGER_EN",@"MEETING_C",@"CIRCLE_C",@"CIRCLE_JOIN_C",
      @"GROUP_C",@"CIRCLE_PUBLISH_TREND",@"CIRCLE_S",@"CIRCLE_VIEW_TREND",
      @"CIRCLE_REPLY_TREND",@"OFFICIAL_RELEASE",@"OFFICIAL_RELEASE_VIEW",@"APPCENTER",
      @"DOC_10000",@"DOC_9999",@"DOC_EN",@"DOC",
      @"GROUP_S",@"ORG_VIEW",@"ROSTER_ADD",@"ROSTER_INVITE"
      ];
    return authorityArray;
}

+(NSArray *)getUserAuthorityLevelArray
{
    NSArray *levelArray=@[@"V",@"J",@"N",@"S"];
    return levelArray;
}

+(NSString *)userAuthorityLevel
{
    NSString *rst=@"";
    NSArray *levelArray=[Authority getUserAuthorityLevelArray];
    int lv=[sqlite getAuthorityLevel];
    if (lv!=AUTHORITY_FUNCTION_ERROR)
    {
        lv-=AUTHORITY_FUNCTION_LEVEL_V;
    }
    if (lv>=0 && lv<[levelArray count])
    {
        rst=[levelArray objectAtIndex:lv];
    }
    else
        rst=@"J";
    return rst;
}

//获取权限
+(int)functionCode:(NSString *)fun_str
{
    NSArray *authorityArray=[self getAuthorityArray];
    NSArray *levelArray=[self getUserAuthorityLevelArray];

    for (int i=0;i<[authorityArray count];i++)
    {
        if ([authorityArray[i] isEqualToString:fun_str])
        {
            return i;
        }
    }
    
    for (int i=0;i<[levelArray count];i++)
    {
        if ([levelArray[i] isEqualToString:fun_str])
        {
            return i+AUTHORITY_FUNCTION_LEVEL_V;
        }
    }
    return AUTHORITY_FUNCTION_ERROR;
}

+(void)tipNoAccess
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您无权使用该项功能!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

//从数据库判断是否允许使用功能
+(BOOL)permission:(int)fm
{
    if (fm<0)
        return YES;
    return [sqlite permissionAuthority:fm];
}

@end
