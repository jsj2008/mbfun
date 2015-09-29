//
//  SDiscoveryBrandCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryBrandCollectionView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryShowImageCell.h"
#import "SBrandStoryDetailModel.h"
#import "SBrandSotryViewController.h"
#import "SBrandShowListControllerViewController.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryFlexibleModel.h"
#import "DailyNewViewController.h"
#import "SNewBrandPavilionViewController.h"

@interface SDiscoveryBrandCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, SDiscoveryShowTitleViewDelegate>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

@implementation SDiscoveryBrandCollectionView

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
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115 )];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryShowImageCell" bundle:nil] forCellWithReuseIdentifier:showImageCellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setTarget:(UIViewController *)target{
    _target = target;
    _advertView.target = _target;
}

- (void)setContentArray:(NSArray *)contentArray{
    if (_contentModel && _contentModel.type.intValue == 301 && contentArray.count > 7) {
        _contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 7)];
    }else{
        _contentArray = contentArray;
    }
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
    if (contentModel.type.intValue == 301) {
        _titleView.subTitleLabel.text = contentModel.title;
        _titleView.subTitleLabel.hidden = NO;
        _titleView.moreButton.hidden = YES;
    }else{
        _titleView.subTitleLabel.hidden = YES;
        _titleView.moreButton.hidden = NO;
    }
    self.contentArray = contentModel.config;
}

- (void)showTitleTouchMoreButton:(UIButton *)sender{
    SBrandShowListControllerViewController *brandVc = [[SBrandShowListControllerViewController alloc]initWithNibName:@"SBrandShowListControllerViewController" bundle:nil];
    [_target.navigationController pushViewController:brandVc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    int count = (int)_contentArray.count;
    count += _contentModel.type.intValue == 301? 1: 0;
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH)/ 4.0, _contentCollectionView.bounds.size.height/ 2.0);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showImageCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == _contentArray.count && _contentModel.type.intValue == 301) {
        cell.reserveImageView.hidden = NO;
        cell.contentImageView.hidden = YES;
    }else{
        cell.reserveImageView.hidden = YES;
        cell.contentImageView.hidden = NO;
        SBrandStoryDetailModel *model = _contentArray[indexPath.row];
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.logo_img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
        cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.contentImageView.frame = cell.bounds;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.row == _contentArray.count && _contentModel.type.intValue == 301) {
        SNewBrandPavilionViewController *controller = [SNewBrandPavilionViewController new];
        controller.brandType = _contentModel.selectedID;
        [_target.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    SBrandStoryDetailModel *model = _contentArray[indexPath.row];
    
    DailyNewViewController *dailyNewVC = [[DailyNewViewController alloc]init];
    dailyNewVC.brandId = [NSString stringWithFormat:@"%@",model.brand_code];
    dailyNewVC.brandStoryDeatilModel = model;
    dailyNewVC.isCanSocial = NO;//不是社交
   [_target.navigationController pushViewController:dailyNewVC animated:YES];
}
@end
