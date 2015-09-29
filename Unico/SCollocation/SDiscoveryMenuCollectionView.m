//
//  SDiscoveryMenuCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 7/9/15.
//  Copyright (c) 2015 metersbonwe. All rights reserved.
//

#import "SDiscoveryMenuCollectionView.h"
#import "SDiscoveryFlexibleModel.h"
#import "SDiscoveryTitleCollectionViewCell.h"
#import "SUtilityTool.h"

@interface SDiscoveryMenuCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SDiscoveryMenuCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing =10;
    layout.minimumLineSpacing = 0;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.contentInset = UIEdgeInsetsMake(7, 10, 0, 10);
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"SDiscoveryTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    [self reloadData];
}

- (void)setContentModel:(SDiscoveryFlexibleModel *)contentModel{
    _contentModel = contentModel;
    self.contentArray = contentModel.config;
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 60)/ 5, 65 * SCALE_UI_SCREEN);
    return size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    SDiscoveryJumpModel *model = _contentArray[indexPath.row];
    cell.titleLabel.text = model.name;
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SDiscoveryJumpModel *model = _contentArray[indexPath.row];
    [[SUtilityTool shared]jumpControllerWithContent:model.dict target:_target];
}

@end
