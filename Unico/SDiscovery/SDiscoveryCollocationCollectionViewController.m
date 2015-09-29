//
//  SDiscoveryCollocationCollectionViewController.m
//  Wefafa
//
//  Created by Mr_J on 15/8/20.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "SDiscoveryCollocationCollectionViewController.h"
#import "SCollocationDetailViewController.h"
#import "SWaterAdvertCollectionViewCell.h"
#import "SWaterCollectionViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "WaterFLayout.h"
#import "LNGood.h"
#import "SDataCache.h"

@interface SDiscoveryCollocationCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
{
    NSInteger _pageIndex;
}

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray *contentModelArray;

@end

@implementation SDiscoveryCollocationCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initSubViews{
    WaterFLayout *waterLayout = [WaterFLayout new];
    waterLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _contentCollectionView.collectionViewLayout = waterLayout;
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.alwaysBounceVertical = YES;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterAdvertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterAdvertCellIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
    [_contentCollectionView addHeaderWithTarget:self action:@selector(requestRefreshData)];
}

- (void)setupNavbar{
    [super setupNavbar];
    [self initNavigationCenterView];
}

#pragma  mark - super moudle
- (void)initNavigationCenterView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(-5, 0, UI_SCREEN_WIDTH -100, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6.0;
    CGRect rect = backView.bounds;
    if ([[[UIDevice currentDevice]systemVersion] intValue] < 8.0) {
        rect = CGRectInset(rect, -10, 0);
    }
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:rect];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.placeholder = @"搜索:用户、品牌、标签";
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [backView addSubview:searchBar];
    
    self.tabBarController.navigationItem.titleView = backView;
}

#pragma mark - collectionVIew delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    LNGood *goodsModel = _contentModelArray[indexPath.row];
    size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    if (goodsModel.content_info.length <= 0) size.height -= 20;
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LNGood *goodsModel = self.contentModelArray[indexPath.row];
    UICollectionViewCell *cell;
    if ([goodsModel.show_type boolValue]) {
        SWaterAdvertCollectionViewCell *advertCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterAdvertCellIdentifier forIndexPath:indexPath];
        advertCell.contentGoodsModel = goodsModel;
        cell = advertCell;
    }else{
        SWaterCollectionViewCell *waterCell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
        waterCell.contentGoodsModel = goodsModel;
        cell = waterCell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LNGood *good = _contentModelArray[indexPath.row];
    NSString * collocationId  = [NSString stringWithFormat:@"%@",good.product_ID] ;
    if (collocationId.length==0) {
        return;
    }
    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
    collocationDetailVC.collocationId = collocationId;
    [self.navigationController pushViewController:collocationDetailVC animated:YES];
}

@end
