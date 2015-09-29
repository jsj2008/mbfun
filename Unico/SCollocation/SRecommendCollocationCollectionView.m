//
//  SRecommendCollocationCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/18/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SRecommendCollocationCollectionView.h"
#import "SDiscoveryBannerModel.h"
#import "SDiscoveryShowImageCell.h"
#import "UIImageView+WebCache.h"
#import "SUtilityTool.h"

@interface SRecommendCollocationCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SRecommendCollocationCollectionView

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
    self.delegate = self;
    self.dataSource = self;
    self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [self registerNib:[UINib nibWithNibName:@"SDiscoveryShowImageCell" bundle:nil] forCellWithReuseIdentifier:showImageCellIdentifier];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.height + 7, self.bounds.size.height - 10);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:showImageCellIdentifier forIndexPath:indexPath];
    cell.contentImageView.frame = cell.bounds;
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"pic_loading"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryBannerModel *model = _contentArray[indexPath.row];
    [[SUtilityTool shared]jumpControllerWithContent:model.dict target:_target];
}

@end
