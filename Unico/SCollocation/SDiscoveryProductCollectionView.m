//
//  SDiscoveryProductCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryProductCollectionView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryShowProductCell.h"
#import "SDiscoveryShowImageCell.h"
#import "SDiscoveryProductModel.h"
#import "SItemViewController.h"
#import "SUtilityTool.h"
#import "SSearchResultViewController.h"
#import "SDiscoveryFlexibleModel.h"
#import "ShowAdvertisementView.h"

@interface SDiscoveryProductCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, SDiscoveryShowTitleViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;

@end

NSString *cellIdentifier = @"SDiscoveryShowProductCellIdentifier";
@implementation SDiscoveryProductCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"推荐品牌"];
    _titleView.delegate = self;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, frame.size.height - 40) collectionViewLayout:layout];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryShowProductCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    CGRect rect = _contentCollectionView.frame;
    rect.size.height = (contentArray.count + 1)/ 2 * 60 * UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView.frame = rect;
    [_contentCollectionView reloadData];
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
    self.titleView.titleString = contentModel.name;
    self.contentArray = contentModel.config;
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    SItemViewController *itemVc = [SItemViewController new];
    [_target.navigationController pushViewController:itemVc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(UI_SCREEN_WIDTH/ 2, 60 * UI_SCREEN_WIDTH/ 375.0);
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryShowProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SDiscoveryProductModel *model = _contentArray[indexPath.row];
    cell.contentModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryProductModel *model = _contentArray[indexPath.row];
    SSearchResultViewController *searchrVC = [[SSearchResultViewController alloc]init];
    searchrVC.selectedIndex = 1;
    searchrVC.searchText =model.search;
    [_target.navigationController pushViewController:searchrVC animated:YES];
    return;
    
    SItemViewController *item = [[SItemViewController alloc] init];
//    SDiscoveryProductModel *model = _contentArray[indexPath.row];
    item.modelName = model.name;
    [_target.navigationController pushViewController:item animated:YES];
}

@end
