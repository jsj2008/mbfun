//
//  SUsedProductViewController.mm
//  Wefafa
//
//  Created by chencheng on 15/8/21.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SUsedProductViewController.h"
#import "WaterFLayout.h"
#import "SUtilityTool.h"
#import "SUploadColllocationControlCenter.h"
#import "SScrollButtonTabBar.h"
#import "UIScrollView+MJRefresh.h"
#import "SProductCell.h"
#import "SProductModel.h"
#import "SCategoryInfo.h"
#import "WeFaFaGet.h"
#import "SDataCache.h"
#import "Toast.h"
#import "HttpRequest.h"
#define sizeK UI_SCREEN_WIDTH/750.0


@interface SUsedProductViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    UINavigationBar *_navigationBar;
    UINavigationItem *_navigationItem;
    
    SScrollButtonTabBar *_scrollButtonTabBar;
    
    NSMutableArray *_categoryInfoMutableArray;
    
    WaterFLayout *_waterFLayout;
    UICollectionView *_collectionView;
    
    
    NSMutableArray *_productModelMutableArray;
    NSMutableArray *_productArray;
    
    SProductTagEditeInfo *_selectedRroductTagEditeInfo;
    
    int _selectedIndex;
    int _selectedSection;
    ///是否允许刷新数据
    BOOL _isRefresh;
    ///当前为为上拉还是下拉
    BOOL _isHeader;
    ///下拉加载索引
    int _headerIndex;
    
}

@end

@implementation SUsedProductViewController


#pragma mark - 构造与析构

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _navigationItem = [[UINavigationItem alloc] init];
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
        _navigationItem.leftBarButtonItems = @[backButtonItem];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UI_SCREEN_WIDTH-200)/2.0, 0, 200, 44)];
        titleLabel.font = FONT_SIZE(18);
        titleLabel.textColor = COLOR_WHITE;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"使用过的单品";
        
        _navigationItem.titleView = titleLabel;
    }
    return self;
}


#pragma mark - 视图控制器接口

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if ([self.view.gestureRecognizers count] > 0)
    {
        for(UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers)
        {
            if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
            }
        }
    }
    if (screenEdgePanGestureRecognizer != nil)
    {
        [self.view removeGestureRecognizer:screenEdgePanGestureRecognizer];//此处禁止屏幕边界右滑时返回上一级界面的手势
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavbar];
    
    _selectedIndex=1;
    _selectedSection=0;
    _isRefresh=YES;
    _headerIndex=0;
    //NO为上拉
    _isHeader=NO;
    
    UIView *vi =[[UIView alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, 88*sizeK)];
    vi.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:vi];
    _scrollButtonTabBar = [[SScrollButtonTabBar alloc] initWithFrame:CGRectMake(0, 44, UI_SCREEN_WIDTH, 88 * sizeK)];
    _scrollButtonTabBar.selectedIndex=_selectedSection;
    [self.view addSubview:_scrollButtonTabBar];
    
    [_scrollButtonTabBar addTarget:self action:@selector(requestAddData) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_navigationBar];
    
    _waterFLayout = [[WaterFLayout alloc] init];
    _waterFLayout.sectionInset = UIEdgeInsetsMake(10 * sizeK, 20 * sizeK, 10 * sizeK, 20 * sizeK);
    _waterFLayout.minimumColumnSpacing = 10 * sizeK;
    _waterFLayout.minimumInteritemSpacing = 26 * sizeK;
    _waterFLayout.columnCount = 3;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44 + _scrollButtonTabBar.frame.size.height, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-(44 + _scrollButtonTabBar.frame.size.height)) collectionViewLayout:_waterFLayout];
    _collectionView.backgroundColor = [UIColor colorWithRed:float(0xf2)/255.0 green:float(0xf2)/255.0 blue:float(0xf2)/255.0 alpha:1];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView addFooterWithTarget:self action:@selector(requestAddData)];
    [_collectionView addHeaderWithTarget:self action:@selector(requestHeaderData)];
    _collectionView.headerHidden=YES;
    
    [_collectionView registerClass:[SProductCell class] forCellWithReuseIdentifier:@"ProductCell"];
    
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview: _collectionView];
    
    [self getCategoryList];
    
    [self.view addSubview:_navigationBar];
}

/**
 *   构建导航栏
 */
- (void)setupNavbar
{
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [_navigationBar removeFromSuperview];
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 44)];
    [_navigationBar pushNavigationItem:_navigationItem animated:NO];
    [_navigationBar setBackgroundImage:[UIImage imageNamed:@"Unico/blackBarBg.jpg"] forBarMetrics:UIBarMetricsDefault];
    [_navigationBar setBarTintColor:[UIColor blackColor]];
    [self.view addSubview:_navigationBar];
    
    _navigationBar.layer.transform = CATransform3DMakeTranslation(0, 0, 5);
    
}

#pragma mark - UICollectionViewDataSource接口

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProductCell";
    
    SProductCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SProductModel *model = [_productModelMutableArray objectAtIndex:[indexPath row]];
    SProductTagEditeInfo *sproductInfo=[_productArray objectAtIndex:indexPath.row];
    
    //数据方面的属性
    cell.productImageURL = model.productImageURL;
    if (model.productCode) {
        cell.price = model.price;
    }
    else
    {
        cell.price=-1;
    }
    
    cell.title = [NSString stringWithFormat:@"%@%@",model.title,sproductInfo.productSubCategoryName];
    
    //布局属性
    cell.productImageRect = model.productImageRect;
    cell.priceLabelRect = model.priceLabelRect;
    cell.titleLabelRect = model.titleLabelRect;
    
    cell.layer.borderWidth = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate接口

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SProductCell * cell =(SProductCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"cell = %@", cell);
    NSLog(@"cell.productImage = %@", cell.productImage);
    
    SProductTagEditeInfo *productTagEditeInfo=_productArray[indexPath.item];
    SCategoryInfo *scateIn=_categoryInfoMutableArray[_scrollButtonTabBar.selectedIndex];
    productTagEditeInfo.productCategoryId=scateIn.categoryId;
    productTagEditeInfo.productCategoryName=scateIn.categoryName;
    productTagEditeInfo.productImage=cell.productImage;
    productTagEditeInfo.productOriginImage=cell.productImage;
    if (_scrollButtonTabBar.selectedIndex!=0) {
        productTagEditeInfo.productCategoryId=scateIn.categoryId;
        productTagEditeInfo.productCategoryName=scateIn.categoryName;
    }
    
    _selectedRroductTagEditeInfo = productTagEditeInfo;
    
    if (self.didFinishPickingProduct != nil)
    {
        self.didFinishPickingProduct(productTagEditeInfo);
    }
}

#pragma mark - WaterFLayoutDelegate接口

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SProductModel *model = [_productModelMutableArray objectAtIndex:[indexPath row]];
    
    return model.cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - 控件事件接口

- (void)backButtonClick:(id)sender
{
    if (self.back != nil)
    {
        self.back();
    }
}

#pragma mark - 获取网络数据的接口


/**
 *   获取所有的类别
 */
- (void)getCategoryList
{
    _categoryInfoMutableArray=[NSMutableArray array];
    SCategoryInfo *scateInfo=[[SCategoryInfo alloc] init];
    scateInfo.categoryCode=@"0";
    scateInfo.categoryId=@"0";
    scateInfo.categoryName=@"全部";
    [_categoryInfoMutableArray addObject:scateInfo];
    
    NSMutableArray *titleArray=[NSMutableArray array];
    [titleArray addObject:@"全部"];
    
    _productModelMutableArray=[NSMutableArray array];
    _productArray=[NSMutableArray array];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [HttpRequest productGetRequestPath:@"Product" methodName:@"ProductCategorySubItemFilter" params:dict success:^(NSDictionary *dict) {
        [Toast hideToastActivity];
        
        NSArray *result = [dict objectForKey:@"results"];
        
        if (![result isKindOfClass:[NSArray class]])
        {
            //错误信息
            [Toast makeToast:@"服务端数据异常"];
            return;
        }
        
        if (result.count <= 0)
        {
            //错误信息
            [Toast makeToast:@"服务端无数据"];
            return;
        }
        
        [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            SCategoryInfo *scateIn=[[SCategoryInfo alloc] init];
            scateIn.categoryCode=obj[@"code"];
            scateIn.categoryId=obj[@"id"];
            scateIn.categoryName=obj[@"name"];
            [_categoryInfoMutableArray addObject:scateIn];
            [titleArray addObject:obj[@"name"]];
        }];
        
        _scrollButtonTabBar.titles=titleArray;
        
        [self requestAddData];
        
    } failed:^(NSError *error) {
        
        [Toast hideToastActivity];
    }];
}

/**
 *   获取某个类别下所有使用过的单品
 */

-(void)requestProductListWithcategoryId:(NSString *)categoryId currentPage:(int)currentPage
{
    //如果当前是上拉状态且不允许刷新，则返回
    if(!_isRefresh&&!_isHeader){
        return ;
    }
    
    [Toast makeToastActivity:@"正在努力加载..." hasMusk:NO];
    NSString *userToken = sns.isLogin? [SDataCache sharedInstance].userInfo[@"token"]: @"";
    NSDictionary *param = @{
                            @"token":userToken,
                            @"cid":categoryId,
                            @"userId":sns.ldap_uid,
                            @"pageIndex":@(currentPage),
                            @"pageSize":@(30)
                            };
    [[SDataCache sharedInstance] get:@"Product" action:@"getUserProductListByCategory"
                               param:param success:^(AFHTTPRequestOperation *operation, id object) {
                                   [Toast hideToastActivity];
                                   [_collectionView footerEndRefreshing];
                                   [_collectionView headerEndRefreshing];
                                   
                                   if ([object[@"isSuccess"] integerValue] == 1) {
                                       NSArray * responseArr = (NSArray *)object[@"results"];
                                       
                                       if (responseArr.count<1&&currentPage==0) {
                                           [self showAndRemoveNoneView:YES];
                                       }
                                       else
                                       {
                                           [self showAndRemoveNoneView:NO];
                                       }
                                       
                                       //如果本次返回数据少于请求的数量，表明没有更多数据，下次可以不用刷新
                                       if (responseArr.count<30) {
                                           _isRefresh=NO;
                                           //隐藏上拉加载
                                           _collectionView.footerHidden=YES;
                                       }
                                       else
                                       {
                                           _isRefresh=YES;
                                           _collectionView.footerHidden=NO;
                                       }
                                       
                                       [responseArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                                           SProductTagEditeInfo *sproductInfo=[[SProductTagEditeInfo alloc] init];
                                           sproductInfo.productBrandCode=[NSString stringWithFormat:@"%@",obj[@"brand_code"]];
                                           sproductInfo.productBrandName=[NSString stringWithFormat:@"%@",obj[@"brand_value"]];
                                           
                                           sproductInfo.productSubCategoryId=[NSString stringWithFormat:@"%@",obj[@"cate_id"]];
                                           sproductInfo.productSubCategoryName=[NSString stringWithFormat:@"%@",obj[@"cate_value"]];
                                           sproductInfo.productColorCode=[NSString stringWithFormat:@"%@",obj[@"color_code"]];
                                           sproductInfo.productColorName=[NSString stringWithFormat:@"%@",obj[@"color_value"]];
                                           sproductInfo.productId=[NSString stringWithFormat:@"%@",obj[@"id"]];
                                           //如果product_code为空，则为虚拟商品，没有价格
                                           if (obj[@"product"]) {
                                               sproductInfo.price=[NSString stringWithFormat:@"%@",obj[@"product"][@"price"]];
//                                               sproductInfo.productCode=[NSString stringWithFormat:@"%@",obj[@"product"][@"product_sys_code"]];
                                               sproductInfo.productCode=[NSString stringWithFormat:@"%@",obj[@"product_code"]];
                                           }
                                           sproductInfo.productImageUrl=[NSString stringWithFormat:@"%@",obj[@"product_img"]];
                                           
                                           
                                           SProductModel *productModel = [[SProductModel alloc] init];
                                           productModel.waterFLayout = _waterFLayout;
                                           productModel.productId = obj[@"brand_code"];
                                           productModel.productImageURL = [NSURL URLWithString:obj[@"product_img"]];
                                           productModel.title = obj[@"brand_value"];
                                           if (obj[@"product"]) {
                                               productModel.productCode=sproductInfo.productCode;
                                               productModel.price=[obj[@"product"][@"price"] floatValue];
                                           }
                                           
                                           
                                           productModel.productImageSize = CGSizeMake(300, 300);
                                           if (_isHeader) {
                                               [_productArray insertObject:sproductInfo atIndex:idx];
                                               [_productModelMutableArray insertObject:productModel atIndex:idx];
                                           }
                                           else
                                           {
                                               [_productArray addObject:sproductInfo];
                                               [_productModelMutableArray addObject:productModel];
                                           }
                                           
                                       }];
                                       
                                       //优化 内存占用，限定数组个数
                                       if (_productArray.count>150)
                                       {
                                           if (_isHeader)
                                           {
                                               NSInteger count=_productArray.count;
                                               [_productArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(150, count-150)]];
                                               [_productModelMutableArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(150, count-150)]];
                                               _selectedIndex--;
                                           }
                                           else
                                           {
                                               [_productArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 30)]];
                                               [_productModelMutableArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 30)]];
                                               _headerIndex++;
                                               _collectionView.headerHidden=NO;
                                           }
                                       }
                                       
                                       if (_isHeader) {
                                           _headerIndex--;
                                           if (_headerIndex<1) {
                                               _collectionView.headerHidden=YES;
                                           }
                                       }
                                       else{
                                           _selectedIndex++;
                                       }
                                       
                                       [_collectionView reloadData];
                                   }
                                   
                                   
                               } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   [_collectionView footerEndRefreshing];
                                   [Toast makeToast:@"网络错误，请重试！" duration:1.5 position:@"center"];
                               }];
}

-(void)requestHeaderData
{
    if (_headerIndex<1) {
        return;
    }
    _isHeader=YES;
    
    SCategoryInfo *scateIn=_categoryInfoMutableArray[_scrollButtonTabBar.selectedIndex];
    [self requestProductListWithcategoryId:[[NSString alloc]initWithFormat:@"%@",scateIn.categoryId] currentPage:_headerIndex];
}

-(void)requestAddData
{
    [self showAndRemoveNoneView:NO];
    _isHeader=NO;
    SCategoryInfo *scateIn=_categoryInfoMutableArray[_scrollButtonTabBar.selectedIndex];
    if (_selectedSection!=_scrollButtonTabBar.selectedIndex) {
        _selectedIndex=1;
        
        [_productArray removeAllObjects];
        [_productModelMutableArray removeAllObjects];
        //切换类别时，取消下拉加载
        _collectionView.headerHidden=YES;
        _headerIndex=0;
        [_collectionView reloadData];
        _isRefresh=YES;
    }
    _selectedSection=_scrollButtonTabBar.selectedIndex;
    [self requestProductListWithcategoryId:[[NSString alloc]initWithFormat:@"%@",scateIn.categoryId] currentPage:_selectedIndex];
}

///显示无商品背景：YES显示,NO移除
-(void)showAndRemoveNoneView:(BOOL)isShow
{
    UIView *noneView=[self.view viewWithTag:100861];
    if (!noneView) {
        if (isShow) {
            noneView = [[UIView alloc] initWithFrame:CGRectMake(0,44+88*sizeK, SCREEN_WIDTH, UI_SCREEN_HEIGHT-44-88*sizeK)];
            noneView.tag=100861;
            [noneView setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:noneView];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, 100+44, 60, 60)];
            [imgView setImage:[UIImage imageNamed:@"Unico/ico_nocollection"]];
            [noneView addSubview:imgView];
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155+10+44, SCREEN_WIDTH, 20)];
            [messageLabel setFont:FONT_t1];
            [messageLabel setTextAlignment:NSTextAlignmentCenter];
            [messageLabel setTextColor:COLOR_C9];
            [messageLabel setTag:100];
            [messageLabel setText:@"暂无商品"];
            [noneView addSubview:messageLabel];
        }
    }
    else
    {
        if (!isShow) {
            [noneView removeFromSuperview];
        }
    }
}

@end















