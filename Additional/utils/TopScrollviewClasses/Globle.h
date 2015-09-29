//
//  Globle.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define SHEAR1  @"shear1"
#define SHEAR2  @"shear2"
#define SHEAR3  @"shear3"
#define focusMemoryFilterDic @"focusMemoryFilter"
#import "AppDelegate.h"
#import "HttpRequest.h"
#import "JsonToModel.h"
#import "Base64.h"
#import "NSString+help.h"
#import "UIImageView+WebCache.h"
#import "UIKit+AFNetworking.h"
#import "UIColor+extend.h"
#import "UIViewController+help.h"
#import "sys/utsname.h"
#import "YYAnimationIndicator.h"
#import "NavTopTitleView.h"
#import "Toast+UIView.h"
#import "MJRefresh.h"
#import "NSString+help.h"
#import "AppSetting.h"
#import "SNSDataClass.h"
#import "WXApi.h"
#import "ShareRelated.h"
#import "Toast.h"
#import "Hash.h"
#import "ASIHTTPRequest.h"
#import "EGOCache.h"
#import "TMCache.h"

#import "WeFaFaGet.h"
#import "CommMBBusiness.h"

#import "MBShoppingGuideInterface.h"
#import "TencentQQClient.h"
#import "SinaWeiboClient.h"
#import "Utils.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIViewController+help.h"
#import "GlobelImpl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "DataVerifier.h"
#import "Order.h"



#import "APAuthV2Info.h"
#import "ZLSwipeableView.h"
#import "CardView.h"
#import "MLKMenuPopover.h"
#import "ZMAlertView.h"
#import "NavigationTitleView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#define NOTICE_ADDCHOOSEGOODS  @"addchoosegoods"
#define NOTICE_CLEANCANCANVAS  @"cleanCanvas"
#define NOTICE_PAYALICOMPLETE  @"payAliComplete"
#define NOTICE_PAYFAILURE      @"payFailure"
@interface Globle : NSObject<QQApiInterfaceDelegate>

@property (nonatomic,assign) float globleWidth;
@property (nonatomic,assign) float globleHeight;
@property (nonatomic,assign) float globleAllHeight;
@property (nonatomic,strong) NSString *alipayNotifyUrl;

+ (Globle *)shareInstance;
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;
-(NSString *)getDeviceModelNameAndSystemVersion;
-(void)deleteCreatematchWithNSUserDefaultsKeys;
-(SNSStaffFull *)getUserInfo;
#pragma mark--YYAnimationIndicator
-(YYAnimationIndicator *)addYYAnimationIndicator;

#pragma mark -直接画成image图片
-(UIImage *)imageDrawGroupimageWithimageArray:(NSArray *)imageArray;
-(NSString*) getuuid;
- (NSString *)getTimeNow;
- (NSString *)getRandomWord;
-(BOOL)handleResponseQQZoneWithurl:(NSURL *)qqurl;
@end
