//
//  DailyNewViewController.m
//  Wefafa
//
//  Created by metesbonweios on 15/7/29.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//
//每日新品  //单一品牌
#import "DailyNewViewController.h"
#import "Utils.h"
#import "SUtilityTool.h"
#import "SDataCache.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "WaterFLayout.h"
#import "HttpRequest.h"
#import "SFilterBrandController.h"
#import "SSearchProductModel.h"
#import "SSearchProductCollectionViewCell.h"
#import "SProductDetailViewController.h"
#import "SActivityBrandListModel.h"
#import "FilterPirceRangeModel.h"
#import "FilterColorCategoryModel.h"
#import "FilterBrandCategoryModel.h"
#import "SDiscoveryPicAndTextModel.h"
#import "SBrandStoryDetailModel.h"

#import "SBrandSotryViewController.h"
#import "BrandDetailViewController.h"
#import "WeFaFaGet.h"
#import "DailyNewModel.h"
#import "NSString+help.h"
#import "ShareRelated.h"

static NSString *productCellIdentifier = @"SBrandSotryProductCellIdentifier";

@interface DailyNewViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate>
{
    int _selectedIndex;
    int _sortSelectedIndex;
//    BOOL _isSortSequence;
    NSInteger _pageIndex;
    CALayer *_topSelectedLineLayer;
    CALayer *_bottomSelectedLineLayer;
    NSMutableDictionary *chooseDic;
    CGFloat _beginOrigin_Y;
    UIImageView *brandImgView;
    UIButton *likeBtn;
    int showSortField;
  
    UIView *backView;
    UIView *noneDataView;
    UIBarButtonItem *_navigationRightItem;

    int _isSortSequence;
    __block BOOL iserror;
    
    
}
@property (nonatomic, strong) NSMutableArray *bottomButtonArray;
//@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *productListArray;
@property (nonatomic, strong) NSMutableArray *collocationListArray;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;

@property (nonatomic, weak) UIView *selectedContentView;

@property (nonatomic, strong) NSMutableDictionary *brandFilterDictionary;
@property (nonatomic) WaterFLayout* flowLayout;
@property (nonatomic,strong)  DailyNewModel *dailyHeadModel;
@end

@implementation DailyNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavbar];
    [self initTitleView];
    chooseDic=[[NSMutableDictionary alloc]init];

}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
//    [brandImgView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, brandImgView.frame.size.height)];
//    [backView setFrame:CGRectMake(0, brandImgView.frame.size.height+brandImgView.frame.origin.y, backView.frame.size.width, backView.frame.size.height)];
//
//    [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-backView.frame.size.height- backView.frame.origin.y)];
//    self.navigationController.navigationBar.hidden=NO;
    if (self.brandId!=nil||self.brandId.length!=0) {
        [self requestHeaderData];
    }

}
-(void)requestHeaderData
{
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
//    NSDictionary *params = @{
//                             @"m":@"BrandMb",
//                             @"a":@"getBrandDetailsForItem",
//                             @"token":userToken,
//                             @"bid":[NSString stringWithFormat:@"%@",_brandId]
//                             };
    NSDictionary *params = @{
                             @"m":@"BrandMb",
                             @"a":@"getBrandDetailsForItem",
                             @"token":userToken,
                             @"brandCode":[NSString stringWithFormat:@"%@",_brandId]
                             };

    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        NSDictionary *dic=nil;
        NSArray *array =nil;
        if ([object isKindOfClass:[NSArray class]]) {
            array = (NSArray *)object;
            dic = [array firstObject];
        }
        else
        {
            dic = (NSDictionary*)object;
        }
        self.dailyHeadModel =[[DailyNewModel alloc]initWithDictionary:dic[@"data"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code == -100){
            iserror = YES;
            self.title=@"品牌";
            UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
            view.backgroundColor = UIColorFromRGB(0xf2f2f2);
            [self.view addSubview:view];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unico/icon_brand_failure"]];
            imageView.centerX = UI_SCREEN_WIDTH/ 2;
            imageView.centerY = UI_SCREEN_HEIGHT/ 2;
            [view addSubview:imageView];
            _navigationRightItem.enabled = NO;
        }else{
            [Toast makeToast:kNoneInternetTitle];
        }
    }];

}
-(void)initTitleView
{
    _bottomButtonArray = [[NSMutableArray alloc]init];
    
    int brandY=0;
    if (self.brandId!=nil||self.brandId.length!=0) {
        if(!_isCanSocial)
        {
           brandY=125;
        }
       
        brandImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, brandY)];
        brandImgView.userInteractionEnabled=YES;
        [self.view addSubview:brandImgView];
//        likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
//        [likeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-50, brandImgView.frame.size.height-50,30, 30)];
//        likeBtn.layer.cornerRadius=3;
//        likeBtn.layer.masksToBounds=YES;
//    
//        [likeBtn addTarget:self action:@selector(likeBrand:) forControlEvents:UIControlEventTouchUpInside];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y_de"] forState:UIControlStateHighlighted];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y_de"] forState:UIControlStateNormal];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y"] forState:UIControlStateSelected];
//        [brandImgView addSubview:likeBtn];
        
    }
    backView = [[UIView alloc]initWithFrame:CGRectMake(0,64+brandY, UI_SCREEN_WIDTH, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, self.contentCollectionView.frame.size.height-brandY)];
    
    self.contentCollectionView.alwaysBounceVertical = YES;
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:productCellIdentifier];
    [self.contentCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    _flowLayout = [[WaterFLayout alloc]init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentCollectionView.collectionViewLayout = _flowLayout;

    if (self.brandId!=nil||self.brandId.length!=0) {
 
        likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
        [likeBtn setFrame:CGRectMake(UI_SCREEN_WIDTH-50,UI_SCREEN_HEIGHT-50,30, 30)];
        likeBtn.layer.cornerRadius=3;
        likeBtn.layer.masksToBounds=YES;
        
        [likeBtn addTarget:self action:@selector(likeBrand:) forControlEvents:UIControlEventTouchUpInside];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y_de"] forState:UIControlStateHighlighted];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y_de"] forState:UIControlStateNormal];
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y"] forState:UIControlStateSelected];
        [likeBtn setImage:[UIImage imageNamed:@"Unico/brandlike"] forState:UIControlStateHighlighted];
        [likeBtn setImage:[UIImage imageNamed:@"Unico/brandunlike"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"Unico/brandlike"] forState:UIControlStateSelected];
        [self.view addSubview:likeBtn];
        }
    

    
    NSArray* titleArray = @[@"上新",@"热销",@"价格", @"筛选"];
    int count = 4;
    NSArray *imageNameArray = @[@"",@"", @"Unico/btn_sort_nomal", @"Unico/btn_selected_icon"];
    CGFloat origin_X = 0.0;
    for (int i = 0; i < count; i++) {
        origin_X = (70 + (UI_SCREEN_WIDTH - 75 * count)/ (count - 1)) * i;
        UIButton *bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(origin_X, 0, 75, 44)];
        NSString *imageName = imageNameArray[i];

        if (i == 4) {
            [bottomButton setImage:[UIImage imageNamed:@"Unico/btn_selected_icon_selected"] forState:UIControlStateSelected];
            
        }
        bottomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        if (![imageName isEqualToString:@""]) {
            [bottomButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            bottomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        }
        bottomButton.titleLabel.font = FONT_t4;
        [bottomButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [bottomButton setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        [bottomButton setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        bottomButton.tag = 180 + i;
        [bottomButton addTarget:self action:@selector(bottomSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:bottomButton];
        [_bottomButtonArray addObject:bottomButton];
    }
    UIButton *btn=_bottomButtonArray[0];
    CGSize size =[btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
    _bottomSelectedLineLayer = [CALayer layer];
    _bottomSelectedLineLayer.backgroundColor = COLOR_C1.CGColor;
    _bottomSelectedLineLayer.frame = CGRectMake(100, 41.0, size.width+10, 3);
    _bottomSelectedLineLayer.zPosition = 5;
    [backView.layer addSublayer:_bottomSelectedLineLayer];
    [self bottomSelectedButton:[_bottomButtonArray firstObject]];
}
-(void)initNoDataView
{
    [self removeNoDataView];
    int brandY=0;
    if(!_isCanSocial)
    {
        brandY=125;
    }
    
    noneDataView = [SUTILITY_TOOL_INSTANCE createLayOutNoDataViewRect:CGRectMake(0, brandY+64+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-(brandY+64+backView.frame.size.height)) WithImage:NONE_DATA_ITEM andImgSize:CGSizeMake(60, 60) andTipString:@"没有相关品牌单品" font:FONT_t5 textColor:[Utils HexColor:0x999999 Alpha:1.0] andInterval:10.0];
    [noneDataView setBackgroundColor:[Utils HexColor:0xf2f2f2 Alpha:1]];
    
    [self.view addSubview:noneDataView];
    if (self.brandId!=nil||self.brandId.length!=0) {
        [self.view addSubview:likeBtn];
    }
    
}
-(void)removeNoDataView
{
    [noneDataView removeFromSuperview];
    
}
-(void)setDailyHeadModel:(DailyNewModel *)dailyHeadModel
{
    //顶部图片取错误
    _dailyHeadModel = dailyHeadModel;
    NSString *imgUrlStr = [dailyHeadModel.item_img.img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
//    [brandImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] isLoadThumbnail:NO placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    [brandImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    self.title=_dailyHeadModel.english_name;

    [likeBtn setSelected:_dailyHeadModel.is_love];
    [self setHightPic];
    
}
-(void) setHightPic
{
    if (likeBtn.selected) {
        
        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y"] forState:UIControlStateHighlighted];
    }
    else
    {
//        [likeBtn setImage:[UIImage imageNamed:@"Unico/smile_big_y_de"] forState:UIControlStateHighlighted];
        [likeBtn setImage:[UIImage imageNamed:@"Unico/brandlike"] forState:UIControlStateHighlighted];
        //APP store弹出框弹出条件：用户点赞，收藏，加入心愿单之后3秒
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [SUTILITY_TOOL_INSTANCE showPraiseBox];
        });
    }
}
- (void)requestAddData{
    _pageIndex = (_productListArray.count + 9)/ 10;
    [self requestProductListData];
}
- (void)bottomSelectedButton:(UIButton*)sender{
    
    _sortSelectedIndex = (int)sender.tag - 180;
    
    if (_sortSelectedIndex == 3) {
        [chooseDic removeAllObjects];
//        if (sender.selected){
//            sender.selected = NO;
//            self.brandFilterDictionary = nil;
//            chooseDic=nil;
//            [self requestProductListData];
//        }else{
            sender.selected = NO;
            self.brandFilterDictionary = [NSMutableDictionary dictionary];
            SFilterCollectionViewController *vc = [[SFilterCollectionViewController alloc] initWithNibName:@"SFilterCollectionViewController" bundle:nil];
            vc.isBack=YES;
            if([self.title isEqualToString:@"每日新品"])
            {
                vc.isComeFromBrand=NO;
            }
            else
            {
                vc.isComeFromBrand=YES;
                vc.dailyNewModel=_dailyHeadModel;
                vc.keyword=nil;
            }
//            vc.isComeFromBrand=NO;
            vc.didSelectedEnter = ^(id sender)
            {
                chooseDic =(NSMutableDictionary *)sender;
                [self.productListArray removeAllObjects];
                [self requestAddData];
            };
            [self.navigationController pushViewController:vc animated:YES];
//        }
        return;
    }
    for (int i = 0; i < 3; i++) {
        UIButton *button = _bottomButtonArray[i];
        button.selected = button == sender;
    }
    _pageIndex = 0;
    if (_sortSelectedIndex != 2) {
        _isSortSequence = -1;
        UIButton *button = _bottomButtonArray[2];
        [button setImage:[UIImage imageNamed:@"Unico/btn_sort_nomal"] forState:UIControlStateNormal];
    }else{
//        _isSortSequence = !_isSortSequence;
        if(_isSortSequence ==1)
        {
            _isSortSequence=-1;
        }
        else
        {
          _isSortSequence=1;
        }
        
        NSString *imageName = @"";
        if (_isSortSequence==1) {
            imageName = @"Unico/btn_sort_top";//升序 箭头向上 1
        }else{
            imageName = @"Unico/btn_sort_bottom";//降序 箭头向下-1
        }
        [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    CGPoint position = _bottomSelectedLineLayer.position;
    position.x = sender.centerX;
    if (_sortSelectedIndex == 2) {
        position.x += 5;
    }
    UIButton *btn=_bottomButtonArray[_sortSelectedIndex];
    CGSize size =[btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
    _bottomSelectedLineLayer.frame=CGRectMake(_bottomSelectedLineLayer.frame.origin.x,
                                              _bottomSelectedLineLayer.frame.origin.y,size.width+10, _bottomSelectedLineLayer.frame.size.height);
    
    _bottomSelectedLineLayer.position = position;
    
    [self requestProductListData];
}

- (void)requestProductListData{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"brandId":[Utils getSNSString:self.brandId],
//                                                                                  @"pageIndex": @(_pageIndex + 1),
//                                                                                  @"pageSize": @10}];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"brandCode":[Utils getSNSString:self.brandId],
                                                                                  @"pageIndex": @(_pageIndex + 1),
                                                                                  @"pageSize": @10}];
    if ([[chooseDic allKeys]count]>0) {
        
        if([[chooseDic allKeys]containsObject:@"cid"])
        {
            params[@"CategoryId"]=chooseDic[@"cid"];
        }
        if([[chooseDic allKeys]containsObject:@"brand"])
        {
           params[@"brandCode"]=chooseDic[@"brand"];
        }
        if([[chooseDic allKeys]containsObject:@"sizeCode"])
        {
             params[@"sizeCode"]=chooseDic[@"sizeCode"];
        }
        if([[chooseDic allKeys]containsObject:@"color"])
        {
            params[@"color"]=chooseDic[@"color"];
        }
        if([[chooseDic allKeys]containsObject:@"priceRange"])
        {
            params[@"priceRange"]=chooseDic[@"priceRange"];
        }
        if([[chooseDic allKeys]containsObject:@"productId"])
        {
            params[@"productId"]=chooseDic[@"productId"];
        }
        if([[chooseDic allKeys]containsObject:@"discountRange"])
        {
            params[@"discountRange"]=chooseDic[@"discountRange"];
            //            params[@"priceRange"]=_chooseDic[@"priceRange"];
        }
//        params[@"pageIndex"]=@(1);
        
    }
    
   //  des  1 升序    －1 降序 ;  SortField 全为1
    
//  SortField  Int	1：价格price，2：总销量saleCount，3：上市日期marketDate，4：周销量weekSaleCount，5：满意度saticsfaction
    
     showSortField =3;
    
    if (_sortSelectedIndex == 2){ //3价格  1 上新 默认
        showSortField=1;
        params[@"sortInfo"] = @{@"sortField": @(showSortField), @"desc": @(_isSortSequence)};
    }else if (_sortSelectedIndex == 0)
    {
        showSortField=3;
//        上新
        params[@"sortInfo"] = @{@"sortField":@(showSortField), @"desc": @"0"};
    }else if(_sortSelectedIndex==1){
        
        showSortField=2;
        params[@"sortInfo"] = @{@"sortField": @(showSortField), @"desc": @"0"};
    }
    else {
        params[@"sortInfo"] = @{@"sortField": @(showSortField), @"desc": @(_isSortSequence)};
    }
//    if (_sortSelectedIndex == 1){ //3价格  1 上新 默认
////        showSortField=3;
//       
//        params[@"sortInfo"] = @{@"SortField": @(showSortField), @"Desc": @(!_isSortSequence)};
//    }else if (_sortSelectedIndex == 0)
//    {
//        showSortField=1;
//        params[@"sortInfo"] = @{@"SortField": @(showSortField), @"Desc": @(!_isSortSequence)};
//    }
//    else {
//         params[@"sortInfo"] = @{@"SortField": @(showSortField), @"Desc": @(!_isSortSequence)};
//       }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.brandFilterDictionary) {
        [dictionary setValuesForKeysWithDictionary:self.brandFilterDictionary];
    }
     [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductClsCommonSearchFilter" params:dictionary success:^(NSDictionary *dict) {
         [self.contentCollectionView footerEndRefreshing];
         if ([dict[@"isSuccess"] boolValue]) {
             NSMutableArray *array = [SSearchProductModel modelArrayForCategaryDataArray:dict[@"results"]];
             if (_pageIndex == 0) {
                 if(!iserror)
                 {
                     if([array count]==0)
                     {
                         [self initNoDataView];
                     }
                     else
                     {
                         [self  removeNoDataView];
                     }
                 }
   
                 self.productListArray = array;
             }else{
                 [self.productListArray addObjectsFromArray:array];
                 [self.contentCollectionView reloadData];
             }
         }else{
             [Toast makeToast:dict[@"message"] duration:1.5 position:@"center"];
         }

     } failed:^(NSError *error) {
            [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
     }];
    
    /*
    [HttpRequest productPostRequestPath:@"Product" methodName:@"ProductClsCommonSearchFilter" params:dictionary success:^(NSDictionary *dict) {
        [self.contentCollectionView footerEndRefreshing];
        if ([dict[@"isSuccess"] boolValue]) {
            NSMutableArray *array = [SSearchProductModel modelArrayForCategaryDataArray:dict[@"results"]];
            if (_pageIndex == 0) {
                if([array count]==0)
                {
                    [self initNoDataView];
                }
                else
                {
                    [self  removeNoDataView];
                }
                self.productListArray = array;
            }else{
                [self.productListArray addObjectsFromArray:array];
                [self.contentCollectionView reloadData];
            }
        }else{
            [Toast makeToast:dict[@"message"] duration:1.5 position:@"center"];
        }
    } failed:^(NSError *error) {
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
    */
}
- (void)setProductListArray:(NSMutableArray *)productListArray{
    _productListArray = productListArray;
    [self.contentCollectionView reloadData];
}
- (void)setupNavbar {
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backHome:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"晒单" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClicked)];
//    self.navigationItem.rightBarButtonItem = right;
    
    self.title=@"每日新品";
    if (self.brandId!=nil||self.brandId.length!=0)
    {
//        NSString *titleStr=nil;
//        if(_isCanSocial)//如果是社交属性 则是更多没有brander条  如果是购物属性 则是 品牌馆
//        {
//           titleStr=@"更多";
//            _navigationRightItem = [[UIBarButtonItem alloc] initWithTitle:titleStr style:UIBarButtonItemStylePlain target:self action:@selector(gotoBrandLibrary)];
//            self.navigationItem.rightBarButtonItems = @[_navigationRightItem] ;
//        }
//        else
//        {
////           titleStr= @"品牌馆";// 跳转会无限跳 品牌馆先禁掉
//            titleStr =@"";
//            
//        }
        //rightBarItem 添加分享
        UIButton*_navigationShareButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationShareButton setFrame:CGRectMake(self.view.frame.size.width-44, 20,88/2,88/2)];
        [_navigationShareButton addTarget:self action:@selector(onlist:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationShareButton setImage:[UIImage imageNamed:@"Unico/icon_navigation_share"] forState:UIControlStateNormal];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithCustomView:_navigationShareButton];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, shareItem];
        self.title=@"";//
        if (_ptConfigMode) {
            
            self.title=_ptConfigMode.name;
        }else
        {
            self.title= _brandStoryDeatilModel.english_name;
        }
    }

}
-(void)onlist:(id)sender
{
    ShareData *shareData = [[ShareData alloc]init];
    if (_ptConfigMode) {
        
        shareData.title=_ptConfigMode.name;
        shareData.descriptionStr = _ptConfigMode.info;
        
    }else
    {
        NSString *shareTitle=[NSString stringWithFormat:@"%@", _brandStoryDeatilModel.english_name];
        
        shareData.title=[Utils getSNSString:shareTitle];
        shareData.descriptionStr =@"";
    }


    //        NSString *url=[SHOPPING_GUIDE_ITF createShareGoodsUrl:sns.ldap_uid CollocationID:@"" ProductClsID:[Utils getSNSString:[NSString stringWithFormat:@"%@",self.contentModel.goodsDetailModel.clsInfo.aID]] designerId:@""];
    //单品分享url
    
    NSString *shareUrl=[NSString stringWithFormat:@"%@",U_SHARE_BRAND_URL];
    NSString *detailUrlStr= [NSString stringWithFormat:@"%@",shareUrl];
    NSString *lastStr = [detailUrlStr substringFromIndex:detailUrlStr.length-1];
    
    NSString *noLastUrlStr=detailUrlStr;
    
    if ([lastStr isEqualToString:@"?"]) {
        
        noLastUrlStr = [detailUrlStr substringToIndex:detailUrlStr.length-1];
        
    }
    
    shareUrl=[NSString stringWithFormat:@"%@",noLastUrlStr];
    
    NSString *jsonWeb =[NSString stringWithFormat:@"&f_code=brand_detail&brandCode=%@",self.brandId];
    
    NSString * web_urlStr = [shareUrl stringByAppendingFormat:@"%@",jsonWeb];
    
    
    
    shareData.shareUrl = [NSString stringWithFormat:@"%@",web_urlStr];
    
    shareData.image = [Utils reSizeImage:brandImgView.image toSize:CGSizeMake(57,57)];

    ShareRelated *view = [ShareRelated sharedShareRelated];
    [view showInTarget:self withData:shareData];
 
}
-(void)backHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarClicked {
    [self gotoBrandLibrary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - collectionVIew delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;

    count = _productListArray.count;

    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);

    size.height = 300 * UI_SCREEN_WIDTH/ 375.0;

    return size;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productCellIdentifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    if (indexPath.row<[_productListArray count])
    {
        cell.contentModel = _productListArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SActivityBrandListModel *model = _productListArray[indexPath.row];
    SProductDetailViewController *controller = [SProductDetailViewController new];
//    controller.productID = [NSString stringWithFormat:@"%@",model.aID];
    controller.productID = [NSString stringWithFormat:@"%@",model.code];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    return reusableView;
}

#pragma mark ADD Header AND Footer
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(void)gotoBrandLibrary
{
    if (self.brandId!=nil||self.brandId.length!=0)
    {
        if(_isCanSocial)//如果是社交属性 则是更多没有brander条  如果是购物属性 则是 品牌馆
        {
            //自己  这里应该会有问题 不断的循环引用？
            DailyNewViewController *daily=[[DailyNewViewController alloc]init];
            daily.isCanSocial=NO;
            daily.brandId=self.brandId;
            [self.navigationController pushViewController:daily animated:YES];
            
        }
        else
        {
            //品牌馆跳转
            BrandDetailViewController *vc = [BrandDetailViewController new];
            vc.brandId = _brandId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
- (void)likeBrand:(id)sender{
    
    SDataCache *dataChche = [SDataCache sharedInstance];
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    if (likeBtn.selected){
        [dataChche delLikeBrand:dataChche.userInfo[@"token"] brandId:[NSString stringWithFormat:@"%@",self.brandId] complete:^(id data) {
            if ([data intValue] == 1) {
                [likeBtn setSelected:NO];
                   [self setHightPic];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"brandRefresh" object:nil userInfo:nil];
                NSString *string = [NSString stringWithFormat:@"取消喜欢%@成功！", _dailyHeadModel.english_name];
                [Toast makeToastSuccess:string];
            }
        }];
    }else{
        [dataChche likeBrand:dataChche.userInfo[@"token"] brandId:[NSString stringWithFormat:@"%@",self.brandId]  complete:^(id data) {
            if ([data intValue] == 1) {
                NSString *string = [NSString stringWithFormat:@"成功喜欢%@！", _dailyHeadModel.english_name];
                [likeBtn setSelected:YES];
                [self setHightPic];
                [Toast makeToastSuccess:string];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"brandRefresh" object:nil userInfo:nil];
                
                //APP store弹出框弹出条件：用户点赞，收藏，加入心愿单之后3秒
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [SUTILITY_TOOL_INSTANCE showPraiseBox];
                });
            }
        }];
    }
}
#pragma mark - UIScrollViewDelegate接口

/**
 *   实现标题栏的悬停处理
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.height)
    {
        //出现加载更多的动画了 会出现闪烁，这里直接返回
        if (_productListArray.count==0) {
            [brandImgView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, brandImgView.frame.size.height)];
            [backView setFrame:CGRectMake(0, brandImgView.frame.size.height+brandImgView.frame.origin.y, backView.frame.size.width, backView.frame.size.height)];
            [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-backView.frame.size.height- backView.frame.origin.y)];
        }
        return;
    }
    if (scrollView.contentOffset.y>64&&scrollView.contentOffset.y<(brandImgView.height-64)) {//+backView.height
        [brandImgView setFrame:CGRectMake(0, -scrollView.contentOffset.y, UI_SCREEN_WIDTH, brandImgView.frame.size.height)];
        [backView setFrame:CGRectMake(0, -scrollView.contentOffset.y+brandImgView.frame.size.height, backView.frame.size.width, backView.frame.size.height)];
        [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-(backView.frame.origin.y+backView.frame.size.height))];
    }
    if (scrollView.contentOffset.y <0)
    {
        [brandImgView setFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, brandImgView.frame.size.height)];
        [backView setFrame:CGRectMake(0, brandImgView.frame.size.height+brandImgView.frame.origin.y, backView.frame.size.width, backView.frame.size.height)];
        [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-backView.frame.size.height- backView.frame.origin.y)];
    }
    if (scrollView.contentOffset.y>(brandImgView.height-64)) {//(brandImgView.height+backView.height)
       
        [brandImgView setFrame:CGRectMake(0, -brandImgView.frame.size.height, UI_SCREEN_WIDTH, brandImgView.frame.size.height)];
        [backView setFrame:CGRectMake(0, 64, backView.frame.size.width, backView.frame.size.height)];
        [self.contentCollectionView setFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-(backView.frame.origin.y+backView.frame.size.height))];
    }
}


@end
