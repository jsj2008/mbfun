//
//  MainTabViewController.m
//  Wefafa
//
//  Created by fafa  on 13-6-22.
//  Copyright (c) 2013年 fafatime. All rights reserved.
//
//废弃 不用
#import "MainTabViewController.h"

//#import "CommunicateViewController.h"
//#import "CircleHomePageViewController.h"
//#import "MeetingMainViewController.h"
//#import "UserSettingViewController.h"
//#import "SnsMainViewController.h"
//#import "MicroAppViewController.h"
#ifdef XML_VIEWCONTROLLER
#import "AppDelegate.h"
#import "RequstInfo.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "JSON.h"
#import "Toast.h"
#import "LoginViewController.h"
#import "AppSetting.h"
#import "XMLDictionary.h"
#import "ASIHTTPRequest.h"
//#import "GetViewControllerFile.h"
#import "NSNullAdditions.h"
//#import "HomeViewController.h"
#import "CustomButton.h"
#import "AppSetting.h"
#import "WeFaFaGet.h"
#import "Utils.h"
#import "CommMBBusiness.h"
#import "MainUINavigationController.h"
#import "PolyvoreViewController.h"
@interface MainTabViewController ()
{
    NSArray *itemImDocum;
    NSArray *selectImDocum;
}
@end

@implementation MainTabViewController
@synthesize dataString;
@synthesize titleNames;
@synthesize itemImageVName;
@synthesize buttons;
@synthesize bgImageView;
@synthesize selectItemImageViewName;
@synthesize badgeValue;
@synthesize badgeBtn;
@synthesize buttonsImgViewArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.hidden=YES;
     

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
    
    getXML_times=0;
    firstLoadData=YES;
    condition=[[NSCondition alloc] init];
    
    changePic = [[NSMutableArray alloc]init];
    self.titleNames = [[NSMutableArray alloc]init];
    self.itemImageVName = [[NSMutableArray alloc]init];
    self.selectItemImageViewName = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshNavitem) name:@"changeRequest"
                                              object:nil];

    [[NSNotificationCenter  defaultCenter] removeObserver:self
                                                     name:@"changBadge"
                                                   object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeBadgeNumber:) name:@"changBadge"
                                              object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
#ifndef WEFAFA_IOS6_VERSION_COMPILE
//        self.tabBar.translucent=NO;
#endif
    }
}
//系统的隐藏掉
- (void)hiddenTabBar
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITabBar class]])//UITabBar
        {
            view.hidden = YES;
            break;
        }
    }
    
}
- (void)hiddenTabBar:(BOOL)hidder
{
    /*
    for (UIView *view in self.view.subviews)
    {

        if ([view isKindOfClass:[UITabBar class]])//UITabBar
        {
            //            view.hidden = YES;
           if(hidder)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, UI_SCREEN_HEIGHT-20+heightios7, view.frame.size.width, view.frame.size.height)];

            }
            else {


            }

        }else {
            if(hidder)
            {
               [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, UI_SCREEN_HEIGHT-20+44)];

            }else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, UI_SCREEN_HEIGHT-20-29)];//460-29

            }
        }
    }
    */
}
-(void)hiddenCustomTabbar
{
    [self hiddenTabBar:YES];
    [self hiddenTabBar];

    self.bgImageView.hidden=YES;
    
}
-(void)cancleHiddenTabbar
{
    [self hiddenTabBar:NO];
    self.bgImageView.hidden=NO;
    
}
-(void)changeBadgeNumber:(NSNotification*)sender
{
    NSDictionary *di = [sender userInfo];
    
    
    
    if ([[di objectForKey:@"badgeNumber"] intValue]==0)
    {
        self.badgeBtn.hidden=YES;
    }
    else
    {
        self.badgeValue = [NSString stringWithFormat:@"%@",[di objectForKey:@"badgeNumber"]];
        //超过99就一直是99
        if ([self.badgeValue intValue]>99)
        {
            self.badgeValue = [NSString stringWithFormat:@"99"];
            
        }
        if ([self.badgeValue intValue]>9)
        {
            
            [self.badgeBtn setFrame:CGRectMake(self.badgeBtn.frame.origin.x, self.badgeBtn.frame.origin.y , 22, 22)];
        }
        else
        {
            [self.badgeBtn setFrame:CGRectMake(self.badgeBtn.frame.origin.x, self.badgeBtn.frame.origin.y, 18, 18)];
        }
        self.badgeBtn.hidden=NO;
        [self.badgeBtn setTitle:self.badgeValue forState:UIControlStateNormal];
        
        
    }
    
    
}
//////////////
- (void)customTabBar
{
    NSLog(@">>>>MainTabViewController customTabBar");

    if ([bgImageView superview])
    {
        [bgImageView removeFromSuperview];
        
        self.badgeValue=nil;
        
    }
    if ([label superview])
    {
        [label removeFromSuperview];
    }
    
    
    bgImageView = [[UIImageView alloc] initWithFrame:self.tabBar.frame];
    [bgImageView setBackgroundColor:tabBarBackgroundColor];
    bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:bgImageView];
    
    int viewCount = self.viewControllers.count > 5 ? 5 : (int)self.viewControllers.count;
    
    if (viewCount==4)
    {
        itemImDocum=@[@"btn_home_normal@3x.png",@"btn_message_normal@3x.png",@"btn_discover_normal@3x.png",@"btn_me_normal@3x.png"];
        selectImDocum=@[@"btn_home_pressed@3x.png",@"btn_message_pressed@3x.png",@"btn_discover_pressed@3x.png",@"btn_me_pressed@3x.png"];
        
    }else
    {
    itemImDocum=@[@"btn_home_normal@3x.png",@"btn_message_normal@3x.png",@"btn_create_normal@3x.png",@"btn_discover_normal@3x.png",@"btn_me_normal@3x.png"];
    selectImDocum=@[@"btn_home_pressed@3x.png",@"btn_message_pressed@3x.png",@"btn_create_pressed@3x.png",@"btn_discover_pressed@3x.png",@"btn_me_pressed@3x.png"];
    
    }
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    self.buttonsImgViewArray = [NSMutableArray arrayWithCapacity:viewCount];
    
    double width = UI_SCREEN_WIDTH/viewCount;
    double height = self.tabBar.frame.size.height;
    
    for (int i = 0; i < viewCount; i ++)
    {
        CustomButton *tabBarButton = [[CustomButton alloc]initWithFrame:CGRectMake(width*i, 0, width, height) withLineUp:YES];
        tabBarButton.tag = 300 + i;
        tabBarButton.hidden=NO;
        [tabBarButton addTarget:self
                         action:@selector(selectedTabBarItem:)
               forControlEvents:UIControlEventTouchUpInside];
        //读取nsuserdefault中的缓存numberStr来确定消息数目的的位置。
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *numberStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"homePageVCNumber"]];
        
        UIImageView *imageline=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tabBarButton.frame.size.width, 0.5)];
        imageline.backgroundColor=[Utils HexColor:0xafaca5 Alpha:1.0];
        [tabBarButton addSubview:imageline];
        [tabBarButton sendSubviewToBack:imageline];
        
        if (i==[numberStr intValue])
        {
            self.badgeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [self.badgeBtn setBackgroundColor:[UIColor redColor]];
            self.badgeBtn.layer.masksToBounds=YES;
            self.badgeBtn.hidden=YES;
            self.badgeBtn.layer.cornerRadius =10;//self.badgeBtn.frame.size.width/2;
            
            [self.badgeBtn setFrame:CGRectMake(tabBarButton.frame.size.width-30, 2, 18, 18)];
            self.badgeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            self.badgeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            //偏移
            self.badgeBtn.titleEdgeInsets = UIEdgeInsetsMake(0,0, 0, -1.4);
            
            [tabBarButton addSubview:self.badgeBtn];
            
            //不在第一个，homepage没有初始化，要手动调用刷新会话和badgenum
            if (i!=0)
            {
          
            }
        }
        
        
        if ( i==0)
        {
            //            [tabBarButton setBackgroundColor:selectColor];
            [tabBarButton setBackgroundColor:tabBarSelectColor];
            
        }
        else
        {
            //            [tabBarButton setBackgroundColor:color];
            [tabBarButton setBackgroundColor:tabBarBackgroundColor];
            
        }
        
        [buttons addObject:tabBarButton];
        
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
//        NSString *tabbarImgFile= [nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"tabbarImg%d",i]];
//        NSString *selectTabbarImgFile=[nameFile stringByAppendingPathComponent:[NSString stringWithFormat:@"selecttabbarImg%d",i]];
//        
//        if ([fileManager fileExistsAtPath:tabbarImgFile])
//        {
//            UIImage *normalImage=[UIImage imageWithContentsOfFile:tabbarImgFile];
//            tabBarButton.itemImageV.image=normalImage;
//        }
//        else
//        {
//            [fileManager createFileAtPath:tabbarImgFile contents:nil attributes:nil];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *imgBaseChange= [[self.itemImageVName objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSData *normalImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgBaseChange]];
//                [normalImageData writeToFile:tabbarImgFile atomically:YES];
//                //正常状态
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    UIImage *normalImage=[UIImage imageWithContentsOfFile:tabbarImgFile];
//                    tabBarButton.itemImageV.image=normalImage;
//                });
//                
//            });
//
//        }
//        if ([fileManager fileExistsAtPath:selectTabbarImgFile])
//        {
//            UIImage *selectedimage =[UIImage imageWithContentsOfFile:selectTabbarImgFile ];
//            tabBarButton.selectImageView.image = selectedimage;
//        }
//        else
//        {
//            [fileManager createFileAtPath:selectTabbarImgFile contents:nil attributes:nil];
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *imgBaseChange= [[self.selectItemImageViewName objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSData *selectImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgBaseChange]];
//                [selectImageData writeToFile:selectTabbarImgFile atomically:YES];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    UIImage *selectedimage =[UIImage imageWithContentsOfFile:selectTabbarImgFile ];
//                    tabBarButton.selectImageView.image = selectedimage;
//                });
//                
//                
//            });
//            
//        }
        /*
        NSString *imgBaseChange= [[self.itemImageVName objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tabBarButton.itemImageV downloadImageUrl:imgBaseChange cachePath:[AppSetting getXMLFilePath] defaultImageName:nil];
        
        NSString *selectItemImageViewNameBaseChange= [[self.selectItemImageViewName objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tabBarButton.selectImageView downloadImageUrl:selectItemImageViewNameBaseChange cachePath:[AppSetting getXMLFilePath] defaultImageName:nil];
*/
        [tabBarButton.itemImageV setImage:[UIImage imageNamed:itemImDocum[i]]];
        [tabBarButton.selectImageView setImage:[UIImage imageNamed:selectImDocum[i]]];
        
        tabBarButton.nameLabel.text = [self.titleNames objectAtIndex:i];
        
        //MB图片25*25
        tabBarButton.nameLabel.font=[UIFont systemFontOfSize:10.0];
        tabBarButton.nameLabel.frame=CGRectMake(0, tabBarButton.frame.size.height-15,tabBarButton.frame.size.width, 12);
        tabBarButton.itemImageV.frame=CGRectMake((tabBarButton.frame.size.width-25)/2.0, 6, 25, 25);
        tabBarButton.selectImageView.frame=tabBarButton.itemImageV.frame;
        tabBarButton.clickImgView.backgroundColor=[Utils HexColor:0xe74708 Alpha:1.0];
        
        if (i==0)
        {
            tabBarButton.itemImageV.hidden=YES;
            tabBarButton.selectImageView.hidden=NO;
            tabBarButton.nameLabel.textColor=tabBarButtonSelectedTextColor;
            tabBarButton.clickImgView.hidden=NO;
        }
        else
        {
            tabBarButton.itemImageV.hidden=NO;
            tabBarButton.selectImageView.hidden=YES;
            tabBarButton.nameLabel.textColor=tabBarButtonTextColor;
            tabBarButton.clickImgView.hidden=YES;
        }
        [bgImageView addSubview:tabBarButton];
    }
}

- (void)selectedTabBarItem:(UIButton *)sender
{
    CustomButton *clickedbtn = [buttons objectAtIndex:sender.tag - 300];
    if ([clickedbtn.nameLabel.text isEqualToString:@"CREATE"])
    {
        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainUINavigationController *mainUINavigationController = [myStoryboard instantiateViewControllerWithIdentifier:@"MainUINavigationController"];
        [self.navigationController presentViewController:mainUINavigationController animated:YES completion:^{
            
        }];
        
        [self tabButtonClicked:0];
        
        
//         mainUINavigationController.view.frame = CGRectMake(0, self.navigationController.view.frame.size.height, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//        self.navigationController.view.hidden = YES;
//         [self.view addSubview:mainUINavigationController.view];
//        [UIView animateWithDuration:0.4f animations:^{
//                    self.navigationController.view.hidden = NO;
//             mainUINavigationController.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
//        } completion:^(BOOL finished) {
//            
//        }];
       
//        PolyvoreViewController *PolyvoreViewController =
//        [myStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        [self.navigationController pushViewController:PolyvoreViewController animated:YES];
    }
    else
    {
        [self tabButtonClicked:(int)sender.tag - 300];
    }
}

-(void)tabButtonClicked:(int)index
{
    for (int i = 0; i < [self.titleNames count]; i ++)
    {
        CustomButton *btn = [buttons objectAtIndex:i];
        if (index == i)
        {
            [[buttons objectAtIndex:i] setBackgroundColor:tabBarSelectColor];
            
            [[buttons objectAtIndex:i] setSelected:YES];
            btn.selectImageView.hidden=NO;
            btn.itemImageV.hidden=YES;
            btn.nameLabel.textColor=tabBarButtonSelectedTextColor;
            btn.clickImgView.hidden=NO;
            self.selectedIndex = index;
            self.currentSelect = index;
        }
        else
        {
            [[buttons objectAtIndex:i] setSelected:NO];
            
            btn.selectImageView.hidden=YES;
            btn.itemImageV.hidden=NO;
            btn.nameLabel.textColor=tabBarButtonTextColor;
            btn.clickImgView.hidden=YES;
            
            //            [[buttons objectAtIndex:i] setBackgroundColor:color];
            [[buttons objectAtIndex:i] setBackgroundColor:tabBarBackgroundColor];
        }
    }
}
- (void)currentSelectView:(int)currentIndex
{
    self.selectedIndex = currentIndex;
    [self customTabBar];
    [self selectedTabBarItem:[buttons objectAtIndex:currentIndex]];
    [self hiddenTabBar];
}

-(void)gotoDetail
{
    /*
    GetViewControllerFile *getVCF=[GetViewControllerFile getVCFile];
    
    NSDictionary *rootDict = [getVCF getXMLRootFunction:transDic];
    if (rootDict==nil) return;

    tabBarBackgroundColor=[Utils getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor" ] alpha:0.7];
    tabBarSelectColor=[Utils getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_bgcolor_active" ]alpha:0.7];
    tabBarButtonTextColor=[Utils getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_color" ] alpha:1.0];
    tabBarButtonSelectedTextColor=[Utils getcolor:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"] objectForKey:@"_color_active" ] alpha:1.0];
    if (!tabBarBackgroundColor)
    {
        tabBarBackgroundColor=MAIN_NAVNORMALBG;
        tabBarSelectColor=MAIN_NAVACTIVEGB;
    }
    
    //设置互斥锁
    [condition lock];
    modelArray = [[NSArray alloc]initWithArray:[[[rootDict objectForKey:@"template"]objectForKey:@"nav"]objectForKey:@"navitem"]];
    //    NSLog(@"****************tabbar中的 modelarra===%@",modelArray);
    //    //bgcolor颜色参数需要协调
    //    NSString *bgcolor = [NSString stringWithFormat:@"%@",[[[[detailDic objectForKey:@"function"]objectForKey:@"template"]objectForKey:@"nav"]objectForKey:@"_style"]];
    
    [self.titleNames removeAllObjects];
    [self.itemImageVName removeAllObjects];
    [self.selectItemImageViewName removeAllObjects];
    
    NSMutableArray *modelArrayDuty=[[NSMutableArray alloc] initWithCapacity:5];
    [CommMBBusiness judgeDesigner:sns.ldap_uid staffType:STAFF_TYPE_OPENID isDesigner:^(BOOL result){
        
        for (int x=0; x<[modelArray count]; x++)
        {
            BOOL isCreateTabbar=NO;
            NSString *displaystr=[[modelArray objectAtIndex:x] objectForKey:@"_display"];
            //是否需要判断造型权限师
            if (displaystr.length>0 && [displaystr isEqualToString:@"DUTY:造型师"])
            {
                if (result) //是造型师
                {
                    isCreateTabbar=YES;
                }
            }
            else
            {
                isCreateTabbar=YES;
            }
            
            if (isCreateTabbar)
            {
                [self.titleNames addObject:[[modelArray objectAtIndex:x] objectForKey:@"itemname"]];
                [self.itemImageVName addObject:[[modelArray objectAtIndex:x]objectForKey:@"itemicon"]];
                [self.selectItemImageViewName addObject:[[modelArray objectAtIndex:x] objectForKey:@"itemicon_active"]];
                
                [modelArrayDuty addObject:[modelArray objectAtIndex:x]];
            }
        }
        
        //重新创建modelArray
        modelArray=modelArrayDuty;
        
        [getVCF jumpto:self WithArray:modelArray WithDictionary:transDic WithHeadColor:nil WithbjColor:nil];
        [condition unlock];
        [Toast hideToastActivity];
    }];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //为了解决当tabcontroll之上弹出一个窗口并收到内存警告时，垃圾的苹果不会调用当前选择的viewcontroller的viewdidunload事件
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        if ([self isViewLoaded] && self.view.window == nil) {
            [self.selectedViewController.view removeFromSuperview];
            isviewdidunload = true;
        }
    }
    
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        //        self.view = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self
                                                     name:@"changBadge"
                                                   object:nil];
}

-(NSString *)getPortalConfigUrl
{
    return [NSString stringWithFormat:@"%@/api/http/mapp/portalconfig/%@?dev=1",[AppSetting getSNSFaFaDomain],sns.openid];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (firstLoadData)
//    {
//        [self requestXML];
//        firstLoadData=NO;
//    }
    
    //从snslogin已经获取， 本地文件为最新portalVersion， requestXML不用
    if (firstLoadData)
    {
        transDic = [MainTabViewController getPortalConfigLocalData];
        [self  gotoDetail];
        firstLoadData=NO;
    }
    [Toast hideToastActivity];
}
-(void)refreshNavitem
{
    //动态获取配置url
    NSString *urlString=[self getPortalConfigUrl];
    tabbarImgViewRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    tabbarImgViewRequest.delegate=self;
    [tabbarImgViewRequest startAsynchronous];
    
}
+(NSDictionary *)getPortalConfigLocalData
{
    NSDictionary *rstDic=nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];
    
    NSString *filePath=[nameFile stringByAppendingPathComponent:@"navitem"];
    
    if([fileManager fileExistsAtPath:filePath])//判断文件是否存在
    {
        rstDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
    }
    return rstDic;
}

+(void)savePortalConfigLocalData:(NSDictionary *)portaldict
{
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];
    
    NSString *filePath=[nameFile stringByAppendingPathComponent:@"navitem"];
    
    [[NSString stringWithFormat:@"%@",portaldict] writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *)getPortalLocalVersion
{
    NSString *rst=@"";
//    NSDictionary *dict=[self getPortalConfigLocalData];
//    if (dict!=nil && dict[@"basicinfo"] && dict[@"basicinfo"][@"version"]!=nil)
//    {
//        rst=[Utils getSNSString:dict[@"basicinfo"][@"version"]];
//    }
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];
    // 在路径信息中拼接进去text文件信息
    NSString *filePaths=[nameFile stringByAppendingPathComponent:@"config"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filePaths];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePaths])
    {
        if (dict!=nil && dict[@"portalversion"]!=nil)
        {
            rst=dict[@"portalversion"];
        }
    }
    return rst;
}

+(void)savePortalLocalVersion:(NSString *)version
{
    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];
    // 在路径信息中拼接进去text文件信息
    NSString *filePaths=[nameFile stringByAppendingPathComponent:@"config"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:filePaths];
    if (dict==nil)
    {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setObject:version forKey:@"portalversion"];
    [[NSString stringWithFormat:@"%@",dict] writeToFile:filePaths atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//不用
-(void)requestXML
{
    getXML_times++;
    if (self.viewControllers.count == 0)
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
//        NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getXMLFilePath]];
        

        NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];
        //动态获取配置url
        NSString *urlString=[self getPortalConfigUrl];
//        if([fileManager fileExistsAtPath:nameFile])//判断文件是否存在
//        {
        
            NSString *filePath=[nameFile stringByAppendingPathComponent:@"navitem"];
            
            if([fileManager fileExistsAtPath:filePath])//判断文件是否存在
            {
                transDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
                [self  gotoDetail];
                
                //有本地数据，也需要获取最新配置 chengyubing 2014-08-05
                [self loadFrameworkXML];
            }
            else
            {
                //                    //不存在文件navitem
                tabbarImgViewRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
                tabbarImgViewRequest.delegate=self;
                [tabbarImgViewRequest startAsynchronous];
            }
//        }
//        else
//        {
//            tabbarImgViewRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
//            tabbarImgViewRequest.delegate=self;
//            [tabbarImgViewRequest startAsynchronous];
//        }
    }
}

-(void)loadFrameworkXML
{
    NSString *urlString=[self getPortalConfigUrl];
    tabbarImgViewRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    tabbarImgViewRequest.userInfo=[[NSMutableDictionary alloc] init];
    [tabbarImgViewRequest.userInfo setValue:@"0" forKey:@"needRefreshView"];
    tabbarImgViewRequest.delegate=self;
    [tabbarImgViewRequest startAsynchronous];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.userInfo!=nil && [[request.userInfo objectForKey:@"needRefreshView"] isEqualToString:@"0"])
    {
        [Toast hideToastActivity];
        return;
    }
    
    if (getXML_times>=5)
    {
        [[AppDelegate App] logout];
        [Toast hideToastActivity];
        return;
    }
    NSLog(@"获取门户设置第%d次，失败!",getXML_times);
    [self requestXML];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    BOOL needRefreshView=YES;
    if (request.userInfo!=nil && [[request.userInfo objectForKey:@"needRefreshView"] isEqualToString:@"0"])
    {
        needRefreshView=NO;
    }
    
    NSError *error=[request error];
    if (error || [request responseStatusCode]/100!=2)
    {
        if (needRefreshView==NO)
        {
            [Toast hideToastActivity];
            return;
        }
        if (getXML_times>=5)//18516056072
        {
            [[AppDelegate App] logout];
            [Toast hideToastActivity];
            return;
        }
        NSLog(@"获取门户设置第%d次，错误!",getXML_times);
        [self requestXML];
        return;
    }
    getXML_times=0;

    NSString *nameFile=[NSString stringWithFormat:@"%@",[AppSetting getFaFaDocPath]];//getXMLFilePath
    // 在路径信息中拼接进去text文件信息
    NSString *filePaths=[nameFile stringByAppendingPathComponent:@"navitem"];
    NSDictionary *oldDict = [[NSDictionary alloc]initWithContentsOfFile:filePaths];
    
    NSDictionary *xmlDic = [NSDictionary dictionaryWithXMLData:request.responseData];
    transDic = [[NSDictionary alloc]initWithDictionary:xmlDic];
    
    [[NSString stringWithFormat:@"%@",xmlDic] writeToFile:filePaths atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    //判断当前xml和本地xml文件数据是否一致，不一致刷新界面 chengyb 20141119 todo: ...
//    if (needRefreshView)
    if ([transDic isEqualToDictionary:oldDict]==NO)
    {
        [self  gotoDetail];
    }
}

-(void)systemTabbar
{
    
}
@end


//////////////////////////////////////////////////////////////////////////////////////////

#else

//////////////////////////////////////////////////////////////////////////////////////////
#import "CollocationViewController.h"
#import "MeViewController.h"
#import "Utils.h"
#import "Base.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isviewdidunload = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //为了解决当tabcontroll之上弹出一个窗口并收到内存警告时，垃圾的苹果不会调用当前选择的viewcontroller的viewdidunload事件
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        if ([self isViewLoaded] && self.view.window == nil) {
            [self.selectedViewController.view removeFromSuperview];
            isviewdidunload = true;
        }
    }
    
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        //        self.view = nil;
    }
}

- (void)dealloc
{
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.viewControllers.count == 0)
    {
        HomePageViewController *homePageViewController = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
        CommunicateViewController *communicateViewController = [[CommunicateViewController alloc] initWithNibName:@"CommunicateViewController" bundle:nil];
//        CircleHomePageViewController *circleHomePageViewController = [[CircleHomePageViewController alloc] initWithNibName:@"CircleHomePageViewController" bundle:nil];
        //        SnsMainViewController *snsMainViewController = [[SnsMainViewController alloc] initWithNibName:@"SnsMainViewController" bundle:nil];
        //        MeetingMainViewController *meetingMainViewController = [[MeetingMainViewController alloc] initWithNibName:@"MeetingMainViewController" bundle:nil];
//        MicroAppViewController *microAppViewController=[[MicroAppViewController alloc] initWithNibName:@"MicroAppViewController" bundle:nil];
//        UserSettingViewController *userSettingViewController = [[UserSettingViewController alloc] initWithNibName:@"UserSettingViewController" bundle:nil];

        CollocationViewController *collectionViewController = [[CollocationViewController alloc] initWithNibName:@"CollocationViewController" bundle:nil];
        MeViewController *meViewController = [[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil];

        self.viewControllers = @[homePageViewController, collectionViewController, communicateViewController,  meViewController];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.tabBar.translucent=NO;
    }
    self.tabBar.selectedImageTintColor=TOOLBAR_ICON_COLOR;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0)
    {
        if (isviewdidunload)
        {
            int i = self.selectedIndex;
            self.selectedIndex = i==0?1:0;
            self.selectedIndex = i;
        }
        isviewdidunload = false;
    }    
}

@end


#endif

