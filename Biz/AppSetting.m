//
//  AppSetting.m
//  FaFa
//
//  Created by mac on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppSetting.h"
#import "Utils.h"
//#import "SNSCommObject.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SNSDataClass.h"
#import "SQLiteOper.h"

//NSArray *emotionString;
//NSArray *emotionNameCN;
//NSArray *emotionImageName;
//NSMutableArray *emotionImageArray;
//BOOL firstLogin; //是否第一次登录
//NSString *const UPDATE_URL=@"http://itunes.apple.com/lookup?id=526657411";

NSString *const DEFAULT_JID=@"defualtjid@fafacn.com";
//////////////////////////////
//OtherLoginCache
@implementation ThirdLoginCache

@end

static ThirdLoginCache *thirdLoginCache;


//////////////////////////////
@implementation AppSetting

//==================================================
/**
以Dictionary格式存储所有设置参数
{
  "loginaccount" : {UserID:"xx@xx.xx", Password:"", AutoLogin:"0", RememberPasswd:"1", ServerAddr:"https://www.wefafac.com", SwitchAlertVoice:"1"}
}
**/
static NSMutableDictionary *dicAllSettings;
static NSMutableDictionary *dicCurrUserSettings;
static NSString *currLoginAccount;
static NSString *const SETTINGFILENAME=@"fafasetting.plist";

//==================================================

+(void)load:(NSString*)loginaccount
{    
    NSString *filepath = [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:SETTINGFILENAME];
    
    if (currLoginAccount != nil)
    {
        OBJC_RELEASE(currLoginAccount);
    }
    currLoginAccount = [loginaccount copy];
    
    if (dicCurrUserSettings != nil)
    {
        OBJC_RELEASE(dicCurrUserSettings);
    }
    
    if (dicAllSettings != nil)
    {
        OBJC_RELEASE(dicAllSettings);
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath])
    {
        dicAllSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath]; 
    }
    
#if ! __has_feature(objc_arc)
    if (dicAllSettings == nil) dicAllSettings = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
#else
    if (dicAllSettings == nil) dicAllSettings = [NSMutableDictionary dictionaryWithCapacity:10];
#endif
    
    dicCurrUserSettings = [dicAllSettings objectForKey:loginaccount];
    if (dicCurrUserSettings == nil)
    {
        dicCurrUserSettings = [NSMutableDictionary dictionaryWithCapacity:10];
        [dicAllSettings setObject:dicCurrUserSettings forKey:loginaccount];    
    }
    
#if ! __has_feature(objc_arc)
    [dicCurrUserSettings retain];
#endif
}

+(void)del:(NSString*)loginaccount
{
    [dicAllSettings removeObjectForKey:loginaccount];
    if ([loginaccount isEqualToString:dicCurrUserSettings[@"UserID"]])
    {
        [AppSetting load:@""];
    }
}

+(void)save
{
    if (thirdLoginCache!=nil)
        return;
    
    NSString *filepath = [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:SETTINGFILENAME];
    
    [dicAllSettings writeToFile:filepath atomically:YES];
}

+(NSString*)getFafaJid:(NSString*)loginaccount
{
    NSString *re = nil;
    
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
        return thirdLoginCache.jid;
    
    //
    NSDictionary *dicX = dicAllSettings[loginaccount];
    re = [dicX objectForKey:@"FafaJid"];
    
    return re;
}

+(NSMutableArray*)getHisLoginAccount
{
    NSMutableArray *arrX = [dicAllSettings objectForKey:@"HisLoginAccount"];
    if (arrX.count == 0)
    {
        //查看是否有旧版本的
        NSString *oldloginAccPath= [[self getFaFaDocPath] stringByAppendingPathComponent:@"LoginAccList.plist"];
        if([[NSFileManager defaultManager] fileExistsAtPath:oldloginAccPath])
        {
            arrX = [NSMutableArray arrayWithContentsOfFile:oldloginAccPath];
        }
        
        if (arrX == nil) arrX = [NSMutableArray arrayWithCapacity:10];
        [dicAllSettings setObject:arrX forKey:@"HisLoginAccount"];
    }
    
    return arrX;
}

//==================================================
+(NSString*) getSNSFaFaDomain
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"ServerAddr"];
//    if (re == nil) re = @"http://we.fafatime.com";//@"https://www.wefafa.com"
    if (re == nil) re = DEFAULT_SERVER;
    
    
    return re;
}
+(void) setSNSFaFaDomain:(NSString*) value
{
    [dicCurrUserSettings setObject:value forKey:@"ServerAddr"];
}
+(NSString*) getIMServer
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"IMServer"];
    if (re == nil) re = @"127.0.0.1";
    
    return re;
}
+(void) setIMServer:(NSString*) value
{
    [dicCurrUserSettings setObject:value forKey:@"IMServer"];
}
+(int) getIMServerPort
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"IMServerPort"];
    if (re == nil) re = @"0";
    
    return [re intValue];
}
+(void) setIMServerPort:(int) value
{
    [dicCurrUserSettings setObject:[NSString stringWithFormat:@"%d", value] forKey:@"IMServerPort"];
}
+(NSString*) getIMUpdateServer
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"IMUpdateServer"];
    if (re == nil) re = @"http://update.wefafa.com";
    
    return re;
}
+(void) setIMUpdateServer:(NSString*) value
{
    [dicCurrUserSettings setObject:value forKey:@"IMUpdateServer"];
}

+(void)add:(NSString*)loginaccount
{
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
        return;
    
    NSMutableArray *arrX = [AppSetting getHisLoginAccount];
    
    [arrX removeObject:loginaccount];
    [arrX insertObject:loginaccount atIndex:0];
}
//+(BOOL)getIsThirdLogin
//{
//    BOOL isThird=NO;
//    if (thirdLoginCache!=nil)
//    {
//      isThird=YES;
//    }
//    return isThird;
//    //todo OtherLoginCache Chengyb 20141015
//}
+(NSString*) getUserID
{
    NSString *re = nil;
    
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
        return thirdLoginCache.userid;
    
    
    //
    re = [dicCurrUserSettings objectForKey:@"UserID"];
    if (re == nil) re = currLoginAccount;
    
    return re;
}

+(void) setUserID:(NSString*) value
{
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
    {
        thirdLoginCache.userid=[[NSString alloc] initWithFormat:@"%@",value];
        return;
    }

//    if (![currLoginAccount isEqualToString:value])
    {
        [dicCurrUserSettings setObject:value forKey:@"UserID"];
        [dicAllSettings removeObjectForKey:currLoginAccount];
        [dicAllSettings setObject:dicCurrUserSettings forKey:value];
        OBJC_RELEASE(currLoginAccount);
        currLoginAccount = [value copy];
    }
}

+(NSString*) getPassword
{
    NSString *re = nil;
    
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
        return thirdLoginCache.password;
    
    
    //
    re = [dicCurrUserSettings objectForKey:@"Password"];
    if (re == nil) re = @"";
    
    return re;
}

+(void) setPassword:(NSString*) value
{
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
    {
        thirdLoginCache.password=[[NSString alloc] initWithFormat:@"%@",value];
        return;
    }
    
    
    //
    [dicCurrUserSettings setObject:value forKey:@"Password"];
}

+(NSString *) getNewPassWord
{
    NSString *re = nil;
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
        return thirdLoginCache.password;
    
    re = [dicCurrUserSettings objectForKey:@"NewPassword"];
    if (re == nil) re = @"";
    
    return re;
}

+(void) setPassword:(NSString*) value Jid:(NSString *)jid PassDes:(NSString *)des
{
    [self setPassword:value];
    [self setFafaJid:jid];
    
    if (des.length!=0)
    {
        [dicCurrUserSettings setObject:des forKey:@"NewPassword"];
    }
}

+(bool) getRememberPasswd
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"RememberPasswd"];
    if (re == nil) re = @"0";
    
    return [@"1" isEqualToString:re];
}
+(void) setRememberPasswd:(bool) value
{
    //todo OtherLoginCache Chengyb 20141015
    if (thirdLoginCache!=nil)
    {
        return;
    }
    
    
    //
    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"RememberPasswd"];
}
+(bool) getAutoLogin
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"AutoLogin"];
    if (re == nil) re = @"0";
    
    return [@"1" isEqualToString:re];
}
+(NSString *)getMyLoginAccount
{
    SNSStaffFull *stf = [[SNSStaffFull alloc] init];
    [sqlite getStaffFullByJid:[AppSetting getFafaJid] stafffull:stf];
    return stf.login_account;
}
+(void) setAutoLogin:(bool) value
{
    if (thirdLoginCache!=nil)
    {
        return;
    }
    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"AutoLogin"];
}
+(bool) getMsgTipVoice
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"MsgTipVoice"];
    if (re == nil) re = @"1";
    
    UInt32 route = [re isEqualToString:@"1"] ? kAudioSessionOverrideAudioRoute_Speaker : kAudioSessionOverrideAudioRoute_None;
    //    error =
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);

    return [@"1" isEqualToString:re];
}
+(void) setMsgTipVoice:(bool) value
{
    if (thirdLoginCache!=nil)
    {
        return;
    }

    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"MsgTipVoice"];
}
+(bool) getMsgTipViber
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"MsgTipViber"];
    if (re == nil) re = @"0";
    
    return [@"1" isEqualToString:re];
}
+(void) setMsgTipViber:(bool) value
{
    if (thirdLoginCache!=nil)
    {
        return;
    }

    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"MsgTipViber"];
}
+(bool) getVoiceMsgSpeakerOn
{
    NSString *re = nil;
    
    re = [dicCurrUserSettings objectForKey:@"VoiceMsgSpeakerOn"];
    if (re == nil) re = @"1";
    
    return [@"1" isEqualToString:re];
}
+(void) setVoiceMsgSpeakerOn:(bool) value
{
    if (thirdLoginCache!=nil)
    {
        return;
    }

    [dicCurrUserSettings setObject:value?@"1":@"0" forKey:@"VoiceMsgSpeakerOn"];
}
+(NSString*) getFafaJid
{
    NSString *re = nil;
    if (thirdLoginCache!=nil)
    {
        return thirdLoginCache.jid;
    }

    re = [dicCurrUserSettings objectForKey:@"FafaJid"];
    if (re == nil) re = @"";
    
    return re;
}
+(void) setFafaJid:(NSString*) value
{
    if (thirdLoginCache!=nil)
    {
        thirdLoginCache.jid=[[NSString alloc] initWithFormat:@"%@",value];
        return;
    }

    [dicCurrUserSettings setObject:value forKey:@"FafaJid"];
}

+(NSString*) getRegistState
{
    NSString *re = nil;
    
    re = [dicAllSettings objectForKey:@"RegistState"];
    if (re == nil) re = @"0";
    
    return re;
}
+(void) setRegistState:(NSString*) value
{
    if (thirdLoginCache!=nil)
    {
        return;
    }

    [dicAllSettings setObject:value forKey:@"RegistState"];
}

//==================================================


+(NSString*) getFaFaDocPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[paths objectAtIndex:0];
    return documentPath;
}

+(NSString*) getPersonalFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getFaFaDocPath] stringByAppendingPathComponent:jid];
}

+(NSString*) getPersonalFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getPersonalFilePathWithJID:jid];
}

+(NSString*) getRecvFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"receive"];
}

+(NSString*) getRecvFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getRecvFilePathWithJID:jid];
}

+(NSString*) getTempFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"tmp"];
}

+(NSString*) getTempFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getTempFilePathWithJID:jid];
}

+(NSString*) getSNSHeadImgFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"snsheadcache"];
}

+(NSString*) getSNSHeadImgFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getSNSHeadImgFilePathWithJID:jid];
}

+(NSString*) getSNSAttachFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"snsattachfile"];
}

+(NSString*) getSNSAttachFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getSNSAttachFilePathWithJID:jid];
}

+(NSString*) getPluginFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"plugin"];
}

+(NSString*) getPluginFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getPluginFilePathWithJID:jid];
}

+(NSString*) getAppCenterFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"appcenter"];
}

+(NSString*) getAppCenterFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getAppCenterFilePathWithJID:jid];
}

+(NSString*) getXMLFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"xml"];
}

+(NSString*) getXMLFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getXMLFilePathWithJID:jid];
}

+(NSString*) getMBCacheFilePathWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [[AppSetting getPersonalFilePathWithJID:jid] stringByAppendingPathComponent:@"mbapp"];
}

+(NSString*) getMBCacheFilePath
{
    NSString *jid=[AppSetting getFafaJid];
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    return [AppSetting getMBCacheFilePathWithJID:jid];
}

+(void) createPersonalFileDir
{    
    [Utils createDirectory:[AppSetting getRecvFilePath]];
    [Utils createDirectory:[AppSetting getTempFilePath]];
    [Utils createDirectory:[AppSetting getSNSHeadImgFilePath]];
    [Utils createDirectory:[AppSetting getSNSAttachFilePath]];
    [Utils createDirectory:[AppSetting getPluginFilePath]];
    [Utils createDirectory:[AppSetting getAppCenterFilePath]];
    [Utils createDirectory:[AppSetting getMBCacheFilePath]];
    [Utils createDirectory:[AppSetting getXMLFilePath]];
}

+(void) createPersonalFileDirWithJID:(NSString *)jid
{
    if (jid.length==0)
        jid=[NSString stringWithFormat:@"%@",DEFAULT_JID];
    [Utils createDirectory:[AppSetting getRecvFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getTempFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getSNSHeadImgFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getSNSAttachFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getPluginFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getAppCenterFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getMBCacheFilePathWithJID:jid]];
    [Utils createDirectory:[AppSetting getXMLFilePathWithJID:jid]];
}

static bool _isVoiceTalking = false;
+(bool)isVoiceTalking
{
    return _isVoiceTalking;
}

+(void)setVoiceTalking:(bool) value
{
    _isVoiceTalking = value;
}

+ (BOOL)createVedioTempPath
{
    NSString *temp = NSTemporaryDirectory();
    NSString *path = [temp stringByAppendingPathComponent:@"VeidoFolder"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isCreate = YES;
    if (![manager fileExistsAtPath:path]) {
      isCreate = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isCreate;
}


//+(NSString *)getRegularEmotionString:(NSArray *)emotionstr
//{
//    NSMutableString *regularstr=[[[NSMutableString alloc] initWithFormat:@"("] autorelease];
//    int i;
//    for(i=0;i<[emotionstr count];i++)
//    {
//        if (i>0)
//            [regularstr appendString:@"|"];
//        [regularstr appendFormat:@"\\[%@\\]",[emotionstr objectAtIndex:i]];
//    }
//    
//    [regularstr appendString:@")"];
//    
//    return regularstr;
//}
//
//+(NSString *)getRegularEmotionCHNString:(NSArray *)emotionstr_cn
//{
//    NSMutableString *regularstr=[[[NSMutableString alloc] initWithFormat:@"("] autorelease];
//    int i;
//    for(i=0;i<[emotionstr_cn count];i++)
//    {
//        if (i>0)
//            [regularstr appendString:@"|"];
//        [regularstr appendFormat:@"\\/%@",[emotionstr_cn objectAtIndex:i]];
//    }
//    
//    [regularstr appendString:@")"];
//    
//    return regularstr;
//}
//
//+(NSString *)replaceIMFaceCHNString:(NSString *)message
//{
//    NSString *resultString=[[[NSString alloc] initWithFormat:@""] autorelease];
//    NSString * reg=[AppSetting getRegularEmotionCHNString:emotionNameCN];
//    
//    NSRange r= [message rangeOfString:reg options:NSRegularExpressionSearch];
//    //是否有表情
//    if (r.length != NSNotFound &&r.length != 0)
//    {
//        
//        int i=0;
//        int lastlocation=0;
//        
//        do {
//            NSString* substr = [message substringWithRange:r];
//            //type:(image,image_ft_pic,text)
//            if (lastlocation!=r.location)
//            {
//                //文字
//                NSString *firstText=[message substringWithRange:NSMakeRange(lastlocation, r.location-lastlocation)];
//                resultString=[resultString stringByAppendingString:firstText];
//            }
//            
//            if (r.length>0)
//            {
//                //图
//                NSArray *arr=[substr componentsSeparatedByString:@"/"];
//                NSString *emotionCHNStr;
//                if ([arr count]==2)
//                {
//                    emotionCHNStr=[arr objectAtIndex:1];
//                }
//                else
//                    emotionCHNStr=[NSString stringWithFormat:@"%@",substr];
//                
//                resultString=[resultString stringByAppendingFormat:@"%@",[AppSetting getEmotionStringByNameCN:emotionCHNStr]];
//            }
//            
//            ///////////////////////////////////////
//            //剩余部分
//            lastlocation=r.location+r.length;
//            NSRange startr=NSMakeRange(r.location+r.length, [message length]-r.location-r.length);
//            //检查剩余部分是否为空
//            NSString *nextstr=[message substringWithRange:startr];
//            if ([nextstr isEqualToString:@""]) {
//                break;
//            }
//            
//            //匹配
//            r=[message rangeOfString:reg options:NSRegularExpressionSearch range:startr];
//            
//            //是否最后一行文本
//            if (r.length == 0 )
//            {
//                //文字
//                NSString *firstText=[message substringWithRange:startr];
//                resultString=[resultString stringByAppendingString:firstText];
//            }
//        }while (r.length != NSNotFound &&r.length != 0);
//    } else if (message != nil) {
//        //文字
//        resultString=[[[NSString alloc] initWithFormat:@"%@",message] autorelease];
//    }
//    return resultString;
//}
//
//+(NSString *)getRegularEmotionAndMediaString:(NSArray *)emotionstr
//{
//    NSMutableString *regularstr=[[[NSMutableString alloc] initWithFormat:@"("] autorelease];
//    int i;
//    for(i=0;i<[emotionstr count];i++)
//    {
//        [regularstr appendString:[emotionstr objectAtIndex:i]];
//        [regularstr appendString:@"|"];
//    }
//    //filetransfer
//    [regularstr appendString:@"(\\{[\\[\\(]([a-zA-Z0-9]{32}\\.[a-zA-Z0-9]{3,5})[\\]\\)]\\})"];
//    
//    [regularstr appendString:@")"];
//    
//    return regularstr;
//}
//
//+(NSString *)getEmotionImageNameByStr:(NSString *)emotionstr
//{
//    NSString *rst=nil;
//    int i=0;
//    for(i=0;i<[emotionString count];i++)
//    {
//        NSString *str=[emotionString objectAtIndex:i];
//        if ([str isEqualToString:emotionstr])
//        {
//            rst=[[[NSString alloc] initWithFormat:@"%@",[emotionImageName objectAtIndex:i]] autorelease];
//            break;
//        }
//    }
//    if (rst==nil)
//        rst=[[[NSString alloc] initWithFormat:@""]autorelease];
//    return rst;
//}
//
//+(NSString *)getEmotionImageNameByNameCN:(NSString *)namecn
//{
//    NSString *rst=nil;
//    int i=0;
//    for(i=0;i<[emotionNameCN count];i++)
//    {
//        NSString *str=[emotionNameCN objectAtIndex:i];
//        if ([str isEqualToString:namecn])
//        {
//            rst=[[[NSString alloc] initWithFormat:@"%@",[emotionImageName objectAtIndex:i]] autorelease];
//            break;
//        }
//    }
//    if (rst==nil)
//        rst=[[[NSString alloc] initWithFormat:@""]autorelease];
//    return rst;
//}
//
//+(NSString *)getEmotionNameCNByStr:(NSString *)emotionstr
//{
//    NSString *rst=nil;
//    int i=0;
//    for(i=0;i<[emotionString count];i++)
//    {
//        NSString *str=[emotionString objectAtIndex:i];
//        if ([str isEqualToString:emotionstr])
//        {
//            rst=[[[NSString alloc] initWithFormat:@"%@",[emotionNameCN objectAtIndex:i]] autorelease];
//            break;
//        }
//    }
//    if (rst==nil)
//        rst=[[[NSString alloc] initWithFormat:@""]autorelease];
//    return rst;
//}
//
//+(NSString *)getEmotionStringByNameCN:(NSString *)namecn
//{
//    NSString *rst=nil;
//    int i=0;
//    for(i=0;i<[emotionNameCN count];i++)
//    {
//        NSString *str=[emotionNameCN objectAtIndex:i];
//        if ([str isEqualToString:namecn])
//        {
//            rst=[[[NSString alloc] initWithFormat:@"%@",[emotionString objectAtIndex:i]] autorelease];
//            break;
//        }
//    }
//    if (rst==nil)
//        rst=[[[NSString alloc] initWithFormat:@""]autorelease];
//    return rst;
//}
//
//+(NSString *)IMMessage2SessionText:(NSString*)message {
//    
//    ////////////////////////////////////
//    NSRegularExpression *pvoicesec = [NSRegularExpression regularExpressionWithPattern:@"(\\{\\(([a-zA-Z0-9]{32}\\.[a-zA-Z0-9]{3,5})\\)\\})" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSTextCheckingResult *mvoicesec = [pvoicesec firstMatchInString:message options:0 range:NSMakeRange(0, [message length])];
//    if (mvoicesec) {
//        //            NSString * matchstring= [result substringWithRange:mvoicesec.range];
//        NSRange filerange=NSMakeRange(0,mvoicesec.range.location);
//        NSString * filestr = [message substringWithRange:filerange];
//        
////        NSString * temp=[NSString stringWithFormat:@"[语音消息]"];
////        NSString *replacestring = [pvoicesec stringByReplacingMatchesInString:message options:0 range:NSMakeRange(mvoicesec.range.location, mvoicesec.range.length) withTemplate:temp];
//        return @"[语音消息]";
//    }
//
//    NSMutableString *result=[[[NSMutableString alloc] init] autorelease];
//    
//    NSString * reg=[AppSetting getRegularEmotionAndMediaString:emotionString];
//    
//    NSRange r= [message rangeOfString:reg options:NSRegularExpressionSearch];
//    //是否有表情
//    if (r.length != NSNotFound &&r.length != 0)
//    {
//        
//        int i=0;
//        int lastlocation=0;
//        
//        do {
//            NSString* substr = [message substringWithRange:r];
//            
//            //type:(image,image_ft_pic,text)
//            if (lastlocation!=r.location)
//            {
//                //文字
//                NSString *firstText=[message substringWithRange:NSMakeRange(lastlocation, r.location-lastlocation)];
//                [result appendString:firstText];
//            }
//            
//            if (r.length>0)
//            {
//                //图片
//                NSString *expressText=[message substringWithRange:NSMakeRange(r.location, r.length)];
//                NSDictionary *dict;
//                if ([[expressText substringToIndex:2] isEqualToString:@"{["]==YES)
//                {
//                    NSRange range1=NSMakeRange(2, [expressText length]-4);
//                    NSString *filename = [expressText substringWithRange:range1];
//                    [result appendString:@"[图片]"];
//                }
//                else if ([[expressText substringToIndex:2] isEqualToString:@"{("]==YES)
//                {
//                    NSRange range1=NSMakeRange(2, [expressText length]-4);
//                    NSString *filename = [expressText substringWithRange:range1];
//                    [result appendString:@"[语音消息]"];
//                }
//                else
//                {
//                    //expressText
//                    NSString *imageName=[AppSetting getEmotionNameCNByStr:expressText];
//                    [result appendFormat:@"[%@]",imageName];
//                }
//            }
//            
//            
//            
//            ///////////////////////////////////////
//            //剩余部分
//            lastlocation=r.location+r.length;
//            NSRange startr=NSMakeRange(r.location+r.length, [message length]-r.location-r.length);
//            //检查剩余部分是否为空
//            NSString *nextstr=[message substringWithRange:startr];
//            if ([nextstr isEqualToString:@""]) {
//                return result;
//            }
//            
//            //匹配
//            r=[message rangeOfString:reg options:NSRegularExpressionSearch range:startr];
//            
//            //是否最后一行文本
//            if (r.length == 0 )
//            {
//                //文字
//                NSString *firstText=[message substringWithRange:startr];
//                [result appendString:firstText];
//            }
//        }while (r.length != NSNotFound &&r.length != 0);
//    } else if (message != nil) {
//        //文字
//        [result appendString:message];
//    }
//    return result;
//}
+(void)closeThirdLoginAccount //关闭三方登录
{
    thirdLoginCache=nil;
}
+(void)startThirdLoginAccount //开启三方登录
{
    thirdLoginCache=[[ThirdLoginCache alloc] init];
}

//为了避免新版和老版数据不兼容，新版本第一次运行时清空老版的缓存
+ (void)clearOldVersionCacheDataOnlyOnceInTheNewVersion
{
    //NSLog(@"NSHomeDirectory() = %@", NSHomeDirectory());
    
    NSString *shortVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSString *versionId = [NSString stringWithFormat:@"%@_%@", shortVersionString, versionString];
    
    //NSLog(@"shortVersionString = %@, versionString = %@, versionId = %@", shortVersionString, versionString, versionId);
    
    BOOL  isNewVersion = NO;
    NSString *isNewVersionFileName = @"isNewVersion.db";
    
    NSString *isNewVersionFilepath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), isNewVersionFileName];
    
    //NSLog(@"isNewVersionFilepath = %@", isNewVersionFilepath);
    
    NSMutableDictionary *isNewVersionMutableDictionary = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:isNewVersionFilepath])
    {
        [[NSFileManager defaultManager] createFileAtPath:isNewVersionFilepath contents:nil attributes:nil];
        isNewVersion = YES;
        
        
        isNewVersionMutableDictionary = [[NSMutableDictionary alloc] init];
        [isNewVersionMutableDictionary setObject:@"NO" forKey:versionId];
    }
    else
    {
        isNewVersionMutableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:isNewVersionFilepath];
        if (isNewVersionMutableDictionary == nil)
        {
            isNewVersion = YES;
            
            isNewVersionMutableDictionary = [[NSMutableDictionary alloc] init];
            [isNewVersionMutableDictionary setObject:@"NO" forKey:versionId];
        }
        else
        {
            NSString *versionIdValue = isNewVersionMutableDictionary[versionId];
            if (versionIdValue == nil || [versionIdValue isEqualToString:@"YES"])
            {
                isNewVersion = YES;
                
                [isNewVersionMutableDictionary setObject:@"NO" forKey:versionId];
            }
            else
            {
                isNewVersion = NO;
            }
        }
    }
    
    
    
    //更新是否是新版的文件
    BOOL ret = [isNewVersionMutableDictionary writeToFile:isNewVersionFilepath atomically:YES];
    if (!ret)
    {
        //NSLog(@"writeToFile:isNewVersionFilepath err");
    }
    
    if (isNewVersion)
    {
       // NSLog(@"开始清空缓存");
    
        NSString *libraryPath = [NSString stringWithFormat:@"%@/Library", NSHomeDirectory()];
        NSString *documentsPath = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
        NSString *tmpPath = [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
        
        
        ret = NO;
        NSError *error = nil;
        
        NSArray *subpathsArray = nil;
        
        subpathsArray = [[NSFileManager defaultManager] subpathsAtPath:tmpPath];
        for (NSString *subfile in subpathsArray)
        {
            NSString *subpath = [NSString stringWithFormat:@"%@/%@", tmpPath, subfile];
            //NSLog(@"subpath = %@", subpath);
            
           // NSLog(@"subfile = %@", subfile);
            
            error = nil;
            ret = [[NSFileManager defaultManager] removeItemAtPath:subpath error:&error];
            if (!ret || error != nil)
            {
                //NSLog(@"removeItemAtPath:tmpPath error = %@", error);
            }
        }
        
        
        
        subpathsArray = [[NSFileManager defaultManager] subpathsAtPath:libraryPath];
        for (NSString *subfile in subpathsArray)
        {
            NSString *subpath = [NSString stringWithFormat:@"%@/%@", libraryPath, subfile];
            //NSLog(@"subpath = %@", subpath);
            
            //NSLog(@"subfile = %@", subfile);
            
            error = nil;
            ret = [[NSFileManager defaultManager] removeItemAtPath:subpath error:&error];
            if (!ret || error != nil)
            {
                //NSLog(@"removeItemAtPath:libraryPath error = %@", error);
            }
        }
        
        //Documents目录下面只保留用户登录等等相关设置信息，其他全部删掉
        subpathsArray = [[NSFileManager defaultManager] subpathsAtPath:documentsPath];
        for (NSString *subfile in subpathsArray)
        {
            NSString *subpath = [NSString stringWithFormat:@"%@/%@", documentsPath, subfile];
            NSLog(@"subfile = %@", subfile);
            
            if (![subfile isEqualToString:SETTINGFILENAME] && ![subfile isEqualToString:isNewVersionFileName])
            {
                error = nil;
                ret = [[NSFileManager defaultManager] removeItemAtPath:subpath error:&error];
                if (!ret || error != nil)
                {
                    //NSLog(@"removeItemAtPath:documentsPath error = %@", error);
                }
            }
        }
    }
}




static AppSetting *g_appSetting = nil;

+ (void)showAppUpdateAlertView
{
    static int i = 0;
    
    if (i > 0)
    {
        return;
    }
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSMutableString *currentVersionCode = [[NSMutableString alloc] init];
    NSMutableString *latestVersionCode = [[NSMutableString alloc] init];
    
    
    for (int i=0; i<[currentVersion length]; i++)
    {
        unichar ch;
        
        [currentVersion getCharacters:&ch range:NSMakeRange(i, 1)];
        
        if ((ch >= '0'&&ch <= '9'))
        {
            [currentVersionCode appendFormat:@"%c", ch];
        }
    }
    
    
    for (int i=0; i<[VERSION_NAME length]; i++)
    {
        unichar ch;
        
        [VERSION_NAME getCharacters:&ch range:NSMakeRange(i, 1)];
        
        if ((ch >= '0'&&ch <= '9'))
        {
            [latestVersionCode appendFormat:@"%c", ch];
        }
    }
    
    
    if (g_appSetting == nil)
    {
        g_appSetting = [[AppSetting alloc] init];
    }
    
    
    if (strcmp([latestVersionCode UTF8String], [currentVersionCode UTF8String]) > 0)
    {
        if ([IS_FORCE_UPDATE integerValue] == 1)//强制更新
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:VERSION_INFO delegate:g_appSetting cancelButtonTitle:@"更新" otherButtonTitles:nil];
            
            i++;
            [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:VERSION_INFO delegate:g_appSetting cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
            
            i++;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([IS_FORCE_UPDATE integerValue] == 1)//强制更新
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/you-fan/id977919857?mt=8"]];
        exit(0);
    }
    else
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/you-fan/id977919857?mt=8"]];
        }
        
        g_appSetting = nil;
    }
}


@end













