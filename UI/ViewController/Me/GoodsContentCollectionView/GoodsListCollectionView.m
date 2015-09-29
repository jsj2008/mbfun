//
//  GoodsListCollectionView.m
//  Wefafa
//
//  Created by Jiang on 3/20/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "GoodsListCollectionView.h"
#import "ImageInfo.h"
#import "Utils.h"

@interface GoodsListCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
static NSString *cellIdentifier = @"GoodsListCollectionViewCellIdentifier";
@implementation GoodsListCollectionView

- (instancetype)initWithFrame:(CGRect)frame AndModelArray:(NSArray*)modelArray AndCellType:(GoodsCellType)cellType{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
        self.cellType = cellType;
        self.contentModelArray = [[NSMutableArray alloc]init];
        self.contentModelArray = [NSMutableArray arrayWithArray:modelArray];
        self.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);//
        self.backgroundColor=[Utils HexColor:0xf2f2f2 Alpha:1];
        
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

//- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
//    self.contentModelArray = contentModelArray ;
//    [self reloadData];
//}

- (void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
    self.alwaysBounceVertical = YES;
//    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self registerNib:[UINib nibWithNibName:@"GoodsListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    self.delegate = self;
    self.dataSource = self;
}

- (void)loadNextPage:(NSArray*)nextArray{
    [self.contentModelArray addObjectsFromArray:nextArray];
    [self reloadData];
}

- (void)refreshView:(NSArray*)refreshArray{
    [self.contentModelArray removeAllObjects];
    [self.contentModelArray addObjectsFromArray:refreshArray];
    [self reloadData];
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((UI_SCREEN_WIDTH - 30) / 2, 211 * UI_SCREEN_WIDTH/ 320.0);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.cellType = self.cellType;
    cell.contentModel = self.contentModelArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageInfo *imageInfo = self.contentModelArray[indexPath.row];
    if ([self.goodsDelegate respondsToSelector:@selector(tvColl_OnDidSelected:RowMessage:)]) {
        [self.goodsDelegate tvColl_OnDidSelected:self RowMessage:imageInfo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.goodsDelegate respondsToSelector:@selector(goodsListScrollView:)]) {
        [self.goodsDelegate goodsListScrollView:scrollView];
    }
}

@end
