//
//  MainTabViewController.h
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelBase.h" //XML_VIEWCONTROLLER宏定义导入文件


//////////////////////////////////////////////////////////////////////////////////////////

#ifdef XML_VIEWCONTROLLER


#import "SDWebImageManager.h"
#import "ASIHTTPRequest.h"
@interface MainTabViewController : UITabBarController<ASIHTTPRequestDelegate,SDWebImageManagerDelegate,NSXMLParserDelegate,UIScrollViewDelegate,UITabBarControllerDelegate>
{
    bool isviewdidunload;
    
    NSArray *modelArray;
    NSDictionary *transDic;//每一个大模块下小模块
    
    ASIHTTPRequest *tabbarImgViewRequest;
    
    NSString *saveFilePath;//下载的保存文件路径
    NSString *upzipFilePath;//解压文件夹的路径
    
    
    UIView *customTabBarView;
    NSMutableArray *buttons;
    NSMutableArray *buttonsImgViewArray;
    UIImageView *bgImageView;
    UILabel *label;
    int heightios7;
    NSMutableArray *changePic;
    
    UIColor *tabBarBackgroundColor;
    UIColor *tabBarSelectColor;
    UIColor *tabBarButtonTextColor;
    UIColor *tabBarButtonSelectedTextColor;
    
    int getXML_times;
    BOOL firstLoadData;
    
    NSCondition *condition;
}


@property (nonatomic,retain)NSString *dataString;
@property (nonatomic,retain)NSString *detailModelDataString;



@property (nonatomic, retain)NSMutableArray *buttons;
@property (nonatomic, retain)NSMutableArray *buttonsImgViewArray;
@property (nonatomic, retain)NSMutableArray *titleNames;
@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)NSMutableArray *itemImageVName;
@property (nonatomic, retain)NSMutableArray *selectItemImageViewName;
@property (nonatomic, assign)NSInteger currentSelect;

@property (nonatomic, retain)NSString *badgeValue;
@property (nonatomic, retain)UIButton *badgeBtn;


- (void)hiddenTabBar;//隐藏系统本身的
- (void)customTabBar;
//-(void)hiddenTabBar :(BOOL)hidden;
-(void)hiddenCustomTabbar;//隐藏本身
- (void)selectedTabBarItem:(UIButton *)sender;
- (void)currentSelectView:(int)currentIndex;
-(void)cancleHiddenTabbar;//取消隐藏

-(void)loadFrameworkXML;

-(void)tabButtonClicked:(int)index;
+(NSString *)getPortalLocalVersion;
+(NSDictionary *)getPortalConfigLocalData;
+(void)savePortalLocalVersion:(NSString *)version;
+(void)savePortalConfigLocalData:(NSDictionary *)portaldict;

@end

//////////////////////////////////////////////////////////////////////////////////////////
#else

//////////////////////////////////////////////////////////////////////////////////////////


@interface MainTabViewController : UITabBarController
{
    bool isviewdidunload;
}

@end



#endif

