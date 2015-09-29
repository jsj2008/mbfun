//
//  MyLikeViewController.m
//  Wefafa
//
//  Created by fafatime on 14-9-15.
//  Copyright (c) 2014年 fafatime. All rights reserved.
//

#import "MyLikeViewController.h"
#import "Utils.h"
#import "MBCustomClassifyModelView.h"
#import "AttendCustomButton.h"
#import "NavigationTitleView.h"
#import "Toast.h"
#import "MBShoppingGuideInterface.h"
#import "MyLikeCollocationTableView.h"
#import "MyLikeGoodsTableView.h"
#import "ImageWaterView.h"
#import "JSONKit.h"
#import "JSON.h"
//#import "CollocationDetailViewController.h"
//#import "MBGoodsViewController.h"
#import "HeadBtnView.h"
#import "SelectedSubContentView.h"
#import "MBCollocationDetailsController.h"
#import "SUtilityTool.h"
#import "Utils.h"
#import "SProductDetailViewController.h"
#import "SMainTopicTableView.h"
#import "SDataCache.h"

#import "SBrandStoryDetailModel.h"
#import "MyLikeBrandTableViewCell.h"
#import "STopicDetailViewController.h"
#import "SBrandSotryViewController.h"
#import "SSearchProductCollectionView.h"
#import "SSearchProductModel.h"
#import "BrandDetailViewController.h"
#import "DailyNewViewController.h"
#import "MJRefresh.h"

@interface MyLikeViewController () <SelectedSubContentViewDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UIScrollView *backScrollView;
    AttendCustomButton * otherBtn;
    HeadBtnView *headBtnV;
    int just;
    NSDictionary *transRootDic;
    
    UIImageView *noCodeImgView;
    NSMutableArray *collArrayImage ;
    //    NSObject *deleteobject;//要删除的搭配
    NSObject *goodObject;
    //    NoDataView *nodataView;
    int collocationPage;
    int goodPage;
    //    NSString *pageSize;
    NSArray *cacheArray;
    UIButton *collocationBtn;
    UIButton *goodBtn;
    
    BOOL _isTouchGoodsList;
    BOOL _isReloadList;
    
    UIView *placeholdView;
    
    
    UIScrollView *_homeScrollView;
    UIView *_btnView;
    CALayer *_btnBottomLayer;
    
    NSMutableArray *_arrayBtn;
    NSInteger _selectedIndex;
    int brandPageIndex;//品牌页
    NSInteger itemPageIndex;//单品
    
}

@property (nonatomic, strong) SelectedSubContentView *headerSelectedView;
@property (nonatomic, weak) SSearchProductCollectionView *productCollectionView;
@property (nonatomic, strong) NSMutableArray *arrayBrandList;
@end

@implementation MyLikeViewController
@synthesize use_Id;
@synthesize isMy;
@synthesize brandTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [_homeScrollView setContentOffset:CGPointMake(_selectedIndex * UI_SCREEN_WIDTH, 0) animated:YES];
}
-(void)setupNavbar
{
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    if(isMy){
        self.title=@"我的收藏";
    }else {
        self.title=@"Ta的收藏";
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshDelete" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"brandRefresh" object:nil];
    
}

-(void)initView
{
    CGRect headrect=CGRectMake(0,0,self.headView.frame.size.width,self.headView.frame.size.height);
    NavigationTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    [view createTitleView:headrect delegate:self selectorBack:@selector(backHome:) selectorOk:nil selectorMenu:nil];
    
    CGRect frame = CGRectMake(0, 64, UI_SCREEN_WIDTH, 40);
    NSArray *nameArray = @[@"品牌",@"单品"];
    self.headerSelectedView = [[SelectedSubContentView alloc]initWithFrame:frame AndNameArray:nameArray];
    self.headerSelectedView.hidden = NO;
    [self.headerSelectedView scrollViewEndAction:0];
    self.headerSelectedView.delegate = self;
    self.headerSelectedView.isShowAnimation=YES;
    [self.view addSubview:self.headerSelectedView];
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = COLOR_C9.CGColor;
    layer.frame = CGRectMake(0, self.headerSelectedView.size.height - 0.5, self.headerSelectedView.size.width, 0.5);
    layer.zPosition = 5;
    [self.headerSelectedView.layer addSublayer:layer];
    
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.headerSelectedView.frame.size.height+self.headerSelectedView.frame.origin.y, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.headerSelectedView.frame.size.height-self.headerSelectedView.frame.origin.y)];
    _homeScrollView.backgroundColor = COLOR_NORMAL;
    _homeScrollView.showsHorizontalScrollIndicator=NO;
    _homeScrollView.showsVerticalScrollIndicator=NO;
    _homeScrollView.scrollEnabled = NO;
    _homeScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*2, 0);
    [self.view addSubview:_homeScrollView];
    
    
    //品牌
    self.brandTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, _homeScrollView.frame.size.height) style:UITableViewStylePlain];
    self.brandTableView.backgroundColor=[UIColor clearColor];
    self.brandTableView.delegate=self;
    self.brandTableView.dataSource=self;
    self.brandTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.brandTableView.tableFooterView=[[UIView alloc]init];
    [self addBrandFooter];
    [self addbrandHeader];
    [_homeScrollView addSubview: self.brandTableView];
    
    
     UIEdgeInsets edgeInset = UIEdgeInsetsMake(10, 0, 0, 0);
    __unsafe_unretained typeof(self) p = self;
    SSearchProductCollectionView *productCollectionView = [[SSearchProductCollectionView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, _homeScrollView.frame.size.height)];
    productCollectionView.contentInset=edgeInset;
    [productCollectionView addFooterWithTarget:self action:@selector(requestAddData)];
    productCollectionView.opration = ^(NSIndexPath *indexPath, NSArray *array){
        SSearchProductModel *model = array[indexPath.row];
        SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
        controller.productID = [NSString stringWithFormat:@"%@",model.code];
        [p.navigationController pushViewController:controller animated:YES];
    };
    productCollectionView.isShowPrice = YES;
    [_homeScrollView addSubview:productCollectionView];
    _productCollectionView = productCollectionView;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deleteClick:)
//                                                 name:@"refreshDelete"
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(productRefresh:)
                                                 name:@"productRefresh" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(brandRefresh:)
                                                 name:@"brandRefresh"
                                               object:nil];
    [self.view setBackgroundColor:COLOR_NORMAL];
    
}
-(void)productRefresh:(NSNotification *)sender
{
    _productCollectionView.contentArray=[[NSArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestAddData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            
        });
    });
}
-(void)brandRefresh:(NSNotification*)sender
{
    [self requestBrandWithNextPage:NO];
}

-(void)requestBrandWithNextPage:(BOOL)isnext;
{
    if (isnext) {
        brandPageIndex++;
    }
    else
    {
        brandPageIndex=0;
    }
    
    if(placeholdView)
       [placeholdView removeFromSuperview];
    
    SDataCache *dataCache = [SDataCache sharedInstance];
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";

    NSDictionary *params = @{
                             @"m":@"BrandMb",
                             @"a":@"getMyLikeBrandListWithItem",
                             @"token":userToken,
                             @"userId":use_Id,
                             @"page":@(brandPageIndex),
                             @"num":@(10)
                             };
    [dataCache quickGet:SERVER_URL parameters:params success:^(AFHTTPRequestOperation *operation, id object) {
        
        [self.brandTableView footerEndRefreshing];
        [self.brandTableView headerEndRefreshing];
        
        NSArray *dataArray = object[@"data"];
        NSLog(@"data====%@",dataArray);
        if (brandPageIndex == 0) {
            
            _arrayBrandList = [SBrandStoryDetailModel modelArrayForDataArray:dataArray];
            if ([dataArray count]==0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [self configNotifyViewWithTitle:@"您尚未收藏品牌"  Selectedindex:0];
                });
            }
            
        }else
        {
            if (dataArray.count <= 0) {
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //
                //                    [Toast makeToast:@"已经到底了！" duration:1.5 position:@"center"];
                //
                //                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Toast hideToastActivity];
                    [self.brandTableView reloadData];
                });
                
                return;
            }
            NSArray *newBrandList=[SBrandStoryDetailModel modelArrayForDataArray:dataArray];
            [_arrayBrandList addObjectsFromArray:newBrandList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            [self.brandTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        brandPageIndex--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [Toast hideToastActivity];
            [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
            [self.brandTableView footerEndRefreshing];
            [self.brandTableView headerEndRefreshing];
        });
        
    }];
}
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    
    if (index == 0) {
        _selectedIndex=0;
        if (_arrayBrandList.count == 0) {
            [self requestBrandWithNextPage:NO]; //品牌
        }
    }else if (index == 1){
        _selectedIndex=1;
        if (_productCollectionView.contentArray.count == 0) {
            [self requestAddData];
        }
    }
    [_homeScrollView setContentOffset:CGPointMake(index * UI_SCREEN_WIDTH, 0) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _headView.backgroundColor=TITLE_BG;
    transRootDic = [NSDictionary new];
    cacheArray = [[NSArray alloc]init];
    
    collocationPage = 1;
    goodPage = 1;
    [self setupNavbar];
    
    [self initView];
    
//    NSString *userId=[NSString stringWithFormat:@"%@",self.use_Id];
    collocationList=[[NSMutableArray alloc]init];
    goodsList=[[NSMutableArray alloc]init];
    
//    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    
    collArrayImage = [[NSMutableArray alloc]init];
    [self requestBrandWithNextPage:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [_homeScrollView setContentOffset:CGPointMake(_selectedIndex * UI_SCREEN_WIDTH, 0) animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_isReloadList) {
//        if (_isTouchGoodsList) {
//            [self.goodWaterView headerBeginRefreshing];
//        }else{
//            [self.waterView headerBeginRefreshing];
//        }
//        _isReloadList = NO;
//    }
}

- (void)configNotifyViewWithTitle:(NSString *)title Selectedindex:(NSInteger)selectedindex
{
    
    [_homeScrollView setBackgroundColor:COLOR_NORMAL];
    [self.productCollectionView setBackgroundColor:COLOR_NORMAL];
    
    [self.view setBackgroundColor:COLOR_NORMAL];
    [placeholdView removeFromSuperview];
    
    placeholdView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH*selectedindex,0, SCREEN_WIDTH, self.view.frame.size.height-104)];
    [placeholdView setBackgroundColor:COLOR_NORMAL];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (placeholdView.frame.size.height-20)/2, SCREEN_WIDTH, 20)];
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setTag:100];
    [messageLabel setText:@"暂无收藏"];
    [placeholdView addSubview:messageLabel];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, messageLabel.frame.origin.y-messageLabel.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/ico_nocollection"]];
    imgView.contentMode=UIViewContentModeScaleAspectFill;
    [placeholdView addSubview:imgView];
    [_homeScrollView addSubview:placeholdView];
    
    
    //    }
    if (title) {
        UILabel *label = (UILabel *)[placeholdView viewWithTag:100];
        [label setText:title];
    }
}
#pragma mark - collection

-(void)addBrandFooter
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.brandTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf requestBrandWithNextPage:YES];
        });
    }];
}
-(void)addbrandHeader
{
    __weak typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.brandTableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //            NSArray *array=[weakSelf refreshDataWithPageIndex:2 WithCollocation:NO];
            [weakSelf requestBrandWithNextPage:NO];
        });
    }];
}
- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //是否有品牌明细，如果没有就隐藏明细界面
    SBrandStoryDetailModel *model=_arrayBrandList[indexPath.row];
    if(!model.itemList||model.itemList.count==0)
        return 78;
    else
        return 195 ;
}
//* UI_SCREEN_WIDTH/ 375
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayBrandList  count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLikeBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLikeBrandTableViewCellIdentifier"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyLikeBrandTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.parentVc=self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model=_arrayBrandList[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_homeScrollView setContentOffset:CGPointMake(_selectedIndex * UI_SCREEN_WIDTH, 0) animated:YES];
    
    SBrandStoryDetailModel *model = _arrayBrandList[indexPath.row];
    DailyNewViewController *dailyNewVC = [[DailyNewViewController alloc]init];
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",model.brand_code];
    dailyNewVC.brandStoryDeatilModel = model;
    dailyNewVC.isCanSocial = NO;//不是社交
    [self.navigationController pushViewController:dailyNewVC animated:YES];
}
//TODO:collectionView请求数据
- (NSArray *)refreshDataWithPageIndex:(int)pageIndex WithCollocation:(BOOL)isCollocation
{
    NSString *userId=[NSString stringWithFormat:@"%@",self.use_Id];
    NSMutableString *returnMessage=[[NSMutableString alloc]init];
    NSMutableArray *collArrayImageS = [[NSMutableArray alloc]init];
    NSMutableArray *returnList=[[NSMutableArray alloc]init];
    NSString *source_type;
    int indexPage;
    NSString *urlName;
    if (isCollocation) {
        
        source_type = @"2";
        collocationPage ++;
        indexPage=collocationPage;
        urlName=@"FavoriteCollocationFilter";
    }
    else
    {
        source_type=@"1";
        goodPage++;
        indexPage=goodPage;
        urlName =@"FavoriteProductClsFilter";
    }
    if (pageIndex==2) {
        //搭配跟单品为同一个接口 SOURCE_TYPE 分别
        //搭配,@"pageSize":pageSize,@"source_type":source_type,
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:urlName param:@{@"userId":userId, @"LoginUserId": sns.ldap_uid,@"pageIndex":[NSNumber numberWithInt:indexPage], @"pageSize": @15} responseList:returnList  responseMsg:returnMessage])
        {
            for (int i=0; i<[returnList count]; i++) {
                NSDictionary *dataD = [returnList objectAtIndex:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:!isCollocation WithBrand:NO];
                    NSNumber *favrite = dataD[@"favoritCount"];
                    imageInfo.favriteCount = favrite.stringValue;
                    [collArrayImageS addObject:imageInfo];
                }
            }
        }
    }
    else
    {
        if (isCollocation) {
            
            source_type = @"2";
            collocationPage=1;
            //            indexPage=collocationPage;
            indexPage=1;
        }
        else
        {
            source_type=@"1";
            goodPage=1;
            //            indexPage=goodPage;
            indexPage=1;
        }
        //搭配跟单品为同一个接口 SOURCE_TYPE 分别
        //搭配,@"pageSize":pageSize@"source_type":source_type,
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:urlName param:@{@"userId":userId,
                                                                  @"LoginUserId": sns.ldap_uid,
                                                                  @"pageIndex":[NSNumber numberWithInt:1],
                                                                  @"pageSize": @15}
                                     responseList:returnList  responseMsg:returnMessage])
        {
            for (int i=0; i<[returnList count]; i++) {
                NSDictionary *dataD = [returnList objectAtIndex:i];
                if (dataD) {
                    ImageInfo *imageInfo = [[ImageInfo alloc]initWithDictionary:dataD WithGood:!isCollocation WithBrand:NO];
                    NSNumber *favrite = nil;
                    if(dataD[@"favoritCount"]){
                        favrite = dataD[@"favoritCount"];
                    }else{
                        favrite = dataD[@"collectionList"][0][@"statisticsFilterList"][0][@"favoritCount"];
                    }
                    imageInfo.favriteCount = favrite.stringValue;
                    [collArrayImageS addObject:imageInfo];
                }
            }
            
        }
    }
    
    return collArrayImageS;
}

-(void)clickColloctBtn:(UIButton *)sender
{
    just=10;
    [headBtnV.colloctBtn setBackgroundColor:[UIColor blackColor]];
    [headBtnV.goodBtn setBackgroundColor:[UIColor whiteColor]];
    headBtnV.colloctBtn.selected=YES;
    headBtnV.goodBtn.selected=NO;
    [backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
    [collocationBtn setBackgroundColor:[UIColor redColor]];
    [goodBtn setBackgroundColor:[UIColor blackColor]];
    
}
-(void)clickGoodBtn:(UIButton *)sender
{
    just=10;
    headBtnV.colloctBtn.selected=NO;
    headBtnV.goodBtn.selected=YES;
    [headBtnV.goodBtn setBackgroundColor:[UIColor blackColor]];
    [headBtnV.colloctBtn setBackgroundColor:[UIColor whiteColor]];
    [backScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH,0) animated:YES];
    
    [collocationBtn setBackgroundColor:[UIColor blackColor]];
    [goodBtn setBackgroundColor:[UIColor redColor]];
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    CGFloat scrollViewContentWidth = scrollView.contentSize.width - SCREEN_WIDTH;
    //    CGFloat scrollViewLocation = scrollView.contentOffset.x;
    //    CGFloat percentage = scrollViewLocation / scrollViewContentWidth;
    //    [self.headerSelectedView setLineLocationPercentage:percentage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    int page = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    //    [self.headerSelectedView scrollViewEndAction:page];
}
#pragma MBCustomClassifyModelView delegate
-(void)TabItemClick:(id)sender button:(id)button
{
    UIButton *btn=(UIButton *)button;
    //subFunctionArray[btn.tag];
    UIView *view = [sender getButtonActionViewForIndex:btn.tag];
    if (view)
    {
        [_viewCenter bringSubviewToFront:view];
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backHome:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////
- (void)tvColl_OnLoadMoreMessage:(MyLikeCollocationTableView*)sender eventData:(id)eventData
{
}


- (void)tvColl_OnLoadNewMessage:(MyLikeCollocationTableView*)sender eventData:(id)eventData
{
    NSInteger actionid=[customClassifyModelV indexOfActiveButton];
    
    [collocationList removeAllObjects];
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"FavoriteFilter" param:@{@"userId":userId,@"source_type":@"2"} responseList:collocationList  responseMsg:returnMessage])
        {
            //,@"pageSize":pageSize
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLikeCollocationTableView *view=(MyLikeCollocationTableView *)[customClassifyModelV getButtonActionViewForIndex:actionid];
            view.dataArray=collocationList;
            [Toast hideToastActivity];
        });
    });
}

-(void)tvcell_OnDidFavrite:(ImageWaterView*)sender RowMessage:(id)message
{
}
//////////////////////////
- (void)tvGoods_OnLoadMoreMessage:(MyLikeGoodsTableView*)sender eventData:(id)eventData
{
    
}

- (void)tvGoods_OnLoadNewMessage:(MyLikeGoodsTableView*)sender eventData:(id)eventData
{
    NSInteger actionid=[customClassifyModelV indexOfActiveButton];
    
    [goodsList removeAllObjects];
    [Toast makeToastActivity:@"正在加载..." hasMusk:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *userId=[NSString stringWithFormat:@"%@",sns.ldap_uid];
        NSMutableString *returnMessage=[[NSMutableString alloc]init];
        //商品,@"pageSize":pageSize
        if ([SHOPPING_GUIDE_ITF requestGetUrlName:@"FavoriteFilter" param:@{@"userId":userId,@"source_type":@"1"} responseList:goodsList  responseMsg:returnMessage])
        {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            MyLikeGoodsTableView *view=(MyLikeGoodsTableView *)[customClassifyModelV getButtonActionViewForIndex:actionid];
            view.dataArray=goodsList;
            [Toast hideToastActivity];
        });
    });
}

- (void)tvGoods_OnDidSelected:(MyLikeGoodsTableView*)sender RowMessage:(id)message
{
    ImageInfo *info = message;
    NSMutableDictionary *showMessage=[NSMutableDictionary new];
    showMessage = [NSMutableDictionary dictionaryWithDictionary:info.imageData];
    
    //
}
- (void)goodsListScrollView:(UIScrollView*)scrollView
{
    
}
-(void)requestAddData{
    if(placeholdView)
        [placeholdView removeFromSuperview];
    
    itemPageIndex=(_productCollectionView.contentArray.count+19)/20+1;
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    NSDictionary *data = @{@"m": @"Product",
                           @"a": @"FavoriteProductClsFilter",
                           @"token":userToken,
                           @"userId":use_Id,
                           @"pageIndex":@(itemPageIndex),
                           @"PageSize": @20};
    
    NSLog(@"params－－－%@",data);
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:SERVER_URL parameters:data success:^(AFHTTPRequestOperation* operation, id responseObject) {
        [Toast hideToastActivity];
        [_productCollectionView footerEndRefreshing];
        NSLog(@"data－－－%@",responseObject);
        if ([responseObject[@"isSuccess"] boolValue]) {
            NSMutableArray *mutableAry = responseObject[@"results"];
            if(mutableAry.count==0&&itemPageIndex==1){
                [self configNotifyViewWithTitle:@"您尚未收藏单品" Selectedindex:1];
                return;
            }
            if (itemPageIndex == 1) {
                _productCollectionView.contentArray=[mutableAry copy];
            }else{
                NSMutableArray *ary=[_productCollectionView.contentArray mutableCopy];
                [ary addObjectsFromArray:mutableAry];
                _productCollectionView.contentArray=[ary copy];
            }
        }else{
            [Toast makeToast:responseObject[@"message"] duration:1.5 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        [_productCollectionView footerEndRefreshing];
        [Toast makeToast:kNoneInternetTitle duration:1.5 position:@"center"];
    }];
}
@end
