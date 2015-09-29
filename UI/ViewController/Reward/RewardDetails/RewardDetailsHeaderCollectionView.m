//
//  DescriptionsCollectionView.m
//  Designer
//
//  Created by Jiang on 1/15/15.
//  Copyright (c) 2015 banggo. All rights reserved.
//

#import "RewardDetailsHeaderCollectionView.h"

@interface RewardDetailsHeaderCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

static NSString *cellIdentifier = @"DescriptionsCollectionViewCellIdentifier";
@implementation RewardDetailsHeaderCollectionView

- (void)awakeFromNib{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(44.0, 44.0);
    flowLayout.minimumLineSpacing = 15.0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout = flowLayout;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"u4201"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [cell.contentView addSubview:imageView];
    return cell;
}

@end
