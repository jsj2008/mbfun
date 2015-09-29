//
//  MBAddShoppingColorView.m
//  Wefafa
//
//  Created by Jiang on 5/13/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBAddShoppingColorView.h"
#import "MBGoodsDetailsColorModel.h"
#import "Utils.h"

@interface MBAddShoppingColorView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (assign, nonatomic) BOOL isNotFirstInitData;         //第一次初始化
@end

static NSString *cellIdentifier = @"MBAddShoppingColorCellIdentifier";
@implementation MBAddShoppingColorView

//通过视图加载nib文件
- (void)awakeFromNib {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"MBAddShoppingColorCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
}
#pragma mark - 设置getter setter
@synthesize contentModelArray = _contentModelArray;
@synthesize tempColorArray = _tempColorArray;
@synthesize selectedIndex = _selectedIndex;
- (void)setContentModelArray:(NSArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    //_tempColorArray = _temp(@"12");
    [self reloadData];
}

- (void)setTempColorArray:(NSMutableArray *)tempColorArray{
    _tempColorArray = tempColorArray;
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
    MBAddShoppingColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageUrl = self.contentModelArray[indexPath.row][@"coloR_FILE_PATH"];
    cell.coloR_ID = [NSString stringWithFormat:@"%@",self.contentModelArray[indexPath.row][@"coloR_ID"]];
    [cell.showColorImageView sd_setImageWithURL:[NSURL URLWithString:cell.imageUrl] placeholderImage:[UIImage imageNamed:DEFAULT_LOADING_IMAGE] options:SDWebImageHighPriority];
    
    if ([self.contentModelArray[indexPath.row][@"isColorSelected"] boolValue]) {
         cell.selected = YES;
        if ([self.colorCollectionDelegate respondsToSelector:@selector(colorViewContentCollectionCell:didSelectItemAtIndexPath:)]) {
            [self.colorCollectionDelegate colorViewContentCollectionCell:cell didSelectItemAtIndexPath:indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     MBAddShoppingColorCell *cell = (MBAddShoppingColorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //重用cell 重置所有cell
    if (_selectedIndex>-1) {
        for (MBAddShoppingColorCell *selectCell in [collectionView subviews]) {
            selectCell.selected = NO;
        }
    }

    _selectedIndex = indexPath.row;
    if ([self.colorCollectionDelegate respondsToSelector:@selector(colorViewContentCollectionCell:didSelectItemAtIndexPath:)]) {
        [self.colorCollectionDelegate colorViewContentCollectionCell:cell didSelectItemAtIndexPath:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(46, 46);
}

@end
