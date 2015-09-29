//
//  MBMyGoodsContentCollectionView.h
//  Wefafa
//
//  Created by Jiang on 4/1/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBOtherUserInfoModel, MBMyGoodsContentCollectionView;
typedef enum : NSUInteger {
    collectionViewCell = 0,
    tableViewCell
} CellType;

typedef enum : NSUInteger {
    noneDefault = 0,
    noneGoods,
    noneCollocation,
    noneAttention,
    noneFans
} NoneDataShow;

@protocol MBMyGoodsContentCollectionViewDelegate <NSObject>
@optional
- (void)myGoodsCollectionDidScroll:(MBMyGoodsContentCollectionView *)collectionView;
- (void)myGoodsCollection:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)myGoodsTable:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)myGoodsTableCellAttentionButtonAction:(UIButton*)button model:(MBOtherUserInfoModel*)model;

@end

@interface MBMyGoodsContentCollectionView : UICollectionView

@property (assign, nonatomic) id<MBMyGoodsContentCollectionViewDelegate> goodsCollectionDelegate;
@property (assign, nonatomic) CellType cellType;
@property (assign, nonatomic) int subSelectedIndex;
@property (assign, nonatomic) CGFloat saveValue;
@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, assign) NoneDataShow noneDataShow;

@property (nonatomic ,assign) BOOL showPrice;// 活动页面单品 展示价格
@property (nonatomic ,assign) BOOL isPermissionReloadData; //是否允许刷新操作
@property (nonatomic ,assign) BOOL isPermissionAddData; //是否允许上提添加数据操作

@property (nonatomic ,assign) BOOL showHidenPic; //展示我的商品中隐藏与显示按钮
- (instancetype)initWithFrame:(CGRect)frame AndCellType:(CellType)cellType;
- (void)setContentModel:(NSMutableArray*)contentArray additionalHeight:(CGFloat)additionalHeight;
- (void)addContentModel:(NSMutableArray*)contentArray additionalHeight:(CGFloat)additionalHeight;
@end
