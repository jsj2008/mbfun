//
//  SDiscoveryFunFashionView.m
//  Wefafa
//
//  Created by Jiang on 8/17/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryFunFashionView.h"
#import "ShowAdvertisementView.h"
#import "SDiscoveryShowTitleView.h"
#import "SProductShowImageCell.h"
#import "SDiscoveryBannerModel.h"
#import "SDiscoveryFlexibleModel.h"
#import "SUtilityTool.h"

@interface SDiscoveryFunFashionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) ShowAdvertisementView *advertView;
@property (nonatomic, strong) SDiscoveryShowTitleView *titleView;

@end

static NSString *cellIdentifier = @"SProductShowImageCellIdentifier";
@implementation SDiscoveryFunFashionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    _titleView = [[SDiscoveryShowTitleView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 40) title:@"有范潮货"];
    _titleView.subTitleLabel.hidden = NO;
    _titleView.moreButton.hidden = YES;
    _titleView.decorateView.hidden = YES;
    _titleView.isHiddenLine = YES;
    [self addSubview:_titleView];
    
    _advertView = [[ShowAdvertisementView alloc]initWithFrame:CGRectMake(0, 35, UI_SCREEN_WIDTH, 115)];
    _advertView.hidden = YES;
    [self addSubview:_advertView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5;
    
    CGRect frame = self.bounds;
    frame.size.width = UI_SCREEN_WIDTH;
    frame.size.height *= UI_SCREEN_WIDTH/ 375.0;
    _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, frame.size.width, 150 * UI_SCREEN_WIDTH/ 375.0) collectionViewLayout:layout];
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    _contentCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SProductShowImageCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [self addSubview:_contentCollectionView];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    _titleView.titleString = _contentModel.name;
    _titleView.subTitleLabel.text = contentModel.title;
    self.contentArray = contentModel.config;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    if (contentArray.count > 0) {
        SDiscoveryBannerModel *model = _contentArray[0];
        _contentCollectionView.height = model.img_height.floatValue / 2.0 + 10;
    }
    [_contentCollectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    CGFloat width = model.img_width.floatValue * (_contentCollectionView.height/ model.img_height.floatValue);
    return CGSizeMake(width, _contentCollectionView.height - 10);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SProductShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.contentImageView.frame = cell.bounds;
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [[SUtilityTool shared]jumpControllerWithContent:model.dict target:_target];
}

@end
