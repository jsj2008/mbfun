//
//  AppDelegate.h
//  Wefafa
//
//  Created by fafa  on 13-6-21.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "RootViewController.h"
#import "CustomStatueBar.h"
#import "ASIHTTPRequest.h"
#import <CoreData/CoreData.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "CommonEventHandler.h"
//#import "SplashScreenViewController.h"



#import "MBSideViewController.h"
#import "MiPushSDK.h"//小米推送sdk

extern BOOL g_isVideoRecording;
extern TencentOAuth *_tencentOAuth;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,UIScrollViewDelegate,WXApiDelegate,TencentSessionDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate,MiPushSDKDelegate, UIAlertViewDelegate>
{
//    UIScrollView *scrollview;
//    UIActivityIndicatorView *indicatorView;
//    UIPageControl *pageC;
    CommonEventHandler* qqCallbackEvent;
    
    UIImageView *launchImageView;
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) CustomStatueBar *custStatuBar;
@property (strong, nonatomic) NSString *devTokenStr;
@property (assign, nonatomic) BOOL appEnterBackground;

//@property (retain,nonatomic) NSString *dataString;
//@property (strong, nonatomic) SplashScreenViewController *splashController;

//@property (nonatomic, strong) UIWindow *statrAnimationWindow;
-(void)logout;

+(AppDelegate *)App;
//+(RootViewController*)rootViewController;
+(UINavigationController*)rootViewController;
+(id)getTabViewControllerObject:(NSString *)className;

@property(strong,nonatomic,readonly)NSManagedObjectModel * managedObjectModel;

@property(strong,nonatomic,readonly)NSManagedObjectContext * managedObjectContext;

@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator * persistentStoreCoordinator;

+(AppDelegate *)shareAppdelegate;
-(void)qqLogin:(CommonEventHandler *)eventHandle;

- (void)saveContext;

//sina weibo
//@property (strong, nonatomic) NSString *wbtoken;
//@property (strong, nonatomic) NSString *wbCurrentUserID;




//////////////////////////////V2
@property (nonatomic ,strong) MBSideViewController * sideViewController ;
//@property (nonatomic, strong) UINavigationController *navHome;

@end

