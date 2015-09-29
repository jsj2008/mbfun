//
//  SDiscoveryViewController.m
//  Wefafa
//
//  Created by unico on 15/5/17.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "SDiscoveryViewController.h"
#import "SItemListViewController.h"
#import "SUtilityTool.h"
#import "XLCycleScrollView.h"
#import "HttpRequest.h"
#import "DesignerModel.h"
#import "BrandListCellModel.h"
#import "UIImageView+AFNetworking.h"
#import "BrandListViewController.h"
#import "SItemViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "SBrandSotryViewController.h"
#import "SCollocationDetailViewController.h"
#import "MBBrandViewController.h"
#import "SDesignerViewController.h"
#import "SDataCache.h"
#import "LNGood.H"
#import "SStarStoreViewController.h"
#import "SCollocationCollectionViewCell.h"
#import "SBrandViewController.h"
#import "SBestCollocationViewController.h"
#import "SFashionInfomationViewController.h"
#import "STopicViewController.h"
#import "STopicDetailViewController.h"
#import "SHeaderTitleView.h"
#import "SHeaderTitleModel.h"
#import "SMineViewController.h"
#import "WeFaFaGet.h"
#import "MyShoppingTrollyViewController.h"
#import "SSearchViewController.h"
#import "LoginViewController.h"
#import "ShoppIngBagShowButton.h"
#import "SActivityListViewController.h"
#import "SSearchResultViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "SChatSocket.h"

#import "SCollocationDetailNoneShopController.h"


#define AOTO(par) UI_SCREEN_WIDTH / 375 * par

@interface SDiscoveryViewController()<UISearchBarDelegate, XLCycleScrollViewDatasource,XLCycleScrollViewDelegate, SHeaderTitleCollectionViewDelegate, UIScrollViewDelegate>{
    XLCycleScrollView *idsScroll;
    NSArray *idsArray;
    NSMutableArray * recommendBrandArr;//推荐品牌数据源
    NSMutableArray * recommendDesignerArr;//推荐设计师数据源
    NSArray *dpData;
    //选择的按钮
    UIButton *p_selectButton;
    UIImageView *p_selectView_y;
    
    UIImageView *loadingBg;
    BOOL isScrollLoading;
    
    UIImageView *loadingSnapView; // 临时截屏，后面用数据缓存
    NSArray *activityArray;
    NSArray *bannerArray;
    NSArray *yourFanArray;
    CGFloat _titleFrameOrigin_Y;
    UIImageView *_searchView;
    
    NSMutableArray * categaryArray;
    NSString *_selectedTitleString;
    UIImageView *headerImageView;
}
@property (nonatomic, strong) UIView *badgeView;

@property (nonatomic, strong) SHeaderTitleView *titleView;
@property (nonatomic, strong) ShoppIngBagShowButton *shoppingBagButton;
@end

@implementation SDiscoveryViewController
#define MORE_DESIGNER  100
#define MORE_BRAND     101
#define MORE_ITEM      102
#define MORE_FAN       103
#define MORE_DP        104

#define STAR_SHOP         110
#define BEST_BRAND        111
#define BEST_DP           112
#define FASHION_INFO      113
#define ACTIVITY_NOW      114



#define BANNER_TYPE     (@"banner")
#define FAN_TYPE        (@"pos_1")
#define DP_TYPE         (@"pos_2")
#define DESIGNER_TYPE   (@"pos_3")
#define BRAND_TYPE      (@"pos_4")
#define ITEM_TYPE       (@"pos_5")
-(void)initnotificationcenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMsg:) name:@"MBFUN_CHAT_MESSAGE_SOCKET" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemote)  name:MBFUN_REMOTE object:nil];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti_loginOut) name:@"noti_loginOut" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImgView:) name:@"changeHeadImgView" object:nil];
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 加载图
    loadingBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1044/2)];//[SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/select_bg" rect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1044/2)];
    [self.view addSubview:loadingBg];
    
//    loadingSnapView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"temp_cache.jpg" rect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
//    [self.view addSubview:loadingSnapView];
    
    //idsArray = @[@"Unico/banner3",@"Unico/banner3",@"Unico/banner3",@"Unico/banner3"];
    //显示navigator
    
    [self initSearchBarViewSet];
//    [self requestCarCount];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SSearchViewController *controller = [[SSearchViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [idsScroll setAutoScroll:YES];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];

    if (UNREAD_ALL_NUMBER > 0) {
        _badgeView.hidden = NO;
    }else {
        _badgeView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavbar];
    [self requestCarCount];
}
- (void)noti_loginComplete
{
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path] placeholderImage:[UIImage imageNamed:@"Unico/default_header_image"]];
}

- (void)noti_loginOut
{
    [[SDataCache sharedInstance] logout];

    [headerImageView setImage:[UIImage imageNamed:@"Unico/default_header_image"]];
    

}

- (void)onMsg:(NSNotification*)notification {

    if (UNREAD_ALL_NUMBER > 0) {
        _badgeView.hidden = NO;
    }else {
        _badgeView.hidden = YES;
    }
}

- (void)onRemote {

    if (UNREAD_ALL_NUMBER > 0) {
        _badgeView.hidden = NO;
    }else {
        _badgeView.hidden = YES;
    }
}

-(void)initSearchBarViewSet
{
    
    // 顶部搜索 TODO：现在是整个图片。
    // discover_top_search_bar
//    UIImageView *searchView = [[UIImageView alloc] init];//initWithImage:[UIImage imageNamed:@"Unico/discover_ztop_search_bar"]];
//    searchView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
//    searchView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64)];
    _searchView = backView;
    backView.image = [UIImage imageNamed:@"Unico/common_navi_mixblack.png"];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
   
    backView.userInteractionEnabled = YES;
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(AUTO_SIZE(49), 20, UI_SCREEN_WIDTH - AUTO_SIZE(49) * 2, 44)];//CGRectMake(54, 20, UI_SCREEN_WIDTH - 54 * 2, 44)];
    search.layer.cornerRadius = 3;
    search.layer.masksToBounds = YES;
    search.translucent = YES;
    search.searchBarStyle = UISearchBarStyleMinimal;//UISearchBarStyleDefault;
    search.delegate = self;
    [search setPlaceholder:@"搜索:用户、品牌、标签"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(search.frame.origin.x + 8, search.frame.origin.y + 8,  search.width - 16, 28)];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor whiteColor];
    [backView addSubview:view];
    [backView addSubview:search];
    
    UIImageView *menuImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 27, 30, 30)];
    [menuImg setImage:[UIImage imageNamed:@"icon_menu@2x.png"]];
    [menuImg setUserInteractionEnabled:YES];
    [backView addSubview:menuImg];
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenu)];
    [menuImg addGestureRecognizer:headerTap];
    
//    headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 27, 30, 30)];
//    headerImageView.layer.cornerRadius = 15;
//    headerImageView.layer.masksToBounds = YES;
//    headerImageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBack)];
//    [headerImageView addGestureRecognizer:headerTap];
//    [headerImageView sd_setImageWithURL:[NSURL URLWithString:sns.myStaffCard.photo_path_big] placeholderImage:[UIImage imageNamed:@"Unico/common_navi_portarit.png"]];
//    [backView addSubview:headerImageView];
    
    _badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    _badgeView.center = CGPointMake( headerImageView.centerX + 22/2, headerImageView.centerY - 22/2);
    _badgeView.backgroundColor = [Utils HexColor:0xfb5b4e Alpha:1];//COLOR_C12;
    _badgeView.layer.cornerRadius = _badgeView.width/2;
    _badgeView.layer.masksToBounds = YES;
    [backView addSubview:_badgeView];
    
    _shoppingBagButton = [[ShoppIngBagShowButton alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
    [_shoppingBagButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_shoppingBagButton setImage:[UIImage imageNamed:@"Unico/cart"] forState:UIControlStateNormal];
    [backView addSubview:_shoppingBagButton];
    
    [_shoppingBagButton addTarget:self action:@selector(shoppingbag) forControlEvents:UIControlEventTouchUpInside];

}

- (void)onBack {
    [self.tabBarController setSelectedIndex:4];
//    [self popAnimated:YES];
}

- (void)tapMenu
{
    [[SUtilityTool shared] showOrHideLeftSideView];
}

- (void)shoppingbag {
     if ([BaseViewController pushLoginViewController]) {
        MyShoppingTrollyViewController *controller = [[MyShoppingTrollyViewController alloc] initWithNibName:@"MyShoppingTrollyViewController" bundle:nil];
        [self pushController:controller animated:YES];
     }
}

-(void) getData{
    //[self loadData];
    self.goodsList = nil;
    [self getDiscoveryInfo];
    [self getCollocationList:NO tabString:nil];

}

- (void)requestCarCount{
    if(!sns.ldap_uid){
        return;
    }
    [HttpRequest orderGetRequestPath:nil methodName:@"ShoppingCartStaticFilter" params:@{@"UserId":sns.ldap_uid} success:^(NSDictionary *dict) {
//        [self.shoppingBagButton setTitle:[Utils getSNSInteger:dict[@"results"][0][@"count"]] forState:UIControlStateNormal];
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

- (void)scrollToTop{
    [self.collectionView setContentOffset:CGPointMake(0, - self.collectionView.contentInset.top) animated:YES];
}

-(void)getDiscoveryInfo{
    [SDATACACHE_INSTANCE getFindHomeLayoutInfo:^(NSArray *data) {
        _listDict = (NSDictionary*)data;
        
        [loadingBg removeFromSuperview];
        loadingBg = nil;
         [self dealData];
    }];
}
-(void)dealData{
    if (!_listDict || !self.goodsList || self.goodsList.count <= 0) {
        return;
    }else{
        [self layoutUI];
    }
}

- (void)requestAddData{
    _selectedTitleString = _selectedTitleString? _selectedTitleString: @"";
    LNGood *goods = [self.goodsList firstObject];
    NSInteger listCount = self.goodsList.count - (goods.show_type.boolValue? 1: 0);
    NSInteger pageIndex = (listCount+ 9)/ 10;
    NSDictionary *data = @{
                           @"m":@"Home",
                           @"a":@"getCollocationListForMain",
                           @"page":@(pageIndex),
                           @"tabstr": _selectedTitleString
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        NSArray *array = object[@"data"];
        [self.collectionView footerEndRefreshing];
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:array.count];
        }
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
            self.goodsList = self.goodsList;
        }];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView footerEndRefreshing];
    }];
}

-(void) getCollocationList:(BOOL)isScrollUpdate tabString:(NSString*)tabString{
    _selectedTitleString = tabString;
    [[SDataCache sharedInstance] getCollocationListForMain:0 tabString:tabString complete:^(NSArray *data) {
        //转换成LNGood的数据模型
        if (!self.goodsList) {
            self.goodsList = [NSMutableArray arrayWithCapacity:data.count];
        }
        [self.goodsList removeAllObjects];
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LNGood *goods = [LNGood goodWithDict:obj];
            [self.goodsList addObject:goods];
        }];
        if (isScrollUpdate) {
            [self.collectionView reloadData];
        }else{
            [self dealCollocationData];
        }
//        UIEdgeInsets edgeInset = self.collectionView.contentInset;
//        if ((self.collectionView.frame.size.height + self.headerViewHeight - self.collectionView.contentSize.height) > 0) {
//            edgeInset.bottom = self.collectionView.frame.size.height + self.headerViewHeight - self.collectionView.contentSize.height;
//        }else{
//            edgeInset.bottom = 0;
//        }
//        self.collectionView.contentInset = edgeInset;
    }];
}
-(void)dealCollocationData{
    if (!_listDict || !self.goodsList || self.goodsList.count <= 0) {
        return;
    }else{
        [self layoutUI];
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self setupNavbar];
//}

// 在willAppear中处理，会有很多问题，所以用下面的方式处理
// 比如navbar在手势滑动时候消失等。

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)dealloc{
    // FIXED: 在此释放
    idsScroll.delegate = nil;
    idsScroll.datasource = nil;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)clickBack:(id)selector{
    NSLog(@"返回");
    

    [self popAnimated:YES];
}

-(void)clickShare:(id)selector{
    NSLog(@"分享");
}

- (void)setupNavbar {
    [super setupNavbar];
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationController setNavigationBarHidden:YES];
    

    
}
//事件
-(void)onMoreGood:(id)selector{
    SItemViewController * vc = [[SItemViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//更多品牌
-(void)moreBrandClicked:(UITapGestureRecognizer*)gest
{
//    BrandListViewController * brandListVC = [[BrandListViewController alloc]init];
//    [self.navigationController pushViewController:brandListVC animated:YES];
    SBrandShowListControllerViewController *Vc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
    [self.navigationController pushViewController:Vc animated:YES];

}
//更多设计师
-(void)designerMoreClicked:(UITapGestureRecognizer*)gest
{

}
//查看设计师详情
-(void)designDetailClicked:(UITapGestureRecognizer*)gest
{
    UIView * view = [gest view];
    NSInteger index = view.tag -1000;
    DesignerModel * model = (DesignerModel*)recommendDesignerArr[index] ;

    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = model.userId;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void) updateHeaderView:(UICollectionReusableView*) headerView{
    float offset = 0;
    UIView *tempUIView;
    UILabel *tempLabel;
    NSString *tempStr;
    UIImageView *tempView2;
    CGRect tempRect;
    NSArray *tempAry;
    UIImageView *tempView;
    float bgViewOffset = 0;
    NSArray *dataArray;
    UIScrollView *tempScrollView ;
    float tempFloat;
    int tempIndex = 0;
    float tempY = 0;
    float tempX = 0;
    float widthFloat = 0;
    float heightFloat = 0;
    UIButton *tempBtn;
    NSArray *tempAryName ;
//    UIImageView *iconView;
    CGSize labelSize ;
    
    //背景图
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1044/2)];//[SUTIL createUIImageViewByStyle:@"Unico/select_bg" rect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1044/2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    
//    bgViewOffset += 64;
    
    
       if (self.listDict[BANNER_TYPE]) {
        if (self.listDict[BANNER_TYPE][@"1001"]) {
            idsArray = (NSArray*)self.listDict[BANNER_TYPE][@"1001"];

            if (idsArray.count > 0) {
                widthFloat = [idsArray[0][@"img_width"]floatValue];
                heightFloat = [idsArray[0][@"img_height"]floatValue];
                tempFloat = (UI_SCREEN_WIDTH/(widthFloat/2)*(heightFloat/2));
//                [idsScroll setHeight:tempFloat];
                
                if (!idsScroll) {
                    idsScroll = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, bgViewOffset, UI_SCREEN_WIDTH, tempFloat)];
                    [idsScroll setDataource:self];
                    [idsScroll setDelegate:self];
                }
                [idsScroll setShouldHandleTap:YES];
                CGRect frame = idsScroll.pageControl.frame;
                frame.origin.y = tempFloat - 30;
                idsScroll.pageControl.frame = frame;
            }else{
                if (!idsScroll) {
                    idsScroll = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, bgViewOffset, UI_SCREEN_WIDTH, 344/2)];
                    [idsScroll setDataource:self];
                    [idsScroll setDelegate:self];
                }
            }
            [idsScroll reloadData];
            [idsScroll setAutoScroll:YES];
        }
        bgViewOffset += idsScroll.frame.size.height;
        
        
        float tempFloat = (UI_SCREEN_WIDTH - 44 - 44*5)/4;
        tempAry = @[@"Unico/star_shop",@"Unico/brand",@"Unico/collocation",@"Unico/consulting",@"Unico/activity"];
        tempAryName = @[@"时尚达人",@"推荐品牌",@"最+搭配",@"时尚资讯",@"当前活动"];
        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempAry[0] fontStyle:[UIFont systemFontOfSize:12]];
        
        for (int i = 0; i<[tempAry count]; i++) {
            tempBtn = [SUTILITY_TOOL_INSTANCE createButtonByImage:tempAry[i] target:self action:@selector(onSelectInfo:) rect:CGRectMake(44/2+i*(tempBtn.frame.size.width + tempFloat), bgViewOffset +28/2,88/2, 88/2)];
            tempBtn.adjustsImageWhenHighlighted = NO;
            tempBtn.tag = BASE_BTN_TAG + STAR_SHOP + i;
            [bgView addSubview:tempBtn];
            
            tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:tempAryName[i] fontStyle:[UIFont systemFontOfSize:12] color:COLOR_C2 rect:CGRectMake(tempBtn.frame.origin.x, tempBtn.frame.origin.y+tempBtn.frame.size.height+14/2, 0, labelSize.height) isFitWidth:YES isAlignLeft:YES];
            //和图片对齐，居中
            [tempLabel setOrigin:CGPointMake(tempBtn.frame.origin.x - (tempLabel.frame.size.width - tempBtn.frame.size.width)/2,tempLabel.frame.origin.y)];
            
            [bgView addSubview:tempLabel];
        }
        //y坐标偏移量
        bgViewOffset += 28/2 + 88/2+ 14/2+tempLabel.frame.size.height;
        //bgViewOffset += 36/2;
           tempView.userInteractionEnabled = YES;
        //联合推出系列，推荐活动
        if (self.listDict[BANNER_TYPE][@"1002"]) {
            activityArray = (NSArray*)self.listDict[BANNER_TYPE][@"1002"];
            //标题
            tempStr = @"推荐活动";
            tempUIView = [[UIView alloc]init];//[SUTILITY_TOOL_INSTANCE createUILabelDottedLine:tempStr height:66/2 color:[UIColor whiteColor] fontStyle:[UIFont systemFontOfSize:14] interval:5];
            [tempUIView setOrigin:CGPointMake(tempUIView.frame.origin.x, bgViewOffset)];
            tempUIView.backgroundColor = [UIColor clearColor];
            [bgView addSubview:tempUIView];
            
            bgViewOffset += tempUIView.frame.size.height + 22;
            tempScrollView = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, bgViewOffset, UI_SCREEN_WIDTH, 300/2)];
            tempScrollView.backgroundColor = [UIColor clearColor];
            [bgView addSubview:tempScrollView];
            for (int i=0; i<[activityArray count]; i++) {
                tempRect = CGRectMake(i*(334/2+14/2), 0, 334/2, 300/2);
                tempStr = activityArray[i][@"img"];
                widthFloat = [activityArray[i][@"img_width"]floatValue];
                heightFloat = [activityArray[i][@"img_height"]floatValue];
                tempView = [UIImageView new];
                [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
                tempView.frame = tempRect;
                tempView.tag = BASE_BTN_TAG + i;
                [SUTIL addViewAction:tempView target:self action:@selector(onSelectActivity:)];
                [tempScrollView addSubview:tempView];
            }
            tempScrollView.contentInset = UIEdgeInsetsMake(0, 10*SCALE_UI_SCREEN, 0, 10*SCALE_UI_SCREEN);
            [tempScrollView setContentSize:CGSizeMake(tempView.frame.origin.x + tempView.width, 300/2)];

            bgViewOffset += tempView.frame.size.height;
            bgViewOffset += 16/2;
            /*
            tempAry = @[@"Unico/point1",@"Unico/point2",@"Unico/point2"];
            float tempfloat = 0;
            for (int i = 0; i<[tempAry count]; i++) {
                if (i == 0) {
                    tempfloat = -8/2/2;
                }else if(i ==1){
                    tempfloat = -8/2/2 -10-8/2/2;
                }
                else{
                    tempfloat = -8/2/2+10+8/2/2;
                }
                tempView2 = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:tempAry[i] rect:CGRectMake(UI_SCREEN_WIDTH/2 +tempfloat, bgViewOffset, 8/2, 8/2)];
                [bgView addSubview:tempView2];
            }
             */
            bgViewOffset += 8/2;
            bgViewOffset += 10/2;
        }
        
        if (self.listDict[BANNER_TYPE][@"1003"]) {
            bannerArray = (NSArray*)self.listDict[BANNER_TYPE][@"1003"];
            for (int i = 0; i<bannerArray.count; i++) {
                tempStr = bannerArray[i][@"img"];
                widthFloat = [bannerArray[i][@"img_width"]floatValue];
                heightFloat = [bannerArray[i][@"img_height"]floatValue];
                tempView = [UIImageView new];
                [tempView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
                tempFloat = widthFloat/2/375;
                tempView.frame = CGRectMake(0,bgViewOffset , UI_SCREEN_WIDTH, tempFloat*heightFloat/2 *(UI_SCREEN_WIDTH/ 375.0));
                tempView.tag = BASE_BTN_TAG+i;
                [SUTIL addViewAction:tempView target:self action:@selector(onSelectBanner:)];
                [headerView addSubview:tempView];
                bgViewOffset += tempView.frame.size.height;
                if (i != (bannerArray.count - 1)) {
                     bgViewOffset += 10/2;
                }
               
            }
            
           
        }
        offset += bgViewOffset;
    }
    
   
    //name :晒出你的范
    yourFanArray = (NSArray*)(self.listDict[FAN_TYPE][@"config"]);
    if (yourFanArray) {
        tempUIView = [SUTILITY_TOOL_INSTANCE createUILabelDottedLine:@"晒出你的范" height:66/2 color:nil fontStyle:nil interval:20];
        [tempUIView setOrigin:CGPointMake(0, offset)];
        [headerView addSubview:tempUIView];
        offset += tempUIView.frame.size.height;
       // tempAry = [dataDict allKeys];
        tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:(496+10+244)/2*SCALE_UI_SCREEN coordY:offset];
        [headerView addSubview:tempUIView];
        for (int i = 0; i<yourFanArray.count;i++) {
            
            switch (i+1) {
                case 1:
                {
                    tempView = [UIImageView new];
                    tempRect = CGRectMake(0, 0, 496/2*SCALE_UI_SCREEN, 496/2*SCALE_UI_SCREEN);
                    [tempView sd_setImageWithURL:[NSURL URLWithString:yourFanArray[i][@"img"]]];
                    tempView.frame = tempRect;
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, tempRect.size.height - 26, tempRect.size.width, 26)];
                    label.backgroundColor = [Utils HexColor:0x000000 Alpha:.4];
                    label.text = yourFanArray[i][@"name"];
                    label.textColor = COLOR_C3;
                    label.font = FONT_T4;
                    label.textAlignment = NSTextAlignmentCenter;
                    [tempView addSubview:label];
                    
                    [tempUIView addSubview:tempView];
                }
                    break;
                case 2:
                {
                    tempView = [UIImageView new];
                    tempRect = CGRectMake((496/2+10/2) *SCALE_UI_SCREEN, 0, 244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN);
                    [tempView sd_setImageWithURL:[NSURL URLWithString:yourFanArray[i][@"img"]]];
                    tempView.frame = tempRect;
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, tempRect.size.height - 26, tempRect.size.width, 26)];
                    label.backgroundColor = [Utils HexColor:0x000000 Alpha:.4];
                    label.text = yourFanArray[i][@"name"];
                    label.textColor = COLOR_C3;
                    label.font = FONT_T4;
                    label.textAlignment = NSTextAlignmentCenter;
                    [tempView addSubview:label];
                    
                    [tempUIView addSubview:tempView];
                    break;
                }
                case 3:
                {
                    tempView = [UIImageView new];
                    tempRect = CGRectMake((496/2+10/2)*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN+8/2,244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN);
                    [tempView sd_setImageWithURL:[NSURL URLWithString:yourFanArray[i][@"img"]]];
                    tempView.frame = tempRect;
                 
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, tempRect.size.height - 26, tempRect.size.width, 26)];
                    label.backgroundColor = [Utils HexColor:0x000000 Alpha:.4];
                    label.text = yourFanArray[i][@"name"];
                    label.textColor = COLOR_C3;
                    label.font = FONT_T4;
                    label.textAlignment = NSTextAlignmentCenter;
                    [tempView addSubview:label];
                    
                    [tempUIView addSubview:tempView];
                }
                    break;
                case 4:
                {
                    tempView = [UIImageView new];
                    [tempView sd_setImageWithURL:[NSURL URLWithString:yourFanArray[i][@"img"]]];
                    tempView.frame = CGRectMake(0, (496/2+10/2)*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN);
                    
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, tempRect.size.height - 26, tempRect.size.width, 26)];
                    label.backgroundColor = [Utils HexColor:0x000000 Alpha:.4];
                    label.text = yourFanArray[i][@"name"];
                    label.textColor = COLOR_C3;
                    label.font = FONT_T4;
                    label.textAlignment = NSTextAlignmentCenter;
                    [tempView addSubview:label];
                    
                    [tempUIView addSubview:tempView];
                }
                    break;
                case 5:
                {
                    tempView = [UIImageView new];
                    [tempView sd_setImageWithURL:[NSURL URLWithString:yourFanArray[i][@"img"]]];
                    tempView.frame = CGRectMake((244/2+10/2)*SCALE_UI_SCREEN, (496/2+10/2)*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN);
                 
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, tempRect.size.height - 26, tempRect.size.width, 26)];
                    label.backgroundColor = [Utils HexColor:0x000000 Alpha:.4];
                    label.text = yourFanArray[i][@"name"];
                    label.textColor = COLOR_C3;
                    label.font = FONT_T4;
                    label.textAlignment = NSTextAlignmentCenter;
                    [tempView addSubview:label];
                    
                    [tempUIView addSubview:tempView];
                    break;
                }
                    
                default:
                    break;
            }
            tempView.tag = BASE_BTN_TAG + i;
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onShowYourFan:)];
        }
        
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/topic6" rect:CGRectMake((244/2+10/2)*2*SCALE_UI_SCREEN, (496/2+10/2) *SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN)];
        [tempView setUserInteractionEnabled:YES];
        UIImageView* shadowTemp = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/cover22.png" rect:CGRectMake(0, 0, 244/2*SCALE_UI_SCREEN, 244/2*SCALE_UI_SCREEN)];
        shadowTemp.tag = BASE_BTN_TAG + MORE_FAN;
        [SUTILITY_TOOL_INSTANCE addViewAction:shadowTemp target:self action:@selector(onMoreSelect:)];
        [tempView addSubview:shadowTemp];
        [tempUIView addSubview:tempView];
        
        offset += tempUIView.height;
    }
    
    //今日搭配
    dataArray = (NSArray*)(self.listDict[DP_TYPE][@"config"]);
    if (dataArray) {
        tempUIView = [SUTILITY_TOOL_INSTANCE createUILabelDottedLine:@"今日搭配" height:66/2 color:nil fontStyle:nil interval:20];
        [tempUIView setOrigin:CGPointMake(0, offset)];
        [tempUIView setUserInteractionEnabled:YES];
        [headerView addSubview:tempUIView];
        offset += tempUIView.frame.size.height;
        //tempAry = [dataDict allKeys];
        
        
        tempScrollView  = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, AUTO_SIZE(410/2))];
        tempIndex = 0;
        for (int i = 0 ; i<dataArray.count; i++) {//推荐设计师
            tempView = [UIImageView new];
            [tempView sd_setImageWithURL:[NSURL URLWithString:dataArray[i][@"img"]]];
            tempView.clipsToBounds = YES;
            tempView.contentMode = UIViewContentModeScaleAspectFill;
            tempView.frame = CGRectMake(10+tempIndex*(228/2*SCALE_UI_SCREEN+12/2), 0, 228/2*SCALE_UI_SCREEN, 410/2*SCALE_UI_SCREEN);
            
            UIView *bottomView = [UIView new];
            bottomView.alpha = 0.4;
            bottomView.backgroundColor = [UIColor blackColor];
            bottomView.frame = CGRectMake(0, tempView.frame.size.height - 15, tempView.frame.size.width, 15);
            [tempView addSubview:bottomView];
            
            CGFloat headheight = 60 / 2;
            tempView2 = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:dataArray[i][@"head_img"] rect:CGRectMake(tempView.width/2-60/2/2, tempView.height - 6/2-60/2, 60/2, 60/2) cornerRadius:headheight/2];
            [tempView addSubview:tempView2];
//            tempView.backgroundColor = [UIColor redColor];
            tempView.tag = BASE_BTN_TAG + [dataArray[i][@"id"] intValue];
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onShowYourDP:)];
            [tempScrollView addSubview:tempView];
            tempIndex++;
        }
        tempScrollView.contentSize = CGSizeMake(10+(AUTO_SIZE(228/2)+12/2)*(tempIndex), 300/2);
        [headerView addSubview:tempScrollView];
        offset += tempScrollView.frame.size.height;
    }
    
    //推荐设计师
    dataArray = (NSArray*)(self.listDict[DESIGNER_TYPE][@"config"]);
    if (dataArray) {
        tempUIView = [SUTILITY_TOOL_INSTANCE createUILabelDottedLine:@"推荐造型师" height:66/2 color:nil fontStyle:nil interval:20];
        [tempUIView setOrigin:CGPointMake(0, offset)];
        [headerView addSubview:tempUIView];
        offset += tempUIView.frame.size.height;
        CGSize nameSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:@"张张张张张" fontStyle:FONT_t8];
        tempScrollView  = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 90/2+10/2+nameSize.height)];
        
      //  tempAry = [dataDict allKeys];
        [tempScrollView setContentSize:CGSizeMake(20/2+(90/2+34/2)*(dataArray.count+1), 80/2)];
        tempIndex = 0;
        for (int i = 0 ; i<dataArray.count; i++) {//
            tempView = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:dataArray[i][@"head_img"] rect:CGRectMake(20/2+tempIndex*(90/2+34/2), 0, 90/2, 90/2) cornerRadius:90/2/2];
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onSelectDesigner:)];
            tempView.tag = BASE_BTN_TAG + i;
            [tempScrollView addSubview:tempView];
            
            labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:dataArray[i][@"nick_name"] fontStyle:FONT_t8];
            tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:dataArray[i][@"nick_name"] fontStyle:FONT_t8 color:COLOR_C2 rect:CGRectMake(tempView.frame.origin.x+tempView.width/2-labelSize.width/2, tempView.height+10/2, nameSize.width, labelSize.height) isFitWidth:NO isAlignLeft:YES];
            [tempScrollView addSubview:tempLabel];
            tempIndex++;
           
        }
        if ((tempView.frame.origin.x+tempView.width) > UI_SCREEN_WIDTH) {
            tempView = [SUTIL createUIImageViewByStyle:@"Unico/more" rect:CGRectMake(20/2+tempIndex*(90/2+34/2), tempView.height/2-47/2/2, 79/2, 47/2)];
            tempView.tag = MORE_DESIGNER+BASE_BTN_TAG;
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onMoreSelect:)];
            [tempScrollView addSubview:tempView];
        }
        [headerView addSubview:tempScrollView];
        offset += tempScrollView.height;
    }
    
    
    
    //推荐品牌
     dataArray = (NSArray*)(self.listDict[BRAND_TYPE][@"config"]);
    if (dataArray) {
        tempUIView = [SUTILITY_TOOL_INSTANCE createUILabelDottedLine:@"推荐品牌" height:66/2 color:nil fontStyle:nil interval:20];
        [tempUIView setOrigin:CGPointMake(0, offset)];
        [headerView addSubview:tempUIView];
        offset += tempUIView.frame.size.height;
        
        tempFloat = UI_SCREEN_WIDTH/4;
        tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:tempFloat*2 coordY:offset];
        [headerView addSubview:tempUIView];
        tempY = 0;
        tempX = 0;
        tempIndex = 0;
        for (int i = 0; i<dataArray.count; i++) {
            tempIndex = i;
            if (tempIndex>=4) {
                tempY = tempFloat;
                tempX = 4;
            }else{
                tempY = 0;
                tempX = 0;
            }
            tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByUrl:dataArray[i][@"logo_img"] rect:CGRectMake((tempIndex-tempX)*tempFloat, tempY, tempFloat, tempFloat)];
            //尼玛的 搞个毛球 temp_id 变为brand_code了. 字符串类型
            tempView.tag = BASE_BTN_TAG + [dataArray[i][@"temp_id"] intValue];
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onSelectBrand:)];
            [tempUIView addSubview:tempView];
        }
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/more" rect:CGRectMake(tempUIView.width-tempFloat/2-79/2/2, tempUIView.height-tempFloat/2-47/2/2, 79/2, 47/2)];
        tempView.tag = BASE_BTN_TAG + MORE_BRAND;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onMoreSelect:)];
        [tempUIView addSubview:tempView];
        
        offset += tempUIView.height;
    }
    
  
    categaryArray = [(NSArray*)(self.listDict[ITEM_TYPE][@"config"]) mutableCopy];
    if (categaryArray) {
        //推荐品牌分类
        tempUIView = [SUTILITY_TOOL_INSTANCE createUILabelDottedLine:@"优选单品" height:66/2 color:nil fontStyle:nil interval:20];
        [tempUIView setOrigin:CGPointMake(0, offset)];
        [headerView addSubview:tempUIView];
        offset += tempUIView.frame.size.height;
        tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:440/2 coordY:offset];
        [headerView addSubview:tempUIView];
        tempY = 0;
        tempX = 0;
        float widthFloat = UI_SCREEN_WIDTH/4;
        float heightFloat = 440/2/2;
        tempIndex = 0;
        for (int i = 0; i<categaryArray.count; i++) {
            tempIndex = i;
            if (tempIndex>=4) {
                tempY = heightFloat;
                tempX = 4;
            }else{
                tempY = 0;
                tempX = 0;
            }
            tempView = [SUTILITY_TOOL_INSTANCE createRoundUIImageViewByUrl:categaryArray[i][@"item_img"] rect:CGRectMake(((widthFloat - 144/2)/2) +(tempIndex-tempX)*(widthFloat), tempY, 144/2, 144/2) cornerRadius:144/2/2];
            [tempUIView addSubview:tempView];
            tempView.tag = BASE_BTN_TAG + i;
            
            [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onshowItem:)];
            labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:categaryArray[i][@"name"] fontStyle:FONT_t8];
            tempLabel = [SUTILITY_TOOL_INSTANCE createUILabelByStyle:categaryArray[i][@"name"] fontStyle:FONT_t8 color:COLOR_C2 rect:CGRectMake(tempView.frame.origin.x+tempView.width/2-labelSize.width/2, tempY +tempView.height+20/2, 0, 0) isFitWidth:YES isAlignLeft:YES];
            [tempUIView addSubview:tempLabel];
            tempIndex++;
        }
        tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/more" rect:CGRectMake(tempUIView.width-tempFloat/2-79/2/2, tempUIView.height-tempFloat/2-47/2/2, 79/2, 47/2)];
        tempView.tag = BASE_BTN_TAG + MORE_ITEM;
        [SUTILITY_TOOL_INSTANCE addViewAction:tempView target:self action:@selector(onMoreSelect:)];
        [tempUIView addSubview:tempView];
        offset += tempUIView.height;
    }
    
    
//    tempScrollView = [SUTILITY_TOOL_INSTANCE createScrollView:self rect:CGRectMake(0, offset, UI_SCREEN_WIDTH, 0)];
//    dpData = @[@"全部",@"最有范",@"臭美妞",@"骚包男",@"熊孩纸",@"吃不胖",@"胖不吃",@"不吃胖"];
//    tempAry = dpData;
//    tempoffset = 0;
//    tempScrollView.userInteractionEnabled = YES;
//    for (int i = 0; i<[tempAry count]; i++) {
//        labelSize = [SUTILITY_TOOL_INSTANCE getStrLenByFontStyle:tempAry[i] fontStyle:FONT_SIZE(12) ];
//        tempBtn = [SUTILITY_TOOL_INSTANCE createTitleButtonAction:tempAry[i] bgColor:nil fontColor:UIColorFromRGB(0x3b3b3b) fontStyle:FONT_SIZE(12) rect:CGRectMake(43/2+i*(labelSize.width+36/2), 0, labelSize.width, 90/2) target:self action:@selector(selectCollocationType:)];
//        
//        tempColor = COLOR_C5;
//        tempBtn.tag = BASE_BTN_TAG + i;
//        if (i == 0 ) {
//            p_selectButton = tempBtn;
//           tempColor = COLOR_C2;
//            tempView = [SUTILITY_TOOL_INSTANCE createUIImageViewByStyle:@"Unico/selected_3" rect:CGRectMake(43/2+tempBtn.width/2-80/2/2, tempBtn.height - 6/2, 80/2, 6/2)];
//            [tempScrollView addSubview:tempView];
//            p_selectView_y = tempView;
//        }
//        [tempBtn setTitleColor:tempColor forState:UIControlStateNormal];
//        [tempScrollView addSubview:tempBtn];
//    }
//    [tempScrollView setSize:CGSizeMake(UI_SCREEN_WIDTH, 90/2)];
//    
//    tempScrollView.contentSize = CGSizeMake(tempBtn.frame.origin.x + tempBtn.frame.size.width, 90/2);
//    //两根线
//    UIView *tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:nil];
//    [tempUI setOrigin:CGPointMake(0, tempScrollView.frame.origin.y -1)];
//    [headerView addSubview:tempUI];
//    tempUI = [SUTILITY_TOOL_INSTANCE getNormalLineBySize:UI_SCREEN_WIDTH height:1 color:nil];
//    [tempUI setOrigin:CGPointMake(0, tempScrollView.frame.origin.y + tempScrollView.height + 1)];
//    [headerView addSubview:tempUI];
//    
//    
//    [headerView addSubview:tempScrollView];
//    //暂时隐藏
//    
//    offset += tempScrollView.frame.size.height;
    tempUIView = [SUTILITY_TOOL_INSTANCE createUIViewByHeight:0 coordY:offset];
    
    UIView* tempUI = [SUTILITY_TOOL_INSTANCE createUILabeLine:@"推荐搭配" color:UIColorFromRGB(0xc4c4c4) fontStyle:FONT_SIZE(12) interval:20/2];
    [tempUI setOrigin:CGPointMake(0, 50/2)];
//    [tempUIView addSubview:tempUI];
    [tempUIView setHeight:(50/2+30/2+tempUI.height)];
    tempUIView.backgroundColor = COLOR_NORMAL;
    [headerView addSubview:tempUIView];
    
    CGPoint position = [self.view convertPoint:CGPointMake(0, offset) fromView:self.collectionView];
    _titleView = [[SHeaderTitleView alloc]initWithFrame:CGRectMake(0, position.y, UI_SCREEN_WIDTH, 44)];
    _titleFrameOrigin_Y = position.y - self.collectionView.frame.origin.y;
    _titleView.headerTitleDelegate = self;
    _titleView.contentArray = _listDict[@"pos_6"][@"config"];
    [self.view addSubview:_titleView];
    
    offset += _titleView.height;
    
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setSize:CGSizeMake(UI_SCREEN_WIDTH, offset)];
    //跑马灯
    [headerView addSubview:idsScroll];
    self.headerViewHeight = offset;
}

-(void)onSearch:(id)sender{
    [SUTIL showSearch];
}
-(void)onSelectActivity:(UITapGestureRecognizer*)recognizer{
    long index = recognizer.view.tag - BASE_BTN_TAG;
    if (index < 0) {
        return;
    }
    NSDictionary *tempDict =  activityArray[index];
    
    [SUTIL jumpControllerWithContent:tempDict target:self];
    
//    NSString *tempStr;
//    NSString *name;
//    NSInteger jumpType = [tempDict[@"jump_type"]integerValue];
//    if (jumpType == 6) {
//        tempStr = tempDict[@"url"];
//        name = tempDict[@"name"];
//        [SUTIL showWebpage:tempStr titleName:name];
//    }
}

-(void)onSelectBanner:(UITapGestureRecognizer*)recognizer{
    long index = recognizer.view.tag - BASE_BTN_TAG;
    if (index < 0) {
        return;
    }
    NSDictionary *tempDict =  bannerArray[index];
    
    [SUTIL jumpControllerWithContent:tempDict target:self];
    
//    NSString *tempStr;
//    NSString *name;
//    NSInteger jumpType = [tempDict[@"jump_type"]integerValue];
//    if (jumpType == 6) {
//        tempStr = tempDict[@"url"];
//        name = tempDict[@"name"];
//        [SUTIL showWebpage:tempStr titleName:name];
//    }
}

-(void)onSelectDesigner:(UITapGestureRecognizer*)recognizer{
    //根据
    long designerIndex = recognizer.view.tag;
    designerIndex = designerIndex - BASE_BTN_TAG;
    if (designerIndex < 0) {
        return;
    }
    if(!sns.isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
        
    }
    NSString *tempStr = _listDict[DESIGNER_TYPE][@"config"][designerIndex][@"user_id"];
    SMineViewController *vc = [[SMineViewController alloc]init];
    vc.person_id = tempStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)onSelectBrand:(UITapGestureRecognizer*)recognizer{
    long brandId = recognizer.view.tag;
    brandId = brandId - BASE_BTN_TAG;
    if (brandId < 0) {
        return;
    }
    //推荐品牌
  NSArray *  dataArray = (NSArray*)(self.listDict[BRAND_TYPE][@"config"]);
    NSString *brandCode=nil;
    
    for (int a=0; a<[dataArray count]; a++) {
       int tempID= [dataArray[a][@"temp_id"] intValue];
        if (tempID ==brandId) {
            brandCode = [NSString stringWithFormat:@"%@",dataArray[a][@"brand_code"]];
            break;
        }
    }
#warning  brandid为brandcode 字符串类型. 此处brandid tag 值 瞎搞
    SBrandSotryViewController *vc = [SBrandSotryViewController new];
    vc.brandId = [NSString stringWithFormat:@"%@",brandCode];
    
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"brandId id is %ld",brandId);
    
}

-(void)onShowYourDP:(UITapGestureRecognizer*)recognizer{
    long collocationId = recognizer.view.tag;
    collocationId = collocationId - BASE_BTN_TAG;
    if (collocationId < 0) {
        return;
    }
  /*  SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
    vc.collocationId = collocationId;
    [self pushController:vc animated:YES];
    NSLog(@"collocationId dp id is %ld",collocationId);*/
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
        
        detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%ld",collocationId];
        [self pushController:detailNoShoppingViewController animated:YES];
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        collocationDetailVC.collocationId = [NSString stringWithFormat:@"%ld",collocationId];
        [self pushController:collocationDetailVC animated:YES];
        
    }
    
    
    
}

-(void)onshowItem:(UITapGestureRecognizer*)recognizer{
    long index = recognizer.view.tag;
    index = index - BASE_BTN_TAG;
    if (index < 0) {
        return;
    }
//    SSearchResultViewController * searchResultVC  = [[SSearchResultViewController alloc]init];
//    searchResultVC.selectedIndex = 1;
//    searchResultVC.searchText = categaryArray[index][@"name"];
//    [self.navigationController pushViewController:searchResultVC animated:YES];
    SItemViewController *item = [[SItemViewController alloc] init];
    item.modelName = categaryArray[index][@"name"];
    [self.navigationController pushViewController:item animated:YES];
    //id值
    //    [categaryArray[index][@"id"] intValue]

    
//    MBBrandViewController * detailVC = [[MBBrandViewController alloc]init];
//    detailVC.categaryID = OTHER_TO_STRING(@"%ld", itemId);
//    [self.navigationController pushViewController:detailVC animated:YES];
//    NSLog(@"itemId dp id is %ld",itemId);
}

-(void)onShowYourFan:(UITapGestureRecognizer*)recognizer{
    long index = recognizer.view.tag-BASE_BTN_TAG;
    if (index<0 || index>(yourFanArray.count-1)) {
        return;
    }
    NSDictionary *dict = yourFanArray[index];
    STopicDetailViewController *controller = [[STopicDetailViewController alloc]init];
    controller.topicID = [NSString stringWithFormat:@"%@", dict[@"id"]];
    controller.titleName = dict[@"name"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)onShowTodayDp:(UITapGestureRecognizer*)recognizer{
    long collocationId = recognizer.view.tag;
    collocationId = collocationId - BASE_BTN_TAG;
    if (collocationId < 0) {
        return;
    }
   /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
    vc.collocationId = collocationId;
    [self pushController:vc animated:YES];*/
    
    
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        
#warning  搭配id 要是字符串类型
        detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%ld",collocationId];
        [self pushController:detailNoShoppingViewController animated:YES];
        
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        
        
        collocationDetailVC.collocationId = [NSString stringWithFormat:@"%ld",collocationId];;
        [self pushController:collocationDetailVC animated:YES];
        
    }

}

-(void)onSelectInfo:(id)selector{
    UIButton *tempBtn = (UIButton*)selector;
    long tag = tempBtn.tag-BASE_BTN_TAG;
    switch (tag) {
        case STAR_SHOP:
            {
                NSLog(@"%ld",tag);
                SStarStoreViewController * starStoreVC = [[SStarStoreViewController alloc]init];
                [self.navigationController pushViewController:starStoreVC animated:YES];
            }
            break;
        case BEST_BRAND:
            {
                NSLog(@"%ld",tag);
                SBrandViewController *Vc = [SBrandViewController new];
                [self.navigationController pushViewController:Vc animated:YES];
            }
            break;
        case BEST_DP:
            {
                SBestCollocationViewController *dbVc = [SBestCollocationViewController new];
                [self pushController:dbVc animated:YES];
            }
            break;
        case FASHION_INFO:
            {
                NSLog(@"%ld",tag);
                SFashionInfomationViewController *fashionVc = [SFashionInfomationViewController new];
                [self pushController:fashionVc animated:YES];
            }
            break;
        case ACTIVITY_NOW:
            {
                SActivityListViewController *controller = [[SActivityListViewController alloc]initWithNibName:@"SActivityListViewController" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }

    
}

-(void)onMoreSelect:(UITapGestureRecognizer*)recognizer{
    
    long tag = recognizer.view.tag;
    tag = tag - BASE_BTN_TAG;
    if (tag < 0) {
        return;
    }
    switch (tag) {
        case MORE_DESIGNER:
        {
            NSLog(@"更多设计师");
            SDesignerViewController *Vc = [SDesignerViewController new];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case MORE_BRAND:
            {
                NSLog(@"更多品牌");
                SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
                [self.navigationController pushViewController:brandVc animated:YES];
            }
            break;
        case MORE_ITEM:
            {
                NSLog(@"更多单品");
                SItemViewController *itemVc = [SItemViewController new];
                [self.navigationController pushViewController:itemVc animated:YES];
            }
            break;
        case MORE_FAN:
            NSLog(@"更多范");
            {
                STopicViewController *controller = [[STopicViewController alloc]initWithNibName:@"STopicViewController" bundle:nil];
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
                backItem.title = @"";
                self.navigationItem.backBarButtonItem = backItem;
                [self.navigationController pushViewController:controller animated:YES];
            }
            break;
        default:
            break;
    }
    
}

-(void)selectCollocationType:(id)selector{
    UIButton *tempBtn = (UIButton*)selector;
    long tag = tempBtn.tag - BASE_BTN_TAG;
    
    [p_selectButton setTitleColor:COLOR_C5 forState:UIControlStateNormal];
    [tempBtn setTitleColor:COLOR_C2 forState:UIControlStateNormal];
    [p_selectView_y setOrigin:CGPointMake(tempBtn.frame.origin.x+tempBtn.width/2-p_selectView_y.width/2, p_selectView_y.frame.origin.y)];
    if (tag < 0 || tag > dpData.count) {
        return;
    }
    NSLog(@"%@",dpData[tag]);
    
}

#pragma mark - SHeaderTitleCollectionView delegate

- (void)headerTitleCollectionView:(UICollectionView *)collectionView contentModel:(SHeaderTitleModel *)contenModel{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 3.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat origin_Y;
    if (self.collectionView.contentOffset.y + 64 > CGRectGetMaxY(headContent.frame)) {
        origin_Y = self.collectionView.contentOffset.y + 64;
    }else{
        origin_Y = CGRectGetMaxY(headContent.frame);
    }
    CGPoint point = [self.collectionView convertPoint:CGPointMake(0, origin_Y) toView:self.view];
    
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, point.y * 3, image.size.width * 3, image.size.height * 3))];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    CGRect frame = CGRectMake(0, point.y, UI_SCREEN_WIDTH, self.view.frame.size.height - point.y);
    imageView.frame = frame;
    
//    [self.goodsList removeAllObjects];
    [self.collectionView setContentOffset:CGPointMake(0, CGRectGetMaxY(headContent.frame) - CGRectGetMaxY(self.titleView.frame)) animated:YES];
    [self.collectionView reloadData];
    
    [self getCollocationList:YES tabString:[contenModel.name isEqualToString:@"全部"]? @"": contenModel.name];
    [self.view addSubview:imageView];
//    frame = imageView.frame;
//    frame.origin.x = - UI_SCREEN_WIDTH;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        imageView.frame = frame;
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        [imageView removeFromSuperview];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"scrollViewBegin"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tabBarController setValue:scrollView forKey:@"controlScrollView"];
    if (scrollView == self.collectionView) {
        CGRect frame = self.titleView.frame;
        frame.origin.y = _titleFrameOrigin_Y - scrollView.contentOffset.y;
        CGRect rect = _searchView.frame;
        if (frame.origin.y < 64) {
            rect.origin.y = frame.origin.y - 64;
        }else{
            rect.origin.y = 0;
        }
        _searchView.frame = rect;
        if (frame.origin.y < 20) {
            frame.origin.y = 20;
            [_titleView setOriginOffset:-(40 - frame.origin.y)];
        }else if (frame.origin.y < 40){
            [_titleView setOriginOffset:-(40 - frame.origin.y)];
        }else{
            [_titleView setOriginOffset:0];
        }
        if(frame.origin.y < 30){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
        self.titleView.frame = frame;
    }
}

#pragma mark - XLCycleScrollDelagate
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    NSDictionary *info = idsArray[index];
    NSLog(@"Click %@",info);
    NSDictionary *tempDict =  idsArray[index];
    [SUTIL jumpControllerWithContent:tempDict target:self];
  
}

#pragma mark -XLCycleScrollViewDatasource
- (NSUInteger)numberOfPages
{
    return idsArray.count;
}
- (UIView *)pageAtIndex:(NSInteger)index
{
    if (idsArray.count == 1) {
        [idsScroll.pageControl setHidden:YES];
    } else {
        if (idsScroll.pageControl.isHidden) {
            [idsScroll.pageControl setHidden:NO];
        }
    }
    UIImageView *imageView  = [UIImageView new];
    NSString *tempStr = idsArray[index][@"img"];
//    float widthFloat = [idsArray[index][@"img_width"] floatValue];
//    float heightFloat = [idsArray[index][@"img_height"] floatValue];
//    float tempFloat = (UI_SCREEN_WIDTH/(widthFloat/2)*(heightFloat/2));
    [imageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
    [imageView setFrame:idsScroll.bounds];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    return imageView;
}
#pragma mark 获取推荐品牌列表
-(void)getRecommendBrandListRequest
{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //新的
            [HttpRequest productPostRequestPath:@"Product" methodName:@"BrandFilter" params:@{@"pageIndex": @1, @"pageSize": @7} success:^(NSDictionary *dict) {
                NSLog(@"brandSuccess");
                NSArray *result = [dict objectForKey:@"results"];
                if (recommendBrandArr == nil) {
                    recommendBrandArr = [[NSMutableArray alloc]initWithCapacity:0];
                }
                
                if (recommendBrandArr.count == 0) {
                    for (int i = 0; i<[result count]; i++) {
                        BrandListCellModel * model = [[BrandListCellModel alloc]initWithBrandListCellDic:result[i]];
                        [recommendBrandArr addObject:model];
                    }
                }
                if (recommendBrandArr.count >0) {
                    [recommendBrandArr addObject:@"Unico/more"];
                    
                }

            } failed:^(NSError *error) {
                
            }];
//            老得 
            /*
        [HttpRequest productGetRequestPath:@"Product" methodName:@"BrandFilter" params:@{@"pageIndex":[NSNumber numberWithInt:1],@"pageSize":[NSNumber numberWithInteger:7]} success:^(NSDictionary *dict) {
            NSLog(@"brandSuccess");
            NSArray *result = [dict objectForKey:@"results"];
            if (recommendBrandArr == nil) {
               recommendBrandArr = [[NSMutableArray alloc]initWithCapacity:0];
            }

            if (recommendBrandArr.count == 0) {
                for (int i = 0; i<[result count]; i++) {
                    BrandListCellModel * model = [[BrandListCellModel alloc]initWithBrandListCellDic:result[i]];
                    [recommendBrandArr addObject:model];
                }
            }
            if (recommendBrandArr.count >0) {
                [recommendBrandArr addObject:@"Unico/more"];
                
            }
        } failed:^(NSError *error) {
            //                [_homeTable setTableHeaderView:[self configTableViewHeaderView]];
        }];
             */
    });
    

}

#pragma mark 获取推荐设计师列表
-(void)getRecommendDesignerListRequest
{
    if (!recommendDesignerArr) {
        recommendDesignerArr = [[NSMutableArray alloc]init];
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    if ([sns.ldap_uid length] > 0) {
        [dict setObject:sns.ldap_uid forKey:@"userId"];
    }
    [dict setObject: @"Gradle"  forKey:@"sortField"];

    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInteger:7] forKey:@"pageSize"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest accountPostRequestPath:nil methodName:@"DesignerSearchFilter" params:dict success:^(NSDictionary *dict) {
            NSLog(@"designner success");
            NSArray *result = [dict objectForKey:@"results"];
            if (!recommendDesignerArr) {
                recommendDesignerArr = [[NSMutableArray alloc]init];
            }
            if (recommendDesignerArr.count == 0) {
                for (int i = 0 ; i <[result count]; i++) {
                    DesignerModel * model = [[DesignerModel alloc]initWithDesignerInfo:result[i]];
                    [recommendDesignerArr addObject:model];
                }
                
            }
            if([recommendDesignerArr count]>0)
            {
                [recommendDesignerArr addObject:@"Unico/more"];
            }
            
            [self brandListRequestDone];
        } failed:^(NSError *error) {
            //                [_homeTable setTableHeaderView:[self configTableViewHeaderView]];
        }];
    });
    
    
}

#pragma mark 获取分类列表
-(void)getRecommendListRequest
{
    if (!recommendDesignerArr) {
        recommendDesignerArr = [[NSMutableArray alloc]init];
    }
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    if ([sns.ldap_uid length] > 0) {
        [dict setObject:sns.ldap_uid forKey:@"userId"];
    }
    [dict setObject: @"Gradle"  forKey:@"sortField"];
    
    [dict setObject:[NSNumber numberWithInteger:1] forKey:@"pageIndex"];
    [dict setObject:[NSNumber numberWithInteger:7] forKey:@"pageSize"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest accountPostRequestPath:nil methodName:@"DesignerSearchFilter" params:dict success:^(NSDictionary *dict) {
            NSLog(@"designner success");
            NSArray *result = [dict objectForKey:@"results"];
            if (!recommendDesignerArr) {
                recommendDesignerArr = [[NSMutableArray alloc]init];
            }
            if (recommendDesignerArr.count == 0) {
                for (int i = 0 ; i <[result count]; i++) {
                    DesignerModel * model = [[DesignerModel alloc]initWithDesignerInfo:result[i]];
                    [recommendDesignerArr addObject:model];
                }
                
            }
            
            [self brandListRequestDone];
        } failed:^(NSError *error) {
            //                [_homeTable setTableHeaderView:[self configTableViewHeaderView]];
        }];
    });
    
    
}

-(void)brandListRequestDone
{
//    if (!recommendBrandArr) {
//        return;
//    }
//    else
//    {
      //  [self loadData];
        [self layoutUI];

//    }
}
-(void)layoutUI{
//    [loadingSnapView removeFromSuperview];
    [super layoutUI];
    [self.collectionView setOrigin:CGPointMake(0, 0)];
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.collectionView addFooterWithTarget:self action:@selector(requestAddData)];
//    self.collectionView.contentOffset = CGPointMake(0, - 64);
}

//- (void)setGoodsList:(NSMutableArray *)goodsList{
//    _goodsList = goodsList;
//    [self.collectionView reloadData];
//    UIEdgeInsets edgeInset = self.collectionView.contentInset;
//    CGFloat contentInsetBottom = self.collectionView.contentSize.height - self.headerViewHeight;
//    if (contentInsetBottom <= UI_SCREEN_HEIGHT - 64) {
//        edgeInset.bottom = contentInsetBottom;
//    }else{
//        edgeInset.bottom = 0;
//    }
//    self.collectionView.contentInset = edgeInset;
//}

//#pragma collectionDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//   NSInteger collocationId  = [((LNGood*)self.goodsList[indexPath.row]).product_ID integerValue];
//    if (collocationId<0) {
//        return;
//    }
//    SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
//    vc.collocationId = collocationId;
//    [self pushController:vc animated:YES];
//    
//}

@end
