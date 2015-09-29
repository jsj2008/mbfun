//
//  ProductSimilarityView.m
//  Wefafa
//
//  Created by Jiang on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ProductSimilarityView.h"
#import "SUtilityTool.h"
#import "UIScrollView+MJRefresh.h"

#import "SSearchProductModel.h"
#import "SProductDetailViewController.h"
#import "SSearchProductCollectionViewCell.h"

#import "AppDelegate.h"

@interface ProductSimilarityView ()
    <UICollectionViewDataSource, UICollectionViewDelegate,
        UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_contentModelArray;
}
@property (nonatomic, weak) UIView *showNoneData;
@end

static NSString *cellIndetifier = @"SSearchProductCollectionViewCellIdentifier";
@implementation ProductSimilarityView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = COLOR_C4;
        self.delegate = self;
        self.dataSource = self;
        self.alwaysBounceVertical = YES;
        [self registerNib:[UINib nibWithNibName:@"SSearchProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIndetifier];
//        [self addFooterWithTarget:self action:@selector(requestAddData)];

    }
    return self;
}

- (void)requestAddData
{
    // 
}


- (void)setContentArray:(NSArray *)contentArray{

    if (contentArray.count<=0) {
        [self showNoneData];
        return ;
    } else {
        [_showNoneData removeFromSuperview];
        _showNoneData = nil;
        _contentArray = contentArray;
    }

    
//    _contentArray = contentArray;
    _contentModelArray = [NSMutableArray arrayWithArray:[SSearchProductModel modelArrayForDataArray:contentArray]];
    [self reloadData];
}

-(void)setCategaryContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    _contentModelArray =[NSMutableArray arrayWithArray: [SSearchProductModel modelArrayForCategaryDataArray:contentArray]];
    [self reloadData];
}

-(void)loadNextContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    NSArray *array  = [SSearchProductModel modelArrayForCategaryDataArray:contentArray];
    [_contentModelArray addObjectsFromArray:array];
    [self reloadData];
}

- (UIView *)showNoneData{
    if (!_showNoneData) {
        CGRect frame = CGRectMake(0, 100, self.frame.size.width, 200);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = NO;
        frame.origin.y = 0;
        frame.size.height = 160;
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.textColor = COLOR_C6;
        label.font = FONT_T3;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有相关的单品";
        [view addSubview:label];
        
        [self addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

#pragma mark -
#pragma mark - collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentModelArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(UI_SCREEN_WIDTH/ 2 - 15, 300);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndetifier forIndexPath:indexPath];
    cell.isShowPrice = YES;
    cell.contentModel = _contentModelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SSearchProductModel *model = _contentModelArray[indexPath.row];
    if (_similarityDelegate && [_similarityDelegate respondsToSelector:@selector(productSimilartyViewCellDidSelectedWithProductCode:)]) {
        [_similarityDelegate productSimilartyViewCellDidSelectedWithProductCode:[NSString stringWithFormat:@"%@",model.code]];
    }
    
    return ;
//    SSearchProductModel *model = _contentModelArray[indexPath.row];
    SProductDetailViewController *controller = [[SProductDetailViewController alloc]init];
    controller.productID = [NSString stringWithFormat:@"%@",model.code];
    [_target.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (_similarityDelegate && [_similarityDelegate respondsToSelector:@selector(productSimilartyViewViewDidScroll:)]) {
        [_similarityDelegate productSimilartyViewViewDidScroll:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_similarityDelegate && [_similarityDelegate respondsToSelector:@selector(productSimilartyViewViewWillBeginDraggingScroll:)]) {
        [_similarityDelegate productSimilartyViewViewWillBeginDraggingScroll:scrollView];
    }
}
@end
