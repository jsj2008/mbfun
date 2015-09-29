//
//  AppSetting.h
//  FaFa
//
//  Created by mac on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern NSArray *emotionString;
//extern NSArray *emotionNameCN;
//extern NSArray *emotionImageName;
//extern NSMutableArray *emotionImageArray;
//extern NSString *const UPDATE_URL;
//
//extern BOOL firstLogin;

//微信，qq等第三方登录存放登录帐号信息缓存。
@interface ThirdLoginCache : NSObject

@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *jid;

@end




@interface AppSetting : NSObject<UIAlertViewDelegate>

//读取配置文件，若loginaccount已存在，则读取该用户配置，否则给予default value
+(void)load:(NSString*)loginaccount;
+(void)del:(NSString*)loginaccount;
+(void)save;
+(NSString*)getFafaJid:(NSString*)loginaccount;
+(NSMutableArray*)getHisLoginAccount;

+(NSString*) getSNSFaFaDomain;
+(void) setSNSFaFaDomain:(NSString*) value;
+(NSString*) getIMServer;
+(void) setIMServer:(NSString*) value;
+(int) getIMServerPort;
+(void) setIMServerPort:(int) value;
+(NSString*) getIMUpdateServer;
+(void) setIMUpdateServer:(NSString*) value;
+(void)add:(NSString*)loginaccount;
+(NSString*) getUserID;
+(void) setUserID:(NSString*) value;
+(NSString*) getPassword;
+(void) setPassword:(NSString*) value;
+(bool) getRememberPasswd;
+(void) setRememberPasswd:(bool) value;
+(bool) getAutoLogin;
+(void) setAutoLogin:(bool) value;
+(bool) getMsgTipVoice;
+(void) setMsgTipVoice:(bool) value;
+(bool) getMsgTipViber;
+(void) setMsgTipViber:(bool) value;
+(bool) getVoiceMsgSpeakerOn;
+(void) setVoiceMsgSpeakerOn:(bool) value;
+(NSString*) getFafaJid;
+(void) setFafaJid:(NSString*) value;
+(NSString*) getRegistState;
+(void) setRegistState:(NSString*) value;

+(NSString*) getFaFaDocPath;
+(NSString*) getPersonalFilePath;
+(NSString*) getPersonalFilePathWithJID:(NSString *)jid;
+(NSString*) getRecvFilePath;
+(NSString*) getTempFilePath;
+(NSString*) getSNSHeadImgFilePath;
+(NSString*) getSNSAttachFilePath;
+(NSString*) getPluginFilePath;
+(NSString*) getAppCenterFilePath;
+(NSString*) getXMLFilePath;
+(NSString*) getMBCacheFilePath;

+ (BOOL)createVedioTempPath;
+(void) createPersonalFileDir;
+(void) createPersonalFileDirWithJID:(NSString *)jid;

+(bool)isVoiceTalking;
+(void)setVoiceTalking:(bool) value;

+(NSString *)getMyLoginAccount;
+(void)closeThirdLoginAccount; //关闭三方登录
+(void)startThirdLoginAccount; //开启三方登录
//+(NSString *)getThirdLoginId;  //获取第三方登陆的useid


//+(NSString *)getRegularEmotionString:(NSArray *)emotionstr;
//+(NSString *)getRegularEmotionAndMediaString:(NSArray *)emotionstr;
//+(NSString *)getEmotionImageNameByStr:(NSString *)emotionstr;
//+(NSString *)getEmotionNameCNByStr:(NSString *)emotionstr;
//+(NSString *)getEmotionImageNameByNameCN:(NSString *)namecn;
//+(NSString *)getEmotionStringByNameCN:(NSString *)namecn;
//+(NSString *)replaceIMFaceCHNString:(NSString *)message;
//+(NSString *)IMMessage2SessionText:(NSString*)message;
+(void) setPassword:(NSString*) value Jid:(NSString *)jid PassDes:(NSString *)des;
+(NSString *) getNewPassWord;


//为了避免新版和老版数据不兼容，新版本第一次运行时清空老版的缓存
+ (void)clearOldVersionCacheDataOnlyOnceInTheNewVersion;

+ (void)showAppUpdateAlertView;

@end
