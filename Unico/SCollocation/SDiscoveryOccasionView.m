//
//  SDiscoveryOccasionView.m
//  Wefafa
//
//  Created by Jiang on 8/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryOccasionView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryShowTitleView.h"
#import "SDiscoveryTitleCollectionViewCell.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryProductModel.h"
#import "SDiscoveryShowTitleCell.h"
#import "SSearchSimilarViewController.h"
#import "SUtilityTool.h"

@interface SDiscoveryOccasionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

@implementation SDiscoveryOccasionView

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
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 115 )];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SDiscoveryShowTitleCell" bundle:nil] forCellWithReuseIdentifier:showTitleCellIdentifier];
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
    if (_contentModel.type.intValue == 304) {
        CGFloat height = 0.0;
        int count = ((int)contentArray.count + 2)/ 3;
        if (count <= 0) return;
        height += ((UI_SCREEN_WIDTH - 80)/ 3.0 + 10) * MIN(count, 1);
        if (count > 1) {
            height += (count - 1) * 30;
        }
        height += (count - 1) * 10;
        self.contentCollectionView.height = 20 + height;
    }else{
        int count = ((int)contentArray.count + 3)/ 4;
        if (count <= 0) return;
         self.contentCollectionView.height = 20 + ((UI_SCREEN_WIDTH - 30)/ 4.0 + 5) * (int)((contentArray.count + 3)/ 4) + (count - 1) * 10;
    }
    [self.contentCollectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if (_contentModel.type.intValue == 304) {
        if (indexPath.row < 3) {
            size = CGSizeMake((UI_SCREEN_WIDTH - 80)/ 3.0, (UI_SCREEN_WIDTH - 80)/ 3.0 + 10);
        }else{
            size = CGSizeMake((UI_SCREEN_WIDTH - 80)/ 3.0, 30);
        }
    }else{
        size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 4.0, (UI_SCREEN_WIDTH - 30)/ 4.0 + 5);
    }
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *returnCell = nil;
    SDiscoveryProductModel *model = _contentArray[indexPath.row];
    if (indexPath.row >= 3 && _contentModel.type.intValue == 304) {
        SDiscoveryShowTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showTitleCellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = model.name;
        cell.titleLabel.backgroundColor = COLOR_C4;
        cell.titleLabel.layer.masksToBounds = YES;
        cell.titleLabel.layer.cornerRadius = 3.0;
        cell.titleLabel.textColor = COLOR_C6;
        cell.titleLabel.font = FONT_t6;
        returnCell = cell;
    }else{
        SDiscoveryTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.item_img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
        cell.titleLabel.text = model.name;
        if (_contentModel.type.intValue == 304) {
            cell.titleLabel.font = FONT_t4;
            cell.titleLabel.textColor = COLOR_C6;
        }else{
            cell.titleLabel.font = FONT_t7;
            cell.titleLabel.textColor = COLOR_C5;
        }
        returnCell = cell;
    }
    return returnCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryProductModel *model = _contentArray[indexPath.row];
    SSearchSimilarViewController *searchrVC = [[SSearchSimilarViewController alloc]init];
    searchrVC.searchText = model.search;
    [_target.navigationController pushViewController:searchrVC animated:YES];
}

@end
