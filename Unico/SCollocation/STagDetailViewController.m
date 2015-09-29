//
//  STapDetailViewController.m
//  Wefafa
//
//  Created by su on 15/6/13.
//  Copyright (c) 2015年 fafatime. All rights reserved.
//

#import "STagDetailViewController.h"
#import "SCollocationCollectionViewCell.h"
#import "SCollocationCollectionViewLayout.h"
#import "SCollocationDetailViewController.h"
#import "SUtilityTool.h"
#import "LNGood.h"
#import "MBProgressHUD.h"
#import "SDataCache.h"
#import "MJRefresh.h"
#import "Toast.h"
#import "SCollocationDetailNoneShopController.h"

static NSString* CollocationCellReuseIdentifier = @"CollocationCellReuseIdentifier";

@interface STagDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSMutableArray *dataArray;
    NSInteger _pageIndex;
}
@property(nonatomic,strong)SCollocationCollectionViewLayout *collectionFlowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation STagDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionFlowLayout = [SCollocationCollectionViewLayout new];
    self.collectionFlowLayout.marginToLetf = 10;
    self.collectionFlowLayout.itemSize = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2,204);
    self.collectionFlowLayout.minimumInteritemSpacing = 10;
    self.collectionFlowLayout.minimumLineSpacing = 10;
    self.collectionFlowLayout.columnCount = 2;
//    self.collectionFlowLayout.goodsList = self.goodsList;
//    self.collectionFlowLayout.headerViewHeight = self.headerViewHeight;
//    self.collectionFlowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.headerViewHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) collectionViewLayout:self.collectionFlowLayout];
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:COLOR_C4];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    [self.view insertSubview:self.collectionView atIndex:0];
    
    [self.collectionView registerClass:[SCollocationCollectionViewCell class] forCellWithReuseIdentifier:CollocationCellReuseIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addHeaderWithCallback:^{
        [weakSelf requestDataIsPull:YES];
    }];
    [self.collectionView addFooterWithCallback:^{
        [weakSelf requestDataIsPull:NO];
    }];
    
    dataArray = [NSMutableArray arrayWithCapacity:0];
    [self requestDataIsPull:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavbar];
}

- (void)setupNavbar {
    [super setupNavbar];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unico/icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,left1] ;
    [self setTitle:self.tagTitle];
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestDataIsPull:(BOOL)isPull
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    NSString *methodName = @"getCollocationListByKey";
    if (_isTopic) {
        methodName = @"getTopicListByKey";
    }
    if (isPull) {
        _pageIndex = 0;
        [dataArray removeAllObjects];
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"m": @"Search",
                                                                                @"a": methodName,
                                                                                @"keyword":_tagTitle,
                                                                                @"page": @(_pageIndex),
                                                                                }];
    [[SDataCache sharedInstance] searchTagDetailList:data complete:^(NSArray *data, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [self.collectionView headerEndRefreshing];
        [self.collectionView footerEndRefreshing];
        if ([data isKindOfClass:[NSDictionary class]]) {

            NSDictionary *collectionDict = (NSDictionary *)data;
            NSArray *array = [collectionDict objectForKey:@"list"];
            if (array.count > 0) {
                
                _pageIndex ++;
                for(NSDictionary *subDict in array){
                    LNGood *good = [LNGood goodWithDict:subDict];
                    [dataArray addObject:good];
                }
            }else{
                NSString *message = _pageIndex ? @"没有更多" :@"暂无数据";
                [Toast makeToast:message];
            }
            [weakSelf updateCollectionView];
        }
        if (error) {
            [Toast makeToast:@"加载失败"];
            [weakSelf updateCollectionView];
        }
    }];
    
}

- (void)updateCollectionView
{
    self.collectionFlowLayout.goodsList = dataArray;
    [self.collectionView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    SCollocationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollocationCellReuseIdentifier forIndexPath:indexPath];
    //判断是否是重用
    if(!cell.good) {
        [cell initWaterFallFlowCell];
    }
    if([dataArray count]>indexPath.item)
    {
           cell.good = dataArray[indexPath.item];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.bounds.size.width, self.headerViewHeight);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([dataArray count]>indexPath.row) {
      
        LNGood *goodInfo = dataArray[indexPath.row];
        if ([goodInfo.show_type integerValue] <= 0) {
            NSString * collocationId  = [NSString stringWithFormat:@"%@",goodInfo.product_ID ];
            if (collocationId<0) {
                return;
            }
           /* SCollocationDetailViewController *vc = [SCollocationDetailViewController new];
            vc.collocationId = collocationId;
            [self pushController:vc animated:YES];*/
            
            
            extern BOOL g_socialStatus;
            if (g_socialStatus)//是否处于社交状态
            {
                SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
                
                
                detailNoShoppingViewController.collocationId = collocationId;
                [self pushController:detailNoShoppingViewController animated:YES];
                
                
            }
            else
            {
                SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
                
                
                collocationDetailVC.collocationId = collocationId;
                [self pushController:collocationDetailVC animated:YES];
                
            }

            
            
            
            
        }else{
            NSDictionary *tempDict = @{@"is_h5":goodInfo.is_h5,@"jump_id":goodInfo.jump_id,@"jump_type":goodInfo.jump_type,@"name":goodInfo.name,@"tid":goodInfo.tid,@"type":goodInfo.type,@"url":goodInfo.url};
            [SUTIL jumpControllerWithContent:tempDict target:self];
        }
        
    }

    
}

///**
// *  追加视图
// */
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *temp = nil;
//    if (kind == UICollectionElementKindSectionFooter) {
//        if (!self.footerView) {
//            self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterReuseIdentifier forIndexPath:indexPath];
//        }
//        temp = self.footerView;
//    }
//    else  if(kind == UICollectionElementKindSectionHeader){
//        //为空时添加
//        if (!self.headerView) {
//            self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderReuseIdentifier forIndexPath:indexPath];
//            //            self.isCalculateHeight = NO;
//            //            [self updateHeaderView:self.headerView];
//            NSArray *views = [headContent subviews];
//            for (UIView* view in views) {
//                [view removeFromSuperview];
//                [self.headerView addSubview:view];
//            }
//            // 直接加容器，会导致没有事件，所以暂时这样处理了。
//            //            [self.headerView addSubview:headContent];
//        }
//        temp = self.headerView;
//    }
//    return temp;
//}


//#pragma mark - scrollView代理方法
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGPoint offset = scrollView.contentOffset;
//    
//    CGRect bounds = scrollView.bounds;
//    
//    CGSize size = scrollView.contentSize;
//    
//    UIEdgeInsets inset = scrollView.contentInset;
//    
//    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
//    
//    CGFloat maximumOffset = size.height;
//    SGLOBAL_DATA_INSTANCE.scrollSelectedOffset = currentOffset;
//    //当currentOffset与maximumOffset的值相等时，说明scrollview已经滑到底部了。也可以根据这两个值的差来让他做点其他的什么事情
//    float tempFloat = UI_SCREEN_WIDTH/4;
//    if(((maximumOffset-currentOffset) <= tempFloat && (maximumOffset-currentOffset)>(tempFloat-50)) || ((maximumOffset-currentOffset) < 0 && (maximumOffset-currentOffset) > -1))
//    {
//        [self updateScrollViewDidScroll];
//    }
//    
//}


@end
