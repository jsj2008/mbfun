//
//  MBMyGoodsContentCollectionView.m
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import "MBMyGoodsContentCollectionView.h"
#import "MBMyGoodsContentCollectionViewCell.h"
#import "MBMyGoodsContentTableViewCell.h"
#import "MJRefresh.h"
#import "Utils.h"

@interface MBMyGoodsContentCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MBOtherUserInfoModelDelegate>

@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, weak) UIView *showNoneDataView;

@end

static NSString *collectionCellIdentifier = @"MBMyGoodsContentCollectionViewCellIdentifier";
static NSString *tableCellIdentifier = @"MBMyGoodsContentTableViewCellIdentifier";

static NSString *footerViewIndetifier = @"MBMyGoodsContentFooterViewIdentifier";
@implementation MBMyGoodsContentCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cellType = collectionViewCell;
        self.alwaysBounceVertical = YES;
    }
    return self;
}
 //cellType cell类型
- (instancetype)initWithFrame:(CGRect)frame AndCellType:(CellType)cellType{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.cellType = cellType;
    }
    return self;
}

- (void)setContentModelArray:(NSMutableArray *)contentModelArray{
    _contentModelArray = contentModelArray;
    [self showNoneData];
    [self reloadData];
}

- (void)setCellType:(CellType)cellType{
    _cellType = cellType;
    self.isPermissionReloadData = YES;
    self.isPermissionAddData = YES;
    switch (cellType) {
        case collectionViewCell:
        {
            [self registerNib:[UINib nibWithNibName:@"MBMyGoodsContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionCellIdentifier];
             self.itemSize = CGSizeMake(UI_SCREEN_WIDTH/2, 215);
        }
            break;
        case tableViewCell:
        {
            [self registerNib:[UINib nibWithNibName:@"MBMyGoodsContentTableViewCell" bundle:nil] forCellWithReuseIdentifier:tableCellIdentifier];
            self.itemSize = CGSizeMake(UI_SCREEN_WIDTH, 55);
        }
            break;
        default:
            break;
    }
    self.delegate = self;
    self.dataSource = self;
    
}

- (void)setContentModel:(NSMutableArray*)contentArray additionalHeight:(CGFloat)additionalHeight{
    if (contentArray.count > 0) {
        _contentModelArray = contentArray;
    }
    
    [self additionalHeight:additionalHeight];
}

- (void)addContentModel:(NSMutableArray*)contentArray additionalHeight:(CGFloat)additionalHeight{
    if (contentArray.count > 0) {
        [_contentModelArray addObjectsFromArray:contentArray];
    }
    
    [self additionalHeight:additionalHeight];
}

- (void)additionalHeight:(CGFloat)additionalHeight{
    [self showNoneData];
    NSInteger i = 0;
    if (self.cellType == tableViewCell) {
        i = _contentModelArray.count;
    }else if(self.cellType == collectionViewCell){
        i = (_contentModelArray.count + 1)/ 2;
    }
    CGFloat contentHeight = i * self.itemSize.height;
    CGFloat footerViewHeight = additionalHeight - contentHeight;
    UIEdgeInsets edge = self.contentInset;
    CGPoint offset = self.contentOffset;
    edge.bottom = UI_SCREEN_HEIGHT;
    self.contentInset = edge;
    [self reloadData];
    if (footerViewHeight > 0) {
        edge.bottom = footerViewHeight;
    }else{
        edge.bottom = 0;
    }
    self.contentInset = edge;
    self.contentOffset = offset;
}

- (void)showNoneData{
    
    [self.showNoneDataView removeFromSuperview];
    if (_contentModelArray.count == 0 || !_contentModelArray) {
        NSString *imageName = nil;
        NSString *titleString = nil;
        switch (self.noneDataShow) {
            case noneDefault:
                imageName = @"medium_loading@3x.png";
                titleString = @"";
                break;
            case noneGoods:
                imageName = @"btn-clothes@2x.png";
                titleString = @"暂无单品";
                break;
            case noneCollocation:
                imageName = @"btn-hanger@2x.png";
                titleString = @"暂无搭配";
                break;
            case noneAttention:
                imageName = @"btn-man@2x.png";
                titleString = @"没有关注的造型师";
                break;
            case noneFans:
                imageName = @"btn-man@2x.png";
                titleString = @"没有粉丝";
                break;
            default:
                break;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 70, 150, 250)];
        view.centerX = self.bounds.size.width/ 2;
        [self addSubview:view];
        _showNoneDataView = view;
        
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 50, 50);
        imageView.centerX = view.bounds.size.width/ 2;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_showNoneDataView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 150, 25)];
        label.text = titleString;
        label.centerX = view.bounds.size.width/ 2;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [Utils HexColor:0x919191 Alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [_showNoneDataView addSubview:label];
        
    }
}

#pragma mark delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentModelArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.cellType) {
        case collectionViewCell:
        {
            MBMyGoodsContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellIdentifier forIndexPath:indexPath];
            cell.backgroundColor=[UIColor whiteColor];
            MBMyGoodsPersonalModel *model = self.contentModelArray[indexPath.row];
            cell.model = model;
            cell.showPrice = self.showPrice;
            return cell;
        }
            break;
        case tableViewCell:
        {
            MBMyGoodsContentTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tableCellIdentifier forIndexPath:indexPath];
            cell.delegate = self;
            cell.backgroundColor = [UIColor whiteColor];
            MBOtherUserInfoModel *model = self.contentModelArray[indexPath.row];
            cell.model = model;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellType == collectionViewCell) {
        if ([self.goodsCollectionDelegate respondsToSelector:@selector(myGoodsCollection:didSelectItemAtIndexPath:)]) {
            [self.goodsCollectionDelegate myGoodsCollection:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }else if (self.cellType == tableViewCell){
        if ([self.goodsCollectionDelegate respondsToSelector:@selector(myGoodsTable:didSelectItemAtIndexPath:)]) {
            [self.goodsCollectionDelegate myGoodsTable:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
    
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.goodsCollectionDelegate respondsToSelector:@selector(myGoodsCollectionDidScroll:)]) {
        [self.goodsCollectionDelegate myGoodsCollectionDidScroll:self];
    }
}

#pragma cell delegate
- (void)attentionButtonAction:(UIButton *)button model:(MBOtherUserInfoModel *)model{
    if ([self.goodsCollectionDelegate respondsToSelector:@selector(myGoodsTableCellAttentionButtonAction:model:)]) {
        [self.goodsCollectionDelegate myGoodsTableCellAttentionButtonAction:button model:model];
    }
}

@end
