//
//  SMineProductViewController.m
//  Wefafa
//
//  Created by Jiang on 15/8/26.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SMineProductViewController.h"
#import "WaterFLayout.h"
#import "SMinProductCell.h"
#import "SMineProduct.h"

#import "UIScrollView+MJRefresh.h"
#import "SUtilityTool.h"
#import "WeFaFaGet.h"

#import "SDataCache.h"
#import "Toast.h"

#import "SFilterBrandController.h"
#import "SMIneAddProductViewController.h"
#import "SProductDetailViewController.h"
#import "SNoneProductDetailViewController.h"
#import "SScrollButtonTabBar.h"

#import "SMineProductModel.h"

static NSString *cellId = @"cellIdentifier";
static CGFloat kSelectViewH = 44.f;

@interface SMineProductViewController ()<UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSInteger _sortSelectedIndex; // 当前Btn的索引
    BOOL _isSortSequence;  // 价格排序
    NSInteger _pageIndex;
    NSInteger _previousIndex; // 记录之前的btn的索引
    CALayer *_selectBtnLayer;
    
    
    UIView *_showNoneData;
    NSInteger _cid;          //分类商品的ID
    NSInteger _preCid;       //用于记住分类商品前一个的ID
}
//
@property (weak, nonatomic) UICollectionView *contentCollectionView;
@property (weak, nonatomic) UIView *selectedContentView;
@property (weak, nonatomic) SScrollButtonTabBar *scrollBtnTabBar;
//
@property (nonatomic, strong) NSMutableArray *productDataArrM;
@property (nonatomic, strong) NSMutableArray *btnArrM;

@property (nonatomic, strong) NSMutableArray *btnBar_DataArray; //顶部条数据
@end

@implementation SMineProductViewController
@synthesize productDataArrM = _productDataArrM;

#pragma mark -
#pragma mark - lazy load
- (NSMutableArray *)btnArrM
{
    if (!_btnArrM) {
        _btnArrM = [NSMutableArray array];
    }
    return _btnArrM;
}

- (void)setProductDataArrM:(NSMutableArray *)productDataArrM
{
    _productDataArrM = productDataArrM;
    [self.contentCollectionView reloadData];
}

- (NSMutableArray *)productDataArrM
{
    if (!_productDataArrM) {
        _productDataArrM = [NSMutableArray array];
    }
    return _productDataArrM;
}

#pragma mark -
#pragma mark - vc life cyc
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarHidden = NO;
    [self initNaVigationBar];
    
    [self requestProductListData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewDidAppear:animated];
}

- (void)initNaVigationBar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UILabel *tempView = nil;
    CGRect navRect = self.navigationController.navigationBar.frame;
    // back bar button
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/common_navi_mixblack.png"] forBarMetrics:UIBarMetricsDefault];
    
    tempView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    tempView.textColor = COLOR_C3;//[UIColor whiteColor];
    tempView.textAlignment = NSTextAlignmentCenter;
    tempView.font = FONT_T2;
    NSString *titleStr = @"";
    
    if( !_personId ){
        _personId = sns.ldap_uid;
    }
    
    if ([self.personId isEqualToString:sns.ldap_uid]) {
        // 我的商店
        UIBarButtonItem *right =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/上传单品44"]
                                         style:UIBarButtonItemStylePlain
                                        target:self action:@selector(personProduct)];
        self.navigationItem.rightBarButtonItem = right;
        titleStr = @"我的商品";
    } else {
        // ta的商店
        titleStr = @"Ta的商品";
    }
    tempView.text = titleStr;
    self.navigationItem.titleView = tempView;
}

#pragma mark -
#pragma mark - 跳转到录入单品界面
- (void)personProduct
{
    SMIneAddProductViewController *adddProductVc = [[SMIneAddProductViewController alloc] init];
//    adddProductVc.back = ^{
//        [self requestProductListData];
//        [Toast makeToastSuccess:@"上传成功！"];
//    };
    [self.navigationController pushViewController:adddProductVc animated:YES];
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_C4;
    _pageIndex = 1;
    _preCid = 0;
    // Do any additional setup after loading the view.
    [self createCollectionView];
    
//    [self createSelectView];
    [self requestBtnBarData];
    /*
    [self initSelectView];
    */

    //默认请求全部商品
    _cid = 0;
    // 加载数据
//    [self requestProductListData];
}

- (void)requestBtnBarData {
//    m=Product&a=getProductCategoryList&cid=" + cid
    __weak __typeof(self) ws = self;
    NSDictionary *param = @{
                            @"m" : @"Product",
                            @"a" : @"getProductCategoryList",
                            @"cid" : @"0"
                            };
    [SDATACACHE_INSTANCE quickGet:SERVER_URL parameters:param success:^(AFHTTPRequestOperation *operation, id object) {
        if ([object isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            NSDictionary *dictionary = object;
            if ([dictionary[@"status"] intValue] == 1) {
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *dic in dictionary[@"data"]) {
                    SMineProductModel *model = [[SMineProductModel alloc] initWithDic:dic];
                    [array addObject:model];
                }
                _btnBar_DataArray = [array mutableCopy];
//                self.pageDictM = ;
                [ws initSelectView];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//分类条不需要
- (void)initSelectView
{
    NSMutableArray *titleArr = [NSMutableArray new];
    for (SMineProductModel *model in _btnBar_DataArray) {
        [titleArr addObject:model.name];
    }
    //默认第一个为"全部"
    [titleArr insertObject:@"全部" atIndex:0];
    
    CGRect rect = CGRectMake(0, 64, UI_SCREEN_WIDTH, kSelectViewH);
    SScrollButtonTabBar *scrollBtnBar = [[SScrollButtonTabBar alloc] initWithFrame:rect];
    scrollBtnBar.titles = titleArr;
    scrollBtnBar.backgroundColor = COLOR_C3;
    scrollBtnBar.autoLayoutButtons = YES;
    [self.view addSubview:scrollBtnBar];
    self.scrollBtnTabBar = scrollBtnBar;
    [self.scrollBtnTabBar addTarget:self action:@selector(changeProductList:) forControlEvents:UIControlEventValueChanged];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, kSelectViewH-0.5f, UI_SCREEN_WIDTH, 0.5);
    layer.backgroundColor = COLOR_C9.CGColor;
    [self.scrollBtnTabBar.layer addSublayer:layer];
}

- (void)createCollectionView
{
    WaterFLayout *layout = [[WaterFLayout alloc] init];
    layout.minimumColumnSpacing = 5.f;
    layout.minimumInteritemSpacing = 5.f;// 上下间距
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    CGRect collectionViewF = self.view.bounds;
    collectionViewF.origin.y += (64+44);
    collectionViewF.size.height -= (64+44);//kSelectViewH;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewF
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = COLOR_C4;//[UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SMinProductCell class]
       forCellWithReuseIdentifier:cellId];
    collectionView.alwaysBounceVertical = YES;
    [collectionView addFooterWithTarget:self action:@selector(requestAddData)];
    
    
    [self.view addSubview:collectionView];
    
    self.contentCollectionView = collectionView;
}

- (void)configNotifyViewWithTitle:(NSString *)title
{
//    [self.view setBackgroundColor:COLOR_C4];
    [_showNoneData removeFromSuperview];
    
    _showNoneData = [[UIView alloc] initWithFrame:CGRectMake(0,64+kSelectViewH, SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-kSelectViewH)];
    [_showNoneData setBackgroundColor:COLOR_C4];
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_showNoneData.frame.size.height-20)/2, SCREEN_WIDTH, 20)];
    [messageLabel setFont:FONT_t5];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setTextColor:COLOR_C6];
    [messageLabel setTag:100];
    [messageLabel setText:@"暂无商品"];
    [_showNoneData addSubview:messageLabel];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, messageLabel.frame.origin.y-messageLabel.frame.size.height-60, 60, 60)];
    [imgView setImage:[UIImage imageNamed:@"Unico/ico_noitem"]];//ico_noitem
    [_showNoneData addSubview:imgView];//btn-itemCollection
    
    
    [self.view addSubview:_showNoneData];
    
    if (title) {
        NSString *titleStr = @"";
        if ([self.personId isEqualToString:sns.ldap_uid]) {
            titleStr = @"您还未发布过商品";
        } else {
            titleStr = @"Ta还未发布过商品";
        }
        UILabel *label = (UILabel *)[_showNoneData viewWithTag:100];
        [label setText:titleStr];
    }
}

/*      // @[@"上新", @"折扣", @"价格", @"筛选"];
- (void)createSelectView
{
    CGRect selectViewF = CGRectMake(0, 64, UI_SCREEN_WIDTH, 44);
    UIView *selectView = [[UIView alloc] initWithFrame:selectViewF];
    selectView.layer.masksToBounds = YES;
    selectView.backgroundColor = COLOR_C3;
    [self.view addSubview:selectView];
    _selectedContentView = selectView;
    
    NSArray *titleArr = @[@"上新", @"折扣", @"价格", @"筛选"];
    NSArray *imgArr = @[@"", @"", @"Unico/btn_sort_nomal", @"Unico/btn_selected_icon"];
    NSInteger count = MIN(titleArr.count, imgArr.count);
    
    CGFloat originX = 0.f;
    CGFloat btnW = 70;
    for (NSInteger i=0; i<count; i++) {
        originX = (btnW+ (UI_SCREEN_WIDTH - 75 *count) / (count -1)) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, btnW, 44)];
        NSString *imgName = imgArr[i];
        if (![imgName isEqualToString:@""]) {
            [btn setImage:[UIImage imageNamed:imgName]
                 forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
        }
        if (i == 3) {
            [btn setImage:[UIImage imageNamed:@"Unico/btn_selected_icon_selected"]
                 forState:UIControlStateSelected];
        }
        btn.titleLabel.font = FONT_t4;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C7 forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_C2 forState:UIControlStateSelected];
        btn.tag = 100 +i;
        [btn addTarget:self action:@selector(selectBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:btn];
        [self.btnArrM addObject:btn];
    }
    
    CALayer *selectBtnLayer = [CALayer layer];
    selectBtnLayer.backgroundColor = COLOR_C1.CGColor;
    selectBtnLayer.frame = CGRectMake(0, 41, 40, 3);
    selectBtnLayer.zPosition = 5.f;
    [selectView.layer addSublayer:selectBtnLayer];
    _selectBtnLayer = selectBtnLayer;
    
    [self selectBtnClicked:[_btnArrM firstObject]];
}

#pragma mark -
#pragma mark - btn actions method

- (void)selectBtnClicked:(UIButton *)sender
{
    if (_sortSelectedIndex != 3) {
        _previousIndex = _sortSelectedIndex;
    }
    
    UIButton *tempBtn = _btnArrM[_previousIndex];
    _sortSelectedIndex = sender.tag - 100;
    if (_sortSelectedIndex == 3) {
        if (sender.selected) {
            sender.selected = NO;
            
            tempBtn.selected = YES;
            
            // 恢复数据
            [self requestProductListData];
            
        } else {
            sender.selected = YES;
            
            tempBtn.selected = NO;
            
            // 跳转到筛选界面
            NSLog(@"跳转到筛选界面");
            SFilterBrandController *controller = [[SFilterBrandController alloc]initWithNibName:@"SFilterCollectionViewController" bundle:nil];
//            controller.brandFilterDictionary = self.brandFilterDictionary;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        return ;
    }
    
    for (NSInteger i=0; i<4; i++) {
        UIButton *btn = _btnArrM[i];
        btn.selected = btn == sender;
    }
    
    _pageIndex = 1;
    if (_sortSelectedIndex != 2) {
        _isSortSequence = NO;
        UIButton *btn = _btnArrM[2];
        [btn setImage:[UIImage imageNamed:@"Unico/btn_sort_nomal"]
             forState:UIControlStateNormal];
    } else {
        _isSortSequence = !_isSortSequence;
        NSString *imgName = @"";
        if (_isSortSequence) {
            imgName = @"Unico/btn_sort_top";
        } else {
            imgName = @"Unico/btn_sort_bottom";
        }
        [sender setImage:[UIImage imageNamed:imgName]
                forState:UIControlStateNormal];
    }
    
    CGPoint position = _selectBtnLayer.position;
    position.x = sender.centerX;
    if (_sortSelectedIndex == 2) {
        position.x += 5.f;
    }
    _selectBtnLayer.position = position;
    
    [self requestProductListData];
}
*/

#pragma mark - button bar event
- (void)changeProductList:(UIControl*)sener
{
    if (self.scrollBtnTabBar.selectedIndex == 0) {
        //全部
        _cid = 0;
        _preCid = _cid;
    }else {
        SMineProductModel *model = _btnBar_DataArray[self.scrollBtnTabBar.selectedIndex - 1];
        _preCid = _cid;    // 存放上一个点击获得的Cid
        _cid = [model.aid integerValue];
    }
    [self requestProductListData];
}

#pragma mark -
#pragma mark - get data form server
- (void)requestAddData
{
    _pageIndex = (_productDataArrM.count + 19)/20+1;
    [self requestProductListData];
}

- (void)requestProductListData
{
    if (_preCid != _cid) {  // 切换条目，清空数据且分页置初始值,_preCid = _cid
        _pageIndex = 1;
        [_productDataArrM removeAllObjects];
        _preCid = _cid;
    }
    
    [Toast makeToastActivity:@"加载中，请稍等..." hasMusk:NO];
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    NSDictionary *param = @{
                            @"token":userToken,
                            @"cid":@(_cid),
                            @"userId":[NSString stringWithFormat:@"%@",_personId],
                            @"pageIndex":@(_pageIndex),
                            @"pageSize":@(20)
                                };
    [[SDataCache sharedInstance] get:@"Product" action:@"getUserProductListByCategory"
                               param:param success:^(AFHTTPRequestOperation *operation, id object) {
                                   [Toast hideToastActivity];
                                   [self.contentCollectionView footerEndRefreshing];
                                   
                                   if ([object[@"isSuccess"] integerValue] == 1) {
                                       NSArray * responseArr = (NSArray *)object[@"results"];
                                       if(_pageIndex == 1) {
                                           if (responseArr.count <= 0) {
                                               self.productDataArrM = [NSMutableArray arrayWithArray:@[]];
                                               [self configNotifyViewWithTitle:@"暂无商品"];
                                               return ;
                                           }
                                       }
                                   
                                       [_showNoneData removeFromSuperview];
                                       NSMutableArray *tempArray = [SMineProduct productArrForDataArray:responseArr];
                                       
                                       if (_pageIndex == 1) {
                                           self.productDataArrM = tempArray;
                                       }else{
                                           [self.productDataArrM addObjectsFromArray:tempArray];
                                           [self.contentCollectionView reloadData];
                                       }
                                       
                                       if (self.productDataArrM.count < 20) {
                                           _contentCollectionView.footerHidden = YES;
                                       } else {
                                           _contentCollectionView.footerHidden = NO;
                                       }
                                       
                                   } else {
                                       _showNoneData.hidden = NO;
                                       [self configNotifyViewWithTitle:@"暂无商品"];
                                   }
                                   
                               } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   [Toast hideToastActivity];
                                   [self.contentCollectionView footerEndRefreshing];
                                   [Toast makeToast:@"网络不给力"];//error.userInfo[@"info"]
                                   [self configNotifyViewWithTitle:@"暂无商品"];
                               }];
}

#pragma mark -
#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _productDataArrM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMinProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                      forIndexPath:indexPath];
    cell.product = _productDataArrM[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(1, 1.2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMineProduct * product = _productDataArrM[indexPath.row];
    
    NSString *productCode=[NSString stringWithFormat:@"%@",product.product_code];
    if ([Utils getSNSString:productCode].length != 0) {
        SProductDetailViewController *vc =[[SProductDetailViewController alloc]init];
        vc.productID= product.product_code;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SNoneProductDetailViewController *noneProductVC = [[SNoneProductDetailViewController alloc] init];
        noneProductVC.productID = product.idStr;
//        noneProductVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:noneProductVC animated:YES];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
