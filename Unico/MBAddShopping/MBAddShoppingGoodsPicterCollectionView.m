//
//  MBAddShoppingGoodsPicterCollectionView.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingGoodsPicterCollectionView.h"
#import "Utils.h"

@interface MBAddShoppingGoodsPicterCollectionView ()<UICollectionViewDataSource>

@end

static NSString *cellIdentifier = @"MBAddShoppingGoodsPicterCellIdentifier";
@implementation MBAddShoppingGoodsPicterCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    self.backgroundColor = [Utils HexColor:0xf2f2f2 Alpha:1];
    self.dataSource = self;
    [self registerNib:[UINib nibWithNibName:@"MBAddShoppingGoodsPicterCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

//- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    MBAddShoppingGoodsPicterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    MBGoodsDetailListModel *model = _contentModelArray[indexPath.row];
//    cell.contentModel = model;
//    return cell;
//    
//}

@end
