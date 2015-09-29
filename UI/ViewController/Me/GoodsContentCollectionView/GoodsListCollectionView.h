//
//  GoodsListCollectionView.h
//  Wefafa
//
//  Created by Jiang on 3/20/15.
//  Copyright (c) 2015 fafatime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListCollectionViewCell.h"

@class GoodsListCollectionView;

@protocol GoodsListCollectionDelegate <NSObject>

- (void)tvColl_OnDidSelected:(GoodsListCollectionView*)sender RowMessage:(id)message;
- (void)goodsListScrollView:(UIScrollView*)scrollView;

@end

@interface GoodsListCollectionView : UICollectionView

@property (assign, nonatomic) id<GoodsListCollectionDelegate> goodsDelegate;
@property (assign, nonatomic) GoodsCellType cellType;

@property (nonatomic, strong) NSMutableArray *contentModelArray;
@property (nonatomic, assign) BOOL showName;//判断是或否展示名字


- (instancetype)initWithFrame:(CGRect)frame AndModelArray:(NSArray*)modelArray AndCellType:(GoodsCellType)cellType;
- (void)loadNextPage:(NSArray*)nextArray;
- (void)refreshView:(NSArray*)refreshArray;

@end
