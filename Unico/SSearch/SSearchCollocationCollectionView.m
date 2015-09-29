//
//  SSearchCollocationCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 6/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchCollocationCollectionView.h"
#import "SWaterCollectionViewCell.h"
#import "WaterFLayout.h"
#import "SUtilityTool.h"
#import "LNGood.h"

@interface SSearchCollocationCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, WaterFLayoutDelegate>
{
    NSArray *_contentModelArray;
}

@property (nonatomic, weak) UIView *showNoneData;

@end

@implementation SSearchCollocationCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    WaterFLayout *flowLayout = [[WaterFLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_C4;
        self.alwaysBounceVertical = YES;
        [self registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:waterCellIdentifier];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in contentArray) {
        LNGood *model = [LNGood goodWithDict:dict];
        [array addObject:model];
    }
    _contentModelArray = array;
    [self reloadData];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, -200, self.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor whiteColor];
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_t5;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有找到相关的搭配，请重新搜索";
        [view addSubview:label];
        
        frame = CGRectMake(0, 160, self.frame.size.width, 40);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        nameLabel.backgroundColor = COLOR_C4;
        nameLabel.textColor = COLOR_C6;
        nameLabel.font = FONT_t4;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"热门搭配推荐";
        [view addSubview:nameLabel];
        
        frame = CGRectMake(10, 20, 100, 0.5);
        CALayer *leftLayer = [CALayer layer];
        leftLayer.backgroundColor = COLOR_C9.CGColor;
        leftLayer.frame = frame;
        leftLayer.zPosition = 5;
        [nameLabel.layer addSublayer:leftLayer];
        
        frame = CGRectMake(self.frame.size.width - 110, 20, 100, 0.5);
        CALayer *rightLayer = [CALayer layer];
        rightLayer.backgroundColor = COLOR_C9.CGColor;
        rightLayer.frame = frame;
        rightLayer.zPosition = 5;
        [nameLabel.layer addSublayer:rightLayer];
        
        [self addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

- (void)setIsHotData:(NSNumber *)isHotData{
    _isHotData = isHotData;
    if (isHotData.boolValue) {
        if (_showNoneData) {
            return;
        }else{
            UIEdgeInsets edgeInset = self.contentInset;
            edgeInset.top = 200;
            self.contentInset = edgeInset;
            self.contentOffset = CGPointMake(0, - 200);
            [self showNoneData];
        }
    }else{
        UIEdgeInsets edgeInset = self.contentInset;
        edgeInset.top = 0;
        self.contentInset = edgeInset;
        [_showNoneData removeFromSuperview];
    }
}

#pragma mark - 数据源方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
    LNGood *goodsModel = _contentModelArray[indexPath.row];
    size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
    if (goodsModel.content_info.length <= 0) size.height -= 20;
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _contentModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建可重用的cell
    SWaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:waterCellIdentifier forIndexPath:indexPath];
    cell.contentGoodsModel = _contentModelArray[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section{
    if ([self.collectionDelagate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
        return [self.collectionDelagate collectionView:collectionView layout:collectionViewLayout heightForHeaderInSection:section];
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionDelagate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.collectionDelagate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentModelArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.collectionDelagate respondsToSelector:@selector(listViewDidScroll:)]){
        [self.collectionDelagate listViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.collectionDelagate respondsToSelector:@selector(listViewWillBeginDraggingScroll:)]) {
        [self.collectionDelagate listViewWillBeginDraggingScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.collectionDelagate respondsToSelector:@selector(listViewDidEndDecelerating:)]) {
        [self.collectionDelagate listViewDidEndDecelerating:scrollView];
    }
}

@end
