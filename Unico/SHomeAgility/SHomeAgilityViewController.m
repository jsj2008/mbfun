//
//  SHomeAgilityViewController.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SHomeAgilityViewController.h"
#import "SDiscoveryCollocationCollectionViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "SSearchProductCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "SCollocationSubProductModel.h"
#import "SDataCache.h"
#import "LNGood.h"
#import "SProductDetailViewController.h"
#import "SDiscoveryFlexibleModel.h"
#import "Utils.h"

@interface SHomeAgilityViewController () <UIScrollViewDelegate>
{
    NSInteger _pageIndex;
    SDiscoveryFlexibleModel *_discriptionTitleModel;
}

@property (nonatomic, strong) NSMutableArray *contentModelArray;

@end

static NSString *productCellIdentifier = @"SSearchProductCollectionViewCellIdentifier";
@implementation SHomeAgilityViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)initSubViews{
    [super initSubViews];
    [self.contentCollectionView registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:productCellIdentifier];
    [self.contentCollectionView addFooterAutoRefreshWithTarget:self action:@selector(requestAddListData)];
}

- (void)requestData{
    [self.contentModelArray removeAllObjects];
    [super requestData];
    [self requestListData];
}

- (void)requestListData{
    NSDictionary *data = @{
                           @"m":@"Product",
                           @"a":@"getRecommedProductList",
                           @"page":@(_pageIndex),
                           };
    [[SDataCache sharedInstance]quickGet:SERVER_URL parameters:data success:^(AFHTTPRequestOperation *operation, id object) {
        [self.contentCollectionView footerEndRefreshing];
        if (!object[@"data"][@"productList"]) return ;
        NSArray *array = object[@"data"][@"productList"];
        if (array.count <= 0) {
            return ;
        }
        [self showDiscriptionWithString:object[@"data"][@"name"]];
        if (_pageIndex == 0) {
            self.contentModelArray = [SCollocationSubProductInfoModel modelArrayForDataArray:array];
        }else{
            [self.contentModelArray addObjectsFromArray:[SCollocationSubProductInfoModel modelArrayForDataArray:array]];
            [self.contentCollectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.contentCollectionView footerEndRefreshing];
    }];
}

- (void)requestAddListData{
    NSInteger listCount = _contentModelArray.count;
    _pageIndex = (listCount + 9)/ 10;
    [self requestListData];
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    if (contentModelArray && contentModelArray.count > 0) {
        self.contentCollectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }else{
        self.contentCollectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    }
    [self.contentCollectionView reloadData];
}

- (void)showDiscriptionWithString:(NSString *)titleString{
    for (SDiscoveryFlexibleModel *model in self.contentHeaderModelArray) {
        if (model.type.intValue == discoveryListDsicriptionTitle) {
            return;
        }
    }
    _discriptionTitleModel = [[SDiscoveryFlexibleModel alloc]init];
    _discriptionTitleModel.type = @(discoveryListDsicriptionTitle);
    _discriptionTitleModel.name = titleString;
    if (self.contentHeaderModelArray && self.contentHeaderModelArray.count > 0) {
        [self.contentHeaderModelArray addObject:_discriptionTitleModel];
        [self.contentCollectionView reloadData];
    }
}

- (void)setContentHeaderModelArray:(NSMutableArray *)contentHeaderModelArray{
    [super setContentHeaderModelArray:contentHeaderModelArray];
    if (_discriptionTitleModel) {
        [self.contentHeaderModelArray addObject:_discriptionTitleModel];
        [self.contentCollectionView reloadData];
    }
}

#pragma mark - collectionView delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollocationSubProductInfoModel *goodsModel = self.contentModelArray[indexPath.row];
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:productCellIdentifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    cell.productInfoModel = goodsModel;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SCollocationSubProductInfoModel *goods = _contentModelArray[indexPath.row];
    NSString * collocationId  =[NSString stringWithFormat:@"%@",goods.product_sys_code] ;
    if (collocationId.length<=0) {
        return;
    }
    SProductDetailViewController *productVc=[[SProductDetailViewController alloc]init];
    productVc.productID =[Utils getSNSString:collocationId];
//    
//    SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
//    collocationDetailVC.collocationId = collocationId;
    [self.navigationController pushViewController:productVc animated:YES];
}

@end
