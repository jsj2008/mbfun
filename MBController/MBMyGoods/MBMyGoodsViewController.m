//
//  MBMyGoodsViewController.m
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//
#import "MBMyGoodsViewController.h"
#import "NavigationTitleView.h"
#import "MBMyGoodsSelectedHeaderView.h"
#import "MBMyGoodsContentCollectionView.h"
#import "MBMyGoodsPersonalModel.h"
#import "HttpRequest.h"
#import "WeFaFaGet.h"
#import "MJRefresh.h"
#import "SelectedSubContentView.h"
#import "SProductDetailViewController.h"
#import "SBaseDetailViewController.h"
#import "LNGood.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationDetailNoneShopController.h"
#import "Toast.h"

@interface MBMyGoodsViewController () <SelectedSubContentViewDelegate, UIScrollViewDelegate,MBMyGoodsContentCollectionViewDelegate>
{
    NSInteger clickIndex;
    NSMutableArray *_arraySBaseVC;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) SelectedSubContentView *selectedHarderView;
@property (weak, nonatomic) UIScrollView *contentScrollView;


@end

@implementation MBMyGoodsViewController
{
     NSMutableArray * dataSource0;
     NSMutableArray * dataSource1;
     NSMutableArray * dataSource2;

     NSInteger  currentOriginalPage;
     NSInteger  currentShareColocationPage;
     NSInteger  currentSinglePage;
    
     NSInteger totalOriginalNum;
     NSInteger totalShareColocationNum;
     NSInteger totalShareSingleNum;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (sns.ldap_uid.length == 0 || [sns.ldap_uid isEqualToString:@""] || [sns.ldap_uid isEqual:[NSNull null]]) {
        [self.navigationController popViewControllerAnimated:YES];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"未登录" cancelButtonItem:nil otherButtonItems: nil];
        [alertView show];
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    [self initSubView];
    [self selectedButtonForIndex:0];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    // 这里换selector来测试
    // 注意这里还原下背景色，可能被别的vc设置掉了。
    self.headerView.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    UIView *tempView;
    CGRect navRect = self.navigationController.navigationBar.frame;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    

    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10;// TODO 负数无效这里

    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    
    
    UIButton *tempBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 100, navRect.size.height)];
    [tempBtn setTitle:@"我的商品" forState:UIControlStateNormal];
    tempBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
    tempBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [tempBtn addTarget:self action:@selector(bestSelect:) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempBtn];
    // default40@2x.9
    
    
    self.navigationItem.titleView = tempView;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    [self.navigationItem.titleView addGestureRecognizer:recognizer];
    
}

- (void)onBack:(UIButton*)sender {
    [self popAnimated:YES];
}

- (void)onCart:(UIButton*)sender {
    
}

- (void)onShare:(UIButton*)sender {
    
}

- (void)bestSelect:(UIButton*)sender {
    
}
-(void)hiddenGoods:(id)sender {
    
}
- (void)backHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect selectedHeaderRect = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), UI_SCREEN_WIDTH, 85.0-41);
    NSArray *nameArray = @[@"原创", @"分享搭配", @"分享单品"];
    SelectedSubContentView *selectedHeaderView = [[SelectedSubContentView alloc]initWithFrame:selectedHeaderRect AndNameArray:nameArray];
    selectedHeaderView.delegate = self;
    selectedHeaderView.hidden = NO;
    [selectedHeaderView scrollViewEndAction:0];
    selectedHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectedHeaderView];
    self.selectedHarderView = selectedHeaderView;
    
    CGRect contentScrollRect = CGRectMake(0, CGRectGetMaxY(selectedHeaderView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - CGRectGetMaxY(selectedHeaderView.frame));
    UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:contentScrollRect];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.delegate = self;
    contentScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 3, UI_SCREEN_HEIGHT-CGRectGetMaxY(selectedHeaderView.frame));
    contentScrollView.pagingEnabled = YES;
    [self.view addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    self.contentScrollView.userInteractionEnabled=YES;
    
    for (int i =0; i<3; i++) {
        [self mbMyGoodContentCollectionViewSet:i];
    }
    
}


-(void)mbMyGoodContentCollectionViewSet:(NSInteger)index
{
    CGRect rect = self.contentScrollView.bounds;
    rect.origin.x = index * UI_SCREEN_WIDTH;
//    SBaseDetailViewController *collectionView = [[SBaseDetailViewController alloc]init];
//    collectionView.view.frame = rect;
    MBMyGoodsContentCollectionView *collectionView = [[MBMyGoodsContentCollectionView alloc]initWithFrame:rect];
//    collectionView.showTwoBtn=NO;
    collectionView.showPrice = NO;
    if (index == 2) {
        collectionView.noneDataShow = noneGoods;
    }else{
        collectionView.noneDataShow = noneCollocation;
    }
    
    collectionView.userInteractionEnabled=YES;
    collectionView.goodsCollectionDelegate=self;
//    if (!_arraySBaseVC) {
//        _arraySBaseVC = [NSMutableArray arrayWithCapacity:3];
//    }
//    [_arraySBaseVC addObject:collectionView];
    [self.contentScrollView setUserInteractionEnabled:true];
    [self.contentScrollView addSubview:collectionView];
    [self addHeader:index];
    [self addFooter:index];
    
}


- (void)addHeader:(NSInteger)selectIndex
{
    __weak typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    switch (selectIndex) {
            
        case 0:{
            currentOriginalPage = 1;
            break;}
            
        case 1:{
            currentShareColocationPage = 1;
            break;}
            
        case 2:{
            currentSinglePage = 1;
            break;}
            
        default:
            break;
    }
    currentOriginalPage = 1;
    MBMyGoodsContentCollectionView *collectionView = weakSelf.contentScrollView.subviews[selectIndex];
//    SBaseDetailViewController *collectionView = _arraySBaseVC[selectIndex];
    
    [collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakSelf requestData:YES andIndex:selectIndex];
        });
    }];
}

- (void)addFooter:(NSInteger)selectIndex
{
    __weak typeof(self) weakSelf = self;
//    MBMyGoodsContentCollectionView *collectionView = self.contentScrollView.subviews[selectIndex];
    SBaseDetailViewController *collectionView = _arraySBaseVC[selectIndex];
    // 添加上拉刷新尾部控件
    [collectionView.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        
        if ([weakSelf isNoMoreData:selectIndex]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateViewWithRequestSuccess:YES message:@"没有更多信息" andIndex:selectIndex];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [weakSelf requestData:NO andIndex:selectIndex];
            });
        }
    }];
}

- (BOOL)isNoMoreData:(NSInteger)selectIndex
{
    switch (selectIndex) {
            
        case 0:{
            if (totalOriginalNum == 0) {
                return YES;
            }
            
            else{
                return NO;
            }
            
            break;}
            
            
        case 1:{
            if (totalShareColocationNum == 0) {
                return YES;
            }
            
            else
            {
                return NO;
            }
            
            break;}
            
            
        case 2:{
            if (totalShareSingleNum == 0) {
                return YES;
            }
            
            else
            {
                return NO;
            }
            
            break;
        }
            
            
        default:
            break;
    }
    return NO;
}


- (void)requestData:(BOOL)isPull andIndex:(NSInteger)selectIndex{
    
    NSString *methodName = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    MBMyGoodsContentCollectionView *collectionView = self.contentScrollView.subviews[selectIndex];
//    SBaseDetailViewController *collectionView = _arraySBaseVC[selectIndex];
    
    if (!collectionView.contentModelArray) {
        collectionView.contentModelArray = [NSMutableArray array];

    }
    
    switch (selectIndex) {
            
        case 0:{
            if (!dataSource0) {
                dataSource0 = [[NSMutableArray alloc] init];
            }
            methodName =  @"PersonalCollocationInfoFilter";
            if (isPull) {
                currentOriginalPage = 1;
                [collectionView.contentModelArray removeAllObjects];
                [dataSource0 removeAllObjects];

            }
            [params setObject:[NSString stringWithFormat:@"%ld", (long)currentOriginalPage ]forKey:@"pageIndex"];
            
            break;}
        case 1:{
            if (!dataSource1) {
                dataSource1 = [[NSMutableArray alloc] init];
            }
            methodName = @"SharedCollocationFilter";
            if (isPull) {
                currentShareColocationPage = 1;
                [collectionView.contentModelArray removeAllObjects];
                [dataSource1 removeAllObjects];
            }
            [params setObject:[NSString stringWithFormat:@"%ld", (long)currentShareColocationPage] forKey:@"pageIndex"];
            

            break;}
        case 2:{
            if (!dataSource2) {
                dataSource2 = [[NSMutableArray alloc] init];
            }
            methodName = @"SharedProductFilter";
            if (isPull) {
                currentSinglePage = 1;
                [collectionView.contentModelArray removeAllObjects];
                [dataSource2 removeAllObjects];
            }
            [params setObject:[NSString stringWithFormat:@"%ld", (long)currentSinglePage] forKey:@"pageIndex"];

            break;}
            
            
        default:
            break;
    }
    [params setObject:sns.ldap_uid forKey:@"userId"];
    [params setObject:@"14" forKey:@"pageSize"];
    
    
    [HttpRequest collocationGetRequestPath:nil methodName:methodName params:params success:^(NSDictionary *dict) {
        
        NSString *message = nil;
        
        switch (selectIndex) {
                
            case 0:{
                NSArray *result = [dict objectForKey:@"results"];
                totalOriginalNum = [result count];
                /*假数据*/
                if (result.count == 0) {
                    result = @[@{@"amount" : @"0",
                                 @"description" : @"123",
                                 @"favoriteCount" : @"0",
                                 @"id" : @"73268",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150301/1425190660.jpg",
                                 @"sharedCount" : @"0",
                                 @"userId" : @"8d2a9f55-1f98-4fa7-913c-e203f0855076"},
                               @{@"amount" : @"0",
                                 @"description" : @"123",
                                 @"favoriteCount" : @"0",
                                 @"id" : @"73268",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150301/1425190660.jpg",
                                 @"sharedCount" : @"0",
                                 @"userId" : @"8d2a9f55-1f98-4fa7-913c-e203f0855076"},
                               @{@"amount" : @"0",
                                 @"description" : @"123",
                                 @"favoriteCount" : @"0",
                                 @"id" : @"73268",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150301/1425190660.jpg",
                                 @"sharedCount" : @"0",
                                 @"userId" : @"8d2a9f55-1f98-4fa7-913c-e203f0855076"}];
                }
                /*假数据*/
                for(NSDictionary *dict in result){
                    
                    MBMyGoodsPersonalModel *model = [MBMyGoodsPersonalModel new];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource0 addObject:model];
//                    LNGood *good = [LNGood goodWithDict:dict];
//                    [dataSource0 addObject:good];
                    }
//                NSMutableArray *array = [MBMyGoodsPersonalModel modelArrayWithDataArray:dataSource0];
                
                collectionView.contentModelArray = dataSource0;
//                [collectionView layoutUI];
                
                if (result.count <= 0) {
                    message = @"没有更多信息";
                }else{
                    currentOriginalPage ++;
                }
                
                break;
            }
            case 1:{

                NSArray *result = [dict objectForKey:@"results"];
                totalShareColocationNum = [result count];
                /*假数据*/
                if (result.count == 0) {
                    result = @[@{@"amount" : @"0",
                                 @"description" : @"nn",
                                 @"favoriteCount" : @"16",
                                 @"id" : @"73837",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150310/1425954273.jpg",
                                 @"sharedCount" : @"20"},
                               @{@"amount" : @"0",
                                 @"description" : @"nn",
                                 @"favoriteCount" : @"16",
                                 @"id" : @"73837",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150310/1425954273.jpg",
                                 @"sharedCount" : @"20"},
                               @{@"amount" : @"0",
                                 @"description" : @"nn",
                                 @"favoriteCount" : @"16",
                                 @"id" : @"73837",
                                 @"name" : @"",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/Collocation/20150310/1425954273.jpg",
                                 @"sharedCount" : @"20"}];
                }
                /*假数据*/
                for(NSDictionary *dict in result){
                    
                    MBMyGoodsPersonalModel *model = [MBMyGoodsPersonalModel new];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource1 addObject:model];
//                    LNGood *good = [LNGood goodWithDict:dict];
//                    [dataSource1 addObject:good];
                    
                }
//                NSMutableArray *array = [MBMyGoodsPersonalModel modelArrayWithDataArray:dataSource1];
                collectionView.contentModelArray = dataSource1;
//                [collectionView layoutUI];
                
                if (result.count <= 0) {
                    message = @"没有更多信息";
                }else{
                    currentShareColocationPage ++;
                }
                break;
            }
                
            case 2:{

                NSArray *result = [dict objectForKey:@"results"];
                totalShareSingleNum = [result count];
                /*假数据*/
                if (result.count == 0) {
                    result = @[@{@"code" : @"519023",
                                 @"favoritCount" : @"6",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/ProdCls/0f5f0677-43b2-46f7-9ff8-ac754268d3b2.jpg",
                                 @"price" : @"399",
                                 @"proName" : @"男立体装饰条纹毛衫",
                                 @"productClsID" : @"8816",
                                 @"sale_price" : @"398",
                                 @"sharedCount" : @"1"},
                               @{@"code" : @"519023",
                                 @"favoritCount" : @"6",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/ProdCls/0f5f0677-43b2-46f7-9ff8-ac754268d3b2.jpg",
                                 @"price" : @"399",
                                 @"proName" : @"男立体装饰条纹毛衫",
                                 @"productClsID" : @"8816",
                                 @"sale_price" : @"398",
                                 @"sharedCount" : @"1"},
                               @{@"code" : @"519023",
                                 @"favoritCount" : @"6",
                                 @"pictureUrl" : @"http://img.51mb.com:5659/sources/designer/ProdCls/0f5f0677-43b2-46f7-9ff8-ac754268d3b2.jpg",
                                 @"price" : @"399",
                                 @"proName" : @"男立体装饰条纹毛衫",
                                 @"productClsID" : @"8816",
                                 @"sale_price" : @"398",
                                 @"sharedCount" : @"1"}];
                }
                /*假数据*/
                for(NSDictionary *dict in result){
                    
                    MBMyGoodsPersonalModel *model = [MBMyGoodsPersonalModel new];
                    [model setValuesForKeysWithDictionary:dict];
                    [dataSource2 addObject:model];
//                    LNGood *good = [LNGood goodWithDict:dict];
//                    [dataSource2 addObject:good];
                    
                }
//                NSMutableArray *array = [MBMyGoodsPersonalModel modelArrayWithDataArray:dataSource2];
                collectionView.contentModelArray = dataSource2;
//                [collectionView layoutUI];
                if (result.count <= 0) {
                    message = @"没有更多信息";
                }else{
                    currentSinglePage ++;
                }

                break;}
            default:
                break;
        }
        
        
        [self updateViewWithRequestSuccess:YES message:message andIndex:selectIndex];


        
    } failed:^(NSError *error) {
        
        NSLog(@"我的商品模块错误------%@", error);
        [self updateViewWithRequestSuccess:NO message:@"" andIndex:selectIndex];

    }];
}


- (void)updateViewWithRequestSuccess:(BOOL)isSuccess message:(NSString *)message andIndex:(NSInteger)index
{
    MBMyGoodsContentCollectionView *collectionView = self.contentScrollView.subviews[index];
//    SBaseDetailViewController *collectionView = _arraySBaseVC[index];

    if (isSuccess) {
        [collectionView reloadData];
    }
   [collectionView footerEndRefreshing];
    [collectionView headerEndRefreshing];
    [Toast hideToastActivity];
    if (!message || [message isEqual:[NSNull null]] || [message isEqualToString:@""]) {
        return;
    }
    [Toast makeToast:message];
    
}


- (void)showRequestToast
{
    [Toast makeToastActivity:@"正在获取数据" hasMusk:YES];
}



#pragma mark - selectedView delegate
- (void)selectedSubContentViewSelectedIndex:(NSInteger)index{
    [self.contentScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * index, 0) animated:YES];
    [self selectedButtonForIndex:index];
}

- (void)goodsSelectedButtonIndex:(int)index{
    CGPoint point = CGPointMake(index * UI_SCREEN_WIDTH, 0);
    [self.contentScrollView setContentOffset:point animated:YES];
    [self selectedButtonForIndex:index];
}

#pragma mark - content ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewContentWidth = scrollView.contentSize.width - SCREEN_WIDTH;
    CGFloat scrollViewLocation = scrollView.contentOffset.x;
    CGFloat percentage = scrollViewLocation / scrollViewContentWidth;
    [self.selectedHarderView setLineLocationPercentage:percentage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/ UI_SCREEN_WIDTH;
    [self.selectedHarderView scrollViewEndAction:index];
    [self selectedButtonForIndex:index];
}

- (void)selectedButtonForIndex:(NSInteger)index{
    clickIndex = index;
    
    MBMyGoodsContentCollectionView *collectionView = self.contentScrollView.subviews[index];
//    SBaseDetailViewController *collectionView = _arraySBaseVC[index];

    if (!collectionView.contentModelArray) {
        __weak typeof(self) weakSelf = self;
        [weakSelf performSelectorOnMainThread:@selector(showRequestToast) withObject:nil waitUntilDone:YES];
        [self requestData:YES andIndex:index];
    }
}
- (void)myGoodsCollection:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    MBMyGoodsContentCollectionView * myContentView=(MBMyGoodsContentCollectionView *)collectionView;
    MBMyGoodsPersonalModel *personalModel = myContentView.contentModelArray[indexPath.row];
    if (![BaseViewController pushLoginViewController]) {
        return;
    }
    if (clickIndex==2)
    {
//        MBGoodsViewController *goodViewC=[[MBGoodsViewController alloc]initWithNibName:@"MBGoodsViewController" bundle:nil];
//        goodViewC.product_Id =[NSString stringWithFormat:@"%@", personalModel.code];
//        goodViewC.shareUserId = sns.ldap_uid;
//        [self.navigationController pushViewController:goodViewC animated:YES];
        
        SProductDetailViewController *itemVC = [SProductDetailViewController new];
        
#warning      要传商品code
        itemVC.productID =  [NSString stringWithFormat:@"%@",personalModel.code];
        [self pushController:itemVC animated:YES];
    }
    else
    {
       /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
        vc.collocationId = [personalModel.aID intValue];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;*/
        
        extern BOOL g_socialStatus;
        if (g_socialStatus)//是否处于社交状态
        {
            SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
            
            
            detailNoShoppingViewController.collocationId = [NSString stringWithFormat:@"%@",personalModel.aID];
            [self.navigationController pushViewController:detailNoShoppingViewController animated:YES];
        }
        else
        {
            SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
            
            
            collocationDetailVC.collocationId =  [NSString stringWithFormat:@"%@",personalModel.aID];
            [self.navigationController pushViewController:collocationDetailVC animated:YES];
        }

        
        
        
        
        
        
   
//        CollocationDetailViewController *collocationVc=[[CollocationDetailViewController alloc]initWithNibName:@"CollocationDetailViewController" bundle:nil];
//        collocationVc.collocationId =[NSString stringWithFormat:@"%@", personalModel.aID];
//        collocationVc.shareUserId = sns.ldap_uid;
//        [self.navigationController pushViewController:collocationVc animated:YES];
    }

}
@end
