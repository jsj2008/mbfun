//
//  GoodsColorSelectConllectionView.h
//  PopView
//
//  Created by Jiang on 15/8/28.
//  Copyright (c) 2015年 Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class GoodsColorCollectionCell;
#import "GoodsColorCollectionCell.h"

@protocol GoodsColorSelectConllectionViewDelegate <NSObject>

- (void)didClickedGoodsColorCollectionViewWithCell:(GoodsColorCollectionCell *)cell index:(NSInteger)index;

@end

@interface GoodsColorSelectConllectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *colorArrM;
@property (nonatomic, assign) CGFloat colorViewH;
@property (nonatomic, weak) id<GoodsColorSelectConllectionViewDelegate> clickedDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSMutableArray *tempArrM;

@property (nonatomic, strong) NSMutableArray *containsArrM;    // 用数组记录cell灰色的index

@end
