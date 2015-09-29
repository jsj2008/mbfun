//
//  ProductCollocationView.m
//  Wefafa
//
//  Created by Jiang on 15/8/31.
//  Copyright (c) 2015年 metersbonwe. All rights reserved.
//

#import "ProductCollocationView.h"
#import "WaterFLayout.h"
#import "SWaterCollectionViewCell.h"
#import "SUtilityTool.h"
#import "LNGood.h"

/**
 ReleaseButton
 */
@interface ReleaseButton : UIButton

@end
/**
 *	@简要 获取 SCollocationDetailViewController中的isLike
 */
extern NSString *isCollocationDetailLike;
@implementation ReleaseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        self.layer.cornerRadius = 3.f;
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:@"Unico/camera_switch_photo"] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width/3*2;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleW/2, 0, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    //    CGFloat imageW = contentRect.size.width/3;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(13, (imageH-15)/2, 15, 15);
}

@end


/**
 ProductCollocationView
 */
@interface ProductCollocationView ()
<UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    NSArray *_contentModelArray;
    LNGood *_model;
}
@property (nonatomic, weak) UIView *showNoneData;

@end

@implementation ProductCollocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    WaterFLayout *flowLayout = [[WaterFLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 10, 10);
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = COLOR_C4;
        self.alwaysBounceVertical = YES;
        [self registerNib:[UINib nibWithNibName:@"SWaterCollectionViewCell" bundle:nil]
forCellWithReuseIdentifier:waterCellIdentifier];
    }
    return self;
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
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIView *view = [[UIView alloc]initWithFrame:frame];
        view.backgroundColor = COLOR_C4;
        
        CGRect imgRect = CGRectMake((UI_SCREEN_WIDTH-67)/2, 160, 67, 50.f); // 67 50
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:imgRect];
        imgV.image = [UIImage imageNamed:@"Unico/ico_nocollocation"];
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imgV];
        
        CGFloat lbY = CGRectGetMaxY(imgV.frame)+25;
        CGRect lbRect = CGRectMake(0, lbY, UI_SCREEN_WIDTH, 10);
        UILabel *lb = [[UILabel alloc] initWithFrame:lbRect];
        lb.text = @"暂无相关搭配";
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = COLOR_C6;
        lb.font = FONT_t6;
        [view addSubview:lb];
        
        CGFloat bgViewY = CGRectGetMaxY(lb.frame)+15;
        CGRect bgViewRect = CGRectMake((UI_SCREEN_WIDTH-100)/2, bgViewY, 100, 30);
        ReleaseButton *releaseBtn = [[ReleaseButton alloc] initWithFrame:bgViewRect];
        releaseBtn.backgroundColor = [UIColor blackColor];
        [releaseBtn setTitle:@"发布搭配" forState:UIControlStateNormal];
        [releaseBtn addTarget:self action:@selector(releaseCollocationClicked)
             forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:releaseBtn];
        
        CGFloat btnX = (UI_SCREEN_WIDTH-100)/2;
        CGRect btnRect = CGRectMake(btnX, self.frame.size.height - 44 - 25- 10, 100, 10); // 44 为contentInset的顶部值
        UIButton *btn = [[UIButton alloc] initWithFrame:btnRect];
        btn.backgroundColor = [UIColor clearColor];
        btn.opaque = NO;
        btn.titleLabel.font = FONT_t5;
        [btn setTitleColor:COLOR_C6 forState:UIControlStateNormal];
        [btn setTitle:@"查看相似搭配>>" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lookForClicked)
      forControlEvents:UIControlEventTouchUpInside];
        //        [view addSubview:btn];
        
        [self addSubview:view];
        _showNoneData = view;
    }
    return _showNoneData;
}

#pragma mark - tap gesture
- (void)releaseCollocationClicked
{
    // 发布搭配
    if (self.releaseColl) {
        self.releaseColl();
    }
}

- (void)lookForClicked
{
    // 查看相似搭配
    if(self.lookFor) {
        self.lookFor();
    }
}

-(void)loadNextContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    //    NSArray *array  = [SSearchProductModel modelArrayForCategaryDataArray:contentArray];
    //    [_contentModelArray addObjectsFromArray:array];
    [self reloadData];
}

#pragma mark 监听刷新 是否喜欢相关搭配
-(void)loadLikeData{
    if (![isCollocationDetailLike isEqual:@""]) {
        if ([isCollocationDetailLike isEqualToString:@"1"]) {
            _model.is_love = [NSString stringWithFormat:@"%@",isCollocationDetailLike];
            _model.like_count = [NSString stringWithFormat:@"%d",[_model.like_count intValue]+1];
        }else{
            _model.is_love = [NSString stringWithFormat:@"%@",isCollocationDetailLike];
            if ([_model.like_count intValue]>0) {
                _model.like_count = [NSString stringWithFormat:@"%d",[_model.like_count intValue]-1];
            }
        }
    }
    [self reloadData];
}

#pragma mark - 数据源方法

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
     CGSize size = CGSizeMake((UI_SCREEN_WIDTH - 30)/ 2, 0);
     LNGood *goodsModel = _contentModelArray[indexPath.row];
     size.height = goodsModel.h * (size.width /goodsModel.w) + 60;
     if (goodsModel.content_info.length <= 0) size.height -= 20;*/
    CGSize size = CGSizeMake(UI_SCREEN_WIDTH/ 2 - 10, 300);
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _model = _contentModelArray[indexPath.row];
    if (_collocationDelegate && [_collocationDelegate respondsToSelector:@selector(productCollocationViewCellDidSelectedWithProductCode:)]) {
        [_collocationDelegate productCollocationViewCellDidSelectedWithProductCode:_model.product_ID];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_collocationDelegate && [_collocationDelegate respondsToSelector:@selector(ProductCollocationViewViewDidScroll:)]) {
        [_collocationDelegate ProductCollocationViewViewDidScroll:scrollView];
    }
}

@end
