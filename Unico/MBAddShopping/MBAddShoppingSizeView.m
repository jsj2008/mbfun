//
//  MBAddShoppingSizeView.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingSizeView.h"

#import "MBGoodsDetailesSpecModel.h"

@interface MBAddShoppingSizeView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (assign, nonatomic) BOOL isNotFirstInitData;         //第一次初始化
@end

static NSString *cellIdentifier = @"MBAddShoppingSizeCellIdentifier";
@implementation MBAddShoppingSizeView


- (void)awakeFromNib {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MBAddShoppingSizeCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}
#pragma mark - 设置getter setter
@synthesize contentModelArray = _contentModelArray;
@synthesize tempSizeArray = _tempSizeArray;
@synthesize selectedIndex = _selectedIndex;
- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self reloadData];
}

-(void)setTempSizeArray:(NSMutableArray *)tempSizeArray{
    _tempSizeArray = tempSizeArray;
    [self reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:selectedIndex] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MBAddShoppingSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.showSizeLabel.text = self.contentModelArray[indexPath.row][@"speC_NAME"];
    
    if ([self.contentModelArray[indexPath.row][@"isSizeSelected"] boolValue]) {
        cell.selected = YES;
    }
//    //重置对应颜色的尺寸 不存在则置为灰色
//    if ([_tempSizeArray containsObject:cell.showSizeLabel.text]) {
//        cell.showSizeLabel.textColor = [UIColor blackColor];
//        cell.userInteractionEnabled = YES;
//
//    } else {
//        cell.showSizeLabel.textColor = [UIColor lightGrayColor];
//        cell.userInteractionEnabled = NO;
//        cell.selected = NO;
//    }


    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBAddShoppingSizeCell *cell = (MBAddShoppingSizeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //重用cell 重置所有cell
    if (_selectedIndex>-1) {
        for (MBAddShoppingSizeCell *selectCell in [collectionView subviews]) {
            selectCell.selected = NO;
        }
    }
    
    _selectedIndex = indexPath.row;
    if ([self.sizeCollectionDelegate respondsToSelector:@selector(sizeViewContentCollectionCell:didSelectItemAtIndexPath:)]) {
        [self.sizeCollectionDelegate sizeViewContentCollectionCell:cell didSelectItemAtIndexPath:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 30);
}

@end
