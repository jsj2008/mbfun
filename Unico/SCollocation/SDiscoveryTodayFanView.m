//
//  SDiscoveryTodayFanView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryTodayFanView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryTodayCollectionViewCell.h"
#import "SCollocationDetailViewController.h"
#import "SDiscoveryFlexibleModel.h"
#import "ShowAdvertisementView.h"
#import "LNGood.h"
#import "Toast.h"

#import "SCollocationDetailNoneShopController.h"

@interface SDiscoveryTodayFanView ()<UICollectionViewDataSource, UICollectionViewDelegate, SDiscoveryShowTitleViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

static NSString *cellIdentifier = @"SDiscoveryTodayCollectionViewCellIdentifier";
@implementation SDiscoveryTodayFanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"今日搭配"];
    _titleView.delegate = self;
    _titleView.moreButton.hidden = YES;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 240 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryTodayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    CGRect frame = _contentCollectionView.frame;
    if (contentModel.banner_list.count > 0) {
        _advertView.hidden = NO;
        _advertView.contentModelArray = contentModel.banner_list;
        frame.origin.y = 40 + _advertView.height;
    }else{
        _advertView.hidden = YES;
        frame.origin.y = 40;
    }
    _contentCollectionView.frame = frame;
    _titleView.titleString = contentModel.name;
    
    self.contentArray = contentModel.config;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [_contentCollectionView reloadData];
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    [Toast makeToast:@"暂未开放此功能!" duration:1.5 position:@"center"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH - 30)/ 3, _contentCollectionView.bounds.size.height - 10);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryTodayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentModel = _contentArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    extern BOOL g_socialStatus;
    if (g_socialStatus)//是否处于社交状态
    {
        SCollocationDetailNoneShopController *detailNoShoppingViewController = [[SCollocationDetailNoneShopController alloc] init];
        LNGood *goodsModel = _contentArray[indexPath.row];
        detailNoShoppingViewController.collocationId = goodsModel.product_ID ;
        [_target.navigationController pushViewController:detailNoShoppingViewController animated:YES];
    }
    else
    {
        SCollocationDetailViewController * collocationDetailVC = [[SCollocationDetailViewController alloc]init];
        LNGood *goodsModel = _contentArray[indexPath.row];
        collocationDetailVC.collocationId = goodsModel.product_ID ;
        [_target.navigationController pushViewController:collocationDetailVC animated:YES];
        
    }
}

@end
