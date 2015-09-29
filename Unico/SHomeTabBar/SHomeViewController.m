//
//  SHomeViewController.m
//  Wefafa
//
//  Created by unico_0 on 6/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SHomeViewController.h"
#import "SMainViewController.h"
#import "SDiscoveryViewController.h"
#import "SChatListController.h"
#import "SMineViewController.h"
#import "SDiscoveryHomeViewController.h"
#import "SHomeNavigationViewController.h"
#import "SHomeAgilityViewController.h"
#import "SUtilityTool.h"
#import "AppDelegate.h"

#import "WeFaFaGet.h"
#import "STabMineViewController.h"
#import "SChatSocket.h"

#import "SUploadColllocationControlCenter.h"
#import "SHomeAgilityViewController.h"

#import "PraiseBoxView.h"
#import "ShoppIngBagShowButton.h"
#import "HttpRequest.h"
#import "ShareRelated.h"
#import "Utils.h"

#import "SMenuBottomModel.h"
#import "UIButton+WebCache.h"
#import "JSWebAgilityNavigationViewController.h"
#import "MyShoppingTrollyViewController.h"
#import "SSearchViewController.h"

BOOL g_socialStatus = NO; //是否处于社交状态，当主页选择相机按钮后，App处于社交状态，此后显示的所有搭配详情都没有购物功能；反之，显示的搭配详情都有购物功能。


typedef enum : NSUInteger {
    tabbarShow = 0,
    tabbarHidden,
} TabbarStatus;

@interface SHomeViewController ()<UITabBarControllerDelegate>
{
    CGFloat _savaLocation_Y;
    UITabBarItem *_messageItem;
}

@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;

@property (nonatomic, strong) NSArray *jumpControllers;

@property (nonatomic, assign) TabbarStatus tabbarStatus;
//底部菜单数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static SHomeViewController *g_SHomeViewController = nil;

@implementation SHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        g_SHomeViewController = self;
        
    }
    return self;
}

+(SHomeViewController*) instance {
    return g_SHomeViewController;
}

- (void)configData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
        for (NSMutableArray *array in MENUBOTTOM_ARRAY) {
            for (NSDictionary *dictionary in array) {
                SMenuBottomModel *model = [[SMenuBottomModel alloc] initWithDictionary:dictionary];
                [_dataArray addObject:model];
            }
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.delegate = self;
    [self configData];
    [self initSubViews];
    [self setupNavbar];
    // 0 首页，1 发现
    if ([LAUNCH_DEFAULT_PAGE intValue]>0) {
        [self setSelectedIndex:[LAUNCH_DEFAULT_PAGE intValue]];
        LAUNCH_DEFAULT_PAGE = @"0";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMsg) name:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemote)  name:MBFUN_REMOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut) name:@"noti_loginOut" object:nil];
}

- (void)setupNavbar{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

#pragma mark - 配置navigationbar
- (void)setLayoutModel:(SMenuBottomModel *)layoutModel{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    NSMutableArray *leftItemArray = [NSMutableArray array];
    [leftItemArray addObject:negativeSpacer];
    for (NSNumber *number in layoutModel.button_config.left) {
        UIButton *leftButton = [self createNavigationBarButtonWithType:number.intValue];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        [leftItemArray addObject:leftItem];
    }
    self.navigationItem.leftBarButtonItems = leftItemArray;
    
    negativeSpacer.width = -5;
    NSMutableArray *rightItemArray = [NSMutableArray array];
    [rightItemArray addObject:negativeSpacer];
    for (NSNumber *number in layoutModel.button_config.right) {
        UIButton *rightButton = [self createNavigationBarButtonWithType:number.intValue];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        [rightItemArray addObject:rightItem];
    }
    self.navigationItem.rightBarButtonItems = rightItemArray;
    
    [self createNavigationTitleViewWithModel:layoutModel];
}

- (void)openMenuAction:(UIButton *)sender
{
    [[SUtilityTool shared] showOrHideLeftSideView];
}
-(void)shareButtonClick:(UIButton *)sender
{
    //点击分享按钮
    ShareData *shareData = [[ShareData alloc]init];
    
    shareData.title =@"有范";
    
    SMenuBottomModel *menuBottom=_dataArray[self.selectedIndex];


    switch ([menuBottom.type intValue]) {
        case 1://主页
        {
            
        }
            break;
        case 2://发现
        {
            
        }
            break;
        case 3://社交
        {
            
        }
            break;
        case 4://消息
        {
            
        }
            break;
        case 5://个人中心
        {
            NSString *shareUrl=[NSString stringWithFormat:@"%@",U_SHARE_USER_URL];
    
            NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
            
            NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
            NSString *noLastUrlStr=detailUrlStr;
            if ([lastStr isEqualToString:@"?"]) {
                noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
            }
            shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
            NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=user_center&userID=%@", sns.ldap_uid];
            NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
            
            shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
        }
            break;
        default:
            break;
    }

    shareData.descriptionStr = @"";
    
    //    shareData.image = [Utils reSizeImage:titleShareImgView.image toSize:CGSizeMake(57,57)];
    ShareRelated *share = [ShareRelated sharedShareRelated];
    [share showInTarget:self withData:shareData];

}
- (void)onCart{
    if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *vc1 = [[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}

- (UIButton *)createNavigationBarButtonWithType:(int)type{
    UIButton *button = nil;
    switch (type) {
        case 1:
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(openMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2:
            button = self.shoppingBagButton;
            break;
        case 3:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom] ;
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/icon_navigation_search"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 5:
        {
            button =[UIButton buttonWithType:UIButtonTypeCustom] ;
            [button setFrame:CGRectMake(0, 0, 33, 33)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"Unico/community_camera"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    return button;
}

- (ShoppIngBagShowButton *)shoppingBagButton{
    if (!_shoppingBagButton) {
        _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
        [_shoppingBagButton addTarget:self action:@selector(onCart) forControlEvents:UIControlEventTouchUpInside];
        [self requestCarCount];
    }
    return _shoppingBagButton;
}

- (void)searchButtonClick{
    SSearchViewController *controller = [SSearchViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cameraButtonClick{
    [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
        NSInteger total = [dict[@"total"] integerValue];
        if (total==0) {
            return ;
        }
        int count = [dict[@"results"][0][@"count"] intValue];
        if (count!=0) {
            self.shoppingBagButton.titleLabel.hidden=NO;
            [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
        }else
        {
            self.shoppingBagButton.titleLabel.hidden=YES;
            [self.shoppingBagButton setTitle:@"" forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)createNavigationTitleViewWithModel:(SMenuBottomModel*)layoutModel{
    if (layoutModel.top_img.length > 0) {
        [self setTitleViewUrl:layoutModel.top_img];
    }else{
        self.navigationTitleView = [self createNavigationCenterView];
    }
}

- (void)setNavigationTitleView:(UIView *)navigationTitleView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (UI_SCREEN_WIDTH - MAX(self.navigationItem.leftBarButtonItems.count, self.navigationItem.rightBarButtonItems.count) * 88), 30 * 0.9)];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:navigationTitleView];
    self.navigationItem.titleView = titleView;
}

- (void)setTitleViewUrl:(NSString *)titleViewUrl{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (UI_SCREEN_WIDTH - MAX(self.navigationItem.leftBarButtonItems.count, self.navigationItem.rightBarButtonItems.count) * 88), 30*0.9)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:titleViewUrl]];
    [self setNavigationTitleView:imageView];
}

- (UIView *)createNavigationCenterView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-5, 0, (UI_SCREEN_WIDTH - MAX(self.navigationItem.leftBarButtonItems.count, self.navigationItem.rightBarButtonItems.count) * 88), 30*0.9)];
    titleLabel.text=@"有范";
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

#pragma mark - 

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //   self.navigationController.navigationBarHidden = YES;
    [self requestCarCount];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //   self.navigationController.navigationBarHidden = YES;
}

- (void)initSubViews{
    self.tabBar.translucent = YES;
    self.tabBar.alpha = 1;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/main_tabbar_bg"]];
    imageView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 49);
    imageView.alpha = 0.4;
    imageView.tag=-1;
    [self.tabBar insertSubview:imageView atIndex:0];
    self.tabBar.selectedImageTintColor = COLOR_C6;
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName: FONT_t7,
                                                       NSForegroundColorAttributeName: COLOR_C6} forState:UIControlStateNormal];
//
    SHomeAgilityViewController *homeViewController = [SHomeAgilityViewController new];
    homeViewController.requestActionName = @"getHomeLayoutInfoV2";
    
    SDiscoveryHomeViewController *discoverController = [SDiscoveryHomeViewController new];
    discoverController.requestActionName = @"getFindHomeLayoutInfoV3";
    
    SMainViewController *mainController = [SMainViewController new];
    
    SChatListController *messageController = [SChatListController new];
    
    STabMineViewController *mineController = [[STabMineViewController alloc]
    initWithNibName:@"SMineViewController" bundle:nil];
    
    mineController.navigationItem.hidesBackButton = YES;
    mineController.person_id = sns.ldap_uid;
    
    //config是否有配置
    bool isNew = false;
    
    NSMutableArray *dataViewArray = [[NSMutableArray alloc]init];
    CGFloat button_Width = UI_SCREEN_WIDTH/ _dataArray.count;
    for (int i=0; i<_dataArray.count; i++) {
        isNew = true;
        SMenuBottomModel *menuBottom=_dataArray[i];
        UITabBarItem *item = self.tabBar.items[i];
        UIViewController *controller = nil;
        if (menuBottom.is_web.boolValue){
            controller = [[JSWebAgilityNavigationViewController alloc]initWithUrl:menuBottom.web_url];
        }else{
            switch ([menuBottom.type intValue]) {
                case 1://主页
                    controller = homeViewController;
                    break;
                case 2://发现
                    controller = discoverController;
                    break;
                case 3://社交
                    _messageItem = item;
                    controller = mainController;
                    break;
                case 4://消息
                    controller = messageController;
                    break;
                case 5://个人中心
                    mineController.isHiddenBackItem=YES;
                    controller = mineController;
                    break;
                default:
                    break;
            }
        }
        if (!controller) continue;
        [controller setValue:menuBottom forKey:@"layoutModel"];
        [dataViewArray addObject:controller];
        UIImageView *imageItemView = [[UIImageView alloc] initWithFrame:CGRectMake(i*button_Width, (imageView.frame.size.height-[menuBottom.height integerValue])/2, button_Width, [menuBottom.height integerValue])];
        
        if(i==0)
            [imageItemView sd_setImageWithURL:[NSURL URLWithString:menuBottom.selected_img]
             placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        else
            [imageItemView sd_setImageWithURL:[NSURL URLWithString:menuBottom.normall_img]
             placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        
        [imageItemView setContentMode:UIViewContentModeScaleAspectFit];
        [self.tabBar addSubview:imageItemView];
        imageItemView.tag=i+100;
    }
    
    if(!isNew){
        [dataViewArray addObject:homeViewController];
        [dataViewArray addObject:discoverController];
        [dataViewArray addObject:mainController];
        [dataViewArray addObject:messageController];
        [dataViewArray addObject:mineController];
        
        self.jumpControllers = [dataViewArray copy];
        self.viewControllers =  [dataViewArray copy];
        
        
        UITabBarItem *item = self.tabBar.items[0];
        item.tag = 0;
        item.title = @"主页";
        item.selectedImage = [self noneTinColorImageName:@"Unico/main_home_pressed"];
        item.image = [self noneTinColorImageName:@"Unico/main_home_normal"];
        
        item = self.tabBar.items[1];
        item.tag = 1;
        item.title = @"发现";
        item.selectedImage = [self noneTinColorImageName:@"Unico/main_browse_pressed"];
        item.image = [self noneTinColorImageName:@"Unico/main_browse_normal"];
    
        item = self.tabBar.items[2];
        item.tag = 2;
        item.title = @"社区";
        item.selectedImage = [self noneTinColorImageName:@"Unico/social_pressed"];
        item.image = [self noneTinColorImageName:@"Unico/social_normal"];
    
        item = self.tabBar.items[3];
        _messageItem = item;
        item.tag = 3;
        item.title = @"消息";
        item.selectedImage = [self noneTinColorImageName:@"Unico/main_chat_pressed"];
        item.image = [self noneTinColorImageName:@"Unico/main_chat_normal"];
    
        item = self.tabBar.items[4];
        item.tag = 4;
        item.title = @"我的";
        item.selectedImage = [self noneTinColorImageName:@"Unico/main_me_pressed"];
        item.image = [self noneTinColorImageName:@"Unico/main_me_normal"];
    }else{
        self.jumpControllers = [dataViewArray copy];
        self.viewControllers =  [dataViewArray copy];
        for (int i=0; i< MIN(_dataArray.count, dataViewArray.count); i++) {
            
            UITabBarItem *item = self.tabBar.items[i];
            item.tag =i;
        }
    }
}

// 不渲染图片
- (UIImage*)noneTinColorImageName:(NSString*)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma mark - tab bar controller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    g_socialStatus = YES;
//    if (viewController.tabBarItem.tag == 2)
//    {
//        
//    }
//    else
//    {
//        g_socialStatus = NO;
//    }
    [self requestCarCount];
    self.navigationController.navigationBar.alpha = 1;
    if (viewController.tabBarItem.tag == self.selectedIndex) {
        //      if (viewController.tabBarItem.tag == 2) {
        //         [self showTabbarAndAnimation:NO];
        //         //[[SUtilityTool shared] showCamera:nil];
        //          [[SUploadColllocationControlCenter shareSUploadColllocationControlCenter] showUploadColllocationHomeViewWithAnimated:YES];
        //
        //         self.selectedIndex = 2;
        //         return NO;
        //      }
        if ([viewController respondsToSelector:@selector(scrollToTop)]) {
            [viewController performSelector:@selector(scrollToTop)];
        }
    }
    if (viewController.tabBarItem.tag == 4 || viewController.tabBarItem.tag == 3) {
        if (![BaseViewController pushLoginViewController]) {
            return NO;
        }else{
            if (viewController.tabBarItem.tag == 4) {
                UIViewController *controller = self.jumpControllers[4];
                [controller setValue:sns.ldap_uid forKey:@"person_id"];
            }
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController{
    if([_dataArray count]<5)return;
    for (id obj in self.tabBar.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* imageView = (UIImageView*)obj;
            if(imageView.tag<100)continue;
            
            SMenuBottomModel *menuBottom=_dataArray[imageView.tag-100];
            imageView.image=nil;
            if(imageView.tag-100==viewController.tabBarController.selectedIndex){
                [imageView sd_setImageWithURL:[NSURL URLWithString:menuBottom.selected_img]
                 placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:menuBottom.normall_img]
                 placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            }
        }
    }
}
- (void)setMessageBadge:(NSString *)messageBadge{
    _messageBadge = [messageBadge copy];
    _messageItem.badgeValue = messageBadge;
    if ([messageBadge isEqualToString:@"0"] || [messageBadge intValue] < 0) {
        _messageItem.badgeValue = nil;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex == 4) {
        if (![BaseViewController pushLoginViewController]) {
            return;
        }else{
            
            
            UIViewController *controller = self.jumpControllers[4];
            [controller setValue:sns.ldap_uid forKey:@"person_id"];
        }
    }
    
    
    for (id obj in self.tabBar.subviews) {
        if([_dataArray count]<5)break;
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView* imageView = (UIImageView*)obj;
            if(imageView.tag<100)continue;
            SMenuBottomModel *menuBottom=_dataArray[imageView.tag-100];
            
            if([menuBottom.type intValue]==1){
                [imageView sd_setImageWithURL:[NSURL URLWithString:menuBottom.selected_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            }else{
                [imageView sd_setImageWithURL:[NSURL URLWithString:menuBottom.normall_img]
                 placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
            }
        }
        
    }

    
    [super setSelectedIndex:selectedIndex];
}

- (void)onMsg {
    self.messageBadge = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
}

- (void)onRemote {
    self.messageBadge = [NSString stringWithFormat:@"%d", UNREAD_ALL_NUMBER];
}

- (void)noti_loginOut {
    self.messageBadge = @"0";
}

#pragma mark - tabbar隐藏控制速度
#define speed 20
- (void)setControlScrollView:(UIScrollView *)controlScrollView{
    if (controlScrollView.contentSize.height + controlScrollView.contentInset.top + controlScrollView.contentInset.bottom < controlScrollView.height - 49){
        [self showTabbarAndAnimation:YES];
        return;
    }
    if (controlScrollView.contentOffset.y <= - controlScrollView.contentInset.top) {
        [self showTabbarAndAnimation:YES];
        return;
    }else if (controlScrollView.contentOffset.y >= controlScrollView.contentSize.height - UI_SCREEN_HEIGHT){
        [self showTabbarAndAnimation:NO];
        return;
    }
    if (controlScrollView.contentOffset.y - _savaLocation_Y > speed) {
        [self showTabbarAndAnimation:NO];
    }else if(controlScrollView.contentOffset.y <= - controlScrollView.contentInset.top || controlScrollView.contentOffset.y - _savaLocation_Y < -speed){
        [self showTabbarAndAnimation:YES];
    }
    _savaLocation_Y = controlScrollView.contentOffset.y;
}

- (void)setScrollViewBegin:(UIScrollView *)scrollViewBegin{
    _savaLocation_Y = scrollViewBegin.contentOffset.y;
}

- (void)setIsShowTabbar:(NSNumber *)isShowTabbar{
    [self showTabbarAndAnimation:[isShowTabbar boolValue]];
}

- (void)showTabbarAndAnimation:(BOOL)isShow{
    if (!isShow == _tabbarStatus) {
        return;
    }
    _tabbarStatus = !isShow;
    UIViewController *controller  = self.jumpControllers[self.selectedIndex];
    CGRect frame = controller.navigationController.navigationBar.frame;
    CGRect rect = self.tabBar.frame;
    if (isShow) {
        frame.origin.y = 20;
        rect.origin.y = UI_SCREEN_HEIGHT - 49;
    }else{
        frame.origin.y = -44;
        rect.origin.y = UI_SCREEN_HEIGHT;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
#warning 打开导航条隐藏属性
        //      controller.navigationController.navigationBar.frame = frame;
        self.tabBar.frame = rect;
    }];
}

@end
