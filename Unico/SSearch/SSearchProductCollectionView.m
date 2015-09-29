//
//  SSearchProductCollectionView.m
//  Wefafa
//
//  Created by unico_0 on 5/31/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "SSearchProductCollectionView.h"
#import "SSearchProductCollectionViewCell.h"
#import "SCollocationCollectionViewLayout.h"
#import "SSearchProductModel.h"
#import "SUtilityTool.h"

@interface SSearchProductCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentModelArray;
}
@property (nonatomic, weak) UIView *showNoneData;

@end

static NSString *cellIndetifier = @"SSearchProductCollectionViewCellIdentifier";
@implementation SSearchProductCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = COLOR_C4;
        self.alwaysBounceVertical = YES;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIndetifier];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    _contentModelArray = [SSearchProductModel modelArrayForDataArray:contentArray];
    [self reloadData];
}
-(void)setCategaryContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    _contentModelArray =[NSMutableArray arrayWithArray: [SSearchProductModel modelArrayForCategaryDataArray:contentArray]];
    [self reloadData];


}
//⬆️提刷新
-(void)loadNextContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    NSArray *array  = [SSearchProductModel modelArrayForCategaryDataArray:contentArray];
    [_contentModelArray addObjectsFromArray:array];
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
        label.text = @"抱歉，没有找到相关的单品，请重新搜索";
        [view addSubview:label];
        
        frame = CGRectMake(0, 160, self.frame.size.width, 40);
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:frame];
        nameLabel.backgroundColor = COLOR_C4;
        nameLabel.textColor = COLOR_C6;
        nameLabel.font = FONT_t4;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = @"热门单品推荐";
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
        edgeInset.top = 10;
        self.contentInset = edgeInset;
        [_showNoneData removeFromSuperview];
    }
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndetifier forIndexPath:indexPath];
    cell.isShowPrice = _isShowPrice;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.opration) {
        self.opration(indexPath, _contentModelArray);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_productDelegate && [_productDelegate respondsToSelector:@selector(listViewDidScroll:)]) {
        [_productDelegate listViewDidScroll:scrollView];
    }
}

@end

