//
//  SDiscoveryCollocationCategoryView.m
//  Wefafa
//
//  Created by Jiang on 8/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryCollocationCategoryView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryHotCategoryCell.h"
#import "SAgilityHotCategoryModel.h"
#import "DailyNewViewController.h"
#import "SSearchResultViewController.h"
#import "SClothingCategoryViewController.h"

@interface SDiscoveryCollocationCategoryView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

@implementation SDiscoveryCollocationCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"热门分类"];
    _titleView.subTitleLabel.hidden = NO;
    _titleView.moreButton.hidden = YES;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 2.5;
    layout.minimumLineSpacing = 2.5;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _contentCollectionView.contentInset = UIEdgeInsetsMake(2.5, 5, 0, 5);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryHotCategoryCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
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
    self.titleView.subTitleLabel.text = contentModel.title;
    self.contentArray = contentModel.config;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    int count = ((int)contentArray.count + 2)/ 3;
    if (count <= 0) return;
    _contentCollectionView.height = ((UI_SCREEN_WIDTH - 15)/ 3.0 + 20) * count + 2.5 * (count - 1);
    [self.contentCollectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_WIDTH - 15)/ 3.0, (UI_SCREEN_WIDTH - 15)/ 3.0 + 20);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryHotCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SAgilityHotCategoryModel *model = _contentArray[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.infoLabel.text = model.info;
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SAgilityHotCategoryModel *model = _contentArray[indexPath.row];
    
    SClothingCategoryViewController *controller = [SClothingCategoryViewController new];
    controller.clothingCategoryId = model.temp_id;
    controller.defaultTitle = model.name;
//    if (model.type.intValue == 2) {
//        controller.defaultId = [NSString stringWithFormat:@"%@", model.temp_id];
//    }
    controller.hiddenHeaderImage = model.type.intValue != 2;
    [_target.navigationController pushViewController:controller animated:YES];
}

@end
